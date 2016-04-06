
obj/user/testkbd.debug:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba c0 3a 80 00 00 	movabs $0x803ac0,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf cd 3a 80 00 00 	movabs $0x803acd,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba dc 3a 80 00 00 	movabs $0x803adc,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf cd 3a 80 00 00 	movabs $0x803acd,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 64 25 80 00 00 	movabs $0x802564,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba f6 3a 80 00 00 	movabs $0x803af6,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf cd 3a 80 00 00 	movabs $0x803acd,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 1e 05 80 00 00 	movabs $0x80051e,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for ( ; ; ) {
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf fe 3a 80 00 00 	movabs $0x803afe,%rdi
  800153:	00 00 00 
  800156:	48 b8 93 14 80 00 00 	movabs $0x801493,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be 0c 3b 80 00 00 	movabs $0x803b0c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 0b 31 80 00 00 	movabs $0x80310b,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 10 3b 80 00 00 	movabs $0x803b10,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 0b 31 80 00 00 	movabs $0x80310b,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 0d 27 80 00 00 	movabs $0x80270d,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 43 22 80 00 00 	movabs $0x802243,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 8a 1e 80 00 00 	movabs $0x801e8a,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 7d 19 80 00 00 	movabs $0x80197d,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be 2d 3b 80 00 00 	movabs $0x803b2d,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80047a:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	48 98                	cltq   
  800488:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048d:	48 89 c2             	mov    %rax,%rdx
  800490:	48 89 d0             	mov    %rdx,%rax
  800493:	48 c1 e0 03          	shl    $0x3,%rax
  800497:	48 01 d0             	add    %rdx,%rax
  80049a:	48 c1 e0 05          	shl    $0x5,%rax
  80049e:	48 89 c2             	mov    %rax,%rdx
  8004a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8004a8:	00 00 00 
  8004ab:	48 01 c2             	add    %rax,%rdx
  8004ae:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8004b5:	00 00 00 
  8004b8:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004bf:	7e 14                	jle    8004d5 <libmain+0x6a>
		binaryname = argv[0];
  8004c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c5:	48 8b 10             	mov    (%rax),%rdx
  8004c8:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8004cf:	00 00 00 
  8004d2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004dc:	48 89 d6             	mov    %rdx,%rsi
  8004df:	89 c7                	mov    %eax,%edi
  8004e1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004e8:	00 00 00 
  8004eb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004ed:	48 b8 fb 04 80 00 00 	movabs $0x8004fb,%rax
  8004f4:	00 00 00 
  8004f7:	ff d0                	callq  *%rax
}
  8004f9:	c9                   	leaveq 
  8004fa:	c3                   	retq   

00000000008004fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004fb:	55                   	push   %rbp
  8004fc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004ff:	48 b8 36 25 80 00 00 	movabs $0x802536,%rax
  800506:	00 00 00 
  800509:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80050b:	bf 00 00 00 00       	mov    $0x0,%edi
  800510:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  800517:	00 00 00 
  80051a:	ff d0                	callq  *%rax
}
  80051c:	5d                   	pop    %rbp
  80051d:	c3                   	retq   

000000000080051e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80051e:	55                   	push   %rbp
  80051f:	48 89 e5             	mov    %rsp,%rbp
  800522:	53                   	push   %rbx
  800523:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80052a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800531:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800537:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80053e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800545:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80054c:	84 c0                	test   %al,%al
  80054e:	74 23                	je     800573 <_panic+0x55>
  800550:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800557:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80055b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800563:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800567:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80056b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800573:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80057a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800581:	00 00 00 
  800584:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80058b:	00 00 00 
  80058e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800592:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800599:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a7:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8005ae:	00 00 00 
  8005b1:	48 8b 18             	mov    (%rax),%rbx
  8005b4:	48 b8 0c 1f 80 00 00 	movabs $0x801f0c,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
  8005c0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005cd:	41 89 c8             	mov    %ecx,%r8d
  8005d0:	48 89 d1             	mov    %rdx,%rcx
  8005d3:	48 89 da             	mov    %rbx,%rdx
  8005d6:	89 c6                	mov    %eax,%esi
  8005d8:	48 bf 40 3b 80 00 00 	movabs $0x803b40,%rdi
  8005df:	00 00 00 
  8005e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e7:	49 b9 57 07 80 00 00 	movabs $0x800757,%r9
  8005ee:	00 00 00 
  8005f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800602:	48 89 d6             	mov    %rdx,%rsi
  800605:	48 89 c7             	mov    %rax,%rdi
  800608:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80060f:	00 00 00 
  800612:	ff d0                	callq  *%rax
	cprintf("\n");
  800614:	48 bf 63 3b 80 00 00 	movabs $0x803b63,%rdi
  80061b:	00 00 00 
  80061e:	b8 00 00 00 00       	mov    $0x0,%eax
  800623:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  80062a:	00 00 00 
  80062d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062f:	cc                   	int3   
  800630:	eb fd                	jmp    80062f <_panic+0x111>

0000000000800632 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	48 83 ec 10          	sub    $0x10,%rsp
  80063a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80063d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800645:	8b 00                	mov    (%rax),%eax
  800647:	8d 48 01             	lea    0x1(%rax),%ecx
  80064a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064e:	89 0a                	mov    %ecx,(%rdx)
  800650:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800653:	89 d1                	mov    %edx,%ecx
  800655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800659:	48 98                	cltq   
  80065b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066a:	75 2c                	jne    800698 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80066c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	48 98                	cltq   
  800674:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800678:	48 83 c2 08          	add    $0x8,%rdx
  80067c:	48 89 c6             	mov    %rax,%rsi
  80067f:	48 89 d7             	mov    %rdx,%rdi
  800682:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
		b->idx = 0;
  80068e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800692:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	8d 50 01             	lea    0x1(%rax),%edx
  8006a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a9:	c9                   	leaveq 
  8006aa:	c3                   	retq   

00000000008006ab <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006ab:	55                   	push   %rbp
  8006ac:	48 89 e5             	mov    %rsp,%rbp
  8006af:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006bd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006c4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006cb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d2:	48 8b 0a             	mov    (%rdx),%rcx
  8006d5:	48 89 08             	mov    %rcx,(%rax)
  8006d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006ef:	00 00 00 
	b.cnt = 0;
  8006f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006fc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800703:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800711:	48 89 c6             	mov    %rax,%rsi
  800714:	48 bf 32 06 80 00 00 	movabs $0x800632,%rdi
  80071b:	00 00 00 
  80071e:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  800725:	00 00 00 
  800728:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80072a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800730:	48 98                	cltq   
  800732:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800739:	48 83 c2 08          	add    $0x8,%rdx
  80073d:	48 89 c6             	mov    %rax,%rsi
  800740:	48 89 d7             	mov    %rdx,%rdi
  800743:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  80074a:	00 00 00 
  80074d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800755:	c9                   	leaveq 
  800756:	c3                   	retq   

0000000000800757 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800762:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800769:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800770:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800777:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80077e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800785:	84 c0                	test   %al,%al
  800787:	74 20                	je     8007a9 <cprintf+0x52>
  800789:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80078d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800791:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800795:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800799:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80079d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007b0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b7:	00 00 00 
  8007ba:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c1:	00 00 00 
  8007c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007cf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007dd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007eb:	48 8b 0a             	mov    (%rdx),%rcx
  8007ee:	48 89 08             	mov    %rcx,(%rax)
  8007f1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007fd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800801:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800808:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080f:	48 89 d6             	mov    %rdx,%rsi
  800812:	48 89 c7             	mov    %rax,%rdi
  800815:	48 b8 ab 06 80 00 00 	movabs $0x8006ab,%rax
  80081c:	00 00 00 
  80081f:	ff d0                	callq  *%rax
  800821:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800827:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80082d:	c9                   	leaveq 
  80082e:	c3                   	retq   

000000000080082f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082f:	55                   	push   %rbp
  800830:	48 89 e5             	mov    %rsp,%rbp
  800833:	53                   	push   %rbx
  800834:	48 83 ec 38          	sub    $0x38,%rsp
  800838:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80083c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800840:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800844:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800847:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80084b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800852:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800856:	77 3b                	ja     800893 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800858:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80085b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80085f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	48 f7 f3             	div    %rbx
  80086e:	48 89 c2             	mov    %rax,%rdx
  800871:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800874:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800877:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	41 89 f9             	mov    %edi,%r9d
  800882:	48 89 c7             	mov    %rax,%rdi
  800885:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  80088c:	00 00 00 
  80088f:	ff d0                	callq  *%rax
  800891:	eb 1e                	jmp    8008b1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	eb 12                	jmp    8008a7 <printnum+0x78>
			putch(padc, putdat);
  800895:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800899:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80089c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a0:	48 89 ce             	mov    %rcx,%rsi
  8008a3:	89 d7                	mov    %edx,%edi
  8008a5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008af:	7f e4                	jg     800895 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	48 f7 f1             	div    %rcx
  8008c0:	48 89 d0             	mov    %rdx,%rax
  8008c3:	48 ba 48 3d 80 00 00 	movabs $0x803d48,%rdx
  8008ca:	00 00 00 
  8008cd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d1:	0f be d0             	movsbl %al,%edx
  8008d4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008dc:	48 89 ce             	mov    %rcx,%rsi
  8008df:	89 d7                	mov    %edx,%edi
  8008e1:	ff d0                	callq  *%rax
}
  8008e3:	48 83 c4 38          	add    $0x38,%rsp
  8008e7:	5b                   	pop    %rbx
  8008e8:	5d                   	pop    %rbp
  8008e9:	c3                   	retq   

00000000008008ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %rbp
  8008eb:	48 89 e5             	mov    %rsp,%rbp
  8008ee:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8008f9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fd:	7e 52                	jle    800951 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	8b 00                	mov    (%rax),%eax
  800905:	83 f8 30             	cmp    $0x30,%eax
  800908:	73 24                	jae    80092e <getuint+0x44>
  80090a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800916:	8b 00                	mov    (%rax),%eax
  800918:	89 c0                	mov    %eax,%eax
  80091a:	48 01 d0             	add    %rdx,%rax
  80091d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800921:	8b 12                	mov    (%rdx),%edx
  800923:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800926:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092a:	89 0a                	mov    %ecx,(%rdx)
  80092c:	eb 17                	jmp    800945 <getuint+0x5b>
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800936:	48 89 d0             	mov    %rdx,%rax
  800939:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800941:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800945:	48 8b 00             	mov    (%rax),%rax
  800948:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094c:	e9 a3 00 00 00       	jmpq   8009f4 <getuint+0x10a>
	else if (lflag)
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800955:	74 4f                	je     8009a6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	8b 00                	mov    (%rax),%eax
  80095d:	83 f8 30             	cmp    $0x30,%eax
  800960:	73 24                	jae    800986 <getuint+0x9c>
  800962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800966:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096e:	8b 00                	mov    (%rax),%eax
  800970:	89 c0                	mov    %eax,%eax
  800972:	48 01 d0             	add    %rdx,%rax
  800975:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800979:	8b 12                	mov    (%rdx),%edx
  80097b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800982:	89 0a                	mov    %ecx,(%rdx)
  800984:	eb 17                	jmp    80099d <getuint+0xb3>
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098e:	48 89 d0             	mov    %rdx,%rax
  800991:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800995:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800999:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099d:	48 8b 00             	mov    (%rax),%rax
  8009a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a4:	eb 4e                	jmp    8009f4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	83 f8 30             	cmp    $0x30,%eax
  8009af:	73 24                	jae    8009d5 <getuint+0xeb>
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	89 c0                	mov    %eax,%eax
  8009c1:	48 01 d0             	add    %rdx,%rax
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	8b 12                	mov    (%rdx),%edx
  8009ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	89 0a                	mov    %ecx,(%rdx)
  8009d3:	eb 17                	jmp    8009ec <getuint+0x102>
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009dd:	48 89 d0             	mov    %rdx,%rax
  8009e0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ec:	8b 00                	mov    (%rax),%eax
  8009ee:	89 c0                	mov    %eax,%eax
  8009f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f8:	c9                   	leaveq 
  8009f9:	c3                   	retq   

00000000008009fa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009fa:	55                   	push   %rbp
  8009fb:	48 89 e5             	mov    %rsp,%rbp
  8009fe:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a06:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a09:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a0d:	7e 52                	jle    800a61 <getint+0x67>
		x=va_arg(*ap, long long);
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	8b 00                	mov    (%rax),%eax
  800a15:	83 f8 30             	cmp    $0x30,%eax
  800a18:	73 24                	jae    800a3e <getint+0x44>
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a26:	8b 00                	mov    (%rax),%eax
  800a28:	89 c0                	mov    %eax,%eax
  800a2a:	48 01 d0             	add    %rdx,%rax
  800a2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a31:	8b 12                	mov    (%rdx),%edx
  800a33:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3a:	89 0a                	mov    %ecx,(%rdx)
  800a3c:	eb 17                	jmp    800a55 <getint+0x5b>
  800a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a42:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a46:	48 89 d0             	mov    %rdx,%rax
  800a49:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a51:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a55:	48 8b 00             	mov    (%rax),%rax
  800a58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5c:	e9 a3 00 00 00       	jmpq   800b04 <getint+0x10a>
	else if (lflag)
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a65:	74 4f                	je     800ab6 <getint+0xbc>
		x=va_arg(*ap, long);
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	8b 00                	mov    (%rax),%eax
  800a6d:	83 f8 30             	cmp    $0x30,%eax
  800a70:	73 24                	jae    800a96 <getint+0x9c>
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	89 c0                	mov    %eax,%eax
  800a82:	48 01 d0             	add    %rdx,%rax
  800a85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a89:	8b 12                	mov    (%rdx),%edx
  800a8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a92:	89 0a                	mov    %ecx,(%rdx)
  800a94:	eb 17                	jmp    800aad <getint+0xb3>
  800a96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a9e:	48 89 d0             	mov    %rdx,%rax
  800aa1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aad:	48 8b 00             	mov    (%rax),%rax
  800ab0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab4:	eb 4e                	jmp    800b04 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	8b 00                	mov    (%rax),%eax
  800abc:	83 f8 30             	cmp    $0x30,%eax
  800abf:	73 24                	jae    800ae5 <getint+0xeb>
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	8b 00                	mov    (%rax),%eax
  800acf:	89 c0                	mov    %eax,%eax
  800ad1:	48 01 d0             	add    %rdx,%rax
  800ad4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad8:	8b 12                	mov    (%rdx),%edx
  800ada:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	89 0a                	mov    %ecx,(%rdx)
  800ae3:	eb 17                	jmp    800afc <getint+0x102>
  800ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aed:	48 89 d0             	mov    %rdx,%rax
  800af0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afc:	8b 00                	mov    (%rax),%eax
  800afe:	48 98                	cltq   
  800b00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b08:	c9                   	leaveq 
  800b09:	c3                   	retq   

