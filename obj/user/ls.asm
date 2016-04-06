
obj/user/ls.debug:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba a0 3f 80 00 00 	movabs $0x803fa0,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf ac 3f 80 00 00 	movabs $0x803fac,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 1e 2e 80 00 00 	movabs $0x802e1e,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba b6 3f 80 00 00 	movabs $0x803fb6,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf ac 3f 80 00 00 	movabs $0x803fac,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 1d 2a 80 00 00 	movabs $0x802a1d,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba c2 3f 80 00 00 	movabs $0x803fc2,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf ac 3f 80 00 00 	movabs $0x803fac,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 ce 05 80 00 00 	movabs $0x8005ce,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba e0 3f 80 00 00 	movabs $0x803fe0,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf ac 3f 80 00 00 	movabs $0x803fac,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if (flag['l'])
  8002a0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf ff 3f 80 00 00 	movabs $0x803fff,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 fe 33 80 00 00 	movabs $0x8033fe,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if (prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 0a 40 80 00 00 	movabs $0x80400a,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf 0b 40 80 00 00 	movabs $0x80400b,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 fe 33 80 00 00 	movabs $0x8033fe,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf 10 40 80 00 00 	movabs $0x804010,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba fe 33 80 00 00 	movabs $0x8033fe,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if (flag['F'] && isdir)
  800387:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba fe 33 80 00 00 	movabs $0x8033fe,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba fe 33 80 00 00 	movabs $0x8033fe,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba fe 33 80 00 00 	movabs $0x8033fe,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 ab 05 80 00 00 	movabs $0x8005ab,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 4b 21 80 00 00 	movabs $0x80214b,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be 0a 40 80 00 00 	movabs $0x80400a,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80052a:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	48 98                	cltq   
  800538:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053d:	48 89 c2             	mov    %rax,%rdx
  800540:	48 89 d0             	mov    %rdx,%rax
  800543:	48 c1 e0 03          	shl    $0x3,%rax
  800547:	48 01 d0             	add    %rdx,%rax
  80054a:	48 c1 e0 05          	shl    $0x5,%rax
  80054e:	48 89 c2             	mov    %rax,%rdx
  800551:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800558:	00 00 00 
  80055b:	48 01 c2             	add    %rax,%rdx
  80055e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800565:	00 00 00 
  800568:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056f:	7e 14                	jle    800585 <libmain+0x6a>
		binaryname = argv[0];
  800571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800575:	48 8b 10             	mov    (%rax),%rdx
  800578:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80057f:	00 00 00 
  800582:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800585:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80058c:	48 89 d6             	mov    %rdx,%rsi
  80058f:	89 c7                	mov    %eax,%edi
  800591:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800598:	00 00 00 
  80059b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80059d:	48 b8 ab 05 80 00 00 	movabs $0x8005ab,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
}
  8005a9:	c9                   	leaveq 
  8005aa:	c3                   	retq   

00000000008005ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ab:	55                   	push   %rbp
  8005ac:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005af:	48 b8 71 27 80 00 00 	movabs $0x802771,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c0:	48 b8 1e 1e 80 00 00 	movabs $0x801e1e,%rax
  8005c7:	00 00 00 
  8005ca:	ff d0                	callq  *%rax
}
  8005cc:	5d                   	pop    %rbp
  8005cd:	c3                   	retq   

00000000008005ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	53                   	push   %rbx
  8005d3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005da:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005e1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005ee:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005fc:	84 c0                	test   %al,%al
  8005fe:	74 23                	je     800623 <_panic+0x55>
  800600:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800607:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80060b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80060f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800613:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800617:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80061b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80061f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800623:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80062a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800631:	00 00 00 
  800634:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80063b:	00 00 00 
  80063e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800642:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800649:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800650:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800657:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80065e:	00 00 00 
  800661:	48 8b 18             	mov    (%rax),%rbx
  800664:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  80066b:	00 00 00 
  80066e:	ff d0                	callq  *%rax
  800670:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800676:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80067d:	41 89 c8             	mov    %ecx,%r8d
  800680:	48 89 d1             	mov    %rdx,%rcx
  800683:	48 89 da             	mov    %rbx,%rdx
  800686:	89 c6                	mov    %eax,%esi
  800688:	48 bf 40 40 80 00 00 	movabs $0x804040,%rdi
  80068f:	00 00 00 
  800692:	b8 00 00 00 00       	mov    $0x0,%eax
  800697:	49 b9 07 08 80 00 00 	movabs $0x800807,%r9
  80069e:	00 00 00 
  8006a1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006a4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006b2:	48 89 d6             	mov    %rdx,%rsi
  8006b5:	48 89 c7             	mov    %rax,%rdi
  8006b8:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  8006bf:	00 00 00 
  8006c2:	ff d0                	callq  *%rax
	cprintf("\n");
  8006c4:	48 bf 63 40 80 00 00 	movabs $0x804063,%rdi
  8006cb:	00 00 00 
  8006ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d3:	48 ba 07 08 80 00 00 	movabs $0x800807,%rdx
  8006da:	00 00 00 
  8006dd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006df:	cc                   	int3   
  8006e0:	eb fd                	jmp    8006df <_panic+0x111>

00000000008006e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006e2:	55                   	push   %rbp
  8006e3:	48 89 e5             	mov    %rsp,%rbp
  8006e6:	48 83 ec 10          	sub    $0x10,%rsp
  8006ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8006f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	8d 48 01             	lea    0x1(%rax),%ecx
  8006fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006fe:	89 0a                	mov    %ecx,(%rdx)
  800700:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800703:	89 d1                	mov    %edx,%ecx
  800705:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800709:	48 98                	cltq   
  80070b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80070f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071a:	75 2c                	jne    800748 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80071c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	48 98                	cltq   
  800724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800728:	48 83 c2 08          	add    $0x8,%rdx
  80072c:	48 89 c6             	mov    %rax,%rsi
  80072f:	48 89 d7             	mov    %rdx,%rdi
  800732:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax
		b->idx = 0;
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80074c:	8b 40 04             	mov    0x4(%rax),%eax
  80074f:	8d 50 01             	lea    0x1(%rax),%edx
  800752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800756:	89 50 04             	mov    %edx,0x4(%rax)
}
  800759:	c9                   	leaveq 
  80075a:	c3                   	retq   

000000000080075b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80075b:	55                   	push   %rbp
  80075c:	48 89 e5             	mov    %rsp,%rbp
  80075f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800766:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80076d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800774:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80077b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800782:	48 8b 0a             	mov    (%rdx),%rcx
  800785:	48 89 08             	mov    %rcx,(%rax)
  800788:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80078c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800790:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800794:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800798:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80079f:	00 00 00 
	b.cnt = 0;
  8007a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007ac:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007b3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007ba:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007c1:	48 89 c6             	mov    %rax,%rsi
  8007c4:	48 bf e2 06 80 00 00 	movabs $0x8006e2,%rdi
  8007cb:	00 00 00 
  8007ce:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  8007d5:	00 00 00 
  8007d8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007da:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007e0:	48 98                	cltq   
  8007e2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007e9:	48 83 c2 08          	add    $0x8,%rdx
  8007ed:	48 89 c6             	mov    %rax,%rsi
  8007f0:	48 89 d7             	mov    %rdx,%rdi
  8007f3:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  8007fa:	00 00 00 
  8007fd:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8007ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800805:	c9                   	leaveq 
  800806:	c3                   	retq   

0000000000800807 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800807:	55                   	push   %rbp
  800808:	48 89 e5             	mov    %rsp,%rbp
  80080b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800812:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800819:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800820:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800827:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80082e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800835:	84 c0                	test   %al,%al
  800837:	74 20                	je     800859 <cprintf+0x52>
  800839:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80083d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800841:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800845:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800849:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80084d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800851:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800855:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800859:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800860:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800867:	00 00 00 
  80086a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800871:	00 00 00 
  800874:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800878:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80087f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800886:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80088d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800894:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80089b:	48 8b 0a             	mov    (%rdx),%rcx
  80089e:	48 89 08             	mov    %rcx,(%rax)
  8008a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008b1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008b8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008bf:	48 89 d6             	mov    %rdx,%rsi
  8008c2:	48 89 c7             	mov    %rax,%rdi
  8008c5:	48 b8 5b 07 80 00 00 	movabs $0x80075b,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008d7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008dd:	c9                   	leaveq 
  8008de:	c3                   	retq   

00000000008008df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	53                   	push   %rbx
  8008e4:	48 83 ec 38          	sub    $0x38,%rsp
  8008e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008f4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008f7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008fb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008ff:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800902:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800906:	77 3b                	ja     800943 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800908:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80090b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80090f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	48 f7 f3             	div    %rbx
  80091e:	48 89 c2             	mov    %rax,%rdx
  800921:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800924:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800927:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	41 89 f9             	mov    %edi,%r9d
  800932:	48 89 c7             	mov    %rax,%rdi
  800935:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	eb 1e                	jmp    800961 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800943:	eb 12                	jmp    800957 <printnum+0x78>
			putch(padc, putdat);
  800945:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800949:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80094c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800950:	48 89 ce             	mov    %rcx,%rsi
  800953:	89 d7                	mov    %edx,%edi
  800955:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800957:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80095b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80095f:	7f e4                	jg     800945 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800961:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	48 f7 f1             	div    %rcx
  800970:	48 89 d0             	mov    %rdx,%rax
  800973:	48 ba 48 42 80 00 00 	movabs $0x804248,%rdx
  80097a:	00 00 00 
  80097d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800981:	0f be d0             	movsbl %al,%edx
  800984:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	48 89 ce             	mov    %rcx,%rsi
  80098f:	89 d7                	mov    %edx,%edi
  800991:	ff d0                	callq  *%rax
}
  800993:	48 83 c4 38          	add    $0x38,%rsp
  800997:	5b                   	pop    %rbx
  800998:	5d                   	pop    %rbp
  800999:	c3                   	retq   

000000000080099a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80099a:	55                   	push   %rbp
  80099b:	48 89 e5             	mov    %rsp,%rbp
  80099e:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8009a9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009ad:	7e 52                	jle    800a01 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	8b 00                	mov    (%rax),%eax
  8009b5:	83 f8 30             	cmp    $0x30,%eax
  8009b8:	73 24                	jae    8009de <getuint+0x44>
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	8b 00                	mov    (%rax),%eax
  8009c8:	89 c0                	mov    %eax,%eax
  8009ca:	48 01 d0             	add    %rdx,%rax
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	8b 12                	mov    (%rdx),%edx
  8009d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009da:	89 0a                	mov    %ecx,(%rdx)
  8009dc:	eb 17                	jmp    8009f5 <getuint+0x5b>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e6:	48 89 d0             	mov    %rdx,%rax
  8009e9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f5:	48 8b 00             	mov    (%rax),%rax
  8009f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009fc:	e9 a3 00 00 00       	jmpq   800aa4 <getuint+0x10a>
	else if (lflag)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a05:	74 4f                	je     800a56 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	83 f8 30             	cmp    $0x30,%eax
  800a10:	73 24                	jae    800a36 <getuint+0x9c>
  800a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a16:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	89 c0                	mov    %eax,%eax
  800a22:	48 01 d0             	add    %rdx,%rax
  800a25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a29:	8b 12                	mov    (%rdx),%edx
  800a2b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a32:	89 0a                	mov    %ecx,(%rdx)
  800a34:	eb 17                	jmp    800a4d <getuint+0xb3>
  800a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3e:	48 89 d0             	mov    %rdx,%rax
  800a41:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4d:	48 8b 00             	mov    (%rax),%rax
  800a50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a54:	eb 4e                	jmp    800aa4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5a:	8b 00                	mov    (%rax),%eax
  800a5c:	83 f8 30             	cmp    $0x30,%eax
  800a5f:	73 24                	jae    800a85 <getuint+0xeb>
  800a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a65:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6d:	8b 00                	mov    (%rax),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a78:	8b 12                	mov    (%rdx),%edx
  800a7a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	89 0a                	mov    %ecx,(%rdx)
  800a83:	eb 17                	jmp    800a9c <getuint+0x102>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8d:	48 89 d0             	mov    %rdx,%rax
  800a90:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a98:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a9c:	8b 00                	mov    (%rax),%eax
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa8:	c9                   	leaveq 
  800aa9:	c3                   	retq   

0000000000800aaa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aaa:	55                   	push   %rbp
  800aab:	48 89 e5             	mov    %rsp,%rbp
  800aae:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ab2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ab9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800abd:	7e 52                	jle    800b11 <getint+0x67>
		x=va_arg(*ap, long long);
  800abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac3:	8b 00                	mov    (%rax),%eax
  800ac5:	83 f8 30             	cmp    $0x30,%eax
  800ac8:	73 24                	jae    800aee <getint+0x44>
  800aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ace:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad6:	8b 00                	mov    (%rax),%eax
  800ad8:	89 c0                	mov    %eax,%eax
  800ada:	48 01 d0             	add    %rdx,%rax
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	8b 12                	mov    (%rdx),%edx
  800ae3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	89 0a                	mov    %ecx,(%rdx)
  800aec:	eb 17                	jmp    800b05 <getint+0x5b>
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af6:	48 89 d0             	mov    %rdx,%rax
  800af9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800afd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b01:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b05:	48 8b 00             	mov    (%rax),%rax
  800b08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b0c:	e9 a3 00 00 00       	jmpq   800bb4 <getint+0x10a>
	else if (lflag)
  800b11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b15:	74 4f                	je     800b66 <getint+0xbc>
		x=va_arg(*ap, long);
  800b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1b:	8b 00                	mov    (%rax),%eax
  800b1d:	83 f8 30             	cmp    $0x30,%eax
  800b20:	73 24                	jae    800b46 <getint+0x9c>
  800b22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b26:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b2e:	8b 00                	mov    (%rax),%eax
  800b30:	89 c0                	mov    %eax,%eax
  800b32:	48 01 d0             	add    %rdx,%rax
  800b35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b39:	8b 12                	mov    (%rdx),%edx
  800b3b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b42:	89 0a                	mov    %ecx,(%rdx)
  800b44:	eb 17                	jmp    800b5d <getint+0xb3>
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b4e:	48 89 d0             	mov    %rdx,%rax
  800b51:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b59:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b5d:	48 8b 00             	mov    (%rax),%rax
  800b60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b64:	eb 4e                	jmp    800bb4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6a:	8b 00                	mov    (%rax),%eax
  800b6c:	83 f8 30             	cmp    $0x30,%eax
  800b6f:	73 24                	jae    800b95 <getint+0xeb>
  800b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b75:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7d:	8b 00                	mov    (%rax),%eax
  800b7f:	89 c0                	mov    %eax,%eax
  800b81:	48 01 d0             	add    %rdx,%rax
  800b84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b88:	8b 12                	mov    (%rdx),%edx
  800b8a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b91:	89 0a                	mov    %ecx,(%rdx)
  800b93:	eb 17                	jmp    800bac <getint+0x102>
  800b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b99:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b9d:	48 89 d0             	mov    %rdx,%rax
  800ba0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ba4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bac:	8b 00                	mov    (%rax),%eax
  800bae:	48 98                	cltq   
  800bb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bb8:	c9                   	leaveq 
  800bb9:	c3                   	retq   

