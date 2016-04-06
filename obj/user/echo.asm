
obj/user/echo.debug:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
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
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be 00 36 80 00 00 	movabs $0x803600,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be 03 36 80 00 00 	movabs $0x803603,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be 05 36 80 00 00 	movabs $0x803605,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800161:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 98                	cltq   
  80016f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800174:	48 89 c2             	mov    %rax,%rdx
  800177:	48 89 d0             	mov    %rdx,%rax
  80017a:	48 c1 e0 03          	shl    $0x3,%rax
  80017e:	48 01 d0             	add    %rdx,%rax
  800181:	48 c1 e0 05          	shl    $0x5,%rax
  800185:	48 89 c2             	mov    %rax,%rdx
  800188:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80018f:	00 00 00 
  800192:	48 01 c2             	add    %rax,%rdx
  800195:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80019c:	00 00 00 
  80019f:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a6:	7e 14                	jle    8001bc <libmain+0x6a>
		binaryname = argv[0];
  8001a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ac:	48 8b 10             	mov    (%rax),%rdx
  8001af:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001b6:	00 00 00 
  8001b9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c3:	48 89 d6             	mov    %rdx,%rsi
  8001c6:	89 c7                	mov    %eax,%edi
  8001c8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d4:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	callq  *%rax
}
  8001e0:	c9                   	leaveq 
  8001e1:	c3                   	retq   

00000000008001e2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e6:	48 b8 4e 11 80 00 00 	movabs $0x80114e,%rax
  8001ed:	00 00 00 
  8001f0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f7:	48 b8 e0 0a 80 00 00 	movabs $0x800ae0,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax
}
  800203:	5d                   	pop    %rbp
  800204:	c3                   	retq   

0000000000800205 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800205:	55                   	push   %rbp
  800206:	48 89 e5             	mov    %rsp,%rbp
  800209:	48 83 ec 18          	sub    $0x18,%rsp
  80020d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800218:	eb 09                	jmp    800223 <strlen+0x1e>
		n++;
  80021a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800227:	0f b6 00             	movzbl (%rax),%eax
  80022a:	84 c0                	test   %al,%al
  80022c:	75 ec                	jne    80021a <strlen+0x15>
		n++;
	return n;
  80022e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800231:	c9                   	leaveq 
  800232:	c3                   	retq   

0000000000800233 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	48 83 ec 20          	sub    $0x20,%rsp
  80023b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80023f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80024a:	eb 0e                	jmp    80025a <strnlen+0x27>
		n++;
  80024c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800250:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800255:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80025a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80025f:	74 0b                	je     80026c <strnlen+0x39>
  800261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800265:	0f b6 00             	movzbl (%rax),%eax
  800268:	84 c0                	test   %al,%al
  80026a:	75 e0                	jne    80024c <strnlen+0x19>
		n++;
	return n;
  80026c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80026f:	c9                   	leaveq 
  800270:	c3                   	retq   

0000000000800271 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	48 83 ec 20          	sub    $0x20,%rsp
  800279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80027d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800285:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800289:	90                   	nop
  80028a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800292:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800296:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80029a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80029e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8002a2:	0f b6 12             	movzbl (%rdx),%edx
  8002a5:	88 10                	mov    %dl,(%rax)
  8002a7:	0f b6 00             	movzbl (%rax),%eax
  8002aa:	84 c0                	test   %al,%al
  8002ac:	75 dc                	jne    80028a <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002b2:	c9                   	leaveq 
  8002b3:	c3                   	retq   

00000000008002b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002b4:	55                   	push   %rbp
  8002b5:	48 89 e5             	mov    %rsp,%rbp
  8002b8:	48 83 ec 20          	sub    $0x20,%rsp
  8002bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c8:	48 89 c7             	mov    %rax,%rdi
  8002cb:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
  8002d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002dd:	48 63 d0             	movslq %eax,%rdx
  8002e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e4:	48 01 c2             	add    %rax,%rdx
  8002e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002eb:	48 89 c6             	mov    %rax,%rsi
  8002ee:	48 89 d7             	mov    %rdx,%rdi
  8002f1:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
	return dst;
  8002fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 28          	sub    $0x28,%rsp
  80030b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80031f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800326:	00 
  800327:	eb 2a                	jmp    800353 <strncpy+0x50>
		*dst++ = *src;
  800329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80032d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800335:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800339:	0f b6 12             	movzbl (%rdx),%edx
  80033c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80033e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800342:	0f b6 00             	movzbl (%rax),%eax
  800345:	84 c0                	test   %al,%al
  800347:	74 05                	je     80034e <strncpy+0x4b>
			src++;
  800349:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80034e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800357:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035b:	72 cc                	jb     800329 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80035d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800361:	c9                   	leaveq 
  800362:	c3                   	retq   

0000000000800363 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
  800367:	48 83 ec 28          	sub    $0x28,%rsp
  80036b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80036f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800373:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800377:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80037f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800384:	74 3d                	je     8003c3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800386:	eb 1d                	jmp    8003a5 <strlcpy+0x42>
			*dst++ = *src++;
  800388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80038c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800390:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800394:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800398:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80039c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8003a0:	0f b6 12             	movzbl (%rdx),%edx
  8003a3:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003af:	74 0b                	je     8003bc <strlcpy+0x59>
  8003b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b5:	0f b6 00             	movzbl (%rax),%eax
  8003b8:	84 c0                	test   %al,%al
  8003ba:	75 cc                	jne    800388 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cb:	48 29 c2             	sub    %rax,%rdx
  8003ce:	48 89 d0             	mov    %rdx,%rax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 10          	sub    $0x10,%rsp
  8003db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003e3:	eb 0a                	jmp    8003ef <strcmp+0x1c>
		p++, q++;
  8003e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f3:	0f b6 00             	movzbl (%rax),%eax
  8003f6:	84 c0                	test   %al,%al
  8003f8:	74 12                	je     80040c <strcmp+0x39>
  8003fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003fe:	0f b6 10             	movzbl (%rax),%edx
  800401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800405:	0f b6 00             	movzbl (%rax),%eax
  800408:	38 c2                	cmp    %al,%dl
  80040a:	74 d9                	je     8003e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80040c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800410:	0f b6 00             	movzbl (%rax),%eax
  800413:	0f b6 d0             	movzbl %al,%edx
  800416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041a:	0f b6 00             	movzbl (%rax),%eax
  80041d:	0f b6 c0             	movzbl %al,%eax
  800420:	29 c2                	sub    %eax,%edx
  800422:	89 d0                	mov    %edx,%eax
}
  800424:	c9                   	leaveq 
  800425:	c3                   	retq   

0000000000800426 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800426:	55                   	push   %rbp
  800427:	48 89 e5             	mov    %rsp,%rbp
  80042a:	48 83 ec 18          	sub    $0x18,%rsp
  80042e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800432:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800436:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80043a:	eb 0f                	jmp    80044b <strncmp+0x25>
		n--, p++, q++;
  80043c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800441:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800446:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80044b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800450:	74 1d                	je     80046f <strncmp+0x49>
  800452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800456:	0f b6 00             	movzbl (%rax),%eax
  800459:	84 c0                	test   %al,%al
  80045b:	74 12                	je     80046f <strncmp+0x49>
  80045d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800461:	0f b6 10             	movzbl (%rax),%edx
  800464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800468:	0f b6 00             	movzbl (%rax),%eax
  80046b:	38 c2                	cmp    %al,%dl
  80046d:	74 cd                	je     80043c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80046f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800474:	75 07                	jne    80047d <strncmp+0x57>
		return 0;
  800476:	b8 00 00 00 00       	mov    $0x0,%eax
  80047b:	eb 18                	jmp    800495 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80047d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800481:	0f b6 00             	movzbl (%rax),%eax
  800484:	0f b6 d0             	movzbl %al,%edx
  800487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048b:	0f b6 00             	movzbl (%rax),%eax
  80048e:	0f b6 c0             	movzbl %al,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 d0                	mov    %edx,%eax
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
  80049b:	48 83 ec 0c          	sub    $0xc,%rsp
  80049f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004a3:	89 f0                	mov    %esi,%eax
  8004a5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004a8:	eb 17                	jmp    8004c1 <strchr+0x2a>
		if (*s == c)
  8004aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ae:	0f b6 00             	movzbl (%rax),%eax
  8004b1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004b4:	75 06                	jne    8004bc <strchr+0x25>
			return (char *) s;
  8004b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ba:	eb 15                	jmp    8004d1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004bc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c5:	0f b6 00             	movzbl (%rax),%eax
  8004c8:	84 c0                	test   %al,%al
  8004ca:	75 de                	jne    8004aa <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d1:	c9                   	leaveq 
  8004d2:	c3                   	retq   

00000000008004d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004d3:	55                   	push   %rbp
  8004d4:	48 89 e5             	mov    %rsp,%rbp
  8004d7:	48 83 ec 0c          	sub    $0xc,%rsp
  8004db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004df:	89 f0                	mov    %esi,%eax
  8004e1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004e4:	eb 13                	jmp    8004f9 <strfind+0x26>
		if (*s == c)
  8004e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ea:	0f b6 00             	movzbl (%rax),%eax
  8004ed:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004f0:	75 02                	jne    8004f4 <strfind+0x21>
			break;
  8004f2:	eb 10                	jmp    800504 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fd:	0f b6 00             	movzbl (%rax),%eax
  800500:	84 c0                	test   %al,%al
  800502:	75 e2                	jne    8004e6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  800504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800508:	c9                   	leaveq 
  800509:	c3                   	retq   

000000000080050a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80050a:	55                   	push   %rbp
  80050b:	48 89 e5             	mov    %rsp,%rbp
  80050e:	48 83 ec 18          	sub    $0x18,%rsp
  800512:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800516:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800519:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80051d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800522:	75 06                	jne    80052a <memset+0x20>
		return v;
  800524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800528:	eb 69                	jmp    800593 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80052a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052e:	83 e0 03             	and    $0x3,%eax
  800531:	48 85 c0             	test   %rax,%rax
  800534:	75 48                	jne    80057e <memset+0x74>
  800536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053a:	83 e0 03             	and    $0x3,%eax
  80053d:	48 85 c0             	test   %rax,%rax
  800540:	75 3c                	jne    80057e <memset+0x74>
		c &= 0xFF;
  800542:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800549:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054c:	c1 e0 18             	shl    $0x18,%eax
  80054f:	89 c2                	mov    %eax,%edx
  800551:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800554:	c1 e0 10             	shl    $0x10,%eax
  800557:	09 c2                	or     %eax,%edx
  800559:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80055c:	c1 e0 08             	shl    $0x8,%eax
  80055f:	09 d0                	or     %edx,%eax
  800561:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 c1 e8 02          	shr    $0x2,%rax
  80056c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80056f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800573:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800576:	48 89 d7             	mov    %rdx,%rdi
  800579:	fc                   	cld    
  80057a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80057c:	eb 11                	jmp    80058f <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80057e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800582:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800585:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800589:	48 89 d7             	mov    %rdx,%rdi
  80058c:	fc                   	cld    
  80058d:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80058f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800593:	c9                   	leaveq 
  800594:	c3                   	retq   

0000000000800595 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800595:	55                   	push   %rbp
  800596:	48 89 e5             	mov    %rsp,%rbp
  800599:	48 83 ec 28          	sub    $0x28,%rsp
  80059d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c1:	0f 83 88 00 00 00    	jae    80064f <memmove+0xba>
  8005c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005cf:	48 01 d0             	add    %rdx,%rax
  8005d2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005d6:	76 77                	jbe    80064f <memmove+0xba>
		s += n;
  8005d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005dc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ec:	83 e0 03             	and    $0x3,%eax
  8005ef:	48 85 c0             	test   %rax,%rax
  8005f2:	75 3b                	jne    80062f <memmove+0x9a>
  8005f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f8:	83 e0 03             	and    $0x3,%eax
  8005fb:	48 85 c0             	test   %rax,%rax
  8005fe:	75 2f                	jne    80062f <memmove+0x9a>
  800600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800604:	83 e0 03             	and    $0x3,%eax
  800607:	48 85 c0             	test   %rax,%rax
  80060a:	75 23                	jne    80062f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80060c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800610:	48 83 e8 04          	sub    $0x4,%rax
  800614:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800618:	48 83 ea 04          	sub    $0x4,%rdx
  80061c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800620:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800624:	48 89 c7             	mov    %rax,%rdi
  800627:	48 89 d6             	mov    %rdx,%rsi
  80062a:	fd                   	std    
  80062b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80062d:	eb 1d                	jmp    80064c <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80062f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800633:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80063b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80063f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800643:	48 89 d7             	mov    %rdx,%rdi
  800646:	48 89 c1             	mov    %rax,%rcx
  800649:	fd                   	std    
  80064a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80064c:	fc                   	cld    
  80064d:	eb 57                	jmp    8006a6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80064f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800653:	83 e0 03             	and    $0x3,%eax
  800656:	48 85 c0             	test   %rax,%rax
  800659:	75 36                	jne    800691 <memmove+0xfc>
  80065b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065f:	83 e0 03             	and    $0x3,%eax
  800662:	48 85 c0             	test   %rax,%rax
  800665:	75 2a                	jne    800691 <memmove+0xfc>
  800667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066b:	83 e0 03             	and    $0x3,%eax
  80066e:	48 85 c0             	test   %rax,%rax
  800671:	75 1e                	jne    800691 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800677:	48 c1 e8 02          	shr    $0x2,%rax
  80067b:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80067e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800682:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800686:	48 89 c7             	mov    %rax,%rdi
  800689:	48 89 d6             	mov    %rdx,%rsi
  80068c:	fc                   	cld    
  80068d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80068f:	eb 15                	jmp    8006a6 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800695:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800699:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80069d:	48 89 c7             	mov    %rax,%rdi
  8006a0:	48 89 d6             	mov    %rdx,%rsi
  8006a3:	fc                   	cld    
  8006a4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006aa:	c9                   	leaveq 
  8006ab:	c3                   	retq   

00000000008006ac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006ac:	55                   	push   %rbp
  8006ad:	48 89 e5             	mov    %rsp,%rbp
  8006b0:	48 83 ec 18          	sub    $0x18,%rsp
  8006b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006cc:	48 89 ce             	mov    %rcx,%rsi
  8006cf:	48 89 c7             	mov    %rax,%rdi
  8006d2:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  8006d9:	00 00 00 
  8006dc:	ff d0                	callq  *%rax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 28          	sub    $0x28,%rsp
  8006e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  800704:	eb 36                	jmp    80073c <memcmp+0x5c>
		if (*s1 != *s2)
  800706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070a:	0f b6 10             	movzbl (%rax),%edx
  80070d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800711:	0f b6 00             	movzbl (%rax),%eax
  800714:	38 c2                	cmp    %al,%dl
  800716:	74 1a                	je     800732 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  800718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80071c:	0f b6 00             	movzbl (%rax),%eax
  80071f:	0f b6 d0             	movzbl %al,%edx
  800722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800726:	0f b6 00             	movzbl (%rax),%eax
  800729:	0f b6 c0             	movzbl %al,%eax
  80072c:	29 c2                	sub    %eax,%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	eb 20                	jmp    800752 <memcmp+0x72>
		s1++, s2++;
  800732:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800737:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80073c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800740:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800744:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800748:	48 85 c0             	test   %rax,%rax
  80074b:	75 b9                	jne    800706 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80074d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800752:	c9                   	leaveq 
  800753:	c3                   	retq   

0000000000800754 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 83 ec 28          	sub    $0x28,%rsp
  80075c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800760:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800776:	eb 15                	jmp    80078d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	0f b6 10             	movzbl (%rax),%edx
  80077f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800782:	38 c2                	cmp    %al,%dl
  800784:	75 02                	jne    800788 <memfind+0x34>
			break;
  800786:	eb 0f                	jmp    800797 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800788:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800795:	72 e1                	jb     800778 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80079b:	c9                   	leaveq 
  80079c:	c3                   	retq   