0000000000800b0a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b0a:	55                   	push   %rbp
  800b0b:	48 89 e5             	mov    %rsp,%rbp
  800b0e:	41 54                	push   %r12
  800b10:	53                   	push   %rbx
  800b11:	48 83 ec 60          	sub    $0x60,%rsp
  800b15:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b19:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b1d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b21:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b25:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b29:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b2d:	48 8b 0a             	mov    (%rdx),%rcx
  800b30:	48 89 08             	mov    %rcx,(%rax)
  800b33:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b37:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b3b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b3f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800b43:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b4f:	0f b6 00             	movzbl (%rax),%eax
  800b52:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800b55:	eb 29                	jmp    800b80 <vprintfmt+0x76>
			if (ch == '\0')
  800b57:	85 db                	test   %ebx,%ebx
  800b59:	0f 84 ad 06 00 00    	je     80120c <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800b5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b67:	48 89 d6             	mov    %rdx,%rsi
  800b6a:	89 df                	mov    %ebx,%edi
  800b6c:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800b6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b72:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b76:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b7a:	0f b6 00             	movzbl (%rax),%eax
  800b7d:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800b80:	83 fb 25             	cmp    $0x25,%ebx
  800b83:	74 05                	je     800b8a <vprintfmt+0x80>
  800b85:	83 fb 1b             	cmp    $0x1b,%ebx
  800b88:	75 cd                	jne    800b57 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800b8a:	83 fb 1b             	cmp    $0x1b,%ebx
  800b8d:	0f 85 ae 01 00 00    	jne    800d41 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800b93:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800b9a:	00 00 00 
  800b9d:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800ba3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bab:	48 89 d6             	mov    %rdx,%rsi
  800bae:	89 df                	mov    %ebx,%edi
  800bb0:	ff d0                	callq  *%rax
			putch('[', putdat);
  800bb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bba:	48 89 d6             	mov    %rdx,%rsi
  800bbd:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800bc2:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800bc4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800bca:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800bcf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd3:	0f b6 00             	movzbl (%rax),%eax
  800bd6:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800bd9:	eb 32                	jmp    800c0d <vprintfmt+0x103>
					putch(ch, putdat);
  800bdb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be3:	48 89 d6             	mov    %rdx,%rsi
  800be6:	89 df                	mov    %ebx,%edi
  800be8:	ff d0                	callq  *%rax
					esc_color *= 10;
  800bea:	44 89 e0             	mov    %r12d,%eax
  800bed:	c1 e0 02             	shl    $0x2,%eax
  800bf0:	44 01 e0             	add    %r12d,%eax
  800bf3:	01 c0                	add    %eax,%eax
  800bf5:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800bf8:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800bfb:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800bfe:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c03:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c07:	0f b6 00             	movzbl (%rax),%eax
  800c0a:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800c0d:	83 fb 3b             	cmp    $0x3b,%ebx
  800c10:	74 05                	je     800c17 <vprintfmt+0x10d>
  800c12:	83 fb 6d             	cmp    $0x6d,%ebx
  800c15:	75 c4                	jne    800bdb <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800c17:	45 85 e4             	test   %r12d,%r12d
  800c1a:	75 15                	jne    800c31 <vprintfmt+0x127>
					color_flag = 0x07;
  800c1c:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800c23:	00 00 00 
  800c26:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800c2c:	e9 dc 00 00 00       	jmpq   800d0d <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800c31:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800c35:	7e 69                	jle    800ca0 <vprintfmt+0x196>
  800c37:	41 83 fc 25          	cmp    $0x25,%r12d
  800c3b:	7f 63                	jg     800ca0 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800c3d:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800c44:	00 00 00 
  800c47:	8b 00                	mov    (%rax),%eax
  800c49:	25 f8 00 00 00       	and    $0xf8,%eax
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800c57:	00 00 00 
  800c5a:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800c5c:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800c60:	44 89 e0             	mov    %r12d,%eax
  800c63:	83 e0 04             	and    $0x4,%eax
  800c66:	c1 f8 02             	sar    $0x2,%eax
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	44 89 e0             	mov    %r12d,%eax
  800c6e:	83 e0 02             	and    $0x2,%eax
  800c71:	09 c2                	or     %eax,%edx
  800c73:	44 89 e0             	mov    %r12d,%eax
  800c76:	83 e0 01             	and    $0x1,%eax
  800c79:	c1 e0 02             	shl    $0x2,%eax
  800c7c:	09 c2                	or     %eax,%edx
  800c7e:	41 89 d4             	mov    %edx,%r12d
  800c81:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800c88:	00 00 00 
  800c8b:	8b 00                	mov    (%rax),%eax
  800c8d:	44 89 e2             	mov    %r12d,%edx
  800c90:	09 c2                	or     %eax,%edx
  800c92:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800c99:	00 00 00 
  800c9c:	89 10                	mov    %edx,(%rax)
  800c9e:	eb 6d                	jmp    800d0d <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800ca0:	41 83 fc 27          	cmp    $0x27,%r12d
  800ca4:	7e 67                	jle    800d0d <vprintfmt+0x203>
  800ca6:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800caa:	7f 61                	jg     800d0d <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800cac:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800cb3:	00 00 00 
  800cb6:	8b 00                	mov    (%rax),%eax
  800cb8:	25 8f 00 00 00       	and    $0x8f,%eax
  800cbd:	89 c2                	mov    %eax,%edx
  800cbf:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800cc6:	00 00 00 
  800cc9:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800ccb:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800ccf:	44 89 e0             	mov    %r12d,%eax
  800cd2:	83 e0 04             	and    $0x4,%eax
  800cd5:	c1 f8 02             	sar    $0x2,%eax
  800cd8:	89 c2                	mov    %eax,%edx
  800cda:	44 89 e0             	mov    %r12d,%eax
  800cdd:	83 e0 02             	and    $0x2,%eax
  800ce0:	09 c2                	or     %eax,%edx
  800ce2:	44 89 e0             	mov    %r12d,%eax
  800ce5:	83 e0 01             	and    $0x1,%eax
  800ce8:	c1 e0 06             	shl    $0x6,%eax
  800ceb:	09 c2                	or     %eax,%edx
  800ced:	41 89 d4             	mov    %edx,%r12d
  800cf0:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800cf7:	00 00 00 
  800cfa:	8b 00                	mov    (%rax),%eax
  800cfc:	44 89 e2             	mov    %r12d,%edx
  800cff:	09 c2                	or     %eax,%edx
  800d01:	48 b8 40 50 80 00 00 	movabs $0x805040,%rax
  800d08:	00 00 00 
  800d0b:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800d0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d15:	48 89 d6             	mov    %rdx,%rsi
  800d18:	89 df                	mov    %ebx,%edi
  800d1a:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800d1c:	83 fb 6d             	cmp    $0x6d,%ebx
  800d1f:	75 1b                	jne    800d3c <vprintfmt+0x232>
					fmt ++;
  800d21:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800d26:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800d27:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800d2e:	00 00 00 
  800d31:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800d37:	e9 cb 04 00 00       	jmpq   801207 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800d3c:	e9 83 fe ff ff       	jmpq   800bc4 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800d41:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d45:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d4c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800d53:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800d5a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d65:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d69:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d6d:	0f b6 00             	movzbl (%rax),%eax
  800d70:	0f b6 d8             	movzbl %al,%ebx
  800d73:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800d76:	83 f8 55             	cmp    $0x55,%eax
  800d79:	0f 87 5a 04 00 00    	ja     8011d9 <vprintfmt+0x6cf>
  800d7f:	89 c0                	mov    %eax,%eax
  800d81:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800d88:	00 
  800d89:	48 b8 70 3d 80 00 00 	movabs $0x803d70,%rax
  800d90:	00 00 00 
  800d93:	48 01 d0             	add    %rdx,%rax
  800d96:	48 8b 00             	mov    (%rax),%rax
  800d99:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d9b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d9f:	eb c0                	jmp    800d61 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800da5:	eb ba                	jmp    800d61 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800dae:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800db1:	89 d0                	mov    %edx,%eax
  800db3:	c1 e0 02             	shl    $0x2,%eax
  800db6:	01 d0                	add    %edx,%eax
  800db8:	01 c0                	add    %eax,%eax
  800dba:	01 d8                	add    %ebx,%eax
  800dbc:	83 e8 30             	sub    $0x30,%eax
  800dbf:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800dc2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc6:	0f b6 00             	movzbl (%rax),%eax
  800dc9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dcc:	83 fb 2f             	cmp    $0x2f,%ebx
  800dcf:	7e 0c                	jle    800ddd <vprintfmt+0x2d3>
  800dd1:	83 fb 39             	cmp    $0x39,%ebx
  800dd4:	7f 07                	jg     800ddd <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ddb:	eb d1                	jmp    800dae <vprintfmt+0x2a4>
			goto process_precision;
  800ddd:	eb 58                	jmp    800e37 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800ddf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de2:	83 f8 30             	cmp    $0x30,%eax
  800de5:	73 17                	jae    800dfe <vprintfmt+0x2f4>
  800de7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800deb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dee:	89 c0                	mov    %eax,%eax
  800df0:	48 01 d0             	add    %rdx,%rax
  800df3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800df6:	83 c2 08             	add    $0x8,%edx
  800df9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dfc:	eb 0f                	jmp    800e0d <vprintfmt+0x303>
  800dfe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e02:	48 89 d0             	mov    %rdx,%rax
  800e05:	48 83 c2 08          	add    $0x8,%rdx
  800e09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e0d:	8b 00                	mov    (%rax),%eax
  800e0f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800e12:	eb 23                	jmp    800e37 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800e14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e18:	79 0c                	jns    800e26 <vprintfmt+0x31c>
				width = 0;
  800e1a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e21:	e9 3b ff ff ff       	jmpq   800d61 <vprintfmt+0x257>
  800e26:	e9 36 ff ff ff       	jmpq   800d61 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800e2b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e32:	e9 2a ff ff ff       	jmpq   800d61 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800e37:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e3b:	79 12                	jns    800e4f <vprintfmt+0x345>
				width = precision, precision = -1;
  800e3d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e40:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e43:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e4a:	e9 12 ff ff ff       	jmpq   800d61 <vprintfmt+0x257>
  800e4f:	e9 0d ff ff ff       	jmpq   800d61 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e54:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800e58:	e9 04 ff ff ff       	jmpq   800d61 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800e5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e60:	83 f8 30             	cmp    $0x30,%eax
  800e63:	73 17                	jae    800e7c <vprintfmt+0x372>
  800e65:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e6c:	89 c0                	mov    %eax,%eax
  800e6e:	48 01 d0             	add    %rdx,%rax
  800e71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e74:	83 c2 08             	add    $0x8,%edx
  800e77:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e7a:	eb 0f                	jmp    800e8b <vprintfmt+0x381>
  800e7c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e80:	48 89 d0             	mov    %rdx,%rax
  800e83:	48 83 c2 08          	add    $0x8,%rdx
  800e87:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e8b:	8b 10                	mov    (%rax),%edx
  800e8d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e95:	48 89 ce             	mov    %rcx,%rsi
  800e98:	89 d7                	mov    %edx,%edi
  800e9a:	ff d0                	callq  *%rax
			break;
  800e9c:	e9 66 03 00 00       	jmpq   801207 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ea1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea4:	83 f8 30             	cmp    $0x30,%eax
  800ea7:	73 17                	jae    800ec0 <vprintfmt+0x3b6>
  800ea9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ead:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb0:	89 c0                	mov    %eax,%eax
  800eb2:	48 01 d0             	add    %rdx,%rax
  800eb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eb8:	83 c2 08             	add    $0x8,%edx
  800ebb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ebe:	eb 0f                	jmp    800ecf <vprintfmt+0x3c5>
  800ec0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ec4:	48 89 d0             	mov    %rdx,%rax
  800ec7:	48 83 c2 08          	add    $0x8,%rdx
  800ecb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ecf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ed1:	85 db                	test   %ebx,%ebx
  800ed3:	79 02                	jns    800ed7 <vprintfmt+0x3cd>
				err = -err;
  800ed5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ed7:	83 fb 10             	cmp    $0x10,%ebx
  800eda:	7f 16                	jg     800ef2 <vprintfmt+0x3e8>
  800edc:	48 b8 c0 3c 80 00 00 	movabs $0x803cc0,%rax
  800ee3:	00 00 00 
  800ee6:	48 63 d3             	movslq %ebx,%rdx
  800ee9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800eed:	4d 85 e4             	test   %r12,%r12
  800ef0:	75 2e                	jne    800f20 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800ef2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	89 d9                	mov    %ebx,%ecx
  800efc:	48 ba 59 3d 80 00 00 	movabs $0x803d59,%rdx
  800f03:	00 00 00 
  800f06:	48 89 c7             	mov    %rax,%rdi
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0e:	49 b8 15 12 80 00 00 	movabs $0x801215,%r8
  800f15:	00 00 00 
  800f18:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f1b:	e9 e7 02 00 00       	jmpq   801207 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f20:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f28:	4c 89 e1             	mov    %r12,%rcx
  800f2b:	48 ba 62 3d 80 00 00 	movabs $0x803d62,%rdx
  800f32:	00 00 00 
  800f35:	48 89 c7             	mov    %rax,%rdi
  800f38:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3d:	49 b8 15 12 80 00 00 	movabs $0x801215,%r8
  800f44:	00 00 00 
  800f47:	41 ff d0             	callq  *%r8
			break;
  800f4a:	e9 b8 02 00 00       	jmpq   801207 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f52:	83 f8 30             	cmp    $0x30,%eax
  800f55:	73 17                	jae    800f6e <vprintfmt+0x464>
  800f57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f5e:	89 c0                	mov    %eax,%eax
  800f60:	48 01 d0             	add    %rdx,%rax
  800f63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f66:	83 c2 08             	add    $0x8,%edx
  800f69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f6c:	eb 0f                	jmp    800f7d <vprintfmt+0x473>
  800f6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f72:	48 89 d0             	mov    %rdx,%rax
  800f75:	48 83 c2 08          	add    $0x8,%rdx
  800f79:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f7d:	4c 8b 20             	mov    (%rax),%r12
  800f80:	4d 85 e4             	test   %r12,%r12
  800f83:	75 0a                	jne    800f8f <vprintfmt+0x485>
				p = "(null)";
  800f85:	49 bc 65 3d 80 00 00 	movabs $0x803d65,%r12
  800f8c:	00 00 00 
			if (width > 0 && padc != '-')
  800f8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f93:	7e 3f                	jle    800fd4 <vprintfmt+0x4ca>
  800f95:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800f99:	74 39                	je     800fd4 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f9b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f9e:	48 98                	cltq   
  800fa0:	48 89 c6             	mov    %rax,%rsi
  800fa3:	4c 89 e7             	mov    %r12,%rdi
  800fa6:	48 b8 1b 16 80 00 00 	movabs $0x80161b,%rax
  800fad:	00 00 00 
  800fb0:	ff d0                	callq  *%rax
  800fb2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800fb5:	eb 17                	jmp    800fce <vprintfmt+0x4c4>
					putch(padc, putdat);
  800fb7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800fbb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800fbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc3:	48 89 ce             	mov    %rcx,%rsi
  800fc6:	89 d7                	mov    %edx,%edi
  800fc8:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fca:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fd2:	7f e3                	jg     800fb7 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd4:	eb 37                	jmp    80100d <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800fd6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800fda:	74 1e                	je     800ffa <vprintfmt+0x4f0>
  800fdc:	83 fb 1f             	cmp    $0x1f,%ebx
  800fdf:	7e 05                	jle    800fe6 <vprintfmt+0x4dc>
  800fe1:	83 fb 7e             	cmp    $0x7e,%ebx
  800fe4:	7e 14                	jle    800ffa <vprintfmt+0x4f0>
					putch('?', putdat);
  800fe6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fee:	48 89 d6             	mov    %rdx,%rsi
  800ff1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ff6:	ff d0                	callq  *%rax
  800ff8:	eb 0f                	jmp    801009 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800ffa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801002:	48 89 d6             	mov    %rdx,%rsi
  801005:	89 df                	mov    %ebx,%edi
  801007:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801009:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80100d:	4c 89 e0             	mov    %r12,%rax
  801010:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	0f be d8             	movsbl %al,%ebx
  80101a:	85 db                	test   %ebx,%ebx
  80101c:	74 10                	je     80102e <vprintfmt+0x524>
  80101e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801022:	78 b2                	js     800fd6 <vprintfmt+0x4cc>
  801024:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801028:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80102c:	79 a8                	jns    800fd6 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80102e:	eb 16                	jmp    801046 <vprintfmt+0x53c>
				putch(' ', putdat);
  801030:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801034:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801038:	48 89 d6             	mov    %rdx,%rsi
  80103b:	bf 20 00 00 00       	mov    $0x20,%edi
  801040:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801042:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801046:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80104a:	7f e4                	jg     801030 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  80104c:	e9 b6 01 00 00       	jmpq   801207 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801051:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801055:	be 03 00 00 00       	mov    $0x3,%esi
  80105a:	48 89 c7             	mov    %rax,%rdi
  80105d:	48 b8 fa 09 80 00 00 	movabs $0x8009fa,%rax
  801064:	00 00 00 
  801067:	ff d0                	callq  *%rax
  801069:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80106d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801071:	48 85 c0             	test   %rax,%rax
  801074:	79 1d                	jns    801093 <vprintfmt+0x589>
				putch('-', putdat);
  801076:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80107a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80107e:	48 89 d6             	mov    %rdx,%rsi
  801081:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801086:	ff d0                	callq  *%rax
				num = -(long long) num;
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 f7 d8             	neg    %rax
  80108f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801093:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80109a:	e9 fb 00 00 00       	jmpq   80119a <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80109f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010a3:	be 03 00 00 00       	mov    $0x3,%esi
  8010a8:	48 89 c7             	mov    %rax,%rdi
  8010ab:	48 b8 ea 08 80 00 00 	movabs $0x8008ea,%rax
  8010b2:	00 00 00 
  8010b5:	ff d0                	callq  *%rax
  8010b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8010bb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010c2:	e9 d3 00 00 00       	jmpq   80119a <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  8010c7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010cb:	be 03 00 00 00       	mov    $0x3,%esi
  8010d0:	48 89 c7             	mov    %rax,%rdi
  8010d3:	48 b8 fa 09 80 00 00 	movabs $0x8009fa,%rax
  8010da:	00 00 00 
  8010dd:	ff d0                	callq  *%rax
  8010df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8010e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e7:	48 85 c0             	test   %rax,%rax
  8010ea:	79 1d                	jns    801109 <vprintfmt+0x5ff>
				putch('-', putdat);
  8010ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f4:	48 89 d6             	mov    %rdx,%rsi
  8010f7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010fc:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 f7 d8             	neg    %rax
  801105:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  801109:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801110:	e9 85 00 00 00       	jmpq   80119a <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801115:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801119:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80111d:	48 89 d6             	mov    %rdx,%rsi
  801120:	bf 30 00 00 00       	mov    $0x30,%edi
  801125:	ff d0                	callq  *%rax
			putch('x', putdat);
  801127:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80112b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80112f:	48 89 d6             	mov    %rdx,%rsi
  801132:	bf 78 00 00 00       	mov    $0x78,%edi
  801137:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801139:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80113c:	83 f8 30             	cmp    $0x30,%eax
  80113f:	73 17                	jae    801158 <vprintfmt+0x64e>
  801141:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801145:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801148:	89 c0                	mov    %eax,%eax
  80114a:	48 01 d0             	add    %rdx,%rax
  80114d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801150:	83 c2 08             	add    $0x8,%edx
  801153:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801156:	eb 0f                	jmp    801167 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801158:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80115c:	48 89 d0             	mov    %rdx,%rax
  80115f:	48 83 c2 08          	add    $0x8,%rdx
  801163:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801167:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80116a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80116e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801175:	eb 23                	jmp    80119a <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801177:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80117b:	be 03 00 00 00       	mov    $0x3,%esi
  801180:	48 89 c7             	mov    %rax,%rdi
  801183:	48 b8 ea 08 80 00 00 	movabs $0x8008ea,%rax
  80118a:	00 00 00 
  80118d:	ff d0                	callq  *%rax
  80118f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801193:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80119a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80119f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8011a2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8011a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8011ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011b1:	45 89 c1             	mov    %r8d,%r9d
  8011b4:	41 89 f8             	mov    %edi,%r8d
  8011b7:	48 89 c7             	mov    %rax,%rdi
  8011ba:	48 b8 2f 08 80 00 00 	movabs $0x80082f,%rax
  8011c1:	00 00 00 
  8011c4:	ff d0                	callq  *%rax
			break;
  8011c6:	eb 3f                	jmp    801207 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011c8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011d0:	48 89 d6             	mov    %rdx,%rsi
  8011d3:	89 df                	mov    %ebx,%edi
  8011d5:	ff d0                	callq  *%rax
			break;
  8011d7:	eb 2e                	jmp    801207 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011d9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011e1:	48 89 d6             	mov    %rdx,%rsi
  8011e4:	bf 25 00 00 00       	mov    $0x25,%edi
  8011e9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011eb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011f0:	eb 05                	jmp    8011f7 <vprintfmt+0x6ed>
  8011f2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011f7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011fb:	48 83 e8 01          	sub    $0x1,%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	3c 25                	cmp    $0x25,%al
  801204:	75 ec                	jne    8011f2 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801206:	90                   	nop
		}
	}
  801207:	e9 37 f9 ff ff       	jmpq   800b43 <vprintfmt+0x39>
    va_end(aq);
}
  80120c:	48 83 c4 60          	add    $0x60,%rsp
  801210:	5b                   	pop    %rbx
  801211:	41 5c                	pop    %r12
  801213:	5d                   	pop    %rbp
  801214:	c3                   	retq   