0000000000800bba <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bba:	55                   	push   %rbp
  800bbb:	48 89 e5             	mov    %rsp,%rbp
  800bbe:	41 54                	push   %r12
  800bc0:	53                   	push   %rbx
  800bc1:	48 83 ec 60          	sub    $0x60,%rsp
  800bc5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bc9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bcd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bd1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bdd:	48 8b 0a             	mov    (%rdx),%rcx
  800be0:	48 89 08             	mov    %rcx,(%rax)
  800be3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800beb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800bf3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bfb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bff:	0f b6 00             	movzbl (%rax),%eax
  800c02:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800c05:	eb 29                	jmp    800c30 <vprintfmt+0x76>
			if (ch == '\0')
  800c07:	85 db                	test   %ebx,%ebx
  800c09:	0f 84 ad 06 00 00    	je     8012bc <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800c0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c17:	48 89 d6             	mov    %rdx,%rsi
  800c1a:	89 df                	mov    %ebx,%edi
  800c1c:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800c1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c22:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c26:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c2a:	0f b6 00             	movzbl (%rax),%eax
  800c2d:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800c30:	83 fb 25             	cmp    $0x25,%ebx
  800c33:	74 05                	je     800c3a <vprintfmt+0x80>
  800c35:	83 fb 1b             	cmp    $0x1b,%ebx
  800c38:	75 cd                	jne    800c07 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800c3a:	83 fb 1b             	cmp    $0x1b,%ebx
  800c3d:	0f 85 ae 01 00 00    	jne    800df1 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800c43:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800c4a:	00 00 00 
  800c4d:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800c53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5b:	48 89 d6             	mov    %rdx,%rsi
  800c5e:	89 df                	mov    %ebx,%edi
  800c60:	ff d0                	callq  *%rax
			putch('[', putdat);
  800c62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6a:	48 89 d6             	mov    %rdx,%rsi
  800c6d:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800c72:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800c74:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800c7a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800c7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c83:	0f b6 00             	movzbl (%rax),%eax
  800c86:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800c89:	eb 32                	jmp    800cbd <vprintfmt+0x103>
					putch(ch, putdat);
  800c8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c93:	48 89 d6             	mov    %rdx,%rsi
  800c96:	89 df                	mov    %ebx,%edi
  800c98:	ff d0                	callq  *%rax
					esc_color *= 10;
  800c9a:	44 89 e0             	mov    %r12d,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	44 01 e0             	add    %r12d,%eax
  800ca3:	01 c0                	add    %eax,%eax
  800ca5:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800ca8:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800cab:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800cae:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800cb3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb7:	0f b6 00             	movzbl (%rax),%eax
  800cba:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800cbd:	83 fb 3b             	cmp    $0x3b,%ebx
  800cc0:	74 05                	je     800cc7 <vprintfmt+0x10d>
  800cc2:	83 fb 6d             	cmp    $0x6d,%ebx
  800cc5:	75 c4                	jne    800c8b <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800cc7:	45 85 e4             	test   %r12d,%r12d
  800cca:	75 15                	jne    800ce1 <vprintfmt+0x127>
					color_flag = 0x07;
  800ccc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cd3:	00 00 00 
  800cd6:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800cdc:	e9 dc 00 00 00       	jmpq   800dbd <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800ce1:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800ce5:	7e 69                	jle    800d50 <vprintfmt+0x196>
  800ce7:	41 83 fc 25          	cmp    $0x25,%r12d
  800ceb:	7f 63                	jg     800d50 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800ced:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cf4:	00 00 00 
  800cf7:	8b 00                	mov    (%rax),%eax
  800cf9:	25 f8 00 00 00       	and    $0xf8,%eax
  800cfe:	89 c2                	mov    %eax,%edx
  800d00:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d07:	00 00 00 
  800d0a:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800d0c:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800d10:	44 89 e0             	mov    %r12d,%eax
  800d13:	83 e0 04             	and    $0x4,%eax
  800d16:	c1 f8 02             	sar    $0x2,%eax
  800d19:	89 c2                	mov    %eax,%edx
  800d1b:	44 89 e0             	mov    %r12d,%eax
  800d1e:	83 e0 02             	and    $0x2,%eax
  800d21:	09 c2                	or     %eax,%edx
  800d23:	44 89 e0             	mov    %r12d,%eax
  800d26:	83 e0 01             	and    $0x1,%eax
  800d29:	c1 e0 02             	shl    $0x2,%eax
  800d2c:	09 c2                	or     %eax,%edx
  800d2e:	41 89 d4             	mov    %edx,%r12d
  800d31:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d38:	00 00 00 
  800d3b:	8b 00                	mov    (%rax),%eax
  800d3d:	44 89 e2             	mov    %r12d,%edx
  800d40:	09 c2                	or     %eax,%edx
  800d42:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d49:	00 00 00 
  800d4c:	89 10                	mov    %edx,(%rax)
  800d4e:	eb 6d                	jmp    800dbd <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800d50:	41 83 fc 27          	cmp    $0x27,%r12d
  800d54:	7e 67                	jle    800dbd <vprintfmt+0x203>
  800d56:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800d5a:	7f 61                	jg     800dbd <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800d5c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d63:	00 00 00 
  800d66:	8b 00                	mov    (%rax),%eax
  800d68:	25 8f 00 00 00       	and    $0x8f,%eax
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d76:	00 00 00 
  800d79:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800d7b:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800d7f:	44 89 e0             	mov    %r12d,%eax
  800d82:	83 e0 04             	and    $0x4,%eax
  800d85:	c1 f8 02             	sar    $0x2,%eax
  800d88:	89 c2                	mov    %eax,%edx
  800d8a:	44 89 e0             	mov    %r12d,%eax
  800d8d:	83 e0 02             	and    $0x2,%eax
  800d90:	09 c2                	or     %eax,%edx
  800d92:	44 89 e0             	mov    %r12d,%eax
  800d95:	83 e0 01             	and    $0x1,%eax
  800d98:	c1 e0 06             	shl    $0x6,%eax
  800d9b:	09 c2                	or     %eax,%edx
  800d9d:	41 89 d4             	mov    %edx,%r12d
  800da0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800da7:	00 00 00 
  800daa:	8b 00                	mov    (%rax),%eax
  800dac:	44 89 e2             	mov    %r12d,%edx
  800daf:	09 c2                	or     %eax,%edx
  800db1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800db8:	00 00 00 
  800dbb:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800dbd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc5:	48 89 d6             	mov    %rdx,%rsi
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800dcc:	83 fb 6d             	cmp    $0x6d,%ebx
  800dcf:	75 1b                	jne    800dec <vprintfmt+0x232>
					fmt ++;
  800dd1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800dd6:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800dd7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800dde:	00 00 00 
  800de1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800de7:	e9 cb 04 00 00       	jmpq   8012b7 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800dec:	e9 83 fe ff ff       	jmpq   800c74 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800df1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800df5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800dfc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800e03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800e0a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e11:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e15:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e19:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800e1d:	0f b6 00             	movzbl (%rax),%eax
  800e20:	0f b6 d8             	movzbl %al,%ebx
  800e23:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800e26:	83 f8 55             	cmp    $0x55,%eax
  800e29:	0f 87 5a 04 00 00    	ja     801289 <vprintfmt+0x6cf>
  800e2f:	89 c0                	mov    %eax,%eax
  800e31:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800e38:	00 
  800e39:	48 b8 70 42 80 00 00 	movabs $0x804270,%rax
  800e40:	00 00 00 
  800e43:	48 01 d0             	add    %rdx,%rax
  800e46:	48 8b 00             	mov    (%rax),%rax
  800e49:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e4b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e4f:	eb c0                	jmp    800e11 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e51:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e55:	eb ba                	jmp    800e11 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e57:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e5e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	c1 e0 02             	shl    $0x2,%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	01 c0                	add    %eax,%eax
  800e6a:	01 d8                	add    %ebx,%eax
  800e6c:	83 e8 30             	sub    $0x30,%eax
  800e6f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e72:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e76:	0f b6 00             	movzbl (%rax),%eax
  800e79:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e7c:	83 fb 2f             	cmp    $0x2f,%ebx
  800e7f:	7e 0c                	jle    800e8d <vprintfmt+0x2d3>
  800e81:	83 fb 39             	cmp    $0x39,%ebx
  800e84:	7f 07                	jg     800e8d <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e86:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e8b:	eb d1                	jmp    800e5e <vprintfmt+0x2a4>
			goto process_precision;
  800e8d:	eb 58                	jmp    800ee7 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800e8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e92:	83 f8 30             	cmp    $0x30,%eax
  800e95:	73 17                	jae    800eae <vprintfmt+0x2f4>
  800e97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e9e:	89 c0                	mov    %eax,%eax
  800ea0:	48 01 d0             	add    %rdx,%rax
  800ea3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ea6:	83 c2 08             	add    $0x8,%edx
  800ea9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800eac:	eb 0f                	jmp    800ebd <vprintfmt+0x303>
  800eae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eb2:	48 89 d0             	mov    %rdx,%rax
  800eb5:	48 83 c2 08          	add    $0x8,%rdx
  800eb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ebd:	8b 00                	mov    (%rax),%eax
  800ebf:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ec2:	eb 23                	jmp    800ee7 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800ec4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ec8:	79 0c                	jns    800ed6 <vprintfmt+0x31c>
				width = 0;
  800eca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ed1:	e9 3b ff ff ff       	jmpq   800e11 <vprintfmt+0x257>
  800ed6:	e9 36 ff ff ff       	jmpq   800e11 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800edb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ee2:	e9 2a ff ff ff       	jmpq   800e11 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800ee7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eeb:	79 12                	jns    800eff <vprintfmt+0x345>
				width = precision, precision = -1;
  800eed:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ef0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ef3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800efa:	e9 12 ff ff ff       	jmpq   800e11 <vprintfmt+0x257>
  800eff:	e9 0d ff ff ff       	jmpq   800e11 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f04:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800f08:	e9 04 ff ff ff       	jmpq   800e11 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800f0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f10:	83 f8 30             	cmp    $0x30,%eax
  800f13:	73 17                	jae    800f2c <vprintfmt+0x372>
  800f15:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1c:	89 c0                	mov    %eax,%eax
  800f1e:	48 01 d0             	add    %rdx,%rax
  800f21:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f24:	83 c2 08             	add    $0x8,%edx
  800f27:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f2a:	eb 0f                	jmp    800f3b <vprintfmt+0x381>
  800f2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f30:	48 89 d0             	mov    %rdx,%rax
  800f33:	48 83 c2 08          	add    $0x8,%rdx
  800f37:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f3b:	8b 10                	mov    (%rax),%edx
  800f3d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f45:	48 89 ce             	mov    %rcx,%rsi
  800f48:	89 d7                	mov    %edx,%edi
  800f4a:	ff d0                	callq  *%rax
			break;
  800f4c:	e9 66 03 00 00       	jmpq   8012b7 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800f51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f54:	83 f8 30             	cmp    $0x30,%eax
  800f57:	73 17                	jae    800f70 <vprintfmt+0x3b6>
  800f59:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f5d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f60:	89 c0                	mov    %eax,%eax
  800f62:	48 01 d0             	add    %rdx,%rax
  800f65:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f68:	83 c2 08             	add    $0x8,%edx
  800f6b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f6e:	eb 0f                	jmp    800f7f <vprintfmt+0x3c5>
  800f70:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f74:	48 89 d0             	mov    %rdx,%rax
  800f77:	48 83 c2 08          	add    $0x8,%rdx
  800f7b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f7f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800f81:	85 db                	test   %ebx,%ebx
  800f83:	79 02                	jns    800f87 <vprintfmt+0x3cd>
				err = -err;
  800f85:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800f87:	83 fb 10             	cmp    $0x10,%ebx
  800f8a:	7f 16                	jg     800fa2 <vprintfmt+0x3e8>
  800f8c:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  800f93:	00 00 00 
  800f96:	48 63 d3             	movslq %ebx,%rdx
  800f99:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800f9d:	4d 85 e4             	test   %r12,%r12
  800fa0:	75 2e                	jne    800fd0 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800fa2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800faa:	89 d9                	mov    %ebx,%ecx
  800fac:	48 ba 59 42 80 00 00 	movabs $0x804259,%rdx
  800fb3:	00 00 00 
  800fb6:	48 89 c7             	mov    %rax,%rdi
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	49 b8 c5 12 80 00 00 	movabs $0x8012c5,%r8
  800fc5:	00 00 00 
  800fc8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fcb:	e9 e7 02 00 00       	jmpq   8012b7 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fd0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd8:	4c 89 e1             	mov    %r12,%rcx
  800fdb:	48 ba 62 42 80 00 00 	movabs $0x804262,%rdx
  800fe2:	00 00 00 
  800fe5:	48 89 c7             	mov    %rax,%rdi
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	49 b8 c5 12 80 00 00 	movabs $0x8012c5,%r8
  800ff4:	00 00 00 
  800ff7:	41 ff d0             	callq  *%r8
			break;
  800ffa:	e9 b8 02 00 00       	jmpq   8012b7 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800fff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801002:	83 f8 30             	cmp    $0x30,%eax
  801005:	73 17                	jae    80101e <vprintfmt+0x464>
  801007:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80100b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100e:	89 c0                	mov    %eax,%eax
  801010:	48 01 d0             	add    %rdx,%rax
  801013:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801016:	83 c2 08             	add    $0x8,%edx
  801019:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80101c:	eb 0f                	jmp    80102d <vprintfmt+0x473>
  80101e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801022:	48 89 d0             	mov    %rdx,%rax
  801025:	48 83 c2 08          	add    $0x8,%rdx
  801029:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80102d:	4c 8b 20             	mov    (%rax),%r12
  801030:	4d 85 e4             	test   %r12,%r12
  801033:	75 0a                	jne    80103f <vprintfmt+0x485>
				p = "(null)";
  801035:	49 bc 65 42 80 00 00 	movabs $0x804265,%r12
  80103c:	00 00 00 
			if (width > 0 && padc != '-')
  80103f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801043:	7e 3f                	jle    801084 <vprintfmt+0x4ca>
  801045:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801049:	74 39                	je     801084 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  80104b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80104e:	48 98                	cltq   
  801050:	48 89 c6             	mov    %rax,%rsi
  801053:	4c 89 e7             	mov    %r12,%rdi
  801056:	48 b8 71 15 80 00 00 	movabs $0x801571,%rax
  80105d:	00 00 00 
  801060:	ff d0                	callq  *%rax
  801062:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801065:	eb 17                	jmp    80107e <vprintfmt+0x4c4>
					putch(padc, putdat);
  801067:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80106b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80106f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801073:	48 89 ce             	mov    %rcx,%rsi
  801076:	89 d7                	mov    %edx,%edi
  801078:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80107a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80107e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801082:	7f e3                	jg     801067 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801084:	eb 37                	jmp    8010bd <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  801086:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80108a:	74 1e                	je     8010aa <vprintfmt+0x4f0>
  80108c:	83 fb 1f             	cmp    $0x1f,%ebx
  80108f:	7e 05                	jle    801096 <vprintfmt+0x4dc>
  801091:	83 fb 7e             	cmp    $0x7e,%ebx
  801094:	7e 14                	jle    8010aa <vprintfmt+0x4f0>
					putch('?', putdat);
  801096:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80109e:	48 89 d6             	mov    %rdx,%rsi
  8010a1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8010a6:	ff d0                	callq  *%rax
  8010a8:	eb 0f                	jmp    8010b9 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  8010aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b2:	48 89 d6             	mov    %rdx,%rsi
  8010b5:	89 df                	mov    %ebx,%edi
  8010b7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010b9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010bd:	4c 89 e0             	mov    %r12,%rax
  8010c0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8010c4:	0f b6 00             	movzbl (%rax),%eax
  8010c7:	0f be d8             	movsbl %al,%ebx
  8010ca:	85 db                	test   %ebx,%ebx
  8010cc:	74 10                	je     8010de <vprintfmt+0x524>
  8010ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010d2:	78 b2                	js     801086 <vprintfmt+0x4cc>
  8010d4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8010d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010dc:	79 a8                	jns    801086 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010de:	eb 16                	jmp    8010f6 <vprintfmt+0x53c>
				putch(' ', putdat);
  8010e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e8:	48 89 d6             	mov    %rdx,%rsi
  8010eb:	bf 20 00 00 00       	mov    $0x20,%edi
  8010f0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010f2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010fa:	7f e4                	jg     8010e0 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  8010fc:	e9 b6 01 00 00       	jmpq   8012b7 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801101:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801105:	be 03 00 00 00       	mov    $0x3,%esi
  80110a:	48 89 c7             	mov    %rax,%rdi
  80110d:	48 b8 aa 0a 80 00 00 	movabs $0x800aaa,%rax
  801114:	00 00 00 
  801117:	ff d0                	callq  *%rax
  801119:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 85 c0             	test   %rax,%rax
  801124:	79 1d                	jns    801143 <vprintfmt+0x589>
				putch('-', putdat);
  801126:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80112a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80112e:	48 89 d6             	mov    %rdx,%rsi
  801131:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801136:	ff d0                	callq  *%rax
				num = -(long long) num;
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 f7 d8             	neg    %rax
  80113f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801143:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80114a:	e9 fb 00 00 00       	jmpq   80124a <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80114f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801153:	be 03 00 00 00       	mov    $0x3,%esi
  801158:	48 89 c7             	mov    %rax,%rdi
  80115b:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  801162:	00 00 00 
  801165:	ff d0                	callq  *%rax
  801167:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80116b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801172:	e9 d3 00 00 00       	jmpq   80124a <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  801177:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80117b:	be 03 00 00 00       	mov    $0x3,%esi
  801180:	48 89 c7             	mov    %rax,%rdi
  801183:	48 b8 aa 0a 80 00 00 	movabs $0x800aaa,%rax
  80118a:	00 00 00 
  80118d:	ff d0                	callq  *%rax
  80118f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801197:	48 85 c0             	test   %rax,%rax
  80119a:	79 1d                	jns    8011b9 <vprintfmt+0x5ff>
				putch('-', putdat);
  80119c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011a4:	48 89 d6             	mov    %rdx,%rsi
  8011a7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8011ac:	ff d0                	callq  *%rax
				num = -(long long) num;
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	48 f7 d8             	neg    %rax
  8011b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8011b9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8011c0:	e9 85 00 00 00       	jmpq   80124a <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011cd:	48 89 d6             	mov    %rdx,%rsi
  8011d0:	bf 30 00 00 00       	mov    $0x30,%edi
  8011d5:	ff d0                	callq  *%rax
			putch('x', putdat);
  8011d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011df:	48 89 d6             	mov    %rdx,%rsi
  8011e2:	bf 78 00 00 00       	mov    $0x78,%edi
  8011e7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8011e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ec:	83 f8 30             	cmp    $0x30,%eax
  8011ef:	73 17                	jae    801208 <vprintfmt+0x64e>
  8011f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011f8:	89 c0                	mov    %eax,%eax
  8011fa:	48 01 d0             	add    %rdx,%rax
  8011fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801200:	83 c2 08             	add    $0x8,%edx
  801203:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801206:	eb 0f                	jmp    801217 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801208:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80120c:	48 89 d0             	mov    %rdx,%rax
  80120f:	48 83 c2 08          	add    $0x8,%rdx
  801213:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801217:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80121a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80121e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801225:	eb 23                	jmp    80124a <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801227:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80122b:	be 03 00 00 00       	mov    $0x3,%esi
  801230:	48 89 c7             	mov    %rax,%rdi
  801233:	48 b8 9a 09 80 00 00 	movabs $0x80099a,%rax
  80123a:	00 00 00 
  80123d:	ff d0                	callq  *%rax
  80123f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801243:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80124a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80124f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801252:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801255:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801259:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80125d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801261:	45 89 c1             	mov    %r8d,%r9d
  801264:	41 89 f8             	mov    %edi,%r8d
  801267:	48 89 c7             	mov    %rax,%rdi
  80126a:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  801271:	00 00 00 
  801274:	ff d0                	callq  *%rax
			break;
  801276:	eb 3f                	jmp    8012b7 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801278:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80127c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801280:	48 89 d6             	mov    %rdx,%rsi
  801283:	89 df                	mov    %ebx,%edi
  801285:	ff d0                	callq  *%rax
			break;
  801287:	eb 2e                	jmp    8012b7 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801289:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80128d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801291:	48 89 d6             	mov    %rdx,%rsi
  801294:	bf 25 00 00 00       	mov    $0x25,%edi
  801299:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80129b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8012a0:	eb 05                	jmp    8012a7 <vprintfmt+0x6ed>
  8012a2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8012a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8012ab:	48 83 e8 01          	sub    $0x1,%rax
  8012af:	0f b6 00             	movzbl (%rax),%eax
  8012b2:	3c 25                	cmp    $0x25,%al
  8012b4:	75 ec                	jne    8012a2 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8012b6:	90                   	nop
		}
	}
  8012b7:	e9 37 f9 ff ff       	jmpq   800bf3 <vprintfmt+0x39>
    va_end(aq);
}
  8012bc:	48 83 c4 60          	add    $0x60,%rsp
  8012c0:	5b                   	pop    %rbx
  8012c1:	41 5c                	pop    %r12
  8012c3:	5d                   	pop    %rbp
  8012c4:	c3                   	retq   