000000000080079d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80079d:	55                   	push   %rbp
  80079e:	48 89 e5             	mov    %rsp,%rbp
  8007a1:	48 83 ec 34          	sub    $0x34,%rsp
  8007a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007ad:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007be:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007bf:	eb 05                	jmp    8007c6 <strtol+0x29>
		s++;
  8007c1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ca:	0f b6 00             	movzbl (%rax),%eax
  8007cd:	3c 20                	cmp    $0x20,%al
  8007cf:	74 f0                	je     8007c1 <strtol+0x24>
  8007d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d5:	0f b6 00             	movzbl (%rax),%eax
  8007d8:	3c 09                	cmp    $0x9,%al
  8007da:	74 e5                	je     8007c1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e0:	0f b6 00             	movzbl (%rax),%eax
  8007e3:	3c 2b                	cmp    $0x2b,%al
  8007e5:	75 07                	jne    8007ee <strtol+0x51>
		s++;
  8007e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ec:	eb 17                	jmp    800805 <strtol+0x68>
	else if (*s == '-')
  8007ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f2:	0f b6 00             	movzbl (%rax),%eax
  8007f5:	3c 2d                	cmp    $0x2d,%al
  8007f7:	75 0c                	jne    800805 <strtol+0x68>
		s++, neg = 1;
  8007f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800805:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800809:	74 06                	je     800811 <strtol+0x74>
  80080b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80080f:	75 28                	jne    800839 <strtol+0x9c>
  800811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800815:	0f b6 00             	movzbl (%rax),%eax
  800818:	3c 30                	cmp    $0x30,%al
  80081a:	75 1d                	jne    800839 <strtol+0x9c>
  80081c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800820:	48 83 c0 01          	add    $0x1,%rax
  800824:	0f b6 00             	movzbl (%rax),%eax
  800827:	3c 78                	cmp    $0x78,%al
  800829:	75 0e                	jne    800839 <strtol+0x9c>
		s += 2, base = 16;
  80082b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800830:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800837:	eb 2c                	jmp    800865 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800839:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80083d:	75 19                	jne    800858 <strtol+0xbb>
  80083f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800843:	0f b6 00             	movzbl (%rax),%eax
  800846:	3c 30                	cmp    $0x30,%al
  800848:	75 0e                	jne    800858 <strtol+0xbb>
		s++, base = 8;
  80084a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80084f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800856:	eb 0d                	jmp    800865 <strtol+0xc8>
	else if (base == 0)
  800858:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80085c:	75 07                	jne    800865 <strtol+0xc8>
		base = 10;
  80085e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800869:	0f b6 00             	movzbl (%rax),%eax
  80086c:	3c 2f                	cmp    $0x2f,%al
  80086e:	7e 1d                	jle    80088d <strtol+0xf0>
  800870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800874:	0f b6 00             	movzbl (%rax),%eax
  800877:	3c 39                	cmp    $0x39,%al
  800879:	7f 12                	jg     80088d <strtol+0xf0>
			dig = *s - '0';
  80087b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087f:	0f b6 00             	movzbl (%rax),%eax
  800882:	0f be c0             	movsbl %al,%eax
  800885:	83 e8 30             	sub    $0x30,%eax
  800888:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80088b:	eb 4e                	jmp    8008db <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80088d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800891:	0f b6 00             	movzbl (%rax),%eax
  800894:	3c 60                	cmp    $0x60,%al
  800896:	7e 1d                	jle    8008b5 <strtol+0x118>
  800898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089c:	0f b6 00             	movzbl (%rax),%eax
  80089f:	3c 7a                	cmp    $0x7a,%al
  8008a1:	7f 12                	jg     8008b5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8008a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a7:	0f b6 00             	movzbl (%rax),%eax
  8008aa:	0f be c0             	movsbl %al,%eax
  8008ad:	83 e8 57             	sub    $0x57,%eax
  8008b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008b3:	eb 26                	jmp    8008db <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b9:	0f b6 00             	movzbl (%rax),%eax
  8008bc:	3c 40                	cmp    $0x40,%al
  8008be:	7e 48                	jle    800908 <strtol+0x16b>
  8008c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c4:	0f b6 00             	movzbl (%rax),%eax
  8008c7:	3c 5a                	cmp    $0x5a,%al
  8008c9:	7f 3d                	jg     800908 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cf:	0f b6 00             	movzbl (%rax),%eax
  8008d2:	0f be c0             	movsbl %al,%eax
  8008d5:	83 e8 37             	sub    $0x37,%eax
  8008d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008de:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008e1:	7c 02                	jl     8008e5 <strtol+0x148>
			break;
  8008e3:	eb 23                	jmp    800908 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008ed:	48 98                	cltq   
  8008ef:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008f4:	48 89 c2             	mov    %rax,%rdx
  8008f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008fa:	48 98                	cltq   
  8008fc:	48 01 d0             	add    %rdx,%rax
  8008ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  800903:	e9 5d ff ff ff       	jmpq   800865 <strtol+0xc8>

	if (endptr)
  800908:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80090d:	74 0b                	je     80091a <strtol+0x17d>
		*endptr = (char *) s;
  80090f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800913:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800917:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80091a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091e:	74 09                	je     800929 <strtol+0x18c>
  800920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800924:	48 f7 d8             	neg    %rax
  800927:	eb 04                	jmp    80092d <strtol+0x190>
  800929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80092d:	c9                   	leaveq 
  80092e:	c3                   	retq   

000000000080092f <strstr>:

char * strstr(const char *in, const char *str)
{
  80092f:	55                   	push   %rbp
  800930:	48 89 e5             	mov    %rsp,%rbp
  800933:	48 83 ec 30          	sub    $0x30,%rsp
  800937:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80093b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80093f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800943:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800947:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80094b:	0f b6 00             	movzbl (%rax),%eax
  80094e:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  800951:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800955:	75 06                	jne    80095d <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  800957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095b:	eb 6b                	jmp    8009c8 <strstr+0x99>

    len = strlen(str);
  80095d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800961:	48 89 c7             	mov    %rax,%rdi
  800964:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  80096b:	00 00 00 
  80096e:	ff d0                	callq  *%rax
  800970:	48 98                	cltq   
  800972:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  800976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800982:	0f b6 00             	movzbl (%rax),%eax
  800985:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  800988:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80098c:	75 07                	jne    800995 <strstr+0x66>
                return (char *) 0;
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	eb 33                	jmp    8009c8 <strstr+0x99>
        } while (sc != c);
  800995:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800999:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80099c:	75 d8                	jne    800976 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80099e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009a2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009aa:	48 89 ce             	mov    %rcx,%rsi
  8009ad:	48 89 c7             	mov    %rax,%rdi
  8009b0:	48 b8 26 04 80 00 00 	movabs $0x800426,%rax
  8009b7:	00 00 00 
  8009ba:	ff d0                	callq  *%rax
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	75 b6                	jne    800976 <strstr+0x47>

    return (char *) (in - 1);
  8009c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c4:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c8:	c9                   	leaveq 
  8009c9:	c3                   	retq   

00000000008009ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009ca:	55                   	push   %rbp
  8009cb:	48 89 e5             	mov    %rsp,%rbp
  8009ce:	53                   	push   %rbx
  8009cf:	48 83 ec 48          	sub    $0x48,%rsp
  8009d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009dd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009e1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009f0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009f4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009fc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800a00:	4c 89 c3             	mov    %r8,%rbx
  800a03:	cd 30                	int    $0x30
  800a05:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  800a09:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a0d:	74 3e                	je     800a4d <syscall+0x83>
  800a0f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a14:	7e 37                	jle    800a4d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a1d:	49 89 d0             	mov    %rdx,%r8
  800a20:	89 c1                	mov    %eax,%ecx
  800a22:	48 ba 11 36 80 00 00 	movabs $0x803611,%rdx
  800a29:	00 00 00 
  800a2c:	be 23 00 00 00       	mov    $0x23,%esi
  800a31:	48 bf 2e 36 80 00 00 	movabs $0x80362e,%rdi
  800a38:	00 00 00 
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a40:	49 b9 09 24 80 00 00 	movabs $0x802409,%r9
  800a47:	00 00 00 
  800a4a:	41 ff d1             	callq  *%r9

	return ret;
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a51:	48 83 c4 48          	add    $0x48,%rsp
  800a55:	5b                   	pop    %rbx
  800a56:	5d                   	pop    %rbp
  800a57:	c3                   	retq   

0000000000800a58 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a58:	55                   	push   %rbp
  800a59:	48 89 e5             	mov    %rsp,%rbp
  800a5c:	48 83 ec 20          	sub    $0x20,%rsp
  800a60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a77:	00 
  800a78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a84:	48 89 d1             	mov    %rdx,%rcx
  800a87:	48 89 c2             	mov    %rax,%rdx
  800a8a:	be 00 00 00 00       	mov    $0x0,%esi
  800a8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a94:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800a9b:	00 00 00 
  800a9e:	ff d0                	callq  *%rax
}
  800aa0:	c9                   	leaveq 
  800aa1:	c3                   	retq   

0000000000800aa2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa2:	55                   	push   %rbp
  800aa3:	48 89 e5             	mov    %rsp,%rbp
  800aa6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aaa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ab1:	00 
  800ab2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	be 00 00 00 00       	mov    $0x0,%esi
  800acd:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800ad9:	00 00 00 
  800adc:	ff d0                	callq  *%rax
}
  800ade:	c9                   	leaveq 
  800adf:	c3                   	retq   

0000000000800ae0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ae0:	55                   	push   %rbp
  800ae1:	48 89 e5             	mov    %rsp,%rbp
  800ae4:	48 83 ec 10          	sub    $0x10,%rsp
  800ae8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aee:	48 98                	cltq   
  800af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800af7:	00 
  800af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b09:	48 89 c2             	mov    %rax,%rdx
  800b0c:	be 01 00 00 00       	mov    $0x1,%esi
  800b11:	bf 03 00 00 00       	mov    $0x3,%edi
  800b16:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b1d:	00 00 00 
  800b20:	ff d0                	callq  *%rax
}
  800b22:	c9                   	leaveq 
  800b23:	c3                   	retq   

0000000000800b24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
  800b28:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b33:	00 
  800b34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b45:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4a:	be 00 00 00 00       	mov    $0x0,%esi
  800b4f:	bf 02 00 00 00       	mov    $0x2,%edi
  800b54:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
}
  800b60:	c9                   	leaveq 
  800b61:	c3                   	retq   

0000000000800b62 <sys_yield>:

void
sys_yield(void)
{
  800b62:	55                   	push   %rbp
  800b63:	48 89 e5             	mov    %rsp,%rbp
  800b66:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b6a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b71:	00 
  800b72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	be 00 00 00 00       	mov    $0x0,%esi
  800b8d:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b92:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800b99:	00 00 00 
  800b9c:	ff d0                	callq  *%rax
}
  800b9e:	c9                   	leaveq 
  800b9f:	c3                   	retq   

0000000000800ba0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba0:	55                   	push   %rbp
  800ba1:	48 89 e5             	mov    %rsp,%rbp
  800ba4:	48 83 ec 20          	sub    $0x20,%rsp
  800ba8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800baf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bb2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb5:	48 63 c8             	movslq %eax,%rcx
  800bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbf:	48 98                	cltq   
  800bc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bc8:	00 
  800bc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bcf:	49 89 c8             	mov    %rcx,%r8
  800bd2:	48 89 d1             	mov    %rdx,%rcx
  800bd5:	48 89 c2             	mov    %rax,%rdx
  800bd8:	be 01 00 00 00       	mov    $0x1,%esi
  800bdd:	bf 04 00 00 00       	mov    $0x4,%edi
  800be2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
}
  800bee:	c9                   	leaveq 
  800bef:	c3                   	retq   

0000000000800bf0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf0:	55                   	push   %rbp
  800bf1:	48 89 e5             	mov    %rsp,%rbp
  800bf4:	48 83 ec 30          	sub    $0x30,%rsp
  800bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bff:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c02:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c06:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c0a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c0d:	48 63 c8             	movslq %eax,%rcx
  800c10:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c17:	48 63 f0             	movslq %eax,%rsi
  800c1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c21:	48 98                	cltq   
  800c23:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c27:	49 89 f9             	mov    %rdi,%r9
  800c2a:	49 89 f0             	mov    %rsi,%r8
  800c2d:	48 89 d1             	mov    %rdx,%rcx
  800c30:	48 89 c2             	mov    %rax,%rdx
  800c33:	be 01 00 00 00       	mov    $0x1,%esi
  800c38:	bf 05 00 00 00       	mov    $0x5,%edi
  800c3d:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
}
  800c49:	c9                   	leaveq 
  800c4a:	c3                   	retq   

0000000000800c4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4b:	55                   	push   %rbp
  800c4c:	48 89 e5             	mov    %rsp,%rbp
  800c4f:	48 83 ec 20          	sub    $0x20,%rsp
  800c53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c61:	48 98                	cltq   
  800c63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c6a:	00 
  800c6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c77:	48 89 d1             	mov    %rdx,%rcx
  800c7a:	48 89 c2             	mov    %rax,%rdx
  800c7d:	be 01 00 00 00       	mov    $0x1,%esi
  800c82:	bf 06 00 00 00       	mov    $0x6,%edi
  800c87:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	callq  *%rax
}
  800c93:	c9                   	leaveq 
  800c94:	c3                   	retq   

0000000000800c95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 83 ec 10          	sub    $0x10,%rsp
  800c9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ca3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca6:	48 63 d0             	movslq %eax,%rdx
  800ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cac:	48 98                	cltq   
  800cae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb5:	00 
  800cb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cc2:	48 89 d1             	mov    %rdx,%rcx
  800cc5:	48 89 c2             	mov    %rax,%rdx
  800cc8:	be 01 00 00 00       	mov    $0x1,%esi
  800ccd:	bf 08 00 00 00       	mov    $0x8,%edi
  800cd2:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800cd9:	00 00 00 
  800cdc:	ff d0                	callq  *%rax
}
  800cde:	c9                   	leaveq 
  800cdf:	c3                   	retq   

0000000000800ce0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce0:	55                   	push   %rbp
  800ce1:	48 89 e5             	mov    %rsp,%rbp
  800ce4:	48 83 ec 20          	sub    $0x20,%rsp
  800ce8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ceb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf6:	48 98                	cltq   
  800cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cff:	00 
  800d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d0c:	48 89 d1             	mov    %rdx,%rcx
  800d0f:	48 89 c2             	mov    %rax,%rdx
  800d12:	be 01 00 00 00       	mov    $0x1,%esi
  800d17:	bf 09 00 00 00       	mov    $0x9,%edi
  800d1c:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
}
  800d28:	c9                   	leaveq 
  800d29:	c3                   	retq   

0000000000800d2a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d2a:	55                   	push   %rbp
  800d2b:	48 89 e5             	mov    %rsp,%rbp
  800d2e:	48 83 ec 20          	sub    $0x20,%rsp
  800d32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d40:	48 98                	cltq   
  800d42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d49:	00 
  800d4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d56:	48 89 d1             	mov    %rdx,%rcx
  800d59:	48 89 c2             	mov    %rax,%rdx
  800d5c:	be 01 00 00 00       	mov    $0x1,%esi
  800d61:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d66:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	callq  *%rax
}
  800d72:	c9                   	leaveq 
  800d73:	c3                   	retq   