0000000000801215 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801215:	55                   	push   %rbp
  801216:	48 89 e5             	mov    %rsp,%rbp
  801219:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801220:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801227:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80122e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801235:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80123c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801243:	84 c0                	test   %al,%al
  801245:	74 20                	je     801267 <printfmt+0x52>
  801247:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80124b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80124f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801253:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801257:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80125b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80125f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801263:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801267:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80126e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801275:	00 00 00 
  801278:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80127f:	00 00 00 
  801282:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801286:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80128d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801294:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80129b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8012a2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012a9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8012b0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8012b7:	48 89 c7             	mov    %rax,%rdi
  8012ba:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
	va_end(ap);
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 10          	sub    $0x10,%rsp
  8012d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8012d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8012d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012db:	8b 40 10             	mov    0x10(%rax),%eax
  8012de:	8d 50 01             	lea    0x1(%rax),%edx
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8012e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ec:	48 8b 10             	mov    (%rax),%rdx
  8012ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012f7:	48 39 c2             	cmp    %rax,%rdx
  8012fa:	73 17                	jae    801313 <sprintputch+0x4b>
		*b->buf++ = ch;
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801300:	48 8b 00             	mov    (%rax),%rax
  801303:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801307:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80130b:	48 89 0a             	mov    %rcx,(%rdx)
  80130e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801311:	88 10                	mov    %dl,(%rax)
}
  801313:	c9                   	leaveq 
  801314:	c3                   	retq   

0000000000801315 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801315:	55                   	push   %rbp
  801316:	48 89 e5             	mov    %rsp,%rbp
  801319:	48 83 ec 50          	sub    $0x50,%rsp
  80131d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801321:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801324:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801328:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80132c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801330:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801334:	48 8b 0a             	mov    (%rdx),%rcx
  801337:	48 89 08             	mov    %rcx,(%rax)
  80133a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80133e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801342:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801346:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80134a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80134e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801352:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801355:	48 98                	cltq   
  801357:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80135b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80135f:	48 01 d0             	add    %rdx,%rax
  801362:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801366:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80136d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801372:	74 06                	je     80137a <vsnprintf+0x65>
  801374:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801378:	7f 07                	jg     801381 <vsnprintf+0x6c>
		return -E_INVAL;
  80137a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137f:	eb 2f                	jmp    8013b0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801381:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801385:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801389:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80138d:	48 89 c6             	mov    %rax,%rsi
  801390:	48 bf c8 12 80 00 00 	movabs $0x8012c8,%rdi
  801397:	00 00 00 
  80139a:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8013a1:	00 00 00 
  8013a4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8013a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013aa:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8013ad:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8013b0:	c9                   	leaveq 
  8013b1:	c3                   	retq   

00000000008013b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8013bd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8013c4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8013ca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013d1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013d8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 20                	je     801403 <snprintf+0x51>
  8013e3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8013e7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8013eb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8013ef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8013f3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013f7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013fb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8013ff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801403:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80140a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801411:	00 00 00 
  801414:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80141b:	00 00 00 
  80141e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801422:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801429:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801430:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801437:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80143e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801445:	48 8b 0a             	mov    (%rdx),%rcx
  801448:	48 89 08             	mov    %rcx,(%rax)
  80144b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80144f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801453:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801457:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80145b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801462:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801469:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80146f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801476:	48 89 c7             	mov    %rax,%rdi
  801479:	48 b8 15 13 80 00 00 	movabs $0x801315,%rax
  801480:	00 00 00 
  801483:	ff d0                	callq  *%rax
  801485:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80148b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 20          	sub    $0x20,%rsp
  80149b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80149f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014a4:	74 27                	je     8014cd <readline+0x3a>
		fprintf(1, "%s", prompt);
  8014a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014aa:	48 89 c2             	mov    %rax,%rdx
  8014ad:	48 be 20 40 80 00 00 	movabs $0x804020,%rsi
  8014b4:	00 00 00 
  8014b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	48 b9 0b 31 80 00 00 	movabs $0x80310b,%rcx
  8014c8:	00 00 00 
  8014cb:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8014cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8014d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8014d9:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8014e0:	00 00 00 
  8014e3:	ff d0                	callq  *%rax
  8014e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8014e8:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	callq  *%rax
  8014f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8014f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8014fb:	79 30                	jns    80152d <readline+0x9a>
			if (c != -E_EOF)
  8014fd:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801501:	74 20                	je     801523 <readline+0x90>
				cprintf("read error: %e\n", c);
  801503:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801506:	89 c6                	mov    %eax,%esi
  801508:	48 bf 23 40 80 00 00 	movabs $0x804023,%rdi
  80150f:	00 00 00 
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	48 ba 57 07 80 00 00 	movabs $0x800757,%rdx
  80151e:	00 00 00 
  801521:	ff d2                	callq  *%rdx
			return NULL;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	e9 be 00 00 00       	jmpq   8015eb <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80152d:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801531:	74 06                	je     801539 <readline+0xa6>
  801533:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801537:	75 26                	jne    80155f <readline+0xcc>
  801539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80153d:	7e 20                	jle    80155f <readline+0xcc>
			if (echoing)
  80153f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801543:	74 11                	je     801556 <readline+0xc3>
				cputchar('\b');
  801545:	bf 08 00 00 00       	mov    $0x8,%edi
  80154a:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801551:	00 00 00 
  801554:	ff d0                	callq  *%rax
			i--;
  801556:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80155a:	e9 87 00 00 00       	jmpq   8015e6 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80155f:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  801563:	7e 3f                	jle    8015a4 <readline+0x111>
  801565:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80156c:	7f 36                	jg     8015a4 <readline+0x111>
			if (echoing)
  80156e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801572:	74 11                	je     801585 <readline+0xf2>
				cputchar(c);
  801574:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801577:	89 c7                	mov    %eax,%edi
  801579:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801580:	00 00 00 
  801583:	ff d0                	callq  *%rax
			buf[i++] = c;
  801585:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801588:	8d 50 01             	lea    0x1(%rax),%edx
  80158b:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80158e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801591:	89 d1                	mov    %edx,%ecx
  801593:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  80159a:	00 00 00 
  80159d:	48 98                	cltq   
  80159f:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8015a2:	eb 42                	jmp    8015e6 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8015a4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8015a8:	74 06                	je     8015b0 <readline+0x11d>
  8015aa:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8015ae:	75 36                	jne    8015e6 <readline+0x153>
			if (echoing)
  8015b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8015b4:	74 11                	je     8015c7 <readline+0x134>
				cputchar('\n');
  8015b6:	bf 0a 00 00 00       	mov    $0xa,%edi
  8015bb:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8015c2:	00 00 00 
  8015c5:	ff d0                	callq  *%rax
			buf[i] = 0;
  8015c7:	48 ba 20 60 80 00 00 	movabs $0x806020,%rdx
  8015ce:	00 00 00 
  8015d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015d4:	48 98                	cltq   
  8015d6:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8015da:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8015e1:	00 00 00 
  8015e4:	eb 05                	jmp    8015eb <readline+0x158>
		}
	}
  8015e6:	e9 fd fe ff ff       	jmpq   8014e8 <readline+0x55>
}
  8015eb:	c9                   	leaveq 
  8015ec:	c3                   	retq   

00000000008015ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 83 ec 18          	sub    $0x18,%rsp
  8015f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801600:	eb 09                	jmp    80160b <strlen+0x1e>
		n++;
  801602:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801606:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80160b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160f:	0f b6 00             	movzbl (%rax),%eax
  801612:	84 c0                	test   %al,%al
  801614:	75 ec                	jne    801602 <strlen+0x15>
		n++;
	return n;
  801616:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801619:	c9                   	leaveq 
  80161a:	c3                   	retq   

000000000080161b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80161b:	55                   	push   %rbp
  80161c:	48 89 e5             	mov    %rsp,%rbp
  80161f:	48 83 ec 20          	sub    $0x20,%rsp
  801623:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801627:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80162b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801632:	eb 0e                	jmp    801642 <strnlen+0x27>
		n++;
  801634:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801638:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80163d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801642:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801647:	74 0b                	je     801654 <strnlen+0x39>
  801649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	84 c0                	test   %al,%al
  801652:	75 e0                	jne    801634 <strnlen+0x19>
		n++;
	return n;
  801654:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801657:	c9                   	leaveq 
  801658:	c3                   	retq   

0000000000801659 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801659:	55                   	push   %rbp
  80165a:	48 89 e5             	mov    %rsp,%rbp
  80165d:	48 83 ec 20          	sub    $0x20,%rsp
  801661:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801665:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801671:	90                   	nop
  801672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801676:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80167a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80167e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801682:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801686:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80168a:	0f b6 12             	movzbl (%rdx),%edx
  80168d:	88 10                	mov    %dl,(%rax)
  80168f:	0f b6 00             	movzbl (%rax),%eax
  801692:	84 c0                	test   %al,%al
  801694:	75 dc                	jne    801672 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80169a:	c9                   	leaveq 
  80169b:	c3                   	retq   

000000000080169c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80169c:	55                   	push   %rbp
  80169d:	48 89 e5             	mov    %rsp,%rbp
  8016a0:	48 83 ec 20          	sub    $0x20,%rsp
  8016a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	48 89 c7             	mov    %rax,%rdi
  8016b3:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  8016ba:	00 00 00 
  8016bd:	ff d0                	callq  *%rax
  8016bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8016c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016c5:	48 63 d0             	movslq %eax,%rdx
  8016c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cc:	48 01 c2             	add    %rax,%rdx
  8016cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d3:	48 89 c6             	mov    %rax,%rsi
  8016d6:	48 89 d7             	mov    %rdx,%rdi
  8016d9:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
	return dst;
  8016e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e9:	c9                   	leaveq 
  8016ea:	c3                   	retq   

00000000008016eb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 28          	sub    $0x28,%rsp
  8016f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8016ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801703:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801707:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80170e:	00 
  80170f:	eb 2a                	jmp    80173b <strncpy+0x50>
		*dst++ = *src;
  801711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801715:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801719:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80171d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801721:	0f b6 12             	movzbl (%rdx),%edx
  801724:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801726:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80172a:	0f b6 00             	movzbl (%rax),%eax
  80172d:	84 c0                	test   %al,%al
  80172f:	74 05                	je     801736 <strncpy+0x4b>
			src++;
  801731:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801736:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80173b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801743:	72 cc                	jb     801711 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801749:	c9                   	leaveq 
  80174a:	c3                   	retq   

000000000080174b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80174b:	55                   	push   %rbp
  80174c:	48 89 e5             	mov    %rsp,%rbp
  80174f:	48 83 ec 28          	sub    $0x28,%rsp
  801753:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801757:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80175b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80175f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801763:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801767:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80176c:	74 3d                	je     8017ab <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80176e:	eb 1d                	jmp    80178d <strlcpy+0x42>
			*dst++ = *src++;
  801770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801774:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801778:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80177c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801780:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801784:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801788:	0f b6 12             	movzbl (%rdx),%edx
  80178b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80178d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801792:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801797:	74 0b                	je     8017a4 <strlcpy+0x59>
  801799:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	84 c0                	test   %al,%al
  8017a2:	75 cc                	jne    801770 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8017a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8017ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b3:	48 29 c2             	sub    %rax,%rdx
  8017b6:	48 89 d0             	mov    %rdx,%rax
}
  8017b9:	c9                   	leaveq 
  8017ba:	c3                   	retq   

00000000008017bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017bb:	55                   	push   %rbp
  8017bc:	48 89 e5             	mov    %rsp,%rbp
  8017bf:	48 83 ec 10          	sub    $0x10,%rsp
  8017c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8017cb:	eb 0a                	jmp    8017d7 <strcmp+0x1c>
		p++, q++;
  8017cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8017d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	84 c0                	test   %al,%al
  8017e0:	74 12                	je     8017f4 <strcmp+0x39>
  8017e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e6:	0f b6 10             	movzbl (%rax),%edx
  8017e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	38 c2                	cmp    %al,%dl
  8017f2:	74 d9                	je     8017cd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	0f b6 d0             	movzbl %al,%edx
  8017fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801802:	0f b6 00             	movzbl (%rax),%eax
  801805:	0f b6 c0             	movzbl %al,%eax
  801808:	29 c2                	sub    %eax,%edx
  80180a:	89 d0                	mov    %edx,%eax
}
  80180c:	c9                   	leaveq 
  80180d:	c3                   	retq   