00000000008012c5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8012d0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8012d7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8012de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012f3:	84 c0                	test   %al,%al
  8012f5:	74 20                	je     801317 <printfmt+0x52>
  8012f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801303:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801307:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80130b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80130f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801313:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801317:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80131e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801325:	00 00 00 
  801328:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80132f:	00 00 00 
  801332:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801336:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80133d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801344:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80134b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801352:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801359:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801360:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801367:	48 89 c7             	mov    %rax,%rdi
  80136a:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
	va_end(ap);
}
  801376:	c9                   	leaveq 
  801377:	c3                   	retq   

0000000000801378 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	48 83 ec 10          	sub    $0x10,%rsp
  801380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801383:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138b:	8b 40 10             	mov    0x10(%rax),%eax
  80138e:	8d 50 01             	lea    0x1(%rax),%edx
  801391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801395:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139c:	48 8b 10             	mov    (%rax),%rdx
  80139f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8013a7:	48 39 c2             	cmp    %rax,%rdx
  8013aa:	73 17                	jae    8013c3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8013ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b0:	48 8b 00             	mov    (%rax),%rax
  8013b3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8013b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013bb:	48 89 0a             	mov    %rcx,(%rdx)
  8013be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8013c1:	88 10                	mov    %dl,(%rax)
}
  8013c3:	c9                   	leaveq 
  8013c4:	c3                   	retq   

00000000008013c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	48 83 ec 50          	sub    $0x50,%rsp
  8013cd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8013d1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8013d4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8013d8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8013dc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8013e0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8013e4:	48 8b 0a             	mov    (%rdx),%rcx
  8013e7:	48 89 08             	mov    %rcx,(%rax)
  8013ea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013ee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013fe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801402:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801405:	48 98                	cltq   
  801407:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80140b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80140f:	48 01 d0             	add    %rdx,%rax
  801412:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801416:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80141d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801422:	74 06                	je     80142a <vsnprintf+0x65>
  801424:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801428:	7f 07                	jg     801431 <vsnprintf+0x6c>
		return -E_INVAL;
  80142a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142f:	eb 2f                	jmp    801460 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801431:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801435:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801439:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80143d:	48 89 c6             	mov    %rax,%rsi
  801440:	48 bf 78 13 80 00 00 	movabs $0x801378,%rdi
  801447:	00 00 00 
  80144a:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  801451:	00 00 00 
  801454:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801456:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80145a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80145d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80146d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801474:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80147a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801481:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801488:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80148f:	84 c0                	test   %al,%al
  801491:	74 20                	je     8014b3 <snprintf+0x51>
  801493:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801497:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80149b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80149f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014a3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014a7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014ab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014af:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014b3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8014ba:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8014c1:	00 00 00 
  8014c4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014cb:	00 00 00 
  8014ce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014d9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014e0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8014e7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014ee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014f5:	48 8b 0a             	mov    (%rdx),%rcx
  8014f8:	48 89 08             	mov    %rcx,(%rax)
  8014fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801503:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801507:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80150b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801512:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801519:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80151f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801526:	48 89 c7             	mov    %rax,%rdi
  801529:	48 b8 c5 13 80 00 00 	movabs $0x8013c5,%rax
  801530:	00 00 00 
  801533:	ff d0                	callq  *%rax
  801535:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80153b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 18          	sub    $0x18,%rsp
  80154b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80154f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801556:	eb 09                	jmp    801561 <strlen+0x1e>
		n++;
  801558:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80155c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 ec                	jne    801558 <strlen+0x15>
		n++;
	return n;
  80156c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80156f:	c9                   	leaveq 
  801570:	c3                   	retq   

0000000000801571 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801571:	55                   	push   %rbp
  801572:	48 89 e5             	mov    %rsp,%rbp
  801575:	48 83 ec 20          	sub    $0x20,%rsp
  801579:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80157d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801588:	eb 0e                	jmp    801598 <strnlen+0x27>
		n++;
  80158a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80158e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801593:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801598:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80159d:	74 0b                	je     8015aa <strnlen+0x39>
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	84 c0                	test   %al,%al
  8015a8:	75 e0                	jne    80158a <strnlen+0x19>
		n++;
	return n;
  8015aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 20          	sub    $0x20,%rsp
  8015b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8015c7:	90                   	nop
  8015c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015d8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8015dc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8015e0:	0f b6 12             	movzbl (%rdx),%edx
  8015e3:	88 10                	mov    %dl,(%rax)
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	84 c0                	test   %al,%al
  8015ea:	75 dc                	jne    8015c8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8015ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015f0:	c9                   	leaveq 
  8015f1:	c3                   	retq   

00000000008015f2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	48 83 ec 20          	sub    $0x20,%rsp
  8015fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801606:	48 89 c7             	mov    %rax,%rdi
  801609:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  801610:	00 00 00 
  801613:	ff d0                	callq  *%rax
  801615:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80161b:	48 63 d0             	movslq %eax,%rdx
  80161e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801622:	48 01 c2             	add    %rax,%rdx
  801625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801629:	48 89 c6             	mov    %rax,%rsi
  80162c:	48 89 d7             	mov    %rdx,%rdi
  80162f:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  801636:	00 00 00 
  801639:	ff d0                	callq  *%rax
	return dst;
  80163b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	48 83 ec 28          	sub    $0x28,%rsp
  801649:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80164d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801651:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801659:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80165d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801664:	00 
  801665:	eb 2a                	jmp    801691 <strncpy+0x50>
		*dst++ = *src;
  801667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80166f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801673:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801677:	0f b6 12             	movzbl (%rdx),%edx
  80167a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80167c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	84 c0                	test   %al,%al
  801685:	74 05                	je     80168c <strncpy+0x4b>
			src++;
  801687:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801695:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801699:	72 cc                	jb     801667 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80169b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80169f:	c9                   	leaveq 
  8016a0:	c3                   	retq   

00000000008016a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8016a1:	55                   	push   %rbp
  8016a2:	48 89 e5             	mov    %rsp,%rbp
  8016a5:	48 83 ec 28          	sub    $0x28,%rsp
  8016a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8016b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8016bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016c2:	74 3d                	je     801701 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8016c4:	eb 1d                	jmp    8016e3 <strlcpy+0x42>
			*dst++ = *src++;
  8016c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016da:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016de:	0f b6 12             	movzbl (%rdx),%edx
  8016e1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016e3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016ed:	74 0b                	je     8016fa <strlcpy+0x59>
  8016ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	84 c0                	test   %al,%al
  8016f8:	75 cc                	jne    8016c6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8016fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fe:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801709:	48 29 c2             	sub    %rax,%rdx
  80170c:	48 89 d0             	mov    %rdx,%rax
}
  80170f:	c9                   	leaveq 
  801710:	c3                   	retq   

0000000000801711 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801711:	55                   	push   %rbp
  801712:	48 89 e5             	mov    %rsp,%rbp
  801715:	48 83 ec 10          	sub    $0x10,%rsp
  801719:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80171d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801721:	eb 0a                	jmp    80172d <strcmp+0x1c>
		p++, q++;
  801723:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801728:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80172d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801731:	0f b6 00             	movzbl (%rax),%eax
  801734:	84 c0                	test   %al,%al
  801736:	74 12                	je     80174a <strcmp+0x39>
  801738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173c:	0f b6 10             	movzbl (%rax),%edx
  80173f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	38 c2                	cmp    %al,%dl
  801748:	74 d9                	je     801723 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80174a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	0f b6 d0             	movzbl %al,%edx
  801754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801758:	0f b6 00             	movzbl (%rax),%eax
  80175b:	0f b6 c0             	movzbl %al,%eax
  80175e:	29 c2                	sub    %eax,%edx
  801760:	89 d0                	mov    %edx,%eax
}
  801762:	c9                   	leaveq 
  801763:	c3                   	retq   

0000000000801764 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	48 83 ec 18          	sub    $0x18,%rsp
  80176c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801770:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801774:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801778:	eb 0f                	jmp    801789 <strncmp+0x25>
		n--, p++, q++;
  80177a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80177f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801784:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801789:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80178e:	74 1d                	je     8017ad <strncmp+0x49>
  801790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	84 c0                	test   %al,%al
  801799:	74 12                	je     8017ad <strncmp+0x49>
  80179b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179f:	0f b6 10             	movzbl (%rax),%edx
  8017a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	38 c2                	cmp    %al,%dl
  8017ab:	74 cd                	je     80177a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8017ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017b2:	75 07                	jne    8017bb <strncmp+0x57>
		return 0;
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	eb 18                	jmp    8017d3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	0f b6 d0             	movzbl %al,%edx
  8017c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	0f b6 c0             	movzbl %al,%eax
  8017cf:	29 c2                	sub    %eax,%edx
  8017d1:	89 d0                	mov    %edx,%eax
}
  8017d3:	c9                   	leaveq 
  8017d4:	c3                   	retq   

00000000008017d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017d5:	55                   	push   %rbp
  8017d6:	48 89 e5             	mov    %rsp,%rbp
  8017d9:	48 83 ec 0c          	sub    $0xc,%rsp
  8017dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e1:	89 f0                	mov    %esi,%eax
  8017e3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8017e6:	eb 17                	jmp    8017ff <strchr+0x2a>
		if (*s == c)
  8017e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ec:	0f b6 00             	movzbl (%rax),%eax
  8017ef:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8017f2:	75 06                	jne    8017fa <strchr+0x25>
			return (char *) s;
  8017f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f8:	eb 15                	jmp    80180f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8017fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	84 c0                	test   %al,%al
  801808:	75 de                	jne    8017e8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180f:	c9                   	leaveq 
  801810:	c3                   	retq   

0000000000801811 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801811:	55                   	push   %rbp
  801812:	48 89 e5             	mov    %rsp,%rbp
  801815:	48 83 ec 0c          	sub    $0xc,%rsp
  801819:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80181d:	89 f0                	mov    %esi,%eax
  80181f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801822:	eb 13                	jmp    801837 <strfind+0x26>
		if (*s == c)
  801824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80182e:	75 02                	jne    801832 <strfind+0x21>
			break;
  801830:	eb 10                	jmp    801842 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801832:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183b:	0f b6 00             	movzbl (%rax),%eax
  80183e:	84 c0                	test   %al,%al
  801840:	75 e2                	jne    801824 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801842:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801846:	c9                   	leaveq 
  801847:	c3                   	retq   

0000000000801848 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801848:	55                   	push   %rbp
  801849:	48 89 e5             	mov    %rsp,%rbp
  80184c:	48 83 ec 18          	sub    $0x18,%rsp
  801850:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801854:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801857:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80185b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801860:	75 06                	jne    801868 <memset+0x20>
		return v;
  801862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801866:	eb 69                	jmp    8018d1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801868:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186c:	83 e0 03             	and    $0x3,%eax
  80186f:	48 85 c0             	test   %rax,%rax
  801872:	75 48                	jne    8018bc <memset+0x74>
  801874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801878:	83 e0 03             	and    $0x3,%eax
  80187b:	48 85 c0             	test   %rax,%rax
  80187e:	75 3c                	jne    8018bc <memset+0x74>
		c &= 0xFF;
  801880:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801887:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80188a:	c1 e0 18             	shl    $0x18,%eax
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801892:	c1 e0 10             	shl    $0x10,%eax
  801895:	09 c2                	or     %eax,%edx
  801897:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80189a:	c1 e0 08             	shl    $0x8,%eax
  80189d:	09 d0                	or     %edx,%eax
  80189f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8018a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a6:	48 c1 e8 02          	shr    $0x2,%rax
  8018aa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8018ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018b4:	48 89 d7             	mov    %rdx,%rdi
  8018b7:	fc                   	cld    
  8018b8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8018ba:	eb 11                	jmp    8018cd <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8018bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018c7:	48 89 d7             	mov    %rdx,%rdi
  8018ca:	fc                   	cld    
  8018cb:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8018cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   

00000000008018d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8018d3:	55                   	push   %rbp
  8018d4:	48 89 e5             	mov    %rsp,%rbp
  8018d7:	48 83 ec 28          	sub    $0x28,%rsp
  8018db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8018e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8018ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8018f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8018ff:	0f 83 88 00 00 00    	jae    80198d <memmove+0xba>
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80190d:	48 01 d0             	add    %rdx,%rax
  801910:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801914:	76 77                	jbe    80198d <memmove+0xba>
		s += n;
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801926:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192a:	83 e0 03             	and    $0x3,%eax
  80192d:	48 85 c0             	test   %rax,%rax
  801930:	75 3b                	jne    80196d <memmove+0x9a>
  801932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801936:	83 e0 03             	and    $0x3,%eax
  801939:	48 85 c0             	test   %rax,%rax
  80193c:	75 2f                	jne    80196d <memmove+0x9a>
  80193e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801942:	83 e0 03             	and    $0x3,%eax
  801945:	48 85 c0             	test   %rax,%rax
  801948:	75 23                	jne    80196d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80194a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194e:	48 83 e8 04          	sub    $0x4,%rax
  801952:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801956:	48 83 ea 04          	sub    $0x4,%rdx
  80195a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80195e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801962:	48 89 c7             	mov    %rax,%rdi
  801965:	48 89 d6             	mov    %rdx,%rsi
  801968:	fd                   	std    
  801969:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80196b:	eb 1d                	jmp    80198a <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80196d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801971:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801979:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80197d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801981:	48 89 d7             	mov    %rdx,%rdi
  801984:	48 89 c1             	mov    %rax,%rcx
  801987:	fd                   	std    
  801988:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80198a:	fc                   	cld    
  80198b:	eb 57                	jmp    8019e4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80198d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801991:	83 e0 03             	and    $0x3,%eax
  801994:	48 85 c0             	test   %rax,%rax
  801997:	75 36                	jne    8019cf <memmove+0xfc>
  801999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80199d:	83 e0 03             	and    $0x3,%eax
  8019a0:	48 85 c0             	test   %rax,%rax
  8019a3:	75 2a                	jne    8019cf <memmove+0xfc>
  8019a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a9:	83 e0 03             	and    $0x3,%eax
  8019ac:	48 85 c0             	test   %rax,%rax
  8019af:	75 1e                	jne    8019cf <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b5:	48 c1 e8 02          	shr    $0x2,%rax
  8019b9:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8019bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019c4:	48 89 c7             	mov    %rax,%rdi
  8019c7:	48 89 d6             	mov    %rdx,%rsi
  8019ca:	fc                   	cld    
  8019cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8019cd:	eb 15                	jmp    8019e4 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8019db:	48 89 c7             	mov    %rax,%rdi
  8019de:	48 89 d6             	mov    %rdx,%rsi
  8019e1:	fc                   	cld    
  8019e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8019e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 18          	sub    $0x18,%rsp
  8019f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8019fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a02:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801a06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0a:	48 89 ce             	mov    %rcx,%rsi
  801a0d:	48 89 c7             	mov    %rax,%rdi
  801a10:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  801a17:	00 00 00 
  801a1a:	ff d0                	callq  *%rax
}
  801a1c:	c9                   	leaveq 
  801a1d:	c3                   	retq   