0000000000800d74 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d74:	55                   	push   %rbp
  800d75:	48 89 e5             	mov    %rsp,%rbp
  800d78:	48 83 ec 20          	sub    $0x20,%rsp
  800d7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d83:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d87:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d8d:	48 63 f0             	movslq %eax,%rsi
  800d90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d97:	48 98                	cltq   
  800d99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800da4:	00 
  800da5:	49 89 f1             	mov    %rsi,%r9
  800da8:	49 89 c8             	mov    %rcx,%r8
  800dab:	48 89 d1             	mov    %rdx,%rcx
  800dae:	48 89 c2             	mov    %rax,%rdx
  800db1:	be 00 00 00 00       	mov    $0x0,%esi
  800db6:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dbb:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	callq  *%rax
}
  800dc7:	c9                   	leaveq 
  800dc8:	c3                   	retq   

0000000000800dc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc9:	55                   	push   %rbp
  800dca:	48 89 e5             	mov    %rsp,%rbp
  800dcd:	48 83 ec 10          	sub    $0x10,%rsp
  800dd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dd9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800de0:	00 
  800de1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800de7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ded:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df2:	48 89 c2             	mov    %rax,%rdx
  800df5:	be 01 00 00 00       	mov    $0x1,%esi
  800dfa:	bf 0d 00 00 00       	mov    $0xd,%edi
  800dff:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	callq  *%rax
}
  800e0b:	c9                   	leaveq 
  800e0c:	c3                   	retq   

0000000000800e0d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 08          	sub    $0x8,%rsp
  800e15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e19:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800e1d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800e24:	ff ff ff 
  800e27:	48 01 d0             	add    %rdx,%rax
  800e2a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800e2e:	c9                   	leaveq 
  800e2f:	c3                   	retq   

0000000000800e30 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
  800e34:	48 83 ec 08          	sub    $0x8,%rsp
  800e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e40:	48 89 c7             	mov    %rax,%rdi
  800e43:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800e4a:	00 00 00 
  800e4d:	ff d0                	callq  *%rax
  800e4f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800e55:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800e59:	c9                   	leaveq 
  800e5a:	c3                   	retq   

0000000000800e5b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e5b:	55                   	push   %rbp
  800e5c:	48 89 e5             	mov    %rsp,%rbp
  800e5f:	48 83 ec 18          	sub    $0x18,%rsp
  800e63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800e67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e6e:	eb 6b                	jmp    800edb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e73:	48 98                	cltq   
  800e75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800e7b:	48 c1 e0 0c          	shl    $0xc,%rax
  800e7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e87:	48 c1 e8 15          	shr    $0x15,%rax
  800e8b:	48 89 c2             	mov    %rax,%rdx
  800e8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800e95:	01 00 00 
  800e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800e9c:	83 e0 01             	and    $0x1,%eax
  800e9f:	48 85 c0             	test   %rax,%rax
  800ea2:	74 21                	je     800ec5 <fd_alloc+0x6a>
  800ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea8:	48 c1 e8 0c          	shr    $0xc,%rax
  800eac:	48 89 c2             	mov    %rax,%rdx
  800eaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800eb6:	01 00 00 
  800eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ebd:	83 e0 01             	and    $0x1,%eax
  800ec0:	48 85 c0             	test   %rax,%rax
  800ec3:	75 12                	jne    800ed7 <fd_alloc+0x7c>
			*fd_store = fd;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ecd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	eb 1a                	jmp    800ef1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ed7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800edb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800edf:	7e 8f                	jle    800e70 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800eec:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 20          	sub    $0x20,%rsp
  800efb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800f06:	78 06                	js     800f0e <fd_lookup+0x1b>
  800f08:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800f0c:	7e 07                	jle    800f15 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f13:	eb 6c                	jmp    800f81 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f18:	48 98                	cltq   
  800f1a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f20:	48 c1 e0 0c          	shl    $0xc,%rax
  800f24:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f2c:	48 c1 e8 15          	shr    $0x15,%rax
  800f30:	48 89 c2             	mov    %rax,%rdx
  800f33:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f3a:	01 00 00 
  800f3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f41:	83 e0 01             	and    $0x1,%eax
  800f44:	48 85 c0             	test   %rax,%rax
  800f47:	74 21                	je     800f6a <fd_lookup+0x77>
  800f49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4d:	48 c1 e8 0c          	shr    $0xc,%rax
  800f51:	48 89 c2             	mov    %rax,%rdx
  800f54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f5b:	01 00 00 
  800f5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f62:	83 e0 01             	and    $0x1,%eax
  800f65:	48 85 c0             	test   %rax,%rax
  800f68:	75 07                	jne    800f71 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6f:	eb 10                	jmp    800f81 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800f71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f79:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f81:	c9                   	leaveq 
  800f82:	c3                   	retq   

0000000000800f83 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f83:	55                   	push   %rbp
  800f84:	48 89 e5             	mov    %rsp,%rbp
  800f87:	48 83 ec 30          	sub    $0x30,%rsp
  800f8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
  800fa7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fab:	48 89 d6             	mov    %rdx,%rsi
  800fae:	89 c7                	mov    %eax,%edi
  800fb0:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  800fb7:	00 00 00 
  800fba:	ff d0                	callq  *%rax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc3:	78 0a                	js     800fcf <fd_close+0x4c>
	    || fd != fd2)
  800fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800fcd:	74 12                	je     800fe1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800fcf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800fd3:	74 05                	je     800fda <fd_close+0x57>
  800fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd8:	eb 05                	jmp    800fdf <fd_close+0x5c>
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	eb 69                	jmp    80104a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fe5:	8b 00                	mov    (%rax),%eax
  800fe7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800feb:	48 89 d6             	mov    %rdx,%rsi
  800fee:	89 c7                	mov    %eax,%edi
  800ff0:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	callq  *%rax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801003:	78 2a                	js     80102f <fd_close+0xac>
		if (dev->dev_close)
  801005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801009:	48 8b 40 20          	mov    0x20(%rax),%rax
  80100d:	48 85 c0             	test   %rax,%rax
  801010:	74 16                	je     801028 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	48 8b 40 20          	mov    0x20(%rax),%rax
  80101a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80101e:	48 89 d7             	mov    %rdx,%rdi
  801021:	ff d0                	callq  *%rax
  801023:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801026:	eb 07                	jmp    80102f <fd_close+0xac>
		else
			r = 0;
  801028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80102f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801033:	48 89 c6             	mov    %rax,%rsi
  801036:	bf 00 00 00 00       	mov    $0x0,%edi
  80103b:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801042:	00 00 00 
  801045:	ff d0                	callq  *%rax
	return r;
  801047:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 20          	sub    $0x20,%rsp
  801054:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80105b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801062:	eb 41                	jmp    8010a5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801064:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80106b:	00 00 00 
  80106e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801071:	48 63 d2             	movslq %edx,%rdx
  801074:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801078:	8b 00                	mov    (%rax),%eax
  80107a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80107d:	75 22                	jne    8010a1 <dev_lookup+0x55>
			*dev = devtab[i];
  80107f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801086:	00 00 00 
  801089:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80108c:	48 63 d2             	movslq %edx,%rdx
  80108f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801097:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
  80109f:	eb 60                	jmp    801101 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8010a5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8010ac:	00 00 00 
  8010af:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010b2:	48 63 d2             	movslq %edx,%rdx
  8010b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8010b9:	48 85 c0             	test   %rax,%rax
  8010bc:	75 a6                	jne    801064 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8010c5:	00 00 00 
  8010c8:	48 8b 00             	mov    (%rax),%rax
  8010cb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8010d1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8010d4:	89 c6                	mov    %eax,%esi
  8010d6:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  8010dd:	00 00 00 
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	48 b9 42 26 80 00 00 	movabs $0x802642,%rcx
  8010ec:	00 00 00 
  8010ef:	ff d1                	callq  *%rcx
	*dev = 0;
  8010f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8010fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <close>:

int
close(int fdnum)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 20          	sub    $0x20,%rsp
  80110b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801112:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801115:	48 89 d6             	mov    %rdx,%rsi
  801118:	89 c7                	mov    %eax,%edi
  80111a:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801121:	00 00 00 
  801124:	ff d0                	callq  *%rax
  801126:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801129:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80112d:	79 05                	jns    801134 <close+0x31>
		return r;
  80112f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801132:	eb 18                	jmp    80114c <close+0x49>
	else
		return fd_close(fd, 1);
  801134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801138:	be 01 00 00 00       	mov    $0x1,%esi
  80113d:	48 89 c7             	mov    %rax,%rdi
  801140:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  801147:	00 00 00 
  80114a:	ff d0                	callq  *%rax
}
  80114c:	c9                   	leaveq 
  80114d:	c3                   	retq   

000000000080114e <close_all>:

void
close_all(void)
{
  80114e:	55                   	push   %rbp
  80114f:	48 89 e5             	mov    %rsp,%rbp
  801152:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80115d:	eb 15                	jmp    801174 <close_all+0x26>
		close(i);
  80115f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801162:	89 c7                	mov    %eax,%edi
  801164:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801170:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801174:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801178:	7e e5                	jle    80115f <close_all+0x11>
		close(i);
}
  80117a:	c9                   	leaveq 
  80117b:	c3                   	retq   

000000000080117c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	48 83 ec 40          	sub    $0x40,%rsp
  801184:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801187:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80118a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80118e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801191:	48 89 d6             	mov    %rdx,%rsi
  801194:	89 c7                	mov    %eax,%edi
  801196:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80119d:	00 00 00 
  8011a0:	ff d0                	callq  *%rax
  8011a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011a9:	79 08                	jns    8011b3 <dup+0x37>
		return r;
  8011ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ae:	e9 70 01 00 00       	jmpq   801323 <dup+0x1a7>
	close(newfdnum);
  8011b3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011b6:	89 c7                	mov    %eax,%edi
  8011b8:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  8011bf:	00 00 00 
  8011c2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8011c4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8011c7:	48 98                	cltq   
  8011c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8011d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8011d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011db:	48 89 c7             	mov    %rax,%rdi
  8011de:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax
  8011ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 89 c7             	mov    %rax,%rdi
  8011f5:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8011fc:	00 00 00 
  8011ff:	ff d0                	callq  *%rax
  801201:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801209:	48 c1 e8 15          	shr    $0x15,%rax
  80120d:	48 89 c2             	mov    %rax,%rdx
  801210:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801217:	01 00 00 
  80121a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80121e:	83 e0 01             	and    $0x1,%eax
  801221:	48 85 c0             	test   %rax,%rax
  801224:	74 73                	je     801299 <dup+0x11d>
  801226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122a:	48 c1 e8 0c          	shr    $0xc,%rax
  80122e:	48 89 c2             	mov    %rax,%rdx
  801231:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801238:	01 00 00 
  80123b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80123f:	83 e0 01             	and    $0x1,%eax
  801242:	48 85 c0             	test   %rax,%rax
  801245:	74 52                	je     801299 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124b:	48 c1 e8 0c          	shr    $0xc,%rax
  80124f:	48 89 c2             	mov    %rax,%rdx
  801252:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801259:	01 00 00 
  80125c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801260:	25 07 0e 00 00       	and    $0xe07,%eax
  801265:	89 c1                	mov    %eax,%ecx
  801267:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	41 89 c8             	mov    %ecx,%r8d
  801272:	48 89 d1             	mov    %rdx,%rcx
  801275:	ba 00 00 00 00       	mov    $0x0,%edx
  80127a:	48 89 c6             	mov    %rax,%rsi
  80127d:	bf 00 00 00 00       	mov    $0x0,%edi
  801282:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  801289:	00 00 00 
  80128c:	ff d0                	callq  *%rax
  80128e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801295:	79 02                	jns    801299 <dup+0x11d>
			goto err;
  801297:	eb 57                	jmp    8012f0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801299:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129d:	48 c1 e8 0c          	shr    $0xc,%rax
  8012a1:	48 89 c2             	mov    %rax,%rdx
  8012a4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012ab:	01 00 00 
  8012ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b7:	89 c1                	mov    %eax,%ecx
  8012b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012c1:	41 89 c8             	mov    %ecx,%r8d
  8012c4:	48 89 d1             	mov    %rdx,%rcx
  8012c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cc:	48 89 c6             	mov    %rax,%rsi
  8012cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8012d4:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  8012db:	00 00 00 
  8012de:	ff d0                	callq  *%rax
  8012e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e7:	79 02                	jns    8012eb <dup+0x16f>
		goto err;
  8012e9:	eb 05                	jmp    8012f0 <dup+0x174>

	return newfdnum;
  8012eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012ee:	eb 33                	jmp    801323 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	48 89 c6             	mov    %rax,%rsi
  8012f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fc:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801303:	00 00 00 
  801306:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801308:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130c:	48 89 c6             	mov    %rax,%rsi
  80130f:	bf 00 00 00 00       	mov    $0x0,%edi
  801314:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
	return r;
  801320:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801323:	c9                   	leaveq 
  801324:	c3                   	retq   

0000000000801325 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801325:	55                   	push   %rbp
  801326:	48 89 e5             	mov    %rsp,%rbp
  801329:	48 83 ec 40          	sub    $0x40,%rsp
  80132d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801330:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801334:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801338:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80133c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80133f:	48 89 d6             	mov    %rdx,%rsi
  801342:	89 c7                	mov    %eax,%edi
  801344:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  80134b:	00 00 00 
  80134e:	ff d0                	callq  *%rax
  801350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801357:	78 24                	js     80137d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135d:	8b 00                	mov    (%rax),%eax
  80135f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801363:	48 89 d6             	mov    %rdx,%rsi
  801366:	89 c7                	mov    %eax,%edi
  801368:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80136f:	00 00 00 
  801372:	ff d0                	callq  *%rax
  801374:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801377:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80137b:	79 05                	jns    801382 <read+0x5d>
		return r;
  80137d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801380:	eb 76                	jmp    8013f8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	8b 40 08             	mov    0x8(%rax),%eax
  801389:	83 e0 03             	and    $0x3,%eax
  80138c:	83 f8 01             	cmp    $0x1,%eax
  80138f:	75 3a                	jne    8013cb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801391:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801398:	00 00 00 
  80139b:	48 8b 00             	mov    (%rax),%rax
  80139e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8013a4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8013a7:	89 c6                	mov    %eax,%esi
  8013a9:	48 bf 5f 36 80 00 00 	movabs $0x80365f,%rdi
  8013b0:	00 00 00 
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	48 b9 42 26 80 00 00 	movabs $0x802642,%rcx
  8013bf:	00 00 00 
  8013c2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c9:	eb 2d                	jmp    8013f8 <read+0xd3>
	}
	if (!dev->dev_read)
  8013cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013d3:	48 85 c0             	test   %rax,%rax
  8013d6:	75 07                	jne    8013df <read+0xba>
		return -E_NOT_SUPP;
  8013d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8013dd:	eb 19                	jmp    8013f8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8013df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8013e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013ef:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8013f3:	48 89 cf             	mov    %rcx,%rdi
  8013f6:	ff d0                	callq  *%rax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 83 ec 30          	sub    $0x30,%rsp
  801402:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801409:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801414:	eb 49                	jmp    80145f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801419:	48 98                	cltq   
  80141b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80141f:	48 29 c2             	sub    %rax,%rdx
  801422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801425:	48 63 c8             	movslq %eax,%rcx
  801428:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142c:	48 01 c1             	add    %rax,%rcx
  80142f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801432:	48 89 ce             	mov    %rcx,%rsi
  801435:	89 c7                	mov    %eax,%edi
  801437:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  80143e:	00 00 00 
  801441:	ff d0                	callq  *%rax
  801443:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801446:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80144a:	79 05                	jns    801451 <readn+0x57>
			return m;
  80144c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80144f:	eb 1c                	jmp    80146d <readn+0x73>
		if (m == 0)
  801451:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801455:	75 02                	jne    801459 <readn+0x5f>
			break;
  801457:	eb 11                	jmp    80146a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801459:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80145c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80145f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801462:	48 98                	cltq   
  801464:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801468:	72 ac                	jb     801416 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80146a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 40          	sub    $0x40,%rsp
  801477:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80147a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80147e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801482:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801486:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801489:	48 89 d6             	mov    %rdx,%rsi
  80148c:	89 c7                	mov    %eax,%edi
  80148e:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801495:	00 00 00 
  801498:	ff d0                	callq  *%rax
  80149a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80149d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014a1:	78 24                	js     8014c7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a7:	8b 00                	mov    (%rax),%eax
  8014a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8014ad:	48 89 d6             	mov    %rdx,%rsi
  8014b0:	89 c7                	mov    %eax,%edi
  8014b2:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	callq  *%rax
  8014be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8014c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014c5:	79 05                	jns    8014cc <write+0x5d>
		return r;
  8014c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ca:	eb 75                	jmp    801541 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d0:	8b 40 08             	mov    0x8(%rax),%eax
  8014d3:	83 e0 03             	and    $0x3,%eax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 3a                	jne    801514 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014da:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014e1:	00 00 00 
  8014e4:	48 8b 00             	mov    (%rax),%rax
  8014e7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8014ed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8014f0:	89 c6                	mov    %eax,%esi
  8014f2:	48 bf 7b 36 80 00 00 	movabs $0x80367b,%rdi
  8014f9:	00 00 00 
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	48 b9 42 26 80 00 00 	movabs $0x802642,%rcx
  801508:	00 00 00 
  80150b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801512:	eb 2d                	jmp    801541 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 8b 40 18          	mov    0x18(%rax),%rax
  80151c:	48 85 c0             	test   %rax,%rax
  80151f:	75 07                	jne    801528 <write+0xb9>
		return -E_NOT_SUPP;
  801521:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801526:	eb 19                	jmp    801541 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	48 8b 40 18          	mov    0x18(%rax),%rax
  801530:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801534:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801538:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80153c:	48 89 cf             	mov    %rcx,%rdi
  80153f:	ff d0                	callq  *%rax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <seek>:

int
seek(int fdnum, off_t offset)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 18          	sub    $0x18,%rsp
  80154b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80154e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801551:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801558:	48 89 d6             	mov    %rdx,%rsi
  80155b:	89 c7                	mov    %eax,%edi
  80155d:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80156c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801570:	79 05                	jns    801577 <seek+0x34>
		return r;
  801572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801575:	eb 0f                	jmp    801586 <seek+0x43>
	fd->fd_offset = offset;
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80157e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801586:	c9                   	leaveq 
  801587:	c3                   	retq   

0000000000801588 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801588:	55                   	push   %rbp
  801589:	48 89 e5             	mov    %rsp,%rbp
  80158c:	48 83 ec 30          	sub    $0x30,%rsp
  801590:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801593:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801596:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80159a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80159d:	48 89 d6             	mov    %rdx,%rsi
  8015a0:	89 c7                	mov    %eax,%edi
  8015a2:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  8015a9:	00 00 00 
  8015ac:	ff d0                	callq  *%rax
  8015ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b5:	78 24                	js     8015db <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015bb:	8b 00                	mov    (%rax),%eax
  8015bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015c1:	48 89 d6             	mov    %rdx,%rsi
  8015c4:	89 c7                	mov    %eax,%edi
  8015c6:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8015cd:	00 00 00 
  8015d0:	ff d0                	callq  *%rax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d9:	79 05                	jns    8015e0 <ftruncate+0x58>
		return r;
  8015db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015de:	eb 72                	jmp    801652 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e4:	8b 40 08             	mov    0x8(%rax),%eax
  8015e7:	83 e0 03             	and    $0x3,%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 3a                	jne    801628 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015ee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015f5:	00 00 00 
  8015f8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801601:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801604:	89 c6                	mov    %eax,%esi
  801606:	48 bf 98 36 80 00 00 	movabs $0x803698,%rdi
  80160d:	00 00 00 
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	48 b9 42 26 80 00 00 	movabs $0x802642,%rcx
  80161c:	00 00 00 
  80161f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801621:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801626:	eb 2a                	jmp    801652 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162c:	48 8b 40 30          	mov    0x30(%rax),%rax
  801630:	48 85 c0             	test   %rax,%rax
  801633:	75 07                	jne    80163c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801635:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80163a:	eb 16                	jmp    801652 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80163c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801640:	48 8b 40 30          	mov    0x30(%rax),%rax
  801644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801648:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80164b:	89 ce                	mov    %ecx,%esi
  80164d:	48 89 d7             	mov    %rdx,%rdi
  801650:	ff d0                	callq  *%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 30          	sub    $0x30,%rsp
  80165c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801663:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801667:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166a:	48 89 d6             	mov    %rdx,%rsi
  80166d:	89 c7                	mov    %eax,%edi
  80166f:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801676:	00 00 00 
  801679:	ff d0                	callq  *%rax
  80167b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80167e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801682:	78 24                	js     8016a8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	8b 00                	mov    (%rax),%eax
  80168a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80168e:	48 89 d6             	mov    %rdx,%rsi
  801691:	89 c7                	mov    %eax,%edi
  801693:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80169a:	00 00 00 
  80169d:	ff d0                	callq  *%rax
  80169f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a6:	79 05                	jns    8016ad <fstat+0x59>
		return r;
  8016a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ab:	eb 5e                	jmp    80170b <fstat+0xb7>
	if (!dev->dev_stat)
  8016ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016b5:	48 85 c0             	test   %rax,%rax
  8016b8:	75 07                	jne    8016c1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8016ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8016bf:	eb 4a                	jmp    80170b <fstat+0xb7>
	stat->st_name[0] = 0;
  8016c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8016c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016cc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8016d3:	00 00 00 
	stat->st_isdir = 0;
  8016d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016da:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8016e1:	00 00 00 
	stat->st_dev = dev;
  8016e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ec:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8016fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ff:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801703:	48 89 ce             	mov    %rcx,%rsi
  801706:	48 89 d7             	mov    %rdx,%rdi
  801709:	ff d0                	callq  *%rax
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 20          	sub    $0x20,%rsp
  801715:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801719:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801721:	be 00 00 00 00       	mov    $0x0,%esi
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 b8 fb 17 80 00 00 	movabs $0x8017fb,%rax
  801730:	00 00 00 
  801733:	ff d0                	callq  *%rax
  801735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173c:	79 05                	jns    801743 <stat+0x36>
		return fd;
  80173e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801741:	eb 2f                	jmp    801772 <stat+0x65>
	r = fstat(fd, stat);
  801743:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801747:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174a:	48 89 d6             	mov    %rdx,%rsi
  80174d:	89 c7                	mov    %eax,%edi
  80174f:	48 b8 54 16 80 00 00 	movabs $0x801654,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80175e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801761:	89 c7                	mov    %eax,%edi
  801763:	48 b8 03 11 80 00 00 	movabs $0x801103,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	callq  *%rax
	return r;
  80176f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801772:	c9                   	leaveq 
  801773:	c3                   	retq   

0000000000801774 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801774:	55                   	push   %rbp
  801775:	48 89 e5             	mov    %rsp,%rbp
  801778:	48 83 ec 10          	sub    $0x10,%rsp
  80177c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80177f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801783:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80178a:	00 00 00 
  80178d:	8b 00                	mov    (%rax),%eax
  80178f:	85 c0                	test   %eax,%eax
  801791:	75 1d                	jne    8017b0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801793:	bf 01 00 00 00       	mov    $0x1,%edi
  801798:	48 b8 df 34 80 00 00 	movabs $0x8034df,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
  8017a4:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8017ab:	00 00 00 
  8017ae:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017b0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8017b7:	00 00 00 
  8017ba:	8b 00                	mov    (%rax),%eax
  8017bc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8017bf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8017c4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8017cb:	00 00 00 
  8017ce:	89 c7                	mov    %eax,%edi
  8017d0:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8017dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	48 89 c6             	mov    %rax,%rsi
  8017e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ed:	48 b8 7e 33 80 00 00 	movabs $0x80337e,%rax
  8017f4:	00 00 00 
  8017f7:	ff d0                	callq  *%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 20          	sub    $0x20,%rsp
  801803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801807:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80180a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180e:	48 89 c7             	mov    %rax,%rdi
  801811:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801818:	00 00 00 
  80181b:	ff d0                	callq  *%rax
  80181d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801822:	7e 0a                	jle    80182e <open+0x33>
		return -E_BAD_PATH;
  801824:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801829:	e9 a5 00 00 00       	jmpq   8018d3 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80182e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801832:	48 89 c7             	mov    %rax,%rdi
  801835:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  80183c:	00 00 00 
  80183f:	ff d0                	callq  *%rax
  801841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801848:	79 08                	jns    801852 <open+0x57>
		return r;
  80184a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184d:	e9 81 00 00 00       	jmpq   8018d3 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  801852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801856:	48 89 c6             	mov    %rax,%rsi
  801859:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801860:	00 00 00 
  801863:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  80186a:	00 00 00 
  80186d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80186f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801876:	00 00 00 
  801879:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80187c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801886:	48 89 c6             	mov    %rax,%rsi
  801889:	bf 01 00 00 00       	mov    $0x1,%edi
  80188e:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801895:	00 00 00 
  801898:	ff d0                	callq  *%rax
  80189a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80189d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a1:	79 1d                	jns    8018c0 <open+0xc5>
		fd_close(fd, 0);
  8018a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a7:	be 00 00 00 00       	mov    $0x0,%esi
  8018ac:	48 89 c7             	mov    %rax,%rdi
  8018af:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8018b6:	00 00 00 
  8018b9:	ff d0                	callq  *%rax
		return r;
  8018bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018be:	eb 13                	jmp    8018d3 <open+0xd8>
	}

	return fd2num(fd);
  8018c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c4:	48 89 c7             	mov    %rax,%rdi
  8018c7:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  8018ce:	00 00 00 
  8018d1:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	48 83 ec 10          	sub    $0x10,%rsp
  8018dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8018e8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8018ef:	00 00 00 
  8018f2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8018f4:	be 00 00 00 00       	mov    $0x0,%esi
  8018f9:	bf 06 00 00 00       	mov    $0x6,%edi
  8018fe:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801905:	00 00 00 
  801908:	ff d0                	callq  *%rax
}
  80190a:	c9                   	leaveq 
  80190b:	c3                   	retq   

000000000080190c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80190c:	55                   	push   %rbp
  80190d:	48 89 e5             	mov    %rsp,%rbp
  801910:	48 83 ec 30          	sub    $0x30,%rsp
  801914:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801918:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80191c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801924:	8b 50 0c             	mov    0xc(%rax),%edx
  801927:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80192e:	00 00 00 
  801931:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801933:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80193a:	00 00 00 
  80193d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801941:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801945:	be 00 00 00 00       	mov    $0x0,%esi
  80194a:	bf 03 00 00 00       	mov    $0x3,%edi
  80194f:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
  80195b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80195e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801962:	79 05                	jns    801969 <devfile_read+0x5d>
		return r;
  801964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801967:	eb 26                	jmp    80198f <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196c:	48 63 d0             	movslq %eax,%rdx
  80196f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801973:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80197a:	00 00 00 
  80197d:	48 89 c7             	mov    %rax,%rdi
  801980:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax

	return r;
  80198c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 30          	sub    $0x30,%rsp
  801999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80199d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8019a5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8019ac:	00 
  8019ad:	76 08                	jbe    8019b7 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8019af:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8019b6:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8019be:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8019c5:	00 00 00 
  8019c8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8019ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8019d1:	00 00 00 
  8019d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019d8:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8019dc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019e4:	48 89 c6             	mov    %rax,%rsi
  8019e7:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8019ee:	00 00 00 
  8019f1:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  8019f8:	00 00 00 
  8019fb:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019fd:	be 00 00 00 00       	mov    $0x0,%esi
  801a02:	bf 04 00 00 00       	mov    $0x4,%edi
  801a07:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	callq  *%rax
  801a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a1a:	79 05                	jns    801a21 <devfile_write+0x90>
		return r;
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	eb 03                	jmp    801a24 <devfile_write+0x93>

	return r;
  801a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801a24:	c9                   	leaveq 
  801a25:	c3                   	retq   

0000000000801a26 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a26:	55                   	push   %rbp
  801a27:	48 89 e5             	mov    %rsp,%rbp
  801a2a:	48 83 ec 20          	sub    $0x20,%rsp
  801a2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a3a:	8b 50 0c             	mov    0xc(%rax),%edx
  801a3d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a44:	00 00 00 
  801a47:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a49:	be 00 00 00 00       	mov    $0x0,%esi
  801a4e:	bf 05 00 00 00       	mov    $0x5,%edi
  801a53:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a66:	79 05                	jns    801a6d <devfile_stat+0x47>
		return r;
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	eb 56                	jmp    801ac3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a71:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801a78:	00 00 00 
  801a7b:	48 89 c7             	mov    %rax,%rdi
  801a7e:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801a8a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a91:	00 00 00 
  801a94:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a9e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aa4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801aab:	00 00 00 
  801aae:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801ab4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ab8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	48 83 ec 10          	sub    $0x10,%rsp
  801acd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ad1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad8:	8b 50 0c             	mov    0xc(%rax),%edx
  801adb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801ae2:	00 00 00 
  801ae5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801ae7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801aee:	00 00 00 
  801af1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801af4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801af7:	be 00 00 00 00       	mov    $0x0,%esi
  801afc:	bf 02 00 00 00       	mov    $0x2,%edi
  801b01:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <remove>:

// Delete a file
int
remove(const char *path)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 10          	sub    $0x10,%rsp
  801b17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1f:	48 89 c7             	mov    %rax,%rdi
  801b22:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
  801b2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b33:	7e 07                	jle    801b3c <remove+0x2d>
		return -E_BAD_PATH;
  801b35:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801b3a:	eb 33                	jmp    801b6f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801b3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b40:	48 89 c6             	mov    %rax,%rsi
  801b43:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801b4a:	00 00 00 
  801b4d:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  801b54:	00 00 00 
  801b57:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801b59:	be 00 00 00 00       	mov    $0x0,%esi
  801b5e:	bf 07 00 00 00       	mov    $0x7,%edi
  801b63:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801b6a:	00 00 00 
  801b6d:	ff d0                	callq  *%rax
}
  801b6f:	c9                   	leaveq 
  801b70:	c3                   	retq   

0000000000801b71 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801b71:	55                   	push   %rbp
  801b72:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b75:	be 00 00 00 00       	mov    $0x0,%esi
  801b7a:	bf 08 00 00 00       	mov    $0x8,%edi
  801b7f:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	callq  *%rax
}
  801b8b:	5d                   	pop    %rbp
  801b8c:	c3                   	retq   