000000000080180e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80180e:	55                   	push   %rbp
  80180f:	48 89 e5             	mov    %rsp,%rbp
  801812:	48 83 ec 18          	sub    $0x18,%rsp
  801816:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801822:	eb 0f                	jmp    801833 <strncmp+0x25>
		n--, p++, q++;
  801824:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801829:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80182e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801833:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801838:	74 1d                	je     801857 <strncmp+0x49>
  80183a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	84 c0                	test   %al,%al
  801843:	74 12                	je     801857 <strncmp+0x49>
  801845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801849:	0f b6 10             	movzbl (%rax),%edx
  80184c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 cd                	je     801824 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801857:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80185c:	75 07                	jne    801865 <strncmp+0x57>
		return 0;
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	eb 18                	jmp    80187d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	0f b6 d0             	movzbl %al,%edx
  80186f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	29 c2                	sub    %eax,%edx
  80187b:	89 d0                	mov    %edx,%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   

000000000080187f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80187f:	55                   	push   %rbp
  801880:	48 89 e5             	mov    %rsp,%rbp
  801883:	48 83 ec 0c          	sub    $0xc,%rsp
  801887:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80188b:	89 f0                	mov    %esi,%eax
  80188d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801890:	eb 17                	jmp    8018a9 <strchr+0x2a>
		if (*s == c)
  801892:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801896:	0f b6 00             	movzbl (%rax),%eax
  801899:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80189c:	75 06                	jne    8018a4 <strchr+0x25>
			return (char *) s;
  80189e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a2:	eb 15                	jmp    8018b9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	84 c0                	test   %al,%al
  8018b2:	75 de                	jne    801892 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b9:	c9                   	leaveq 
  8018ba:	c3                   	retq   

00000000008018bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018bb:	55                   	push   %rbp
  8018bc:	48 89 e5             	mov    %rsp,%rbp
  8018bf:	48 83 ec 0c          	sub    $0xc,%rsp
  8018c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018c7:	89 f0                	mov    %esi,%eax
  8018c9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8018cc:	eb 13                	jmp    8018e1 <strfind+0x26>
		if (*s == c)
  8018ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d2:	0f b6 00             	movzbl (%rax),%eax
  8018d5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8018d8:	75 02                	jne    8018dc <strfind+0x21>
			break;
  8018da:	eb 10                	jmp    8018ec <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8018dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	84 c0                	test   %al,%al
  8018ea:	75 e2                	jne    8018ce <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8018ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018f0:	c9                   	leaveq 
  8018f1:	c3                   	retq   

00000000008018f2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8018f2:	55                   	push   %rbp
  8018f3:	48 89 e5             	mov    %rsp,%rbp
  8018f6:	48 83 ec 18          	sub    $0x18,%rsp
  8018fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fe:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801901:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801905:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80190a:	75 06                	jne    801912 <memset+0x20>
		return v;
  80190c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801910:	eb 69                	jmp    80197b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801916:	83 e0 03             	and    $0x3,%eax
  801919:	48 85 c0             	test   %rax,%rax
  80191c:	75 48                	jne    801966 <memset+0x74>
  80191e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801922:	83 e0 03             	and    $0x3,%eax
  801925:	48 85 c0             	test   %rax,%rax
  801928:	75 3c                	jne    801966 <memset+0x74>
		c &= 0xFF;
  80192a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801931:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801934:	c1 e0 18             	shl    $0x18,%eax
  801937:	89 c2                	mov    %eax,%edx
  801939:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80193c:	c1 e0 10             	shl    $0x10,%eax
  80193f:	09 c2                	or     %eax,%edx
  801941:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801944:	c1 e0 08             	shl    $0x8,%eax
  801947:	09 d0                	or     %edx,%eax
  801949:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80194c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801950:	48 c1 e8 02          	shr    $0x2,%rax
  801954:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801957:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80195b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80195e:	48 89 d7             	mov    %rdx,%rdi
  801961:	fc                   	cld    
  801962:	f3 ab                	rep stos %eax,%es:(%rdi)
  801964:	eb 11                	jmp    801977 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801966:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80196a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80196d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801971:	48 89 d7             	mov    %rdx,%rdi
  801974:	fc                   	cld    
  801975:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801977:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 83 ec 28          	sub    $0x28,%rsp
  801985:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801989:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80198d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801991:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801995:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8019a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8019a9:	0f 83 88 00 00 00    	jae    801a37 <memmove+0xba>
  8019af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019b7:	48 01 d0             	add    %rdx,%rax
  8019ba:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8019be:	76 77                	jbe    801a37 <memmove+0xba>
		s += n;
  8019c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8019c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8019d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d4:	83 e0 03             	and    $0x3,%eax
  8019d7:	48 85 c0             	test   %rax,%rax
  8019da:	75 3b                	jne    801a17 <memmove+0x9a>
  8019dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e0:	83 e0 03             	and    $0x3,%eax
  8019e3:	48 85 c0             	test   %rax,%rax
  8019e6:	75 2f                	jne    801a17 <memmove+0x9a>
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	83 e0 03             	and    $0x3,%eax
  8019ef:	48 85 c0             	test   %rax,%rax
  8019f2:	75 23                	jne    801a17 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f8:	48 83 e8 04          	sub    $0x4,%rax
  8019fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a00:	48 83 ea 04          	sub    $0x4,%rdx
  801a04:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a08:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801a0c:	48 89 c7             	mov    %rax,%rdi
  801a0f:	48 89 d6             	mov    %rdx,%rsi
  801a12:	fd                   	std    
  801a13:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a15:	eb 1d                	jmp    801a34 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a1b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a23:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2b:	48 89 d7             	mov    %rdx,%rdi
  801a2e:	48 89 c1             	mov    %rax,%rcx
  801a31:	fd                   	std    
  801a32:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801a34:	fc                   	cld    
  801a35:	eb 57                	jmp    801a8e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3b:	83 e0 03             	and    $0x3,%eax
  801a3e:	48 85 c0             	test   %rax,%rax
  801a41:	75 36                	jne    801a79 <memmove+0xfc>
  801a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a47:	83 e0 03             	and    $0x3,%eax
  801a4a:	48 85 c0             	test   %rax,%rax
  801a4d:	75 2a                	jne    801a79 <memmove+0xfc>
  801a4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a53:	83 e0 03             	and    $0x3,%eax
  801a56:	48 85 c0             	test   %rax,%rax
  801a59:	75 1e                	jne    801a79 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5f:	48 c1 e8 02          	shr    $0x2,%rax
  801a63:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801a66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a6e:	48 89 c7             	mov    %rax,%rdi
  801a71:	48 89 d6             	mov    %rdx,%rsi
  801a74:	fc                   	cld    
  801a75:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a77:	eb 15                	jmp    801a8e <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a81:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 89 d6             	mov    %rdx,%rsi
  801a8b:	fc                   	cld    
  801a8c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a92:	c9                   	leaveq 
  801a93:	c3                   	retq   

0000000000801a94 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a94:	55                   	push   %rbp
  801a95:	48 89 e5             	mov    %rsp,%rbp
  801a98:	48 83 ec 18          	sub    $0x18,%rsp
  801a9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801aa8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801aac:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab4:	48 89 ce             	mov    %rcx,%rsi
  801ab7:	48 89 c7             	mov    %rax,%rdi
  801aba:	48 b8 7d 19 80 00 00 	movabs $0x80197d,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	48 83 ec 28          	sub    $0x28,%rsp
  801ad0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ad8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801ae4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ae8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801aec:	eb 36                	jmp    801b24 <memcmp+0x5c>
		if (*s1 != *s2)
  801aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af2:	0f b6 10             	movzbl (%rax),%edx
  801af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af9:	0f b6 00             	movzbl (%rax),%eax
  801afc:	38 c2                	cmp    %al,%dl
  801afe:	74 1a                	je     801b1a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b04:	0f b6 00             	movzbl (%rax),%eax
  801b07:	0f b6 d0             	movzbl %al,%edx
  801b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0e:	0f b6 00             	movzbl (%rax),%eax
  801b11:	0f b6 c0             	movzbl %al,%eax
  801b14:	29 c2                	sub    %eax,%edx
  801b16:	89 d0                	mov    %edx,%eax
  801b18:	eb 20                	jmp    801b3a <memcmp+0x72>
		s1++, s2++;
  801b1a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b1f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b28:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b30:	48 85 c0             	test   %rax,%rax
  801b33:	75 b9                	jne    801aee <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3a:	c9                   	leaveq 
  801b3b:	c3                   	retq   

0000000000801b3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	48 83 ec 28          	sub    $0x28,%rsp
  801b44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b48:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801b4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b57:	48 01 d0             	add    %rdx,%rax
  801b5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801b5e:	eb 15                	jmp    801b75 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b64:	0f b6 10             	movzbl (%rax),%edx
  801b67:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b6a:	38 c2                	cmp    %al,%dl
  801b6c:	75 02                	jne    801b70 <memfind+0x34>
			break;
  801b6e:	eb 0f                	jmp    801b7f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b70:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b79:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801b7d:	72 e1                	jb     801b60 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801b7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b83:	c9                   	leaveq 
  801b84:	c3                   	retq   

0000000000801b85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b85:	55                   	push   %rbp
  801b86:	48 89 e5             	mov    %rsp,%rbp
  801b89:	48 83 ec 34          	sub    $0x34,%rsp
  801b8d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b91:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801b95:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801b98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801b9f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801ba6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ba7:	eb 05                	jmp    801bae <strtol+0x29>
		s++;
  801ba9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb2:	0f b6 00             	movzbl (%rax),%eax
  801bb5:	3c 20                	cmp    $0x20,%al
  801bb7:	74 f0                	je     801ba9 <strtol+0x24>
  801bb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bbd:	0f b6 00             	movzbl (%rax),%eax
  801bc0:	3c 09                	cmp    $0x9,%al
  801bc2:	74 e5                	je     801ba9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801bc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bc8:	0f b6 00             	movzbl (%rax),%eax
  801bcb:	3c 2b                	cmp    $0x2b,%al
  801bcd:	75 07                	jne    801bd6 <strtol+0x51>
		s++;
  801bcf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bd4:	eb 17                	jmp    801bed <strtol+0x68>
	else if (*s == '-')
  801bd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bda:	0f b6 00             	movzbl (%rax),%eax
  801bdd:	3c 2d                	cmp    $0x2d,%al
  801bdf:	75 0c                	jne    801bed <strtol+0x68>
		s++, neg = 1;
  801be1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801be6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801bed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801bf1:	74 06                	je     801bf9 <strtol+0x74>
  801bf3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801bf7:	75 28                	jne    801c21 <strtol+0x9c>
  801bf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfd:	0f b6 00             	movzbl (%rax),%eax
  801c00:	3c 30                	cmp    $0x30,%al
  801c02:	75 1d                	jne    801c21 <strtol+0x9c>
  801c04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c08:	48 83 c0 01          	add    $0x1,%rax
  801c0c:	0f b6 00             	movzbl (%rax),%eax
  801c0f:	3c 78                	cmp    $0x78,%al
  801c11:	75 0e                	jne    801c21 <strtol+0x9c>
		s += 2, base = 16;
  801c13:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c18:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c1f:	eb 2c                	jmp    801c4d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c21:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c25:	75 19                	jne    801c40 <strtol+0xbb>
  801c27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2b:	0f b6 00             	movzbl (%rax),%eax
  801c2e:	3c 30                	cmp    $0x30,%al
  801c30:	75 0e                	jne    801c40 <strtol+0xbb>
		s++, base = 8;
  801c32:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c37:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801c3e:	eb 0d                	jmp    801c4d <strtol+0xc8>
	else if (base == 0)
  801c40:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c44:	75 07                	jne    801c4d <strtol+0xc8>
		base = 10;
  801c46:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c51:	0f b6 00             	movzbl (%rax),%eax
  801c54:	3c 2f                	cmp    $0x2f,%al
  801c56:	7e 1d                	jle    801c75 <strtol+0xf0>
  801c58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5c:	0f b6 00             	movzbl (%rax),%eax
  801c5f:	3c 39                	cmp    $0x39,%al
  801c61:	7f 12                	jg     801c75 <strtol+0xf0>
			dig = *s - '0';
  801c63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c67:	0f b6 00             	movzbl (%rax),%eax
  801c6a:	0f be c0             	movsbl %al,%eax
  801c6d:	83 e8 30             	sub    $0x30,%eax
  801c70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c73:	eb 4e                	jmp    801cc3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801c75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c79:	0f b6 00             	movzbl (%rax),%eax
  801c7c:	3c 60                	cmp    $0x60,%al
  801c7e:	7e 1d                	jle    801c9d <strtol+0x118>
  801c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c84:	0f b6 00             	movzbl (%rax),%eax
  801c87:	3c 7a                	cmp    $0x7a,%al
  801c89:	7f 12                	jg     801c9d <strtol+0x118>
			dig = *s - 'a' + 10;
  801c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8f:	0f b6 00             	movzbl (%rax),%eax
  801c92:	0f be c0             	movsbl %al,%eax
  801c95:	83 e8 57             	sub    $0x57,%eax
  801c98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c9b:	eb 26                	jmp    801cc3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca1:	0f b6 00             	movzbl (%rax),%eax
  801ca4:	3c 40                	cmp    $0x40,%al
  801ca6:	7e 48                	jle    801cf0 <strtol+0x16b>
  801ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cac:	0f b6 00             	movzbl (%rax),%eax
  801caf:	3c 5a                	cmp    $0x5a,%al
  801cb1:	7f 3d                	jg     801cf0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb7:	0f b6 00             	movzbl (%rax),%eax
  801cba:	0f be c0             	movsbl %al,%eax
  801cbd:	83 e8 37             	sub    $0x37,%eax
  801cc0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801cc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cc6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801cc9:	7c 02                	jl     801ccd <strtol+0x148>
			break;
  801ccb:	eb 23                	jmp    801cf0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ccd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cd2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801cd5:	48 98                	cltq   
  801cd7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801cdc:	48 89 c2             	mov    %rax,%rdx
  801cdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ce2:	48 98                	cltq   
  801ce4:	48 01 d0             	add    %rdx,%rax
  801ce7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ceb:	e9 5d ff ff ff       	jmpq   801c4d <strtol+0xc8>

	if (endptr)
  801cf0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801cf5:	74 0b                	je     801d02 <strtol+0x17d>
		*endptr = (char *) s;
  801cf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cfb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801cff:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d06:	74 09                	je     801d11 <strtol+0x18c>
  801d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0c:	48 f7 d8             	neg    %rax
  801d0f:	eb 04                	jmp    801d15 <strtol+0x190>
  801d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <strstr>:

char * strstr(const char *in, const char *str)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 30          	sub    $0x30,%rsp
  801d1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801d27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d2f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d33:	0f b6 00             	movzbl (%rax),%eax
  801d36:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801d39:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801d3d:	75 06                	jne    801d45 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801d3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d43:	eb 6b                	jmp    801db0 <strstr+0x99>

    len = strlen(str);
  801d45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d49:	48 89 c7             	mov    %rax,%rdi
  801d4c:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
  801d58:	48 98                	cltq   
  801d5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801d5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801d6a:	0f b6 00             	movzbl (%rax),%eax
  801d6d:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801d70:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801d74:	75 07                	jne    801d7d <strstr+0x66>
                return (char *) 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7b:	eb 33                	jmp    801db0 <strstr+0x99>
        } while (sc != c);
  801d7d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801d81:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801d84:	75 d8                	jne    801d5e <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801d86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d92:	48 89 ce             	mov    %rcx,%rsi
  801d95:	48 89 c7             	mov    %rax,%rdi
  801d98:	48 b8 0e 18 80 00 00 	movabs $0x80180e,%rax
  801d9f:	00 00 00 
  801da2:	ff d0                	callq  *%rax
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 b6                	jne    801d5e <strstr+0x47>

    return (char *) (in - 1);
  801da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dac:	48 83 e8 01          	sub    $0x1,%rax
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	53                   	push   %rbx
  801db7:	48 83 ec 48          	sub    $0x48,%rsp
  801dbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801dbe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801dc1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801dc5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801dc9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801dcd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801dd4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801dd8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ddc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801de0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801de4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801de8:	4c 89 c3             	mov    %r8,%rbx
  801deb:	cd 30                	int    $0x30
  801ded:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801df1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801df5:	74 3e                	je     801e35 <syscall+0x83>
  801df7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dfc:	7e 37                	jle    801e35 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801dfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e02:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e05:	49 89 d0             	mov    %rdx,%r8
  801e08:	89 c1                	mov    %eax,%ecx
  801e0a:	48 ba 33 40 80 00 00 	movabs $0x804033,%rdx
  801e11:	00 00 00 
  801e14:	be 23 00 00 00       	mov    $0x23,%esi
  801e19:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  801e20:	00 00 00 
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	49 b9 1e 05 80 00 00 	movabs $0x80051e,%r9
  801e2f:	00 00 00 
  801e32:	41 ff d1             	callq  *%r9

	return ret;
  801e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e39:	48 83 c4 48          	add    $0x48,%rsp
  801e3d:	5b                   	pop    %rbx
  801e3e:	5d                   	pop    %rbp
  801e3f:	c3                   	retq   

0000000000801e40 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	48 83 ec 20          	sub    $0x20,%rsp
  801e48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e58:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5f:	00 
  801e60:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6c:	48 89 d1             	mov    %rdx,%rcx
  801e6f:	48 89 c2             	mov    %rax,%rdx
  801e72:	be 00 00 00 00       	mov    $0x0,%esi
  801e77:	bf 00 00 00 00       	mov    $0x0,%edi
  801e7c:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
}
  801e88:	c9                   	leaveq 
  801e89:	c3                   	retq   

0000000000801e8a <sys_cgetc>:

int
sys_cgetc(void)
{
  801e8a:	55                   	push   %rbp
  801e8b:	48 89 e5             	mov    %rsp,%rbp
  801e8e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801e92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e99:	00 
  801e9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	be 00 00 00 00       	mov    $0x0,%esi
  801eb5:	bf 01 00 00 00       	mov    $0x1,%edi
  801eba:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 10          	sub    $0x10,%rsp
  801ed0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed6:	48 98                	cltq   
  801ed8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edf:	00 
  801ee0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	be 01 00 00 00       	mov    $0x1,%esi
  801ef9:	bf 03 00 00 00       	mov    $0x3,%edi
  801efe:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	callq  *%rax
}
  801f0a:	c9                   	leaveq 
  801f0b:	c3                   	retq   

0000000000801f0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f0c:	55                   	push   %rbp
  801f0d:	48 89 e5             	mov    %rsp,%rbp
  801f10:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f1b:	00 
  801f1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f32:	be 00 00 00 00       	mov    $0x0,%esi
  801f37:	bf 02 00 00 00       	mov    $0x2,%edi
  801f3c:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
}
  801f48:	c9                   	leaveq 
  801f49:	c3                   	retq   

0000000000801f4a <sys_yield>:

void
sys_yield(void)
{
  801f4a:	55                   	push   %rbp
  801f4b:	48 89 e5             	mov    %rsp,%rbp
  801f4e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801f52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f59:	00 
  801f5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	be 00 00 00 00       	mov    $0x0,%esi
  801f75:	bf 0b 00 00 00       	mov    $0xb,%edi
  801f7a:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
}
  801f86:	c9                   	leaveq 
  801f87:	c3                   	retq   

0000000000801f88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801f88:	55                   	push   %rbp
  801f89:	48 89 e5             	mov    %rsp,%rbp
  801f8c:	48 83 ec 20          	sub    $0x20,%rsp
  801f90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f97:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801f9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f9d:	48 63 c8             	movslq %eax,%rcx
  801fa0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa7:	48 98                	cltq   
  801fa9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fb0:	00 
  801fb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fb7:	49 89 c8             	mov    %rcx,%r8
  801fba:	48 89 d1             	mov    %rdx,%rcx
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	be 01 00 00 00       	mov    $0x1,%esi
  801fc5:	bf 04 00 00 00       	mov    $0x4,%edi
  801fca:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  801fd1:	00 00 00 
  801fd4:	ff d0                	callq  *%rax
}
  801fd6:	c9                   	leaveq 
  801fd7:	c3                   	retq   

0000000000801fd8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801fd8:	55                   	push   %rbp
  801fd9:	48 89 e5             	mov    %rsp,%rbp
  801fdc:	48 83 ec 30          	sub    $0x30,%rsp
  801fe0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fe3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fe7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801fea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801fee:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ff2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ff5:	48 63 c8             	movslq %eax,%rcx
  801ff8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ffc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fff:	48 63 f0             	movslq %eax,%rsi
  802002:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802009:	48 98                	cltq   
  80200b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80200f:	49 89 f9             	mov    %rdi,%r9
  802012:	49 89 f0             	mov    %rsi,%r8
  802015:	48 89 d1             	mov    %rdx,%rcx
  802018:	48 89 c2             	mov    %rax,%rdx
  80201b:	be 01 00 00 00       	mov    $0x1,%esi
  802020:	bf 05 00 00 00       	mov    $0x5,%edi
  802025:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	callq  *%rax
}
  802031:	c9                   	leaveq 
  802032:	c3                   	retq   

0000000000802033 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802033:	55                   	push   %rbp
  802034:	48 89 e5             	mov    %rsp,%rbp
  802037:	48 83 ec 20          	sub    $0x20,%rsp
  80203b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80203e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802042:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802049:	48 98                	cltq   
  80204b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802052:	00 
  802053:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802059:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80205f:	48 89 d1             	mov    %rdx,%rcx
  802062:	48 89 c2             	mov    %rax,%rdx
  802065:	be 01 00 00 00       	mov    $0x1,%esi
  80206a:	bf 06 00 00 00       	mov    $0x6,%edi
  80206f:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  802076:	00 00 00 
  802079:	ff d0                	callq  *%rax
}
  80207b:	c9                   	leaveq 
  80207c:	c3                   	retq   

000000000080207d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80207d:	55                   	push   %rbp
  80207e:	48 89 e5             	mov    %rsp,%rbp
  802081:	48 83 ec 10          	sub    $0x10,%rsp
  802085:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802088:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80208b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80208e:	48 63 d0             	movslq %eax,%rdx
  802091:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802094:	48 98                	cltq   
  802096:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80209d:	00 
  80209e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020aa:	48 89 d1             	mov    %rdx,%rcx
  8020ad:	48 89 c2             	mov    %rax,%rdx
  8020b0:	be 01 00 00 00       	mov    $0x1,%esi
  8020b5:	bf 08 00 00 00       	mov    $0x8,%edi
  8020ba:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	callq  *%rax
}
  8020c6:	c9                   	leaveq 
  8020c7:	c3                   	retq   

00000000008020c8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8020c8:	55                   	push   %rbp
  8020c9:	48 89 e5             	mov    %rsp,%rbp
  8020cc:	48 83 ec 20          	sub    $0x20,%rsp
  8020d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8020d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020de:	48 98                	cltq   
  8020e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e7:	00 
  8020e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020f4:	48 89 d1             	mov    %rdx,%rcx
  8020f7:	48 89 c2             	mov    %rax,%rdx
  8020fa:	be 01 00 00 00       	mov    $0x1,%esi
  8020ff:	bf 09 00 00 00       	mov    $0x9,%edi
  802104:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 20          	sub    $0x20,%rsp
  80211a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80211d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802121:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802128:	48 98                	cltq   
  80212a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802131:	00 
  802132:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802138:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80213e:	48 89 d1             	mov    %rdx,%rcx
  802141:	48 89 c2             	mov    %rax,%rdx
  802144:	be 01 00 00 00       	mov    $0x1,%esi
  802149:	bf 0a 00 00 00       	mov    $0xa,%edi
  80214e:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  802155:	00 00 00 
  802158:	ff d0                	callq  *%rax
}
  80215a:	c9                   	leaveq 
  80215b:	c3                   	retq   

000000000080215c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80215c:	55                   	push   %rbp
  80215d:	48 89 e5             	mov    %rsp,%rbp
  802160:	48 83 ec 20          	sub    $0x20,%rsp
  802164:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802167:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80216b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80216f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802172:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802175:	48 63 f0             	movslq %eax,%rsi
  802178:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80217c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217f:	48 98                	cltq   
  802181:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802185:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80218c:	00 
  80218d:	49 89 f1             	mov    %rsi,%r9
  802190:	49 89 c8             	mov    %rcx,%r8
  802193:	48 89 d1             	mov    %rdx,%rcx
  802196:	48 89 c2             	mov    %rax,%rdx
  802199:	be 00 00 00 00       	mov    $0x0,%esi
  80219e:	bf 0c 00 00 00       	mov    $0xc,%edi
  8021a3:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax
}
  8021af:	c9                   	leaveq 
  8021b0:	c3                   	retq   

00000000008021b1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8021b1:	55                   	push   %rbp
  8021b2:	48 89 e5             	mov    %rsp,%rbp
  8021b5:	48 83 ec 10          	sub    $0x10,%rsp
  8021b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8021bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021c8:	00 
  8021c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021da:	48 89 c2             	mov    %rax,%rdx
  8021dd:	be 01 00 00 00       	mov    $0x1,%esi
  8021e2:	bf 0d 00 00 00       	mov    $0xd,%edi
  8021e7:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
}
  8021f3:	c9                   	leaveq 
  8021f4:	c3                   	retq   

00000000008021f5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021f5:	55                   	push   %rbp
  8021f6:	48 89 e5             	mov    %rsp,%rbp
  8021f9:	48 83 ec 08          	sub    $0x8,%rsp
  8021fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802201:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802205:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80220c:	ff ff ff 
  80220f:	48 01 d0             	add    %rdx,%rax
  802212:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802216:	c9                   	leaveq 
  802217:	c3                   	retq   

0000000000802218 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802218:	55                   	push   %rbp
  802219:	48 89 e5             	mov    %rsp,%rbp
  80221c:	48 83 ec 08          	sub    $0x8,%rsp
  802220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802228:	48 89 c7             	mov    %rax,%rdi
  80222b:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
  802237:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80223d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802241:	c9                   	leaveq 
  802242:	c3                   	retq   

0000000000802243 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802243:	55                   	push   %rbp
  802244:	48 89 e5             	mov    %rsp,%rbp
  802247:	48 83 ec 18          	sub    $0x18,%rsp
  80224b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80224f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802256:	eb 6b                	jmp    8022c3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225b:	48 98                	cltq   
  80225d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802263:	48 c1 e0 0c          	shl    $0xc,%rax
  802267:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	48 c1 e8 15          	shr    $0x15,%rax
  802273:	48 89 c2             	mov    %rax,%rdx
  802276:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80227d:	01 00 00 
  802280:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802284:	83 e0 01             	and    $0x1,%eax
  802287:	48 85 c0             	test   %rax,%rax
  80228a:	74 21                	je     8022ad <fd_alloc+0x6a>
  80228c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802290:	48 c1 e8 0c          	shr    $0xc,%rax
  802294:	48 89 c2             	mov    %rax,%rdx
  802297:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80229e:	01 00 00 
  8022a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a5:	83 e0 01             	and    $0x1,%eax
  8022a8:	48 85 c0             	test   %rax,%rax
  8022ab:	75 12                	jne    8022bf <fd_alloc+0x7c>
			*fd_store = fd;
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	eb 1a                	jmp    8022d9 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022bf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022c3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022c7:	7e 8f                	jle    802258 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022d4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022d9:	c9                   	leaveq 
  8022da:	c3                   	retq   

00000000008022db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022db:	55                   	push   %rbp
  8022dc:	48 89 e5             	mov    %rsp,%rbp
  8022df:	48 83 ec 20          	sub    $0x20,%rsp
  8022e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022ee:	78 06                	js     8022f6 <fd_lookup+0x1b>
  8022f0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022f4:	7e 07                	jle    8022fd <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022fb:	eb 6c                	jmp    802369 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802300:	48 98                	cltq   
  802302:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802308:	48 c1 e0 0c          	shl    $0xc,%rax
  80230c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802314:	48 c1 e8 15          	shr    $0x15,%rax
  802318:	48 89 c2             	mov    %rax,%rdx
  80231b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802322:	01 00 00 
  802325:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802329:	83 e0 01             	and    $0x1,%eax
  80232c:	48 85 c0             	test   %rax,%rax
  80232f:	74 21                	je     802352 <fd_lookup+0x77>
  802331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802335:	48 c1 e8 0c          	shr    $0xc,%rax
  802339:	48 89 c2             	mov    %rax,%rdx
  80233c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802343:	01 00 00 
  802346:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234a:	83 e0 01             	and    $0x1,%eax
  80234d:	48 85 c0             	test   %rax,%rax
  802350:	75 07                	jne    802359 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802352:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802357:	eb 10                	jmp    802369 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80235d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802361:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802369:	c9                   	leaveq 
  80236a:	c3                   	retq   

000000000080236b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
  80236f:	48 83 ec 30          	sub    $0x30,%rsp
  802373:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802377:	89 f0                	mov    %esi,%eax
  802379:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80237c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802380:	48 89 c7             	mov    %rax,%rdi
  802383:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  80238a:	00 00 00 
  80238d:	ff d0                	callq  *%rax
  80238f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
  8023a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ab:	78 0a                	js     8023b7 <fd_close+0x4c>
	    || fd != fd2)
  8023ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023b5:	74 12                	je     8023c9 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023b7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023bb:	74 05                	je     8023c2 <fd_close+0x57>
  8023bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c0:	eb 05                	jmp    8023c7 <fd_close+0x5c>
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	eb 69                	jmp    802432 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023cd:	8b 00                	mov    (%rax),%eax
  8023cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023d3:	48 89 d6             	mov    %rdx,%rsi
  8023d6:	89 c7                	mov    %eax,%edi
  8023d8:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
  8023e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023eb:	78 2a                	js     802417 <fd_close+0xac>
		if (dev->dev_close)
  8023ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023f5:	48 85 c0             	test   %rax,%rax
  8023f8:	74 16                	je     802410 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	48 8b 40 20          	mov    0x20(%rax),%rax
  802402:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802406:	48 89 d7             	mov    %rdx,%rdi
  802409:	ff d0                	callq  *%rax
  80240b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240e:	eb 07                	jmp    802417 <fd_close+0xac>
		else
			r = 0;
  802410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80241b:	48 89 c6             	mov    %rax,%rsi
  80241e:	bf 00 00 00 00       	mov    $0x0,%edi
  802423:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  80242a:	00 00 00 
  80242d:	ff d0                	callq  *%rax
	return r;
  80242f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 20          	sub    $0x20,%rsp
  80243c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80243f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80244a:	eb 41                	jmp    80248d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80244c:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802453:	00 00 00 
  802456:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802459:	48 63 d2             	movslq %edx,%rdx
  80245c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802460:	8b 00                	mov    (%rax),%eax
  802462:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802465:	75 22                	jne    802489 <dev_lookup+0x55>
			*dev = devtab[i];
  802467:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80246e:	00 00 00 
  802471:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802474:	48 63 d2             	movslq %edx,%rdx
  802477:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80247b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	eb 60                	jmp    8024e9 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802489:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80248d:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802494:	00 00 00 
  802497:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80249a:	48 63 d2             	movslq %edx,%rdx
  80249d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a1:	48 85 c0             	test   %rax,%rax
  8024a4:	75 a6                	jne    80244c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024a6:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8024ad:	00 00 00 
  8024b0:	48 8b 00             	mov    (%rax),%rax
  8024b3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024bc:	89 c6                	mov    %eax,%esi
  8024be:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  8024c5:	00 00 00 
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8024d4:	00 00 00 
  8024d7:	ff d1                	callq  *%rcx
	*dev = 0;
  8024d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024dd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024e9:	c9                   	leaveq 
  8024ea:	c3                   	retq   

00000000008024eb <close>:

int
close(int fdnum)
{
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
  8024ef:	48 83 ec 20          	sub    $0x20,%rsp
  8024f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024fd:	48 89 d6             	mov    %rdx,%rsi
  802500:	89 c7                	mov    %eax,%edi
  802502:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  802509:	00 00 00 
  80250c:	ff d0                	callq  *%rax
  80250e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802515:	79 05                	jns    80251c <close+0x31>
		return r;
  802517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251a:	eb 18                	jmp    802534 <close+0x49>
	else
		return fd_close(fd, 1);
  80251c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802520:	be 01 00 00 00       	mov    $0x1,%esi
  802525:	48 89 c7             	mov    %rax,%rdi
  802528:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  80252f:	00 00 00 
  802532:	ff d0                	callq  *%rax
}
  802534:	c9                   	leaveq 
  802535:	c3                   	retq   

0000000000802536 <close_all>:

void
close_all(void)
{
  802536:	55                   	push   %rbp
  802537:	48 89 e5             	mov    %rsp,%rbp
  80253a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80253e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802545:	eb 15                	jmp    80255c <close_all+0x26>
		close(i);
  802547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254a:	89 c7                	mov    %eax,%edi
  80254c:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  802553:	00 00 00 
  802556:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802558:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80255c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802560:	7e e5                	jle    802547 <close_all+0x11>
		close(i);
}
  802562:	c9                   	leaveq 
  802563:	c3                   	retq   

0000000000802564 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802564:	55                   	push   %rbp
  802565:	48 89 e5             	mov    %rsp,%rbp
  802568:	48 83 ec 40          	sub    $0x40,%rsp
  80256c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80256f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802572:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802576:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802579:	48 89 d6             	mov    %rdx,%rsi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802591:	79 08                	jns    80259b <dup+0x37>
		return r;
  802593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802596:	e9 70 01 00 00       	jmpq   80270b <dup+0x1a7>
	close(newfdnum);
  80259b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80259e:	89 c7                	mov    %eax,%edi
  8025a0:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  8025a7:	00 00 00 
  8025aa:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025ac:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025af:	48 98                	cltq   
  8025b1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025b7:	48 c1 e0 0c          	shl    $0xc,%rax
  8025bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025da:	48 89 c7             	mov    %rax,%rdi
  8025dd:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8025e4:	00 00 00 
  8025e7:	ff d0                	callq  *%rax
  8025e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f1:	48 c1 e8 15          	shr    $0x15,%rax
  8025f5:	48 89 c2             	mov    %rax,%rdx
  8025f8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025ff:	01 00 00 
  802602:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802606:	83 e0 01             	and    $0x1,%eax
  802609:	48 85 c0             	test   %rax,%rax
  80260c:	74 73                	je     802681 <dup+0x11d>
  80260e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802612:	48 c1 e8 0c          	shr    $0xc,%rax
  802616:	48 89 c2             	mov    %rax,%rdx
  802619:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802620:	01 00 00 
  802623:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802627:	83 e0 01             	and    $0x1,%eax
  80262a:	48 85 c0             	test   %rax,%rax
  80262d:	74 52                	je     802681 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80262f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802633:	48 c1 e8 0c          	shr    $0xc,%rax
  802637:	48 89 c2             	mov    %rax,%rdx
  80263a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802641:	01 00 00 
  802644:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802648:	25 07 0e 00 00       	and    $0xe07,%eax
  80264d:	89 c1                	mov    %eax,%ecx
  80264f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802657:	41 89 c8             	mov    %ecx,%r8d
  80265a:	48 89 d1             	mov    %rdx,%rcx
  80265d:	ba 00 00 00 00       	mov    $0x0,%edx
  802662:	48 89 c6             	mov    %rax,%rsi
  802665:	bf 00 00 00 00       	mov    $0x0,%edi
  80266a:	48 b8 d8 1f 80 00 00 	movabs $0x801fd8,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
  802676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267d:	79 02                	jns    802681 <dup+0x11d>
			goto err;
  80267f:	eb 57                	jmp    8026d8 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802685:	48 c1 e8 0c          	shr    $0xc,%rax
  802689:	48 89 c2             	mov    %rax,%rdx
  80268c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802693:	01 00 00 
  802696:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269a:	25 07 0e 00 00       	and    $0xe07,%eax
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a9:	41 89 c8             	mov    %ecx,%r8d
  8026ac:	48 89 d1             	mov    %rdx,%rcx
  8026af:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b4:	48 89 c6             	mov    %rax,%rsi
  8026b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bc:	48 b8 d8 1f 80 00 00 	movabs $0x801fd8,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
  8026c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cf:	79 02                	jns    8026d3 <dup+0x16f>
		goto err;
  8026d1:	eb 05                	jmp    8026d8 <dup+0x174>

	return newfdnum;
  8026d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026d6:	eb 33                	jmp    80270b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dc:	48 89 c6             	mov    %rax,%rsi
  8026df:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e4:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f4:	48 89 c6             	mov    %rax,%rsi
  8026f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026fc:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
	return r;
  802708:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80270b:	c9                   	leaveq 
  80270c:	c3                   	retq   

000000000080270d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80270d:	55                   	push   %rbp
  80270e:	48 89 e5             	mov    %rsp,%rbp
  802711:	48 83 ec 40          	sub    $0x40,%rsp
  802715:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802718:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80271c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802720:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802724:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802727:	48 89 d6             	mov    %rdx,%rsi
  80272a:	89 c7                	mov    %eax,%edi
  80272c:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
  802738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273f:	78 24                	js     802765 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802745:	8b 00                	mov    (%rax),%eax
  802747:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80274b:	48 89 d6             	mov    %rdx,%rsi
  80274e:	89 c7                	mov    %eax,%edi
  802750:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802757:	00 00 00 
  80275a:	ff d0                	callq  *%rax
  80275c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80275f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802763:	79 05                	jns    80276a <read+0x5d>
		return r;
  802765:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802768:	eb 76                	jmp    8027e0 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80276a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276e:	8b 40 08             	mov    0x8(%rax),%eax
  802771:	83 e0 03             	and    $0x3,%eax
  802774:	83 f8 01             	cmp    $0x1,%eax
  802777:	75 3a                	jne    8027b3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802779:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  802780:	00 00 00 
  802783:	48 8b 00             	mov    (%rax),%rax
  802786:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80278c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	48 bf 7f 40 80 00 00 	movabs $0x80407f,%rdi
  802798:	00 00 00 
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8027a7:	00 00 00 
  8027aa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027b1:	eb 2d                	jmp    8027e0 <read+0xd3>
	}
	if (!dev->dev_read)
  8027b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027bb:	48 85 c0             	test   %rax,%rax
  8027be:	75 07                	jne    8027c7 <read+0xba>
		return -E_NOT_SUPP;
  8027c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027c5:	eb 19                	jmp    8027e0 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027d3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027d7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027db:	48 89 cf             	mov    %rcx,%rdi
  8027de:	ff d0                	callq  *%rax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 30          	sub    $0x30,%rsp
  8027ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027fc:	eb 49                	jmp    802847 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802801:	48 98                	cltq   
  802803:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802807:	48 29 c2             	sub    %rax,%rdx
  80280a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280d:	48 63 c8             	movslq %eax,%rcx
  802810:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802814:	48 01 c1             	add    %rax,%rcx
  802817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80281a:	48 89 ce             	mov    %rcx,%rsi
  80281d:	89 c7                	mov    %eax,%edi
  80281f:	48 b8 0d 27 80 00 00 	movabs $0x80270d,%rax
  802826:	00 00 00 
  802829:	ff d0                	callq  *%rax
  80282b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80282e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802832:	79 05                	jns    802839 <readn+0x57>
			return m;
  802834:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802837:	eb 1c                	jmp    802855 <readn+0x73>
		if (m == 0)
  802839:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80283d:	75 02                	jne    802841 <readn+0x5f>
			break;
  80283f:	eb 11                	jmp    802852 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802841:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802844:	01 45 fc             	add    %eax,-0x4(%rbp)
  802847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284a:	48 98                	cltq   
  80284c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802850:	72 ac                	jb     8027fe <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802855:	c9                   	leaveq 
  802856:	c3                   	retq   

0000000000802857 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802857:	55                   	push   %rbp
  802858:	48 89 e5             	mov    %rsp,%rbp
  80285b:	48 83 ec 40          	sub    $0x40,%rsp
  80285f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802862:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802866:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80286a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80286e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802871:	48 89 d6             	mov    %rdx,%rsi
  802874:	89 c7                	mov    %eax,%edi
  802876:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  80287d:	00 00 00 
  802880:	ff d0                	callq  *%rax
  802882:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802885:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802889:	78 24                	js     8028af <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80288b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288f:	8b 00                	mov    (%rax),%eax
  802891:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802895:	48 89 d6             	mov    %rdx,%rsi
  802898:	89 c7                	mov    %eax,%edi
  80289a:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8028a1:	00 00 00 
  8028a4:	ff d0                	callq  *%rax
  8028a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ad:	79 05                	jns    8028b4 <write+0x5d>
		return r;
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b2:	eb 75                	jmp    802929 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b8:	8b 40 08             	mov    0x8(%rax),%eax
  8028bb:	83 e0 03             	and    $0x3,%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	75 3a                	jne    8028fc <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028c2:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8028c9:	00 00 00 
  8028cc:	48 8b 00             	mov    (%rax),%rax
  8028cf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028d5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028d8:	89 c6                	mov    %eax,%esi
  8028da:	48 bf 9b 40 80 00 00 	movabs $0x80409b,%rdi
  8028e1:	00 00 00 
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  8028f0:	00 00 00 
  8028f3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028fa:	eb 2d                	jmp    802929 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802900:	48 8b 40 18          	mov    0x18(%rax),%rax
  802904:	48 85 c0             	test   %rax,%rax
  802907:	75 07                	jne    802910 <write+0xb9>
		return -E_NOT_SUPP;
  802909:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80290e:	eb 19                	jmp    802929 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802910:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802914:	48 8b 40 18          	mov    0x18(%rax),%rax
  802918:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80291c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802920:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802924:	48 89 cf             	mov    %rcx,%rdi
  802927:	ff d0                	callq  *%rax
}
  802929:	c9                   	leaveq 
  80292a:	c3                   	retq   

000000000080292b <seek>:

int
seek(int fdnum, off_t offset)
{
  80292b:	55                   	push   %rbp
  80292c:	48 89 e5             	mov    %rsp,%rbp
  80292f:	48 83 ec 18          	sub    $0x18,%rsp
  802933:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802936:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802939:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80293d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802940:	48 89 d6             	mov    %rdx,%rsi
  802943:	89 c7                	mov    %eax,%edi
  802945:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax
  802951:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802954:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802958:	79 05                	jns    80295f <seek+0x34>
		return r;
  80295a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295d:	eb 0f                	jmp    80296e <seek+0x43>
	fd->fd_offset = offset;
  80295f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802963:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802966:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296e:	c9                   	leaveq 
  80296f:	c3                   	retq   

0000000000802970 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802970:	55                   	push   %rbp
  802971:	48 89 e5             	mov    %rsp,%rbp
  802974:	48 83 ec 30          	sub    $0x30,%rsp
  802978:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80297b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80297e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802982:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802985:	48 89 d6             	mov    %rdx,%rsi
  802988:	89 c7                	mov    %eax,%edi
  80298a:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax
  802996:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802999:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299d:	78 24                	js     8029c3 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80299f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a3:	8b 00                	mov    (%rax),%eax
  8029a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a9:	48 89 d6             	mov    %rdx,%rsi
  8029ac:	89 c7                	mov    %eax,%edi
  8029ae:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
  8029ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c1:	79 05                	jns    8029c8 <ftruncate+0x58>
		return r;
  8029c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c6:	eb 72                	jmp    802a3a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cc:	8b 40 08             	mov    0x8(%rax),%eax
  8029cf:	83 e0 03             	and    $0x3,%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	75 3a                	jne    802a10 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029d6:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8029dd:	00 00 00 
  8029e0:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029e3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029ec:	89 c6                	mov    %eax,%esi
  8029ee:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  8029f5:	00 00 00 
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fd:	48 b9 57 07 80 00 00 	movabs $0x800757,%rcx
  802a04:	00 00 00 
  802a07:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a0e:	eb 2a                	jmp    802a3a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a14:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a18:	48 85 c0             	test   %rax,%rax
  802a1b:	75 07                	jne    802a24 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a1d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a22:	eb 16                	jmp    802a3a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a28:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a2c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a30:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a33:	89 ce                	mov    %ecx,%esi
  802a35:	48 89 d7             	mov    %rdx,%rdi
  802a38:	ff d0                	callq  *%rax
}
  802a3a:	c9                   	leaveq 
  802a3b:	c3                   	retq   

0000000000802a3c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a3c:	55                   	push   %rbp
  802a3d:	48 89 e5             	mov    %rsp,%rbp
  802a40:	48 83 ec 30          	sub    $0x30,%rsp
  802a44:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a47:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a4b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a4f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a52:	48 89 d6             	mov    %rdx,%rsi
  802a55:	89 c7                	mov    %eax,%edi
  802a57:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
  802a63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6a:	78 24                	js     802a90 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a70:	8b 00                	mov    (%rax),%eax
  802a72:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a76:	48 89 d6             	mov    %rdx,%rsi
  802a79:	89 c7                	mov    %eax,%edi
  802a7b:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
  802a87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8e:	79 05                	jns    802a95 <fstat+0x59>
		return r;
  802a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a93:	eb 5e                	jmp    802af3 <fstat+0xb7>
	if (!dev->dev_stat)
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a9d:	48 85 c0             	test   %rax,%rax
  802aa0:	75 07                	jne    802aa9 <fstat+0x6d>
		return -E_NOT_SUPP;
  802aa2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aa7:	eb 4a                	jmp    802af3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802aa9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aad:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ab0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ab4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802abb:	00 00 00 
	stat->st_isdir = 0;
  802abe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ac2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ac9:	00 00 00 
	stat->st_dev = dev;
  802acc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ad0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802adf:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ae3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802aeb:	48 89 ce             	mov    %rcx,%rsi
  802aee:	48 89 d7             	mov    %rdx,%rdi
  802af1:	ff d0                	callq  *%rax
}
  802af3:	c9                   	leaveq 
  802af4:	c3                   	retq   

0000000000802af5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802af5:	55                   	push   %rbp
  802af6:	48 89 e5             	mov    %rsp,%rbp
  802af9:	48 83 ec 20          	sub    $0x20,%rsp
  802afd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b09:	be 00 00 00 00       	mov    $0x0,%esi
  802b0e:	48 89 c7             	mov    %rax,%rdi
  802b11:	48 b8 e3 2b 80 00 00 	movabs $0x802be3,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b24:	79 05                	jns    802b2b <stat+0x36>
		return fd;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	eb 2f                	jmp    802b5a <stat+0x65>
	r = fstat(fd, stat);
  802b2b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b32:	48 89 d6             	mov    %rdx,%rsi
  802b35:	89 c7                	mov    %eax,%edi
  802b37:	48 b8 3c 2a 80 00 00 	movabs $0x802a3c,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
  802b43:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b49:	89 c7                	mov    %eax,%edi
  802b4b:	48 b8 eb 24 80 00 00 	movabs $0x8024eb,%rax
  802b52:	00 00 00 
  802b55:	ff d0                	callq  *%rax
	return r;
  802b57:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b5a:	c9                   	leaveq 
  802b5b:	c3                   	retq   

0000000000802b5c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b5c:	55                   	push   %rbp
  802b5d:	48 89 e5             	mov    %rsp,%rbp
  802b60:	48 83 ec 10          	sub    $0x10,%rsp
  802b64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b6b:	48 b8 20 64 80 00 00 	movabs $0x806420,%rax
  802b72:	00 00 00 
  802b75:	8b 00                	mov    (%rax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	75 1d                	jne    802b98 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b7b:	bf 01 00 00 00       	mov    $0x1,%edi
  802b80:	48 b8 a3 39 80 00 00 	movabs $0x8039a3,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	48 ba 20 64 80 00 00 	movabs $0x806420,%rdx
  802b93:	00 00 00 
  802b96:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b98:	48 b8 20 64 80 00 00 	movabs $0x806420,%rax
  802b9f:	00 00 00 
  802ba2:	8b 00                	mov    (%rax),%eax
  802ba4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ba7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bac:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802bb3:	00 00 00 
  802bb6:	89 c7                	mov    %eax,%edi
  802bb8:	48 b8 0b 39 80 00 00 	movabs $0x80390b,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcd:	48 89 c6             	mov    %rax,%rsi
  802bd0:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd5:	48 b8 42 38 80 00 00 	movabs $0x803842,%rax
  802bdc:	00 00 00 
  802bdf:	ff d0                	callq  *%rax
}
  802be1:	c9                   	leaveq 
  802be2:	c3                   	retq   