0000000000801a1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a1e:	55                   	push   %rbp
  801a1f:	48 89 e5             	mov    %rsp,%rbp
  801a22:	48 83 ec 28          	sub    $0x28,%rsp
  801a26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801a3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801a42:	eb 36                	jmp    801a7a <memcmp+0x5c>
		if (*s1 != *s2)
  801a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a48:	0f b6 10             	movzbl (%rax),%edx
  801a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a4f:	0f b6 00             	movzbl (%rax),%eax
  801a52:	38 c2                	cmp    %al,%dl
  801a54:	74 1a                	je     801a70 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5a:	0f b6 00             	movzbl (%rax),%eax
  801a5d:	0f b6 d0             	movzbl %al,%edx
  801a60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	0f b6 c0             	movzbl %al,%eax
  801a6a:	29 c2                	sub    %eax,%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	eb 20                	jmp    801a90 <memcmp+0x72>
		s1++, s2++;
  801a70:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a75:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a86:	48 85 c0             	test   %rax,%rax
  801a89:	75 b9                	jne    801a44 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 28          	sub    $0x28,%rsp
  801a9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a9e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801aa1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801aad:	48 01 d0             	add    %rdx,%rax
  801ab0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801ab4:	eb 15                	jmp    801acb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aba:	0f b6 10             	movzbl (%rax),%edx
  801abd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ac0:	38 c2                	cmp    %al,%dl
  801ac2:	75 02                	jne    801ac6 <memfind+0x34>
			break;
  801ac4:	eb 0f                	jmp    801ad5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ac6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801acf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801ad3:	72 e1                	jb     801ab6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 34          	sub    $0x34,%rsp
  801ae3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ae7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801aeb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801aee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801af5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801afc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801afd:	eb 05                	jmp    801b04 <strtol+0x29>
		s++;
  801aff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b08:	0f b6 00             	movzbl (%rax),%eax
  801b0b:	3c 20                	cmp    $0x20,%al
  801b0d:	74 f0                	je     801aff <strtol+0x24>
  801b0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b13:	0f b6 00             	movzbl (%rax),%eax
  801b16:	3c 09                	cmp    $0x9,%al
  801b18:	74 e5                	je     801aff <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1e:	0f b6 00             	movzbl (%rax),%eax
  801b21:	3c 2b                	cmp    $0x2b,%al
  801b23:	75 07                	jne    801b2c <strtol+0x51>
		s++;
  801b25:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b2a:	eb 17                	jmp    801b43 <strtol+0x68>
	else if (*s == '-')
  801b2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b30:	0f b6 00             	movzbl (%rax),%eax
  801b33:	3c 2d                	cmp    $0x2d,%al
  801b35:	75 0c                	jne    801b43 <strtol+0x68>
		s++, neg = 1;
  801b37:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b3c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b43:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b47:	74 06                	je     801b4f <strtol+0x74>
  801b49:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801b4d:	75 28                	jne    801b77 <strtol+0x9c>
  801b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b53:	0f b6 00             	movzbl (%rax),%eax
  801b56:	3c 30                	cmp    $0x30,%al
  801b58:	75 1d                	jne    801b77 <strtol+0x9c>
  801b5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5e:	48 83 c0 01          	add    $0x1,%rax
  801b62:	0f b6 00             	movzbl (%rax),%eax
  801b65:	3c 78                	cmp    $0x78,%al
  801b67:	75 0e                	jne    801b77 <strtol+0x9c>
		s += 2, base = 16;
  801b69:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b6e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b75:	eb 2c                	jmp    801ba3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b77:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b7b:	75 19                	jne    801b96 <strtol+0xbb>
  801b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b81:	0f b6 00             	movzbl (%rax),%eax
  801b84:	3c 30                	cmp    $0x30,%al
  801b86:	75 0e                	jne    801b96 <strtol+0xbb>
		s++, base = 8;
  801b88:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b8d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801b94:	eb 0d                	jmp    801ba3 <strtol+0xc8>
	else if (base == 0)
  801b96:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b9a:	75 07                	jne    801ba3 <strtol+0xc8>
		base = 10;
  801b9c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba7:	0f b6 00             	movzbl (%rax),%eax
  801baa:	3c 2f                	cmp    $0x2f,%al
  801bac:	7e 1d                	jle    801bcb <strtol+0xf0>
  801bae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb2:	0f b6 00             	movzbl (%rax),%eax
  801bb5:	3c 39                	cmp    $0x39,%al
  801bb7:	7f 12                	jg     801bcb <strtol+0xf0>
			dig = *s - '0';
  801bb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bbd:	0f b6 00             	movzbl (%rax),%eax
  801bc0:	0f be c0             	movsbl %al,%eax
  801bc3:	83 e8 30             	sub    $0x30,%eax
  801bc6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bc9:	eb 4e                	jmp    801c19 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801bcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcf:	0f b6 00             	movzbl (%rax),%eax
  801bd2:	3c 60                	cmp    $0x60,%al
  801bd4:	7e 1d                	jle    801bf3 <strtol+0x118>
  801bd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bda:	0f b6 00             	movzbl (%rax),%eax
  801bdd:	3c 7a                	cmp    $0x7a,%al
  801bdf:	7f 12                	jg     801bf3 <strtol+0x118>
			dig = *s - 'a' + 10;
  801be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be5:	0f b6 00             	movzbl (%rax),%eax
  801be8:	0f be c0             	movsbl %al,%eax
  801beb:	83 e8 57             	sub    $0x57,%eax
  801bee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bf1:	eb 26                	jmp    801c19 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801bf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf7:	0f b6 00             	movzbl (%rax),%eax
  801bfa:	3c 40                	cmp    $0x40,%al
  801bfc:	7e 48                	jle    801c46 <strtol+0x16b>
  801bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c02:	0f b6 00             	movzbl (%rax),%eax
  801c05:	3c 5a                	cmp    $0x5a,%al
  801c07:	7f 3d                	jg     801c46 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0d:	0f b6 00             	movzbl (%rax),%eax
  801c10:	0f be c0             	movsbl %al,%eax
  801c13:	83 e8 37             	sub    $0x37,%eax
  801c16:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801c19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c1c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801c1f:	7c 02                	jl     801c23 <strtol+0x148>
			break;
  801c21:	eb 23                	jmp    801c46 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801c23:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c28:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801c2b:	48 98                	cltq   
  801c2d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801c32:	48 89 c2             	mov    %rax,%rdx
  801c35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c38:	48 98                	cltq   
  801c3a:	48 01 d0             	add    %rdx,%rax
  801c3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801c41:	e9 5d ff ff ff       	jmpq   801ba3 <strtol+0xc8>

	if (endptr)
  801c46:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801c4b:	74 0b                	je     801c58 <strtol+0x17d>
		*endptr = (char *) s;
  801c4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c51:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c55:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c5c:	74 09                	je     801c67 <strtol+0x18c>
  801c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c62:	48 f7 d8             	neg    %rax
  801c65:	eb 04                	jmp    801c6b <strtol+0x190>
  801c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <strstr>:

char * strstr(const char *in, const char *str)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
  801c71:	48 83 ec 30          	sub    $0x30,%rsp
  801c75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801c7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c81:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c85:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c89:	0f b6 00             	movzbl (%rax),%eax
  801c8c:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801c8f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801c93:	75 06                	jne    801c9b <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801c95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c99:	eb 6b                	jmp    801d06 <strstr+0x99>

    len = strlen(str);
  801c9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c9f:	48 89 c7             	mov    %rax,%rdi
  801ca2:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	callq  *%rax
  801cae:	48 98                	cltq   
  801cb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801cb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801cbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801cc0:	0f b6 00             	movzbl (%rax),%eax
  801cc3:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801cc6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801cca:	75 07                	jne    801cd3 <strstr+0x66>
                return (char *) 0;
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	eb 33                	jmp    801d06 <strstr+0x99>
        } while (sc != c);
  801cd3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801cd7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801cda:	75 d8                	jne    801cb4 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ce4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce8:	48 89 ce             	mov    %rcx,%rsi
  801ceb:	48 89 c7             	mov    %rax,%rdi
  801cee:	48 b8 64 17 80 00 00 	movabs $0x801764,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	callq  *%rax
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	75 b6                	jne    801cb4 <strstr+0x47>

    return (char *) (in - 1);
  801cfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d02:	48 83 e8 01          	sub    $0x1,%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	53                   	push   %rbx
  801d0d:	48 83 ec 48          	sub    $0x48,%rsp
  801d11:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d14:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801d17:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d1b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801d1f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801d23:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d27:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801d2e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801d32:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801d36:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801d3a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801d3e:	4c 89 c3             	mov    %r8,%rbx
  801d41:	cd 30                	int    $0x30
  801d43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801d47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d4b:	74 3e                	je     801d8b <syscall+0x83>
  801d4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d52:	7e 37                	jle    801d8b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801d54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d5b:	49 89 d0             	mov    %rdx,%r8
  801d5e:	89 c1                	mov    %eax,%ecx
  801d60:	48 ba 20 45 80 00 00 	movabs $0x804520,%rdx
  801d67:	00 00 00 
  801d6a:	be 23 00 00 00       	mov    $0x23,%esi
  801d6f:	48 bf 3d 45 80 00 00 	movabs $0x80453d,%rdi
  801d76:	00 00 00 
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	49 b9 ce 05 80 00 00 	movabs $0x8005ce,%r9
  801d85:	00 00 00 
  801d88:	41 ff d1             	callq  *%r9

	return ret;
  801d8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d8f:	48 83 c4 48          	add    $0x48,%rsp
  801d93:	5b                   	pop    %rbx
  801d94:	5d                   	pop    %rbp
  801d95:	c3                   	retq   

0000000000801d96 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801d96:	55                   	push   %rbp
  801d97:	48 89 e5             	mov    %rsp,%rbp
  801d9a:	48 83 ec 20          	sub    $0x20,%rsp
  801d9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801da6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801daa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db5:	00 
  801db6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc2:	48 89 d1             	mov    %rdx,%rcx
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
  801dcd:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd2:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801de8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801def:	00 
  801df0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e01:	ba 00 00 00 00       	mov    $0x0,%edx
  801e06:	be 00 00 00 00       	mov    $0x0,%esi
  801e0b:	bf 01 00 00 00       	mov    $0x1,%edi
  801e10:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
}
  801e1c:	c9                   	leaveq 
  801e1d:	c3                   	retq   

0000000000801e1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801e1e:	55                   	push   %rbp
  801e1f:	48 89 e5             	mov    %rsp,%rbp
  801e22:	48 83 ec 10          	sub    $0x10,%rsp
  801e26:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2c:	48 98                	cltq   
  801e2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e35:	00 
  801e36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e42:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e47:	48 89 c2             	mov    %rax,%rdx
  801e4a:	be 01 00 00 00       	mov    $0x1,%esi
  801e4f:	bf 03 00 00 00       	mov    $0x3,%edi
  801e54:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801e5b:	00 00 00 
  801e5e:	ff d0                	callq  *%rax
}
  801e60:	c9                   	leaveq 
  801e61:	c3                   	retq   

0000000000801e62 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e71:	00 
  801e72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e83:	ba 00 00 00 00       	mov    $0x0,%edx
  801e88:	be 00 00 00 00       	mov    $0x0,%esi
  801e8d:	bf 02 00 00 00       	mov    $0x2,%edi
  801e92:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	callq  *%rax
}
  801e9e:	c9                   	leaveq 
  801e9f:	c3                   	retq   

0000000000801ea0 <sys_yield>:

void
sys_yield(void)
{
  801ea0:	55                   	push   %rbp
  801ea1:	48 89 e5             	mov    %rsp,%rbp
  801ea4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ea8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eaf:	00 
  801eb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec6:	be 00 00 00 00       	mov    $0x0,%esi
  801ecb:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ed0:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 20          	sub    $0x20,%rsp
  801ee6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eed:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ef0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef3:	48 63 c8             	movslq %eax,%rcx
  801ef6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efd:	48 98                	cltq   
  801eff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f06:	00 
  801f07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0d:	49 89 c8             	mov    %rcx,%r8
  801f10:	48 89 d1             	mov    %rdx,%rcx
  801f13:	48 89 c2             	mov    %rax,%rdx
  801f16:	be 01 00 00 00       	mov    $0x1,%esi
  801f1b:	bf 04 00 00 00       	mov    $0x4,%edi
  801f20:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801f27:	00 00 00 
  801f2a:	ff d0                	callq  *%rax
}
  801f2c:	c9                   	leaveq 
  801f2d:	c3                   	retq   

0000000000801f2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801f2e:	55                   	push   %rbp
  801f2f:	48 89 e5             	mov    %rsp,%rbp
  801f32:	48 83 ec 30          	sub    $0x30,%rsp
  801f36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f40:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f44:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801f48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f4b:	48 63 c8             	movslq %eax,%rcx
  801f4e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f55:	48 63 f0             	movslq %eax,%rsi
  801f58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f5f:	48 98                	cltq   
  801f61:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f65:	49 89 f9             	mov    %rdi,%r9
  801f68:	49 89 f0             	mov    %rsi,%r8
  801f6b:	48 89 d1             	mov    %rdx,%rcx
  801f6e:	48 89 c2             	mov    %rax,%rdx
  801f71:	be 01 00 00 00       	mov    $0x1,%esi
  801f76:	bf 05 00 00 00       	mov    $0x5,%edi
  801f7b:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
}
  801f87:	c9                   	leaveq 
  801f88:	c3                   	retq   

0000000000801f89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801f89:	55                   	push   %rbp
  801f8a:	48 89 e5             	mov    %rsp,%rbp
  801f8d:	48 83 ec 20          	sub    $0x20,%rsp
  801f91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801f98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9f:	48 98                	cltq   
  801fa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fa8:	00 
  801fa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801faf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fb5:	48 89 d1             	mov    %rdx,%rcx
  801fb8:	48 89 c2             	mov    %rax,%rdx
  801fbb:	be 01 00 00 00       	mov    $0x1,%esi
  801fc0:	bf 06 00 00 00       	mov    $0x6,%edi
  801fc5:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	callq  *%rax
}
  801fd1:	c9                   	leaveq 
  801fd2:	c3                   	retq   

0000000000801fd3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801fd3:	55                   	push   %rbp
  801fd4:	48 89 e5             	mov    %rsp,%rbp
  801fd7:	48 83 ec 10          	sub    $0x10,%rsp
  801fdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fde:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801fe1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fe4:	48 63 d0             	movslq %eax,%rdx
  801fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fea:	48 98                	cltq   
  801fec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff3:	00 
  801ff4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ffa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802000:	48 89 d1             	mov    %rdx,%rcx
  802003:	48 89 c2             	mov    %rax,%rdx
  802006:	be 01 00 00 00       	mov    $0x1,%esi
  80200b:	bf 08 00 00 00       	mov    $0x8,%edi
  802010:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802017:	00 00 00 
  80201a:	ff d0                	callq  *%rax
}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	48 83 ec 20          	sub    $0x20,%rsp
  802026:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802029:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80202d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802034:	48 98                	cltq   
  802036:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80203d:	00 
  80203e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802044:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80204a:	48 89 d1             	mov    %rdx,%rcx
  80204d:	48 89 c2             	mov    %rax,%rdx
  802050:	be 01 00 00 00       	mov    $0x1,%esi
  802055:	bf 09 00 00 00       	mov    $0x9,%edi
  80205a:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
}
  802066:	c9                   	leaveq 
  802067:	c3                   	retq   

0000000000802068 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802068:	55                   	push   %rbp
  802069:	48 89 e5             	mov    %rsp,%rbp
  80206c:	48 83 ec 20          	sub    $0x20,%rsp
  802070:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802073:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802077:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207e:	48 98                	cltq   
  802080:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802087:	00 
  802088:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80208e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802094:	48 89 d1             	mov    %rdx,%rcx
  802097:	48 89 c2             	mov    %rax,%rdx
  80209a:	be 01 00 00 00       	mov    $0x1,%esi
  80209f:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020a4:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
}
  8020b0:	c9                   	leaveq 
  8020b1:	c3                   	retq   

00000000008020b2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8020b2:	55                   	push   %rbp
  8020b3:	48 89 e5             	mov    %rsp,%rbp
  8020b6:	48 83 ec 20          	sub    $0x20,%rsp
  8020ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8020c5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8020c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020cb:	48 63 f0             	movslq %eax,%rsi
  8020ce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d5:	48 98                	cltq   
  8020d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020e2:	00 
  8020e3:	49 89 f1             	mov    %rsi,%r9
  8020e6:	49 89 c8             	mov    %rcx,%r8
  8020e9:	48 89 d1             	mov    %rdx,%rcx
  8020ec:	48 89 c2             	mov    %rax,%rdx
  8020ef:	be 00 00 00 00       	mov    $0x0,%esi
  8020f4:	bf 0c 00 00 00       	mov    $0xc,%edi
  8020f9:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
}
  802105:	c9                   	leaveq 
  802106:	c3                   	retq   

0000000000802107 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802107:	55                   	push   %rbp
  802108:	48 89 e5             	mov    %rsp,%rbp
  80210b:	48 83 ec 10          	sub    $0x10,%rsp
  80210f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802117:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80211e:	00 
  80211f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802125:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	be 01 00 00 00       	mov    $0x1,%esi
  802138:	bf 0d 00 00 00       	mov    $0xd,%edi
  80213d:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
}
  802149:	c9                   	leaveq 
  80214a:	c3                   	retq   