0000000000801b8d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	53                   	push   %rbx
  801b92:	48 83 ec 38          	sub    $0x38,%rsp
  801b96:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b9a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801b9e:	48 89 c7             	mov    %rax,%rdi
  801ba1:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  801ba8:	00 00 00 
  801bab:	ff d0                	callq  *%rax
  801bad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bb4:	0f 88 bf 01 00 00    	js     801d79 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bbe:	ba 07 04 00 00       	mov    $0x407,%edx
  801bc3:	48 89 c6             	mov    %rax,%rsi
  801bc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bcb:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	callq  *%rax
  801bd7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bda:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bde:	0f 88 95 01 00 00    	js     801d79 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801be4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801be8:	48 89 c7             	mov    %rax,%rdi
  801beb:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
  801bf7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bfe:	0f 88 5d 01 00 00    	js     801d61 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c08:	ba 07 04 00 00       	mov    $0x407,%edx
  801c0d:	48 89 c6             	mov    %rax,%rsi
  801c10:	bf 00 00 00 00       	mov    $0x0,%edi
  801c15:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	callq  *%rax
  801c21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c28:	0f 88 33 01 00 00    	js     801d61 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c32:	48 89 c7             	mov    %rax,%rdi
  801c35:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801c3c:	00 00 00 
  801c3f:	ff d0                	callq  *%rax
  801c41:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c49:	ba 07 04 00 00       	mov    $0x407,%edx
  801c4e:	48 89 c6             	mov    %rax,%rsi
  801c51:	bf 00 00 00 00       	mov    $0x0,%edi
  801c56:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	callq  *%rax
  801c62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c69:	79 05                	jns    801c70 <pipe+0xe3>
		goto err2;
  801c6b:	e9 d9 00 00 00       	jmpq   801d49 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c74:	48 89 c7             	mov    %rax,%rdi
  801c77:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
  801c83:	48 89 c2             	mov    %rax,%rdx
  801c86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c8a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801c90:	48 89 d1             	mov    %rdx,%rcx
  801c93:	ba 00 00 00 00       	mov    $0x0,%edx
  801c98:	48 89 c6             	mov    %rax,%rsi
  801c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca0:	48 b8 f0 0b 80 00 00 	movabs $0x800bf0,%rax
  801ca7:	00 00 00 
  801caa:	ff d0                	callq  *%rax
  801cac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801caf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cb3:	79 1b                	jns    801cd0 <pipe+0x143>
		goto err3;
  801cb5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cba:	48 89 c6             	mov    %rax,%rsi
  801cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc2:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
  801cce:	eb 79                	jmp    801d49 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801cd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd4:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801cdb:	00 00 00 
  801cde:	8b 12                	mov    (%rdx),%edx
  801ce0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801ce2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801ced:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cf1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801cf8:	00 00 00 
  801cfb:	8b 12                	mov    (%rdx),%edx
  801cfd:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801cff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d03:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0e:	48 89 c7             	mov    %rax,%rdi
  801d11:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	callq  *%rax
  801d1d:	89 c2                	mov    %eax,%edx
  801d1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d23:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801d25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d29:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801d2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d31:	48 89 c7             	mov    %rax,%rdi
  801d34:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  801d3b:	00 00 00 
  801d3e:	ff d0                	callq  *%rax
  801d40:	89 03                	mov    %eax,(%rbx)
	return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	eb 33                	jmp    801d7c <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801d49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d4d:	48 89 c6             	mov    %rax,%rsi
  801d50:	bf 00 00 00 00       	mov    $0x0,%edi
  801d55:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801d61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d65:	48 89 c6             	mov    %rax,%rsi
  801d68:	bf 00 00 00 00       	mov    $0x0,%edi
  801d6d:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  801d74:	00 00 00 
  801d77:	ff d0                	callq  *%rax
    err:
	return r;
  801d79:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801d7c:	48 83 c4 38          	add    $0x38,%rsp
  801d80:	5b                   	pop    %rbx
  801d81:	5d                   	pop    %rbp
  801d82:	c3                   	retq   

0000000000801d83 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	53                   	push   %rbx
  801d88:	48 83 ec 28          	sub    $0x28,%rsp
  801d8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d90:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d94:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801d9b:	00 00 00 
  801d9e:	48 8b 00             	mov    (%rax),%rax
  801da1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801da7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dae:	48 89 c7             	mov    %rax,%rdi
  801db1:	48 b8 61 35 80 00 00 	movabs $0x803561,%rax
  801db8:	00 00 00 
  801dbb:	ff d0                	callq  *%rax
  801dbd:	89 c3                	mov    %eax,%ebx
  801dbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc3:	48 89 c7             	mov    %rax,%rdi
  801dc6:	48 b8 61 35 80 00 00 	movabs $0x803561,%rax
  801dcd:	00 00 00 
  801dd0:	ff d0                	callq  *%rax
  801dd2:	39 c3                	cmp    %eax,%ebx
  801dd4:	0f 94 c0             	sete   %al
  801dd7:	0f b6 c0             	movzbl %al,%eax
  801dda:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801ddd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801de4:	00 00 00 
  801de7:	48 8b 00             	mov    (%rax),%rax
  801dea:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801df0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801df3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801df6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801df9:	75 05                	jne    801e00 <_pipeisclosed+0x7d>
			return ret;
  801dfb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dfe:	eb 4f                	jmp    801e4f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801e00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e03:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801e06:	74 42                	je     801e4a <_pipeisclosed+0xc7>
  801e08:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801e0c:	75 3c                	jne    801e4a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e0e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e15:	00 00 00 
  801e18:	48 8b 00             	mov    (%rax),%rax
  801e1b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801e21:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801e24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e27:	89 c6                	mov    %eax,%esi
  801e29:	48 bf c3 36 80 00 00 	movabs $0x8036c3,%rdi
  801e30:	00 00 00 
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
  801e38:	49 b8 42 26 80 00 00 	movabs $0x802642,%r8
  801e3f:	00 00 00 
  801e42:	41 ff d0             	callq  *%r8
	}
  801e45:	e9 4a ff ff ff       	jmpq   801d94 <_pipeisclosed+0x11>
  801e4a:	e9 45 ff ff ff       	jmpq   801d94 <_pipeisclosed+0x11>
}
  801e4f:	48 83 c4 28          	add    $0x28,%rsp
  801e53:	5b                   	pop    %rbx
  801e54:	5d                   	pop    %rbp
  801e55:	c3                   	retq   

0000000000801e56 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801e56:	55                   	push   %rbp
  801e57:	48 89 e5             	mov    %rsp,%rbp
  801e5a:	48 83 ec 30          	sub    $0x30,%rsp
  801e5e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e61:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e68:	48 89 d6             	mov    %rdx,%rsi
  801e6b:	89 c7                	mov    %eax,%edi
  801e6d:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
  801e79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e80:	79 05                	jns    801e87 <pipeisclosed+0x31>
		return r;
  801e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e85:	eb 31                	jmp    801eb8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8b:	48 89 c7             	mov    %rax,%rdi
  801e8e:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	callq  *%rax
  801e9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea6:	48 89 d6             	mov    %rdx,%rsi
  801ea9:	48 89 c7             	mov    %rax,%rdi
  801eac:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
}
  801eb8:	c9                   	leaveq 
  801eb9:	c3                   	retq   

0000000000801eba <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801eba:	55                   	push   %rbp
  801ebb:	48 89 e5             	mov    %rsp,%rbp
  801ebe:	48 83 ec 40          	sub    $0x40,%rsp
  801ec2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801eca:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ece:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed2:	48 89 c7             	mov    %rax,%rdi
  801ed5:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801edc:	00 00 00 
  801edf:	ff d0                	callq  *%rax
  801ee1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801ee5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ee9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801eed:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801ef4:	00 
  801ef5:	e9 92 00 00 00       	jmpq   801f8c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801efa:	eb 41                	jmp    801f3d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801efc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801f01:	74 09                	je     801f0c <devpipe_read+0x52>
				return i;
  801f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f07:	e9 92 00 00 00       	jmpq   801f9e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f14:	48 89 d6             	mov    %rdx,%rsi
  801f17:	48 89 c7             	mov    %rax,%rdi
  801f1a:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
  801f26:	85 c0                	test   %eax,%eax
  801f28:	74 07                	je     801f31 <devpipe_read+0x77>
				return 0;
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	eb 6d                	jmp    801f9e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f31:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  801f38:	00 00 00 
  801f3b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f41:	8b 10                	mov    (%rax),%edx
  801f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f47:	8b 40 04             	mov    0x4(%rax),%eax
  801f4a:	39 c2                	cmp    %eax,%edx
  801f4c:	74 ae                	je     801efc <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f56:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5e:	8b 00                	mov    (%rax),%eax
  801f60:	99                   	cltd   
  801f61:	c1 ea 1b             	shr    $0x1b,%edx
  801f64:	01 d0                	add    %edx,%eax
  801f66:	83 e0 1f             	and    $0x1f,%eax
  801f69:	29 d0                	sub    %edx,%eax
  801f6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6f:	48 98                	cltq   
  801f71:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801f76:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7c:	8b 00                	mov    (%rax),%eax
  801f7e:	8d 50 01             	lea    0x1(%rax),%edx
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f87:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f90:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801f94:	0f 82 60 ff ff ff    	jb     801efa <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801f9e:	c9                   	leaveq 
  801f9f:	c3                   	retq   

0000000000801fa0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fa0:	55                   	push   %rbp
  801fa1:	48 89 e5             	mov    %rsp,%rbp
  801fa4:	48 83 ec 40          	sub    $0x40,%rsp
  801fa8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801fb0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb8:	48 89 c7             	mov    %rax,%rdi
  801fbb:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
  801fc7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fcf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801fd3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801fda:	00 
  801fdb:	e9 8e 00 00 00       	jmpq   80206e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fe0:	eb 31                	jmp    802013 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fe2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fea:	48 89 d6             	mov    %rdx,%rsi
  801fed:	48 89 c7             	mov    %rax,%rdi
  801ff0:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	74 07                	je     802007 <devpipe_write+0x67>
				return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	eb 79                	jmp    802080 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802007:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802017:	8b 40 04             	mov    0x4(%rax),%eax
  80201a:	48 63 d0             	movslq %eax,%rdx
  80201d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802021:	8b 00                	mov    (%rax),%eax
  802023:	48 98                	cltq   
  802025:	48 83 c0 20          	add    $0x20,%rax
  802029:	48 39 c2             	cmp    %rax,%rdx
  80202c:	73 b4                	jae    801fe2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80202e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802032:	8b 40 04             	mov    0x4(%rax),%eax
  802035:	99                   	cltd   
  802036:	c1 ea 1b             	shr    $0x1b,%edx
  802039:	01 d0                	add    %edx,%eax
  80203b:	83 e0 1f             	and    $0x1f,%eax
  80203e:	29 d0                	sub    %edx,%eax
  802040:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802044:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802048:	48 01 ca             	add    %rcx,%rdx
  80204b:	0f b6 0a             	movzbl (%rdx),%ecx
  80204e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802052:	48 98                	cltq   
  802054:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205c:	8b 40 04             	mov    0x4(%rax),%eax
  80205f:	8d 50 01             	lea    0x1(%rax),%edx
  802062:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802066:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802069:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80206e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802072:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802076:	0f 82 64 ff ff ff    	jb     801fe0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80207c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802080:	c9                   	leaveq 
  802081:	c3                   	retq   

0000000000802082 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802082:	55                   	push   %rbp
  802083:	48 89 e5             	mov    %rsp,%rbp
  802086:	48 83 ec 20          	sub    $0x20,%rsp
  80208a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80208e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802096:	48 89 c7             	mov    %rax,%rdi
  802099:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax
  8020a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8020a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ad:	48 be d6 36 80 00 00 	movabs $0x8036d6,%rsi
  8020b4:	00 00 00 
  8020b7:	48 89 c7             	mov    %rax,%rdi
  8020ba:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8020c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ca:	8b 50 04             	mov    0x4(%rax),%edx
  8020cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d1:	8b 00                	mov    (%rax),%eax
  8020d3:	29 c2                	sub    %eax,%edx
  8020d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8020df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8020ea:	00 00 00 
	stat->st_dev = &devpipe;
  8020ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f1:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8020f8:	00 00 00 
  8020fb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802107:	c9                   	leaveq 
  802108:	c3                   	retq   

0000000000802109 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802109:	55                   	push   %rbp
  80210a:	48 89 e5             	mov    %rsp,%rbp
  80210d:	48 83 ec 10          	sub    $0x10,%rsp
  802111:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802119:	48 89 c6             	mov    %rax,%rsi
  80211c:	bf 00 00 00 00       	mov    $0x0,%edi
  802121:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  802128:	00 00 00 
  80212b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80212d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802131:	48 89 c7             	mov    %rax,%rdi
  802134:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
  802140:	48 89 c6             	mov    %rax,%rsi
  802143:	bf 00 00 00 00       	mov    $0x0,%edi
  802148:	48 b8 4b 0c 80 00 00 	movabs $0x800c4b,%rax
  80214f:	00 00 00 
  802152:	ff d0                	callq  *%rax
}
  802154:	c9                   	leaveq 
  802155:	c3                   	retq   

0000000000802156 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
  80215a:	48 83 ec 20          	sub    $0x20,%rsp
  80215e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802161:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802164:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802167:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80216b:	be 01 00 00 00       	mov    $0x1,%esi
  802170:	48 89 c7             	mov    %rax,%rdi
  802173:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
}
  80217f:	c9                   	leaveq 
  802180:	c3                   	retq   

0000000000802181 <getchar>:

int
getchar(void)
{
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
  802185:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802189:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80218d:	ba 01 00 00 00       	mov    $0x1,%edx
  802192:	48 89 c6             	mov    %rax,%rsi
  802195:	bf 00 00 00 00       	mov    $0x0,%edi
  80219a:	48 b8 25 13 80 00 00 	movabs $0x801325,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
  8021a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8021a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ad:	79 05                	jns    8021b4 <getchar+0x33>
		return r;
  8021af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b2:	eb 14                	jmp    8021c8 <getchar+0x47>
	if (r < 1)
  8021b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b8:	7f 07                	jg     8021c1 <getchar+0x40>
		return -E_EOF;
  8021ba:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8021bf:	eb 07                	jmp    8021c8 <getchar+0x47>
	return c;
  8021c1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8021c5:	0f b6 c0             	movzbl %al,%eax
}
  8021c8:	c9                   	leaveq 
  8021c9:	c3                   	retq   

00000000008021ca <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021ca:	55                   	push   %rbp
  8021cb:	48 89 e5             	mov    %rsp,%rbp
  8021ce:	48 83 ec 20          	sub    $0x20,%rsp
  8021d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021dc:	48 89 d6             	mov    %rdx,%rsi
  8021df:	89 c7                	mov    %eax,%edi
  8021e1:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax
  8021ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f4:	79 05                	jns    8021fb <iscons+0x31>
		return r;
  8021f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f9:	eb 1a                	jmp    802215 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8021fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ff:	8b 10                	mov    (%rax),%edx
  802201:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802208:	00 00 00 
  80220b:	8b 00                	mov    (%rax),%eax
  80220d:	39 c2                	cmp    %eax,%edx
  80220f:	0f 94 c0             	sete   %al
  802212:	0f b6 c0             	movzbl %al,%eax
}
  802215:	c9                   	leaveq 
  802216:	c3                   	retq   

0000000000802217 <opencons>:

int
opencons(void)
{
  802217:	55                   	push   %rbp
  802218:	48 89 e5             	mov    %rsp,%rbp
  80221b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80221f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802223:	48 89 c7             	mov    %rax,%rdi
  802226:	48 b8 5b 0e 80 00 00 	movabs $0x800e5b,%rax
  80222d:	00 00 00 
  802230:	ff d0                	callq  *%rax
  802232:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802235:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802239:	79 05                	jns    802240 <opencons+0x29>
		return r;
  80223b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223e:	eb 5b                	jmp    80229b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802244:	ba 07 04 00 00       	mov    $0x407,%edx
  802249:	48 89 c6             	mov    %rax,%rsi
  80224c:	bf 00 00 00 00       	mov    $0x0,%edi
  802251:	48 b8 a0 0b 80 00 00 	movabs $0x800ba0,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802264:	79 05                	jns    80226b <opencons+0x54>
		return r;
  802266:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802269:	eb 30                	jmp    80229b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80226b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  802276:	00 00 00 
  802279:	8b 12                	mov    (%rdx),%edx
  80227b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80227d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802281:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228c:	48 89 c7             	mov    %rax,%rdi
  80228f:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
}
  80229b:	c9                   	leaveq 
  80229c:	c3                   	retq   