0000000000802be3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802be3:	55                   	push   %rbp
  802be4:	48 89 e5             	mov    %rsp,%rbp
  802be7:	48 83 ec 20          	sub    $0x20,%rsp
  802beb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bef:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf6:	48 89 c7             	mov    %rax,%rdi
  802bf9:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
  802c05:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c0a:	7e 0a                	jle    802c16 <open+0x33>
		return -E_BAD_PATH;
  802c0c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c11:	e9 a5 00 00 00       	jmpq   802cbb <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802c16:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c1a:	48 89 c7             	mov    %rax,%rdi
  802c1d:	48 b8 43 22 80 00 00 	movabs $0x802243,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c30:	79 08                	jns    802c3a <open+0x57>
		return r;
  802c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c35:	e9 81 00 00 00       	jmpq   802cbb <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	48 89 c6             	mov    %rax,%rsi
  802c41:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802c48:	00 00 00 
  802c4b:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  802c52:	00 00 00 
  802c55:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802c57:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c5e:	00 00 00 
  802c61:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c64:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802c6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6e:	48 89 c6             	mov    %rax,%rsi
  802c71:	bf 01 00 00 00       	mov    $0x1,%edi
  802c76:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c89:	79 1d                	jns    802ca8 <open+0xc5>
		fd_close(fd, 0);
  802c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8f:	be 00 00 00 00       	mov    $0x0,%esi
  802c94:	48 89 c7             	mov    %rax,%rdi
  802c97:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
		return r;
  802ca3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca6:	eb 13                	jmp    802cbb <open+0xd8>
	}

	return fd2num(fd);
  802ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cac:	48 89 c7             	mov    %rax,%rdi
  802caf:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802cbb:	c9                   	leaveq 
  802cbc:	c3                   	retq   

0000000000802cbd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cbd:	55                   	push   %rbp
  802cbe:	48 89 e5             	mov    %rsp,%rbp
  802cc1:	48 83 ec 10          	sub    $0x10,%rsp
  802cc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ccd:	8b 50 0c             	mov    0xc(%rax),%edx
  802cd0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cd7:	00 00 00 
  802cda:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802cdc:	be 00 00 00 00       	mov    $0x0,%esi
  802ce1:	bf 06 00 00 00       	mov    $0x6,%edi
  802ce6:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802ced:	00 00 00 
  802cf0:	ff d0                	callq  *%rax
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 30          	sub    $0x30,%rsp
  802cfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0c:	8b 50 0c             	mov    0xc(%rax),%edx
  802d0f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d16:	00 00 00 
  802d19:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d1b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d22:	00 00 00 
  802d25:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d29:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d2d:	be 00 00 00 00       	mov    $0x0,%esi
  802d32:	bf 03 00 00 00       	mov    $0x3,%edi
  802d37:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
  802d43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4a:	79 05                	jns    802d51 <devfile_read+0x5d>
		return r;
  802d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4f:	eb 26                	jmp    802d77 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d54:	48 63 d0             	movslq %eax,%rdx
  802d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d5b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802d62:	00 00 00 
  802d65:	48 89 c7             	mov    %rax,%rdi
  802d68:	48 b8 7d 19 80 00 00 	movabs $0x80197d,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax

	return r;
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d77:	c9                   	leaveq 
  802d78:	c3                   	retq   

0000000000802d79 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d79:	55                   	push   %rbp
  802d7a:	48 89 e5             	mov    %rsp,%rbp
  802d7d:	48 83 ec 30          	sub    $0x30,%rsp
  802d81:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d89:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802d8d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d94:	00 
  802d95:	76 08                	jbe    802d9f <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802d97:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d9e:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da3:	8b 50 0c             	mov    0xc(%rax),%edx
  802da6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dad:	00 00 00 
  802db0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802db2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802db9:	00 00 00 
  802dbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dc0:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802dc4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dcc:	48 89 c6             	mov    %rax,%rsi
  802dcf:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802dd6:	00 00 00 
  802dd9:	48 b8 7d 19 80 00 00 	movabs $0x80197d,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802de5:	be 00 00 00 00       	mov    $0x0,%esi
  802dea:	bf 04 00 00 00       	mov    $0x4,%edi
  802def:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802df6:	00 00 00 
  802df9:	ff d0                	callq  *%rax
  802dfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e02:	79 05                	jns    802e09 <devfile_write+0x90>
		return r;
  802e04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e07:	eb 03                	jmp    802e0c <devfile_write+0x93>

	return r;
  802e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e0c:	c9                   	leaveq 
  802e0d:	c3                   	retq   

0000000000802e0e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e0e:	55                   	push   %rbp
  802e0f:	48 89 e5             	mov    %rsp,%rbp
  802e12:	48 83 ec 20          	sub    $0x20,%rsp
  802e16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e22:	8b 50 0c             	mov    0xc(%rax),%edx
  802e25:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e2c:	00 00 00 
  802e2f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e31:	be 00 00 00 00       	mov    $0x0,%esi
  802e36:	bf 05 00 00 00       	mov    $0x5,%edi
  802e3b:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802e42:	00 00 00 
  802e45:	ff d0                	callq  *%rax
  802e47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4e:	79 05                	jns    802e55 <devfile_stat+0x47>
		return r;
  802e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e53:	eb 56                	jmp    802eab <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e59:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802e60:	00 00 00 
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e72:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e79:	00 00 00 
  802e7c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e86:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e8c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e93:	00 00 00 
  802e96:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eab:	c9                   	leaveq 
  802eac:	c3                   	retq   

0000000000802ead <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ead:	55                   	push   %rbp
  802eae:	48 89 e5             	mov    %rsp,%rbp
  802eb1:	48 83 ec 10          	sub    $0x10,%rsp
  802eb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ebc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec0:	8b 50 0c             	mov    0xc(%rax),%edx
  802ec3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802eca:	00 00 00 
  802ecd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ecf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ed6:	00 00 00 
  802ed9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802edc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802edf:	be 00 00 00 00       	mov    $0x0,%esi
  802ee4:	bf 02 00 00 00       	mov    $0x2,%edi
  802ee9:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
}
  802ef5:	c9                   	leaveq 
  802ef6:	c3                   	retq   

0000000000802ef7 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ef7:	55                   	push   %rbp
  802ef8:	48 89 e5             	mov    %rsp,%rbp
  802efb:	48 83 ec 10          	sub    $0x10,%rsp
  802eff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f07:	48 89 c7             	mov    %rax,%rdi
  802f0a:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f1b:	7e 07                	jle    802f24 <remove+0x2d>
		return -E_BAD_PATH;
  802f1d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f22:	eb 33                	jmp    802f57 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f28:	48 89 c6             	mov    %rax,%rsi
  802f2b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802f32:	00 00 00 
  802f35:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  802f3c:	00 00 00 
  802f3f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f41:	be 00 00 00 00       	mov    $0x0,%esi
  802f46:	bf 07 00 00 00       	mov    $0x7,%edi
  802f4b:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f5d:	be 00 00 00 00       	mov    $0x0,%esi
  802f62:	bf 08 00 00 00       	mov    $0x8,%edi
  802f67:	48 b8 5c 2b 80 00 00 	movabs $0x802b5c,%rax
  802f6e:	00 00 00 
  802f71:	ff d0                	callq  *%rax
}
  802f73:	5d                   	pop    %rbp
  802f74:	c3                   	retq   

0000000000802f75 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802f75:	55                   	push   %rbp
  802f76:	48 89 e5             	mov    %rsp,%rbp
  802f79:	48 83 ec 20          	sub    $0x20,%rsp
  802f7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f85:	8b 40 0c             	mov    0xc(%rax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	7e 67                	jle    802ff3 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f90:	8b 40 04             	mov    0x4(%rax),%eax
  802f93:	48 63 d0             	movslq %eax,%rdx
  802f96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9a:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa2:	8b 00                	mov    (%rax),%eax
  802fa4:	48 89 ce             	mov    %rcx,%rsi
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 57 28 80 00 00 	movabs $0x802857,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
  802fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbc:	7e 13                	jle    802fd1 <writebuf+0x5c>
			b->result += result;
  802fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc2:	8b 50 08             	mov    0x8(%rax),%edx
  802fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc8:	01 c2                	add    %eax,%edx
  802fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fce:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd5:	8b 40 04             	mov    0x4(%rax),%eax
  802fd8:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fdb:	74 16                	je     802ff3 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe6:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802fea:	89 c2                	mov    %eax,%edx
  802fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff0:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802ff3:	c9                   	leaveq 
  802ff4:	c3                   	retq   

0000000000802ff5 <putch>:

static void
putch(int ch, void *thunk)
{
  802ff5:	55                   	push   %rbp
  802ff6:	48 89 e5             	mov    %rsp,%rbp
  802ff9:	48 83 ec 20          	sub    $0x20,%rsp
  802ffd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803000:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803004:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803008:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80300c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803010:	8b 40 04             	mov    0x4(%rax),%eax
  803013:	8d 48 01             	lea    0x1(%rax),%ecx
  803016:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80301a:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80301d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803020:	89 d1                	mov    %edx,%ecx
  803022:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803026:	48 98                	cltq   
  803028:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80302c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803030:	8b 40 04             	mov    0x4(%rax),%eax
  803033:	3d 00 01 00 00       	cmp    $0x100,%eax
  803038:	75 1e                	jne    803058 <putch+0x63>
		writebuf(b);
  80303a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80303e:	48 89 c7             	mov    %rax,%rdi
  803041:	48 b8 75 2f 80 00 00 	movabs $0x802f75,%rax
  803048:	00 00 00 
  80304b:	ff d0                	callq  *%rax
		b->idx = 0;
  80304d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803051:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803058:	c9                   	leaveq 
  803059:	c3                   	retq   

000000000080305a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80305a:	55                   	push   %rbp
  80305b:	48 89 e5             	mov    %rsp,%rbp
  80305e:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803065:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80306b:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803072:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803079:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80307f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803085:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80308c:	00 00 00 
	b.result = 0;
  80308f:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803096:	00 00 00 
	b.error = 1;
  803099:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8030a0:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8030a3:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8030aa:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8030b1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030b8:	48 89 c6             	mov    %rax,%rsi
  8030bb:	48 bf f5 2f 80 00 00 	movabs $0x802ff5,%rdi
  8030c2:	00 00 00 
  8030c5:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8030d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	7e 16                	jle    8030f1 <vfprintf+0x97>
		writebuf(&b);
  8030db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8030e2:	48 89 c7             	mov    %rax,%rdi
  8030e5:	48 b8 75 2f 80 00 00 	movabs $0x802f75,%rax
  8030ec:	00 00 00 
  8030ef:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8030f1:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 08                	je     803103 <vfprintf+0xa9>
  8030fb:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803101:	eb 06                	jmp    803109 <vfprintf+0xaf>
  803103:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803109:	c9                   	leaveq 
  80310a:	c3                   	retq   

000000000080310b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80310b:	55                   	push   %rbp
  80310c:	48 89 e5             	mov    %rsp,%rbp
  80310f:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803116:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80311c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803123:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80312a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803131:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803138:	84 c0                	test   %al,%al
  80313a:	74 20                	je     80315c <fprintf+0x51>
  80313c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803140:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803144:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803148:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80314c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803150:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803154:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803158:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80315c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803163:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80316a:	00 00 00 
  80316d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803174:	00 00 00 
  803177:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80317b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803182:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803189:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803190:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803197:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80319e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031a4:	48 89 ce             	mov    %rcx,%rsi
  8031a7:	89 c7                	mov    %eax,%edi
  8031a9:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  8031b0:	00 00 00 
  8031b3:	ff d0                	callq  *%rax
  8031b5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8031bb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8031c1:	c9                   	leaveq 
  8031c2:	c3                   	retq   

00000000008031c3 <printf>:

int
printf(const char *fmt, ...)
{
  8031c3:	55                   	push   %rbp
  8031c4:	48 89 e5             	mov    %rsp,%rbp
  8031c7:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8031ce:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031d5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031f1:	84 c0                	test   %al,%al
  8031f3:	74 20                	je     803215 <printf+0x52>
  8031f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803201:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803205:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803209:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80320d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803211:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803215:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80321c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803223:	00 00 00 
  803226:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80322d:	00 00 00 
  803230:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803234:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80323b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803242:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803249:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803250:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803257:	48 89 c6             	mov    %rax,%rsi
  80325a:	bf 01 00 00 00       	mov    $0x1,%edi
  80325f:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803271:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803277:	c9                   	leaveq 
  803278:	c3                   	retq   

0000000000803279 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	53                   	push   %rbx
  80327e:	48 83 ec 38          	sub    $0x38,%rsp
  803282:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803286:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80328a:	48 89 c7             	mov    %rax,%rdi
  80328d:	48 b8 43 22 80 00 00 	movabs $0x802243,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
  803299:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a0:	0f 88 bf 01 00 00    	js     803465 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8032af:	48 89 c6             	mov    %rax,%rsi
  8032b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b7:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ca:	0f 88 95 01 00 00    	js     803465 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032d0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032d4:	48 89 c7             	mov    %rax,%rdi
  8032d7:	48 b8 43 22 80 00 00 	movabs $0x802243,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ea:	0f 88 5d 01 00 00    	js     80344d <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032f9:	48 89 c6             	mov    %rax,%rsi
  8032fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803301:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803310:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803314:	0f 88 33 01 00 00    	js     80344d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	48 89 c7             	mov    %rax,%rdi
  803321:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
  80332d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803335:	ba 07 04 00 00       	mov    $0x407,%edx
  80333a:	48 89 c6             	mov    %rax,%rsi
  80333d:	bf 00 00 00 00       	mov    $0x0,%edi
  803342:	48 b8 88 1f 80 00 00 	movabs $0x801f88,%rax
  803349:	00 00 00 
  80334c:	ff d0                	callq  *%rax
  80334e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803351:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803355:	79 05                	jns    80335c <pipe+0xe3>
		goto err2;
  803357:	e9 d9 00 00 00       	jmpq   803435 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80335c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803360:	48 89 c7             	mov    %rax,%rdi
  803363:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  80336a:	00 00 00 
  80336d:	ff d0                	callq  *%rax
  80336f:	48 89 c2             	mov    %rax,%rdx
  803372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803376:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80337c:	48 89 d1             	mov    %rdx,%rcx
  80337f:	ba 00 00 00 00       	mov    $0x0,%edx
  803384:	48 89 c6             	mov    %rax,%rsi
  803387:	bf 00 00 00 00       	mov    $0x0,%edi
  80338c:	48 b8 d8 1f 80 00 00 	movabs $0x801fd8,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
  803398:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80339f:	79 1b                	jns    8033bc <pipe+0x143>
		goto err3;
  8033a1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8033a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a6:	48 89 c6             	mov    %rax,%rsi
  8033a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ae:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
  8033ba:	eb 79                	jmp    803435 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c0:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8033c7:	00 00 00 
  8033ca:	8b 12                	mov    (%rdx),%edx
  8033cc:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033dd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8033e4:	00 00 00 
  8033e7:	8b 12                	mov    (%rdx),%edx
  8033e9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fa:	48 89 c7             	mov    %rax,%rdi
  8033fd:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
  803409:	89 c2                	mov    %eax,%edx
  80340b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80340f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803411:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803415:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803419:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 f5 21 80 00 00 	movabs $0x8021f5,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80342e:	b8 00 00 00 00       	mov    $0x0,%eax
  803433:	eb 33                	jmp    803468 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803435:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803439:	48 89 c6             	mov    %rax,%rsi
  80343c:	bf 00 00 00 00       	mov    $0x0,%edi
  803441:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80344d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803451:	48 89 c6             	mov    %rax,%rsi
  803454:	bf 00 00 00 00       	mov    $0x0,%edi
  803459:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
    err:
	return r;
  803465:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803468:	48 83 c4 38          	add    $0x38,%rsp
  80346c:	5b                   	pop    %rbx
  80346d:	5d                   	pop    %rbp
  80346e:	c3                   	retq   

000000000080346f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80346f:	55                   	push   %rbp
  803470:	48 89 e5             	mov    %rsp,%rbp
  803473:	53                   	push   %rbx
  803474:	48 83 ec 28          	sub    $0x28,%rsp
  803478:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80347c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803480:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  803487:	00 00 00 
  80348a:	48 8b 00             	mov    (%rax),%rax
  80348d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803493:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803496:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349a:	48 89 c7             	mov    %rax,%rdi
  80349d:	48 b8 25 3a 80 00 00 	movabs $0x803a25,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
  8034a9:	89 c3                	mov    %eax,%ebx
  8034ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034af:	48 89 c7             	mov    %rax,%rdi
  8034b2:	48 b8 25 3a 80 00 00 	movabs $0x803a25,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
  8034be:	39 c3                	cmp    %eax,%ebx
  8034c0:	0f 94 c0             	sete   %al
  8034c3:	0f b6 c0             	movzbl %al,%eax
  8034c6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034c9:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8034d0:	00 00 00 
  8034d3:	48 8b 00             	mov    (%rax),%rax
  8034d6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034dc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034e5:	75 05                	jne    8034ec <_pipeisclosed+0x7d>
			return ret;
  8034e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034ea:	eb 4f                	jmp    80353b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ef:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034f2:	74 42                	je     803536 <_pipeisclosed+0xc7>
  8034f4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034f8:	75 3c                	jne    803536 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034fa:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  803501:	00 00 00 
  803504:	48 8b 00             	mov    (%rax),%rax
  803507:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80350d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803513:	89 c6                	mov    %eax,%esi
  803515:	48 bf e3 40 80 00 00 	movabs $0x8040e3,%rdi
  80351c:	00 00 00 
  80351f:	b8 00 00 00 00       	mov    $0x0,%eax
  803524:	49 b8 57 07 80 00 00 	movabs $0x800757,%r8
  80352b:	00 00 00 
  80352e:	41 ff d0             	callq  *%r8
	}
  803531:	e9 4a ff ff ff       	jmpq   803480 <_pipeisclosed+0x11>
  803536:	e9 45 ff ff ff       	jmpq   803480 <_pipeisclosed+0x11>
}
  80353b:	48 83 c4 28          	add    $0x28,%rsp
  80353f:	5b                   	pop    %rbx
  803540:	5d                   	pop    %rbp
  803541:	c3                   	retq   

0000000000803542 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803542:	55                   	push   %rbp
  803543:	48 89 e5             	mov    %rsp,%rbp
  803546:	48 83 ec 30          	sub    $0x30,%rsp
  80354a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80354d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803551:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803554:	48 89 d6             	mov    %rdx,%rsi
  803557:	89 c7                	mov    %eax,%edi
  803559:	48 b8 db 22 80 00 00 	movabs $0x8022db,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
  803565:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356c:	79 05                	jns    803573 <pipeisclosed+0x31>
		return r;
  80356e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803571:	eb 31                	jmp    8035a4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803577:	48 89 c7             	mov    %rax,%rdi
  80357a:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80358a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803592:	48 89 d6             	mov    %rdx,%rsi
  803595:	48 89 c7             	mov    %rax,%rdi
  803598:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
}
  8035a4:	c9                   	leaveq 
  8035a5:	c3                   	retq   