000000000080214b <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80214b:	55                   	push   %rbp
  80214c:	48 89 e5             	mov    %rsp,%rbp
  80214f:	48 83 ec 18          	sub    $0x18,%rsp
  802153:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80215b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  80215f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802163:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802167:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80216a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802172:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80217a:	8b 00                	mov    (%rax),%eax
  80217c:	83 f8 01             	cmp    $0x1,%eax
  80217f:	7e 13                	jle    802194 <argstart+0x49>
  802181:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  802186:	74 0c                	je     802194 <argstart+0x49>
  802188:	48 b8 4b 45 80 00 00 	movabs $0x80454b,%rax
  80218f:	00 00 00 
  802192:	eb 05                	jmp    802199 <argstart+0x4e>
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80219d:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8021ac:	00 
}
  8021ad:	c9                   	leaveq 
  8021ae:	c3                   	retq   

00000000008021af <argnext>:

int
argnext(struct Argstate *args)
{
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	48 83 ec 20          	sub    $0x20,%rsp
  8021b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8021bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bf:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8021c6:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8021c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021cf:	48 85 c0             	test   %rax,%rax
  8021d2:	75 0a                	jne    8021de <argnext+0x2f>
		return -1;
  8021d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8021d9:	e9 25 01 00 00       	jmpq   802303 <argnext+0x154>

	if (!*args->curarg) {
  8021de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e6:	0f b6 00             	movzbl (%rax),%eax
  8021e9:	84 c0                	test   %al,%al
  8021eb:	0f 85 d7 00 00 00    	jne    8022c8 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8021f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f5:	48 8b 00             	mov    (%rax),%rax
  8021f8:	8b 00                	mov    (%rax),%eax
  8021fa:	83 f8 01             	cmp    $0x1,%eax
  8021fd:	0f 84 ef 00 00 00    	je     8022f2 <argnext+0x143>
		    || args->argv[1][0] != '-'
  802203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802207:	48 8b 40 08          	mov    0x8(%rax),%rax
  80220b:	48 83 c0 08          	add    $0x8,%rax
  80220f:	48 8b 00             	mov    (%rax),%rax
  802212:	0f b6 00             	movzbl (%rax),%eax
  802215:	3c 2d                	cmp    $0x2d,%al
  802217:	0f 85 d5 00 00 00    	jne    8022f2 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  80221d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802221:	48 8b 40 08          	mov    0x8(%rax),%rax
  802225:	48 83 c0 08          	add    $0x8,%rax
  802229:	48 8b 00             	mov    (%rax),%rax
  80222c:	48 83 c0 01          	add    $0x1,%rax
  802230:	0f b6 00             	movzbl (%rax),%eax
  802233:	84 c0                	test   %al,%al
  802235:	0f 84 b7 00 00 00    	je     8022f2 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802243:	48 83 c0 08          	add    $0x8,%rax
  802247:	48 8b 00             	mov    (%rax),%rax
  80224a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80224e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802252:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225a:	48 8b 00             	mov    (%rax),%rax
  80225d:	8b 00                	mov    (%rax),%eax
  80225f:	83 e8 01             	sub    $0x1,%eax
  802262:	48 98                	cltq   
  802264:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80226b:	00 
  80226c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802270:	48 8b 40 08          	mov    0x8(%rax),%rax
  802274:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802280:	48 83 c0 08          	add    $0x8,%rax
  802284:	48 89 ce             	mov    %rcx,%rsi
  802287:	48 89 c7             	mov    %rax,%rdi
  80228a:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  802291:	00 00 00 
  802294:	ff d0                	callq  *%rax
		(*args->argc)--;
  802296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229a:	48 8b 00             	mov    (%rax),%rax
  80229d:	8b 10                	mov    (%rax),%edx
  80229f:	83 ea 01             	sub    $0x1,%edx
  8022a2:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022ac:	0f b6 00             	movzbl (%rax),%eax
  8022af:	3c 2d                	cmp    $0x2d,%al
  8022b1:	75 15                	jne    8022c8 <argnext+0x119>
  8022b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022bb:	48 83 c0 01          	add    $0x1,%rax
  8022bf:	0f b6 00             	movzbl (%rax),%eax
  8022c2:	84 c0                	test   %al,%al
  8022c4:	75 02                	jne    8022c8 <argnext+0x119>
			goto endofargs;
  8022c6:	eb 2a                	jmp    8022f2 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8022c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d0:	0f b6 00             	movzbl (%rax),%eax
  8022d3:	0f b6 c0             	movzbl %al,%eax
  8022d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8022d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dd:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8022ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f0:	eb 11                	jmp    802303 <argnext+0x154>

    endofargs:
	args->curarg = 0;
  8022f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f6:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8022fd:	00 
	return -1;
  8022fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802303:	c9                   	leaveq 
  802304:	c3                   	retq   

0000000000802305 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802305:	55                   	push   %rbp
  802306:	48 89 e5             	mov    %rsp,%rbp
  802309:	48 83 ec 10          	sub    $0x10,%rsp
  80230d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802315:	48 8b 40 18          	mov    0x18(%rax),%rax
  802319:	48 85 c0             	test   %rax,%rax
  80231c:	74 0a                	je     802328 <argvalue+0x23>
  80231e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802322:	48 8b 40 18          	mov    0x18(%rax),%rax
  802326:	eb 13                	jmp    80233b <argvalue+0x36>
  802328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232c:	48 89 c7             	mov    %rax,%rdi
  80232f:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  802336:	00 00 00 
  802339:	ff d0                	callq  *%rax
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	53                   	push   %rbx
  802342:	48 83 ec 18          	sub    $0x18,%rsp
  802346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80234a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802352:	48 85 c0             	test   %rax,%rax
  802355:	75 0a                	jne    802361 <argnextvalue+0x24>
		return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
  80235c:	e9 c8 00 00 00       	jmpq   802429 <argnextvalue+0xec>
	if (*args->curarg) {
  802361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802365:	48 8b 40 10          	mov    0x10(%rax),%rax
  802369:	0f b6 00             	movzbl (%rax),%eax
  80236c:	84 c0                	test   %al,%al
  80236e:	74 27                	je     802397 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802374:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802378:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237c:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802384:	48 bb 4b 45 80 00 00 	movabs $0x80454b,%rbx
  80238b:	00 00 00 
  80238e:	48 89 58 10          	mov    %rbx,0x10(%rax)
  802392:	e9 8a 00 00 00       	jmpq   802421 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  802397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239b:	48 8b 00             	mov    (%rax),%rax
  80239e:	8b 00                	mov    (%rax),%eax
  8023a0:	83 f8 01             	cmp    $0x1,%eax
  8023a3:	7e 64                	jle    802409 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8023a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8023b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b5:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8023b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bd:	48 8b 00             	mov    (%rax),%rax
  8023c0:	8b 00                	mov    (%rax),%eax
  8023c2:	83 e8 01             	sub    $0x1,%eax
  8023c5:	48 98                	cltq   
  8023c7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023ce:	00 
  8023cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023d7:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8023db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023df:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023e3:	48 83 c0 08          	add    $0x8,%rax
  8023e7:	48 89 ce             	mov    %rcx,%rsi
  8023ea:	48 89 c7             	mov    %rax,%rdi
  8023ed:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
		(*args->argc)--;
  8023f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fd:	48 8b 00             	mov    (%rax),%rax
  802400:	8b 10                	mov    (%rax),%edx
  802402:	83 ea 01             	sub    $0x1,%edx
  802405:	89 10                	mov    %edx,(%rax)
  802407:	eb 18                	jmp    802421 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  802409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240d:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802414:	00 
		args->curarg = 0;
  802415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802419:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802420:	00 
	}
	return (char*) args->argvalue;
  802421:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802425:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802429:	48 83 c4 18          	add    $0x18,%rsp
  80242d:	5b                   	pop    %rbx
  80242e:	5d                   	pop    %rbp
  80242f:	c3                   	retq   

0000000000802430 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	48 83 ec 08          	sub    $0x8,%rsp
  802438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80243c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802440:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802447:	ff ff ff 
  80244a:	48 01 d0             	add    %rdx,%rax
  80244d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802451:	c9                   	leaveq 
  802452:	c3                   	retq   

0000000000802453 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802453:	55                   	push   %rbp
  802454:	48 89 e5             	mov    %rsp,%rbp
  802457:	48 83 ec 08          	sub    $0x8,%rsp
  80245b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80245f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802463:	48 89 c7             	mov    %rax,%rdi
  802466:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
  802472:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802478:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80247c:	c9                   	leaveq 
  80247d:	c3                   	retq   

000000000080247e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80247e:	55                   	push   %rbp
  80247f:	48 89 e5             	mov    %rsp,%rbp
  802482:	48 83 ec 18          	sub    $0x18,%rsp
  802486:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80248a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802491:	eb 6b                	jmp    8024fe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802496:	48 98                	cltq   
  802498:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80249e:	48 c1 e0 0c          	shl    $0xc,%rax
  8024a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024aa:	48 c1 e8 15          	shr    $0x15,%rax
  8024ae:	48 89 c2             	mov    %rax,%rdx
  8024b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024b8:	01 00 00 
  8024bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bf:	83 e0 01             	and    $0x1,%eax
  8024c2:	48 85 c0             	test   %rax,%rax
  8024c5:	74 21                	je     8024e8 <fd_alloc+0x6a>
  8024c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8024cf:	48 89 c2             	mov    %rax,%rdx
  8024d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024d9:	01 00 00 
  8024dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e0:	83 e0 01             	and    $0x1,%eax
  8024e3:	48 85 c0             	test   %rax,%rax
  8024e6:	75 12                	jne    8024fa <fd_alloc+0x7c>
			*fd_store = fd;
  8024e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f8:	eb 1a                	jmp    802514 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802502:	7e 8f                	jle    802493 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802508:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80250f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802514:	c9                   	leaveq 
  802515:	c3                   	retq   

0000000000802516 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802516:	55                   	push   %rbp
  802517:	48 89 e5             	mov    %rsp,%rbp
  80251a:	48 83 ec 20          	sub    $0x20,%rsp
  80251e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802521:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802525:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802529:	78 06                	js     802531 <fd_lookup+0x1b>
  80252b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80252f:	7e 07                	jle    802538 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802536:	eb 6c                	jmp    8025a4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802538:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80253b:	48 98                	cltq   
  80253d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802543:	48 c1 e0 0c          	shl    $0xc,%rax
  802547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254f:	48 c1 e8 15          	shr    $0x15,%rax
  802553:	48 89 c2             	mov    %rax,%rdx
  802556:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80255d:	01 00 00 
  802560:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802564:	83 e0 01             	and    $0x1,%eax
  802567:	48 85 c0             	test   %rax,%rax
  80256a:	74 21                	je     80258d <fd_lookup+0x77>
  80256c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802570:	48 c1 e8 0c          	shr    $0xc,%rax
  802574:	48 89 c2             	mov    %rax,%rdx
  802577:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80257e:	01 00 00 
  802581:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802585:	83 e0 01             	and    $0x1,%eax
  802588:	48 85 c0             	test   %rax,%rax
  80258b:	75 07                	jne    802594 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80258d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802592:	eb 10                	jmp    8025a4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802594:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802598:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80259c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a4:	c9                   	leaveq 
  8025a5:	c3                   	retq   

00000000008025a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025a6:	55                   	push   %rbp
  8025a7:	48 89 e5             	mov    %rsp,%rbp
  8025aa:	48 83 ec 30          	sub    $0x30,%rsp
  8025ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025b2:	89 f0                	mov    %esi,%eax
  8025b4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bb:	48 89 c7             	mov    %rax,%rdi
  8025be:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	callq  *%rax
  8025ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ce:	48 89 d6             	mov    %rdx,%rsi
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  8025da:	00 00 00 
  8025dd:	ff d0                	callq  *%rax
  8025df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e6:	78 0a                	js     8025f2 <fd_close+0x4c>
	    || fd != fd2)
  8025e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025f0:	74 12                	je     802604 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025f2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025f6:	74 05                	je     8025fd <fd_close+0x57>
  8025f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fb:	eb 05                	jmp    802602 <fd_close+0x5c>
  8025fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802602:	eb 69                	jmp    80266d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802608:	8b 00                	mov    (%rax),%eax
  80260a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80260e:	48 89 d6             	mov    %rdx,%rsi
  802611:	89 c7                	mov    %eax,%edi
  802613:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  80261a:	00 00 00 
  80261d:	ff d0                	callq  *%rax
  80261f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802622:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802626:	78 2a                	js     802652 <fd_close+0xac>
		if (dev->dev_close)
  802628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802630:	48 85 c0             	test   %rax,%rax
  802633:	74 16                	je     80264b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802639:	48 8b 40 20          	mov    0x20(%rax),%rax
  80263d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802641:	48 89 d7             	mov    %rdx,%rdi
  802644:	ff d0                	callq  *%rax
  802646:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802649:	eb 07                	jmp    802652 <fd_close+0xac>
		else
			r = 0;
  80264b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802656:	48 89 c6             	mov    %rax,%rsi
  802659:	bf 00 00 00 00       	mov    $0x0,%edi
  80265e:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
	return r;
  80266a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80266d:	c9                   	leaveq 
  80266e:	c3                   	retq   

000000000080266f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 20          	sub    $0x20,%rsp
  802677:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80267a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80267e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802685:	eb 41                	jmp    8026c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802687:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80268e:	00 00 00 
  802691:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802694:	48 63 d2             	movslq %edx,%rdx
  802697:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269b:	8b 00                	mov    (%rax),%eax
  80269d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026a0:	75 22                	jne    8026c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8026a2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026a9:	00 00 00 
  8026ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026af:	48 63 d2             	movslq %edx,%rdx
  8026b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	eb 60                	jmp    802724 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026c8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026cf:	00 00 00 
  8026d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d5:	48 63 d2             	movslq %edx,%rdx
  8026d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026dc:	48 85 c0             	test   %rax,%rax
  8026df:	75 a6                	jne    802687 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026e1:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8026e8:	00 00 00 
  8026eb:	48 8b 00             	mov    (%rax),%rax
  8026ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026f7:	89 c6                	mov    %eax,%esi
  8026f9:	48 bf 50 45 80 00 00 	movabs $0x804550,%rdi
  802700:	00 00 00 
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  80270f:	00 00 00 
  802712:	ff d1                	callq  *%rcx
	*dev = 0;
  802714:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802718:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80271f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802724:	c9                   	leaveq 
  802725:	c3                   	retq   

0000000000802726 <close>:

int
close(int fdnum)
{
  802726:	55                   	push   %rbp
  802727:	48 89 e5             	mov    %rsp,%rbp
  80272a:	48 83 ec 20          	sub    $0x20,%rsp
  80272e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802731:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802738:	48 89 d6             	mov    %rdx,%rsi
  80273b:	89 c7                	mov    %eax,%edi
  80273d:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802750:	79 05                	jns    802757 <close+0x31>
		return r;
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	eb 18                	jmp    80276f <close+0x49>
	else
		return fd_close(fd, 1);
  802757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275b:	be 01 00 00 00       	mov    $0x1,%esi
  802760:	48 89 c7             	mov    %rax,%rdi
  802763:	48 b8 a6 25 80 00 00 	movabs $0x8025a6,%rax
  80276a:	00 00 00 
  80276d:	ff d0                	callq  *%rax
}
  80276f:	c9                   	leaveq 
  802770:	c3                   	retq   

0000000000802771 <close_all>:

void
close_all(void)
{
  802771:	55                   	push   %rbp
  802772:	48 89 e5             	mov    %rsp,%rbp
  802775:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802780:	eb 15                	jmp    802797 <close_all+0x26>
		close(i);
  802782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802785:	89 c7                	mov    %eax,%edi
  802787:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802793:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802797:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80279b:	7e e5                	jle    802782 <close_all+0x11>
		close(i);
}
  80279d:	c9                   	leaveq 
  80279e:	c3                   	retq   

000000000080279f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80279f:	55                   	push   %rbp
  8027a0:	48 89 e5             	mov    %rsp,%rbp
  8027a3:	48 83 ec 40          	sub    $0x40,%rsp
  8027a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027b4:	48 89 d6             	mov    %rdx,%rsi
  8027b7:	89 c7                	mov    %eax,%edi
  8027b9:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cc:	79 08                	jns    8027d6 <dup+0x37>
		return r;
  8027ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d1:	e9 70 01 00 00       	jmpq   802946 <dup+0x1a7>
	close(newfdnum);
  8027d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027d9:	89 c7                	mov    %eax,%edi
  8027db:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ea:	48 98                	cltq   
  8027ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8027f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fe:	48 89 c7             	mov    %rax,%rdi
  802801:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  802808:	00 00 00 
  80280b:	ff d0                	callq  *%rax
  80280d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802815:	48 89 c7             	mov    %rax,%rdi
  802818:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  80281f:	00 00 00 
  802822:	ff d0                	callq  *%rax
  802824:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282c:	48 c1 e8 15          	shr    $0x15,%rax
  802830:	48 89 c2             	mov    %rax,%rdx
  802833:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80283a:	01 00 00 
  80283d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802841:	83 e0 01             	and    $0x1,%eax
  802844:	48 85 c0             	test   %rax,%rax
  802847:	74 73                	je     8028bc <dup+0x11d>
  802849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284d:	48 c1 e8 0c          	shr    $0xc,%rax
  802851:	48 89 c2             	mov    %rax,%rdx
  802854:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80285b:	01 00 00 
  80285e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802862:	83 e0 01             	and    $0x1,%eax
  802865:	48 85 c0             	test   %rax,%rax
  802868:	74 52                	je     8028bc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80286a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286e:	48 c1 e8 0c          	shr    $0xc,%rax
  802872:	48 89 c2             	mov    %rax,%rdx
  802875:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80287c:	01 00 00 
  80287f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802883:	25 07 0e 00 00       	and    $0xe07,%eax
  802888:	89 c1                	mov    %eax,%ecx
  80288a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80288e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802892:	41 89 c8             	mov    %ecx,%r8d
  802895:	48 89 d1             	mov    %rdx,%rcx
  802898:	ba 00 00 00 00       	mov    $0x0,%edx
  80289d:	48 89 c6             	mov    %rax,%rsi
  8028a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a5:	48 b8 2e 1f 80 00 00 	movabs $0x801f2e,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
  8028b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b8:	79 02                	jns    8028bc <dup+0x11d>
			goto err;
  8028ba:	eb 57                	jmp    802913 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8028c4:	48 89 c2             	mov    %rax,%rdx
  8028c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ce:	01 00 00 
  8028d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8028da:	89 c1                	mov    %eax,%ecx
  8028dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028e4:	41 89 c8             	mov    %ecx,%r8d
  8028e7:	48 89 d1             	mov    %rdx,%rcx
  8028ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ef:	48 89 c6             	mov    %rax,%rsi
  8028f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f7:	48 b8 2e 1f 80 00 00 	movabs $0x801f2e,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	callq  *%rax
  802903:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290a:	79 02                	jns    80290e <dup+0x16f>
		goto err;
  80290c:	eb 05                	jmp    802913 <dup+0x174>

	return newfdnum;
  80290e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802911:	eb 33                	jmp    802946 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802917:	48 89 c6             	mov    %rax,%rsi
  80291a:	bf 00 00 00 00       	mov    $0x0,%edi
  80291f:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  802926:	00 00 00 
  802929:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80292b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292f:	48 89 c6             	mov    %rax,%rsi
  802932:	bf 00 00 00 00       	mov    $0x0,%edi
  802937:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
	return r;
  802943:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802946:	c9                   	leaveq 
  802947:	c3                   	retq   

0000000000802948 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802948:	55                   	push   %rbp
  802949:	48 89 e5             	mov    %rsp,%rbp
  80294c:	48 83 ec 40          	sub    $0x40,%rsp
  802950:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802953:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802957:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80295f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802962:	48 89 d6             	mov    %rdx,%rsi
  802965:	89 c7                	mov    %eax,%edi
  802967:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  80296e:	00 00 00 
  802971:	ff d0                	callq  *%rax
  802973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297a:	78 24                	js     8029a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802980:	8b 00                	mov    (%rax),%eax
  802982:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802986:	48 89 d6             	mov    %rdx,%rsi
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
  802997:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299e:	79 05                	jns    8029a5 <read+0x5d>
		return r;
  8029a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a3:	eb 76                	jmp    802a1b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a9:	8b 40 08             	mov    0x8(%rax),%eax
  8029ac:	83 e0 03             	and    $0x3,%eax
  8029af:	83 f8 01             	cmp    $0x1,%eax
  8029b2:	75 3a                	jne    8029ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029b4:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8029bb:	00 00 00 
  8029be:	48 8b 00             	mov    (%rax),%rax
  8029c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029ca:	89 c6                	mov    %eax,%esi
  8029cc:	48 bf 6f 45 80 00 00 	movabs $0x80456f,%rdi
  8029d3:	00 00 00 
  8029d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029db:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  8029e2:	00 00 00 
  8029e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ec:	eb 2d                	jmp    802a1b <read+0xd3>
	}
	if (!dev->dev_read)
  8029ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029f6:	48 85 c0             	test   %rax,%rax
  8029f9:	75 07                	jne    802a02 <read+0xba>
		return -E_NOT_SUPP;
  8029fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a00:	eb 19                	jmp    802a1b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a0a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a12:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a16:	48 89 cf             	mov    %rcx,%rdi
  802a19:	ff d0                	callq  *%rax
}
  802a1b:	c9                   	leaveq 
  802a1c:	c3                   	retq   

