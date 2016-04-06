
obj/user/init.debug:     file format elf64-x86-64


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
  80003c:	e8 51 06 00 00       	callq  800692 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 1c          	sub    $0x1c,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int i, tot = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (i = 0; i < n; i++)
  800059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800060:	eb 1e                	jmp    800080 <sum+0x3d>
		tot ^= i * s[i];
  800062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800065:	48 63 d0             	movslq %eax,%rdx
  800068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80006c:	48 01 d0             	add    %rdx,%rax
  80006f:	0f b6 00             	movzbl (%rax),%eax
  800072:	0f be c0             	movsbl %al,%eax
  800075:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  800079:	31 45 f8             	xor    %eax,-0x8(%rbp)

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800083:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  800086:	7c da                	jl     800062 <sum+0x1f>
		tot ^= i * s[i];
	return tot;
  800088:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80008b:	c9                   	leaveq 
  80008c:	c3                   	retq   

000000000080008d <umain>:

void
umain(int argc, char **argv)
{
  80008d:	55                   	push   %rbp
  80008e:	48 89 e5             	mov    %rsp,%rbp
  800091:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800098:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80009e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  8000a5:	48 bf 00 45 80 00 00 	movabs $0x804500,%rdi
  8000ac:	00 00 00 
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  8000bb:	00 00 00 
  8000be:	ff d2                	callq  *%rdx

	want = 0xf989e;
  8000c0:	c7 45 f8 9e 98 0f 00 	movl   $0xf989e,-0x8(%rbp)
	if ((x = sum((char*)&data, sizeof data)) != want)
  8000c7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000cc:	48 bf 00 60 80 00 00 	movabs $0x806000,%rdi
  8000d3:	00 00 00 
  8000d6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	callq  *%rax
  8000e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000eb:	74 25                	je     800112 <umain+0x85>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8000f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf 10 45 80 00 00 	movabs $0x804510,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx
  800110:	eb 1b                	jmp    80012d <umain+0xa0>
			x, want);
	else
		cprintf("init: data seems okay\n");
  800112:	48 bf 49 45 80 00 00 	movabs $0x804549,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  800128:	00 00 00 
  80012b:	ff d2                	callq  *%rdx
	if ((x = sum(bss, sizeof bss)) != 0)
  80012d:	be 70 17 00 00       	mov    $0x1770,%esi
  800132:	48 bf 20 80 80 00 00 	movabs $0x808020,%rdi
  800139:	00 00 00 
  80013c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800143:	00 00 00 
  800146:	ff d0                	callq  *%rax
  800148:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80014b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80014f:	74 22                	je     800173 <umain+0xe6>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  800151:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800154:	89 c6                	mov    %eax,%esi
  800156:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
  800171:	eb 1b                	jmp    80018e <umain+0x101>
	else
		cprintf("init: bss seems okay\n");
  800173:	48 bf 8f 45 80 00 00 	movabs $0x80458f,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  800189:	00 00 00 
  80018c:	ff d2                	callq  *%rdx

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  80018e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800195:	48 be a5 45 80 00 00 	movabs $0x8045a5,%rsi
  80019c:	00 00 00 
  80019f:	48 89 c7             	mov    %rax,%rdi
  8001a2:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
	for (i = 0; i < argc; i++) {
  8001ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001b5:	eb 77                	jmp    80022e <umain+0x1a1>
		strcat(args, " '");
  8001b7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001be:	48 be b1 45 80 00 00 	movabs $0x8045b1,%rsi
  8001c5:	00 00 00 
  8001c8:	48 89 c7             	mov    %rax,%rdi
  8001cb:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	callq  *%rax
		strcat(args, argv[i]);
  8001d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001da:	48 98                	cltq   
  8001dc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001e3:	00 
  8001e4:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 d6             	mov    %rdx,%rsi
  8001fb:	48 89 c7             	mov    %rax,%rdi
  8001fe:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  800205:	00 00 00 
  800208:	ff d0                	callq  *%rax
		strcat(args, "'");
  80020a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800211:	48 be b4 45 80 00 00 	movabs $0x8045b4,%rsi
  800218:	00 00 00 
  80021b:	48 89 c7             	mov    %rax,%rdi
  80021e:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80022a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800231:	3b 85 ec fe ff ff    	cmp    -0x114(%rbp),%eax
  800237:	0f 8c 7a ff ff ff    	jl     8001b7 <umain+0x12a>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  80023d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 bf b6 45 80 00 00 	movabs $0x8045b6,%rdi
  80024e:	00 00 00 
  800251:	b8 00 00 00 00       	mov    $0x0,%eax
  800256:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  80025d:	00 00 00 
  800260:	ff d2                	callq  *%rdx

	cprintf("init: running sh\n");
  800262:	48 bf ba 45 80 00 00 	movabs $0x8045ba,%rdi
  800269:	00 00 00 
  80026c:	b8 00 00 00 00       	mov    $0x0,%eax
  800271:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  800278:	00 00 00 
  80027b:	ff d2                	callq  *%rdx

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80027d:	bf 00 00 00 00       	mov    $0x0,%edi
  800282:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  80028e:	48 b8 a0 04 80 00 00 	movabs $0x8004a0,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002a1:	79 30                	jns    8002d3 <umain+0x246>
		panic("opencons: %e", r);
  8002a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	48 ba cc 45 80 00 00 	movabs $0x8045cc,%rdx
  8002af:	00 00 00 
  8002b2:	be 37 00 00 00       	mov    $0x37,%esi
  8002b7:	48 bf d9 45 80 00 00 	movabs $0x8045d9,%rdi
  8002be:	00 00 00 
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c6:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  8002cd:	00 00 00 
  8002d0:	41 ff d0             	callq  *%r8
	if (r != 0)
  8002d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8002d7:	74 30                	je     800309 <umain+0x27c>
		panic("first opencons used fd %d", r);
  8002d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002dc:	89 c1                	mov    %eax,%ecx
  8002de:	48 ba e5 45 80 00 00 	movabs $0x8045e5,%rdx
  8002e5:	00 00 00 
  8002e8:	be 39 00 00 00       	mov    $0x39,%esi
  8002ed:	48 bf d9 45 80 00 00 	movabs $0x8045d9,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  800303:	00 00 00 
  800306:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800309:	be 01 00 00 00       	mov    $0x1,%esi
  80030e:	bf 00 00 00 00       	mov    $0x0,%edi
  800313:	48 b8 31 26 80 00 00 	movabs $0x802631,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800322:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800326:	79 30                	jns    800358 <umain+0x2cb>
		panic("dup: %e", r);
  800328:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba ff 45 80 00 00 	movabs $0x8045ff,%rdx
  800334:	00 00 00 
  800337:	be 3b 00 00 00       	mov    $0x3b,%esi
  80033c:	48 bf d9 45 80 00 00 	movabs $0x8045d9,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8
	while (1) {
		cprintf("init: starting sh\n");
  800358:	48 bf 07 46 80 00 00 	movabs $0x804607,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
		r = spawnl("/bin/sh", "sh", (char*)0);
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	48 be 1a 46 80 00 00 	movabs $0x80461a,%rsi
  80037f:	00 00 00 
  800382:	48 bf 1d 46 80 00 00 	movabs $0x80461d,%rdi
  800389:	00 00 00 
  80038c:	b8 00 00 00 00       	mov    $0x0,%eax
  800391:	48 b9 9d 33 80 00 00 	movabs $0x80339d,%rcx
  800398:	00 00 00 
  80039b:	ff d1                	callq  *%rcx
  80039d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (r < 0) {
  8003a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8003a4:	79 23                	jns    8003c9 <umain+0x33c>
			cprintf("init: spawn sh: %e\n", r);
  8003a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003a9:	89 c6                	mov    %eax,%esi
  8003ab:	48 bf 25 46 80 00 00 	movabs $0x804625,%rdi
  8003b2:	00 00 00 
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  8003c1:	00 00 00 
  8003c4:	ff d2                	callq  *%rdx
			continue;
  8003c6:	90                   	nop
		}
		wait(r);
	}
  8003c7:	eb 8f                	jmp    800358 <umain+0x2cb>
		r = spawnl("/bin/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
			continue;
		}
		wait(r);
  8003c9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8003cc:	89 c7                	mov    %eax,%edi
  8003ce:	48 b8 f7 41 80 00 00 	movabs $0x8041f7,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	callq  *%rax
	}
  8003da:	e9 79 ff ff ff       	jmpq   800358 <umain+0x2cb>

00000000008003df <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8003df:	55                   	push   %rbp
  8003e0:	48 89 e5             	mov    %rsp,%rbp
  8003e3:	48 83 ec 20          	sub    $0x20,%rsp
  8003e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8003ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003ed:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8003f0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8003f4:	be 01 00 00 00       	mov    $0x1,%esi
  8003f9:	48 89 c7             	mov    %rax,%rdi
  8003fc:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  800403:	00 00 00 
  800406:	ff d0                	callq  *%rax
}
  800408:	c9                   	leaveq 
  800409:	c3                   	retq   

000000000080040a <getchar>:

int
getchar(void)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800412:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800416:	ba 01 00 00 00       	mov    $0x1,%edx
  80041b:	48 89 c6             	mov    %rax,%rsi
  80041e:	bf 00 00 00 00       	mov    $0x0,%edi
  800423:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800432:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800436:	79 05                	jns    80043d <getchar+0x33>
		return r;
  800438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043b:	eb 14                	jmp    800451 <getchar+0x47>
	if (r < 1)
  80043d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800441:	7f 07                	jg     80044a <getchar+0x40>
		return -E_EOF;
  800443:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800448:	eb 07                	jmp    800451 <getchar+0x47>
	return c;
  80044a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80044e:	0f b6 c0             	movzbl %al,%eax
}
  800451:	c9                   	leaveq 
  800452:	c3                   	retq   

0000000000800453 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800453:	55                   	push   %rbp
  800454:	48 89 e5             	mov    %rsp,%rbp
  800457:	48 83 ec 20          	sub    $0x20,%rsp
  80045b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80045e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800462:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800465:	48 89 d6             	mov    %rdx,%rsi
  800468:	89 c7                	mov    %eax,%edi
  80046a:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  800471:	00 00 00 
  800474:	ff d0                	callq  *%rax
  800476:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800479:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80047d:	79 05                	jns    800484 <iscons+0x31>
		return r;
  80047f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800482:	eb 1a                	jmp    80049e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800488:	8b 10                	mov    (%rax),%edx
  80048a:	48 b8 80 77 80 00 00 	movabs $0x807780,%rax
  800491:	00 00 00 
  800494:	8b 00                	mov    (%rax),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	0f 94 c0             	sete   %al
  80049b:	0f b6 c0             	movzbl %al,%eax
}
  80049e:	c9                   	leaveq 
  80049f:	c3                   	retq   

00000000008004a0 <opencons>:

int
opencons(void)
{
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004a8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8004ac:	48 89 c7             	mov    %rax,%rdi
  8004af:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	callq  *%rax
  8004bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004c2:	79 05                	jns    8004c9 <opencons+0x29>
		return r;
  8004c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004c7:	eb 5b                	jmp    800524 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8004d2:	48 89 c6             	mov    %rax,%rsi
  8004d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8004da:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax
  8004e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ed:	79 05                	jns    8004f4 <opencons+0x54>
		return r;
  8004ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f2:	eb 30                	jmp    800524 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8004f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f8:	48 ba 80 77 80 00 00 	movabs $0x807780,%rdx
  8004ff:	00 00 00 
  800502:	8b 12                	mov    (%rdx),%edx
  800504:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80050a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800515:	48 89 c7             	mov    %rax,%rdi
  800518:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  80051f:	00 00 00 
  800522:	ff d0                	callq  *%rax
}
  800524:	c9                   	leaveq 
  800525:	c3                   	retq   

0000000000800526 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800526:	55                   	push   %rbp
  800527:	48 89 e5             	mov    %rsp,%rbp
  80052a:	48 83 ec 30          	sub    $0x30,%rsp
  80052e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800532:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800536:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80053a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80053f:	75 07                	jne    800548 <devcons_read+0x22>
		return 0;
  800541:	b8 00 00 00 00       	mov    $0x0,%eax
  800546:	eb 4b                	jmp    800593 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800548:	eb 0c                	jmp    800556 <devcons_read+0x30>
		sys_yield();
  80054a:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800556:	48 b8 57 1f 80 00 00 	movabs $0x801f57,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
  800562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800569:	74 df                	je     80054a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80056b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056f:	79 05                	jns    800576 <devcons_read+0x50>
		return c;
  800571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800574:	eb 1d                	jmp    800593 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  800576:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80057a:	75 07                	jne    800583 <devcons_read+0x5d>
		return 0;
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	eb 10                	jmp    800593 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800586:	89 c2                	mov    %eax,%edx
  800588:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80058c:	88 10                	mov    %dl,(%rax)
	return 1;
  80058e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8005a0:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8005a7:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8005ae:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8005b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005bc:	eb 76                	jmp    800634 <devcons_write+0x9f>
		m = n - tot;
  8005be:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ca:	29 c2                	sub    %eax,%edx
  8005cc:	89 d0                	mov    %edx,%eax
  8005ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8005d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005d4:	83 f8 7f             	cmp    $0x7f,%eax
  8005d7:	76 07                	jbe    8005e0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8005d9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8005e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005e3:	48 63 d0             	movslq %eax,%rdx
  8005e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e9:	48 63 c8             	movslq %eax,%rcx
  8005ec:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8005f3:	48 01 c1             	add    %rax,%rcx
  8005f6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8005fd:	48 89 ce             	mov    %rcx,%rsi
  800600:	48 89 c7             	mov    %rax,%rdi
  800603:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80060f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800612:	48 63 d0             	movslq %eax,%rdx
  800615:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80061c:	48 89 d6             	mov    %rdx,%rsi
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  800629:	00 00 00 
  80062c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80062e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800631:	01 45 fc             	add    %eax,-0x4(%rbp)
  800634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800637:	48 98                	cltq   
  800639:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800640:	0f 82 78 ff ff ff    	jb     8005be <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  800646:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800649:	c9                   	leaveq 
  80064a:	c3                   	retq   

000000000080064b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80064b:	55                   	push   %rbp
  80064c:	48 89 e5             	mov    %rsp,%rbp
  80064f:	48 83 ec 08          	sub    $0x8,%rsp
  800653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80065c:	c9                   	leaveq 
  80065d:	c3                   	retq   

000000000080065e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80065e:	55                   	push   %rbp
  80065f:	48 89 e5             	mov    %rsp,%rbp
  800662:	48 83 ec 10          	sub    $0x10,%rsp
  800666:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80066a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	48 be 3e 46 80 00 00 	movabs $0x80463e,%rsi
  800679:	00 00 00 
  80067c:	48 89 c7             	mov    %rax,%rdi
  80067f:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  800686:	00 00 00 
  800689:	ff d0                	callq  *%rax
	return 0;
  80068b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800690:	c9                   	leaveq 
  800691:	c3                   	retq   

0000000000800692 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800692:	55                   	push   %rbp
  800693:	48 89 e5             	mov    %rsp,%rbp
  800696:	48 83 ec 10          	sub    $0x10,%rsp
  80069a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80069d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8006a1:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8006a8:	00 00 00 
  8006ab:	ff d0                	callq  *%rax
  8006ad:	48 98                	cltq   
  8006af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006b4:	48 89 c2             	mov    %rax,%rdx
  8006b7:	48 89 d0             	mov    %rdx,%rax
  8006ba:	48 c1 e0 03          	shl    $0x3,%rax
  8006be:	48 01 d0             	add    %rdx,%rax
  8006c1:	48 c1 e0 05          	shl    $0x5,%rax
  8006c5:	48 89 c2             	mov    %rax,%rdx
  8006c8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8006cf:	00 00 00 
  8006d2:	48 01 c2             	add    %rax,%rdx
  8006d5:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  8006dc:	00 00 00 
  8006df:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006e6:	7e 14                	jle    8006fc <libmain+0x6a>
		binaryname = argv[0];
  8006e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ec:	48 8b 10             	mov    (%rax),%rdx
  8006ef:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8006f6:	00 00 00 
  8006f9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8006fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800703:	48 89 d6             	mov    %rdx,%rsi
  800706:	89 c7                	mov    %eax,%edi
  800708:	48 b8 8d 00 80 00 00 	movabs $0x80008d,%rax
  80070f:	00 00 00 
  800712:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800714:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
}
  800720:	c9                   	leaveq 
  800721:	c3                   	retq   

0000000000800722 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800726:	48 b8 03 26 80 00 00 	movabs $0x802603,%rax
  80072d:	00 00 00 
  800730:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800732:	bf 00 00 00 00       	mov    $0x0,%edi
  800737:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  80073e:	00 00 00 
  800741:	ff d0                	callq  *%rax
}
  800743:	5d                   	pop    %rbp
  800744:	c3                   	retq   

0000000000800745 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800745:	55                   	push   %rbp
  800746:	48 89 e5             	mov    %rsp,%rbp
  800749:	53                   	push   %rbx
  80074a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800751:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800758:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80075e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800765:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80076c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800773:	84 c0                	test   %al,%al
  800775:	74 23                	je     80079a <_panic+0x55>
  800777:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80077e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800782:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800786:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80078a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80078e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800792:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800796:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80079a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8007a1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8007a8:	00 00 00 
  8007ab:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8007b2:	00 00 00 
  8007b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b9:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8007c0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8007c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007ce:	48 b8 b8 77 80 00 00 	movabs $0x8077b8,%rax
  8007d5:	00 00 00 
  8007d8:	48 8b 18             	mov    (%rax),%rbx
  8007db:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	callq  *%rax
  8007e7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8007ed:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8007f4:	41 89 c8             	mov    %ecx,%r8d
  8007f7:	48 89 d1             	mov    %rdx,%rcx
  8007fa:	48 89 da             	mov    %rbx,%rdx
  8007fd:	89 c6                	mov    %eax,%esi
  8007ff:	48 bf 50 46 80 00 00 	movabs $0x804650,%rdi
  800806:	00 00 00 
  800809:	b8 00 00 00 00       	mov    $0x0,%eax
  80080e:	49 b9 7e 09 80 00 00 	movabs $0x80097e,%r9
  800815:	00 00 00 
  800818:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80081b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800822:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800829:	48 89 d6             	mov    %rdx,%rsi
  80082c:	48 89 c7             	mov    %rax,%rdi
  80082f:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  800836:	00 00 00 
  800839:	ff d0                	callq  *%rax
	cprintf("\n");
  80083b:	48 bf 73 46 80 00 00 	movabs $0x804673,%rdi
  800842:	00 00 00 
  800845:	b8 00 00 00 00       	mov    $0x0,%eax
  80084a:	48 ba 7e 09 80 00 00 	movabs $0x80097e,%rdx
  800851:	00 00 00 
  800854:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800856:	cc                   	int3   
  800857:	eb fd                	jmp    800856 <_panic+0x111>

0000000000800859 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800859:	55                   	push   %rbp
  80085a:	48 89 e5             	mov    %rsp,%rbp
  80085d:	48 83 ec 10          	sub    $0x10,%rsp
  800861:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800864:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80086c:	8b 00                	mov    (%rax),%eax
  80086e:	8d 48 01             	lea    0x1(%rax),%ecx
  800871:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800875:	89 0a                	mov    %ecx,(%rdx)
  800877:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80087a:	89 d1                	mov    %edx,%ecx
  80087c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800880:	48 98                	cltq   
  800882:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80088a:	8b 00                	mov    (%rax),%eax
  80088c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800891:	75 2c                	jne    8008bf <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800897:	8b 00                	mov    (%rax),%eax
  800899:	48 98                	cltq   
  80089b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80089f:	48 83 c2 08          	add    $0x8,%rdx
  8008a3:	48 89 c6             	mov    %rax,%rsi
  8008a6:	48 89 d7             	mov    %rdx,%rdi
  8008a9:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  8008b0:	00 00 00 
  8008b3:	ff d0                	callq  *%rax
		b->idx = 0;
  8008b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8008bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c3:	8b 40 04             	mov    0x4(%rax),%eax
  8008c6:	8d 50 01             	lea    0x1(%rax),%edx
  8008c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008cd:	89 50 04             	mov    %edx,0x4(%rax)
}
  8008d0:	c9                   	leaveq 
  8008d1:	c3                   	retq   