000000000080229d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80229d:	55                   	push   %rbp
  80229e:	48 89 e5             	mov    %rsp,%rbp
  8022a1:	48 83 ec 30          	sub    $0x30,%rsp
  8022a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8022b1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022b6:	75 07                	jne    8022bf <devcons_read+0x22>
		return 0;
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	eb 4b                	jmp    80230a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8022bf:	eb 0c                	jmp    8022cd <devcons_read+0x30>
		sys_yield();
  8022c1:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022cd:	48 b8 a2 0a 80 00 00 	movabs $0x800aa2,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e0:	74 df                	je     8022c1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8022e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e6:	79 05                	jns    8022ed <devcons_read+0x50>
		return c;
  8022e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022eb:	eb 1d                	jmp    80230a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8022ed:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8022f1:	75 07                	jne    8022fa <devcons_read+0x5d>
		return 0;
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	eb 10                	jmp    80230a <devcons_read+0x6d>
	*(char*)vbuf = c;
  8022fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fd:	89 c2                	mov    %eax,%edx
  8022ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802303:	88 10                	mov    %dl,(%rax)
	return 1;
  802305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80230a:	c9                   	leaveq 
  80230b:	c3                   	retq   

000000000080230c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802317:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80231e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802325:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80232c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802333:	eb 76                	jmp    8023ab <devcons_write+0x9f>
		m = n - tot;
  802335:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80233c:	89 c2                	mov    %eax,%edx
  80233e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802341:	29 c2                	sub    %eax,%edx
  802343:	89 d0                	mov    %edx,%eax
  802345:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802348:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80234b:	83 f8 7f             	cmp    $0x7f,%eax
  80234e:	76 07                	jbe    802357 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802350:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802357:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235a:	48 63 d0             	movslq %eax,%rdx
  80235d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802360:	48 63 c8             	movslq %eax,%rcx
  802363:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80236a:	48 01 c1             	add    %rax,%rcx
  80236d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802374:	48 89 ce             	mov    %rcx,%rsi
  802377:	48 89 c7             	mov    %rax,%rdi
  80237a:	48 b8 95 05 80 00 00 	movabs $0x800595,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802386:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802389:	48 63 d0             	movslq %eax,%rdx
  80238c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	48 89 c7             	mov    %rax,%rdi
  802399:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  8023a0:	00 00 00 
  8023a3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	48 98                	cltq   
  8023b0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8023b7:	0f 82 78 ff ff ff    	jb     802335 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8023bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c0:	c9                   	leaveq 
  8023c1:	c3                   	retq   

00000000008023c2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8023c2:	55                   	push   %rbp
  8023c3:	48 89 e5             	mov    %rsp,%rbp
  8023c6:	48 83 ec 08          	sub    $0x8,%rsp
  8023ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 10          	sub    $0x10,%rsp
  8023dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8023e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e9:	48 be e2 36 80 00 00 	movabs $0x8036e2,%rsi
  8023f0:	00 00 00 
  8023f3:	48 89 c7             	mov    %rax,%rdi
  8023f6:	48 b8 71 02 80 00 00 	movabs $0x800271,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
	return 0;
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802407:	c9                   	leaveq 
  802408:	c3                   	retq   

0000000000802409 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	53                   	push   %rbx
  80240e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802415:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80241c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802422:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802429:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802430:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802437:	84 c0                	test   %al,%al
  802439:	74 23                	je     80245e <_panic+0x55>
  80243b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802442:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802446:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80244a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80244e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802452:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802456:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80245a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80245e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802465:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80246c:	00 00 00 
  80246f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802476:	00 00 00 
  802479:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80247d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802484:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80248b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802492:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802499:	00 00 00 
  80249c:	48 8b 18             	mov    (%rax),%rbx
  80249f:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	callq  *%rax
  8024ab:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8024b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8024b8:	41 89 c8             	mov    %ecx,%r8d
  8024bb:	48 89 d1             	mov    %rdx,%rcx
  8024be:	48 89 da             	mov    %rbx,%rdx
  8024c1:	89 c6                	mov    %eax,%esi
  8024c3:	48 bf f0 36 80 00 00 	movabs $0x8036f0,%rdi
  8024ca:	00 00 00 
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d2:	49 b9 42 26 80 00 00 	movabs $0x802642,%r9
  8024d9:	00 00 00 
  8024dc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024df:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8024e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8024ed:	48 89 d6             	mov    %rdx,%rsi
  8024f0:	48 89 c7             	mov    %rax,%rdi
  8024f3:	48 b8 96 25 80 00 00 	movabs $0x802596,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
	cprintf("\n");
  8024ff:	48 bf 13 37 80 00 00 	movabs $0x803713,%rdi
  802506:	00 00 00 
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	48 ba 42 26 80 00 00 	movabs $0x802642,%rdx
  802515:	00 00 00 
  802518:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80251a:	cc                   	int3   
  80251b:	eb fd                	jmp    80251a <_panic+0x111>

000000000080251d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80251d:	55                   	push   %rbp
  80251e:	48 89 e5             	mov    %rsp,%rbp
  802521:	48 83 ec 10          	sub    $0x10,%rsp
  802525:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802528:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80252c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802530:	8b 00                	mov    (%rax),%eax
  802532:	8d 48 01             	lea    0x1(%rax),%ecx
  802535:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802539:	89 0a                	mov    %ecx,(%rdx)
  80253b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80253e:	89 d1                	mov    %edx,%ecx
  802540:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802544:	48 98                	cltq   
  802546:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80254a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254e:	8b 00                	mov    (%rax),%eax
  802550:	3d ff 00 00 00       	cmp    $0xff,%eax
  802555:	75 2c                	jne    802583 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  802557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255b:	8b 00                	mov    (%rax),%eax
  80255d:	48 98                	cltq   
  80255f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802563:	48 83 c2 08          	add    $0x8,%rdx
  802567:	48 89 c6             	mov    %rax,%rsi
  80256a:	48 89 d7             	mov    %rdx,%rdi
  80256d:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
		b->idx = 0;
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802587:	8b 40 04             	mov    0x4(%rax),%eax
  80258a:	8d 50 01             	lea    0x1(%rax),%edx
  80258d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802591:	89 50 04             	mov    %edx,0x4(%rax)
}
  802594:	c9                   	leaveq 
  802595:	c3                   	retq   

0000000000802596 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802596:	55                   	push   %rbp
  802597:	48 89 e5             	mov    %rsp,%rbp
  80259a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8025a1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8025a8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8025af:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8025b6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8025bd:	48 8b 0a             	mov    (%rdx),%rcx
  8025c0:	48 89 08             	mov    %rcx,(%rax)
  8025c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8025c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8025cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8025cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8025d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8025da:	00 00 00 
	b.cnt = 0;
  8025dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8025e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8025e7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8025ee:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8025f5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8025fc:	48 89 c6             	mov    %rax,%rsi
  8025ff:	48 bf 1d 25 80 00 00 	movabs $0x80251d,%rdi
  802606:	00 00 00 
  802609:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  802615:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80261b:	48 98                	cltq   
  80261d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802624:	48 83 c2 08          	add    $0x8,%rdx
  802628:	48 89 c6             	mov    %rax,%rsi
  80262b:	48 89 d7             	mov    %rdx,%rdi
  80262e:	48 b8 58 0a 80 00 00 	movabs $0x800a58,%rax
  802635:	00 00 00 
  802638:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80263a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802640:	c9                   	leaveq 
  802641:	c3                   	retq   

0000000000802642 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802642:	55                   	push   %rbp
  802643:	48 89 e5             	mov    %rsp,%rbp
  802646:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80264d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802654:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80265b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802662:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802669:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802670:	84 c0                	test   %al,%al
  802672:	74 20                	je     802694 <cprintf+0x52>
  802674:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802678:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80267c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802680:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802684:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802688:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80268c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802690:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802694:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80269b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8026a2:	00 00 00 
  8026a5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8026ac:	00 00 00 
  8026af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8026b3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8026ba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8026c1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8026c8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8026cf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8026d6:	48 8b 0a             	mov    (%rdx),%rcx
  8026d9:	48 89 08             	mov    %rcx,(%rax)
  8026dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8026e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8026e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8026e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8026ec:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8026f3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8026fa:	48 89 d6             	mov    %rdx,%rsi
  8026fd:	48 89 c7             	mov    %rax,%rdi
  802700:	48 b8 96 25 80 00 00 	movabs $0x802596,%rax
  802707:	00 00 00 
  80270a:	ff d0                	callq  *%rax
  80270c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  802712:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802718:	c9                   	leaveq 
  802719:	c3                   	retq   

000000000080271a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80271a:	55                   	push   %rbp
  80271b:	48 89 e5             	mov    %rsp,%rbp
  80271e:	53                   	push   %rbx
  80271f:	48 83 ec 38          	sub    $0x38,%rsp
  802723:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802727:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80272b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80272f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802732:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802736:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80273a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80273d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802741:	77 3b                	ja     80277e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802743:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802746:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80274a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80274d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802751:	ba 00 00 00 00       	mov    $0x0,%edx
  802756:	48 f7 f3             	div    %rbx
  802759:	48 89 c2             	mov    %rax,%rdx
  80275c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80275f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802762:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276a:	41 89 f9             	mov    %edi,%r9d
  80276d:	48 89 c7             	mov    %rax,%rdi
  802770:	48 b8 1a 27 80 00 00 	movabs $0x80271a,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
  80277c:	eb 1e                	jmp    80279c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80277e:	eb 12                	jmp    802792 <printnum+0x78>
			putch(padc, putdat);
  802780:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802784:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278b:	48 89 ce             	mov    %rcx,%rsi
  80278e:	89 d7                	mov    %edx,%edi
  802790:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802792:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802796:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80279a:	7f e4                	jg     802780 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80279c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80279f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a8:	48 f7 f1             	div    %rcx
  8027ab:	48 89 d0             	mov    %rdx,%rax
  8027ae:	48 ba e8 38 80 00 00 	movabs $0x8038e8,%rdx
  8027b5:	00 00 00 
  8027b8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8027bc:	0f be d0             	movsbl %al,%edx
  8027bf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8027c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c7:	48 89 ce             	mov    %rcx,%rsi
  8027ca:	89 d7                	mov    %edx,%edi
  8027cc:	ff d0                	callq  *%rax
}
  8027ce:	48 83 c4 38          	add    $0x38,%rsp
  8027d2:	5b                   	pop    %rbx
  8027d3:	5d                   	pop    %rbp
  8027d4:	c3                   	retq   

00000000008027d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8027d5:	55                   	push   %rbp
  8027d6:	48 89 e5             	mov    %rsp,%rbp
  8027d9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8027dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8027e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8027e8:	7e 52                	jle    80283c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8027ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ee:	8b 00                	mov    (%rax),%eax
  8027f0:	83 f8 30             	cmp    $0x30,%eax
  8027f3:	73 24                	jae    802819 <getuint+0x44>
  8027f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	8b 00                	mov    (%rax),%eax
  802803:	89 c0                	mov    %eax,%eax
  802805:	48 01 d0             	add    %rdx,%rax
  802808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80280c:	8b 12                	mov    (%rdx),%edx
  80280e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802815:	89 0a                	mov    %ecx,(%rdx)
  802817:	eb 17                	jmp    802830 <getuint+0x5b>
  802819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802821:	48 89 d0             	mov    %rdx,%rax
  802824:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802828:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80282c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802830:	48 8b 00             	mov    (%rax),%rax
  802833:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802837:	e9 a3 00 00 00       	jmpq   8028df <getuint+0x10a>
	else if (lflag)
  80283c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802840:	74 4f                	je     802891 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802846:	8b 00                	mov    (%rax),%eax
  802848:	83 f8 30             	cmp    $0x30,%eax
  80284b:	73 24                	jae    802871 <getuint+0x9c>
  80284d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802851:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802859:	8b 00                	mov    (%rax),%eax
  80285b:	89 c0                	mov    %eax,%eax
  80285d:	48 01 d0             	add    %rdx,%rax
  802860:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802864:	8b 12                	mov    (%rdx),%edx
  802866:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802869:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80286d:	89 0a                	mov    %ecx,(%rdx)
  80286f:	eb 17                	jmp    802888 <getuint+0xb3>
  802871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802875:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802879:	48 89 d0             	mov    %rdx,%rax
  80287c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802880:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802884:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802888:	48 8b 00             	mov    (%rax),%rax
  80288b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80288f:	eb 4e                	jmp    8028df <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802895:	8b 00                	mov    (%rax),%eax
  802897:	83 f8 30             	cmp    $0x30,%eax
  80289a:	73 24                	jae    8028c0 <getuint+0xeb>
  80289c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8028a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a8:	8b 00                	mov    (%rax),%eax
  8028aa:	89 c0                	mov    %eax,%eax
  8028ac:	48 01 d0             	add    %rdx,%rax
  8028af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b3:	8b 12                	mov    (%rdx),%edx
  8028b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8028b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028bc:	89 0a                	mov    %ecx,(%rdx)
  8028be:	eb 17                	jmp    8028d7 <getuint+0x102>
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8028c8:	48 89 d0             	mov    %rdx,%rax
  8028cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8028cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8028d7:	8b 00                	mov    (%rax),%eax
  8028d9:	89 c0                	mov    %eax,%eax
  8028db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8028df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8028e3:	c9                   	leaveq 
  8028e4:	c3                   	retq   