00000000008035a6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035a6:	55                   	push   %rbp
  8035a7:	48 89 e5             	mov    %rsp,%rbp
  8035aa:	48 83 ec 40          	sub    $0x40,%rsp
  8035ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035be:	48 89 c7             	mov    %rax,%rdi
  8035c1:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
  8035cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035d9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035e0:	00 
  8035e1:	e9 92 00 00 00       	jmpq   803678 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035e6:	eb 41                	jmp    803629 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035e8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035ed:	74 09                	je     8035f8 <devpipe_read+0x52>
				return i;
  8035ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f3:	e9 92 00 00 00       	jmpq   80368a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803600:	48 89 d6             	mov    %rdx,%rsi
  803603:	48 89 c7             	mov    %rax,%rdi
  803606:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
  803612:	85 c0                	test   %eax,%eax
  803614:	74 07                	je     80361d <devpipe_read+0x77>
				return 0;
  803616:	b8 00 00 00 00       	mov    $0x0,%eax
  80361b:	eb 6d                	jmp    80368a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80361d:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362d:	8b 10                	mov    (%rax),%edx
  80362f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803633:	8b 40 04             	mov    0x4(%rax),%eax
  803636:	39 c2                	cmp    %eax,%edx
  803638:	74 ae                	je     8035e8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80363a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803642:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364a:	8b 00                	mov    (%rax),%eax
  80364c:	99                   	cltd   
  80364d:	c1 ea 1b             	shr    $0x1b,%edx
  803650:	01 d0                	add    %edx,%eax
  803652:	83 e0 1f             	and    $0x1f,%eax
  803655:	29 d0                	sub    %edx,%eax
  803657:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80365b:	48 98                	cltq   
  80365d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803662:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803668:	8b 00                	mov    (%rax),%eax
  80366a:	8d 50 01             	lea    0x1(%rax),%edx
  80366d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803671:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803673:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803680:	0f 82 60 ff ff ff    	jb     8035e6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80368a:	c9                   	leaveq 
  80368b:	c3                   	retq   

000000000080368c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80368c:	55                   	push   %rbp
  80368d:	48 89 e5             	mov    %rsp,%rbp
  803690:	48 83 ec 40          	sub    $0x40,%rsp
  803694:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803698:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80369c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a4:	48 89 c7             	mov    %rax,%rdi
  8036a7:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036c6:	00 
  8036c7:	e9 8e 00 00 00       	jmpq   80375a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036cc:	eb 31                	jmp    8036ff <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d6:	48 89 d6             	mov    %rdx,%rsi
  8036d9:	48 89 c7             	mov    %rax,%rdi
  8036dc:	48 b8 6f 34 80 00 00 	movabs $0x80346f,%rax
  8036e3:	00 00 00 
  8036e6:	ff d0                	callq  *%rax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 07                	je     8036f3 <devpipe_write+0x67>
				return 0;
  8036ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f1:	eb 79                	jmp    80376c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036f3:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803703:	8b 40 04             	mov    0x4(%rax),%eax
  803706:	48 63 d0             	movslq %eax,%rdx
  803709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370d:	8b 00                	mov    (%rax),%eax
  80370f:	48 98                	cltq   
  803711:	48 83 c0 20          	add    $0x20,%rax
  803715:	48 39 c2             	cmp    %rax,%rdx
  803718:	73 b4                	jae    8036ce <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80371a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371e:	8b 40 04             	mov    0x4(%rax),%eax
  803721:	99                   	cltd   
  803722:	c1 ea 1b             	shr    $0x1b,%edx
  803725:	01 d0                	add    %edx,%eax
  803727:	83 e0 1f             	and    $0x1f,%eax
  80372a:	29 d0                	sub    %edx,%eax
  80372c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803730:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803734:	48 01 ca             	add    %rcx,%rdx
  803737:	0f b6 0a             	movzbl (%rdx),%ecx
  80373a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80373e:	48 98                	cltq   
  803740:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803748:	8b 40 04             	mov    0x4(%rax),%eax
  80374b:	8d 50 01             	lea    0x1(%rax),%edx
  80374e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803752:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803755:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80375a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803762:	0f 82 64 ff ff ff    	jb     8036cc <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80376c:	c9                   	leaveq 
  80376d:	c3                   	retq   

000000000080376e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80376e:	55                   	push   %rbp
  80376f:	48 89 e5             	mov    %rsp,%rbp
  803772:	48 83 ec 20          	sub    $0x20,%rsp
  803776:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80377a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80377e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803782:	48 89 c7             	mov    %rax,%rdi
  803785:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  80378c:	00 00 00 
  80378f:	ff d0                	callq  *%rax
  803791:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803795:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803799:	48 be f6 40 80 00 00 	movabs $0x8040f6,%rsi
  8037a0:	00 00 00 
  8037a3:	48 89 c7             	mov    %rax,%rdi
  8037a6:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b6:	8b 50 04             	mov    0x4(%rax),%edx
  8037b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bd:	8b 00                	mov    (%rax),%eax
  8037bf:	29 c2                	sub    %eax,%edx
  8037c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037cf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037d6:	00 00 00 
	stat->st_dev = &devpipe;
  8037d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037dd:	48 b9 c0 50 80 00 00 	movabs $0x8050c0,%rcx
  8037e4:	00 00 00 
  8037e7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037f3:	c9                   	leaveq 
  8037f4:	c3                   	retq   

00000000008037f5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037f5:	55                   	push   %rbp
  8037f6:	48 89 e5             	mov    %rsp,%rbp
  8037f9:	48 83 ec 10          	sub    $0x10,%rsp
  8037fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803805:	48 89 c6             	mov    %rax,%rsi
  803808:	bf 00 00 00 00       	mov    $0x0,%edi
  80380d:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381d:	48 89 c7             	mov    %rax,%rdi
  803820:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  803827:	00 00 00 
  80382a:	ff d0                	callq  *%rax
  80382c:	48 89 c6             	mov    %rax,%rsi
  80382f:	bf 00 00 00 00       	mov    $0x0,%edi
  803834:	48 b8 33 20 80 00 00 	movabs $0x802033,%rax
  80383b:	00 00 00 
  80383e:	ff d0                	callq  *%rax
}
  803840:	c9                   	leaveq 
  803841:	c3                   	retq   

0000000000803842 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803842:	55                   	push   %rbp
  803843:	48 89 e5             	mov    %rsp,%rbp
  803846:	48 83 ec 30          	sub    $0x30,%rsp
  80384a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80384e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803852:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80385e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803863:	75 0e                	jne    803873 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803865:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80386c:	00 00 00 
  80386f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803873:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803877:	48 89 c7             	mov    %rax,%rdi
  80387a:	48 b8 b1 21 80 00 00 	movabs $0x8021b1,%rax
  803881:	00 00 00 
  803884:	ff d0                	callq  *%rax
  803886:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803889:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80388d:	79 27                	jns    8038b6 <ipc_recv+0x74>
		if (from_env_store != NULL)
  80388f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803894:	74 0a                	je     8038a0 <ipc_recv+0x5e>
			*from_env_store = 0;
  803896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8038a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038a5:	74 0a                	je     8038b1 <ipc_recv+0x6f>
			*perm_store = 0;
  8038a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ab:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8038b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038b4:	eb 53                	jmp    803909 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8038b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8038bb:	74 19                	je     8038d6 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8038bd:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8038c4:	00 00 00 
  8038c7:	48 8b 00             	mov    (%rax),%rax
  8038ca:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8038d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d4:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8038d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038db:	74 19                	je     8038f6 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8038dd:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8038e4:	00 00 00 
  8038e7:	48 8b 00             	mov    (%rax),%rax
  8038ea:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8038f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f4:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8038f6:	48 b8 28 64 80 00 00 	movabs $0x806428,%rax
  8038fd:	00 00 00 
  803900:	48 8b 00             	mov    (%rax),%rax
  803903:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803909:	c9                   	leaveq 
  80390a:	c3                   	retq   

000000000080390b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80390b:	55                   	push   %rbp
  80390c:	48 89 e5             	mov    %rsp,%rbp
  80390f:	48 83 ec 30          	sub    $0x30,%rsp
  803913:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803916:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803919:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80391d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803920:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803924:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803928:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80392d:	75 10                	jne    80393f <ipc_send+0x34>
		page = (void *)KERNBASE;
  80392f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803936:	00 00 00 
  803939:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80393d:	eb 0e                	jmp    80394d <ipc_send+0x42>
  80393f:	eb 0c                	jmp    80394d <ipc_send+0x42>
		sys_yield();
  803941:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  803948:	00 00 00 
  80394b:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80394d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803950:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803953:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803957:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80395a:	89 c7                	mov    %eax,%edi
  80395c:	48 b8 5c 21 80 00 00 	movabs $0x80215c,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
  803968:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80396b:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80396f:	74 d0                	je     803941 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803971:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803975:	74 2a                	je     8039a1 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803977:	48 ba fd 40 80 00 00 	movabs $0x8040fd,%rdx
  80397e:	00 00 00 
  803981:	be 49 00 00 00       	mov    $0x49,%esi
  803986:	48 bf 19 41 80 00 00 	movabs $0x804119,%rdi
  80398d:	00 00 00 
  803990:	b8 00 00 00 00       	mov    $0x0,%eax
  803995:	48 b9 1e 05 80 00 00 	movabs $0x80051e,%rcx
  80399c:	00 00 00 
  80399f:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8039a1:	c9                   	leaveq 
  8039a2:	c3                   	retq   

00000000008039a3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8039a3:	55                   	push   %rbp
  8039a4:	48 89 e5             	mov    %rsp,%rbp
  8039a7:	48 83 ec 14          	sub    $0x14,%rsp
  8039ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8039ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039b5:	eb 5e                	jmp    803a15 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8039b7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039be:	00 00 00 
  8039c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c4:	48 63 d0             	movslq %eax,%rdx
  8039c7:	48 89 d0             	mov    %rdx,%rax
  8039ca:	48 c1 e0 03          	shl    $0x3,%rax
  8039ce:	48 01 d0             	add    %rdx,%rax
  8039d1:	48 c1 e0 05          	shl    $0x5,%rax
  8039d5:	48 01 c8             	add    %rcx,%rax
  8039d8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8039de:	8b 00                	mov    (%rax),%eax
  8039e0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039e3:	75 2c                	jne    803a11 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8039e5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039ec:	00 00 00 
  8039ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f2:	48 63 d0             	movslq %eax,%rdx
  8039f5:	48 89 d0             	mov    %rdx,%rax
  8039f8:	48 c1 e0 03          	shl    $0x3,%rax
  8039fc:	48 01 d0             	add    %rdx,%rax
  8039ff:	48 c1 e0 05          	shl    $0x5,%rax
  803a03:	48 01 c8             	add    %rcx,%rax
  803a06:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803a0c:	8b 40 08             	mov    0x8(%rax),%eax
  803a0f:	eb 12                	jmp    803a23 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803a11:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a15:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803a1c:	7e 99                	jle    8039b7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a23:	c9                   	leaveq 
  803a24:	c3                   	retq   

0000000000803a25 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a25:	55                   	push   %rbp
  803a26:	48 89 e5             	mov    %rsp,%rbp
  803a29:	48 83 ec 18          	sub    $0x18,%rsp
  803a2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a35:	48 c1 e8 15          	shr    $0x15,%rax
  803a39:	48 89 c2             	mov    %rax,%rdx
  803a3c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a43:	01 00 00 
  803a46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a4a:	83 e0 01             	and    $0x1,%eax
  803a4d:	48 85 c0             	test   %rax,%rax
  803a50:	75 07                	jne    803a59 <pageref+0x34>
		return 0;
  803a52:	b8 00 00 00 00       	mov    $0x0,%eax
  803a57:	eb 53                	jmp    803aac <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a5d:	48 c1 e8 0c          	shr    $0xc,%rax
  803a61:	48 89 c2             	mov    %rax,%rdx
  803a64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a6b:	01 00 00 
  803a6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7a:	83 e0 01             	and    $0x1,%eax
  803a7d:	48 85 c0             	test   %rax,%rax
  803a80:	75 07                	jne    803a89 <pageref+0x64>
		return 0;
  803a82:	b8 00 00 00 00       	mov    $0x0,%eax
  803a87:	eb 23                	jmp    803aac <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8d:	48 c1 e8 0c          	shr    $0xc,%rax
  803a91:	48 89 c2             	mov    %rax,%rdx
  803a94:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a9b:	00 00 00 
  803a9e:	48 c1 e2 04          	shl    $0x4,%rdx
  803aa2:	48 01 d0             	add    %rdx,%rax
  803aa5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803aa9:	0f b7 c0             	movzwl %ax,%eax
}
  803aac:	c9                   	leaveq 
  803aad:	c3                   	retq   