00000000008008d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008d2:	55                   	push   %rbp
  8008d3:	48 89 e5             	mov    %rsp,%rbp
  8008d6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8008dd:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8008e4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8008eb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8008f2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8008f9:	48 8b 0a             	mov    (%rdx),%rcx
  8008fc:	48 89 08             	mov    %rcx,(%rax)
  8008ff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800903:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800907:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80090b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80090f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800916:	00 00 00 
	b.cnt = 0;
  800919:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800920:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800923:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80092a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800931:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800938:	48 89 c6             	mov    %rax,%rsi
  80093b:	48 bf 59 08 80 00 00 	movabs $0x800859,%rdi
  800942:	00 00 00 
  800945:	48 b8 31 0d 80 00 00 	movabs $0x800d31,%rax
  80094c:	00 00 00 
  80094f:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800951:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800957:	48 98                	cltq   
  800959:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800960:	48 83 c2 08          	add    $0x8,%rdx
  800964:	48 89 c6             	mov    %rax,%rsi
  800967:	48 89 d7             	mov    %rdx,%rdi
  80096a:	48 b8 0d 1f 80 00 00 	movabs $0x801f0d,%rax
  800971:	00 00 00 
  800974:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800976:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80097c:	c9                   	leaveq 
  80097d:	c3                   	retq   

000000000080097e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80097e:	55                   	push   %rbp
  80097f:	48 89 e5             	mov    %rsp,%rbp
  800982:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800989:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800990:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800997:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80099e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8009a5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8009ac:	84 c0                	test   %al,%al
  8009ae:	74 20                	je     8009d0 <cprintf+0x52>
  8009b0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8009b4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8009b8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8009bc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8009c0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8009c4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8009c8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8009cc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8009d0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8009d7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8009de:	00 00 00 
  8009e1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8009e8:	00 00 00 
  8009eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8009ef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8009f6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8009fd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800a04:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800a0b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800a12:	48 8b 0a             	mov    (%rdx),%rcx
  800a15:	48 89 08             	mov    %rcx,(%rax)
  800a18:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a1c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a24:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800a28:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800a2f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800a36:	48 89 d6             	mov    %rdx,%rsi
  800a39:	48 89 c7             	mov    %rax,%rdi
  800a3c:	48 b8 d2 08 80 00 00 	movabs $0x8008d2,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	callq  *%rax
  800a48:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800a4e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800a54:	c9                   	leaveq 
  800a55:	c3                   	retq   

0000000000800a56 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a56:	55                   	push   %rbp
  800a57:	48 89 e5             	mov    %rsp,%rbp
  800a5a:	53                   	push   %rbx
  800a5b:	48 83 ec 38          	sub    $0x38,%rsp
  800a5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800a67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800a6b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800a6e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a72:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a76:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a79:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a7d:	77 3b                	ja     800aba <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a7f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a82:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a86:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	48 f7 f3             	div    %rbx
  800a95:	48 89 c2             	mov    %rax,%rdx
  800a98:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800a9b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800a9e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	41 89 f9             	mov    %edi,%r9d
  800aa9:	48 89 c7             	mov    %rax,%rdi
  800aac:	48 b8 56 0a 80 00 00 	movabs $0x800a56,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax
  800ab8:	eb 1e                	jmp    800ad8 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aba:	eb 12                	jmp    800ace <printnum+0x78>
			putch(padc, putdat);
  800abc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ac0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac7:	48 89 ce             	mov    %rcx,%rsi
  800aca:	89 d7                	mov    %edx,%edi
  800acc:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ace:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800ad2:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800ad6:	7f e4                	jg     800abc <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ad8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800adb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	48 f7 f1             	div    %rcx
  800ae7:	48 89 d0             	mov    %rdx,%rax
  800aea:	48 ba 48 48 80 00 00 	movabs $0x804848,%rdx
  800af1:	00 00 00 
  800af4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800af8:	0f be d0             	movsbl %al,%edx
  800afb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b03:	48 89 ce             	mov    %rcx,%rsi
  800b06:	89 d7                	mov    %edx,%edi
  800b08:	ff d0                	callq  *%rax
}
  800b0a:	48 83 c4 38          	add    $0x38,%rsp
  800b0e:	5b                   	pop    %rbx
  800b0f:	5d                   	pop    %rbp
  800b10:	c3                   	retq   

0000000000800b11 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b11:	55                   	push   %rbp
  800b12:	48 89 e5             	mov    %rsp,%rbp
  800b15:	48 83 ec 1c          	sub    $0x1c,%rsp
  800b19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b1d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800b20:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b24:	7e 52                	jle    800b78 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2a:	8b 00                	mov    (%rax),%eax
  800b2c:	83 f8 30             	cmp    $0x30,%eax
  800b2f:	73 24                	jae    800b55 <getuint+0x44>
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	8b 00                	mov    (%rax),%eax
  800b3f:	89 c0                	mov    %eax,%eax
  800b41:	48 01 d0             	add    %rdx,%rax
  800b44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b48:	8b 12                	mov    (%rdx),%edx
  800b4a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b51:	89 0a                	mov    %ecx,(%rdx)
  800b53:	eb 17                	jmp    800b6c <getuint+0x5b>
  800b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b59:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b5d:	48 89 d0             	mov    %rdx,%rax
  800b60:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b68:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b6c:	48 8b 00             	mov    (%rax),%rax
  800b6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b73:	e9 a3 00 00 00       	jmpq   800c1b <getuint+0x10a>
	else if (lflag)
  800b78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b7c:	74 4f                	je     800bcd <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b82:	8b 00                	mov    (%rax),%eax
  800b84:	83 f8 30             	cmp    $0x30,%eax
  800b87:	73 24                	jae    800bad <getuint+0x9c>
  800b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b95:	8b 00                	mov    (%rax),%eax
  800b97:	89 c0                	mov    %eax,%eax
  800b99:	48 01 d0             	add    %rdx,%rax
  800b9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba0:	8b 12                	mov    (%rdx),%edx
  800ba2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ba5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba9:	89 0a                	mov    %ecx,(%rdx)
  800bab:	eb 17                	jmp    800bc4 <getuint+0xb3>
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bb5:	48 89 d0             	mov    %rdx,%rax
  800bb8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bc4:	48 8b 00             	mov    (%rax),%rax
  800bc7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bcb:	eb 4e                	jmp    800c1b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd1:	8b 00                	mov    (%rax),%eax
  800bd3:	83 f8 30             	cmp    $0x30,%eax
  800bd6:	73 24                	jae    800bfc <getuint+0xeb>
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be4:	8b 00                	mov    (%rax),%eax
  800be6:	89 c0                	mov    %eax,%eax
  800be8:	48 01 d0             	add    %rdx,%rax
  800beb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bef:	8b 12                	mov    (%rdx),%edx
  800bf1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bf4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf8:	89 0a                	mov    %ecx,(%rdx)
  800bfa:	eb 17                	jmp    800c13 <getuint+0x102>
  800bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c00:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c04:	48 89 d0             	mov    %rdx,%rax
  800c07:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c13:	8b 00                	mov    (%rax),%eax
  800c15:	89 c0                	mov    %eax,%eax
  800c17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c1f:	c9                   	leaveq 
  800c20:	c3                   	retq   

0000000000800c21 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c21:	55                   	push   %rbp
  800c22:	48 89 e5             	mov    %rsp,%rbp
  800c25:	48 83 ec 1c          	sub    $0x1c,%rsp
  800c29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c2d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800c30:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c34:	7e 52                	jle    800c88 <getint+0x67>
		x=va_arg(*ap, long long);
  800c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3a:	8b 00                	mov    (%rax),%eax
  800c3c:	83 f8 30             	cmp    $0x30,%eax
  800c3f:	73 24                	jae    800c65 <getint+0x44>
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4d:	8b 00                	mov    (%rax),%eax
  800c4f:	89 c0                	mov    %eax,%eax
  800c51:	48 01 d0             	add    %rdx,%rax
  800c54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c58:	8b 12                	mov    (%rdx),%edx
  800c5a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c61:	89 0a                	mov    %ecx,(%rdx)
  800c63:	eb 17                	jmp    800c7c <getint+0x5b>
  800c65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c69:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c6d:	48 89 d0             	mov    %rdx,%rax
  800c70:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c78:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c7c:	48 8b 00             	mov    (%rax),%rax
  800c7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c83:	e9 a3 00 00 00       	jmpq   800d2b <getint+0x10a>
	else if (lflag)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c8c:	74 4f                	je     800cdd <getint+0xbc>
		x=va_arg(*ap, long);
  800c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c92:	8b 00                	mov    (%rax),%eax
  800c94:	83 f8 30             	cmp    $0x30,%eax
  800c97:	73 24                	jae    800cbd <getint+0x9c>
  800c99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca5:	8b 00                	mov    (%rax),%eax
  800ca7:	89 c0                	mov    %eax,%eax
  800ca9:	48 01 d0             	add    %rdx,%rax
  800cac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb0:	8b 12                	mov    (%rdx),%edx
  800cb2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cb9:	89 0a                	mov    %ecx,(%rdx)
  800cbb:	eb 17                	jmp    800cd4 <getint+0xb3>
  800cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cc1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800cc5:	48 89 d0             	mov    %rdx,%rax
  800cc8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ccc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cd4:	48 8b 00             	mov    (%rax),%rax
  800cd7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800cdb:	eb 4e                	jmp    800d2b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce1:	8b 00                	mov    (%rax),%eax
  800ce3:	83 f8 30             	cmp    $0x30,%eax
  800ce6:	73 24                	jae    800d0c <getint+0xeb>
  800ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf4:	8b 00                	mov    (%rax),%eax
  800cf6:	89 c0                	mov    %eax,%eax
  800cf8:	48 01 d0             	add    %rdx,%rax
  800cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cff:	8b 12                	mov    (%rdx),%edx
  800d01:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d08:	89 0a                	mov    %ecx,(%rdx)
  800d0a:	eb 17                	jmp    800d23 <getint+0x102>
  800d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d10:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d14:	48 89 d0             	mov    %rdx,%rax
  800d17:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d23:	8b 00                	mov    (%rax),%eax
  800d25:	48 98                	cltq   
  800d27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d2f:	c9                   	leaveq 
  800d30:	c3                   	retq   