0000000000802a1d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a1d:	55                   	push   %rbp
  802a1e:	48 89 e5             	mov    %rsp,%rbp
  802a21:	48 83 ec 30          	sub    $0x30,%rsp
  802a25:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a37:	eb 49                	jmp    802a82 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	48 98                	cltq   
  802a3e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a42:	48 29 c2             	sub    %rax,%rdx
  802a45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a48:	48 63 c8             	movslq %eax,%rcx
  802a4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4f:	48 01 c1             	add    %rax,%rcx
  802a52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a55:	48 89 ce             	mov    %rcx,%rsi
  802a58:	89 c7                	mov    %eax,%edi
  802a5a:	48 b8 48 29 80 00 00 	movabs $0x802948,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	callq  *%rax
  802a66:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a69:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a6d:	79 05                	jns    802a74 <readn+0x57>
			return m;
  802a6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a72:	eb 1c                	jmp    802a90 <readn+0x73>
		if (m == 0)
  802a74:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a78:	75 02                	jne    802a7c <readn+0x5f>
			break;
  802a7a:	eb 11                	jmp    802a8d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a7f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a85:	48 98                	cltq   
  802a87:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a8b:	72 ac                	jb     802a39 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a90:	c9                   	leaveq 
  802a91:	c3                   	retq   

0000000000802a92 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 83 ec 40          	sub    $0x40,%rsp
  802a9a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802aa1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802aa5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802aa9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aac:	48 89 d6             	mov    %rdx,%rsi
  802aaf:	89 c7                	mov    %eax,%edi
  802ab1:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802ab8:	00 00 00 
  802abb:	ff d0                	callq  *%rax
  802abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac4:	78 24                	js     802aea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aca:	8b 00                	mov    (%rax),%eax
  802acc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ad0:	48 89 d6             	mov    %rdx,%rsi
  802ad3:	89 c7                	mov    %eax,%edi
  802ad5:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802adc:	00 00 00 
  802adf:	ff d0                	callq  *%rax
  802ae1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae8:	79 05                	jns    802aef <write+0x5d>
		return r;
  802aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aed:	eb 75                	jmp    802b64 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af3:	8b 40 08             	mov    0x8(%rax),%eax
  802af6:	83 e0 03             	and    $0x3,%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	75 3a                	jne    802b37 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802afd:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b04:	00 00 00 
  802b07:	48 8b 00             	mov    (%rax),%rax
  802b0a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b10:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b13:	89 c6                	mov    %eax,%esi
  802b15:	48 bf 8b 45 80 00 00 	movabs $0x80458b,%rdi
  802b1c:	00 00 00 
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  802b2b:	00 00 00 
  802b2e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b35:	eb 2d                	jmp    802b64 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b3f:	48 85 c0             	test   %rax,%rax
  802b42:	75 07                	jne    802b4b <write+0xb9>
		return -E_NOT_SUPP;
  802b44:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b49:	eb 19                	jmp    802b64 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b53:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b5b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b5f:	48 89 cf             	mov    %rcx,%rdi
  802b62:	ff d0                	callq  *%rax
}
  802b64:	c9                   	leaveq 
  802b65:	c3                   	retq   

0000000000802b66 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b66:	55                   	push   %rbp
  802b67:	48 89 e5             	mov    %rsp,%rbp
  802b6a:	48 83 ec 18          	sub    $0x18,%rsp
  802b6e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b71:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b7b:	48 89 d6             	mov    %rdx,%rsi
  802b7e:	89 c7                	mov    %eax,%edi
  802b80:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b93:	79 05                	jns    802b9a <seek+0x34>
		return r;
  802b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b98:	eb 0f                	jmp    802ba9 <seek+0x43>
	fd->fd_offset = offset;
  802b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba9:	c9                   	leaveq 
  802baa:	c3                   	retq   

0000000000802bab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bab:	55                   	push   %rbp
  802bac:	48 89 e5             	mov    %rsp,%rbp
  802baf:	48 83 ec 30          	sub    $0x30,%rsp
  802bb3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bb6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bb9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc0:	48 89 d6             	mov    %rdx,%rsi
  802bc3:	89 c7                	mov    %eax,%edi
  802bc5:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802bcc:	00 00 00 
  802bcf:	ff d0                	callq  *%rax
  802bd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd8:	78 24                	js     802bfe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bde:	8b 00                	mov    (%rax),%eax
  802be0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802be4:	48 89 d6             	mov    %rdx,%rsi
  802be7:	89 c7                	mov    %eax,%edi
  802be9:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfc:	79 05                	jns    802c03 <ftruncate+0x58>
		return r;
  802bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c01:	eb 72                	jmp    802c75 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c07:	8b 40 08             	mov    0x8(%rax),%eax
  802c0a:	83 e0 03             	and    $0x3,%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	75 3a                	jne    802c4b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c11:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802c18:	00 00 00 
  802c1b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c1e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c24:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c27:	89 c6                	mov    %eax,%esi
  802c29:	48 bf a8 45 80 00 00 	movabs $0x8045a8,%rdi
  802c30:	00 00 00 
  802c33:	b8 00 00 00 00       	mov    $0x0,%eax
  802c38:	48 b9 07 08 80 00 00 	movabs $0x800807,%rcx
  802c3f:	00 00 00 
  802c42:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c49:	eb 2a                	jmp    802c75 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c53:	48 85 c0             	test   %rax,%rax
  802c56:	75 07                	jne    802c5f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c5d:	eb 16                	jmp    802c75 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c63:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c6b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c6e:	89 ce                	mov    %ecx,%esi
  802c70:	48 89 d7             	mov    %rdx,%rdi
  802c73:	ff d0                	callq  *%rax
}
  802c75:	c9                   	leaveq 
  802c76:	c3                   	retq   

0000000000802c77 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c77:	55                   	push   %rbp
  802c78:	48 89 e5             	mov    %rsp,%rbp
  802c7b:	48 83 ec 30          	sub    $0x30,%rsp
  802c7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c8d:	48 89 d6             	mov    %rdx,%rsi
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	78 24                	js     802ccb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cab:	8b 00                	mov    (%rax),%eax
  802cad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb1:	48 89 d6             	mov    %rdx,%rsi
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 6f 26 80 00 00 	movabs $0x80266f,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc9:	79 05                	jns    802cd0 <fstat+0x59>
		return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	eb 5e                	jmp    802d2e <fstat+0xb7>
	if (!dev->dev_stat)
  802cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cd8:	48 85 c0             	test   %rax,%rax
  802cdb:	75 07                	jne    802ce4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cdd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ce2:	eb 4a                	jmp    802d2e <fstat+0xb7>
	stat->st_name[0] = 0;
  802ce4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ceb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cef:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cf6:	00 00 00 
	stat->st_isdir = 0;
  802cf9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d04:	00 00 00 
	stat->st_dev = dev;
  802d07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d0f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d22:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d26:	48 89 ce             	mov    %rcx,%rsi
  802d29:	48 89 d7             	mov    %rdx,%rdi
  802d2c:	ff d0                	callq  *%rax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 83 ec 20          	sub    $0x20,%rsp
  802d38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d44:	be 00 00 00 00       	mov    $0x0,%esi
  802d49:	48 89 c7             	mov    %rax,%rdi
  802d4c:	48 b8 1e 2e 80 00 00 	movabs $0x802e1e,%rax
  802d53:	00 00 00 
  802d56:	ff d0                	callq  *%rax
  802d58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5f:	79 05                	jns    802d66 <stat+0x36>
		return fd;
  802d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d64:	eb 2f                	jmp    802d95 <stat+0x65>
	r = fstat(fd, stat);
  802d66:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6d:	48 89 d6             	mov    %rdx,%rsi
  802d70:	89 c7                	mov    %eax,%edi
  802d72:	48 b8 77 2c 80 00 00 	movabs $0x802c77,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	callq  *%rax
  802d7e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
	return r;
  802d92:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d95:	c9                   	leaveq 
  802d96:	c3                   	retq   

0000000000802d97 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d97:	55                   	push   %rbp
  802d98:	48 89 e5             	mov    %rsp,%rbp
  802d9b:	48 83 ec 10          	sub    $0x10,%rsp
  802d9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802da2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802da6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802dad:	00 00 00 
  802db0:	8b 00                	mov    (%rax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	75 1d                	jne    802dd3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802db6:	bf 01 00 00 00       	mov    $0x1,%edi
  802dbb:	48 b8 91 3e 80 00 00 	movabs $0x803e91,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
  802dc7:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802dce:	00 00 00 
  802dd1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802dd3:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802dda:	00 00 00 
  802ddd:	8b 00                	mov    (%rax),%eax
  802ddf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802de2:	b9 07 00 00 00       	mov    $0x7,%ecx
  802de7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802dee:	00 00 00 
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 f9 3d 80 00 00 	movabs $0x803df9,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e03:	ba 00 00 00 00       	mov    $0x0,%edx
  802e08:	48 89 c6             	mov    %rax,%rsi
  802e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e10:	48 b8 30 3d 80 00 00 	movabs $0x803d30,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
}
  802e1c:	c9                   	leaveq 
  802e1d:	c3                   	retq   

0000000000802e1e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	48 83 ec 20          	sub    $0x20,%rsp
  802e26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e2a:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e31:	48 89 c7             	mov    %rax,%rdi
  802e34:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e45:	7e 0a                	jle    802e51 <open+0x33>
		return -E_BAD_PATH;
  802e47:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e4c:	e9 a5 00 00 00       	jmpq   802ef6 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e51:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e55:	48 89 c7             	mov    %rax,%rdi
  802e58:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
  802e64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6b:	79 08                	jns    802e75 <open+0x57>
		return r;
  802e6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e70:	e9 81 00 00 00       	jmpq   802ef6 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e79:	48 89 c6             	mov    %rax,%rsi
  802e7c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e83:	00 00 00 
  802e86:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e92:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e99:	00 00 00 
  802e9c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e9f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea9:	48 89 c6             	mov    %rax,%rsi
  802eac:	bf 01 00 00 00       	mov    $0x1,%edi
  802eb1:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
  802ebd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec4:	79 1d                	jns    802ee3 <open+0xc5>
		fd_close(fd, 0);
  802ec6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eca:	be 00 00 00 00       	mov    $0x0,%esi
  802ecf:	48 89 c7             	mov    %rax,%rdi
  802ed2:	48 b8 a6 25 80 00 00 	movabs $0x8025a6,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
		return r;
  802ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee1:	eb 13                	jmp    802ef6 <open+0xd8>
	}

	return fd2num(fd);
  802ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee7:	48 89 c7             	mov    %rax,%rdi
  802eea:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802ef6:	c9                   	leaveq 
  802ef7:	c3                   	retq   

0000000000802ef8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ef8:	55                   	push   %rbp
  802ef9:	48 89 e5             	mov    %rsp,%rbp
  802efc:	48 83 ec 10          	sub    $0x10,%rsp
  802f00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f08:	8b 50 0c             	mov    0xc(%rax),%edx
  802f0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f12:	00 00 00 
  802f15:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f17:	be 00 00 00 00       	mov    $0x0,%esi
  802f1c:	bf 06 00 00 00       	mov    $0x6,%edi
  802f21:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
}
  802f2d:	c9                   	leaveq 
  802f2e:	c3                   	retq   

0000000000802f2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
  802f33:	48 83 ec 30          	sub    $0x30,%rsp
  802f37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f47:	8b 50 0c             	mov    0xc(%rax),%edx
  802f4a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f51:	00 00 00 
  802f54:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f56:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5d:	00 00 00 
  802f60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f64:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f68:	be 00 00 00 00       	mov    $0x0,%esi
  802f6d:	bf 03 00 00 00       	mov    $0x3,%edi
  802f72:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f85:	79 05                	jns    802f8c <devfile_read+0x5d>
		return r;
  802f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8a:	eb 26                	jmp    802fb2 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	48 63 d0             	movslq %eax,%rdx
  802f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f96:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f9d:	00 00 00 
  802fa0:	48 89 c7             	mov    %rax,%rdi
  802fa3:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax

	return r;
  802faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802fb2:	c9                   	leaveq 
  802fb3:	c3                   	retq   

0000000000802fb4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fb4:	55                   	push   %rbp
  802fb5:	48 89 e5             	mov    %rsp,%rbp
  802fb8:	48 83 ec 30          	sub    $0x30,%rsp
  802fbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802fc8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802fcf:	00 
  802fd0:	76 08                	jbe    802fda <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802fd2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802fd9:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fde:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fe8:	00 00 00 
  802feb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802fed:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff4:	00 00 00 
  802ff7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ffb:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802fff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803003:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803007:	48 89 c6             	mov    %rax,%rsi
  80300a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803011:	00 00 00 
  803014:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803020:	be 00 00 00 00       	mov    $0x0,%esi
  803025:	bf 04 00 00 00       	mov    $0x4,%edi
  80302a:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
  803036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803039:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303d:	79 05                	jns    803044 <devfile_write+0x90>
		return r;
  80303f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803042:	eb 03                	jmp    803047 <devfile_write+0x93>

	return r;
  803044:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803047:	c9                   	leaveq 
  803048:	c3                   	retq   