00000000008028e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8028ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8028f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8028f8:	7e 52                	jle    80294c <getint+0x67>
		x=va_arg(*ap, long long);
  8028fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fe:	8b 00                	mov    (%rax),%eax
  802900:	83 f8 30             	cmp    $0x30,%eax
  802903:	73 24                	jae    802929 <getint+0x44>
  802905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802909:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80290d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802911:	8b 00                	mov    (%rax),%eax
  802913:	89 c0                	mov    %eax,%eax
  802915:	48 01 d0             	add    %rdx,%rax
  802918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80291c:	8b 12                	mov    (%rdx),%edx
  80291e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802925:	89 0a                	mov    %ecx,(%rdx)
  802927:	eb 17                	jmp    802940 <getint+0x5b>
  802929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802931:	48 89 d0             	mov    %rdx,%rax
  802934:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802938:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80293c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802940:	48 8b 00             	mov    (%rax),%rax
  802943:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802947:	e9 a3 00 00 00       	jmpq   8029ef <getint+0x10a>
	else if (lflag)
  80294c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802950:	74 4f                	je     8029a1 <getint+0xbc>
		x=va_arg(*ap, long);
  802952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802956:	8b 00                	mov    (%rax),%eax
  802958:	83 f8 30             	cmp    $0x30,%eax
  80295b:	73 24                	jae    802981 <getint+0x9c>
  80295d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802961:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802969:	8b 00                	mov    (%rax),%eax
  80296b:	89 c0                	mov    %eax,%eax
  80296d:	48 01 d0             	add    %rdx,%rax
  802970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802974:	8b 12                	mov    (%rdx),%edx
  802976:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80297d:	89 0a                	mov    %ecx,(%rdx)
  80297f:	eb 17                	jmp    802998 <getint+0xb3>
  802981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802985:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802989:	48 89 d0             	mov    %rdx,%rax
  80298c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802990:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802994:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802998:	48 8b 00             	mov    (%rax),%rax
  80299b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80299f:	eb 4e                	jmp    8029ef <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8029a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a5:	8b 00                	mov    (%rax),%eax
  8029a7:	83 f8 30             	cmp    $0x30,%eax
  8029aa:	73 24                	jae    8029d0 <getint+0xeb>
  8029ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8029b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b8:	8b 00                	mov    (%rax),%eax
  8029ba:	89 c0                	mov    %eax,%eax
  8029bc:	48 01 d0             	add    %rdx,%rax
  8029bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029c3:	8b 12                	mov    (%rdx),%edx
  8029c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8029c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029cc:	89 0a                	mov    %ecx,(%rdx)
  8029ce:	eb 17                	jmp    8029e7 <getint+0x102>
  8029d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8029d8:	48 89 d0             	mov    %rdx,%rax
  8029db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8029df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8029e7:	8b 00                	mov    (%rax),%eax
  8029e9:	48 98                	cltq   
  8029eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8029ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	41 54                	push   %r12
  8029fb:	53                   	push   %rbx
  8029fc:	48 83 ec 60          	sub    $0x60,%rsp
  802a00:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802a04:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802a08:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802a0c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802a10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802a14:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802a18:	48 8b 0a             	mov    (%rdx),%rcx
  802a1b:	48 89 08             	mov    %rcx,(%rax)
  802a1e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a22:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a26:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a2a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  802a2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a32:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a36:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802a3a:	0f b6 00             	movzbl (%rax),%eax
  802a3d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  802a40:	eb 29                	jmp    802a6b <vprintfmt+0x76>
			if (ch == '\0')
  802a42:	85 db                	test   %ebx,%ebx
  802a44:	0f 84 ad 06 00 00    	je     8030f7 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  802a4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802a4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802a52:	48 89 d6             	mov    %rdx,%rsi
  802a55:	89 df                	mov    %ebx,%edi
  802a57:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  802a59:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802a5d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a61:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802a65:	0f b6 00             	movzbl (%rax),%eax
  802a68:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  802a6b:	83 fb 25             	cmp    $0x25,%ebx
  802a6e:	74 05                	je     802a75 <vprintfmt+0x80>
  802a70:	83 fb 1b             	cmp    $0x1b,%ebx
  802a73:	75 cd                	jne    802a42 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  802a75:	83 fb 1b             	cmp    $0x1b,%ebx
  802a78:	0f 85 ae 01 00 00    	jne    802c2c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  802a7e:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802a85:	00 00 00 
  802a88:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  802a8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802a92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802a96:	48 89 d6             	mov    %rdx,%rsi
  802a99:	89 df                	mov    %ebx,%edi
  802a9b:	ff d0                	callq  *%rax
			putch('[', putdat);
  802a9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802aa1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802aa5:	48 89 d6             	mov    %rdx,%rsi
  802aa8:	bf 5b 00 00 00       	mov    $0x5b,%edi
  802aad:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  802aaf:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  802ab5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802aba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802abe:	0f b6 00             	movzbl (%rax),%eax
  802ac1:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  802ac4:	eb 32                	jmp    802af8 <vprintfmt+0x103>
					putch(ch, putdat);
  802ac6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802aca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ace:	48 89 d6             	mov    %rdx,%rsi
  802ad1:	89 df                	mov    %ebx,%edi
  802ad3:	ff d0                	callq  *%rax
					esc_color *= 10;
  802ad5:	44 89 e0             	mov    %r12d,%eax
  802ad8:	c1 e0 02             	shl    $0x2,%eax
  802adb:	44 01 e0             	add    %r12d,%eax
  802ade:	01 c0                	add    %eax,%eax
  802ae0:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  802ae3:	8d 43 d0             	lea    -0x30(%rbx),%eax
  802ae6:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  802ae9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802aee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802af2:	0f b6 00             	movzbl (%rax),%eax
  802af5:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  802af8:	83 fb 3b             	cmp    $0x3b,%ebx
  802afb:	74 05                	je     802b02 <vprintfmt+0x10d>
  802afd:	83 fb 6d             	cmp    $0x6d,%ebx
  802b00:	75 c4                	jne    802ac6 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  802b02:	45 85 e4             	test   %r12d,%r12d
  802b05:	75 15                	jne    802b1c <vprintfmt+0x127>
					color_flag = 0x07;
  802b07:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b0e:	00 00 00 
  802b11:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  802b17:	e9 dc 00 00 00       	jmpq   802bf8 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  802b1c:	41 83 fc 1d          	cmp    $0x1d,%r12d
  802b20:	7e 69                	jle    802b8b <vprintfmt+0x196>
  802b22:	41 83 fc 25          	cmp    $0x25,%r12d
  802b26:	7f 63                	jg     802b8b <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  802b28:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b2f:	00 00 00 
  802b32:	8b 00                	mov    (%rax),%eax
  802b34:	25 f8 00 00 00       	and    $0xf8,%eax
  802b39:	89 c2                	mov    %eax,%edx
  802b3b:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b42:	00 00 00 
  802b45:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  802b47:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  802b4b:	44 89 e0             	mov    %r12d,%eax
  802b4e:	83 e0 04             	and    $0x4,%eax
  802b51:	c1 f8 02             	sar    $0x2,%eax
  802b54:	89 c2                	mov    %eax,%edx
  802b56:	44 89 e0             	mov    %r12d,%eax
  802b59:	83 e0 02             	and    $0x2,%eax
  802b5c:	09 c2                	or     %eax,%edx
  802b5e:	44 89 e0             	mov    %r12d,%eax
  802b61:	83 e0 01             	and    $0x1,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	09 c2                	or     %eax,%edx
  802b69:	41 89 d4             	mov    %edx,%r12d
  802b6c:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b73:	00 00 00 
  802b76:	8b 00                	mov    (%rax),%eax
  802b78:	44 89 e2             	mov    %r12d,%edx
  802b7b:	09 c2                	or     %eax,%edx
  802b7d:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b84:	00 00 00 
  802b87:	89 10                	mov    %edx,(%rax)
  802b89:	eb 6d                	jmp    802bf8 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  802b8b:	41 83 fc 27          	cmp    $0x27,%r12d
  802b8f:	7e 67                	jle    802bf8 <vprintfmt+0x203>
  802b91:	41 83 fc 2f          	cmp    $0x2f,%r12d
  802b95:	7f 61                	jg     802bf8 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  802b97:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802b9e:	00 00 00 
  802ba1:	8b 00                	mov    (%rax),%eax
  802ba3:	25 8f 00 00 00       	and    $0x8f,%eax
  802ba8:	89 c2                	mov    %eax,%edx
  802baa:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802bb1:	00 00 00 
  802bb4:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  802bb6:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  802bba:	44 89 e0             	mov    %r12d,%eax
  802bbd:	83 e0 04             	and    $0x4,%eax
  802bc0:	c1 f8 02             	sar    $0x2,%eax
  802bc3:	89 c2                	mov    %eax,%edx
  802bc5:	44 89 e0             	mov    %r12d,%eax
  802bc8:	83 e0 02             	and    $0x2,%eax
  802bcb:	09 c2                	or     %eax,%edx
  802bcd:	44 89 e0             	mov    %r12d,%eax
  802bd0:	83 e0 01             	and    $0x1,%eax
  802bd3:	c1 e0 06             	shl    $0x6,%eax
  802bd6:	09 c2                	or     %eax,%edx
  802bd8:	41 89 d4             	mov    %edx,%r12d
  802bdb:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802be2:	00 00 00 
  802be5:	8b 00                	mov    (%rax),%eax
  802be7:	44 89 e2             	mov    %r12d,%edx
  802bea:	09 c2                	or     %eax,%edx
  802bec:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802bf3:	00 00 00 
  802bf6:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  802bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802c00:	48 89 d6             	mov    %rdx,%rsi
  802c03:	89 df                	mov    %ebx,%edi
  802c05:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  802c07:	83 fb 6d             	cmp    $0x6d,%ebx
  802c0a:	75 1b                	jne    802c27 <vprintfmt+0x232>
					fmt ++;
  802c0c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  802c11:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  802c12:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802c19:	00 00 00 
  802c1c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  802c22:	e9 cb 04 00 00       	jmpq   8030f2 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  802c27:	e9 83 fe ff ff       	jmpq   802aaf <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  802c2c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802c30:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802c37:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802c3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802c45:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802c4c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802c50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c54:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802c58:	0f b6 00             	movzbl (%rax),%eax
  802c5b:	0f b6 d8             	movzbl %al,%ebx
  802c5e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802c61:	83 f8 55             	cmp    $0x55,%eax
  802c64:	0f 87 5a 04 00 00    	ja     8030c4 <vprintfmt+0x6cf>
  802c6a:	89 c0                	mov    %eax,%eax
  802c6c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802c73:	00 
  802c74:	48 b8 10 39 80 00 00 	movabs $0x803910,%rax
  802c7b:	00 00 00 
  802c7e:	48 01 d0             	add    %rdx,%rax
  802c81:	48 8b 00             	mov    (%rax),%rax
  802c84:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802c86:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802c8a:	eb c0                	jmp    802c4c <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802c8c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802c90:	eb ba                	jmp    802c4c <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802c92:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802c99:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802c9c:	89 d0                	mov    %edx,%eax
  802c9e:	c1 e0 02             	shl    $0x2,%eax
  802ca1:	01 d0                	add    %edx,%eax
  802ca3:	01 c0                	add    %eax,%eax
  802ca5:	01 d8                	add    %ebx,%eax
  802ca7:	83 e8 30             	sub    $0x30,%eax
  802caa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802cad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802cb1:	0f b6 00             	movzbl (%rax),%eax
  802cb4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802cb7:	83 fb 2f             	cmp    $0x2f,%ebx
  802cba:	7e 0c                	jle    802cc8 <vprintfmt+0x2d3>
  802cbc:	83 fb 39             	cmp    $0x39,%ebx
  802cbf:	7f 07                	jg     802cc8 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802cc1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802cc6:	eb d1                	jmp    802c99 <vprintfmt+0x2a4>
			goto process_precision;
  802cc8:	eb 58                	jmp    802d22 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  802cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ccd:	83 f8 30             	cmp    $0x30,%eax
  802cd0:	73 17                	jae    802ce9 <vprintfmt+0x2f4>
  802cd2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802cd9:	89 c0                	mov    %eax,%eax
  802cdb:	48 01 d0             	add    %rdx,%rax
  802cde:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ce1:	83 c2 08             	add    $0x8,%edx
  802ce4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ce7:	eb 0f                	jmp    802cf8 <vprintfmt+0x303>
  802ce9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ced:	48 89 d0             	mov    %rdx,%rax
  802cf0:	48 83 c2 08          	add    $0x8,%rdx
  802cf4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802cf8:	8b 00                	mov    (%rax),%eax
  802cfa:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802cfd:	eb 23                	jmp    802d22 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  802cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d03:	79 0c                	jns    802d11 <vprintfmt+0x31c>
				width = 0;
  802d05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802d0c:	e9 3b ff ff ff       	jmpq   802c4c <vprintfmt+0x257>
  802d11:	e9 36 ff ff ff       	jmpq   802c4c <vprintfmt+0x257>

		case '#':
			altflag = 1;
  802d16:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802d1d:	e9 2a ff ff ff       	jmpq   802c4c <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  802d22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802d26:	79 12                	jns    802d3a <vprintfmt+0x345>
				width = precision, precision = -1;
  802d28:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d2b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802d2e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802d35:	e9 12 ff ff ff       	jmpq   802c4c <vprintfmt+0x257>
  802d3a:	e9 0d ff ff ff       	jmpq   802c4c <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802d3f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802d43:	e9 04 ff ff ff       	jmpq   802c4c <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802d48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d4b:	83 f8 30             	cmp    $0x30,%eax
  802d4e:	73 17                	jae    802d67 <vprintfmt+0x372>
  802d50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d57:	89 c0                	mov    %eax,%eax
  802d59:	48 01 d0             	add    %rdx,%rax
  802d5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802d5f:	83 c2 08             	add    $0x8,%edx
  802d62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802d65:	eb 0f                	jmp    802d76 <vprintfmt+0x381>
  802d67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d6b:	48 89 d0             	mov    %rdx,%rax
  802d6e:	48 83 c2 08          	add    $0x8,%rdx
  802d72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802d76:	8b 10                	mov    (%rax),%edx
  802d78:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802d7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d80:	48 89 ce             	mov    %rcx,%rsi
  802d83:	89 d7                	mov    %edx,%edi
  802d85:	ff d0                	callq  *%rax
			break;
  802d87:	e9 66 03 00 00       	jmpq   8030f2 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802d8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d8f:	83 f8 30             	cmp    $0x30,%eax
  802d92:	73 17                	jae    802dab <vprintfmt+0x3b6>
  802d94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d9b:	89 c0                	mov    %eax,%eax
  802d9d:	48 01 d0             	add    %rdx,%rax
  802da0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802da3:	83 c2 08             	add    $0x8,%edx
  802da6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802da9:	eb 0f                	jmp    802dba <vprintfmt+0x3c5>
  802dab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802daf:	48 89 d0             	mov    %rdx,%rax
  802db2:	48 83 c2 08          	add    $0x8,%rdx
  802db6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802dba:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802dbc:	85 db                	test   %ebx,%ebx
  802dbe:	79 02                	jns    802dc2 <vprintfmt+0x3cd>
				err = -err;
  802dc0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802dc2:	83 fb 10             	cmp    $0x10,%ebx
  802dc5:	7f 16                	jg     802ddd <vprintfmt+0x3e8>
  802dc7:	48 b8 60 38 80 00 00 	movabs $0x803860,%rax
  802dce:	00 00 00 
  802dd1:	48 63 d3             	movslq %ebx,%rdx
  802dd4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802dd8:	4d 85 e4             	test   %r12,%r12
  802ddb:	75 2e                	jne    802e0b <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  802ddd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802de1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802de5:	89 d9                	mov    %ebx,%ecx
  802de7:	48 ba f9 38 80 00 00 	movabs $0x8038f9,%rdx
  802dee:	00 00 00 
  802df1:	48 89 c7             	mov    %rax,%rdi
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	49 b8 00 31 80 00 00 	movabs $0x803100,%r8
  802e00:	00 00 00 
  802e03:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802e06:	e9 e7 02 00 00       	jmpq   8030f2 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802e0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802e0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e13:	4c 89 e1             	mov    %r12,%rcx
  802e16:	48 ba 02 39 80 00 00 	movabs $0x803902,%rdx
  802e1d:	00 00 00 
  802e20:	48 89 c7             	mov    %rax,%rdi
  802e23:	b8 00 00 00 00       	mov    $0x0,%eax
  802e28:	49 b8 00 31 80 00 00 	movabs $0x803100,%r8
  802e2f:	00 00 00 
  802e32:	41 ff d0             	callq  *%r8
			break;
  802e35:	e9 b8 02 00 00       	jmpq   8030f2 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802e3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e3d:	83 f8 30             	cmp    $0x30,%eax
  802e40:	73 17                	jae    802e59 <vprintfmt+0x464>
  802e42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e49:	89 c0                	mov    %eax,%eax
  802e4b:	48 01 d0             	add    %rdx,%rax
  802e4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e51:	83 c2 08             	add    $0x8,%edx
  802e54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e57:	eb 0f                	jmp    802e68 <vprintfmt+0x473>
  802e59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e5d:	48 89 d0             	mov    %rdx,%rax
  802e60:	48 83 c2 08          	add    $0x8,%rdx
  802e64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e68:	4c 8b 20             	mov    (%rax),%r12
  802e6b:	4d 85 e4             	test   %r12,%r12
  802e6e:	75 0a                	jne    802e7a <vprintfmt+0x485>
				p = "(null)";
  802e70:	49 bc 05 39 80 00 00 	movabs $0x803905,%r12
  802e77:	00 00 00 
			if (width > 0 && padc != '-')
  802e7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e7e:	7e 3f                	jle    802ebf <vprintfmt+0x4ca>
  802e80:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802e84:	74 39                	je     802ebf <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  802e86:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e89:	48 98                	cltq   
  802e8b:	48 89 c6             	mov    %rax,%rsi
  802e8e:	4c 89 e7             	mov    %r12,%rdi
  802e91:	48 b8 33 02 80 00 00 	movabs $0x800233,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
  802e9d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802ea0:	eb 17                	jmp    802eb9 <vprintfmt+0x4c4>
					putch(padc, putdat);
  802ea2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802ea6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802eaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eae:	48 89 ce             	mov    %rcx,%rsi
  802eb1:	89 d7                	mov    %edx,%edi
  802eb3:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802eb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802eb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802ebd:	7f e3                	jg     802ea2 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ebf:	eb 37                	jmp    802ef8 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  802ec1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802ec5:	74 1e                	je     802ee5 <vprintfmt+0x4f0>
  802ec7:	83 fb 1f             	cmp    $0x1f,%ebx
  802eca:	7e 05                	jle    802ed1 <vprintfmt+0x4dc>
  802ecc:	83 fb 7e             	cmp    $0x7e,%ebx
  802ecf:	7e 14                	jle    802ee5 <vprintfmt+0x4f0>
					putch('?', putdat);
  802ed1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ed5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ed9:	48 89 d6             	mov    %rdx,%rsi
  802edc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802ee1:	ff d0                	callq  *%rax
  802ee3:	eb 0f                	jmp    802ef4 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  802ee5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802ee9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802eed:	48 89 d6             	mov    %rdx,%rsi
  802ef0:	89 df                	mov    %ebx,%edi
  802ef2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ef4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802ef8:	4c 89 e0             	mov    %r12,%rax
  802efb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802eff:	0f b6 00             	movzbl (%rax),%eax
  802f02:	0f be d8             	movsbl %al,%ebx
  802f05:	85 db                	test   %ebx,%ebx
  802f07:	74 10                	je     802f19 <vprintfmt+0x524>
  802f09:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f0d:	78 b2                	js     802ec1 <vprintfmt+0x4cc>
  802f0f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802f13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802f17:	79 a8                	jns    802ec1 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802f19:	eb 16                	jmp    802f31 <vprintfmt+0x53c>
				putch(' ', putdat);
  802f1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f23:	48 89 d6             	mov    %rdx,%rsi
  802f26:	bf 20 00 00 00       	mov    $0x20,%edi
  802f2b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802f2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802f31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f35:	7f e4                	jg     802f1b <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  802f37:	e9 b6 01 00 00       	jmpq   8030f2 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802f3c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f40:	be 03 00 00 00       	mov    $0x3,%esi
  802f45:	48 89 c7             	mov    %rax,%rdi
  802f48:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
  802f54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5c:	48 85 c0             	test   %rax,%rax
  802f5f:	79 1d                	jns    802f7e <vprintfmt+0x589>
				putch('-', putdat);
  802f61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802f65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f69:	48 89 d6             	mov    %rdx,%rsi
  802f6c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802f71:	ff d0                	callq  *%rax
				num = -(long long) num;
  802f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f77:	48 f7 d8             	neg    %rax
  802f7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  802f7e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802f85:	e9 fb 00 00 00       	jmpq   803085 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802f8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802f8e:	be 03 00 00 00       	mov    $0x3,%esi
  802f93:	48 89 c7             	mov    %rax,%rdi
  802f96:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
  802fa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802fa6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802fad:	e9 d3 00 00 00       	jmpq   803085 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  802fb2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802fb6:	be 03 00 00 00       	mov    $0x3,%esi
  802fbb:	48 89 c7             	mov    %rax,%rdi
  802fbe:	48 b8 e5 28 80 00 00 	movabs $0x8028e5,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd2:	48 85 c0             	test   %rax,%rax
  802fd5:	79 1d                	jns    802ff4 <vprintfmt+0x5ff>
				putch('-', putdat);
  802fd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fdf:	48 89 d6             	mov    %rdx,%rsi
  802fe2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802fe7:	ff d0                	callq  *%rax
				num = -(long long) num;
  802fe9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fed:	48 f7 d8             	neg    %rax
  802ff0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  802ff4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802ffb:	e9 85 00 00 00       	jmpq   803085 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  803000:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803004:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803008:	48 89 d6             	mov    %rdx,%rsi
  80300b:	bf 30 00 00 00       	mov    $0x30,%edi
  803010:	ff d0                	callq  *%rax
			putch('x', putdat);
  803012:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803016:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80301a:	48 89 d6             	mov    %rdx,%rsi
  80301d:	bf 78 00 00 00       	mov    $0x78,%edi
  803022:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803024:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803027:	83 f8 30             	cmp    $0x30,%eax
  80302a:	73 17                	jae    803043 <vprintfmt+0x64e>
  80302c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803030:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803033:	89 c0                	mov    %eax,%eax
  803035:	48 01 d0             	add    %rdx,%rax
  803038:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80303b:	83 c2 08             	add    $0x8,%edx
  80303e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803041:	eb 0f                	jmp    803052 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  803043:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803047:	48 89 d0             	mov    %rdx,%rax
  80304a:	48 83 c2 08          	add    $0x8,%rdx
  80304e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803052:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803055:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803059:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803060:	eb 23                	jmp    803085 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803062:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803066:	be 03 00 00 00       	mov    $0x3,%esi
  80306b:	48 89 c7             	mov    %rax,%rdi
  80306e:	48 b8 d5 27 80 00 00 	movabs $0x8027d5,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
  80307a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80307e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803085:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80308a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80308d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803090:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803094:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803098:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80309c:	45 89 c1             	mov    %r8d,%r9d
  80309f:	41 89 f8             	mov    %edi,%r8d
  8030a2:	48 89 c7             	mov    %rax,%rdi
  8030a5:	48 b8 1a 27 80 00 00 	movabs $0x80271a,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
			break;
  8030b1:	eb 3f                	jmp    8030f2 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8030b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030bb:	48 89 d6             	mov    %rdx,%rsi
  8030be:	89 df                	mov    %ebx,%edi
  8030c0:	ff d0                	callq  *%rax
			break;
  8030c2:	eb 2e                	jmp    8030f2 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8030c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030cc:	48 89 d6             	mov    %rdx,%rsi
  8030cf:	bf 25 00 00 00       	mov    $0x25,%edi
  8030d4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8030d6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8030db:	eb 05                	jmp    8030e2 <vprintfmt+0x6ed>
  8030dd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8030e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8030e6:	48 83 e8 01          	sub    $0x1,%rax
  8030ea:	0f b6 00             	movzbl (%rax),%eax
  8030ed:	3c 25                	cmp    $0x25,%al
  8030ef:	75 ec                	jne    8030dd <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8030f1:	90                   	nop
		}
	}
  8030f2:	e9 37 f9 ff ff       	jmpq   802a2e <vprintfmt+0x39>
    va_end(aq);
}
  8030f7:	48 83 c4 60          	add    $0x60,%rsp
  8030fb:	5b                   	pop    %rbx
  8030fc:	41 5c                	pop    %r12
  8030fe:	5d                   	pop    %rbp
  8030ff:	c3                   	retq   