0000000000800d31 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d31:	55                   	push   %rbp
  800d32:	48 89 e5             	mov    %rsp,%rbp
  800d35:	41 54                	push   %r12
  800d37:	53                   	push   %rbx
  800d38:	48 83 ec 60          	sub    $0x60,%rsp
  800d3c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800d40:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800d44:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d48:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800d4c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d50:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800d54:	48 8b 0a             	mov    (%rdx),%rcx
  800d57:	48 89 08             	mov    %rcx,(%rax)
  800d5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800d6a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d72:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d76:	0f b6 00             	movzbl (%rax),%eax
  800d79:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800d7c:	eb 29                	jmp    800da7 <vprintfmt+0x76>
			if (ch == '\0')
  800d7e:	85 db                	test   %ebx,%ebx
  800d80:	0f 84 ad 06 00 00    	je     801433 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800d86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d8e:	48 89 d6             	mov    %rdx,%rsi
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800d95:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d9d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800da1:	0f b6 00             	movzbl (%rax),%eax
  800da4:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800da7:	83 fb 25             	cmp    $0x25,%ebx
  800daa:	74 05                	je     800db1 <vprintfmt+0x80>
  800dac:	83 fb 1b             	cmp    $0x1b,%ebx
  800daf:	75 cd                	jne    800d7e <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800db1:	83 fb 1b             	cmp    $0x1b,%ebx
  800db4:	0f 85 ae 01 00 00    	jne    800f68 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800dba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800dc1:	00 00 00 
  800dc4:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800dca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd2:	48 89 d6             	mov    %rdx,%rsi
  800dd5:	89 df                	mov    %ebx,%edi
  800dd7:	ff d0                	callq  *%rax
			putch('[', putdat);
  800dd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de1:	48 89 d6             	mov    %rdx,%rsi
  800de4:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800de9:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800deb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800df1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800df6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dfa:	0f b6 00             	movzbl (%rax),%eax
  800dfd:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800e00:	eb 32                	jmp    800e34 <vprintfmt+0x103>
					putch(ch, putdat);
  800e02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0a:	48 89 d6             	mov    %rdx,%rsi
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	ff d0                	callq  *%rax
					esc_color *= 10;
  800e11:	44 89 e0             	mov    %r12d,%eax
  800e14:	c1 e0 02             	shl    $0x2,%eax
  800e17:	44 01 e0             	add    %r12d,%eax
  800e1a:	01 c0                	add    %eax,%eax
  800e1c:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800e1f:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800e22:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800e25:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800e2a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e2e:	0f b6 00             	movzbl (%rax),%eax
  800e31:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800e34:	83 fb 3b             	cmp    $0x3b,%ebx
  800e37:	74 05                	je     800e3e <vprintfmt+0x10d>
  800e39:	83 fb 6d             	cmp    $0x6d,%ebx
  800e3c:	75 c4                	jne    800e02 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800e3e:	45 85 e4             	test   %r12d,%r12d
  800e41:	75 15                	jne    800e58 <vprintfmt+0x127>
					color_flag = 0x07;
  800e43:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800e4a:	00 00 00 
  800e4d:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800e53:	e9 dc 00 00 00       	jmpq   800f34 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800e58:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800e5c:	7e 69                	jle    800ec7 <vprintfmt+0x196>
  800e5e:	41 83 fc 25          	cmp    $0x25,%r12d
  800e62:	7f 63                	jg     800ec7 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800e64:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800e6b:	00 00 00 
  800e6e:	8b 00                	mov    (%rax),%eax
  800e70:	25 f8 00 00 00       	and    $0xf8,%eax
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800e7e:	00 00 00 
  800e81:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800e83:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800e87:	44 89 e0             	mov    %r12d,%eax
  800e8a:	83 e0 04             	and    $0x4,%eax
  800e8d:	c1 f8 02             	sar    $0x2,%eax
  800e90:	89 c2                	mov    %eax,%edx
  800e92:	44 89 e0             	mov    %r12d,%eax
  800e95:	83 e0 02             	and    $0x2,%eax
  800e98:	09 c2                	or     %eax,%edx
  800e9a:	44 89 e0             	mov    %r12d,%eax
  800e9d:	83 e0 01             	and    $0x1,%eax
  800ea0:	c1 e0 02             	shl    $0x2,%eax
  800ea3:	09 c2                	or     %eax,%edx
  800ea5:	41 89 d4             	mov    %edx,%r12d
  800ea8:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800eaf:	00 00 00 
  800eb2:	8b 00                	mov    (%rax),%eax
  800eb4:	44 89 e2             	mov    %r12d,%edx
  800eb7:	09 c2                	or     %eax,%edx
  800eb9:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800ec0:	00 00 00 
  800ec3:	89 10                	mov    %edx,(%rax)
  800ec5:	eb 6d                	jmp    800f34 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800ec7:	41 83 fc 27          	cmp    $0x27,%r12d
  800ecb:	7e 67                	jle    800f34 <vprintfmt+0x203>
  800ecd:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800ed1:	7f 61                	jg     800f34 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800ed3:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800eda:	00 00 00 
  800edd:	8b 00                	mov    (%rax),%eax
  800edf:	25 8f 00 00 00       	and    $0x8f,%eax
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800eed:	00 00 00 
  800ef0:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800ef2:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800ef6:	44 89 e0             	mov    %r12d,%eax
  800ef9:	83 e0 04             	and    $0x4,%eax
  800efc:	c1 f8 02             	sar    $0x2,%eax
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	44 89 e0             	mov    %r12d,%eax
  800f04:	83 e0 02             	and    $0x2,%eax
  800f07:	09 c2                	or     %eax,%edx
  800f09:	44 89 e0             	mov    %r12d,%eax
  800f0c:	83 e0 01             	and    $0x1,%eax
  800f0f:	c1 e0 06             	shl    $0x6,%eax
  800f12:	09 c2                	or     %eax,%edx
  800f14:	41 89 d4             	mov    %edx,%r12d
  800f17:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800f1e:	00 00 00 
  800f21:	8b 00                	mov    (%rax),%eax
  800f23:	44 89 e2             	mov    %r12d,%edx
  800f26:	09 c2                	or     %eax,%edx
  800f28:	48 b8 c0 77 80 00 00 	movabs $0x8077c0,%rax
  800f2f:	00 00 00 
  800f32:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800f34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3c:	48 89 d6             	mov    %rdx,%rsi
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800f43:	83 fb 6d             	cmp    $0x6d,%ebx
  800f46:	75 1b                	jne    800f63 <vprintfmt+0x232>
					fmt ++;
  800f48:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800f4d:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800f4e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800f55:	00 00 00 
  800f58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800f5e:	e9 cb 04 00 00       	jmpq   80142e <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800f63:	e9 83 fe ff ff       	jmpq   800deb <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800f68:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f6c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f73:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f81:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f88:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f8c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f90:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f94:	0f b6 00             	movzbl (%rax),%eax
  800f97:	0f b6 d8             	movzbl %al,%ebx
  800f9a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f9d:	83 f8 55             	cmp    $0x55,%eax
  800fa0:	0f 87 5a 04 00 00    	ja     801400 <vprintfmt+0x6cf>
  800fa6:	89 c0                	mov    %eax,%eax
  800fa8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800faf:	00 
  800fb0:	48 b8 70 48 80 00 00 	movabs $0x804870,%rax
  800fb7:	00 00 00 
  800fba:	48 01 d0             	add    %rdx,%rax
  800fbd:	48 8b 00             	mov    (%rax),%rax
  800fc0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fc2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800fc6:	eb c0                	jmp    800f88 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fcc:	eb ba                	jmp    800f88 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fd5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fd8:	89 d0                	mov    %edx,%eax
  800fda:	c1 e0 02             	shl    $0x2,%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	01 c0                	add    %eax,%eax
  800fe1:	01 d8                	add    %ebx,%eax
  800fe3:	83 e8 30             	sub    $0x30,%eax
  800fe6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fe9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fed:	0f b6 00             	movzbl (%rax),%eax
  800ff0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ff3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ff6:	7e 0c                	jle    801004 <vprintfmt+0x2d3>
  800ff8:	83 fb 39             	cmp    $0x39,%ebx
  800ffb:	7f 07                	jg     801004 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ffd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801002:	eb d1                	jmp    800fd5 <vprintfmt+0x2a4>
			goto process_precision;
  801004:	eb 58                	jmp    80105e <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  801006:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801009:	83 f8 30             	cmp    $0x30,%eax
  80100c:	73 17                	jae    801025 <vprintfmt+0x2f4>
  80100e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801012:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801015:	89 c0                	mov    %eax,%eax
  801017:	48 01 d0             	add    %rdx,%rax
  80101a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80101d:	83 c2 08             	add    $0x8,%edx
  801020:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801023:	eb 0f                	jmp    801034 <vprintfmt+0x303>
  801025:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801029:	48 89 d0             	mov    %rdx,%rax
  80102c:	48 83 c2 08          	add    $0x8,%rdx
  801030:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801034:	8b 00                	mov    (%rax),%eax
  801036:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801039:	eb 23                	jmp    80105e <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  80103b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80103f:	79 0c                	jns    80104d <vprintfmt+0x31c>
				width = 0;
  801041:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801048:	e9 3b ff ff ff       	jmpq   800f88 <vprintfmt+0x257>
  80104d:	e9 36 ff ff ff       	jmpq   800f88 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  801052:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801059:	e9 2a ff ff ff       	jmpq   800f88 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  80105e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801062:	79 12                	jns    801076 <vprintfmt+0x345>
				width = precision, precision = -1;
  801064:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801067:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80106a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801071:	e9 12 ff ff ff       	jmpq   800f88 <vprintfmt+0x257>
  801076:	e9 0d ff ff ff       	jmpq   800f88 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80107b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80107f:	e9 04 ff ff ff       	jmpq   800f88 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801084:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801087:	83 f8 30             	cmp    $0x30,%eax
  80108a:	73 17                	jae    8010a3 <vprintfmt+0x372>
  80108c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801090:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801093:	89 c0                	mov    %eax,%eax
  801095:	48 01 d0             	add    %rdx,%rax
  801098:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80109b:	83 c2 08             	add    $0x8,%edx
  80109e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010a1:	eb 0f                	jmp    8010b2 <vprintfmt+0x381>
  8010a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010a7:	48 89 d0             	mov    %rdx,%rax
  8010aa:	48 83 c2 08          	add    $0x8,%rdx
  8010ae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010b2:	8b 10                	mov    (%rax),%edx
  8010b4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8010b8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010bc:	48 89 ce             	mov    %rcx,%rsi
  8010bf:	89 d7                	mov    %edx,%edi
  8010c1:	ff d0                	callq  *%rax
			break;
  8010c3:	e9 66 03 00 00       	jmpq   80142e <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8010c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010cb:	83 f8 30             	cmp    $0x30,%eax
  8010ce:	73 17                	jae    8010e7 <vprintfmt+0x3b6>
  8010d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010d7:	89 c0                	mov    %eax,%eax
  8010d9:	48 01 d0             	add    %rdx,%rax
  8010dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010e5:	eb 0f                	jmp    8010f6 <vprintfmt+0x3c5>
  8010e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010eb:	48 89 d0             	mov    %rdx,%rax
  8010ee:	48 83 c2 08          	add    $0x8,%rdx
  8010f2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010f6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010f8:	85 db                	test   %ebx,%ebx
  8010fa:	79 02                	jns    8010fe <vprintfmt+0x3cd>
				err = -err;
  8010fc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010fe:	83 fb 10             	cmp    $0x10,%ebx
  801101:	7f 16                	jg     801119 <vprintfmt+0x3e8>
  801103:	48 b8 c0 47 80 00 00 	movabs $0x8047c0,%rax
  80110a:	00 00 00 
  80110d:	48 63 d3             	movslq %ebx,%rdx
  801110:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801114:	4d 85 e4             	test   %r12,%r12
  801117:	75 2e                	jne    801147 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  801119:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80111d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801121:	89 d9                	mov    %ebx,%ecx
  801123:	48 ba 59 48 80 00 00 	movabs $0x804859,%rdx
  80112a:	00 00 00 
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	49 b8 3c 14 80 00 00 	movabs $0x80143c,%r8
  80113c:	00 00 00 
  80113f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801142:	e9 e7 02 00 00       	jmpq   80142e <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801147:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80114b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80114f:	4c 89 e1             	mov    %r12,%rcx
  801152:	48 ba 62 48 80 00 00 	movabs $0x804862,%rdx
  801159:	00 00 00 
  80115c:	48 89 c7             	mov    %rax,%rdi
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	49 b8 3c 14 80 00 00 	movabs $0x80143c,%r8
  80116b:	00 00 00 
  80116e:	41 ff d0             	callq  *%r8
			break;
  801171:	e9 b8 02 00 00       	jmpq   80142e <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801176:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801179:	83 f8 30             	cmp    $0x30,%eax
  80117c:	73 17                	jae    801195 <vprintfmt+0x464>
  80117e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801182:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801185:	89 c0                	mov    %eax,%eax
  801187:	48 01 d0             	add    %rdx,%rax
  80118a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80118d:	83 c2 08             	add    $0x8,%edx
  801190:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801193:	eb 0f                	jmp    8011a4 <vprintfmt+0x473>
  801195:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801199:	48 89 d0             	mov    %rdx,%rax
  80119c:	48 83 c2 08          	add    $0x8,%rdx
  8011a0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011a4:	4c 8b 20             	mov    (%rax),%r12
  8011a7:	4d 85 e4             	test   %r12,%r12
  8011aa:	75 0a                	jne    8011b6 <vprintfmt+0x485>
				p = "(null)";
  8011ac:	49 bc 65 48 80 00 00 	movabs $0x804865,%r12
  8011b3:	00 00 00 
			if (width > 0 && padc != '-')
  8011b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ba:	7e 3f                	jle    8011fb <vprintfmt+0x4ca>
  8011bc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011c0:	74 39                	je     8011fb <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011c5:	48 98                	cltq   
  8011c7:	48 89 c6             	mov    %rax,%rsi
  8011ca:	4c 89 e7             	mov    %r12,%rdi
  8011cd:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  8011d4:	00 00 00 
  8011d7:	ff d0                	callq  *%rax
  8011d9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011dc:	eb 17                	jmp    8011f5 <vprintfmt+0x4c4>
					putch(padc, putdat);
  8011de:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8011e2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8011e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ea:	48 89 ce             	mov    %rcx,%rsi
  8011ed:	89 d7                	mov    %edx,%edi
  8011ef:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011f1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011f9:	7f e3                	jg     8011de <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011fb:	eb 37                	jmp    801234 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8011fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801201:	74 1e                	je     801221 <vprintfmt+0x4f0>
  801203:	83 fb 1f             	cmp    $0x1f,%ebx
  801206:	7e 05                	jle    80120d <vprintfmt+0x4dc>
  801208:	83 fb 7e             	cmp    $0x7e,%ebx
  80120b:	7e 14                	jle    801221 <vprintfmt+0x4f0>
					putch('?', putdat);
  80120d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801211:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801215:	48 89 d6             	mov    %rdx,%rsi
  801218:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80121d:	ff d0                	callq  *%rax
  80121f:	eb 0f                	jmp    801230 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  801221:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801225:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801229:	48 89 d6             	mov    %rdx,%rsi
  80122c:	89 df                	mov    %ebx,%edi
  80122e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801230:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801234:	4c 89 e0             	mov    %r12,%rax
  801237:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80123b:	0f b6 00             	movzbl (%rax),%eax
  80123e:	0f be d8             	movsbl %al,%ebx
  801241:	85 db                	test   %ebx,%ebx
  801243:	74 10                	je     801255 <vprintfmt+0x524>
  801245:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801249:	78 b2                	js     8011fd <vprintfmt+0x4cc>
  80124b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80124f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801253:	79 a8                	jns    8011fd <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801255:	eb 16                	jmp    80126d <vprintfmt+0x53c>
				putch(' ', putdat);
  801257:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80125b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80125f:	48 89 d6             	mov    %rdx,%rsi
  801262:	bf 20 00 00 00       	mov    $0x20,%edi
  801267:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801269:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80126d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801271:	7f e4                	jg     801257 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  801273:	e9 b6 01 00 00       	jmpq   80142e <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801278:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80127c:	be 03 00 00 00       	mov    $0x3,%esi
  801281:	48 89 c7             	mov    %rax,%rdi
  801284:	48 b8 21 0c 80 00 00 	movabs $0x800c21,%rax
  80128b:	00 00 00 
  80128e:	ff d0                	callq  *%rax
  801290:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	48 85 c0             	test   %rax,%rax
  80129b:	79 1d                	jns    8012ba <vprintfmt+0x589>
				putch('-', putdat);
  80129d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012a5:	48 89 d6             	mov    %rdx,%rsi
  8012a8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012ad:	ff d0                	callq  *%rax
				num = -(long long) num;
  8012af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b3:	48 f7 d8             	neg    %rax
  8012b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012ba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012c1:	e9 fb 00 00 00       	jmpq   8013c1 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012c6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012ca:	be 03 00 00 00       	mov    $0x3,%esi
  8012cf:	48 89 c7             	mov    %rax,%rdi
  8012d2:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  8012d9:	00 00 00 
  8012dc:	ff d0                	callq  *%rax
  8012de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012e2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012e9:	e9 d3 00 00 00       	jmpq   8013c1 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  8012ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012f2:	be 03 00 00 00       	mov    $0x3,%esi
  8012f7:	48 89 c7             	mov    %rax,%rdi
  8012fa:	48 b8 21 0c 80 00 00 	movabs $0x800c21,%rax
  801301:	00 00 00 
  801304:	ff d0                	callq  *%rax
  801306:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80130a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130e:	48 85 c0             	test   %rax,%rax
  801311:	79 1d                	jns    801330 <vprintfmt+0x5ff>
				putch('-', putdat);
  801313:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801317:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80131b:	48 89 d6             	mov    %rdx,%rsi
  80131e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801323:	ff d0                	callq  *%rax
				num = -(long long) num;
  801325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801329:	48 f7 d8             	neg    %rax
  80132c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  801330:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801337:	e9 85 00 00 00       	jmpq   8013c1 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  80133c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801340:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801344:	48 89 d6             	mov    %rdx,%rsi
  801347:	bf 30 00 00 00       	mov    $0x30,%edi
  80134c:	ff d0                	callq  *%rax
			putch('x', putdat);
  80134e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801352:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801356:	48 89 d6             	mov    %rdx,%rsi
  801359:	bf 78 00 00 00       	mov    $0x78,%edi
  80135e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801360:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801363:	83 f8 30             	cmp    $0x30,%eax
  801366:	73 17                	jae    80137f <vprintfmt+0x64e>
  801368:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80136c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80136f:	89 c0                	mov    %eax,%eax
  801371:	48 01 d0             	add    %rdx,%rax
  801374:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801377:	83 c2 08             	add    $0x8,%edx
  80137a:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80137d:	eb 0f                	jmp    80138e <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  80137f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801383:	48 89 d0             	mov    %rdx,%rax
  801386:	48 83 c2 08          	add    $0x8,%rdx
  80138a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80138e:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801391:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801395:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80139c:	eb 23                	jmp    8013c1 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80139e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8013a2:	be 03 00 00 00       	mov    $0x3,%esi
  8013a7:	48 89 c7             	mov    %rax,%rdi
  8013aa:	48 b8 11 0b 80 00 00 	movabs $0x800b11,%rax
  8013b1:	00 00 00 
  8013b4:	ff d0                	callq  *%rax
  8013b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8013ba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8013c1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8013c6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8013c9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8013cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013d8:	45 89 c1             	mov    %r8d,%r9d
  8013db:	41 89 f8             	mov    %edi,%r8d
  8013de:	48 89 c7             	mov    %rax,%rdi
  8013e1:	48 b8 56 0a 80 00 00 	movabs $0x800a56,%rax
  8013e8:	00 00 00 
  8013eb:	ff d0                	callq  *%rax
			break;
  8013ed:	eb 3f                	jmp    80142e <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013f7:	48 89 d6             	mov    %rdx,%rsi
  8013fa:	89 df                	mov    %ebx,%edi
  8013fc:	ff d0                	callq  *%rax
			break;
  8013fe:	eb 2e                	jmp    80142e <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801400:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801404:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801408:	48 89 d6             	mov    %rdx,%rsi
  80140b:	bf 25 00 00 00       	mov    $0x25,%edi
  801410:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801412:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801417:	eb 05                	jmp    80141e <vprintfmt+0x6ed>
  801419:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80141e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801422:	48 83 e8 01          	sub    $0x1,%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3c 25                	cmp    $0x25,%al
  80142b:	75 ec                	jne    801419 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  80142d:	90                   	nop
		}
	}
  80142e:	e9 37 f9 ff ff       	jmpq   800d6a <vprintfmt+0x39>
    va_end(aq);
}
  801433:	48 83 c4 60          	add    $0x60,%rsp
  801437:	5b                   	pop    %rbx
  801438:	41 5c                	pop    %r12
  80143a:	5d                   	pop    %rbp
  80143b:	c3                   	retq   

000000000080143c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801447:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80144e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801455:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80145c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801463:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80146a:	84 c0                	test   %al,%al
  80146c:	74 20                	je     80148e <printfmt+0x52>
  80146e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801472:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801476:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80147a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80147e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801482:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801486:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80148a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80148e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801495:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80149c:	00 00 00 
  80149f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8014a6:	00 00 00 
  8014a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014ad:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8014b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014bb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8014c2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8014c9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014d0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014d7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014de:	48 89 c7             	mov    %rax,%rdi
  8014e1:	48 b8 31 0d 80 00 00 	movabs $0x800d31,%rax
  8014e8:	00 00 00 
  8014eb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014ed:	c9                   	leaveq 
  8014ee:	c3                   	retq   

00000000008014ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014ef:	55                   	push   %rbp
  8014f0:	48 89 e5             	mov    %rsp,%rbp
  8014f3:	48 83 ec 10          	sub    $0x10,%rsp
  8014f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	8b 40 10             	mov    0x10(%rax),%eax
  801505:	8d 50 01             	lea    0x1(%rax),%edx
  801508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80150f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801513:	48 8b 10             	mov    (%rax),%rdx
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80151e:	48 39 c2             	cmp    %rax,%rdx
  801521:	73 17                	jae    80153a <sprintputch+0x4b>
		*b->buf++ = ch;
  801523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801527:	48 8b 00             	mov    (%rax),%rax
  80152a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80152e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801532:	48 89 0a             	mov    %rcx,(%rdx)
  801535:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801538:	88 10                	mov    %dl,(%rax)
}
  80153a:	c9                   	leaveq 
  80153b:	c3                   	retq   

000000000080153c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153c:	55                   	push   %rbp
  80153d:	48 89 e5             	mov    %rsp,%rbp
  801540:	48 83 ec 50          	sub    $0x50,%rsp
  801544:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801548:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80154b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80154f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801553:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801557:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80155b:	48 8b 0a             	mov    (%rdx),%rcx
  80155e:	48 89 08             	mov    %rcx,(%rax)
  801561:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801565:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801569:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80156d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801571:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801575:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801579:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80157c:	48 98                	cltq   
  80157e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801582:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801586:	48 01 d0             	add    %rdx,%rax
  801589:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80158d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801594:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801599:	74 06                	je     8015a1 <vsnprintf+0x65>
  80159b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80159f:	7f 07                	jg     8015a8 <vsnprintf+0x6c>
		return -E_INVAL;
  8015a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a6:	eb 2f                	jmp    8015d7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8015a8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8015ac:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8015b0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015b4:	48 89 c6             	mov    %rax,%rsi
  8015b7:	48 bf ef 14 80 00 00 	movabs $0x8014ef,%rdi
  8015be:	00 00 00 
  8015c1:	48 b8 31 0d 80 00 00 	movabs $0x800d31,%rax
  8015c8:	00 00 00 
  8015cb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8015cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015e4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015eb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801606:	84 c0                	test   %al,%al
  801608:	74 20                	je     80162a <snprintf+0x51>
  80160a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80160e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801612:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801616:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80161a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80161e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801622:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801626:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80162a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801631:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801638:	00 00 00 
  80163b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801642:	00 00 00 
  801645:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801649:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801650:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801657:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80165e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801665:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80166c:	48 8b 0a             	mov    (%rdx),%rcx
  80166f:	48 89 08             	mov    %rcx,(%rax)
  801672:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801676:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80167a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80167e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801682:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801689:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801690:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801696:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80169d:	48 89 c7             	mov    %rax,%rdi
  8016a0:	48 b8 3c 15 80 00 00 	movabs $0x80153c,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8016b2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 18          	sub    $0x18,%rsp
  8016c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8016c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016cd:	eb 09                	jmp    8016d8 <strlen+0x1e>
		n++;
  8016cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	84 c0                	test   %al,%al
  8016e1:	75 ec                	jne    8016cf <strlen+0x15>
		n++;
	return n;
  8016e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016e6:	c9                   	leaveq 
  8016e7:	c3                   	retq   

00000000008016e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 20          	sub    $0x20,%rsp
  8016f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ff:	eb 0e                	jmp    80170f <strnlen+0x27>
		n++;
  801701:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801705:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80170a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80170f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801714:	74 0b                	je     801721 <strnlen+0x39>
  801716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	84 c0                	test   %al,%al
  80171f:	75 e0                	jne    801701 <strnlen+0x19>
		n++;
	return n;
  801721:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801724:	c9                   	leaveq 
  801725:	c3                   	retq   

0000000000801726 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801726:	55                   	push   %rbp
  801727:	48 89 e5             	mov    %rsp,%rbp
  80172a:	48 83 ec 20          	sub    $0x20,%rsp
  80172e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801732:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80173e:	90                   	nop
  80173f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801743:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801747:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80174b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80174f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801753:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801757:	0f b6 12             	movzbl (%rdx),%edx
  80175a:	88 10                	mov    %dl,(%rax)
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	84 c0                	test   %al,%al
  801761:	75 dc                	jne    80173f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801763:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801767:	c9                   	leaveq 
  801768:	c3                   	retq   

0000000000801769 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801769:	55                   	push   %rbp
  80176a:	48 89 e5             	mov    %rsp,%rbp
  80176d:	48 83 ec 20          	sub    $0x20,%rsp
  801771:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177d:	48 89 c7             	mov    %rax,%rdi
  801780:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
  80178c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80178f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801792:	48 63 d0             	movslq %eax,%rdx
  801795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801799:	48 01 c2             	add    %rax,%rdx
  80179c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a0:	48 89 c6             	mov    %rax,%rsi
  8017a3:	48 89 d7             	mov    %rdx,%rdi
  8017a6:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
	return dst;
  8017b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017b6:	c9                   	leaveq 
  8017b7:	c3                   	retq   

00000000008017b8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8017b8:	55                   	push   %rbp
  8017b9:	48 89 e5             	mov    %rsp,%rbp
  8017bc:	48 83 ec 28          	sub    $0x28,%rsp
  8017c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8017cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017db:	00 
  8017dc:	eb 2a                	jmp    801808 <strncpy+0x50>
		*dst++ = *src;
  8017de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017ee:	0f b6 12             	movzbl (%rdx),%edx
  8017f1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017f7:	0f b6 00             	movzbl (%rax),%eax
  8017fa:	84 c0                	test   %al,%al
  8017fc:	74 05                	je     801803 <strncpy+0x4b>
			src++;
  8017fe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801803:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801808:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801810:	72 cc                	jb     8017de <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801816:	c9                   	leaveq 
  801817:	c3                   	retq   

0000000000801818 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801818:	55                   	push   %rbp
  801819:	48 89 e5             	mov    %rsp,%rbp
  80181c:	48 83 ec 28          	sub    $0x28,%rsp
  801820:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801824:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801828:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80182c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801830:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801834:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801839:	74 3d                	je     801878 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80183b:	eb 1d                	jmp    80185a <strlcpy+0x42>
			*dst++ = *src++;
  80183d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801841:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801845:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801849:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80184d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801851:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801855:	0f b6 12             	movzbl (%rdx),%edx
  801858:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80185a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80185f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801864:	74 0b                	je     801871 <strlcpy+0x59>
  801866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	84 c0                	test   %al,%al
  80186f:	75 cc                	jne    80183d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801875:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80187c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801880:	48 29 c2             	sub    %rax,%rdx
  801883:	48 89 d0             	mov    %rdx,%rax
}
  801886:	c9                   	leaveq 
  801887:	c3                   	retq   

0000000000801888 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 10          	sub    $0x10,%rsp
  801890:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801898:	eb 0a                	jmp    8018a4 <strcmp+0x1c>
		p++, q++;
  80189a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80189f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a8:	0f b6 00             	movzbl (%rax),%eax
  8018ab:	84 c0                	test   %al,%al
  8018ad:	74 12                	je     8018c1 <strcmp+0x39>
  8018af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b3:	0f b6 10             	movzbl (%rax),%edx
  8018b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ba:	0f b6 00             	movzbl (%rax),%eax
  8018bd:	38 c2                	cmp    %al,%dl
  8018bf:	74 d9                	je     80189a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c5:	0f b6 00             	movzbl (%rax),%eax
  8018c8:	0f b6 d0             	movzbl %al,%edx
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cf:	0f b6 00             	movzbl (%rax),%eax
  8018d2:	0f b6 c0             	movzbl %al,%eax
  8018d5:	29 c2                	sub    %eax,%edx
  8018d7:	89 d0                	mov    %edx,%eax
}
  8018d9:	c9                   	leaveq 
  8018da:	c3                   	retq   