0000000000803049 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803049:	55                   	push   %rbp
  80304a:	48 89 e5             	mov    %rsp,%rbp
  80304d:	48 83 ec 20          	sub    $0x20,%rsp
  803051:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803055:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305d:	8b 50 0c             	mov    0xc(%rax),%edx
  803060:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803067:	00 00 00 
  80306a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80306c:	be 00 00 00 00       	mov    $0x0,%esi
  803071:	bf 05 00 00 00       	mov    $0x5,%edi
  803076:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  80307d:	00 00 00 
  803080:	ff d0                	callq  *%rax
  803082:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803089:	79 05                	jns    803090 <devfile_stat+0x47>
		return r;
  80308b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308e:	eb 56                	jmp    8030e6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803090:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803094:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80309b:	00 00 00 
  80309e:	48 89 c7             	mov    %rax,%rdi
  8030a1:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030ad:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b4:	00 00 00 
  8030b7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030c7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ce:	00 00 00 
  8030d1:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030db:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e6:	c9                   	leaveq 
  8030e7:	c3                   	retq   

00000000008030e8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030e8:	55                   	push   %rbp
  8030e9:	48 89 e5             	mov    %rsp,%rbp
  8030ec:	48 83 ec 10          	sub    $0x10,%rsp
  8030f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030f4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fb:	8b 50 0c             	mov    0xc(%rax),%edx
  8030fe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803105:	00 00 00 
  803108:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80310a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803111:	00 00 00 
  803114:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803117:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80311a:	be 00 00 00 00       	mov    $0x0,%esi
  80311f:	bf 02 00 00 00       	mov    $0x2,%edi
  803124:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
}
  803130:	c9                   	leaveq 
  803131:	c3                   	retq   

0000000000803132 <remove>:

// Delete a file
int
remove(const char *path)
{
  803132:	55                   	push   %rbp
  803133:	48 89 e5             	mov    %rsp,%rbp
  803136:	48 83 ec 10          	sub    $0x10,%rsp
  80313a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80313e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803142:	48 89 c7             	mov    %rax,%rdi
  803145:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	callq  *%rax
  803151:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803156:	7e 07                	jle    80315f <remove+0x2d>
		return -E_BAD_PATH;
  803158:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80315d:	eb 33                	jmp    803192 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80315f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803163:	48 89 c6             	mov    %rax,%rsi
  803166:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80316d:	00 00 00 
  803170:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80317c:	be 00 00 00 00       	mov    $0x0,%esi
  803181:	bf 07 00 00 00       	mov    $0x7,%edi
  803186:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  80318d:	00 00 00 
  803190:	ff d0                	callq  *%rax
}
  803192:	c9                   	leaveq 
  803193:	c3                   	retq   

0000000000803194 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803194:	55                   	push   %rbp
  803195:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803198:	be 00 00 00 00       	mov    $0x0,%esi
  80319d:	bf 08 00 00 00       	mov    $0x8,%edi
  8031a2:	48 b8 97 2d 80 00 00 	movabs $0x802d97,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	5d                   	pop    %rbp
  8031af:	c3                   	retq   

00000000008031b0 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 20          	sub    $0x20,%rsp
  8031b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8031bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c0:	8b 40 0c             	mov    0xc(%rax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	7e 67                	jle    80322e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8031c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cb:	8b 40 04             	mov    0x4(%rax),%eax
  8031ce:	48 63 d0             	movslq %eax,%rdx
  8031d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d5:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8031d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dd:	8b 00                	mov    (%rax),%eax
  8031df:	48 89 ce             	mov    %rcx,%rsi
  8031e2:	89 c7                	mov    %eax,%edi
  8031e4:	48 b8 92 2a 80 00 00 	movabs $0x802a92,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
  8031f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8031f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f7:	7e 13                	jle    80320c <writebuf+0x5c>
			b->result += result;
  8031f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fd:	8b 50 08             	mov    0x8(%rax),%edx
  803200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803203:	01 c2                	add    %eax,%edx
  803205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803209:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80320c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803210:	8b 40 04             	mov    0x4(%rax),%eax
  803213:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803216:	74 16                	je     80322e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803218:	b8 00 00 00 00       	mov    $0x0,%eax
  80321d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803221:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803225:	89 c2                	mov    %eax,%edx
  803227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80322e:	c9                   	leaveq 
  80322f:	c3                   	retq   

0000000000803230 <putch>:

static void
putch(int ch, void *thunk)
{
  803230:	55                   	push   %rbp
  803231:	48 89 e5             	mov    %rsp,%rbp
  803234:	48 83 ec 20          	sub    $0x20,%rsp
  803238:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80323b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80323f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324b:	8b 40 04             	mov    0x4(%rax),%eax
  80324e:	8d 48 01             	lea    0x1(%rax),%ecx
  803251:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803255:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803258:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80325b:	89 d1                	mov    %edx,%ecx
  80325d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803261:	48 98                	cltq   
  803263:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326b:	8b 40 04             	mov    0x4(%rax),%eax
  80326e:	3d 00 01 00 00       	cmp    $0x100,%eax
  803273:	75 1e                	jne    803293 <putch+0x63>
		writebuf(b);
  803275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803279:	48 89 c7             	mov    %rax,%rdi
  80327c:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
		b->idx = 0;
  803288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803293:	c9                   	leaveq 
  803294:	c3                   	retq   

0000000000803295 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803295:	55                   	push   %rbp
  803296:	48 89 e5             	mov    %rsp,%rbp
  803299:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8032a0:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8032a6:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8032ad:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8032b4:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8032ba:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8032c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8032c7:	00 00 00 
	b.result = 0;
  8032ca:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8032d1:	00 00 00 
	b.error = 1;
  8032d4:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8032db:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8032de:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8032e5:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8032ec:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8032f3:	48 89 c6             	mov    %rax,%rsi
  8032f6:	48 bf 30 32 80 00 00 	movabs $0x803230,%rdi
  8032fd:	00 00 00 
  803300:	48 b8 ba 0b 80 00 00 	movabs $0x800bba,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80330c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	7e 16                	jle    80332c <vfprintf+0x97>
		writebuf(&b);
  803316:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80332c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 08                	je     80333e <vfprintf+0xa9>
  803336:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80333c:	eb 06                	jmp    803344 <vfprintf+0xaf>
  80333e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803344:	c9                   	leaveq 
  803345:	c3                   	retq   

0000000000803346 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803346:	55                   	push   %rbp
  803347:	48 89 e5             	mov    %rsp,%rbp
  80334a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803351:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803357:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80335e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803365:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80336c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803373:	84 c0                	test   %al,%al
  803375:	74 20                	je     803397 <fprintf+0x51>
  803377:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80337b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80337f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803383:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803387:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80338b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80338f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803393:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803397:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80339e:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8033a5:	00 00 00 
  8033a8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033af:	00 00 00 
  8033b2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033b6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033bd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033c4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8033cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033d2:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8033d9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8033df:	48 89 ce             	mov    %rcx,%rsi
  8033e2:	89 c7                	mov    %eax,%edi
  8033e4:	48 b8 95 32 80 00 00 	movabs $0x803295,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
  8033f0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033f6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033fc:	c9                   	leaveq 
  8033fd:	c3                   	retq   

00000000008033fe <printf>:

int
printf(const char *fmt, ...)
{
  8033fe:	55                   	push   %rbp
  8033ff:	48 89 e5             	mov    %rsp,%rbp
  803402:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803409:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803410:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803417:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80341e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803425:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80342c:	84 c0                	test   %al,%al
  80342e:	74 20                	je     803450 <printf+0x52>
  803430:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803434:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803438:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80343c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803440:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803444:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803448:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80344c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803450:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803457:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80345e:	00 00 00 
  803461:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803468:	00 00 00 
  80346b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80346f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803476:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80347d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803484:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80348b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803492:	48 89 c6             	mov    %rax,%rsi
  803495:	bf 01 00 00 00       	mov    $0x1,%edi
  80349a:	48 b8 95 32 80 00 00 	movabs $0x803295,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8034ac:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034b2:	c9                   	leaveq 
  8034b3:	c3                   	retq   

00000000008034b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034b4:	55                   	push   %rbp
  8034b5:	48 89 e5             	mov    %rsp,%rbp
  8034b8:	53                   	push   %rbx
  8034b9:	48 83 ec 38          	sub    $0x38,%rsp
  8034bd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034c1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034c5:	48 89 c7             	mov    %rax,%rdi
  8034c8:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
  8034d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034db:	0f 88 bf 01 00 00    	js     8036a0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8034ea:	48 89 c6             	mov    %rax,%rsi
  8034ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f2:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
  8034fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803501:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803505:	0f 88 95 01 00 00    	js     8036a0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80350b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80350f:	48 89 c7             	mov    %rax,%rdi
  803512:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  803519:	00 00 00 
  80351c:	ff d0                	callq  *%rax
  80351e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803521:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803525:	0f 88 5d 01 00 00    	js     803688 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80352b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80352f:	ba 07 04 00 00       	mov    $0x407,%edx
  803534:	48 89 c6             	mov    %rax,%rsi
  803537:	bf 00 00 00 00       	mov    $0x0,%edi
  80353c:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80354b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80354f:	0f 88 33 01 00 00    	js     803688 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803559:	48 89 c7             	mov    %rax,%rdi
  80355c:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80356c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803570:	ba 07 04 00 00       	mov    $0x407,%edx
  803575:	48 89 c6             	mov    %rax,%rsi
  803578:	bf 00 00 00 00       	mov    $0x0,%edi
  80357d:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80358c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803590:	79 05                	jns    803597 <pipe+0xe3>
		goto err2;
  803592:	e9 d9 00 00 00       	jmpq   803670 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80359b:	48 89 c7             	mov    %rax,%rdi
  80359e:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  8035a5:	00 00 00 
  8035a8:	ff d0                	callq  *%rax
  8035aa:	48 89 c2             	mov    %rax,%rdx
  8035ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035b7:	48 89 d1             	mov    %rdx,%rcx
  8035ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8035bf:	48 89 c6             	mov    %rax,%rsi
  8035c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c7:	48 b8 2e 1f 80 00 00 	movabs $0x801f2e,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
  8035d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035da:	79 1b                	jns    8035f7 <pipe+0x143>
		goto err3;
  8035dc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8035dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e1:	48 89 c6             	mov    %rax,%rsi
  8035e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e9:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	eb 79                	jmp    803670 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035fb:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803602:	00 00 00 
  803605:	8b 12                	mov    (%rdx),%edx
  803607:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803614:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803618:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80361f:	00 00 00 
  803622:	8b 12                	mov    (%rdx),%edx
  803624:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803626:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80362a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803635:	48 89 c7             	mov    %rax,%rdi
  803638:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
  803644:	89 c2                	mov    %eax,%edx
  803646:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80364a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80364c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803650:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803654:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803658:	48 89 c7             	mov    %rax,%rdi
  80365b:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  803662:	00 00 00 
  803665:	ff d0                	callq  *%rax
  803667:	89 03                	mov    %eax,(%rbx)
	return 0;
  803669:	b8 00 00 00 00       	mov    $0x0,%eax
  80366e:	eb 33                	jmp    8036a3 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803670:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803674:	48 89 c6             	mov    %rax,%rsi
  803677:	bf 00 00 00 00       	mov    $0x0,%edi
  80367c:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368c:	48 89 c6             	mov    %rax,%rsi
  80368f:	bf 00 00 00 00       	mov    $0x0,%edi
  803694:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
    err:
	return r;
  8036a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036a3:	48 83 c4 38          	add    $0x38,%rsp
  8036a7:	5b                   	pop    %rbx
  8036a8:	5d                   	pop    %rbp
  8036a9:	c3                   	retq   

00000000008036aa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036aa:	55                   	push   %rbp
  8036ab:	48 89 e5             	mov    %rsp,%rbp
  8036ae:	53                   	push   %rbx
  8036af:	48 83 ec 28          	sub    $0x28,%rsp
  8036b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036bb:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8036c2:	00 00 00 
  8036c5:	48 8b 00             	mov    (%rax),%rax
  8036c8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036d5:	48 89 c7             	mov    %rax,%rdi
  8036d8:	48 b8 13 3f 80 00 00 	movabs $0x803f13,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 c3                	mov    %eax,%ebx
  8036e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ea:	48 89 c7             	mov    %rax,%rdi
  8036ed:	48 b8 13 3f 80 00 00 	movabs $0x803f13,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
  8036f9:	39 c3                	cmp    %eax,%ebx
  8036fb:	0f 94 c0             	sete   %al
  8036fe:	0f b6 c0             	movzbl %al,%eax
  803701:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803704:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80370b:	00 00 00 
  80370e:	48 8b 00             	mov    (%rax),%rax
  803711:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803717:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80371a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80371d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803720:	75 05                	jne    803727 <_pipeisclosed+0x7d>
			return ret;
  803722:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803725:	eb 4f                	jmp    803776 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803727:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80372d:	74 42                	je     803771 <_pipeisclosed+0xc7>
  80372f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803733:	75 3c                	jne    803771 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803735:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80373c:	00 00 00 
  80373f:	48 8b 00             	mov    (%rax),%rax
  803742:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803748:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80374b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80374e:	89 c6                	mov    %eax,%esi
  803750:	48 bf d3 45 80 00 00 	movabs $0x8045d3,%rdi
  803757:	00 00 00 
  80375a:	b8 00 00 00 00       	mov    $0x0,%eax
  80375f:	49 b8 07 08 80 00 00 	movabs $0x800807,%r8
  803766:	00 00 00 
  803769:	41 ff d0             	callq  *%r8
	}
  80376c:	e9 4a ff ff ff       	jmpq   8036bb <_pipeisclosed+0x11>
  803771:	e9 45 ff ff ff       	jmpq   8036bb <_pipeisclosed+0x11>
}
  803776:	48 83 c4 28          	add    $0x28,%rsp
  80377a:	5b                   	pop    %rbx
  80377b:	5d                   	pop    %rbp
  80377c:	c3                   	retq   

000000000080377d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80377d:	55                   	push   %rbp
  80377e:	48 89 e5             	mov    %rsp,%rbp
  803781:	48 83 ec 30          	sub    $0x30,%rsp
  803785:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803788:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80378c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80378f:	48 89 d6             	mov    %rdx,%rsi
  803792:	89 c7                	mov    %eax,%edi
  803794:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  80379b:	00 00 00 
  80379e:	ff d0                	callq  *%rax
  8037a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a7:	79 05                	jns    8037ae <pipeisclosed+0x31>
		return r;
  8037a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ac:	eb 31                	jmp    8037df <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b2:	48 89 c7             	mov    %rax,%rdi
  8037b5:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
  8037c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037cd:	48 89 d6             	mov    %rdx,%rsi
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 aa 36 80 00 00 	movabs $0x8036aa,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
}
  8037df:	c9                   	leaveq 
  8037e0:	c3                   	retq   

00000000008037e1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037e1:	55                   	push   %rbp
  8037e2:	48 89 e5             	mov    %rsp,%rbp
  8037e5:	48 83 ec 40          	sub    $0x40,%rsp
  8037e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037f1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f9:	48 89 c7             	mov    %rax,%rdi
  8037fc:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  803803:	00 00 00 
  803806:	ff d0                	callq  *%rax
  803808:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80380c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803810:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803814:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80381b:	00 
  80381c:	e9 92 00 00 00       	jmpq   8038b3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803821:	eb 41                	jmp    803864 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803823:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803828:	74 09                	je     803833 <devpipe_read+0x52>
				return i;
  80382a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382e:	e9 92 00 00 00       	jmpq   8038c5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803833:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383b:	48 89 d6             	mov    %rdx,%rsi
  80383e:	48 89 c7             	mov    %rax,%rdi
  803841:	48 b8 aa 36 80 00 00 	movabs $0x8036aa,%rax
  803848:	00 00 00 
  80384b:	ff d0                	callq  *%rax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 07                	je     803858 <devpipe_read+0x77>
				return 0;
  803851:	b8 00 00 00 00       	mov    $0x0,%eax
  803856:	eb 6d                	jmp    8038c5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803858:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803864:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803868:	8b 10                	mov    (%rax),%edx
  80386a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386e:	8b 40 04             	mov    0x4(%rax),%eax
  803871:	39 c2                	cmp    %eax,%edx
  803873:	74 ae                	je     803823 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803879:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80387d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803885:	8b 00                	mov    (%rax),%eax
  803887:	99                   	cltd   
  803888:	c1 ea 1b             	shr    $0x1b,%edx
  80388b:	01 d0                	add    %edx,%eax
  80388d:	83 e0 1f             	and    $0x1f,%eax
  803890:	29 d0                	sub    %edx,%eax
  803892:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803896:	48 98                	cltq   
  803898:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80389d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80389f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a3:	8b 00                	mov    (%rax),%eax
  8038a5:	8d 50 01             	lea    0x1(%rax),%edx
  8038a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ac:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038bb:	0f 82 60 ff ff ff    	jb     803821 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038c5:	c9                   	leaveq 
  8038c6:	c3                   	retq   