0000000000803100 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80310b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803112:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803119:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803120:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803127:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80312e:	84 c0                	test   %al,%al
  803130:	74 20                	je     803152 <printfmt+0x52>
  803132:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803136:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80313a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80313e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803142:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803146:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80314a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80314e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803152:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803159:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803160:	00 00 00 
  803163:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80316a:	00 00 00 
  80316d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803171:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803178:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80317f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803186:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80318d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803194:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80319b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8031a2:	48 89 c7             	mov    %rax,%rdi
  8031a5:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  8031ac:	00 00 00 
  8031af:	ff d0                	callq  *%rax
	va_end(ap);
}
  8031b1:	c9                   	leaveq 
  8031b2:	c3                   	retq   

00000000008031b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8031b3:	55                   	push   %rbp
  8031b4:	48 89 e5             	mov    %rsp,%rbp
  8031b7:	48 83 ec 10          	sub    $0x10,%rsp
  8031bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8031c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c6:	8b 40 10             	mov    0x10(%rax),%eax
  8031c9:	8d 50 01             	lea    0x1(%rax),%edx
  8031cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8031d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d7:	48 8b 10             	mov    (%rax),%rdx
  8031da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031de:	48 8b 40 08          	mov    0x8(%rax),%rax
  8031e2:	48 39 c2             	cmp    %rax,%rdx
  8031e5:	73 17                	jae    8031fe <sprintputch+0x4b>
		*b->buf++ = ch;
  8031e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031eb:	48 8b 00             	mov    (%rax),%rax
  8031ee:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8031f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031f6:	48 89 0a             	mov    %rcx,(%rdx)
  8031f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031fc:	88 10                	mov    %dl,(%rax)
}
  8031fe:	c9                   	leaveq 
  8031ff:	c3                   	retq   

0000000000803200 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803200:	55                   	push   %rbp
  803201:	48 89 e5             	mov    %rsp,%rbp
  803204:	48 83 ec 50          	sub    $0x50,%rsp
  803208:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80320c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80320f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803213:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803217:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80321b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80321f:	48 8b 0a             	mov    (%rdx),%rcx
  803222:	48 89 08             	mov    %rcx,(%rax)
  803225:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803229:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80322d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803231:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803235:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803239:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80323d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803240:	48 98                	cltq   
  803242:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803246:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80324a:	48 01 d0             	add    %rdx,%rax
  80324d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803251:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803258:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80325d:	74 06                	je     803265 <vsnprintf+0x65>
  80325f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803263:	7f 07                	jg     80326c <vsnprintf+0x6c>
		return -E_INVAL;
  803265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80326a:	eb 2f                	jmp    80329b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80326c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803270:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803274:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803278:	48 89 c6             	mov    %rax,%rsi
  80327b:	48 bf b3 31 80 00 00 	movabs $0x8031b3,%rdi
  803282:	00 00 00 
  803285:	48 b8 f5 29 80 00 00 	movabs $0x8029f5,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803291:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803295:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803298:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8032a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8032af:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8032b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032ca:	84 c0                	test   %al,%al
  8032cc:	74 20                	je     8032ee <snprintf+0x51>
  8032ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032ee:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8032f5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8032fc:	00 00 00 
  8032ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803306:	00 00 00 
  803309:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80330d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803314:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80331b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803322:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803329:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803330:	48 8b 0a             	mov    (%rdx),%rcx
  803333:	48 89 08             	mov    %rcx,(%rax)
  803336:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80333a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80333e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803342:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803346:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80334d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803354:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80335a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803361:	48 89 c7             	mov    %rax,%rdi
  803364:	48 b8 00 32 80 00 00 	movabs $0x803200,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
  803370:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803376:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80337c:	c9                   	leaveq 
  80337d:	c3                   	retq   

000000000080337e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80337e:	55                   	push   %rbp
  80337f:	48 89 e5             	mov    %rsp,%rbp
  803382:	48 83 ec 30          	sub    $0x30,%rsp
  803386:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80338a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803392:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803396:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80339a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80339f:	75 0e                	jne    8033af <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8033a1:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8033a8:	00 00 00 
  8033ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8033af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b3:	48 89 c7             	mov    %rax,%rdi
  8033b6:	48 b8 c9 0d 80 00 00 	movabs $0x800dc9,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033c9:	79 27                	jns    8033f2 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8033cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033d0:	74 0a                	je     8033dc <ipc_recv+0x5e>
			*from_env_store = 0;
  8033d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8033dc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033e1:	74 0a                	je     8033ed <ipc_recv+0x6f>
			*perm_store = 0;
  8033e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8033ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033f0:	eb 53                	jmp    803445 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8033f2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f7:	74 19                	je     803412 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8033f9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803400:	00 00 00 
  803403:	48 8b 00             	mov    (%rax),%rax
  803406:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80340c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803410:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803412:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803417:	74 19                	je     803432 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803419:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803420:	00 00 00 
  803423:	48 8b 00             	mov    (%rax),%rax
  803426:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80342c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803430:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803432:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803439:	00 00 00 
  80343c:	48 8b 00             	mov    (%rax),%rax
  80343f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803445:	c9                   	leaveq 
  803446:	c3                   	retq   

0000000000803447 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803447:	55                   	push   %rbp
  803448:	48 89 e5             	mov    %rsp,%rbp
  80344b:	48 83 ec 30          	sub    $0x30,%rsp
  80344f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803452:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803455:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803459:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80345c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803460:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803464:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803469:	75 10                	jne    80347b <ipc_send+0x34>
		page = (void *)KERNBASE;
  80346b:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803472:	00 00 00 
  803475:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803479:	eb 0e                	jmp    803489 <ipc_send+0x42>
  80347b:	eb 0c                	jmp    803489 <ipc_send+0x42>
		sys_yield();
  80347d:	48 b8 62 0b 80 00 00 	movabs $0x800b62,%rax
  803484:	00 00 00 
  803487:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803489:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80348c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80348f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803493:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803496:	89 c7                	mov    %eax,%edi
  803498:	48 b8 74 0d 80 00 00 	movabs $0x800d74,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034a7:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8034ab:	74 d0                	je     80347d <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8034ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034b1:	74 2a                	je     8034dd <ipc_send+0x96>
		panic("error on ipc send procedure");
  8034b3:	48 ba c0 3b 80 00 00 	movabs $0x803bc0,%rdx
  8034ba:	00 00 00 
  8034bd:	be 49 00 00 00       	mov    $0x49,%esi
  8034c2:	48 bf dc 3b 80 00 00 	movabs $0x803bdc,%rdi
  8034c9:	00 00 00 
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d1:	48 b9 09 24 80 00 00 	movabs $0x802409,%rcx
  8034d8:	00 00 00 
  8034db:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8034dd:	c9                   	leaveq 
  8034de:	c3                   	retq   

00000000008034df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034df:	55                   	push   %rbp
  8034e0:	48 89 e5             	mov    %rsp,%rbp
  8034e3:	48 83 ec 14          	sub    $0x14,%rsp
  8034e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8034ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034f1:	eb 5e                	jmp    803551 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034f3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034fa:	00 00 00 
  8034fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803500:	48 63 d0             	movslq %eax,%rdx
  803503:	48 89 d0             	mov    %rdx,%rax
  803506:	48 c1 e0 03          	shl    $0x3,%rax
  80350a:	48 01 d0             	add    %rdx,%rax
  80350d:	48 c1 e0 05          	shl    $0x5,%rax
  803511:	48 01 c8             	add    %rcx,%rax
  803514:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80351a:	8b 00                	mov    (%rax),%eax
  80351c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80351f:	75 2c                	jne    80354d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803521:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803528:	00 00 00 
  80352b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352e:	48 63 d0             	movslq %eax,%rdx
  803531:	48 89 d0             	mov    %rdx,%rax
  803534:	48 c1 e0 03          	shl    $0x3,%rax
  803538:	48 01 d0             	add    %rdx,%rax
  80353b:	48 c1 e0 05          	shl    $0x5,%rax
  80353f:	48 01 c8             	add    %rcx,%rax
  803542:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803548:	8b 40 08             	mov    0x8(%rax),%eax
  80354b:	eb 12                	jmp    80355f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80354d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803551:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803558:	7e 99                	jle    8034f3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80355a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80355f:	c9                   	leaveq 
  803560:	c3                   	retq   

0000000000803561 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803561:	55                   	push   %rbp
  803562:	48 89 e5             	mov    %rsp,%rbp
  803565:	48 83 ec 18          	sub    $0x18,%rsp
  803569:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80356d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803571:	48 c1 e8 15          	shr    $0x15,%rax
  803575:	48 89 c2             	mov    %rax,%rdx
  803578:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80357f:	01 00 00 
  803582:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803586:	83 e0 01             	and    $0x1,%eax
  803589:	48 85 c0             	test   %rax,%rax
  80358c:	75 07                	jne    803595 <pageref+0x34>
		return 0;
  80358e:	b8 00 00 00 00       	mov    $0x0,%eax
  803593:	eb 53                	jmp    8035e8 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803599:	48 c1 e8 0c          	shr    $0xc,%rax
  80359d:	48 89 c2             	mov    %rax,%rdx
  8035a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035a7:	01 00 00 
  8035aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b6:	83 e0 01             	and    $0x1,%eax
  8035b9:	48 85 c0             	test   %rax,%rax
  8035bc:	75 07                	jne    8035c5 <pageref+0x64>
		return 0;
  8035be:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c3:	eb 23                	jmp    8035e8 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c9:	48 c1 e8 0c          	shr    $0xc,%rax
  8035cd:	48 89 c2             	mov    %rax,%rdx
  8035d0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035d7:	00 00 00 
  8035da:	48 c1 e2 04          	shl    $0x4,%rdx
  8035de:	48 01 d0             	add    %rdx,%rax
  8035e1:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035e5:	0f b7 c0             	movzwl %ax,%eax
}
  8035e8:	c9                   	leaveq 
  8035e9:	c3                   	retq   