00000000008018db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018db:	55                   	push   %rbp
  8018dc:	48 89 e5             	mov    %rsp,%rbp
  8018df:	48 83 ec 18          	sub    $0x18,%rsp
  8018e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018ef:	eb 0f                	jmp    801900 <strncmp+0x25>
		n--, p++, q++;
  8018f1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018fb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801900:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801905:	74 1d                	je     801924 <strncmp+0x49>
  801907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190b:	0f b6 00             	movzbl (%rax),%eax
  80190e:	84 c0                	test   %al,%al
  801910:	74 12                	je     801924 <strncmp+0x49>
  801912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801916:	0f b6 10             	movzbl (%rax),%edx
  801919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191d:	0f b6 00             	movzbl (%rax),%eax
  801920:	38 c2                	cmp    %al,%dl
  801922:	74 cd                	je     8018f1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801924:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801929:	75 07                	jne    801932 <strncmp+0x57>
		return 0;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	eb 18                	jmp    80194a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801936:	0f b6 00             	movzbl (%rax),%eax
  801939:	0f b6 d0             	movzbl %al,%edx
  80193c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	0f b6 c0             	movzbl %al,%eax
  801946:	29 c2                	sub    %eax,%edx
  801948:	89 d0                	mov    %edx,%eax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 0c          	sub    $0xc,%rsp
  801954:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801958:	89 f0                	mov    %esi,%eax
  80195a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80195d:	eb 17                	jmp    801976 <strchr+0x2a>
		if (*s == c)
  80195f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801969:	75 06                	jne    801971 <strchr+0x25>
			return (char *) s;
  80196b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196f:	eb 15                	jmp    801986 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801971:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801976:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	84 c0                	test   %al,%al
  80197f:	75 de                	jne    80195f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801986:	c9                   	leaveq 
  801987:	c3                   	retq   

0000000000801988 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	48 83 ec 0c          	sub    $0xc,%rsp
  801990:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801994:	89 f0                	mov    %esi,%eax
  801996:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801999:	eb 13                	jmp    8019ae <strfind+0x26>
		if (*s == c)
  80199b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199f:	0f b6 00             	movzbl (%rax),%eax
  8019a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8019a5:	75 02                	jne    8019a9 <strfind+0x21>
			break;
  8019a7:	eb 10                	jmp    8019b9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b2:	0f b6 00             	movzbl (%rax),%eax
  8019b5:	84 c0                	test   %al,%al
  8019b7:	75 e2                	jne    80199b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019bd:	c9                   	leaveq 
  8019be:	c3                   	retq   

00000000008019bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	48 83 ec 18          	sub    $0x18,%rsp
  8019c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019cb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8019ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019d7:	75 06                	jne    8019df <memset+0x20>
		return v;
  8019d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019dd:	eb 69                	jmp    801a48 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e3:	83 e0 03             	and    $0x3,%eax
  8019e6:	48 85 c0             	test   %rax,%rax
  8019e9:	75 48                	jne    801a33 <memset+0x74>
  8019eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ef:	83 e0 03             	and    $0x3,%eax
  8019f2:	48 85 c0             	test   %rax,%rax
  8019f5:	75 3c                	jne    801a33 <memset+0x74>
		c &= 0xFF;
  8019f7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a01:	c1 e0 18             	shl    $0x18,%eax
  801a04:	89 c2                	mov    %eax,%edx
  801a06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a09:	c1 e0 10             	shl    $0x10,%eax
  801a0c:	09 c2                	or     %eax,%edx
  801a0e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a11:	c1 e0 08             	shl    $0x8,%eax
  801a14:	09 d0                	or     %edx,%eax
  801a16:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801a19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1d:	48 c1 e8 02          	shr    $0x2,%rax
  801a21:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801a24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a2b:	48 89 d7             	mov    %rdx,%rdi
  801a2e:	fc                   	cld    
  801a2f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a31:	eb 11                	jmp    801a44 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a3e:	48 89 d7             	mov    %rdx,%rdi
  801a41:	fc                   	cld    
  801a42:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 28          	sub    $0x28,%rsp
  801a52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a72:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a76:	0f 83 88 00 00 00    	jae    801b04 <memmove+0xba>
  801a7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a80:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a84:	48 01 d0             	add    %rdx,%rax
  801a87:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a8b:	76 77                	jbe    801b04 <memmove+0xba>
		s += n;
  801a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a91:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a99:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa1:	83 e0 03             	and    $0x3,%eax
  801aa4:	48 85 c0             	test   %rax,%rax
  801aa7:	75 3b                	jne    801ae4 <memmove+0x9a>
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aad:	83 e0 03             	and    $0x3,%eax
  801ab0:	48 85 c0             	test   %rax,%rax
  801ab3:	75 2f                	jne    801ae4 <memmove+0x9a>
  801ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab9:	83 e0 03             	and    $0x3,%eax
  801abc:	48 85 c0             	test   %rax,%rax
  801abf:	75 23                	jne    801ae4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac5:	48 83 e8 04          	sub    $0x4,%rax
  801ac9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801acd:	48 83 ea 04          	sub    $0x4,%rdx
  801ad1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ad5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ad9:	48 89 c7             	mov    %rax,%rdi
  801adc:	48 89 d6             	mov    %rdx,%rsi
  801adf:	fd                   	std    
  801ae0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ae2:	eb 1d                	jmp    801b01 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801aec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	48 89 d7             	mov    %rdx,%rdi
  801afb:	48 89 c1             	mov    %rax,%rcx
  801afe:	fd                   	std    
  801aff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b01:	fc                   	cld    
  801b02:	eb 57                	jmp    801b5b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b08:	83 e0 03             	and    $0x3,%eax
  801b0b:	48 85 c0             	test   %rax,%rax
  801b0e:	75 36                	jne    801b46 <memmove+0xfc>
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	83 e0 03             	and    $0x3,%eax
  801b17:	48 85 c0             	test   %rax,%rax
  801b1a:	75 2a                	jne    801b46 <memmove+0xfc>
  801b1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b20:	83 e0 03             	and    $0x3,%eax
  801b23:	48 85 c0             	test   %rax,%rax
  801b26:	75 1e                	jne    801b46 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2c:	48 c1 e8 02          	shr    $0x2,%rax
  801b30:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b37:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b3b:	48 89 c7             	mov    %rax,%rdi
  801b3e:	48 89 d6             	mov    %rdx,%rsi
  801b41:	fc                   	cld    
  801b42:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b44:	eb 15                	jmp    801b5b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b4e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b52:	48 89 c7             	mov    %rax,%rdi
  801b55:	48 89 d6             	mov    %rdx,%rsi
  801b58:	fc                   	cld    
  801b59:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 18          	sub    $0x18,%rsp
  801b69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b71:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b79:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b81:	48 89 ce             	mov    %rcx,%rsi
  801b84:	48 89 c7             	mov    %rax,%rdi
  801b87:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	callq  *%rax
}
  801b93:	c9                   	leaveq 
  801b94:	c3                   	retq   

0000000000801b95 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b95:	55                   	push   %rbp
  801b96:	48 89 e5             	mov    %rsp,%rbp
  801b99:	48 83 ec 28          	sub    $0x28,%rsp
  801b9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ba1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ba5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801bb9:	eb 36                	jmp    801bf1 <memcmp+0x5c>
		if (*s1 != *s2)
  801bbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbf:	0f b6 10             	movzbl (%rax),%edx
  801bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc6:	0f b6 00             	movzbl (%rax),%eax
  801bc9:	38 c2                	cmp    %al,%dl
  801bcb:	74 1a                	je     801be7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801bcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd1:	0f b6 00             	movzbl (%rax),%eax
  801bd4:	0f b6 d0             	movzbl %al,%edx
  801bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bdb:	0f b6 00             	movzbl (%rax),%eax
  801bde:	0f b6 c0             	movzbl %al,%eax
  801be1:	29 c2                	sub    %eax,%edx
  801be3:	89 d0                	mov    %edx,%eax
  801be5:	eb 20                	jmp    801c07 <memcmp+0x72>
		s1++, s2++;
  801be7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801bf9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bfd:	48 85 c0             	test   %rax,%rax
  801c00:	75 b9                	jne    801bbb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c07:	c9                   	leaveq 
  801c08:	c3                   	retq   

0000000000801c09 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c09:	55                   	push   %rbp
  801c0a:	48 89 e5             	mov    %rsp,%rbp
  801c0d:	48 83 ec 28          	sub    $0x28,%rsp
  801c11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c15:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801c18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c24:	48 01 d0             	add    %rdx,%rax
  801c27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801c2b:	eb 15                	jmp    801c42 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c31:	0f b6 10             	movzbl (%rax),%edx
  801c34:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c37:	38 c2                	cmp    %al,%dl
  801c39:	75 02                	jne    801c3d <memfind+0x34>
			break;
  801c3b:	eb 0f                	jmp    801c4c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c3d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c46:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c4a:	72 e1                	jb     801c2d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c50:	c9                   	leaveq 
  801c51:	c3                   	retq   

0000000000801c52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c52:	55                   	push   %rbp
  801c53:	48 89 e5             	mov    %rsp,%rbp
  801c56:	48 83 ec 34          	sub    $0x34,%rsp
  801c5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c62:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c6c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c73:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c74:	eb 05                	jmp    801c7b <strtol+0x29>
		s++;
  801c76:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7f:	0f b6 00             	movzbl (%rax),%eax
  801c82:	3c 20                	cmp    $0x20,%al
  801c84:	74 f0                	je     801c76 <strtol+0x24>
  801c86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8a:	0f b6 00             	movzbl (%rax),%eax
  801c8d:	3c 09                	cmp    $0x9,%al
  801c8f:	74 e5                	je     801c76 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c95:	0f b6 00             	movzbl (%rax),%eax
  801c98:	3c 2b                	cmp    $0x2b,%al
  801c9a:	75 07                	jne    801ca3 <strtol+0x51>
		s++;
  801c9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ca1:	eb 17                	jmp    801cba <strtol+0x68>
	else if (*s == '-')
  801ca3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca7:	0f b6 00             	movzbl (%rax),%eax
  801caa:	3c 2d                	cmp    $0x2d,%al
  801cac:	75 0c                	jne    801cba <strtol+0x68>
		s++, neg = 1;
  801cae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cbe:	74 06                	je     801cc6 <strtol+0x74>
  801cc0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801cc4:	75 28                	jne    801cee <strtol+0x9c>
  801cc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cca:	0f b6 00             	movzbl (%rax),%eax
  801ccd:	3c 30                	cmp    $0x30,%al
  801ccf:	75 1d                	jne    801cee <strtol+0x9c>
  801cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd5:	48 83 c0 01          	add    $0x1,%rax
  801cd9:	0f b6 00             	movzbl (%rax),%eax
  801cdc:	3c 78                	cmp    $0x78,%al
  801cde:	75 0e                	jne    801cee <strtol+0x9c>
		s += 2, base = 16;
  801ce0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801ce5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cec:	eb 2c                	jmp    801d1a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cee:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cf2:	75 19                	jne    801d0d <strtol+0xbb>
  801cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf8:	0f b6 00             	movzbl (%rax),%eax
  801cfb:	3c 30                	cmp    $0x30,%al
  801cfd:	75 0e                	jne    801d0d <strtol+0xbb>
		s++, base = 8;
  801cff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d04:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801d0b:	eb 0d                	jmp    801d1a <strtol+0xc8>
	else if (base == 0)
  801d0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d11:	75 07                	jne    801d1a <strtol+0xc8>
		base = 10;
  801d13:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	3c 2f                	cmp    $0x2f,%al
  801d23:	7e 1d                	jle    801d42 <strtol+0xf0>
  801d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d29:	0f b6 00             	movzbl (%rax),%eax
  801d2c:	3c 39                	cmp    $0x39,%al
  801d2e:	7f 12                	jg     801d42 <strtol+0xf0>
			dig = *s - '0';
  801d30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d34:	0f b6 00             	movzbl (%rax),%eax
  801d37:	0f be c0             	movsbl %al,%eax
  801d3a:	83 e8 30             	sub    $0x30,%eax
  801d3d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d40:	eb 4e                	jmp    801d90 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d46:	0f b6 00             	movzbl (%rax),%eax
  801d49:	3c 60                	cmp    $0x60,%al
  801d4b:	7e 1d                	jle    801d6a <strtol+0x118>
  801d4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d51:	0f b6 00             	movzbl (%rax),%eax
  801d54:	3c 7a                	cmp    $0x7a,%al
  801d56:	7f 12                	jg     801d6a <strtol+0x118>
			dig = *s - 'a' + 10;
  801d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5c:	0f b6 00             	movzbl (%rax),%eax
  801d5f:	0f be c0             	movsbl %al,%eax
  801d62:	83 e8 57             	sub    $0x57,%eax
  801d65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d68:	eb 26                	jmp    801d90 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d6e:	0f b6 00             	movzbl (%rax),%eax
  801d71:	3c 40                	cmp    $0x40,%al
  801d73:	7e 48                	jle    801dbd <strtol+0x16b>
  801d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d79:	0f b6 00             	movzbl (%rax),%eax
  801d7c:	3c 5a                	cmp    $0x5a,%al
  801d7e:	7f 3d                	jg     801dbd <strtol+0x16b>
			dig = *s - 'A' + 10;
  801d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d84:	0f b6 00             	movzbl (%rax),%eax
  801d87:	0f be c0             	movsbl %al,%eax
  801d8a:	83 e8 37             	sub    $0x37,%eax
  801d8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d93:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d96:	7c 02                	jl     801d9a <strtol+0x148>
			break;
  801d98:	eb 23                	jmp    801dbd <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d9a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d9f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801da2:	48 98                	cltq   
  801da4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801da9:	48 89 c2             	mov    %rax,%rdx
  801dac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801daf:	48 98                	cltq   
  801db1:	48 01 d0             	add    %rdx,%rax
  801db4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801db8:	e9 5d ff ff ff       	jmpq   801d1a <strtol+0xc8>

	if (endptr)
  801dbd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801dc2:	74 0b                	je     801dcf <strtol+0x17d>
		*endptr = (char *) s;
  801dc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dcc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd3:	74 09                	je     801dde <strtol+0x18c>
  801dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dd9:	48 f7 d8             	neg    %rax
  801ddc:	eb 04                	jmp    801de2 <strtol+0x190>
  801dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801de2:	c9                   	leaveq 
  801de3:	c3                   	retq   

0000000000801de4 <strstr>:

char * strstr(const char *in, const char *str)
{
  801de4:	55                   	push   %rbp
  801de5:	48 89 e5             	mov    %rsp,%rbp
  801de8:	48 83 ec 30          	sub    $0x30,%rsp
  801dec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801df0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801df8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dfc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e00:	0f b6 00             	movzbl (%rax),%eax
  801e03:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801e06:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801e0a:	75 06                	jne    801e12 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801e0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e10:	eb 6b                	jmp    801e7d <strstr+0x99>

    len = strlen(str);
  801e12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e16:	48 89 c7             	mov    %rax,%rdi
  801e19:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
  801e25:	48 98                	cltq   
  801e27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801e2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e37:	0f b6 00             	movzbl (%rax),%eax
  801e3a:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801e3d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e41:	75 07                	jne    801e4a <strstr+0x66>
                return (char *) 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	eb 33                	jmp    801e7d <strstr+0x99>
        } while (sc != c);
  801e4a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e4e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e51:	75 d8                	jne    801e2b <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801e53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e57:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5f:	48 89 ce             	mov    %rcx,%rsi
  801e62:	48 89 c7             	mov    %rax,%rdi
  801e65:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
  801e71:	85 c0                	test   %eax,%eax
  801e73:	75 b6                	jne    801e2b <strstr+0x47>

    return (char *) (in - 1);
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 83 e8 01          	sub    $0x1,%rax
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	53                   	push   %rbx
  801e84:	48 83 ec 48          	sub    $0x48,%rsp
  801e88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e8b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e8e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e92:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e96:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e9a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ea1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ea5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ea9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ead:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801eb1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801eb5:	4c 89 c3             	mov    %r8,%rbx
  801eb8:	cd 30                	int    $0x30
  801eba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801ebe:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ec2:	74 3e                	je     801f02 <syscall+0x83>
  801ec4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ec9:	7e 37                	jle    801f02 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ecb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ecf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ed2:	49 89 d0             	mov    %rdx,%r8
  801ed5:	89 c1                	mov    %eax,%ecx
  801ed7:	48 ba 20 4b 80 00 00 	movabs $0x804b20,%rdx
  801ede:	00 00 00 
  801ee1:	be 23 00 00 00       	mov    $0x23,%esi
  801ee6:	48 bf 3d 4b 80 00 00 	movabs $0x804b3d,%rdi
  801eed:	00 00 00 
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	49 b9 45 07 80 00 00 	movabs $0x800745,%r9
  801efc:	00 00 00 
  801eff:	41 ff d1             	callq  *%r9

	return ret;
  801f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f06:	48 83 c4 48          	add    $0x48,%rsp
  801f0a:	5b                   	pop    %rbx
  801f0b:	5d                   	pop    %rbp
  801f0c:	c3                   	retq   

0000000000801f0d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
  801f11:	48 83 ec 20          	sub    $0x20,%rsp
  801f15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2c:	00 
  801f2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f39:	48 89 d1             	mov    %rdx,%rcx
  801f3c:	48 89 c2             	mov    %rax,%rdx
  801f3f:	be 00 00 00 00       	mov    $0x0,%esi
  801f44:	bf 00 00 00 00       	mov    $0x0,%edi
  801f49:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801f50:	00 00 00 
  801f53:	ff d0                	callq  *%rax
}
  801f55:	c9                   	leaveq 
  801f56:	c3                   	retq   

0000000000801f57 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f57:	55                   	push   %rbp
  801f58:	48 89 e5             	mov    %rsp,%rbp
  801f5b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f66:	00 
  801f67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f78:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7d:	be 00 00 00 00       	mov    $0x0,%esi
  801f82:	bf 01 00 00 00       	mov    $0x1,%edi
  801f87:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	callq  *%rax
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 10          	sub    $0x10,%rsp
  801f9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa3:	48 98                	cltq   
  801fa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fac:	00 
  801fad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	be 01 00 00 00       	mov    $0x1,%esi
  801fc6:	bf 03 00 00 00       	mov    $0x3,%edi
  801fcb:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
}
  801fd7:	c9                   	leaveq 
  801fd8:	c3                   	retq   

0000000000801fd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801fe1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fe8:	00 
  801fe9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  801fff:	be 00 00 00 00       	mov    $0x0,%esi
  802004:	bf 02 00 00 00       	mov    $0x2,%edi
  802009:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <sys_yield>:

void
sys_yield(void)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80201f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802026:	00 
  802027:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80202d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802033:	b9 00 00 00 00       	mov    $0x0,%ecx
  802038:	ba 00 00 00 00       	mov    $0x0,%edx
  80203d:	be 00 00 00 00       	mov    $0x0,%esi
  802042:	bf 0b 00 00 00       	mov    $0xb,%edi
  802047:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
}
  802053:	c9                   	leaveq 
  802054:	c3                   	retq   

0000000000802055 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802055:	55                   	push   %rbp
  802056:	48 89 e5             	mov    %rsp,%rbp
  802059:	48 83 ec 20          	sub    $0x20,%rsp
  80205d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802060:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802064:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802067:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80206a:	48 63 c8             	movslq %eax,%rcx
  80206d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802074:	48 98                	cltq   
  802076:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80207d:	00 
  80207e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802084:	49 89 c8             	mov    %rcx,%r8
  802087:	48 89 d1             	mov    %rdx,%rcx
  80208a:	48 89 c2             	mov    %rax,%rdx
  80208d:	be 01 00 00 00       	mov    $0x1,%esi
  802092:	bf 04 00 00 00       	mov    $0x4,%edi
  802097:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
}
  8020a3:	c9                   	leaveq 
  8020a4:	c3                   	retq   

00000000008020a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	48 83 ec 30          	sub    $0x30,%rsp
  8020ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020b7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020bb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8020bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020c2:	48 63 c8             	movslq %eax,%rcx
  8020c5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cc:	48 63 f0             	movslq %eax,%rsi
  8020cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d6:	48 98                	cltq   
  8020d8:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020dc:	49 89 f9             	mov    %rdi,%r9
  8020df:	49 89 f0             	mov    %rsi,%r8
  8020e2:	48 89 d1             	mov    %rdx,%rcx
  8020e5:	48 89 c2             	mov    %rax,%rdx
  8020e8:	be 01 00 00 00       	mov    $0x1,%esi
  8020ed:	bf 05 00 00 00       	mov    $0x5,%edi
  8020f2:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 20          	sub    $0x20,%rsp
  802108:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80210b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80210f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802116:	48 98                	cltq   
  802118:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211f:	00 
  802120:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802126:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212c:	48 89 d1             	mov    %rdx,%rcx
  80212f:	48 89 c2             	mov    %rax,%rdx
  802132:	be 01 00 00 00       	mov    $0x1,%esi
  802137:	bf 06 00 00 00       	mov    $0x6,%edi
  80213c:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
}
  802148:	c9                   	leaveq 
  802149:	c3                   	retq   