00000000008038c7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038c7:	55                   	push   %rbp
  8038c8:	48 89 e5             	mov    %rsp,%rbp
  8038cb:	48 83 ec 40          	sub    $0x40,%rsp
  8038cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038df:	48 89 c7             	mov    %rax,%rdi
  8038e2:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
  8038ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038fa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803901:	00 
  803902:	e9 8e 00 00 00       	jmpq   803995 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803907:	eb 31                	jmp    80393a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803909:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80390d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803911:	48 89 d6             	mov    %rdx,%rsi
  803914:	48 89 c7             	mov    %rax,%rdi
  803917:	48 b8 aa 36 80 00 00 	movabs $0x8036aa,%rax
  80391e:	00 00 00 
  803921:	ff d0                	callq  *%rax
  803923:	85 c0                	test   %eax,%eax
  803925:	74 07                	je     80392e <devpipe_write+0x67>
				return 0;
  803927:	b8 00 00 00 00       	mov    $0x0,%eax
  80392c:	eb 79                	jmp    8039a7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80392e:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80393a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393e:	8b 40 04             	mov    0x4(%rax),%eax
  803941:	48 63 d0             	movslq %eax,%rdx
  803944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803948:	8b 00                	mov    (%rax),%eax
  80394a:	48 98                	cltq   
  80394c:	48 83 c0 20          	add    $0x20,%rax
  803950:	48 39 c2             	cmp    %rax,%rdx
  803953:	73 b4                	jae    803909 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803955:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803959:	8b 40 04             	mov    0x4(%rax),%eax
  80395c:	99                   	cltd   
  80395d:	c1 ea 1b             	shr    $0x1b,%edx
  803960:	01 d0                	add    %edx,%eax
  803962:	83 e0 1f             	and    $0x1f,%eax
  803965:	29 d0                	sub    %edx,%eax
  803967:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80396b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80396f:	48 01 ca             	add    %rcx,%rdx
  803972:	0f b6 0a             	movzbl (%rdx),%ecx
  803975:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803979:	48 98                	cltq   
  80397b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80397f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803983:	8b 40 04             	mov    0x4(%rax),%eax
  803986:	8d 50 01             	lea    0x1(%rax),%edx
  803989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803990:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803995:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803999:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80399d:	0f 82 64 ff ff ff    	jb     803907 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039a7:	c9                   	leaveq 
  8039a8:	c3                   	retq   

00000000008039a9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039a9:	55                   	push   %rbp
  8039aa:	48 89 e5             	mov    %rsp,%rbp
  8039ad:	48 83 ec 20          	sub    $0x20,%rsp
  8039b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039bd:	48 89 c7             	mov    %rax,%rdi
  8039c0:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  8039c7:	00 00 00 
  8039ca:	ff d0                	callq  *%rax
  8039cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d4:	48 be e6 45 80 00 00 	movabs $0x8045e6,%rsi
  8039db:	00 00 00 
  8039de:	48 89 c7             	mov    %rax,%rdi
  8039e1:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8039e8:	00 00 00 
  8039eb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f1:	8b 50 04             	mov    0x4(%rax),%edx
  8039f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f8:	8b 00                	mov    (%rax),%eax
  8039fa:	29 c2                	sub    %eax,%edx
  8039fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a00:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a0a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a11:	00 00 00 
	stat->st_dev = &devpipe;
  803a14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a18:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a1f:	00 00 00 
  803a22:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a2e:	c9                   	leaveq 
  803a2f:	c3                   	retq   

0000000000803a30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a30:	55                   	push   %rbp
  803a31:	48 89 e5             	mov    %rsp,%rbp
  803a34:	48 83 ec 10          	sub    $0x10,%rsp
  803a38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a40:	48 89 c6             	mov    %rax,%rsi
  803a43:	bf 00 00 00 00       	mov    $0x0,%edi
  803a48:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  803a4f:	00 00 00 
  803a52:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a58:	48 89 c7             	mov    %rax,%rdi
  803a5b:	48 b8 53 24 80 00 00 	movabs $0x802453,%rax
  803a62:	00 00 00 
  803a65:	ff d0                	callq  *%rax
  803a67:	48 89 c6             	mov    %rax,%rsi
  803a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6f:	48 b8 89 1f 80 00 00 	movabs $0x801f89,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
}
  803a7b:	c9                   	leaveq 
  803a7c:	c3                   	retq   

0000000000803a7d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a7d:	55                   	push   %rbp
  803a7e:	48 89 e5             	mov    %rsp,%rbp
  803a81:	48 83 ec 20          	sub    $0x20,%rsp
  803a85:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a8b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a8e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a92:	be 01 00 00 00       	mov    $0x1,%esi
  803a97:	48 89 c7             	mov    %rax,%rdi
  803a9a:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803aa1:	00 00 00 
  803aa4:	ff d0                	callq  *%rax
}
  803aa6:	c9                   	leaveq 
  803aa7:	c3                   	retq   

0000000000803aa8 <getchar>:

int
getchar(void)
{
  803aa8:	55                   	push   %rbp
  803aa9:	48 89 e5             	mov    %rsp,%rbp
  803aac:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ab0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ab4:	ba 01 00 00 00       	mov    $0x1,%edx
  803ab9:	48 89 c6             	mov    %rax,%rsi
  803abc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac1:	48 b8 48 29 80 00 00 	movabs $0x802948,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
  803acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad4:	79 05                	jns    803adb <getchar+0x33>
		return r;
  803ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad9:	eb 14                	jmp    803aef <getchar+0x47>
	if (r < 1)
  803adb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803adf:	7f 07                	jg     803ae8 <getchar+0x40>
		return -E_EOF;
  803ae1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ae6:	eb 07                	jmp    803aef <getchar+0x47>
	return c;
  803ae8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803aec:	0f b6 c0             	movzbl %al,%eax
}
  803aef:	c9                   	leaveq 
  803af0:	c3                   	retq   

0000000000803af1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803af1:	55                   	push   %rbp
  803af2:	48 89 e5             	mov    %rsp,%rbp
  803af5:	48 83 ec 20          	sub    $0x20,%rsp
  803af9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803afc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b03:	48 89 d6             	mov    %rdx,%rsi
  803b06:	89 c7                	mov    %eax,%edi
  803b08:	48 b8 16 25 80 00 00 	movabs $0x802516,%rax
  803b0f:	00 00 00 
  803b12:	ff d0                	callq  *%rax
  803b14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1b:	79 05                	jns    803b22 <iscons+0x31>
		return r;
  803b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b20:	eb 1a                	jmp    803b3c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b26:	8b 10                	mov    (%rax),%edx
  803b28:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b2f:	00 00 00 
  803b32:	8b 00                	mov    (%rax),%eax
  803b34:	39 c2                	cmp    %eax,%edx
  803b36:	0f 94 c0             	sete   %al
  803b39:	0f b6 c0             	movzbl %al,%eax
}
  803b3c:	c9                   	leaveq 
  803b3d:	c3                   	retq   

0000000000803b3e <opencons>:

int
opencons(void)
{
  803b3e:	55                   	push   %rbp
  803b3f:	48 89 e5             	mov    %rsp,%rbp
  803b42:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b46:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b4a:	48 89 c7             	mov    %rax,%rdi
  803b4d:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
  803b59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b60:	79 05                	jns    803b67 <opencons+0x29>
		return r;
  803b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b65:	eb 5b                	jmp    803bc2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6b:	ba 07 04 00 00       	mov    $0x407,%edx
  803b70:	48 89 c6             	mov    %rax,%rsi
  803b73:	bf 00 00 00 00       	mov    $0x0,%edi
  803b78:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
  803b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8b:	79 05                	jns    803b92 <opencons+0x54>
		return r;
  803b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b90:	eb 30                	jmp    803bc2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b96:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b9d:	00 00 00 
  803ba0:	8b 12                	mov    (%rdx),%edx
  803ba2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb3:	48 89 c7             	mov    %rax,%rdi
  803bb6:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  803bbd:	00 00 00 
  803bc0:	ff d0                	callq  *%rax
}
  803bc2:	c9                   	leaveq 
  803bc3:	c3                   	retq   

0000000000803bc4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bc4:	55                   	push   %rbp
  803bc5:	48 89 e5             	mov    %rsp,%rbp
  803bc8:	48 83 ec 30          	sub    $0x30,%rsp
  803bcc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bdd:	75 07                	jne    803be6 <devcons_read+0x22>
		return 0;
  803bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  803be4:	eb 4b                	jmp    803c31 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803be6:	eb 0c                	jmp    803bf4 <devcons_read+0x30>
		sys_yield();
  803be8:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  803bef:	00 00 00 
  803bf2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bf4:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803bfb:	00 00 00 
  803bfe:	ff d0                	callq  *%rax
  803c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c07:	74 df                	je     803be8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0d:	79 05                	jns    803c14 <devcons_read+0x50>
		return c;
  803c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c12:	eb 1d                	jmp    803c31 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c14:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c18:	75 07                	jne    803c21 <devcons_read+0x5d>
		return 0;
  803c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1f:	eb 10                	jmp    803c31 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c24:	89 c2                	mov    %eax,%edx
  803c26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c2a:	88 10                	mov    %dl,(%rax)
	return 1;
  803c2c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c31:	c9                   	leaveq 
  803c32:	c3                   	retq   

0000000000803c33 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c33:	55                   	push   %rbp
  803c34:	48 89 e5             	mov    %rsp,%rbp
  803c37:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c3e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c45:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c4c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c5a:	eb 76                	jmp    803cd2 <devcons_write+0x9f>
		m = n - tot;
  803c5c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c63:	89 c2                	mov    %eax,%edx
  803c65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c68:	29 c2                	sub    %eax,%edx
  803c6a:	89 d0                	mov    %edx,%eax
  803c6c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c72:	83 f8 7f             	cmp    $0x7f,%eax
  803c75:	76 07                	jbe    803c7e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c77:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c81:	48 63 d0             	movslq %eax,%rdx
  803c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c87:	48 63 c8             	movslq %eax,%rcx
  803c8a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c91:	48 01 c1             	add    %rax,%rcx
  803c94:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c9b:	48 89 ce             	mov    %rcx,%rsi
  803c9e:	48 89 c7             	mov    %rax,%rdi
  803ca1:	48 b8 d3 18 80 00 00 	movabs $0x8018d3,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb0:	48 63 d0             	movslq %eax,%rdx
  803cb3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cba:	48 89 d6             	mov    %rdx,%rsi
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ccc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ccf:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd5:	48 98                	cltq   
  803cd7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cde:	0f 82 78 ff ff ff    	jb     803c5c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ce7:	c9                   	leaveq 
  803ce8:	c3                   	retq   

0000000000803ce9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ce9:	55                   	push   %rbp
  803cea:	48 89 e5             	mov    %rsp,%rbp
  803ced:	48 83 ec 08          	sub    $0x8,%rsp
  803cf1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cfa:	c9                   	leaveq 
  803cfb:	c3                   	retq   

0000000000803cfc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cfc:	55                   	push   %rbp
  803cfd:	48 89 e5             	mov    %rsp,%rbp
  803d00:	48 83 ec 10          	sub    $0x10,%rsp
  803d04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d10:	48 be f2 45 80 00 00 	movabs $0x8045f2,%rsi
  803d17:	00 00 00 
  803d1a:	48 89 c7             	mov    %rax,%rdi
  803d1d:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
	return 0;
  803d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d2e:	c9                   	leaveq 
  803d2f:	c3                   	retq   

0000000000803d30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d30:	55                   	push   %rbp
  803d31:	48 89 e5             	mov    %rsp,%rbp
  803d34:	48 83 ec 30          	sub    $0x30,%rsp
  803d38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803d44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803d4c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d51:	75 0e                	jne    803d61 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803d53:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d5a:	00 00 00 
  803d5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d65:	48 89 c7             	mov    %rax,%rdi
  803d68:	48 b8 07 21 80 00 00 	movabs $0x802107,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
  803d74:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803d7b:	79 27                	jns    803da4 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803d7d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d82:	74 0a                	je     803d8e <ipc_recv+0x5e>
			*from_env_store = 0;
  803d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d88:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803d8e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d93:	74 0a                	je     803d9f <ipc_recv+0x6f>
			*perm_store = 0;
  803d95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d99:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803d9f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803da2:	eb 53                	jmp    803df7 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803da4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803da9:	74 19                	je     803dc4 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803dab:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803db2:	00 00 00 
  803db5:	48 8b 00             	mov    (%rax),%rax
  803db8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803dbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dc2:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803dc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dc9:	74 19                	je     803de4 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803dcb:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803dd2:	00 00 00 
  803dd5:	48 8b 00             	mov    (%rax),%rax
  803dd8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803dde:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de2:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803de4:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803deb:	00 00 00 
  803dee:	48 8b 00             	mov    (%rax),%rax
  803df1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803df7:	c9                   	leaveq 
  803df8:	c3                   	retq   

0000000000803df9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803df9:	55                   	push   %rbp
  803dfa:	48 89 e5             	mov    %rsp,%rbp
  803dfd:	48 83 ec 30          	sub    $0x30,%rsp
  803e01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e04:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e07:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e0b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803e0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803e16:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e1b:	75 10                	jne    803e2d <ipc_send+0x34>
		page = (void *)KERNBASE;
  803e1d:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e24:	00 00 00 
  803e27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803e2b:	eb 0e                	jmp    803e3b <ipc_send+0x42>
  803e2d:	eb 0c                	jmp    803e3b <ipc_send+0x42>
		sys_yield();
  803e2f:	48 b8 a0 1e 80 00 00 	movabs $0x801ea0,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803e3b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e3e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e48:	89 c7                	mov    %eax,%edi
  803e4a:	48 b8 b2 20 80 00 00 	movabs $0x8020b2,%rax
  803e51:	00 00 00 
  803e54:	ff d0                	callq  *%rax
  803e56:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803e59:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803e5d:	74 d0                	je     803e2f <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803e63:	74 2a                	je     803e8f <ipc_send+0x96>
		panic("error on ipc send procedure");
  803e65:	48 ba f9 45 80 00 00 	movabs $0x8045f9,%rdx
  803e6c:	00 00 00 
  803e6f:	be 49 00 00 00       	mov    $0x49,%esi
  803e74:	48 bf 15 46 80 00 00 	movabs $0x804615,%rdi
  803e7b:	00 00 00 
  803e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e83:	48 b9 ce 05 80 00 00 	movabs $0x8005ce,%rcx
  803e8a:	00 00 00 
  803e8d:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803e8f:	c9                   	leaveq 
  803e90:	c3                   	retq   

0000000000803e91 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e91:	55                   	push   %rbp
  803e92:	48 89 e5             	mov    %rsp,%rbp
  803e95:	48 83 ec 14          	sub    $0x14,%rsp
  803e99:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ea3:	eb 5e                	jmp    803f03 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ea5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803eac:	00 00 00 
  803eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb2:	48 63 d0             	movslq %eax,%rdx
  803eb5:	48 89 d0             	mov    %rdx,%rax
  803eb8:	48 c1 e0 03          	shl    $0x3,%rax
  803ebc:	48 01 d0             	add    %rdx,%rax
  803ebf:	48 c1 e0 05          	shl    $0x5,%rax
  803ec3:	48 01 c8             	add    %rcx,%rax
  803ec6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ecc:	8b 00                	mov    (%rax),%eax
  803ece:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ed1:	75 2c                	jne    803eff <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ed3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803eda:	00 00 00 
  803edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee0:	48 63 d0             	movslq %eax,%rdx
  803ee3:	48 89 d0             	mov    %rdx,%rax
  803ee6:	48 c1 e0 03          	shl    $0x3,%rax
  803eea:	48 01 d0             	add    %rdx,%rax
  803eed:	48 c1 e0 05          	shl    $0x5,%rax
  803ef1:	48 01 c8             	add    %rcx,%rax
  803ef4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803efa:	8b 40 08             	mov    0x8(%rax),%eax
  803efd:	eb 12                	jmp    803f11 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803eff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f03:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f0a:	7e 99                	jle    803ea5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f11:	c9                   	leaveq 
  803f12:	c3                   	retq   

0000000000803f13 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f13:	55                   	push   %rbp
  803f14:	48 89 e5             	mov    %rsp,%rbp
  803f17:	48 83 ec 18          	sub    $0x18,%rsp
  803f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f23:	48 c1 e8 15          	shr    $0x15,%rax
  803f27:	48 89 c2             	mov    %rax,%rdx
  803f2a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f31:	01 00 00 
  803f34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f38:	83 e0 01             	and    $0x1,%eax
  803f3b:	48 85 c0             	test   %rax,%rax
  803f3e:	75 07                	jne    803f47 <pageref+0x34>
		return 0;
  803f40:	b8 00 00 00 00       	mov    $0x0,%eax
  803f45:	eb 53                	jmp    803f9a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f4b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f4f:	48 89 c2             	mov    %rax,%rdx
  803f52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f59:	01 00 00 
  803f5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f68:	83 e0 01             	and    $0x1,%eax
  803f6b:	48 85 c0             	test   %rax,%rax
  803f6e:	75 07                	jne    803f77 <pageref+0x64>
		return 0;
  803f70:	b8 00 00 00 00       	mov    $0x0,%eax
  803f75:	eb 23                	jmp    803f9a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f7b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f7f:	48 89 c2             	mov    %rax,%rdx
  803f82:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f89:	00 00 00 
  803f8c:	48 c1 e2 04          	shl    $0x4,%rdx
  803f90:	48 01 d0             	add    %rdx,%rax
  803f93:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f97:	0f b7 c0             	movzwl %ax,%eax
}
  803f9a:	c9                   	leaveq 
  803f9b:	c3                   	retq   