000000000080214a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80214a:	55                   	push   %rbp
  80214b:	48 89 e5             	mov    %rsp,%rbp
  80214e:	48 83 ec 10          	sub    $0x10,%rsp
  802152:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802155:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802158:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80215b:	48 63 d0             	movslq %eax,%rdx
  80215e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802161:	48 98                	cltq   
  802163:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80216a:	00 
  80216b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802171:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802177:	48 89 d1             	mov    %rdx,%rcx
  80217a:	48 89 c2             	mov    %rax,%rdx
  80217d:	be 01 00 00 00       	mov    $0x1,%esi
  802182:	bf 08 00 00 00       	mov    $0x8,%edi
  802187:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
}
  802193:	c9                   	leaveq 
  802194:	c3                   	retq   

0000000000802195 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	48 83 ec 20          	sub    $0x20,%rsp
  80219d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8021a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ab:	48 98                	cltq   
  8021ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021b4:	00 
  8021b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021c1:	48 89 d1             	mov    %rdx,%rcx
  8021c4:	48 89 c2             	mov    %rax,%rdx
  8021c7:	be 01 00 00 00       	mov    $0x1,%esi
  8021cc:	bf 09 00 00 00       	mov    $0x9,%edi
  8021d1:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
}
  8021dd:	c9                   	leaveq 
  8021de:	c3                   	retq   

00000000008021df <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021df:	55                   	push   %rbp
  8021e0:	48 89 e5             	mov    %rsp,%rbp
  8021e3:	48 83 ec 20          	sub    $0x20,%rsp
  8021e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021fe:	00 
  8021ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802205:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80220b:	48 89 d1             	mov    %rdx,%rcx
  80220e:	48 89 c2             	mov    %rax,%rdx
  802211:	be 01 00 00 00       	mov    $0x1,%esi
  802216:	bf 0a 00 00 00       	mov    $0xa,%edi
  80221b:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax
}
  802227:	c9                   	leaveq 
  802228:	c3                   	retq   

0000000000802229 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802229:	55                   	push   %rbp
  80222a:	48 89 e5             	mov    %rsp,%rbp
  80222d:	48 83 ec 20          	sub    $0x20,%rsp
  802231:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802234:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802238:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80223c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80223f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802242:	48 63 f0             	movslq %eax,%rsi
  802245:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224c:	48 98                	cltq   
  80224e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802252:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802259:	00 
  80225a:	49 89 f1             	mov    %rsi,%r9
  80225d:	49 89 c8             	mov    %rcx,%r8
  802260:	48 89 d1             	mov    %rdx,%rcx
  802263:	48 89 c2             	mov    %rax,%rdx
  802266:	be 00 00 00 00       	mov    $0x0,%esi
  80226b:	bf 0c 00 00 00       	mov    $0xc,%edi
  802270:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax
}
  80227c:	c9                   	leaveq 
  80227d:	c3                   	retq   

000000000080227e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80227e:	55                   	push   %rbp
  80227f:	48 89 e5             	mov    %rsp,%rbp
  802282:	48 83 ec 10          	sub    $0x10,%rsp
  802286:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80228a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802295:	00 
  802296:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80229c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022a7:	48 89 c2             	mov    %rax,%rdx
  8022aa:	be 01 00 00 00       	mov    $0x1,%esi
  8022af:	bf 0d 00 00 00       	mov    $0xd,%edi
  8022b4:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
}
  8022c0:	c9                   	leaveq 
  8022c1:	c3                   	retq   

00000000008022c2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022c2:	55                   	push   %rbp
  8022c3:	48 89 e5             	mov    %rsp,%rbp
  8022c6:	48 83 ec 08          	sub    $0x8,%rsp
  8022ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022d2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022d9:	ff ff ff 
  8022dc:	48 01 d0             	add    %rdx,%rax
  8022df:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 08          	sub    $0x8,%rsp
  8022ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8022f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f5:	48 89 c7             	mov    %rax,%rdi
  8022f8:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  8022ff:	00 00 00 
  802302:	ff d0                	callq  *%rax
  802304:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80230a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80230e:	c9                   	leaveq 
  80230f:	c3                   	retq   

0000000000802310 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 83 ec 18          	sub    $0x18,%rsp
  802318:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80231c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802323:	eb 6b                	jmp    802390 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802325:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802328:	48 98                	cltq   
  80232a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802330:	48 c1 e0 0c          	shl    $0xc,%rax
  802334:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233c:	48 c1 e8 15          	shr    $0x15,%rax
  802340:	48 89 c2             	mov    %rax,%rdx
  802343:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80234a:	01 00 00 
  80234d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802351:	83 e0 01             	and    $0x1,%eax
  802354:	48 85 c0             	test   %rax,%rax
  802357:	74 21                	je     80237a <fd_alloc+0x6a>
  802359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235d:	48 c1 e8 0c          	shr    $0xc,%rax
  802361:	48 89 c2             	mov    %rax,%rdx
  802364:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236b:	01 00 00 
  80236e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802372:	83 e0 01             	and    $0x1,%eax
  802375:	48 85 c0             	test   %rax,%rax
  802378:	75 12                	jne    80238c <fd_alloc+0x7c>
			*fd_store = fd;
  80237a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802382:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	eb 1a                	jmp    8023a6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80238c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802390:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802394:	7e 8f                	jle    802325 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023a1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023a6:	c9                   	leaveq 
  8023a7:	c3                   	retq   

00000000008023a8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023a8:	55                   	push   %rbp
  8023a9:	48 89 e5             	mov    %rsp,%rbp
  8023ac:	48 83 ec 20          	sub    $0x20,%rsp
  8023b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023bb:	78 06                	js     8023c3 <fd_lookup+0x1b>
  8023bd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023c1:	7e 07                	jle    8023ca <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023c8:	eb 6c                	jmp    802436 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023cd:	48 98                	cltq   
  8023cf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023d5:	48 c1 e0 0c          	shl    $0xc,%rax
  8023d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8023dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e1:	48 c1 e8 15          	shr    $0x15,%rax
  8023e5:	48 89 c2             	mov    %rax,%rdx
  8023e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023ef:	01 00 00 
  8023f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f6:	83 e0 01             	and    $0x1,%eax
  8023f9:	48 85 c0             	test   %rax,%rax
  8023fc:	74 21                	je     80241f <fd_lookup+0x77>
  8023fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802402:	48 c1 e8 0c          	shr    $0xc,%rax
  802406:	48 89 c2             	mov    %rax,%rdx
  802409:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802410:	01 00 00 
  802413:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802417:	83 e0 01             	and    $0x1,%eax
  80241a:	48 85 c0             	test   %rax,%rax
  80241d:	75 07                	jne    802426 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80241f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802424:	eb 10                	jmp    802436 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802426:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80242a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80242e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
  80243c:	48 83 ec 30          	sub    $0x30,%rsp
  802440:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802444:	89 f0                	mov    %esi,%eax
  802446:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244d:	48 89 c7             	mov    %rax,%rdi
  802450:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
  80245c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802460:	48 89 d6             	mov    %rdx,%rsi
  802463:	89 c7                	mov    %eax,%edi
  802465:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	callq  *%rax
  802471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802478:	78 0a                	js     802484 <fd_close+0x4c>
	    || fd != fd2)
  80247a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802482:	74 12                	je     802496 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802484:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802488:	74 05                	je     80248f <fd_close+0x57>
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248d:	eb 05                	jmp    802494 <fd_close+0x5c>
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	eb 69                	jmp    8024ff <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802496:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80249a:	8b 00                	mov    (%rax),%eax
  80249c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	78 2a                	js     8024e4 <fd_close+0xac>
		if (dev->dev_close)
  8024ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024be:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024c2:	48 85 c0             	test   %rax,%rax
  8024c5:	74 16                	je     8024dd <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024d3:	48 89 d7             	mov    %rdx,%rdi
  8024d6:	ff d0                	callq  *%rax
  8024d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024db:	eb 07                	jmp    8024e4 <fd_close+0xac>
		else
			r = 0;
  8024dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8024e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e8:	48 89 c6             	mov    %rax,%rsi
  8024eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f0:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
	return r;
  8024fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024ff:	c9                   	leaveq 
  802500:	c3                   	retq   

0000000000802501 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802501:	55                   	push   %rbp
  802502:	48 89 e5             	mov    %rsp,%rbp
  802505:	48 83 ec 20          	sub    $0x20,%rsp
  802509:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80250c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802510:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802517:	eb 41                	jmp    80255a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802519:	48 b8 e0 77 80 00 00 	movabs $0x8077e0,%rax
  802520:	00 00 00 
  802523:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802526:	48 63 d2             	movslq %edx,%rdx
  802529:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252d:	8b 00                	mov    (%rax),%eax
  80252f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802532:	75 22                	jne    802556 <dev_lookup+0x55>
			*dev = devtab[i];
  802534:	48 b8 e0 77 80 00 00 	movabs $0x8077e0,%rax
  80253b:	00 00 00 
  80253e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802541:	48 63 d2             	movslq %edx,%rdx
  802544:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802548:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80254c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	eb 60                	jmp    8025b6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802556:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80255a:	48 b8 e0 77 80 00 00 	movabs $0x8077e0,%rax
  802561:	00 00 00 
  802564:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802567:	48 63 d2             	movslq %edx,%rdx
  80256a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256e:	48 85 c0             	test   %rax,%rax
  802571:	75 a6                	jne    802519 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802573:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80257a:	00 00 00 
  80257d:	48 8b 00             	mov    (%rax),%rax
  802580:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802586:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802589:	89 c6                	mov    %eax,%esi
  80258b:	48 bf 50 4b 80 00 00 	movabs $0x804b50,%rdi
  802592:	00 00 00 
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  8025a1:	00 00 00 
  8025a4:	ff d1                	callq  *%rcx
	*dev = 0;
  8025a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025aa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025b6:	c9                   	leaveq 
  8025b7:	c3                   	retq   

00000000008025b8 <close>:

int
close(int fdnum)
{
  8025b8:	55                   	push   %rbp
  8025b9:	48 89 e5             	mov    %rsp,%rbp
  8025bc:	48 83 ec 20          	sub    $0x20,%rsp
  8025c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ca:	48 89 d6             	mov    %rdx,%rsi
  8025cd:	89 c7                	mov    %eax,%edi
  8025cf:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
  8025db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e2:	79 05                	jns    8025e9 <close+0x31>
		return r;
  8025e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e7:	eb 18                	jmp    802601 <close+0x49>
	else
		return fd_close(fd, 1);
  8025e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ed:	be 01 00 00 00       	mov    $0x1,%esi
  8025f2:	48 89 c7             	mov    %rax,%rdi
  8025f5:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
}
  802601:	c9                   	leaveq 
  802602:	c3                   	retq   

0000000000802603 <close_all>:

void
close_all(void)
{
  802603:	55                   	push   %rbp
  802604:	48 89 e5             	mov    %rsp,%rbp
  802607:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80260b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802612:	eb 15                	jmp    802629 <close_all+0x26>
		close(i);
  802614:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802617:	89 c7                	mov    %eax,%edi
  802619:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  802620:	00 00 00 
  802623:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802625:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802629:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80262d:	7e e5                	jle    802614 <close_all+0x11>
		close(i);
}
  80262f:	c9                   	leaveq 
  802630:	c3                   	retq   

0000000000802631 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	48 83 ec 40          	sub    $0x40,%rsp
  802639:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80263c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80263f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802643:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802646:	48 89 d6             	mov    %rdx,%rsi
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	79 08                	jns    802668 <dup+0x37>
		return r;
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	e9 70 01 00 00       	jmpq   8027d8 <dup+0x1a7>
	close(newfdnum);
  802668:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80266b:	89 c7                	mov    %eax,%edi
  80266d:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  802674:	00 00 00 
  802677:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802679:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80267c:	48 98                	cltq   
  80267e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802684:	48 c1 e0 0c          	shl    $0xc,%rax
  802688:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80268c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802690:	48 89 c7             	mov    %rax,%rdi
  802693:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a7:	48 89 c7             	mov    %rax,%rdi
  8026aa:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026be:	48 c1 e8 15          	shr    $0x15,%rax
  8026c2:	48 89 c2             	mov    %rax,%rdx
  8026c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026cc:	01 00 00 
  8026cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d3:	83 e0 01             	and    $0x1,%eax
  8026d6:	48 85 c0             	test   %rax,%rax
  8026d9:	74 73                	je     80274e <dup+0x11d>
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	48 c1 e8 0c          	shr    $0xc,%rax
  8026e3:	48 89 c2             	mov    %rax,%rdx
  8026e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ed:	01 00 00 
  8026f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f4:	83 e0 01             	and    $0x1,%eax
  8026f7:	48 85 c0             	test   %rax,%rax
  8026fa:	74 52                	je     80274e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802700:	48 c1 e8 0c          	shr    $0xc,%rax
  802704:	48 89 c2             	mov    %rax,%rdx
  802707:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80270e:	01 00 00 
  802711:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802715:	25 07 0e 00 00       	and    $0xe07,%eax
  80271a:	89 c1                	mov    %eax,%ecx
  80271c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802724:	41 89 c8             	mov    %ecx,%r8d
  802727:	48 89 d1             	mov    %rdx,%rcx
  80272a:	ba 00 00 00 00       	mov    $0x0,%edx
  80272f:	48 89 c6             	mov    %rax,%rsi
  802732:	bf 00 00 00 00       	mov    $0x0,%edi
  802737:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
  802743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802746:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274a:	79 02                	jns    80274e <dup+0x11d>
			goto err;
  80274c:	eb 57                	jmp    8027a5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80274e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802752:	48 c1 e8 0c          	shr    $0xc,%rax
  802756:	48 89 c2             	mov    %rax,%rdx
  802759:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802760:	01 00 00 
  802763:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802767:	25 07 0e 00 00       	and    $0xe07,%eax
  80276c:	89 c1                	mov    %eax,%ecx
  80276e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802772:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802776:	41 89 c8             	mov    %ecx,%r8d
  802779:	48 89 d1             	mov    %rdx,%rcx
  80277c:	ba 00 00 00 00       	mov    $0x0,%edx
  802781:	48 89 c6             	mov    %rax,%rsi
  802784:	bf 00 00 00 00       	mov    $0x0,%edi
  802789:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  802790:	00 00 00 
  802793:	ff d0                	callq  *%rax
  802795:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802798:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279c:	79 02                	jns    8027a0 <dup+0x16f>
		goto err;
  80279e:	eb 05                	jmp    8027a5 <dup+0x174>

	return newfdnum;
  8027a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027a3:	eb 33                	jmp    8027d8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a9:	48 89 c6             	mov    %rax,%rsi
  8027ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b1:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c1:	48 89 c6             	mov    %rax,%rsi
  8027c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c9:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8027d0:	00 00 00 
  8027d3:	ff d0                	callq  *%rax
	return r;
  8027d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 40          	sub    $0x40,%rsp
  8027e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027f4:	48 89 d6             	mov    %rdx,%rsi
  8027f7:	89 c7                	mov    %eax,%edi
  8027f9:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
  802805:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802808:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280c:	78 24                	js     802832 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80280e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802812:	8b 00                	mov    (%rax),%eax
  802814:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802818:	48 89 d6             	mov    %rdx,%rsi
  80281b:	89 c7                	mov    %eax,%edi
  80281d:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
  802829:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802830:	79 05                	jns    802837 <read+0x5d>
		return r;
  802832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802835:	eb 76                	jmp    8028ad <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283b:	8b 40 08             	mov    0x8(%rax),%eax
  80283e:	83 e0 03             	and    $0x3,%eax
  802841:	83 f8 01             	cmp    $0x1,%eax
  802844:	75 3a                	jne    802880 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802846:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80284d:	00 00 00 
  802850:	48 8b 00             	mov    (%rax),%rax
  802853:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802859:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80285c:	89 c6                	mov    %eax,%esi
  80285e:	48 bf 6f 4b 80 00 00 	movabs $0x804b6f,%rdi
  802865:	00 00 00 
  802868:	b8 00 00 00 00       	mov    $0x0,%eax
  80286d:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  802874:	00 00 00 
  802877:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802879:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80287e:	eb 2d                	jmp    8028ad <read+0xd3>
	}
	if (!dev->dev_read)
  802880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802884:	48 8b 40 10          	mov    0x10(%rax),%rax
  802888:	48 85 c0             	test   %rax,%rax
  80288b:	75 07                	jne    802894 <read+0xba>
		return -E_NOT_SUPP;
  80288d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802892:	eb 19                	jmp    8028ad <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802898:	48 8b 40 10          	mov    0x10(%rax),%rax
  80289c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028a4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028a8:	48 89 cf             	mov    %rcx,%rdi
  8028ab:	ff d0                	callq  *%rax
}
  8028ad:	c9                   	leaveq 
  8028ae:	c3                   	retq   

00000000008028af <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028af:	55                   	push   %rbp
  8028b0:	48 89 e5             	mov    %rsp,%rbp
  8028b3:	48 83 ec 30          	sub    $0x30,%rsp
  8028b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028c9:	eb 49                	jmp    802914 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ce:	48 98                	cltq   
  8028d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d4:	48 29 c2             	sub    %rax,%rdx
  8028d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028da:	48 63 c8             	movslq %eax,%rcx
  8028dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e1:	48 01 c1             	add    %rax,%rcx
  8028e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e7:	48 89 ce             	mov    %rcx,%rsi
  8028ea:	89 c7                	mov    %eax,%edi
  8028ec:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
  8028f8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8028fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028ff:	79 05                	jns    802906 <readn+0x57>
			return m;
  802901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802904:	eb 1c                	jmp    802922 <readn+0x73>
		if (m == 0)
  802906:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80290a:	75 02                	jne    80290e <readn+0x5f>
			break;
  80290c:	eb 11                	jmp    80291f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80290e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802911:	01 45 fc             	add    %eax,-0x4(%rbp)
  802914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802917:	48 98                	cltq   
  802919:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80291d:	72 ac                	jb     8028cb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80291f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802922:	c9                   	leaveq 
  802923:	c3                   	retq   

0000000000802924 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802924:	55                   	push   %rbp
  802925:	48 89 e5             	mov    %rsp,%rbp
  802928:	48 83 ec 40          	sub    $0x40,%rsp
  80292c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80292f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802933:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802937:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80293b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80293e:	48 89 d6             	mov    %rdx,%rsi
  802941:	89 c7                	mov    %eax,%edi
  802943:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802956:	78 24                	js     80297c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295c:	8b 00                	mov    (%rax),%eax
  80295e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802962:	48 89 d6             	mov    %rdx,%rsi
  802965:	89 c7                	mov    %eax,%edi
  802967:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
  802973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297a:	79 05                	jns    802981 <write+0x5d>
		return r;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297f:	eb 75                	jmp    8029f6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802985:	8b 40 08             	mov    0x8(%rax),%eax
  802988:	83 e0 03             	and    $0x3,%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	75 3a                	jne    8029c9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80298f:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802996:	00 00 00 
  802999:	48 8b 00             	mov    (%rax),%rax
  80299c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029a5:	89 c6                	mov    %eax,%esi
  8029a7:	48 bf 8b 4b 80 00 00 	movabs $0x804b8b,%rdi
  8029ae:	00 00 00 
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b6:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  8029bd:	00 00 00 
  8029c0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c7:	eb 2d                	jmp    8029f6 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029d1:	48 85 c0             	test   %rax,%rax
  8029d4:	75 07                	jne    8029dd <write+0xb9>
		return -E_NOT_SUPP;
  8029d6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029db:	eb 19                	jmp    8029f6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8029dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029e5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029ed:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029f1:	48 89 cf             	mov    %rcx,%rdi
  8029f4:	ff d0                	callq  *%rax
}
  8029f6:	c9                   	leaveq 
  8029f7:	c3                   	retq   

00000000008029f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8029f8:	55                   	push   %rbp
  8029f9:	48 89 e5             	mov    %rsp,%rbp
  8029fc:	48 83 ec 18          	sub    $0x18,%rsp
  802a00:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a03:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a06:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a0d:	48 89 d6             	mov    %rdx,%rsi
  802a10:	89 c7                	mov    %eax,%edi
  802a12:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a25:	79 05                	jns    802a2c <seek+0x34>
		return r;
  802a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2a:	eb 0f                	jmp    802a3b <seek+0x43>
	fd->fd_offset = offset;
  802a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a30:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3b:	c9                   	leaveq 
  802a3c:	c3                   	retq   

0000000000802a3d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a3d:	55                   	push   %rbp
  802a3e:	48 89 e5             	mov    %rsp,%rbp
  802a41:	48 83 ec 30          	sub    $0x30,%rsp
  802a45:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a48:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a4b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a4f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a52:	48 89 d6             	mov    %rdx,%rsi
  802a55:	89 c7                	mov    %eax,%edi
  802a57:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
  802a63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6a:	78 24                	js     802a90 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a70:	8b 00                	mov    (%rax),%eax
  802a72:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a76:	48 89 d6             	mov    %rdx,%rsi
  802a79:	89 c7                	mov    %eax,%edi
  802a7b:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
  802a87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8e:	79 05                	jns    802a95 <ftruncate+0x58>
		return r;
  802a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a93:	eb 72                	jmp    802b07 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a99:	8b 40 08             	mov    0x8(%rax),%eax
  802a9c:	83 e0 03             	and    $0x3,%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	75 3a                	jne    802add <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802aa3:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  802aaa:	00 00 00 
  802aad:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ab0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ab9:	89 c6                	mov    %eax,%esi
  802abb:	48 bf a8 4b 80 00 00 	movabs $0x804ba8,%rdi
  802ac2:	00 00 00 
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aca:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  802ad1:	00 00 00 
  802ad4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ad6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802adb:	eb 2a                	jmp    802b07 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ae5:	48 85 c0             	test   %rax,%rax
  802ae8:	75 07                	jne    802af1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802aea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aef:	eb 16                	jmp    802b07 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802af1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802af9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802afd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b00:	89 ce                	mov    %ecx,%esi
  802b02:	48 89 d7             	mov    %rdx,%rdi
  802b05:	ff d0                	callq  *%rax
}
  802b07:	c9                   	leaveq 
  802b08:	c3                   	retq   

0000000000802b09 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b09:	55                   	push   %rbp
  802b0a:	48 89 e5             	mov    %rsp,%rbp
  802b0d:	48 83 ec 30          	sub    $0x30,%rsp
  802b11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b14:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b18:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b1c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b1f:	48 89 d6             	mov    %rdx,%rsi
  802b22:	89 c7                	mov    %eax,%edi
  802b24:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
  802b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b37:	78 24                	js     802b5d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3d:	8b 00                	mov    (%rax),%eax
  802b3f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b43:	48 89 d6             	mov    %rdx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 01 25 80 00 00 	movabs $0x802501,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	79 05                	jns    802b62 <fstat+0x59>
		return r;
  802b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b60:	eb 5e                	jmp    802bc0 <fstat+0xb7>
	if (!dev->dev_stat)
  802b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b66:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b6a:	48 85 c0             	test   %rax,%rax
  802b6d:	75 07                	jne    802b76 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b6f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b74:	eb 4a                	jmp    802bc0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b7a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b81:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b88:	00 00 00 
	stat->st_isdir = 0;
  802b8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b8f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b96:	00 00 00 
	stat->st_dev = dev;
  802b99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bac:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bb8:	48 89 ce             	mov    %rcx,%rsi
  802bbb:	48 89 d7             	mov    %rdx,%rdi
  802bbe:	ff d0                	callq  *%rax
}
  802bc0:	c9                   	leaveq 
  802bc1:	c3                   	retq   

0000000000802bc2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802bc2:	55                   	push   %rbp
  802bc3:	48 89 e5             	mov    %rsp,%rbp
  802bc6:	48 83 ec 20          	sub    $0x20,%rsp
  802bca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd6:	be 00 00 00 00       	mov    $0x0,%esi
  802bdb:	48 89 c7             	mov    %rax,%rdi
  802bde:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802be5:	00 00 00 
  802be8:	ff d0                	callq  *%rax
  802bea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf1:	79 05                	jns    802bf8 <stat+0x36>
		return fd;
  802bf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf6:	eb 2f                	jmp    802c27 <stat+0x65>
	r = fstat(fd, stat);
  802bf8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bff:	48 89 d6             	mov    %rdx,%rsi
  802c02:	89 c7                	mov    %eax,%edi
  802c04:	48 b8 09 2b 80 00 00 	movabs $0x802b09,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c16:	89 c7                	mov    %eax,%edi
  802c18:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	callq  *%rax
	return r;
  802c24:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c27:	c9                   	leaveq 
  802c28:	c3                   	retq   

0000000000802c29 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c29:	55                   	push   %rbp
  802c2a:	48 89 e5             	mov    %rsp,%rbp
  802c2d:	48 83 ec 10          	sub    $0x10,%rsp
  802c31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c38:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  802c3f:	00 00 00 
  802c42:	8b 00                	mov    (%rax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	75 1d                	jne    802c65 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c48:	bf 01 00 00 00       	mov    $0x1,%edi
  802c4d:	48 b8 f5 43 80 00 00 	movabs $0x8043f5,%rax
  802c54:	00 00 00 
  802c57:	ff d0                	callq  *%rax
  802c59:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  802c60:	00 00 00 
  802c63:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c65:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  802c6c:	00 00 00 
  802c6f:	8b 00                	mov    (%rax),%eax
  802c71:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c74:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c79:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802c80:	00 00 00 
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 5d 43 80 00 00 	movabs $0x80435d,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c95:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9a:	48 89 c6             	mov    %rax,%rsi
  802c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca2:	48 b8 94 42 80 00 00 	movabs $0x804294,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 20          	sub    $0x20,%rsp
  802cb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cbc:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802cbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc3:	48 89 c7             	mov    %rax,%rdi
  802cc6:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	callq  *%rax
  802cd2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cd7:	7e 0a                	jle    802ce3 <open+0x33>
		return -E_BAD_PATH;
  802cd9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cde:	e9 a5 00 00 00       	jmpq   802d88 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ce3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ce7:	48 89 c7             	mov    %rax,%rdi
  802cea:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfd:	79 08                	jns    802d07 <open+0x57>
		return r;
  802cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d02:	e9 81 00 00 00       	jmpq   802d88 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0b:	48 89 c6             	mov    %rax,%rsi
  802d0e:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802d15:	00 00 00 
  802d18:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802d24:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d2b:	00 00 00 
  802d2e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d31:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3b:	48 89 c6             	mov    %rax,%rsi
  802d3e:	bf 01 00 00 00       	mov    $0x1,%edi
  802d43:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
  802d4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d56:	79 1d                	jns    802d75 <open+0xc5>
		fd_close(fd, 0);
  802d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5c:	be 00 00 00 00       	mov    $0x0,%esi
  802d61:	48 89 c7             	mov    %rax,%rdi
  802d64:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
		return r;
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d73:	eb 13                	jmp    802d88 <open+0xd8>
	}

	return fd2num(fd);
  802d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d79:	48 89 c7             	mov    %rax,%rdi
  802d7c:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802d88:	c9                   	leaveq 
  802d89:	c3                   	retq   

0000000000802d8a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d8a:	55                   	push   %rbp
  802d8b:	48 89 e5             	mov    %rsp,%rbp
  802d8e:	48 83 ec 10          	sub    $0x10,%rsp
  802d92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9a:	8b 50 0c             	mov    0xc(%rax),%edx
  802d9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802da4:	00 00 00 
  802da7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802da9:	be 00 00 00 00       	mov    $0x0,%esi
  802dae:	bf 06 00 00 00       	mov    $0x6,%edi
  802db3:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
}
  802dbf:	c9                   	leaveq 
  802dc0:	c3                   	retq   

0000000000802dc1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802dc1:	55                   	push   %rbp
  802dc2:	48 89 e5             	mov    %rsp,%rbp
  802dc5:	48 83 ec 30          	sub    $0x30,%rsp
  802dc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd9:	8b 50 0c             	mov    0xc(%rax),%edx
  802ddc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802de3:	00 00 00 
  802de6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802de8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802def:	00 00 00 
  802df2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802df6:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802dfa:	be 00 00 00 00       	mov    $0x0,%esi
  802dff:	bf 03 00 00 00       	mov    $0x3,%edi
  802e04:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
  802e10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e17:	79 05                	jns    802e1e <devfile_read+0x5d>
		return r;
  802e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1c:	eb 26                	jmp    802e44 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	48 63 d0             	movslq %eax,%rdx
  802e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e28:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802e2f:	00 00 00 
  802e32:	48 89 c7             	mov    %rax,%rdi
  802e35:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  802e3c:	00 00 00 
  802e3f:	ff d0                	callq  *%rax

	return r;
  802e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e44:	c9                   	leaveq 
  802e45:	c3                   	retq   

0000000000802e46 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e46:	55                   	push   %rbp
  802e47:	48 89 e5             	mov    %rsp,%rbp
  802e4a:	48 83 ec 30          	sub    $0x30,%rsp
  802e4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802e5a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e61:	00 
  802e62:	76 08                	jbe    802e6c <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802e64:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e6b:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e70:	8b 50 0c             	mov    0xc(%rax),%edx
  802e73:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e7a:	00 00 00 
  802e7d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802e7f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e86:	00 00 00 
  802e89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802e91:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e99:	48 89 c6             	mov    %rax,%rsi
  802e9c:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802ea3:	00 00 00 
  802ea6:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802eb2:	be 00 00 00 00       	mov    $0x0,%esi
  802eb7:	bf 04 00 00 00       	mov    $0x4,%edi
  802ebc:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	79 05                	jns    802ed6 <devfile_write+0x90>
		return r;
  802ed1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed4:	eb 03                	jmp    802ed9 <devfile_write+0x93>

	return r;
  802ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ed9:	c9                   	leaveq 
  802eda:	c3                   	retq   

0000000000802edb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802edb:	55                   	push   %rbp
  802edc:	48 89 e5             	mov    %rsp,%rbp
  802edf:	48 83 ec 20          	sub    $0x20,%rsp
  802ee3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eef:	8b 50 0c             	mov    0xc(%rax),%edx
  802ef2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ef9:	00 00 00 
  802efc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802efe:	be 00 00 00 00       	mov    $0x0,%esi
  802f03:	bf 05 00 00 00       	mov    $0x5,%edi
  802f08:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
  802f14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1b:	79 05                	jns    802f22 <devfile_stat+0x47>
		return r;
  802f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f20:	eb 56                	jmp    802f78 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f26:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802f2d:	00 00 00 
  802f30:	48 89 c7             	mov    %rax,%rdi
  802f33:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f3f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f46:	00 00 00 
  802f49:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f53:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f59:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f60:	00 00 00 
  802f63:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f6d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f78:	c9                   	leaveq 
  802f79:	c3                   	retq   

0000000000802f7a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f7a:	55                   	push   %rbp
  802f7b:	48 89 e5             	mov    %rsp,%rbp
  802f7e:	48 83 ec 10          	sub    $0x10,%rsp
  802f82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f86:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f90:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f97:	00 00 00 
  802f9a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f9c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fa3:	00 00 00 
  802fa6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fa9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fac:	be 00 00 00 00       	mov    $0x0,%esi
  802fb1:	bf 02 00 00 00       	mov    $0x2,%edi
  802fb6:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	callq  *%rax
}
  802fc2:	c9                   	leaveq 
  802fc3:	c3                   	retq   

0000000000802fc4 <remove>:

// Delete a file
int
remove(const char *path)
{
  802fc4:	55                   	push   %rbp
  802fc5:	48 89 e5             	mov    %rsp,%rbp
  802fc8:	48 83 ec 10          	sub    $0x10,%rsp
  802fcc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd4:	48 89 c7             	mov    %rax,%rdi
  802fd7:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
  802fe3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fe8:	7e 07                	jle    802ff1 <remove+0x2d>
		return -E_BAD_PATH;
  802fea:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fef:	eb 33                	jmp    803024 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff5:	48 89 c6             	mov    %rax,%rsi
  802ff8:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802fff:	00 00 00 
  803002:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80300e:	be 00 00 00 00       	mov    $0x0,%esi
  803013:	bf 07 00 00 00       	mov    $0x7,%edi
  803018:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
}
  803024:	c9                   	leaveq 
  803025:	c3                   	retq   

0000000000803026 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803026:	55                   	push   %rbp
  803027:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80302a:	be 00 00 00 00       	mov    $0x0,%esi
  80302f:	bf 08 00 00 00       	mov    $0x8,%edi
  803034:	48 b8 29 2c 80 00 00 	movabs $0x802c29,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
}
  803040:	5d                   	pop    %rbp
  803041:	c3                   	retq   

0000000000803042 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80304d:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803054:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80305b:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803062:	be 00 00 00 00       	mov    $0x0,%esi
  803067:	48 89 c7             	mov    %rax,%rdi
  80306a:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
  803076:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803079:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80307d:	79 08                	jns    803087 <spawn+0x45>
		return r;
  80307f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803082:	e9 14 03 00 00       	jmpq   80339b <spawn+0x359>
	fd = r;
  803087:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80308a:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  80308d:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803094:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803098:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80309f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030a2:	ba 00 02 00 00       	mov    $0x200,%edx
  8030a7:	48 89 ce             	mov    %rcx,%rsi
  8030aa:	89 c7                	mov    %eax,%edi
  8030ac:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
  8030b8:	3d 00 02 00 00       	cmp    $0x200,%eax
  8030bd:	75 0d                	jne    8030cc <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  8030bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c3:	8b 00                	mov    (%rax),%eax
  8030c5:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8030ca:	74 43                	je     80310f <spawn+0xcd>
		close(fd);
  8030cc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030cf:	89 c7                	mov    %eax,%edi
  8030d1:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8030dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e1:	8b 00                	mov    (%rax),%eax
  8030e3:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8030e8:	89 c6                	mov    %eax,%esi
  8030ea:	48 bf d0 4b 80 00 00 	movabs $0x804bd0,%rdi
  8030f1:	00 00 00 
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	48 b9 7e 09 80 00 00 	movabs $0x80097e,%rcx
  803100:	00 00 00 
  803103:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803105:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80310a:	e9 8c 02 00 00       	jmpq   80339b <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80310f:	b8 07 00 00 00       	mov    $0x7,%eax
  803114:	cd 30                	int    $0x30
  803116:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803119:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80311c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80311f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803123:	79 08                	jns    80312d <spawn+0xeb>
		return r;
  803125:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803128:	e9 6e 02 00 00       	jmpq   80339b <spawn+0x359>
	child = r;
  80312d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803130:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803133:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803136:	25 ff 03 00 00       	and    $0x3ff,%eax
  80313b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803142:	00 00 00 
  803145:	48 63 d0             	movslq %eax,%rdx
  803148:	48 89 d0             	mov    %rdx,%rax
  80314b:	48 c1 e0 03          	shl    $0x3,%rax
  80314f:	48 01 d0             	add    %rdx,%rax
  803152:	48 c1 e0 05          	shl    $0x5,%rax
  803156:	48 01 c8             	add    %rcx,%rax
  803159:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803160:	48 89 c6             	mov    %rax,%rsi
  803163:	b8 18 00 00 00       	mov    $0x18,%eax
  803168:	48 89 d7             	mov    %rdx,%rdi
  80316b:	48 89 c1             	mov    %rax,%rcx
  80316e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803171:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803175:	48 8b 40 18          	mov    0x18(%rax),%rax
  803179:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803180:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803187:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80318e:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  803195:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803198:	48 89 ce             	mov    %rcx,%rsi
  80319b:	89 c7                	mov    %eax,%edi
  80319d:	48 b8 05 36 80 00 00 	movabs $0x803605,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
  8031a9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031b0:	79 08                	jns    8031ba <spawn+0x178>
		return r;
  8031b2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031b5:	e9 e1 01 00 00       	jmpq   80339b <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8031ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031be:	48 8b 40 20          	mov    0x20(%rax),%rax
  8031c2:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8031c9:	48 01 d0             	add    %rdx,%rax
  8031cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8031d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031d7:	e9 a3 00 00 00       	jmpq   80327f <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8031dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e0:	8b 00                	mov    (%rax),%eax
  8031e2:	83 f8 01             	cmp    $0x1,%eax
  8031e5:	74 05                	je     8031ec <spawn+0x1aa>
			continue;
  8031e7:	e9 8a 00 00 00       	jmpq   803276 <spawn+0x234>
		perm = PTE_P | PTE_U;
  8031ec:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8031f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f7:	8b 40 04             	mov    0x4(%rax),%eax
  8031fa:	83 e0 02             	and    $0x2,%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	74 04                	je     803205 <spawn+0x1c3>
			perm |= PTE_W;
  803201:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80320d:	41 89 c1             	mov    %eax,%r9d
  803210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803214:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803224:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803228:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80322b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80322e:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803231:	89 3c 24             	mov    %edi,(%rsp)
  803234:	89 c7                	mov    %eax,%edi
  803236:	48 b8 ae 38 80 00 00 	movabs $0x8038ae,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803245:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803249:	79 2b                	jns    803276 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80324b:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80324c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80324f:	89 c7                	mov    %eax,%edi
  803251:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
	close(fd);
  80325d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803260:	89 c7                	mov    %eax,%edi
  803262:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
	return r;
  80326e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803271:	e9 25 01 00 00       	jmpq   80339b <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803276:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80327a:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80327f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803283:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803287:	0f b7 c0             	movzwl %ax,%eax
  80328a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80328d:	0f 8f 49 ff ff ff    	jg     8031dc <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803293:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803296:	89 c7                	mov    %eax,%edi
  803298:	48 b8 b8 25 80 00 00 	movabs $0x8025b8,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
	fd = -1;
  8032a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8032ab:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032ae:	89 c7                	mov    %eax,%edi
  8032b0:	48 b8 9a 3a 80 00 00 	movabs $0x803a9a,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
  8032bc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032c3:	79 30                	jns    8032f5 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8032c5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032c8:	89 c1                	mov    %eax,%ecx
  8032ca:	48 ba ea 4b 80 00 00 	movabs $0x804bea,%rdx
  8032d1:	00 00 00 
  8032d4:	be 82 00 00 00       	mov    $0x82,%esi
  8032d9:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  8032e0:	00 00 00 
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  8032ef:	00 00 00 
  8032f2:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8032f5:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8032fc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032ff:	48 89 d6             	mov    %rdx,%rsi
  803302:	89 c7                	mov    %eax,%edi
  803304:	48 b8 95 21 80 00 00 	movabs $0x802195,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
  803310:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803313:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803317:	79 30                	jns    803349 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803319:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80331c:	89 c1                	mov    %eax,%ecx
  80331e:	48 ba 0c 4c 80 00 00 	movabs $0x804c0c,%rdx
  803325:	00 00 00 
  803328:	be 85 00 00 00       	mov    $0x85,%esi
  80332d:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  803334:	00 00 00 
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
  80333c:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  803343:	00 00 00 
  803346:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803349:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80334c:	be 02 00 00 00       	mov    $0x2,%esi
  803351:	89 c7                	mov    %eax,%edi
  803353:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  80335a:	00 00 00 
  80335d:	ff d0                	callq  *%rax
  80335f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803362:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803366:	79 30                	jns    803398 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803368:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80336b:	89 c1                	mov    %eax,%ecx
  80336d:	48 ba 26 4c 80 00 00 	movabs $0x804c26,%rdx
  803374:	00 00 00 
  803377:	be 88 00 00 00       	mov    $0x88,%esi
  80337c:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  803383:	00 00 00 
  803386:	b8 00 00 00 00       	mov    $0x0,%eax
  80338b:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  803392:	00 00 00 
  803395:	41 ff d0             	callq  *%r8

	return child;
  803398:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	41 55                	push   %r13
  8033a3:	41 54                	push   %r12
  8033a5:	53                   	push   %rbx
  8033a6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8033ad:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8033b4:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8033bb:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8033c2:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8033c9:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8033d0:	84 c0                	test   %al,%al
  8033d2:	74 26                	je     8033fa <spawnl+0x5d>
  8033d4:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8033db:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8033e2:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8033e6:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8033ea:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8033ee:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8033f2:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8033f6:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8033fa:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803401:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803408:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80340b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803412:	00 00 00 
  803415:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80341c:	00 00 00 
  80341f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803423:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80342a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803431:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  803438:	eb 07                	jmp    803441 <spawnl+0xa4>
		argc++;
  80343a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  803441:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803447:	83 f8 30             	cmp    $0x30,%eax
  80344a:	73 23                	jae    80346f <spawnl+0xd2>
  80344c:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803453:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803459:	89 c0                	mov    %eax,%eax
  80345b:	48 01 d0             	add    %rdx,%rax
  80345e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803464:	83 c2 08             	add    $0x8,%edx
  803467:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80346d:	eb 15                	jmp    803484 <spawnl+0xe7>
  80346f:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803476:	48 89 d0             	mov    %rdx,%rax
  803479:	48 83 c2 08          	add    $0x8,%rdx
  80347d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803484:	48 8b 00             	mov    (%rax),%rax
  803487:	48 85 c0             	test   %rax,%rax
  80348a:	75 ae                	jne    80343a <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  80348c:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803492:	83 c0 02             	add    $0x2,%eax
  803495:	48 89 e2             	mov    %rsp,%rdx
  803498:	48 89 d3             	mov    %rdx,%rbx
  80349b:	48 63 d0             	movslq %eax,%rdx
  80349e:	48 83 ea 01          	sub    $0x1,%rdx
  8034a2:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8034a9:	48 63 d0             	movslq %eax,%rdx
  8034ac:	49 89 d4             	mov    %rdx,%r12
  8034af:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8034b5:	48 63 d0             	movslq %eax,%rdx
  8034b8:	49 89 d2             	mov    %rdx,%r10
  8034bb:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8034c1:	48 98                	cltq   
  8034c3:	48 c1 e0 03          	shl    $0x3,%rax
  8034c7:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8034cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8034d0:	48 83 e8 01          	sub    $0x1,%rax
  8034d4:	48 01 d0             	add    %rdx,%rax
  8034d7:	bf 10 00 00 00       	mov    $0x10,%edi
  8034dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e1:	48 f7 f7             	div    %rdi
  8034e4:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8034e8:	48 29 c4             	sub    %rax,%rsp
  8034eb:	48 89 e0             	mov    %rsp,%rax
  8034ee:	48 83 c0 07          	add    $0x7,%rax
  8034f2:	48 c1 e8 03          	shr    $0x3,%rax
  8034f6:	48 c1 e0 03          	shl    $0x3,%rax
  8034fa:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803501:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803508:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80350f:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803512:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803518:	8d 50 01             	lea    0x1(%rax),%edx
  80351b:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803522:	48 63 d2             	movslq %edx,%rdx
  803525:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80352c:	00 

	va_start(vl, arg0);
  80352d:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803534:	00 00 00 
  803537:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80353e:	00 00 00 
  803541:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803545:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80354c:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803553:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  80355a:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803561:	00 00 00 
  803564:	eb 63                	jmp    8035c9 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803566:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  80356c:	8d 70 01             	lea    0x1(%rax),%esi
  80356f:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803575:	83 f8 30             	cmp    $0x30,%eax
  803578:	73 23                	jae    80359d <spawnl+0x200>
  80357a:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803581:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803587:	89 c0                	mov    %eax,%eax
  803589:	48 01 d0             	add    %rdx,%rax
  80358c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803592:	83 c2 08             	add    $0x8,%edx
  803595:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80359b:	eb 15                	jmp    8035b2 <spawnl+0x215>
  80359d:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8035a4:	48 89 d0             	mov    %rdx,%rax
  8035a7:	48 83 c2 08          	add    $0x8,%rdx
  8035ab:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035b2:	48 8b 08             	mov    (%rax),%rcx
  8035b5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8035bc:	89 f2                	mov    %esi,%edx
  8035be:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  8035c2:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8035c9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035cf:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8035d5:	77 8f                	ja     803566 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8035d7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035de:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8035e5:	48 89 d6             	mov    %rdx,%rsi
  8035e8:	48 89 c7             	mov    %rax,%rdi
  8035eb:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8035f2:	00 00 00 
  8035f5:	ff d0                	callq  *%rax
  8035f7:	48 89 dc             	mov    %rbx,%rsp
}
  8035fa:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8035fe:	5b                   	pop    %rbx
  8035ff:	41 5c                	pop    %r12
  803601:	41 5d                	pop    %r13
  803603:	5d                   	pop    %rbp
  803604:	c3                   	retq   

0000000000803605 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803605:	55                   	push   %rbp
  803606:	48 89 e5             	mov    %rsp,%rbp
  803609:	48 83 ec 50          	sub    $0x50,%rsp
  80360d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803610:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803614:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803618:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80361f:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803620:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803627:	eb 33                	jmp    80365c <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803629:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80362c:	48 98                	cltq   
  80362e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803635:	00 
  803636:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80363a:	48 01 d0             	add    %rdx,%rax
  80363d:	48 8b 00             	mov    (%rax),%rax
  803640:	48 89 c7             	mov    %rax,%rdi
  803643:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	83 c0 01             	add    $0x1,%eax
  803652:	48 98                	cltq   
  803654:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803658:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80365c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80365f:	48 98                	cltq   
  803661:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803668:	00 
  803669:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80366d:	48 01 d0             	add    %rdx,%rax
  803670:	48 8b 00             	mov    (%rax),%rax
  803673:	48 85 c0             	test   %rax,%rax
  803676:	75 b1                	jne    803629 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367c:	48 f7 d8             	neg    %rax
  80367f:	48 05 00 10 40 00    	add    $0x401000,%rax
  803685:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803695:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803699:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80369c:	83 c2 01             	add    $0x1,%edx
  80369f:	c1 e2 03             	shl    $0x3,%edx
  8036a2:	48 63 d2             	movslq %edx,%rdx
  8036a5:	48 f7 da             	neg    %rdx
  8036a8:	48 01 d0             	add    %rdx,%rax
  8036ab:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8036af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b3:	48 83 e8 10          	sub    $0x10,%rax
  8036b7:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8036bd:	77 0a                	ja     8036c9 <init_stack+0xc4>
		return -E_NO_MEM;
  8036bf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8036c4:	e9 e3 01 00 00       	jmpq   8038ac <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8036c9:	ba 07 00 00 00       	mov    $0x7,%edx
  8036ce:	be 00 00 40 00       	mov    $0x400000,%esi
  8036d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d8:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036eb:	79 08                	jns    8036f5 <init_stack+0xf0>
		return r;
  8036ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f0:	e9 b7 01 00 00       	jmpq   8038ac <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8036f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8036fc:	e9 8a 00 00 00       	jmpq   80378b <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803701:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803704:	48 98                	cltq   
  803706:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80370d:	00 
  80370e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803712:	48 01 c2             	add    %rax,%rdx
  803715:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80371a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371e:	48 01 c8             	add    %rcx,%rax
  803721:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803727:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80372a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80372d:	48 98                	cltq   
  80372f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803736:	00 
  803737:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80373b:	48 01 d0             	add    %rdx,%rax
  80373e:	48 8b 10             	mov    (%rax),%rdx
  803741:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803745:	48 89 d6             	mov    %rdx,%rsi
  803748:	48 89 c7             	mov    %rax,%rdi
  80374b:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  803752:	00 00 00 
  803755:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803757:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80375a:	48 98                	cltq   
  80375c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803763:	00 
  803764:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803768:	48 01 d0             	add    %rdx,%rax
  80376b:	48 8b 00             	mov    (%rax),%rax
  80376e:	48 89 c7             	mov    %rax,%rdi
  803771:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
  80377d:	48 98                	cltq   
  80377f:	48 83 c0 01          	add    $0x1,%rax
  803783:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803787:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80378b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80378e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803791:	0f 8c 6a ff ff ff    	jl     803701 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803797:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80379a:	48 98                	cltq   
  80379c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037a3:	00 
  8037a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a8:	48 01 d0             	add    %rdx,%rax
  8037ab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8037b2:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8037b9:	00 
  8037ba:	74 35                	je     8037f1 <init_stack+0x1ec>
  8037bc:	48 b9 40 4c 80 00 00 	movabs $0x804c40,%rcx
  8037c3:	00 00 00 
  8037c6:	48 ba 66 4c 80 00 00 	movabs $0x804c66,%rdx
  8037cd:	00 00 00 
  8037d0:	be f1 00 00 00       	mov    $0xf1,%esi
  8037d5:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  8037dc:	00 00 00 
  8037df:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e4:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  8037eb:	00 00 00 
  8037ee:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8037f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f5:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8037f9:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8037fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803802:	48 01 c8             	add    %rcx,%rax
  803805:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80380b:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80380e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803812:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803816:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803819:	48 98                	cltq   
  80381b:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80381e:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803823:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803827:	48 01 d0             	add    %rdx,%rax
  80382a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803830:	48 89 c2             	mov    %rax,%rdx
  803833:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803837:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80383a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80383d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803843:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803848:	89 c2                	mov    %eax,%edx
  80384a:	be 00 00 40 00       	mov    $0x400000,%esi
  80384f:	bf 00 00 00 00       	mov    $0x0,%edi
  803854:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803863:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803867:	79 02                	jns    80386b <init_stack+0x266>
		goto error;
  803869:	eb 28                	jmp    803893 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80386b:	be 00 00 40 00       	mov    $0x400000,%esi
  803870:	bf 00 00 00 00       	mov    $0x0,%edi
  803875:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80387c:	00 00 00 
  80387f:	ff d0                	callq  *%rax
  803881:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803884:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803888:	79 02                	jns    80388c <init_stack+0x287>
		goto error;
  80388a:	eb 07                	jmp    803893 <init_stack+0x28e>

	return 0;
  80388c:	b8 00 00 00 00       	mov    $0x0,%eax
  803891:	eb 19                	jmp    8038ac <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803893:	be 00 00 40 00       	mov    $0x400000,%esi
  803898:	bf 00 00 00 00       	mov    $0x0,%edi
  80389d:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
	return r;
  8038a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038ac:	c9                   	leaveq 
  8038ad:	c3                   	retq   

00000000008038ae <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8038ae:	55                   	push   %rbp
  8038af:	48 89 e5             	mov    %rsp,%rbp
  8038b2:	48 83 ec 50          	sub    $0x50,%rsp
  8038b6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8038b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038bd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8038c1:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8038c4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8038c8:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8038cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8038d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038dc:	74 21                	je     8038ff <map_segment+0x51>
		va -= i;
  8038de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e1:	48 98                	cltq   
  8038e3:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	48 98                	cltq   
  8038ec:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	48 98                	cltq   
  8038f5:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8038f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fc:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8038ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803906:	e9 79 01 00 00       	jmpq   803a84 <map_segment+0x1d6>
		if (i >= filesz) {
  80390b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80390e:	48 98                	cltq   
  803910:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803914:	72 3c                	jb     803952 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803916:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803919:	48 63 d0             	movslq %eax,%rdx
  80391c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803920:	48 01 d0             	add    %rdx,%rax
  803923:	48 89 c1             	mov    %rax,%rcx
  803926:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803929:	8b 55 10             	mov    0x10(%rbp),%edx
  80392c:	48 89 ce             	mov    %rcx,%rsi
  80392f:	89 c7                	mov    %eax,%edi
  803931:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  803938:	00 00 00 
  80393b:	ff d0                	callq  *%rax
  80393d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803940:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803944:	0f 89 33 01 00 00    	jns    803a7d <map_segment+0x1cf>
				return r;
  80394a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80394d:	e9 46 01 00 00       	jmpq   803a98 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803952:	ba 07 00 00 00       	mov    $0x7,%edx
  803957:	be 00 00 40 00       	mov    $0x400000,%esi
  80395c:	bf 00 00 00 00       	mov    $0x0,%edi
  803961:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  803968:	00 00 00 
  80396b:	ff d0                	callq  *%rax
  80396d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803970:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803974:	79 08                	jns    80397e <map_segment+0xd0>
				return r;
  803976:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803979:	e9 1a 01 00 00       	jmpq   803a98 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80397e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803981:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803984:	01 c2                	add    %eax,%edx
  803986:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803989:	89 d6                	mov    %edx,%esi
  80398b:	89 c7                	mov    %eax,%edi
  80398d:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
  803999:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80399c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039a0:	79 08                	jns    8039aa <map_segment+0xfc>
				return r;
  8039a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039a5:	e9 ee 00 00 00       	jmpq   803a98 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8039aa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8039b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b4:	48 98                	cltq   
  8039b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039ba:	48 29 c2             	sub    %rax,%rdx
  8039bd:	48 89 d0             	mov    %rdx,%rax
  8039c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8039c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039c7:	48 63 d0             	movslq %eax,%rdx
  8039ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ce:	48 39 c2             	cmp    %rax,%rdx
  8039d1:	48 0f 47 d0          	cmova  %rax,%rdx
  8039d5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039d8:	be 00 00 40 00       	mov    $0x400000,%esi
  8039dd:	89 c7                	mov    %eax,%edi
  8039df:	48 b8 af 28 80 00 00 	movabs $0x8028af,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
  8039eb:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8039ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8039f2:	79 08                	jns    8039fc <map_segment+0x14e>
				return r;
  8039f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f7:	e9 9c 00 00 00       	jmpq   803a98 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8039fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ff:	48 63 d0             	movslq %eax,%rdx
  803a02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a06:	48 01 d0             	add    %rdx,%rax
  803a09:	48 89 c2             	mov    %rax,%rdx
  803a0c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a0f:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803a13:	48 89 d1             	mov    %rdx,%rcx
  803a16:	89 c2                	mov    %eax,%edx
  803a18:	be 00 00 40 00       	mov    $0x400000,%esi
  803a1d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a22:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
  803a2e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a31:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a35:	79 30                	jns    803a67 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803a37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a3a:	89 c1                	mov    %eax,%ecx
  803a3c:	48 ba 7b 4c 80 00 00 	movabs $0x804c7b,%rdx
  803a43:	00 00 00 
  803a46:	be 24 01 00 00       	mov    $0x124,%esi
  803a4b:	48 bf 00 4c 80 00 00 	movabs $0x804c00,%rdi
  803a52:	00 00 00 
  803a55:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5a:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  803a61:	00 00 00 
  803a64:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803a67:	be 00 00 40 00       	mov    $0x400000,%esi
  803a6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a71:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a7d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a87:	48 98                	cltq   
  803a89:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a8d:	0f 82 78 fe ff ff    	jb     80390b <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a98:	c9                   	leaveq 
  803a99:	c3                   	retq   

0000000000803a9a <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803a9a:	55                   	push   %rbp
  803a9b:	48 89 e5             	mov    %rsp,%rbp
  803a9e:	48 83 ec 50          	sub    $0x50,%rsp
  803aa2:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  803aa5:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803aac:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803aad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ab4:	00 
  803ab5:	e9 62 01 00 00       	jmpq   803c1c <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803aba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803abe:	48 c1 e8 1b          	shr    $0x1b,%rax
  803ac2:	48 89 c2             	mov    %rax,%rdx
  803ac5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803acc:	01 00 00 
  803acf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ad3:	83 e0 01             	and    $0x1,%eax
  803ad6:	48 85 c0             	test   %rax,%rax
  803ad9:	75 0d                	jne    803ae8 <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  803adb:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  803ae2:	08 
			continue;
  803ae3:	e9 2f 01 00 00       	jmpq   803c17 <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803ae8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803aef:	00 
  803af0:	e9 14 01 00 00       	jmpq   803c09 <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af9:	48 c1 e8 12          	shr    $0x12,%rax
  803afd:	48 89 c2             	mov    %rax,%rdx
  803b00:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803b07:	01 00 00 
  803b0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b0e:	83 e0 01             	and    $0x1,%eax
  803b11:	48 85 c0             	test   %rax,%rax
  803b14:	75 0d                	jne    803b23 <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  803b16:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  803b1d:	00 
				continue;
  803b1e:	e9 e1 00 00 00       	jmpq   803c04 <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803b23:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803b2a:	00 
  803b2b:	e9 c6 00 00 00       	jmpq   803bf6 <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  803b30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b34:	48 c1 e8 09          	shr    $0x9,%rax
  803b38:	48 89 c2             	mov    %rax,%rdx
  803b3b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b42:	01 00 00 
  803b45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b49:	83 e0 01             	and    $0x1,%eax
  803b4c:	48 85 c0             	test   %rax,%rax
  803b4f:	75 0d                	jne    803b5e <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  803b51:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  803b58:	00 
					continue;
  803b59:	e9 93 00 00 00       	jmpq   803bf1 <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803b5e:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803b65:	00 
  803b66:	eb 7b                	jmp    803be3 <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  803b68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b6f:	01 00 00 
  803b72:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b7a:	25 00 04 00 00       	and    $0x400,%eax
  803b7f:	48 85 c0             	test   %rax,%rax
  803b82:	74 55                	je     803bd9 <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  803b84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b88:	48 c1 e0 0c          	shl    $0xc,%rax
  803b8c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  803b90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b97:	01 00 00 
  803b9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ba2:	25 07 0e 00 00       	and    $0xe07,%eax
  803ba7:	89 c6                	mov    %eax,%esi
  803ba9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803bad:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803bb0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb4:	41 89 f0             	mov    %esi,%r8d
  803bb7:	48 89 c6             	mov    %rax,%rsi
  803bba:	bf 00 00 00 00       	mov    $0x0,%edi
  803bbf:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  803bc6:	00 00 00 
  803bc9:	ff d0                	callq  *%rax
  803bcb:	89 45 cc             	mov    %eax,-0x34(%rbp)
  803bce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803bd2:	79 05                	jns    803bd9 <copy_shared_pages+0x13f>
							return r;
  803bd4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803bd7:	eb 53                	jmp    803c2c <copy_shared_pages+0x192>
					}
					ptx++;
  803bd9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803bde:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803be3:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803bea:	00 
  803beb:	0f 86 77 ff ff ff    	jbe    803b68 <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803bf1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803bf6:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803bfd:	00 
  803bfe:	0f 86 2c ff ff ff    	jbe    803b30 <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803c04:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803c09:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803c10:	00 
  803c11:	0f 86 de fe ff ff    	jbe    803af5 <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803c17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c1c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c21:	0f 84 93 fe ff ff    	je     803aba <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  803c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2c:	c9                   	leaveq 
  803c2d:	c3                   	retq   

0000000000803c2e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c2e:	55                   	push   %rbp
  803c2f:	48 89 e5             	mov    %rsp,%rbp
  803c32:	53                   	push   %rbx
  803c33:	48 83 ec 38          	sub    $0x38,%rsp
  803c37:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c3b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c3f:	48 89 c7             	mov    %rax,%rdi
  803c42:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
  803c4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c55:	0f 88 bf 01 00 00    	js     803e1a <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c5f:	ba 07 04 00 00       	mov    $0x407,%edx
  803c64:	48 89 c6             	mov    %rax,%rsi
  803c67:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6c:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
  803c78:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c7f:	0f 88 95 01 00 00    	js     803e1a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c85:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c89:	48 89 c7             	mov    %rax,%rdi
  803c8c:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  803c93:	00 00 00 
  803c96:	ff d0                	callq  *%rax
  803c98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c9f:	0f 88 5d 01 00 00    	js     803e02 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca9:	ba 07 04 00 00       	mov    $0x407,%edx
  803cae:	48 89 c6             	mov    %rax,%rsi
  803cb1:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb6:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  803cbd:	00 00 00 
  803cc0:	ff d0                	callq  *%rax
  803cc2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cc9:	0f 88 33 01 00 00    	js     803e02 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ccf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd3:	48 89 c7             	mov    %rax,%rdi
  803cd6:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  803cdd:	00 00 00 
  803ce0:	ff d0                	callq  *%rax
  803ce2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ce6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cea:	ba 07 04 00 00       	mov    $0x407,%edx
  803cef:	48 89 c6             	mov    %rax,%rsi
  803cf2:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf7:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  803cfe:	00 00 00 
  803d01:	ff d0                	callq  *%rax
  803d03:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d06:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d0a:	79 05                	jns    803d11 <pipe+0xe3>
		goto err2;
  803d0c:	e9 d9 00 00 00       	jmpq   803dea <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d15:	48 89 c7             	mov    %rax,%rdi
  803d18:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  803d1f:	00 00 00 
  803d22:	ff d0                	callq  *%rax
  803d24:	48 89 c2             	mov    %rax,%rdx
  803d27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d31:	48 89 d1             	mov    %rdx,%rcx
  803d34:	ba 00 00 00 00       	mov    $0x0,%edx
  803d39:	48 89 c6             	mov    %rax,%rsi
  803d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d41:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
  803d4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d54:	79 1b                	jns    803d71 <pipe+0x143>
		goto err3;
  803d56:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d5b:	48 89 c6             	mov    %rax,%rsi
  803d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d63:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
  803d6f:	eb 79                	jmp    803dea <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 ba 40 78 80 00 00 	movabs $0x807840,%rdx
  803d7c:	00 00 00 
  803d7f:	8b 12                	mov    (%rdx),%edx
  803d81:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d92:	48 ba 40 78 80 00 00 	movabs $0x807840,%rdx
  803d99:	00 00 00 
  803d9c:	8b 12                	mov    (%rdx),%edx
  803d9e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803da0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803dab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803daf:	48 89 c7             	mov    %rax,%rdi
  803db2:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
  803dbe:	89 c2                	mov    %eax,%edx
  803dc0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dc4:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803dc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dca:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803dce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dd2:	48 89 c7             	mov    %rax,%rdi
  803dd5:	48 b8 c2 22 80 00 00 	movabs $0x8022c2,%rax
  803ddc:	00 00 00 
  803ddf:	ff d0                	callq  *%rax
  803de1:	89 03                	mov    %eax,(%rbx)
	return 0;
  803de3:	b8 00 00 00 00       	mov    $0x0,%eax
  803de8:	eb 33                	jmp    803e1d <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803dea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dee:	48 89 c6             	mov    %rax,%rsi
  803df1:	bf 00 00 00 00       	mov    $0x0,%edi
  803df6:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  803dfd:	00 00 00 
  803e00:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803e02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e06:	48 89 c6             	mov    %rax,%rsi
  803e09:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0e:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
    err:
	return r;
  803e1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e1d:	48 83 c4 38          	add    $0x38,%rsp
  803e21:	5b                   	pop    %rbx
  803e22:	5d                   	pop    %rbp
  803e23:	c3                   	retq   

0000000000803e24 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e24:	55                   	push   %rbp
  803e25:	48 89 e5             	mov    %rsp,%rbp
  803e28:	53                   	push   %rbx
  803e29:	48 83 ec 28          	sub    $0x28,%rsp
  803e2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e35:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e3c:	00 00 00 
  803e3f:	48 8b 00             	mov    (%rax),%rax
  803e42:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e48:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e4f:	48 89 c7             	mov    %rax,%rdi
  803e52:	48 b8 77 44 80 00 00 	movabs $0x804477,%rax
  803e59:	00 00 00 
  803e5c:	ff d0                	callq  *%rax
  803e5e:	89 c3                	mov    %eax,%ebx
  803e60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e64:	48 89 c7             	mov    %rax,%rdi
  803e67:	48 b8 77 44 80 00 00 	movabs $0x804477,%rax
  803e6e:	00 00 00 
  803e71:	ff d0                	callq  *%rax
  803e73:	39 c3                	cmp    %eax,%ebx
  803e75:	0f 94 c0             	sete   %al
  803e78:	0f b6 c0             	movzbl %al,%eax
  803e7b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e7e:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803e85:	00 00 00 
  803e88:	48 8b 00             	mov    (%rax),%rax
  803e8b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e91:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e97:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e9a:	75 05                	jne    803ea1 <_pipeisclosed+0x7d>
			return ret;
  803e9c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e9f:	eb 4f                	jmp    803ef0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ea4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ea7:	74 42                	je     803eeb <_pipeisclosed+0xc7>
  803ea9:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ead:	75 3c                	jne    803eeb <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803eaf:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  803eb6:	00 00 00 
  803eb9:	48 8b 00             	mov    (%rax),%rax
  803ebc:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ec2:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ec5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec8:	89 c6                	mov    %eax,%esi
  803eca:	48 bf 9d 4c 80 00 00 	movabs $0x804c9d,%rdi
  803ed1:	00 00 00 
  803ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed9:	49 b8 7e 09 80 00 00 	movabs $0x80097e,%r8
  803ee0:	00 00 00 
  803ee3:	41 ff d0             	callq  *%r8
	}
  803ee6:	e9 4a ff ff ff       	jmpq   803e35 <_pipeisclosed+0x11>
  803eeb:	e9 45 ff ff ff       	jmpq   803e35 <_pipeisclosed+0x11>
}
  803ef0:	48 83 c4 28          	add    $0x28,%rsp
  803ef4:	5b                   	pop    %rbx
  803ef5:	5d                   	pop    %rbp
  803ef6:	c3                   	retq   

0000000000803ef7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ef7:	55                   	push   %rbp
  803ef8:	48 89 e5             	mov    %rsp,%rbp
  803efb:	48 83 ec 30          	sub    $0x30,%rsp
  803eff:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f02:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f06:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f09:	48 89 d6             	mov    %rdx,%rsi
  803f0c:	89 c7                	mov    %eax,%edi
  803f0e:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  803f15:	00 00 00 
  803f18:	ff d0                	callq  *%rax
  803f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f21:	79 05                	jns    803f28 <pipeisclosed+0x31>
		return r;
  803f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f26:	eb 31                	jmp    803f59 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2c:	48 89 c7             	mov    %rax,%rdi
  803f2f:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  803f36:	00 00 00 
  803f39:	ff d0                	callq  *%rax
  803f3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f47:	48 89 d6             	mov    %rdx,%rsi
  803f4a:	48 89 c7             	mov    %rax,%rdi
  803f4d:	48 b8 24 3e 80 00 00 	movabs $0x803e24,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
}
  803f59:	c9                   	leaveq 
  803f5a:	c3                   	retq   

0000000000803f5b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f5b:	55                   	push   %rbp
  803f5c:	48 89 e5             	mov    %rsp,%rbp
  803f5f:	48 83 ec 40          	sub    $0x40,%rsp
  803f63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f6b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
  803f82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f8e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f95:	00 
  803f96:	e9 92 00 00 00       	jmpq   80402d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f9b:	eb 41                	jmp    803fde <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f9d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fa2:	74 09                	je     803fad <devpipe_read+0x52>
				return i;
  803fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa8:	e9 92 00 00 00       	jmpq   80403f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803fad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb5:	48 89 d6             	mov    %rdx,%rsi
  803fb8:	48 89 c7             	mov    %rax,%rdi
  803fbb:	48 b8 24 3e 80 00 00 	movabs $0x803e24,%rax
  803fc2:	00 00 00 
  803fc5:	ff d0                	callq  *%rax
  803fc7:	85 c0                	test   %eax,%eax
  803fc9:	74 07                	je     803fd2 <devpipe_read+0x77>
				return 0;
  803fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd0:	eb 6d                	jmp    80403f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803fd2:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe2:	8b 10                	mov    (%rax),%edx
  803fe4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe8:	8b 40 04             	mov    0x4(%rax),%eax
  803feb:	39 c2                	cmp    %eax,%edx
  803fed:	74 ae                	je     803f9d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ff7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fff:	8b 00                	mov    (%rax),%eax
  804001:	99                   	cltd   
  804002:	c1 ea 1b             	shr    $0x1b,%edx
  804005:	01 d0                	add    %edx,%eax
  804007:	83 e0 1f             	and    $0x1f,%eax
  80400a:	29 d0                	sub    %edx,%eax
  80400c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804010:	48 98                	cltq   
  804012:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804017:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80401d:	8b 00                	mov    (%rax),%eax
  80401f:	8d 50 01             	lea    0x1(%rax),%edx
  804022:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804026:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804028:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80402d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804031:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804035:	0f 82 60 ff ff ff    	jb     803f9b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80403b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80403f:	c9                   	leaveq 
  804040:	c3                   	retq   

0000000000804041 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804041:	55                   	push   %rbp
  804042:	48 89 e5             	mov    %rsp,%rbp
  804045:	48 83 ec 40          	sub    $0x40,%rsp
  804049:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80404d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804051:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804059:	48 89 c7             	mov    %rax,%rdi
  80405c:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  804063:	00 00 00 
  804066:	ff d0                	callq  *%rax
  804068:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80406c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804070:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804074:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80407b:	00 
  80407c:	e9 8e 00 00 00       	jmpq   80410f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804081:	eb 31                	jmp    8040b4 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804083:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804087:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408b:	48 89 d6             	mov    %rdx,%rsi
  80408e:	48 89 c7             	mov    %rax,%rdi
  804091:	48 b8 24 3e 80 00 00 	movabs $0x803e24,%rax
  804098:	00 00 00 
  80409b:	ff d0                	callq  *%rax
  80409d:	85 c0                	test   %eax,%eax
  80409f:	74 07                	je     8040a8 <devpipe_write+0x67>
				return 0;
  8040a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a6:	eb 79                	jmp    804121 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040a8:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  8040af:	00 00 00 
  8040b2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b8:	8b 40 04             	mov    0x4(%rax),%eax
  8040bb:	48 63 d0             	movslq %eax,%rdx
  8040be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c2:	8b 00                	mov    (%rax),%eax
  8040c4:	48 98                	cltq   
  8040c6:	48 83 c0 20          	add    $0x20,%rax
  8040ca:	48 39 c2             	cmp    %rax,%rdx
  8040cd:	73 b4                	jae    804083 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8040cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d3:	8b 40 04             	mov    0x4(%rax),%eax
  8040d6:	99                   	cltd   
  8040d7:	c1 ea 1b             	shr    $0x1b,%edx
  8040da:	01 d0                	add    %edx,%eax
  8040dc:	83 e0 1f             	and    $0x1f,%eax
  8040df:	29 d0                	sub    %edx,%eax
  8040e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8040e5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040e9:	48 01 ca             	add    %rcx,%rdx
  8040ec:	0f b6 0a             	movzbl (%rdx),%ecx
  8040ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f3:	48 98                	cltq   
  8040f5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fd:	8b 40 04             	mov    0x4(%rax),%eax
  804100:	8d 50 01             	lea    0x1(%rax),%edx
  804103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804107:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80410a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80410f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804113:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804117:	0f 82 64 ff ff ff    	jb     804081 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80411d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804121:	c9                   	leaveq 
  804122:	c3                   	retq   

0000000000804123 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804123:	55                   	push   %rbp
  804124:	48 89 e5             	mov    %rsp,%rbp
  804127:	48 83 ec 20          	sub    $0x20,%rsp
  80412b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80412f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804137:	48 89 c7             	mov    %rax,%rdi
  80413a:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
  804146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80414a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80414e:	48 be b0 4c 80 00 00 	movabs $0x804cb0,%rsi
  804155:	00 00 00 
  804158:	48 89 c7             	mov    %rax,%rdi
  80415b:	48 b8 26 17 80 00 00 	movabs $0x801726,%rax
  804162:	00 00 00 
  804165:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416b:	8b 50 04             	mov    0x4(%rax),%edx
  80416e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804172:	8b 00                	mov    (%rax),%eax
  804174:	29 c2                	sub    %eax,%edx
  804176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80417a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804180:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804184:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80418b:	00 00 00 
	stat->st_dev = &devpipe;
  80418e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804192:	48 b9 40 78 80 00 00 	movabs $0x807840,%rcx
  804199:	00 00 00 
  80419c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8041a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a8:	c9                   	leaveq 
  8041a9:	c3                   	retq   

00000000008041aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041aa:	55                   	push   %rbp
  8041ab:	48 89 e5             	mov    %rsp,%rbp
  8041ae:	48 83 ec 10          	sub    $0x10,%rsp
  8041b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8041b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ba:	48 89 c6             	mov    %rax,%rsi
  8041bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c2:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8041c9:	00 00 00 
  8041cc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8041ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d2:	48 89 c7             	mov    %rax,%rdi
  8041d5:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  8041dc:	00 00 00 
  8041df:	ff d0                	callq  *%rax
  8041e1:	48 89 c6             	mov    %rax,%rsi
  8041e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8041e9:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8041f0:	00 00 00 
  8041f3:	ff d0                	callq  *%rax
}
  8041f5:	c9                   	leaveq 
  8041f6:	c3                   	retq   

00000000008041f7 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8041f7:	55                   	push   %rbp
  8041f8:	48 89 e5             	mov    %rsp,%rbp
  8041fb:	48 83 ec 20          	sub    $0x20,%rsp
  8041ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804202:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804206:	75 35                	jne    80423d <wait+0x46>
  804208:	48 b9 b7 4c 80 00 00 	movabs $0x804cb7,%rcx
  80420f:	00 00 00 
  804212:	48 ba c2 4c 80 00 00 	movabs $0x804cc2,%rdx
  804219:	00 00 00 
  80421c:	be 09 00 00 00       	mov    $0x9,%esi
  804221:	48 bf d7 4c 80 00 00 	movabs $0x804cd7,%rdi
  804228:	00 00 00 
  80422b:	b8 00 00 00 00       	mov    $0x0,%eax
  804230:	49 b8 45 07 80 00 00 	movabs $0x800745,%r8
  804237:	00 00 00 
  80423a:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80423d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804240:	25 ff 03 00 00       	and    $0x3ff,%eax
  804245:	48 63 d0             	movslq %eax,%rdx
  804248:	48 89 d0             	mov    %rdx,%rax
  80424b:	48 c1 e0 03          	shl    $0x3,%rax
  80424f:	48 01 d0             	add    %rdx,%rax
  804252:	48 c1 e0 05          	shl    $0x5,%rax
  804256:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80425d:	00 00 00 
  804260:	48 01 d0             	add    %rdx,%rax
  804263:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804267:	eb 0c                	jmp    804275 <wait+0x7e>
		sys_yield();
  804269:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  804270:	00 00 00 
  804273:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804279:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80427f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804282:	75 0e                	jne    804292 <wait+0x9b>
  804284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804288:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80428e:	85 c0                	test   %eax,%eax
  804290:	75 d7                	jne    804269 <wait+0x72>
		sys_yield();
}
  804292:	c9                   	leaveq 
  804293:	c3                   	retq   

0000000000804294 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	48 83 ec 30          	sub    $0x30,%rsp
  80429c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8042a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8042b0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042b5:	75 0e                	jne    8042c5 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8042b7:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8042be:	00 00 00 
  8042c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8042c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c9:	48 89 c7             	mov    %rax,%rdi
  8042cc:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  8042d3:	00 00 00 
  8042d6:	ff d0                	callq  *%rax
  8042d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8042db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8042df:	79 27                	jns    804308 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8042e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042e6:	74 0a                	je     8042f2 <ipc_recv+0x5e>
			*from_env_store = 0;
  8042e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ec:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8042f2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042f7:	74 0a                	je     804303 <ipc_recv+0x6f>
			*perm_store = 0;
  8042f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042fd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804306:	eb 53                	jmp    80435b <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  804308:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80430d:	74 19                	je     804328 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80430f:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804316:	00 00 00 
  804319:	48 8b 00             	mov    (%rax),%rax
  80431c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804326:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  804328:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80432d:	74 19                	je     804348 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80432f:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  804336:	00 00 00 
  804339:	48 8b 00             	mov    (%rax),%rax
  80433c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804346:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  804348:	48 b8 90 97 80 00 00 	movabs $0x809790,%rax
  80434f:	00 00 00 
  804352:	48 8b 00             	mov    (%rax),%rax
  804355:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80435b:	c9                   	leaveq 
  80435c:	c3                   	retq   

000000000080435d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80435d:	55                   	push   %rbp
  80435e:	48 89 e5             	mov    %rsp,%rbp
  804361:	48 83 ec 30          	sub    $0x30,%rsp
  804365:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804368:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80436b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80436f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804376:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80437a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80437f:	75 10                	jne    804391 <ipc_send+0x34>
		page = (void *)KERNBASE;
  804381:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804388:	00 00 00 
  80438b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80438f:	eb 0e                	jmp    80439f <ipc_send+0x42>
  804391:	eb 0c                	jmp    80439f <ipc_send+0x42>
		sys_yield();
  804393:	48 b8 17 20 80 00 00 	movabs $0x802017,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80439f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8043a2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8043a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ac:	89 c7                	mov    %eax,%edi
  8043ae:	48 b8 29 22 80 00 00 	movabs $0x802229,%rax
  8043b5:	00 00 00 
  8043b8:	ff d0                	callq  *%rax
  8043ba:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8043bd:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8043c1:	74 d0                	je     804393 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8043c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8043c7:	74 2a                	je     8043f3 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8043c9:	48 ba e2 4c 80 00 00 	movabs $0x804ce2,%rdx
  8043d0:	00 00 00 
  8043d3:	be 49 00 00 00       	mov    $0x49,%esi
  8043d8:	48 bf fe 4c 80 00 00 	movabs $0x804cfe,%rdi
  8043df:	00 00 00 
  8043e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e7:	48 b9 45 07 80 00 00 	movabs $0x800745,%rcx
  8043ee:	00 00 00 
  8043f1:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8043f3:	c9                   	leaveq 
  8043f4:	c3                   	retq   

00000000008043f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043f5:	55                   	push   %rbp
  8043f6:	48 89 e5             	mov    %rsp,%rbp
  8043f9:	48 83 ec 14          	sub    $0x14,%rsp
  8043fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804407:	eb 5e                	jmp    804467 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804409:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804410:	00 00 00 
  804413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804416:	48 63 d0             	movslq %eax,%rdx
  804419:	48 89 d0             	mov    %rdx,%rax
  80441c:	48 c1 e0 03          	shl    $0x3,%rax
  804420:	48 01 d0             	add    %rdx,%rax
  804423:	48 c1 e0 05          	shl    $0x5,%rax
  804427:	48 01 c8             	add    %rcx,%rax
  80442a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804430:	8b 00                	mov    (%rax),%eax
  804432:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804435:	75 2c                	jne    804463 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804437:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80443e:	00 00 00 
  804441:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804444:	48 63 d0             	movslq %eax,%rdx
  804447:	48 89 d0             	mov    %rdx,%rax
  80444a:	48 c1 e0 03          	shl    $0x3,%rax
  80444e:	48 01 d0             	add    %rdx,%rax
  804451:	48 c1 e0 05          	shl    $0x5,%rax
  804455:	48 01 c8             	add    %rcx,%rax
  804458:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80445e:	8b 40 08             	mov    0x8(%rax),%eax
  804461:	eb 12                	jmp    804475 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804463:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804467:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80446e:	7e 99                	jle    804409 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804470:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804475:	c9                   	leaveq 
  804476:	c3                   	retq   

0000000000804477 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804477:	55                   	push   %rbp
  804478:	48 89 e5             	mov    %rsp,%rbp
  80447b:	48 83 ec 18          	sub    $0x18,%rsp
  80447f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804487:	48 c1 e8 15          	shr    $0x15,%rax
  80448b:	48 89 c2             	mov    %rax,%rdx
  80448e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804495:	01 00 00 
  804498:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449c:	83 e0 01             	and    $0x1,%eax
  80449f:	48 85 c0             	test   %rax,%rax
  8044a2:	75 07                	jne    8044ab <pageref+0x34>
		return 0;
  8044a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a9:	eb 53                	jmp    8044fe <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044af:	48 c1 e8 0c          	shr    $0xc,%rax
  8044b3:	48 89 c2             	mov    %rax,%rdx
  8044b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044bd:	01 00 00 
  8044c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044cc:	83 e0 01             	and    $0x1,%eax
  8044cf:	48 85 c0             	test   %rax,%rax
  8044d2:	75 07                	jne    8044db <pageref+0x64>
		return 0;
  8044d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8044d9:	eb 23                	jmp    8044fe <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044df:	48 c1 e8 0c          	shr    $0xc,%rax
  8044e3:	48 89 c2             	mov    %rax,%rdx
  8044e6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044ed:	00 00 00 
  8044f0:	48 c1 e2 04          	shl    $0x4,%rdx
  8044f4:	48 01 d0             	add    %rdx,%rax
  8044f7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044fb:	0f b7 c0             	movzwl %ax,%eax
}
  8044fe:	c9                   	leaveq 
  8044ff:	c3                   	retq   
