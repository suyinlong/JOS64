
obj/user/primespipe.debug:     file format elf64-x86-64


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
  80003c:	e8 d3 03 00 00       	callq  800414 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba c0 3e 80 00 00 	movabs $0x803ec0,%rdx
  800092:	00 00 00 
  800095:	be 15 00 00 00       	mov    $0x15,%esi
  80009a:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 01 3f 80 00 00 	movabs $0x803f01,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 c7 32 80 00 00 	movabs $0x8032c7,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 05 3f 80 00 00 	movabs $0x803f05,%rdx
  8000ff:	00 00 00 
  800102:	be 1b 00 00 00       	mov    $0x1b,%esi
  800107:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 0e 3f 80 00 00 	movabs $0x803f0e,%rdx
  800144:	00 00 00 
  800147:	be 1d 00 00 00       	mov    $0x1d,%esi
  80014c:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 34 2b 80 00 00 	movabs $0x802b34,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 4e                	je     800226 <primeproc+0x1e3>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	89 14 24             	mov    %edx,(%rsp)
  8001f3:	41 89 f1             	mov    %esi,%r9d
  8001f6:	41 89 c8             	mov    %ecx,%r8d
  8001f9:	89 c1                	mov    %eax,%ecx
  8001fb:	48 ba 17 3f 80 00 00 	movabs $0x803f17,%rdx
  800202:	00 00 00 
  800205:	be 2b 00 00 00       	mov    $0x2b,%esi
  80020a:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  800211:	00 00 00 
  800214:	b8 00 00 00 00       	mov    $0x0,%eax
  800219:	49 ba c7 04 80 00 00 	movabs $0x8004c7,%r10
  800220:	00 00 00 
  800223:	41 ff d2             	callq  *%r10
		if (i%p)
  800226:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800229:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022c:	99                   	cltd   
  80022d:	f7 f9                	idiv   %ecx
  80022f:	89 d0                	mov    %edx,%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 6e                	je     8002a3 <primeproc+0x260>
			if ((r=write(wfd, &i, 4)) != 4)
  800235:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  800239:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80023c:	ba 04 00 00 00       	mov    $0x4,%edx
  800241:	48 89 ce             	mov    %rcx,%rsi
  800244:	89 c7                	mov    %eax,%edi
  800246:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800255:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800259:	74 48                	je     8002a3 <primeproc+0x260>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80025b:	b8 00 00 00 00       	mov    $0x0,%eax
  800260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800264:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80026d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800270:	41 89 c9             	mov    %ecx,%r9d
  800273:	41 89 d0             	mov    %edx,%r8d
  800276:	89 c1                	mov    %eax,%ecx
  800278:	48 ba 33 3f 80 00 00 	movabs $0x803f33,%rdx
  80027f:	00 00 00 
  800282:	be 2e 00 00 00       	mov    $0x2e,%esi
  800287:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  80028e:	00 00 00 
  800291:	b8 00 00 00 00       	mov    $0x0,%eax
  800296:	49 ba c7 04 80 00 00 	movabs $0x8004c7,%r10
  80029d:	00 00 00 
  8002a0:	41 ff d2             	callq  *%r10
	}
  8002a3:	e9 0a ff ff ff       	jmpq   8001b2 <primeproc+0x16f>

00000000008002a8 <umain>:
}

void
umain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	53                   	push   %rbx
  8002ad:	48 83 ec 38          	sub    $0x38,%rsp
  8002b1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8002b4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002bf:	00 00 00 
  8002c2:	48 bb 4d 3f 80 00 00 	movabs $0x803f4d,%rbx
  8002c9:	00 00 00 
  8002cc:	48 89 18             	mov    %rbx,(%rax)

	if ((i=pipe(p)) < 0)
  8002cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002d3:	48 89 c7             	mov    %rax,%rdi
  8002d6:	48 b8 c7 32 80 00 00 	movabs $0x8032c7,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	79 30                	jns    80031c <umain+0x74>
		panic("pipe: %e", i);
  8002ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ef:	89 c1                	mov    %eax,%ecx
  8002f1:	48 ba 05 3f 80 00 00 	movabs $0x803f05,%rdx
  8002f8:	00 00 00 
  8002fb:	be 3a 00 00 00       	mov    $0x3a,%esi
  800300:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80031c:	48 b8 ad 22 80 00 00 	movabs $0x8022ad,%rax
  800323:	00 00 00 
  800326:	ff d0                	callq  *%rax
  800328:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80032b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80032f:	79 30                	jns    800361 <umain+0xb9>
		panic("fork: %e", id);
  800331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800334:	89 c1                	mov    %eax,%ecx
  800336:	48 ba 0e 3f 80 00 00 	movabs $0x803f0e,%rdx
  80033d:	00 00 00 
  800340:	be 3e 00 00 00       	mov    $0x3e,%esi
  800345:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b8 c7 04 80 00 00 	movabs $0x8004c7,%r8
  80035b:	00 00 00 
  80035e:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800365:	75 22                	jne    800389 <umain+0xe1>
		close(p[1]);
  800367:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036a:	89 c7                	mov    %eax,%edi
  80036c:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
		primeproc(p[0]);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	89 c7                	mov    %eax,%edi
  80037d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
	}

	close(p[0]);
  800389:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039a:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003a4:	48 8d 4d e4          	lea    -0x1c(%rbp),%rcx
  8003a8:	ba 04 00 00 00       	mov    $0x4,%edx
  8003ad:	48 89 ce             	mov    %rcx,%rsi
  8003b0:	89 c7                	mov    %eax,%edi
  8003b2:	48 b8 a9 2b 80 00 00 	movabs $0x802ba9,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
  8003be:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8003c1:	83 7d e8 04          	cmpl   $0x4,-0x18(%rbp)
  8003c5:	74 42                	je     800409 <umain+0x161>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8003d0:	0f 4e 45 e8          	cmovle -0x18(%rbp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003d9:	41 89 d0             	mov    %edx,%r8d
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	48 ba 58 3f 80 00 00 	movabs $0x803f58,%rdx
  8003e5:	00 00 00 
  8003e8:	be 4a 00 00 00       	mov    $0x4a,%esi
  8003ed:	48 bf ef 3e 80 00 00 	movabs $0x803eef,%rdi
  8003f4:	00 00 00 
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  800403:	00 00 00 
  800406:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	83 c0 01             	add    $0x1,%eax
  80040f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800412:	eb 8d                	jmp    8003a1 <umain+0xf9>

0000000000800414 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 10          	sub    $0x10,%rsp
  80041c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800423:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	callq  *%rax
  80042f:	48 98                	cltq   
  800431:	25 ff 03 00 00       	and    $0x3ff,%eax
  800436:	48 89 c2             	mov    %rax,%rdx
  800439:	48 89 d0             	mov    %rdx,%rax
  80043c:	48 c1 e0 03          	shl    $0x3,%rax
  800440:	48 01 d0             	add    %rdx,%rax
  800443:	48 c1 e0 05          	shl    $0x5,%rax
  800447:	48 89 c2             	mov    %rax,%rdx
  80044a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800451:	00 00 00 
  800454:	48 01 c2             	add    %rax,%rdx
  800457:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80045e:	00 00 00 
  800461:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800464:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800468:	7e 14                	jle    80047e <libmain+0x6a>
		binaryname = argv[0];
  80046a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046e:	48 8b 10             	mov    (%rax),%rdx
  800471:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800478:	00 00 00 
  80047b:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80047e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800485:	48 89 d6             	mov    %rdx,%rsi
  800488:	89 c7                	mov    %eax,%edi
  80048a:	48 b8 a8 02 80 00 00 	movabs $0x8002a8,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800496:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  80049d:	00 00 00 
  8004a0:	ff d0                	callq  *%rax
}
  8004a2:	c9                   	leaveq 
  8004a3:	c3                   	retq   

00000000008004a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004a4:	55                   	push   %rbp
  8004a5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004a8:	48 b8 88 28 80 00 00 	movabs $0x802888,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8004b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b9:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
}
  8004c5:	5d                   	pop    %rbp
  8004c6:	c3                   	retq   

00000000008004c7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	53                   	push   %rbx
  8004cc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004d3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004da:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004e0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004ee:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f5:	84 c0                	test   %al,%al
  8004f7:	74 23                	je     80051c <_panic+0x55>
  8004f9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800500:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800504:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800508:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80050c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800510:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800514:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800518:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80051c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800523:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80052a:	00 00 00 
  80052d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800534:	00 00 00 
  800537:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800542:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800549:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800550:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800557:	00 00 00 
  80055a:	48 8b 18             	mov    (%rax),%rbx
  80055d:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  800564:	00 00 00 
  800567:	ff d0                	callq  *%rax
  800569:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80056f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800576:	41 89 c8             	mov    %ecx,%r8d
  800579:	48 89 d1             	mov    %rdx,%rcx
  80057c:	48 89 da             	mov    %rbx,%rdx
  80057f:	89 c6                	mov    %eax,%esi
  800581:	48 bf 80 3f 80 00 00 	movabs $0x803f80,%rdi
  800588:	00 00 00 
  80058b:	b8 00 00 00 00       	mov    $0x0,%eax
  800590:	49 b9 00 07 80 00 00 	movabs $0x800700,%r9
  800597:	00 00 00 
  80059a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80059d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005a4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ab:	48 89 d6             	mov    %rdx,%rsi
  8005ae:	48 89 c7             	mov    %rax,%rdi
  8005b1:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
	cprintf("\n");
  8005bd:	48 bf a3 3f 80 00 00 	movabs $0x803fa3,%rdi
  8005c4:	00 00 00 
  8005c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cc:	48 ba 00 07 80 00 00 	movabs $0x800700,%rdx
  8005d3:	00 00 00 
  8005d6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d8:	cc                   	int3   
  8005d9:	eb fd                	jmp    8005d8 <_panic+0x111>

00000000008005db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005db:	55                   	push   %rbp
  8005dc:	48 89 e5             	mov    %rsp,%rbp
  8005df:	48 83 ec 10          	sub    $0x10,%rsp
  8005e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8005ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	8d 48 01             	lea    0x1(%rax),%ecx
  8005f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f7:	89 0a                	mov    %ecx,(%rdx)
  8005f9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005fc:	89 d1                	mov    %edx,%ecx
  8005fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800602:	48 98                	cltq   
  800604:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800613:	75 2c                	jne    800641 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800619:	8b 00                	mov    (%rax),%eax
  80061b:	48 98                	cltq   
  80061d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800621:	48 83 c2 08          	add    $0x8,%rdx
  800625:	48 89 c6             	mov    %rax,%rsi
  800628:	48 89 d7             	mov    %rdx,%rdi
  80062b:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
		b->idx = 0;
  800637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800645:	8b 40 04             	mov    0x4(%rax),%eax
  800648:	8d 50 01             	lea    0x1(%rax),%edx
  80064b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800652:	c9                   	leaveq 
  800653:	c3                   	retq   

0000000000800654 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800654:	55                   	push   %rbp
  800655:	48 89 e5             	mov    %rsp,%rbp
  800658:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80065f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800666:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80066d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800674:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80067b:	48 8b 0a             	mov    (%rdx),%rcx
  80067e:	48 89 08             	mov    %rcx,(%rax)
  800681:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800685:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800689:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80068d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800691:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800698:	00 00 00 
	b.cnt = 0;
  80069b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006a2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006a5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ac:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006b3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006ba:	48 89 c6             	mov    %rax,%rsi
  8006bd:	48 bf db 05 80 00 00 	movabs $0x8005db,%rdi
  8006c4:	00 00 00 
  8006c7:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  8006ce:	00 00 00 
  8006d1:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8006d3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006d9:	48 98                	cltq   
  8006db:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006e2:	48 83 c2 08          	add    $0x8,%rdx
  8006e6:	48 89 c6             	mov    %rax,%rsi
  8006e9:	48 89 d7             	mov    %rdx,%rdi
  8006ec:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8006f3:	00 00 00 
  8006f6:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8006f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006fe:	c9                   	leaveq 
  8006ff:	c3                   	retq   

0000000000800700 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800700:	55                   	push   %rbp
  800701:	48 89 e5             	mov    %rsp,%rbp
  800704:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80070b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800712:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800719:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800720:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800727:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80072e:	84 c0                	test   %al,%al
  800730:	74 20                	je     800752 <cprintf+0x52>
  800732:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800736:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80073a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80073e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800742:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800746:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80074a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80074e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800752:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800759:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800760:	00 00 00 
  800763:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80076a:	00 00 00 
  80076d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800771:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800778:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80077f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800786:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80078d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800794:	48 8b 0a             	mov    (%rdx),%rcx
  800797:	48 89 08             	mov    %rcx,(%rax)
  80079a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80079e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007aa:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007b1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b8:	48 89 d6             	mov    %rdx,%rsi
  8007bb:	48 89 c7             	mov    %rax,%rdi
  8007be:	48 b8 54 06 80 00 00 	movabs $0x800654,%rax
  8007c5:	00 00 00 
  8007c8:	ff d0                	callq  *%rax
  8007ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8007d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d6:	c9                   	leaveq 
  8007d7:	c3                   	retq   

00000000008007d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	53                   	push   %rbx
  8007dd:	48 83 ec 38          	sub    $0x38,%rsp
  8007e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8007e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8007ed:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8007f0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8007f4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8007fb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8007ff:	77 3b                	ja     80083c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800801:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800804:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800808:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80080b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	48 f7 f3             	div    %rbx
  800817:	48 89 c2             	mov    %rax,%rdx
  80081a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80081d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800820:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	41 89 f9             	mov    %edi,%r9d
  80082b:	48 89 c7             	mov    %rax,%rdi
  80082e:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
  80083a:	eb 1e                	jmp    80085a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80083c:	eb 12                	jmp    800850 <printnum+0x78>
			putch(padc, putdat);
  80083e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800842:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	48 89 ce             	mov    %rcx,%rsi
  80084c:	89 d7                	mov    %edx,%edi
  80084e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800850:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800854:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800858:	7f e4                	jg     80083e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80085d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	48 f7 f1             	div    %rcx
  800869:	48 89 d0             	mov    %rdx,%rax
  80086c:	48 ba 88 41 80 00 00 	movabs $0x804188,%rdx
  800873:	00 00 00 
  800876:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80087a:	0f be d0             	movsbl %al,%edx
  80087d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800885:	48 89 ce             	mov    %rcx,%rsi
  800888:	89 d7                	mov    %edx,%edi
  80088a:	ff d0                	callq  *%rax
}
  80088c:	48 83 c4 38          	add    $0x38,%rsp
  800890:	5b                   	pop    %rbx
  800891:	5d                   	pop    %rbp
  800892:	c3                   	retq   

0000000000800893 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800893:	55                   	push   %rbp
  800894:	48 89 e5             	mov    %rsp,%rbp
  800897:	48 83 ec 1c          	sub    $0x1c,%rsp
  80089b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80089f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8008a2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a6:	7e 52                	jle    8008fa <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	83 f8 30             	cmp    $0x30,%eax
  8008b1:	73 24                	jae    8008d7 <getuint+0x44>
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	89 c0                	mov    %eax,%eax
  8008c3:	48 01 d0             	add    %rdx,%rax
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	8b 12                	mov    (%rdx),%edx
  8008cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d3:	89 0a                	mov    %ecx,(%rdx)
  8008d5:	eb 17                	jmp    8008ee <getuint+0x5b>
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008df:	48 89 d0             	mov    %rdx,%rax
  8008e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ee:	48 8b 00             	mov    (%rax),%rax
  8008f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f5:	e9 a3 00 00 00       	jmpq   80099d <getuint+0x10a>
	else if (lflag)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008fe:	74 4f                	je     80094f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	8b 00                	mov    (%rax),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 24                	jae    80092f <getuint+0x9c>
  80090b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	8b 00                	mov    (%rax),%eax
  800919:	89 c0                	mov    %eax,%eax
  80091b:	48 01 d0             	add    %rdx,%rax
  80091e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800922:	8b 12                	mov    (%rdx),%edx
  800924:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800927:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092b:	89 0a                	mov    %ecx,(%rdx)
  80092d:	eb 17                	jmp    800946 <getuint+0xb3>
  80092f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800933:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800937:	48 89 d0             	mov    %rdx,%rax
  80093a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800946:	48 8b 00             	mov    (%rax),%rax
  800949:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094d:	eb 4e                	jmp    80099d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	8b 00                	mov    (%rax),%eax
  800955:	83 f8 30             	cmp    $0x30,%eax
  800958:	73 24                	jae    80097e <getuint+0xeb>
  80095a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800966:	8b 00                	mov    (%rax),%eax
  800968:	89 c0                	mov    %eax,%eax
  80096a:	48 01 d0             	add    %rdx,%rax
  80096d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800971:	8b 12                	mov    (%rdx),%edx
  800973:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097a:	89 0a                	mov    %ecx,(%rdx)
  80097c:	eb 17                	jmp    800995 <getuint+0x102>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800986:	48 89 d0             	mov    %rdx,%rax
  800989:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800991:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800995:	8b 00                	mov    (%rax),%eax
  800997:	89 c0                	mov    %eax,%eax
  800999:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80099d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009a1:	c9                   	leaveq 
  8009a2:	c3                   	retq   

00000000008009a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a3:	55                   	push   %rbp
  8009a4:	48 89 e5             	mov    %rsp,%rbp
  8009a7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009b2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009b6:	7e 52                	jle    800a0a <getint+0x67>
		x=va_arg(*ap, long long);
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	8b 00                	mov    (%rax),%eax
  8009be:	83 f8 30             	cmp    $0x30,%eax
  8009c1:	73 24                	jae    8009e7 <getint+0x44>
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	8b 00                	mov    (%rax),%eax
  8009d1:	89 c0                	mov    %eax,%eax
  8009d3:	48 01 d0             	add    %rdx,%rax
  8009d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009da:	8b 12                	mov    (%rdx),%edx
  8009dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	89 0a                	mov    %ecx,(%rdx)
  8009e5:	eb 17                	jmp    8009fe <getint+0x5b>
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ef:	48 89 d0             	mov    %rdx,%rax
  8009f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009fe:	48 8b 00             	mov    (%rax),%rax
  800a01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a05:	e9 a3 00 00 00       	jmpq   800aad <getint+0x10a>
	else if (lflag)
  800a0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a0e:	74 4f                	je     800a5f <getint+0xbc>
		x=va_arg(*ap, long);
  800a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a14:	8b 00                	mov    (%rax),%eax
  800a16:	83 f8 30             	cmp    $0x30,%eax
  800a19:	73 24                	jae    800a3f <getint+0x9c>
  800a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a27:	8b 00                	mov    (%rax),%eax
  800a29:	89 c0                	mov    %eax,%eax
  800a2b:	48 01 d0             	add    %rdx,%rax
  800a2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a32:	8b 12                	mov    (%rdx),%edx
  800a34:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3b:	89 0a                	mov    %ecx,(%rdx)
  800a3d:	eb 17                	jmp    800a56 <getint+0xb3>
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a47:	48 89 d0             	mov    %rdx,%rax
  800a4a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a52:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a56:	48 8b 00             	mov    (%rax),%rax
  800a59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a5d:	eb 4e                	jmp    800aad <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800a5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a63:	8b 00                	mov    (%rax),%eax
  800a65:	83 f8 30             	cmp    $0x30,%eax
  800a68:	73 24                	jae    800a8e <getint+0xeb>
  800a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	8b 00                	mov    (%rax),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a81:	8b 12                	mov    (%rdx),%edx
  800a83:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8a:	89 0a                	mov    %ecx,(%rdx)
  800a8c:	eb 17                	jmp    800aa5 <getint+0x102>
  800a8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a92:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a96:	48 89 d0             	mov    %rdx,%rax
  800a99:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa5:	8b 00                	mov    (%rax),%eax
  800aa7:	48 98                	cltq   
  800aa9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ab1:	c9                   	leaveq 
  800ab2:	c3                   	retq   

0000000000800ab3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ab3:	55                   	push   %rbp
  800ab4:	48 89 e5             	mov    %rsp,%rbp
  800ab7:	41 54                	push   %r12
  800ab9:	53                   	push   %rbx
  800aba:	48 83 ec 60          	sub    $0x60,%rsp
  800abe:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ac2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ac6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aca:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ace:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ad2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ad6:	48 8b 0a             	mov    (%rdx),%rcx
  800ad9:	48 89 08             	mov    %rcx,(%rax)
  800adc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ae0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ae4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ae8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800aec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800af4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af8:	0f b6 00             	movzbl (%rax),%eax
  800afb:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800afe:	eb 29                	jmp    800b29 <vprintfmt+0x76>
			if (ch == '\0')
  800b00:	85 db                	test   %ebx,%ebx
  800b02:	0f 84 ad 06 00 00    	je     8011b5 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800b08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b10:	48 89 d6             	mov    %rdx,%rsi
  800b13:	89 df                	mov    %ebx,%edi
  800b15:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800b17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b23:	0f b6 00             	movzbl (%rax),%eax
  800b26:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800b29:	83 fb 25             	cmp    $0x25,%ebx
  800b2c:	74 05                	je     800b33 <vprintfmt+0x80>
  800b2e:	83 fb 1b             	cmp    $0x1b,%ebx
  800b31:	75 cd                	jne    800b00 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800b33:	83 fb 1b             	cmp    $0x1b,%ebx
  800b36:	0f 85 ae 01 00 00    	jne    800cea <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800b3c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800b43:	00 00 00 
  800b46:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800b4c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b50:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b54:	48 89 d6             	mov    %rdx,%rsi
  800b57:	89 df                	mov    %ebx,%edi
  800b59:	ff d0                	callq  *%rax
			putch('[', putdat);
  800b5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b63:	48 89 d6             	mov    %rdx,%rsi
  800b66:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800b6b:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800b6d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800b73:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b78:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b7c:	0f b6 00             	movzbl (%rax),%eax
  800b7f:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800b82:	eb 32                	jmp    800bb6 <vprintfmt+0x103>
					putch(ch, putdat);
  800b84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	48 89 d6             	mov    %rdx,%rsi
  800b8f:	89 df                	mov    %ebx,%edi
  800b91:	ff d0                	callq  *%rax
					esc_color *= 10;
  800b93:	44 89 e0             	mov    %r12d,%eax
  800b96:	c1 e0 02             	shl    $0x2,%eax
  800b99:	44 01 e0             	add    %r12d,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800ba1:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800ba4:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800ba7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800bac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bb0:	0f b6 00             	movzbl (%rax),%eax
  800bb3:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800bb6:	83 fb 3b             	cmp    $0x3b,%ebx
  800bb9:	74 05                	je     800bc0 <vprintfmt+0x10d>
  800bbb:	83 fb 6d             	cmp    $0x6d,%ebx
  800bbe:	75 c4                	jne    800b84 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800bc0:	45 85 e4             	test   %r12d,%r12d
  800bc3:	75 15                	jne    800bda <vprintfmt+0x127>
					color_flag = 0x07;
  800bc5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bcc:	00 00 00 
  800bcf:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800bd5:	e9 dc 00 00 00       	jmpq   800cb6 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800bda:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800bde:	7e 69                	jle    800c49 <vprintfmt+0x196>
  800be0:	41 83 fc 25          	cmp    $0x25,%r12d
  800be4:	7f 63                	jg     800c49 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800be6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bed:	00 00 00 
  800bf0:	8b 00                	mov    (%rax),%eax
  800bf2:	25 f8 00 00 00       	and    $0xf8,%eax
  800bf7:	89 c2                	mov    %eax,%edx
  800bf9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c00:	00 00 00 
  800c03:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800c05:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800c09:	44 89 e0             	mov    %r12d,%eax
  800c0c:	83 e0 04             	and    $0x4,%eax
  800c0f:	c1 f8 02             	sar    $0x2,%eax
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	44 89 e0             	mov    %r12d,%eax
  800c17:	83 e0 02             	and    $0x2,%eax
  800c1a:	09 c2                	or     %eax,%edx
  800c1c:	44 89 e0             	mov    %r12d,%eax
  800c1f:	83 e0 01             	and    $0x1,%eax
  800c22:	c1 e0 02             	shl    $0x2,%eax
  800c25:	09 c2                	or     %eax,%edx
  800c27:	41 89 d4             	mov    %edx,%r12d
  800c2a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c31:	00 00 00 
  800c34:	8b 00                	mov    (%rax),%eax
  800c36:	44 89 e2             	mov    %r12d,%edx
  800c39:	09 c2                	or     %eax,%edx
  800c3b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c42:	00 00 00 
  800c45:	89 10                	mov    %edx,(%rax)
  800c47:	eb 6d                	jmp    800cb6 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800c49:	41 83 fc 27          	cmp    $0x27,%r12d
  800c4d:	7e 67                	jle    800cb6 <vprintfmt+0x203>
  800c4f:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800c53:	7f 61                	jg     800cb6 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800c55:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c5c:	00 00 00 
  800c5f:	8b 00                	mov    (%rax),%eax
  800c61:	25 8f 00 00 00       	and    $0x8f,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c6f:	00 00 00 
  800c72:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800c74:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800c78:	44 89 e0             	mov    %r12d,%eax
  800c7b:	83 e0 04             	and    $0x4,%eax
  800c7e:	c1 f8 02             	sar    $0x2,%eax
  800c81:	89 c2                	mov    %eax,%edx
  800c83:	44 89 e0             	mov    %r12d,%eax
  800c86:	83 e0 02             	and    $0x2,%eax
  800c89:	09 c2                	or     %eax,%edx
  800c8b:	44 89 e0             	mov    %r12d,%eax
  800c8e:	83 e0 01             	and    $0x1,%eax
  800c91:	c1 e0 06             	shl    $0x6,%eax
  800c94:	09 c2                	or     %eax,%edx
  800c96:	41 89 d4             	mov    %edx,%r12d
  800c99:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ca0:	00 00 00 
  800ca3:	8b 00                	mov    (%rax),%eax
  800ca5:	44 89 e2             	mov    %r12d,%edx
  800ca8:	09 c2                	or     %eax,%edx
  800caa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cb1:	00 00 00 
  800cb4:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800cb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbe:	48 89 d6             	mov    %rdx,%rsi
  800cc1:	89 df                	mov    %ebx,%edi
  800cc3:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800cc5:	83 fb 6d             	cmp    $0x6d,%ebx
  800cc8:	75 1b                	jne    800ce5 <vprintfmt+0x232>
					fmt ++;
  800cca:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800ccf:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800cd0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800cd7:	00 00 00 
  800cda:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800ce0:	e9 cb 04 00 00       	jmpq   8011b0 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800ce5:	e9 83 fe ff ff       	jmpq   800b6d <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800cea:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800cee:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800cf5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800cfc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800d03:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d0a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d0e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d12:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d16:	0f b6 00             	movzbl (%rax),%eax
  800d19:	0f b6 d8             	movzbl %al,%ebx
  800d1c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800d1f:	83 f8 55             	cmp    $0x55,%eax
  800d22:	0f 87 5a 04 00 00    	ja     801182 <vprintfmt+0x6cf>
  800d28:	89 c0                	mov    %eax,%eax
  800d2a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800d31:	00 
  800d32:	48 b8 b0 41 80 00 00 	movabs $0x8041b0,%rax
  800d39:	00 00 00 
  800d3c:	48 01 d0             	add    %rdx,%rax
  800d3f:	48 8b 00             	mov    (%rax),%rax
  800d42:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d44:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d48:	eb c0                	jmp    800d0a <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d4a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d4e:	eb ba                	jmp    800d0a <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d50:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d57:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d5a:	89 d0                	mov    %edx,%eax
  800d5c:	c1 e0 02             	shl    $0x2,%eax
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	01 c0                	add    %eax,%eax
  800d63:	01 d8                	add    %ebx,%eax
  800d65:	83 e8 30             	sub    $0x30,%eax
  800d68:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d6f:	0f b6 00             	movzbl (%rax),%eax
  800d72:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d75:	83 fb 2f             	cmp    $0x2f,%ebx
  800d78:	7e 0c                	jle    800d86 <vprintfmt+0x2d3>
  800d7a:	83 fb 39             	cmp    $0x39,%ebx
  800d7d:	7f 07                	jg     800d86 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d7f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d84:	eb d1                	jmp    800d57 <vprintfmt+0x2a4>
			goto process_precision;
  800d86:	eb 58                	jmp    800de0 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800d88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8b:	83 f8 30             	cmp    $0x30,%eax
  800d8e:	73 17                	jae    800da7 <vprintfmt+0x2f4>
  800d90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d97:	89 c0                	mov    %eax,%eax
  800d99:	48 01 d0             	add    %rdx,%rax
  800d9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9f:	83 c2 08             	add    $0x8,%edx
  800da2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da5:	eb 0f                	jmp    800db6 <vprintfmt+0x303>
  800da7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dab:	48 89 d0             	mov    %rdx,%rax
  800dae:	48 83 c2 08          	add    $0x8,%rdx
  800db2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db6:	8b 00                	mov    (%rax),%eax
  800db8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800dbb:	eb 23                	jmp    800de0 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800dbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc1:	79 0c                	jns    800dcf <vprintfmt+0x31c>
				width = 0;
  800dc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800dca:	e9 3b ff ff ff       	jmpq   800d0a <vprintfmt+0x257>
  800dcf:	e9 36 ff ff ff       	jmpq   800d0a <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800dd4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ddb:	e9 2a ff ff ff       	jmpq   800d0a <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800de0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800de4:	79 12                	jns    800df8 <vprintfmt+0x345>
				width = precision, precision = -1;
  800de6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800de9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800dec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800df3:	e9 12 ff ff ff       	jmpq   800d0a <vprintfmt+0x257>
  800df8:	e9 0d ff ff ff       	jmpq   800d0a <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dfd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800e01:	e9 04 ff ff ff       	jmpq   800d0a <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800e06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e09:	83 f8 30             	cmp    $0x30,%eax
  800e0c:	73 17                	jae    800e25 <vprintfmt+0x372>
  800e0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e15:	89 c0                	mov    %eax,%eax
  800e17:	48 01 d0             	add    %rdx,%rax
  800e1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1d:	83 c2 08             	add    $0x8,%edx
  800e20:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e23:	eb 0f                	jmp    800e34 <vprintfmt+0x381>
  800e25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e29:	48 89 d0             	mov    %rdx,%rax
  800e2c:	48 83 c2 08          	add    $0x8,%rdx
  800e30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e34:	8b 10                	mov    (%rax),%edx
  800e36:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	48 89 ce             	mov    %rcx,%rsi
  800e41:	89 d7                	mov    %edx,%edi
  800e43:	ff d0                	callq  *%rax
			break;
  800e45:	e9 66 03 00 00       	jmpq   8011b0 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800e4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4d:	83 f8 30             	cmp    $0x30,%eax
  800e50:	73 17                	jae    800e69 <vprintfmt+0x3b6>
  800e52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e59:	89 c0                	mov    %eax,%eax
  800e5b:	48 01 d0             	add    %rdx,%rax
  800e5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e67:	eb 0f                	jmp    800e78 <vprintfmt+0x3c5>
  800e69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6d:	48 89 d0             	mov    %rdx,%rax
  800e70:	48 83 c2 08          	add    $0x8,%rdx
  800e74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e78:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e7a:	85 db                	test   %ebx,%ebx
  800e7c:	79 02                	jns    800e80 <vprintfmt+0x3cd>
				err = -err;
  800e7e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e80:	83 fb 10             	cmp    $0x10,%ebx
  800e83:	7f 16                	jg     800e9b <vprintfmt+0x3e8>
  800e85:	48 b8 00 41 80 00 00 	movabs $0x804100,%rax
  800e8c:	00 00 00 
  800e8f:	48 63 d3             	movslq %ebx,%rdx
  800e92:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e96:	4d 85 e4             	test   %r12,%r12
  800e99:	75 2e                	jne    800ec9 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800e9b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea3:	89 d9                	mov    %ebx,%ecx
  800ea5:	48 ba 99 41 80 00 00 	movabs $0x804199,%rdx
  800eac:	00 00 00 
  800eaf:	48 89 c7             	mov    %rax,%rdi
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb7:	49 b8 be 11 80 00 00 	movabs $0x8011be,%r8
  800ebe:	00 00 00 
  800ec1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ec4:	e9 e7 02 00 00       	jmpq   8011b0 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ec9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ecd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed1:	4c 89 e1             	mov    %r12,%rcx
  800ed4:	48 ba a2 41 80 00 00 	movabs $0x8041a2,%rdx
  800edb:	00 00 00 
  800ede:	48 89 c7             	mov    %rax,%rdi
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	49 b8 be 11 80 00 00 	movabs $0x8011be,%r8
  800eed:	00 00 00 
  800ef0:	41 ff d0             	callq  *%r8
			break;
  800ef3:	e9 b8 02 00 00       	jmpq   8011b0 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ef8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800efb:	83 f8 30             	cmp    $0x30,%eax
  800efe:	73 17                	jae    800f17 <vprintfmt+0x464>
  800f00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f07:	89 c0                	mov    %eax,%eax
  800f09:	48 01 d0             	add    %rdx,%rax
  800f0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f0f:	83 c2 08             	add    $0x8,%edx
  800f12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f15:	eb 0f                	jmp    800f26 <vprintfmt+0x473>
  800f17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f1b:	48 89 d0             	mov    %rdx,%rax
  800f1e:	48 83 c2 08          	add    $0x8,%rdx
  800f22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f26:	4c 8b 20             	mov    (%rax),%r12
  800f29:	4d 85 e4             	test   %r12,%r12
  800f2c:	75 0a                	jne    800f38 <vprintfmt+0x485>
				p = "(null)";
  800f2e:	49 bc a5 41 80 00 00 	movabs $0x8041a5,%r12
  800f35:	00 00 00 
			if (width > 0 && padc != '-')
  800f38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f3c:	7e 3f                	jle    800f7d <vprintfmt+0x4ca>
  800f3e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800f42:	74 39                	je     800f7d <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f44:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f47:	48 98                	cltq   
  800f49:	48 89 c6             	mov    %rax,%rsi
  800f4c:	4c 89 e7             	mov    %r12,%rdi
  800f4f:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
  800f5b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f5e:	eb 17                	jmp    800f77 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800f60:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800f64:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6c:	48 89 ce             	mov    %rcx,%rsi
  800f6f:	89 d7                	mov    %edx,%edi
  800f71:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f7b:	7f e3                	jg     800f60 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 37                	jmp    800fb6 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f83:	74 1e                	je     800fa3 <vprintfmt+0x4f0>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x4dc>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 14                	jle    800fa3 <vprintfmt+0x4f0>
					putch('?', putdat);
  800f8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f97:	48 89 d6             	mov    %rdx,%rsi
  800f9a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f9f:	ff d0                	callq  *%rax
  800fa1:	eb 0f                	jmp    800fb2 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800fa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fab:	48 89 d6             	mov    %rdx,%rsi
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fb6:	4c 89 e0             	mov    %r12,%rax
  800fb9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800fbd:	0f b6 00             	movzbl (%rax),%eax
  800fc0:	0f be d8             	movsbl %al,%ebx
  800fc3:	85 db                	test   %ebx,%ebx
  800fc5:	74 10                	je     800fd7 <vprintfmt+0x524>
  800fc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800fcb:	78 b2                	js     800f7f <vprintfmt+0x4cc>
  800fcd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800fd1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800fd5:	79 a8                	jns    800f7f <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	eb 16                	jmp    800fef <vprintfmt+0x53c>
				putch(' ', putdat);
  800fd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe1:	48 89 d6             	mov    %rdx,%rsi
  800fe4:	bf 20 00 00 00       	mov    $0x20,%edi
  800fe9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800feb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ff3:	7f e4                	jg     800fd9 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800ff5:	e9 b6 01 00 00       	jmpq   8011b0 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ffa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ffe:	be 03 00 00 00       	mov    $0x3,%esi
  801003:	48 89 c7             	mov    %rax,%rdi
  801006:	48 b8 a3 09 80 00 00 	movabs $0x8009a3,%rax
  80100d:	00 00 00 
  801010:	ff d0                	callq  *%rax
  801012:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101a:	48 85 c0             	test   %rax,%rax
  80101d:	79 1d                	jns    80103c <vprintfmt+0x589>
				putch('-', putdat);
  80101f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801023:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801027:	48 89 d6             	mov    %rdx,%rsi
  80102a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80102f:	ff d0                	callq  *%rax
				num = -(long long) num;
  801031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801035:	48 f7 d8             	neg    %rax
  801038:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80103c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801043:	e9 fb 00 00 00       	jmpq   801143 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801048:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80104c:	be 03 00 00 00       	mov    $0x3,%esi
  801051:	48 89 c7             	mov    %rax,%rdi
  801054:	48 b8 93 08 80 00 00 	movabs $0x800893,%rax
  80105b:	00 00 00 
  80105e:	ff d0                	callq  *%rax
  801060:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801064:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80106b:	e9 d3 00 00 00       	jmpq   801143 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  801070:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801074:	be 03 00 00 00       	mov    $0x3,%esi
  801079:	48 89 c7             	mov    %rax,%rdi
  80107c:	48 b8 a3 09 80 00 00 	movabs $0x8009a3,%rax
  801083:	00 00 00 
  801086:	ff d0                	callq  *%rax
  801088:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	48 85 c0             	test   %rax,%rax
  801093:	79 1d                	jns    8010b2 <vprintfmt+0x5ff>
				putch('-', putdat);
  801095:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801099:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80109d:	48 89 d6             	mov    %rdx,%rsi
  8010a0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8010a5:	ff d0                	callq  *%rax
				num = -(long long) num;
  8010a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ab:	48 f7 d8             	neg    %rax
  8010ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8010b2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8010b9:	e9 85 00 00 00       	jmpq   801143 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8010be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c6:	48 89 d6             	mov    %rdx,%rsi
  8010c9:	bf 30 00 00 00       	mov    $0x30,%edi
  8010ce:	ff d0                	callq  *%rax
			putch('x', putdat);
  8010d0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d8:	48 89 d6             	mov    %rdx,%rsi
  8010db:	bf 78 00 00 00       	mov    $0x78,%edi
  8010e0:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8010e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010e5:	83 f8 30             	cmp    $0x30,%eax
  8010e8:	73 17                	jae    801101 <vprintfmt+0x64e>
  8010ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010f1:	89 c0                	mov    %eax,%eax
  8010f3:	48 01 d0             	add    %rdx,%rax
  8010f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010f9:	83 c2 08             	add    $0x8,%edx
  8010fc:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010ff:	eb 0f                	jmp    801110 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801101:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801105:	48 89 d0             	mov    %rdx,%rax
  801108:	48 83 c2 08          	add    $0x8,%rdx
  80110c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801110:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801113:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801117:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80111e:	eb 23                	jmp    801143 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801120:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801124:	be 03 00 00 00       	mov    $0x3,%esi
  801129:	48 89 c7             	mov    %rax,%rdi
  80112c:	48 b8 93 08 80 00 00 	movabs $0x800893,%rax
  801133:	00 00 00 
  801136:	ff d0                	callq  *%rax
  801138:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80113c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801143:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801148:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80114b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80114e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801152:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801156:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80115a:	45 89 c1             	mov    %r8d,%r9d
  80115d:	41 89 f8             	mov    %edi,%r8d
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
			break;
  80116f:	eb 3f                	jmp    8011b0 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801171:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801175:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801179:	48 89 d6             	mov    %rdx,%rsi
  80117c:	89 df                	mov    %ebx,%edi
  80117e:	ff d0                	callq  *%rax
			break;
  801180:	eb 2e                	jmp    8011b0 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801182:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801186:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80118a:	48 89 d6             	mov    %rdx,%rsi
  80118d:	bf 25 00 00 00       	mov    $0x25,%edi
  801192:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801194:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801199:	eb 05                	jmp    8011a0 <vprintfmt+0x6ed>
  80119b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011a0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011a4:	48 83 e8 01          	sub    $0x1,%rax
  8011a8:	0f b6 00             	movzbl (%rax),%eax
  8011ab:	3c 25                	cmp    $0x25,%al
  8011ad:	75 ec                	jne    80119b <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8011af:	90                   	nop
		}
	}
  8011b0:	e9 37 f9 ff ff       	jmpq   800aec <vprintfmt+0x39>
    va_end(aq);
}
  8011b5:	48 83 c4 60          	add    $0x60,%rsp
  8011b9:	5b                   	pop    %rbx
  8011ba:	41 5c                	pop    %r12
  8011bc:	5d                   	pop    %rbp
  8011bd:	c3                   	retq   

00000000008011be <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8011c9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8011d0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8011d7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011de:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 20                	je     801210 <printfmt+0x52>
  8011f0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011fc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801200:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801204:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801208:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80120c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801210:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801217:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80121e:	00 00 00 
  801221:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801228:	00 00 00 
  80122b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801236:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80123d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801244:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80124b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801252:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801259:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801260:	48 89 c7             	mov    %rax,%rdi
  801263:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  80126a:	00 00 00 
  80126d:	ff d0                	callq  *%rax
	va_end(ap);
}
  80126f:	c9                   	leaveq 
  801270:	c3                   	retq   

0000000000801271 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	48 83 ec 10          	sub    $0x10,%rsp
  801279:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80127c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801284:	8b 40 10             	mov    0x10(%rax),%eax
  801287:	8d 50 01             	lea    0x1(%rax),%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	48 8b 10             	mov    (%rax),%rdx
  801298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129c:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012a0:	48 39 c2             	cmp    %rax,%rdx
  8012a3:	73 17                	jae    8012bc <sprintputch+0x4b>
		*b->buf++ = ch;
  8012a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a9:	48 8b 00             	mov    (%rax),%rax
  8012ac:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8012b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012b4:	48 89 0a             	mov    %rcx,(%rdx)
  8012b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012ba:	88 10                	mov    %dl,(%rax)
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 83 ec 50          	sub    $0x50,%rsp
  8012c6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8012ca:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8012cd:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8012d1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8012d5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8012d9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8012dd:	48 8b 0a             	mov    (%rdx),%rcx
  8012e0:	48 89 08             	mov    %rcx,(%rax)
  8012e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012f7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8012fb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8012fe:	48 98                	cltq   
  801300:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801304:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801308:	48 01 d0             	add    %rdx,%rax
  80130b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80130f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801316:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80131b:	74 06                	je     801323 <vsnprintf+0x65>
  80131d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801321:	7f 07                	jg     80132a <vsnprintf+0x6c>
		return -E_INVAL;
  801323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801328:	eb 2f                	jmp    801359 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80132a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80132e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801332:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801336:	48 89 c6             	mov    %rax,%rsi
  801339:	48 bf 71 12 80 00 00 	movabs $0x801271,%rdi
  801340:	00 00 00 
  801343:	48 b8 b3 0a 80 00 00 	movabs $0x800ab3,%rax
  80134a:	00 00 00 
  80134d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80134f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801353:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801356:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801366:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80136d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801373:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80137a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801381:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801388:	84 c0                	test   %al,%al
  80138a:	74 20                	je     8013ac <snprintf+0x51>
  80138c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801390:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801394:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801398:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80139c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013a0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013a4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8013a8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8013ac:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8013b3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8013ba:	00 00 00 
  8013bd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8013c4:	00 00 00 
  8013c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8013cb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8013d2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8013d9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8013e0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8013e7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8013ee:	48 8b 0a             	mov    (%rdx),%rcx
  8013f1:	48 89 08             	mov    %rcx,(%rax)
  8013f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801400:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801404:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80140b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801412:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801418:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80141f:	48 89 c7             	mov    %rax,%rdi
  801422:	48 b8 be 12 80 00 00 	movabs $0x8012be,%rax
  801429:	00 00 00 
  80142c:	ff d0                	callq  *%rax
  80142e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801434:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80143a:	c9                   	leaveq 
  80143b:	c3                   	retq   

000000000080143c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80143c:	55                   	push   %rbp
  80143d:	48 89 e5             	mov    %rsp,%rbp
  801440:	48 83 ec 18          	sub    $0x18,%rsp
  801444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80144f:	eb 09                	jmp    80145a <strlen+0x1e>
		n++;
  801451:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801455:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80145a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	84 c0                	test   %al,%al
  801463:	75 ec                	jne    801451 <strlen+0x15>
		n++;
	return n;
  801465:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 20          	sub    $0x20,%rsp
  801472:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801476:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80147a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801481:	eb 0e                	jmp    801491 <strnlen+0x27>
		n++;
  801483:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801487:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80148c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801491:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801496:	74 0b                	je     8014a3 <strnlen+0x39>
  801498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 e0                	jne    801483 <strnlen+0x19>
		n++;
	return n;
  8014a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014a6:	c9                   	leaveq 
  8014a7:	c3                   	retq   

00000000008014a8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014a8:	55                   	push   %rbp
  8014a9:	48 89 e5             	mov    %rsp,%rbp
  8014ac:	48 83 ec 20          	sub    $0x20,%rsp
  8014b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014c0:	90                   	nop
  8014c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014d1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014d5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014d9:	0f b6 12             	movzbl (%rdx),%edx
  8014dc:	88 10                	mov    %dl,(%rax)
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 dc                	jne    8014c1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 20          	sub    $0x20,%rsp
  8014f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ff:	48 89 c7             	mov    %rax,%rdi
  801502:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  801509:	00 00 00 
  80150c:	ff d0                	callq  *%rax
  80150e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801514:	48 63 d0             	movslq %eax,%rdx
  801517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151b:	48 01 c2             	add    %rax,%rdx
  80151e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801522:	48 89 c6             	mov    %rax,%rsi
  801525:	48 89 d7             	mov    %rdx,%rdi
  801528:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  80152f:	00 00 00 
  801532:	ff d0                	callq  *%rax
	return dst;
  801534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	48 83 ec 28          	sub    $0x28,%rsp
  801542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801546:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80154a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80154e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801556:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80155d:	00 
  80155e:	eb 2a                	jmp    80158a <strncpy+0x50>
		*dst++ = *src;
  801560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801564:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801568:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80156c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801570:	0f b6 12             	movzbl (%rdx),%edx
  801573:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801575:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	84 c0                	test   %al,%al
  80157e:	74 05                	je     801585 <strncpy+0x4b>
			src++;
  801580:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801585:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801592:	72 cc                	jb     801560 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801598:	c9                   	leaveq 
  801599:	c3                   	retq   

000000000080159a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80159a:	55                   	push   %rbp
  80159b:	48 89 e5             	mov    %rsp,%rbp
  80159e:	48 83 ec 28          	sub    $0x28,%rsp
  8015a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8015ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8015b6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015bb:	74 3d                	je     8015fa <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8015bd:	eb 1d                	jmp    8015dc <strlcpy+0x42>
			*dst++ = *src++;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015cf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8015d3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8015d7:	0f b6 12             	movzbl (%rdx),%edx
  8015da:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015dc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015e6:	74 0b                	je     8015f3 <strlcpy+0x59>
  8015e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	84 c0                	test   %al,%al
  8015f1:	75 cc                	jne    8015bf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801602:	48 29 c2             	sub    %rax,%rdx
  801605:	48 89 d0             	mov    %rdx,%rax
}
  801608:	c9                   	leaveq 
  801609:	c3                   	retq   

000000000080160a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80160a:	55                   	push   %rbp
  80160b:	48 89 e5             	mov    %rsp,%rbp
  80160e:	48 83 ec 10          	sub    $0x10,%rsp
  801612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801616:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80161a:	eb 0a                	jmp    801626 <strcmp+0x1c>
		p++, q++;
  80161c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801621:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	84 c0                	test   %al,%al
  80162f:	74 12                	je     801643 <strcmp+0x39>
  801631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801635:	0f b6 10             	movzbl (%rax),%edx
  801638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	38 c2                	cmp    %al,%dl
  801641:	74 d9                	je     80161c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801643:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	0f b6 d0             	movzbl %al,%edx
  80164d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801651:	0f b6 00             	movzbl (%rax),%eax
  801654:	0f b6 c0             	movzbl %al,%eax
  801657:	29 c2                	sub    %eax,%edx
  801659:	89 d0                	mov    %edx,%eax
}
  80165b:	c9                   	leaveq 
  80165c:	c3                   	retq   

000000000080165d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80165d:	55                   	push   %rbp
  80165e:	48 89 e5             	mov    %rsp,%rbp
  801661:	48 83 ec 18          	sub    $0x18,%rsp
  801665:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801669:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80166d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801671:	eb 0f                	jmp    801682 <strncmp+0x25>
		n--, p++, q++;
  801673:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801678:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80167d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801682:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801687:	74 1d                	je     8016a6 <strncmp+0x49>
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	84 c0                	test   %al,%al
  801692:	74 12                	je     8016a6 <strncmp+0x49>
  801694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801698:	0f b6 10             	movzbl (%rax),%edx
  80169b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	38 c2                	cmp    %al,%dl
  8016a4:	74 cd                	je     801673 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8016a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016ab:	75 07                	jne    8016b4 <strncmp+0x57>
		return 0;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	eb 18                	jmp    8016cc <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	0f b6 d0             	movzbl %al,%edx
  8016be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	0f b6 c0             	movzbl %al,%eax
  8016c8:	29 c2                	sub    %eax,%edx
  8016ca:	89 d0                	mov    %edx,%eax
}
  8016cc:	c9                   	leaveq 
  8016cd:	c3                   	retq   

00000000008016ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016ce:	55                   	push   %rbp
  8016cf:	48 89 e5             	mov    %rsp,%rbp
  8016d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8016d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016da:	89 f0                	mov    %esi,%eax
  8016dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016df:	eb 17                	jmp    8016f8 <strchr+0x2a>
		if (*s == c)
  8016e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016eb:	75 06                	jne    8016f3 <strchr+0x25>
			return (char *) s;
  8016ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f1:	eb 15                	jmp    801708 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	84 c0                	test   %al,%al
  801701:	75 de                	jne    8016e1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801708:	c9                   	leaveq 
  801709:	c3                   	retq   

000000000080170a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	48 83 ec 0c          	sub    $0xc,%rsp
  801712:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801716:	89 f0                	mov    %esi,%eax
  801718:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80171b:	eb 13                	jmp    801730 <strfind+0x26>
		if (*s == c)
  80171d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801727:	75 02                	jne    80172b <strfind+0x21>
			break;
  801729:	eb 10                	jmp    80173b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80172b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	84 c0                	test   %al,%al
  801739:	75 e2                	jne    80171d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80173b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 18          	sub    $0x18,%rsp
  801749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80174d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801750:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801754:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801759:	75 06                	jne    801761 <memset+0x20>
		return v;
  80175b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175f:	eb 69                	jmp    8017ca <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801761:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801765:	83 e0 03             	and    $0x3,%eax
  801768:	48 85 c0             	test   %rax,%rax
  80176b:	75 48                	jne    8017b5 <memset+0x74>
  80176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801771:	83 e0 03             	and    $0x3,%eax
  801774:	48 85 c0             	test   %rax,%rax
  801777:	75 3c                	jne    8017b5 <memset+0x74>
		c &= 0xFF;
  801779:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801780:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801783:	c1 e0 18             	shl    $0x18,%eax
  801786:	89 c2                	mov    %eax,%edx
  801788:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80178b:	c1 e0 10             	shl    $0x10,%eax
  80178e:	09 c2                	or     %eax,%edx
  801790:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801793:	c1 e0 08             	shl    $0x8,%eax
  801796:	09 d0                	or     %edx,%eax
  801798:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80179b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179f:	48 c1 e8 02          	shr    $0x2,%rax
  8017a3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017ad:	48 89 d7             	mov    %rdx,%rdi
  8017b0:	fc                   	cld    
  8017b1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8017b3:	eb 11                	jmp    8017c6 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017c0:	48 89 d7             	mov    %rdx,%rdi
  8017c3:	fc                   	cld    
  8017c4:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8017c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017ca:	c9                   	leaveq 
  8017cb:	c3                   	retq   

00000000008017cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	48 83 ec 28          	sub    $0x28,%rsp
  8017d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017f8:	0f 83 88 00 00 00    	jae    801886 <memmove+0xba>
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801806:	48 01 d0             	add    %rdx,%rax
  801809:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80180d:	76 77                	jbe    801886 <memmove+0xba>
		s += n;
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80181f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801823:	83 e0 03             	and    $0x3,%eax
  801826:	48 85 c0             	test   %rax,%rax
  801829:	75 3b                	jne    801866 <memmove+0x9a>
  80182b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182f:	83 e0 03             	and    $0x3,%eax
  801832:	48 85 c0             	test   %rax,%rax
  801835:	75 2f                	jne    801866 <memmove+0x9a>
  801837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183b:	83 e0 03             	and    $0x3,%eax
  80183e:	48 85 c0             	test   %rax,%rax
  801841:	75 23                	jne    801866 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801843:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801847:	48 83 e8 04          	sub    $0x4,%rax
  80184b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80184f:	48 83 ea 04          	sub    $0x4,%rdx
  801853:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801857:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80185b:	48 89 c7             	mov    %rax,%rdi
  80185e:	48 89 d6             	mov    %rdx,%rsi
  801861:	fd                   	std    
  801862:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801864:	eb 1d                	jmp    801883 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80186e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801872:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	48 89 d7             	mov    %rdx,%rdi
  80187d:	48 89 c1             	mov    %rax,%rcx
  801880:	fd                   	std    
  801881:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801883:	fc                   	cld    
  801884:	eb 57                	jmp    8018dd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188a:	83 e0 03             	and    $0x3,%eax
  80188d:	48 85 c0             	test   %rax,%rax
  801890:	75 36                	jne    8018c8 <memmove+0xfc>
  801892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801896:	83 e0 03             	and    $0x3,%eax
  801899:	48 85 c0             	test   %rax,%rax
  80189c:	75 2a                	jne    8018c8 <memmove+0xfc>
  80189e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a2:	83 e0 03             	and    $0x3,%eax
  8018a5:	48 85 c0             	test   %rax,%rax
  8018a8:	75 1e                	jne    8018c8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ae:	48 c1 e8 02          	shr    $0x2,%rax
  8018b2:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8018b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018bd:	48 89 c7             	mov    %rax,%rdi
  8018c0:	48 89 d6             	mov    %rdx,%rsi
  8018c3:	fc                   	cld    
  8018c4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018c6:	eb 15                	jmp    8018dd <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018d4:	48 89 c7             	mov    %rax,%rdi
  8018d7:	48 89 d6             	mov    %rdx,%rsi
  8018da:	fc                   	cld    
  8018db:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 18          	sub    $0x18,%rsp
  8018eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018fb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801903:	48 89 ce             	mov    %rcx,%rsi
  801906:	48 89 c7             	mov    %rax,%rdi
  801909:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801910:	00 00 00 
  801913:	ff d0                	callq  *%rax
}
  801915:	c9                   	leaveq 
  801916:	c3                   	retq   

0000000000801917 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801917:	55                   	push   %rbp
  801918:	48 89 e5             	mov    %rsp,%rbp
  80191b:	48 83 ec 28          	sub    $0x28,%rsp
  80191f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801923:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801927:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80192b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801933:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801937:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80193b:	eb 36                	jmp    801973 <memcmp+0x5c>
		if (*s1 != *s2)
  80193d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801941:	0f b6 10             	movzbl (%rax),%edx
  801944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801948:	0f b6 00             	movzbl (%rax),%eax
  80194b:	38 c2                	cmp    %al,%dl
  80194d:	74 1a                	je     801969 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80194f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801953:	0f b6 00             	movzbl (%rax),%eax
  801956:	0f b6 d0             	movzbl %al,%edx
  801959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195d:	0f b6 00             	movzbl (%rax),%eax
  801960:	0f b6 c0             	movzbl %al,%eax
  801963:	29 c2                	sub    %eax,%edx
  801965:	89 d0                	mov    %edx,%eax
  801967:	eb 20                	jmp    801989 <memcmp+0x72>
		s1++, s2++;
  801969:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80196e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801977:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80197b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80197f:	48 85 c0             	test   %rax,%rax
  801982:	75 b9                	jne    80193d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801989:	c9                   	leaveq 
  80198a:	c3                   	retq   

000000000080198b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80198b:	55                   	push   %rbp
  80198c:	48 89 e5             	mov    %rsp,%rbp
  80198f:	48 83 ec 28          	sub    $0x28,%rsp
  801993:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801997:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80199a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a6:	48 01 d0             	add    %rdx,%rax
  8019a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8019ad:	eb 15                	jmp    8019c4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b3:	0f b6 10             	movzbl (%rax),%edx
  8019b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019b9:	38 c2                	cmp    %al,%dl
  8019bb:	75 02                	jne    8019bf <memfind+0x34>
			break;
  8019bd:	eb 0f                	jmp    8019ce <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019cc:	72 e1                	jb     8019af <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8019ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d2:	c9                   	leaveq 
  8019d3:	c3                   	retq   

00000000008019d4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019d4:	55                   	push   %rbp
  8019d5:	48 89 e5             	mov    %rsp,%rbp
  8019d8:	48 83 ec 34          	sub    $0x34,%rsp
  8019dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019e4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019ee:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019f5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019f6:	eb 05                	jmp    8019fd <strtol+0x29>
		s++;
  8019f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	0f b6 00             	movzbl (%rax),%eax
  801a04:	3c 20                	cmp    $0x20,%al
  801a06:	74 f0                	je     8019f8 <strtol+0x24>
  801a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	3c 09                	cmp    $0x9,%al
  801a11:	74 e5                	je     8019f8 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	3c 2b                	cmp    $0x2b,%al
  801a1c:	75 07                	jne    801a25 <strtol+0x51>
		s++;
  801a1e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a23:	eb 17                	jmp    801a3c <strtol+0x68>
	else if (*s == '-')
  801a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a29:	0f b6 00             	movzbl (%rax),%eax
  801a2c:	3c 2d                	cmp    $0x2d,%al
  801a2e:	75 0c                	jne    801a3c <strtol+0x68>
		s++, neg = 1;
  801a30:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a35:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a3c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a40:	74 06                	je     801a48 <strtol+0x74>
  801a42:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a46:	75 28                	jne    801a70 <strtol+0x9c>
  801a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	3c 30                	cmp    $0x30,%al
  801a51:	75 1d                	jne    801a70 <strtol+0x9c>
  801a53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a57:	48 83 c0 01          	add    $0x1,%rax
  801a5b:	0f b6 00             	movzbl (%rax),%eax
  801a5e:	3c 78                	cmp    $0x78,%al
  801a60:	75 0e                	jne    801a70 <strtol+0x9c>
		s += 2, base = 16;
  801a62:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a67:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a6e:	eb 2c                	jmp    801a9c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a70:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a74:	75 19                	jne    801a8f <strtol+0xbb>
  801a76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7a:	0f b6 00             	movzbl (%rax),%eax
  801a7d:	3c 30                	cmp    $0x30,%al
  801a7f:	75 0e                	jne    801a8f <strtol+0xbb>
		s++, base = 8;
  801a81:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a86:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a8d:	eb 0d                	jmp    801a9c <strtol+0xc8>
	else if (base == 0)
  801a8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a93:	75 07                	jne    801a9c <strtol+0xc8>
		base = 10;
  801a95:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa0:	0f b6 00             	movzbl (%rax),%eax
  801aa3:	3c 2f                	cmp    $0x2f,%al
  801aa5:	7e 1d                	jle    801ac4 <strtol+0xf0>
  801aa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aab:	0f b6 00             	movzbl (%rax),%eax
  801aae:	3c 39                	cmp    $0x39,%al
  801ab0:	7f 12                	jg     801ac4 <strtol+0xf0>
			dig = *s - '0';
  801ab2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab6:	0f b6 00             	movzbl (%rax),%eax
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 30             	sub    $0x30,%eax
  801abf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ac2:	eb 4e                	jmp    801b12 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac8:	0f b6 00             	movzbl (%rax),%eax
  801acb:	3c 60                	cmp    $0x60,%al
  801acd:	7e 1d                	jle    801aec <strtol+0x118>
  801acf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad3:	0f b6 00             	movzbl (%rax),%eax
  801ad6:	3c 7a                	cmp    $0x7a,%al
  801ad8:	7f 12                	jg     801aec <strtol+0x118>
			dig = *s - 'a' + 10;
  801ada:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ade:	0f b6 00             	movzbl (%rax),%eax
  801ae1:	0f be c0             	movsbl %al,%eax
  801ae4:	83 e8 57             	sub    $0x57,%eax
  801ae7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aea:	eb 26                	jmp    801b12 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af0:	0f b6 00             	movzbl (%rax),%eax
  801af3:	3c 40                	cmp    $0x40,%al
  801af5:	7e 48                	jle    801b3f <strtol+0x16b>
  801af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afb:	0f b6 00             	movzbl (%rax),%eax
  801afe:	3c 5a                	cmp    $0x5a,%al
  801b00:	7f 3d                	jg     801b3f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b06:	0f b6 00             	movzbl (%rax),%eax
  801b09:	0f be c0             	movsbl %al,%eax
  801b0c:	83 e8 37             	sub    $0x37,%eax
  801b0f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b15:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b18:	7c 02                	jl     801b1c <strtol+0x148>
			break;
  801b1a:	eb 23                	jmp    801b3f <strtol+0x16b>
		s++, val = (val * base) + dig;
  801b1c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b21:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b24:	48 98                	cltq   
  801b26:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801b2b:	48 89 c2             	mov    %rax,%rdx
  801b2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b31:	48 98                	cltq   
  801b33:	48 01 d0             	add    %rdx,%rax
  801b36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b3a:	e9 5d ff ff ff       	jmpq   801a9c <strtol+0xc8>

	if (endptr)
  801b3f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b44:	74 0b                	je     801b51 <strtol+0x17d>
		*endptr = (char *) s;
  801b46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b4e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b55:	74 09                	je     801b60 <strtol+0x18c>
  801b57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5b:	48 f7 d8             	neg    %rax
  801b5e:	eb 04                	jmp    801b64 <strtol+0x190>
  801b60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b64:	c9                   	leaveq 
  801b65:	c3                   	retq   

0000000000801b66 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b66:	55                   	push   %rbp
  801b67:	48 89 e5             	mov    %rsp,%rbp
  801b6a:	48 83 ec 30          	sub    $0x30,%rsp
  801b6e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b72:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801b76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b7a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b7e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b82:	0f b6 00             	movzbl (%rax),%eax
  801b85:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801b88:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b8c:	75 06                	jne    801b94 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801b8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b92:	eb 6b                	jmp    801bff <strstr+0x99>

    len = strlen(str);
  801b94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b98:	48 89 c7             	mov    %rax,%rdi
  801b9b:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
  801ba7:	48 98                	cltq   
  801ba9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801bad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bb5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bb9:	0f b6 00             	movzbl (%rax),%eax
  801bbc:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801bbf:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801bc3:	75 07                	jne    801bcc <strstr+0x66>
                return (char *) 0;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bca:	eb 33                	jmp    801bff <strstr+0x99>
        } while (sc != c);
  801bcc:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801bd0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bd3:	75 d8                	jne    801bad <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801bd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be1:	48 89 ce             	mov    %rcx,%rsi
  801be4:	48 89 c7             	mov    %rax,%rdi
  801be7:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801bee:	00 00 00 
  801bf1:	ff d0                	callq  *%rax
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	75 b6                	jne    801bad <strstr+0x47>

    return (char *) (in - 1);
  801bf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfb:	48 83 e8 01          	sub    $0x1,%rax
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	53                   	push   %rbx
  801c06:	48 83 ec 48          	sub    $0x48,%rsp
  801c0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c0d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c10:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c14:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c18:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c1c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c23:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c27:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c2b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c2f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c33:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c37:	4c 89 c3             	mov    %r8,%rbx
  801c3a:	cd 30                	int    $0x30
  801c3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801c40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c44:	74 3e                	je     801c84 <syscall+0x83>
  801c46:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c4b:	7e 37                	jle    801c84 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c54:	49 89 d0             	mov    %rdx,%r8
  801c57:	89 c1                	mov    %eax,%ecx
  801c59:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801c60:	00 00 00 
  801c63:	be 23 00 00 00       	mov    $0x23,%esi
  801c68:	48 bf 7d 44 80 00 00 	movabs $0x80447d,%rdi
  801c6f:	00 00 00 
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
  801c77:	49 b9 c7 04 80 00 00 	movabs $0x8004c7,%r9
  801c7e:	00 00 00 
  801c81:	41 ff d1             	callq  *%r9

	return ret;
  801c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c88:	48 83 c4 48          	add    $0x48,%rsp
  801c8c:	5b                   	pop    %rbx
  801c8d:	5d                   	pop    %rbp
  801c8e:	c3                   	retq   

0000000000801c8f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c8f:	55                   	push   %rbp
  801c90:	48 89 e5             	mov    %rsp,%rbp
  801c93:	48 83 ec 20          	sub    $0x20,%rsp
  801c97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cae:	00 
  801caf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbb:	48 89 d1             	mov    %rdx,%rcx
  801cbe:	48 89 c2             	mov    %rax,%rdx
  801cc1:	be 00 00 00 00       	mov    $0x0,%esi
  801cc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ccb:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
}
  801cd7:	c9                   	leaveq 
  801cd8:	c3                   	retq   

0000000000801cd9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ce1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce8:	00 
  801ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801cff:	be 00 00 00 00       	mov    $0x0,%esi
  801d04:	bf 01 00 00 00       	mov    $0x1,%edi
  801d09:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 10          	sub    $0x10,%rsp
  801d1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d25:	48 98                	cltq   
  801d27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2e:	00 
  801d2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d40:	48 89 c2             	mov    %rax,%rdx
  801d43:	be 01 00 00 00       	mov    $0x1,%esi
  801d48:	bf 03 00 00 00       	mov    $0x3,%edi
  801d4d:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	callq  *%rax
}
  801d59:	c9                   	leaveq 
  801d5a:	c3                   	retq   

0000000000801d5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d5b:	55                   	push   %rbp
  801d5c:	48 89 e5             	mov    %rsp,%rbp
  801d5f:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6a:	00 
  801d6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d81:	be 00 00 00 00       	mov    $0x0,%esi
  801d86:	bf 02 00 00 00       	mov    $0x2,%edi
  801d8b:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <sys_yield>:

void
sys_yield(void)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801da1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da8:	00 
  801da9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dba:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	bf 0b 00 00 00       	mov    $0xb,%edi
  801dc9:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 20          	sub    $0x20,%rsp
  801ddf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801de6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801de9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dec:	48 63 c8             	movslq %eax,%rcx
  801def:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df6:	48 98                	cltq   
  801df8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dff:	00 
  801e00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e06:	49 89 c8             	mov    %rcx,%r8
  801e09:	48 89 d1             	mov    %rdx,%rcx
  801e0c:	48 89 c2             	mov    %rax,%rdx
  801e0f:	be 01 00 00 00       	mov    $0x1,%esi
  801e14:	bf 04 00 00 00       	mov    $0x4,%edi
  801e19:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801e20:	00 00 00 
  801e23:	ff d0                	callq  *%rax
}
  801e25:	c9                   	leaveq 
  801e26:	c3                   	retq   

0000000000801e27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
  801e2b:	48 83 ec 30          	sub    $0x30,%rsp
  801e2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e36:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e39:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e3d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e44:	48 63 c8             	movslq %eax,%rcx
  801e47:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e4b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e4e:	48 63 f0             	movslq %eax,%rsi
  801e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e58:	48 98                	cltq   
  801e5a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e5e:	49 89 f9             	mov    %rdi,%r9
  801e61:	49 89 f0             	mov    %rsi,%r8
  801e64:	48 89 d1             	mov    %rdx,%rcx
  801e67:	48 89 c2             	mov    %rax,%rdx
  801e6a:	be 01 00 00 00       	mov    $0x1,%esi
  801e6f:	bf 05 00 00 00       	mov    $0x5,%edi
  801e74:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801e7b:	00 00 00 
  801e7e:	ff d0                	callq  *%rax
}
  801e80:	c9                   	leaveq 
  801e81:	c3                   	retq   

0000000000801e82 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e82:	55                   	push   %rbp
  801e83:	48 89 e5             	mov    %rsp,%rbp
  801e86:	48 83 ec 20          	sub    $0x20,%rsp
  801e8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e98:	48 98                	cltq   
  801e9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea1:	00 
  801ea2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eae:	48 89 d1             	mov    %rdx,%rcx
  801eb1:	48 89 c2             	mov    %rax,%rdx
  801eb4:	be 01 00 00 00       	mov    $0x1,%esi
  801eb9:	bf 06 00 00 00       	mov    $0x6,%edi
  801ebe:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
}
  801eca:	c9                   	leaveq 
  801ecb:	c3                   	retq   

0000000000801ecc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ecc:	55                   	push   %rbp
  801ecd:	48 89 e5             	mov    %rsp,%rbp
  801ed0:	48 83 ec 10          	sub    $0x10,%rsp
  801ed4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ed7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801eda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801edd:	48 63 d0             	movslq %eax,%rdx
  801ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee3:	48 98                	cltq   
  801ee5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eec:	00 
  801eed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef9:	48 89 d1             	mov    %rdx,%rcx
  801efc:	48 89 c2             	mov    %rax,%rdx
  801eff:	be 01 00 00 00       	mov    $0x1,%esi
  801f04:	bf 08 00 00 00       	mov    $0x8,%edi
  801f09:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
}
  801f15:	c9                   	leaveq 
  801f16:	c3                   	retq   

0000000000801f17 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f17:	55                   	push   %rbp
  801f18:	48 89 e5             	mov    %rsp,%rbp
  801f1b:	48 83 ec 20          	sub    $0x20,%rsp
  801f1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2d:	48 98                	cltq   
  801f2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f36:	00 
  801f37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f43:	48 89 d1             	mov    %rdx,%rcx
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	be 01 00 00 00       	mov    $0x1,%esi
  801f4e:	bf 09 00 00 00       	mov    $0x9,%edi
  801f53:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	callq  *%rax
}
  801f5f:	c9                   	leaveq 
  801f60:	c3                   	retq   

0000000000801f61 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f61:	55                   	push   %rbp
  801f62:	48 89 e5             	mov    %rsp,%rbp
  801f65:	48 83 ec 20          	sub    $0x20,%rsp
  801f69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f77:	48 98                	cltq   
  801f79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f80:	00 
  801f81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f8d:	48 89 d1             	mov    %rdx,%rcx
  801f90:	48 89 c2             	mov    %rax,%rdx
  801f93:	be 01 00 00 00       	mov    $0x1,%esi
  801f98:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f9d:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801fa4:	00 00 00 
  801fa7:	ff d0                	callq  *%rax
}
  801fa9:	c9                   	leaveq 
  801faa:	c3                   	retq   

0000000000801fab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
  801faf:	48 83 ec 20          	sub    $0x20,%rsp
  801fb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801fbe:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801fc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fc4:	48 63 f0             	movslq %eax,%rsi
  801fc7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fce:	48 98                	cltq   
  801fd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fdb:	00 
  801fdc:	49 89 f1             	mov    %rsi,%r9
  801fdf:	49 89 c8             	mov    %rcx,%r8
  801fe2:	48 89 d1             	mov    %rdx,%rcx
  801fe5:	48 89 c2             	mov    %rax,%rdx
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
  801fed:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ff2:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
}
  801ffe:	c9                   	leaveq 
  801fff:	c3                   	retq   

0000000000802000 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802000:	55                   	push   %rbp
  802001:	48 89 e5             	mov    %rsp,%rbp
  802004:	48 83 ec 10          	sub    $0x10,%rsp
  802008:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80200c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802010:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802017:	00 
  802018:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802024:	b9 00 00 00 00       	mov    $0x0,%ecx
  802029:	48 89 c2             	mov    %rax,%rdx
  80202c:	be 01 00 00 00       	mov    $0x1,%esi
  802031:	bf 0d 00 00 00       	mov    $0xd,%edi
  802036:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  80203d:	00 00 00 
  802040:	ff d0                	callq  *%rax
}
  802042:	c9                   	leaveq 
  802043:	c3                   	retq   

0000000000802044 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	48 83 ec 30          	sub    $0x30,%rsp
  80204c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802054:	48 8b 00             	mov    (%rax),%rax
  802057:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80205b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802063:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  802066:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802069:	83 e0 02             	and    $0x2,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 23                	je     802093 <pgfault+0x4f>
  802070:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802074:	48 c1 e8 0c          	shr    $0xc,%rax
  802078:	48 89 c2             	mov    %rax,%rdx
  80207b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802082:	01 00 00 
  802085:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802089:	25 00 08 00 00       	and    $0x800,%eax
  80208e:	48 85 c0             	test   %rax,%rax
  802091:	75 2a                	jne    8020bd <pgfault+0x79>
		panic("fail check at fork pgfault");
  802093:	48 ba 8b 44 80 00 00 	movabs $0x80448b,%rdx
  80209a:	00 00 00 
  80209d:	be 1d 00 00 00       	mov    $0x1d,%esi
  8020a2:	48 bf a6 44 80 00 00 	movabs $0x8044a6,%rdi
  8020a9:	00 00 00 
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  8020b8:	00 00 00 
  8020bb:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8020bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8020c2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020cc:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  8020d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8020e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8020ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  8020ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020f7:	48 89 c6             	mov    %rax,%rsi
  8020fa:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8020ff:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  80210b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802115:	48 89 c1             	mov    %rax,%rcx
  802118:	ba 00 00 00 00       	mov    $0x0,%edx
  80211d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802122:	bf 00 00 00 00       	mov    $0x0,%edi
  802127:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  802133:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802138:	bf 00 00 00 00       	mov    $0x0,%edi
  80213d:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  802149:	c9                   	leaveq 
  80214a:	c3                   	retq   

000000000080214b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80214b:	55                   	push   %rbp
  80214c:	48 89 e5             	mov    %rsp,%rbp
  80214f:	48 83 ec 20          	sub    $0x20,%rsp
  802153:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802156:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  802159:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80215c:	48 c1 e0 0c          	shl    $0xc,%rax
  802160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  802164:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80216b:	01 00 00 
  80216e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802175:	25 00 04 00 00       	and    $0x400,%eax
  80217a:	48 85 c0             	test   %rax,%rax
  80217d:	74 55                	je     8021d4 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  80217f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802186:	01 00 00 
  802189:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80218c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802190:	25 07 0e 00 00       	and    $0xe07,%eax
  802195:	89 c6                	mov    %eax,%esi
  802197:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80219b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80219e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a2:	41 89 f0             	mov    %esi,%r8d
  8021a5:	48 89 c6             	mov    %rax,%rsi
  8021a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ad:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
  8021b9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8021bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021c0:	79 08                	jns    8021ca <duppage+0x7f>
			return r;
  8021c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021c5:	e9 e1 00 00 00       	jmpq   8022ab <duppage+0x160>
		return 0;
  8021ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cf:	e9 d7 00 00 00       	jmpq   8022ab <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8021d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021db:	01 00 00 
  8021de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e5:	25 05 06 00 00       	and    $0x605,%eax
  8021ea:	80 cc 08             	or     $0x8,%ah
  8021ed:	89 c6                	mov    %eax,%esi
  8021ef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8021f3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fa:	41 89 f0             	mov    %esi,%r8d
  8021fd:	48 89 c6             	mov    %rax,%rsi
  802200:	bf 00 00 00 00       	mov    $0x0,%edi
  802205:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax
  802211:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802218:	79 08                	jns    802222 <duppage+0xd7>
		return r;
  80221a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80221d:	e9 89 00 00 00       	jmpq   8022ab <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  802222:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802229:	01 00 00 
  80222c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80222f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802233:	83 e0 02             	and    $0x2,%eax
  802236:	48 85 c0             	test   %rax,%rax
  802239:	75 1b                	jne    802256 <duppage+0x10b>
  80223b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802242:	01 00 00 
  802245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802248:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224c:	25 00 08 00 00       	and    $0x800,%eax
  802251:	48 85 c0             	test   %rax,%rax
  802254:	74 50                	je     8022a6 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  802256:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80225d:	01 00 00 
  802260:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802263:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802267:	25 05 06 00 00       	and    $0x605,%eax
  80226c:	80 cc 08             	or     $0x8,%ah
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802279:	41 89 c8             	mov    %ecx,%r8d
  80227c:	48 89 d1             	mov    %rdx,%rcx
  80227f:	ba 00 00 00 00       	mov    $0x0,%edx
  802284:	48 89 c6             	mov    %rax,%rsi
  802287:	bf 00 00 00 00       	mov    $0x0,%edi
  80228c:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  802293:	00 00 00 
  802296:	ff d0                	callq  *%rax
  802298:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80229f:	79 05                	jns    8022a6 <duppage+0x15b>
			return r;
  8022a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022a4:	eb 05                	jmp    8022ab <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ab:	c9                   	leaveq 
  8022ac:	c3                   	retq   

00000000008022ad <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8022ad:	55                   	push   %rbp
  8022ae:	48 89 e5             	mov    %rsp,%rbp
  8022b1:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  8022b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  8022bc:	48 bf 44 20 80 00 00 	movabs $0x802044,%rdi
  8022c3:	00 00 00 
  8022c6:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8022d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8022d7:	cd 30                	int    $0x30
  8022d9:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8022dc:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  8022df:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8022e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8022e6:	79 08                	jns    8022f0 <fork+0x43>
		return envid;
  8022e8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022eb:	e9 27 02 00 00       	jmpq   802517 <fork+0x26a>
	else if (envid == 0) {
  8022f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8022f4:	75 46                	jne    80233c <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022f6:	48 b8 5b 1d 80 00 00 	movabs $0x801d5b,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax
  802302:	25 ff 03 00 00       	and    $0x3ff,%eax
  802307:	48 63 d0             	movslq %eax,%rdx
  80230a:	48 89 d0             	mov    %rdx,%rax
  80230d:	48 c1 e0 03          	shl    $0x3,%rax
  802311:	48 01 d0             	add    %rdx,%rax
  802314:	48 c1 e0 05          	shl    $0x5,%rax
  802318:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80231f:	00 00 00 
  802322:	48 01 c2             	add    %rax,%rdx
  802325:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80232c:	00 00 00 
  80232f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
  802337:	e9 db 01 00 00       	jmpq   802517 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80233c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80233f:	ba 07 00 00 00       	mov    $0x7,%edx
  802344:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802349:	89 c7                	mov    %eax,%edi
  80234b:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  802352:	00 00 00 
  802355:	ff d0                	callq  *%rax
  802357:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80235a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80235e:	79 08                	jns    802368 <fork+0xbb>
		return r;
  802360:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802363:	e9 af 01 00 00       	jmpq   802517 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80236f:	e9 49 01 00 00       	jmpq   8024bd <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802374:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802377:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  80237d:	85 c0                	test   %eax,%eax
  80237f:	0f 48 c2             	cmovs  %edx,%eax
  802382:	c1 f8 1b             	sar    $0x1b,%eax
  802385:	89 c2                	mov    %eax,%edx
  802387:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80238e:	01 00 00 
  802391:	48 63 d2             	movslq %edx,%rdx
  802394:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802398:	83 e0 01             	and    $0x1,%eax
  80239b:	48 85 c0             	test   %rax,%rax
  80239e:	75 0c                	jne    8023ac <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8023a0:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  8023a7:	e9 0d 01 00 00       	jmpq   8024b9 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8023ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8023b3:	e9 f4 00 00 00       	jmpq   8024ac <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8023b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023bb:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	0f 48 c2             	cmovs  %edx,%eax
  8023c6:	c1 f8 12             	sar    $0x12,%eax
  8023c9:	89 c2                	mov    %eax,%edx
  8023cb:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023d2:	01 00 00 
  8023d5:	48 63 d2             	movslq %edx,%rdx
  8023d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023dc:	83 e0 01             	and    $0x1,%eax
  8023df:	48 85 c0             	test   %rax,%rax
  8023e2:	75 0c                	jne    8023f0 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  8023e4:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  8023eb:	e9 b8 00 00 00       	jmpq   8024a8 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8023f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8023f7:	e9 9f 00 00 00       	jmpq   80249b <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  8023fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023ff:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802405:	85 c0                	test   %eax,%eax
  802407:	0f 48 c2             	cmovs  %edx,%eax
  80240a:	c1 f8 09             	sar    $0x9,%eax
  80240d:	89 c2                	mov    %eax,%edx
  80240f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802416:	01 00 00 
  802419:	48 63 d2             	movslq %edx,%rdx
  80241c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802420:	83 e0 01             	and    $0x1,%eax
  802423:	48 85 c0             	test   %rax,%rax
  802426:	75 09                	jne    802431 <fork+0x184>
					ptx += NPTENTRIES;
  802428:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  80242f:	eb 66                	jmp    802497 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802438:	eb 54                	jmp    80248e <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  80243a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802441:	01 00 00 
  802444:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802447:	48 63 d2             	movslq %edx,%rdx
  80244a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244e:	83 e0 01             	and    $0x1,%eax
  802451:	48 85 c0             	test   %rax,%rax
  802454:	74 30                	je     802486 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802456:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80245d:	74 27                	je     802486 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80245f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802462:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802465:	89 d6                	mov    %edx,%esi
  802467:	89 c7                	mov    %eax,%edi
  802469:	48 b8 4b 21 80 00 00 	movabs $0x80214b,%rax
  802470:	00 00 00 
  802473:	ff d0                	callq  *%rax
  802475:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802478:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80247c:	79 08                	jns    802486 <fork+0x1d9>
								return r;
  80247e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802481:	e9 91 00 00 00       	jmpq   802517 <fork+0x26a>
					ptx++;
  802486:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80248a:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80248e:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  802495:	7e a3                	jle    80243a <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802497:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80249b:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8024a2:	0f 8e 54 ff ff ff    	jle    8023fc <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8024a8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8024ac:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8024b3:	0f 8e ff fe ff ff    	jle    8023b8 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8024b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c1:	0f 84 ad fe ff ff    	je     802374 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8024c7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8024ca:	48 be ae 3b 80 00 00 	movabs $0x803bae,%rsi
  8024d1:	00 00 00 
  8024d4:	89 c7                	mov    %eax,%edi
  8024d6:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8024dd:	00 00 00 
  8024e0:	ff d0                	callq  *%rax
  8024e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8024e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8024e9:	79 05                	jns    8024f0 <fork+0x243>
		return r;
  8024eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024ee:	eb 27                	jmp    802517 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8024f0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8024f3:	be 02 00 00 00       	mov    $0x2,%esi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 cc 1e 80 00 00 	movabs $0x801ecc,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80250d:	79 05                	jns    802514 <fork+0x267>
		return r;
  80250f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802512:	eb 03                	jmp    802517 <fork+0x26a>

	return envid;
  802514:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802517:	c9                   	leaveq 
  802518:	c3                   	retq   

0000000000802519 <sfork>:

// Challenge!
int
sfork(void)
{
  802519:	55                   	push   %rbp
  80251a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80251d:	48 ba b1 44 80 00 00 	movabs $0x8044b1,%rdx
  802524:	00 00 00 
  802527:	be a7 00 00 00       	mov    $0xa7,%esi
  80252c:	48 bf a6 44 80 00 00 	movabs $0x8044a6,%rdi
  802533:	00 00 00 
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
  80253b:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  802542:	00 00 00 
  802545:	ff d1                	callq  *%rcx

0000000000802547 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802547:	55                   	push   %rbp
  802548:	48 89 e5             	mov    %rsp,%rbp
  80254b:	48 83 ec 08          	sub    $0x8,%rsp
  80254f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802553:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802557:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80255e:	ff ff ff 
  802561:	48 01 d0             	add    %rdx,%rax
  802564:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802568:	c9                   	leaveq 
  802569:	c3                   	retq   

000000000080256a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80256a:	55                   	push   %rbp
  80256b:	48 89 e5             	mov    %rsp,%rbp
  80256e:	48 83 ec 08          	sub    $0x8,%rsp
  802572:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257a:	48 89 c7             	mov    %rax,%rdi
  80257d:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
  802589:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80258f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802593:	c9                   	leaveq 
  802594:	c3                   	retq   

0000000000802595 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802595:	55                   	push   %rbp
  802596:	48 89 e5             	mov    %rsp,%rbp
  802599:	48 83 ec 18          	sub    $0x18,%rsp
  80259d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a8:	eb 6b                	jmp    802615 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8025aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ad:	48 98                	cltq   
  8025af:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025b5:	48 c1 e0 0c          	shl    $0xc,%rax
  8025b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c1:	48 c1 e8 15          	shr    $0x15,%rax
  8025c5:	48 89 c2             	mov    %rax,%rdx
  8025c8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025cf:	01 00 00 
  8025d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d6:	83 e0 01             	and    $0x1,%eax
  8025d9:	48 85 c0             	test   %rax,%rax
  8025dc:	74 21                	je     8025ff <fd_alloc+0x6a>
  8025de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e2:	48 c1 e8 0c          	shr    $0xc,%rax
  8025e6:	48 89 c2             	mov    %rax,%rdx
  8025e9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f0:	01 00 00 
  8025f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f7:	83 e0 01             	and    $0x1,%eax
  8025fa:	48 85 c0             	test   %rax,%rax
  8025fd:	75 12                	jne    802611 <fd_alloc+0x7c>
			*fd_store = fd;
  8025ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802603:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802607:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
  80260f:	eb 1a                	jmp    80262b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802611:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802615:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802619:	7e 8f                	jle    8025aa <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80261b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802626:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80262b:	c9                   	leaveq 
  80262c:	c3                   	retq   

000000000080262d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80262d:	55                   	push   %rbp
  80262e:	48 89 e5             	mov    %rsp,%rbp
  802631:	48 83 ec 20          	sub    $0x20,%rsp
  802635:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802638:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80263c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802640:	78 06                	js     802648 <fd_lookup+0x1b>
  802642:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802646:	7e 07                	jle    80264f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802648:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80264d:	eb 6c                	jmp    8026bb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80264f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802652:	48 98                	cltq   
  802654:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80265a:	48 c1 e0 0c          	shl    $0xc,%rax
  80265e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802666:	48 c1 e8 15          	shr    $0x15,%rax
  80266a:	48 89 c2             	mov    %rax,%rdx
  80266d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802674:	01 00 00 
  802677:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80267b:	83 e0 01             	and    $0x1,%eax
  80267e:	48 85 c0             	test   %rax,%rax
  802681:	74 21                	je     8026a4 <fd_lookup+0x77>
  802683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802687:	48 c1 e8 0c          	shr    $0xc,%rax
  80268b:	48 89 c2             	mov    %rax,%rdx
  80268e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802695:	01 00 00 
  802698:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269c:	83 e0 01             	and    $0x1,%eax
  80269f:	48 85 c0             	test   %rax,%rax
  8026a2:	75 07                	jne    8026ab <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026a9:	eb 10                	jmp    8026bb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8026ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026b3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bb:	c9                   	leaveq 
  8026bc:	c3                   	retq   

00000000008026bd <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026bd:	55                   	push   %rbp
  8026be:	48 89 e5             	mov    %rsp,%rbp
  8026c1:	48 83 ec 30          	sub    $0x30,%rsp
  8026c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026c9:	89 f0                	mov    %esi,%eax
  8026cb:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d2:	48 89 c7             	mov    %rax,%rdi
  8026d5:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
  8026e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e5:	48 89 d6             	mov    %rdx,%rsi
  8026e8:	89 c7                	mov    %eax,%edi
  8026ea:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fd:	78 0a                	js     802709 <fd_close+0x4c>
	    || fd != fd2)
  8026ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802703:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802707:	74 12                	je     80271b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802709:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80270d:	74 05                	je     802714 <fd_close+0x57>
  80270f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802712:	eb 05                	jmp    802719 <fd_close+0x5c>
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
  802719:	eb 69                	jmp    802784 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80271b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271f:	8b 00                	mov    (%rax),%eax
  802721:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802725:	48 89 d6             	mov    %rdx,%rsi
  802728:	89 c7                	mov    %eax,%edi
  80272a:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802731:	00 00 00 
  802734:	ff d0                	callq  *%rax
  802736:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802739:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273d:	78 2a                	js     802769 <fd_close+0xac>
		if (dev->dev_close)
  80273f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802743:	48 8b 40 20          	mov    0x20(%rax),%rax
  802747:	48 85 c0             	test   %rax,%rax
  80274a:	74 16                	je     802762 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80274c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802750:	48 8b 40 20          	mov    0x20(%rax),%rax
  802754:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802758:	48 89 d7             	mov    %rdx,%rdi
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	eb 07                	jmp    802769 <fd_close+0xac>
		else
			r = 0;
  802762:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276d:	48 89 c6             	mov    %rax,%rsi
  802770:	bf 00 00 00 00       	mov    $0x0,%edi
  802775:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
	return r;
  802781:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802784:	c9                   	leaveq 
  802785:	c3                   	retq   

0000000000802786 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802786:	55                   	push   %rbp
  802787:	48 89 e5             	mov    %rsp,%rbp
  80278a:	48 83 ec 20          	sub    $0x20,%rsp
  80278e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802795:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80279c:	eb 41                	jmp    8027df <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80279e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027a5:	00 00 00 
  8027a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ab:	48 63 d2             	movslq %edx,%rdx
  8027ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b2:	8b 00                	mov    (%rax),%eax
  8027b4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027b7:	75 22                	jne    8027db <dev_lookup+0x55>
			*dev = devtab[i];
  8027b9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027c0:	00 00 00 
  8027c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027c6:	48 63 d2             	movslq %edx,%rdx
  8027c9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	eb 60                	jmp    80283b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027df:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027e6:	00 00 00 
  8027e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ec:	48 63 d2             	movslq %edx,%rdx
  8027ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f3:	48 85 c0             	test   %rax,%rax
  8027f6:	75 a6                	jne    80279e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027ff:	00 00 00 
  802802:	48 8b 00             	mov    (%rax),%rax
  802805:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80280b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80280e:	89 c6                	mov    %eax,%esi
  802810:	48 bf c8 44 80 00 00 	movabs $0x8044c8,%rdi
  802817:	00 00 00 
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802826:	00 00 00 
  802829:	ff d1                	callq  *%rcx
	*dev = 0;
  80282b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80283b:	c9                   	leaveq 
  80283c:	c3                   	retq   

000000000080283d <close>:

int
close(int fdnum)
{
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
  802841:	48 83 ec 20          	sub    $0x20,%rsp
  802845:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802848:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80284c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80284f:	48 89 d6             	mov    %rdx,%rsi
  802852:	89 c7                	mov    %eax,%edi
  802854:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax
  802860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802867:	79 05                	jns    80286e <close+0x31>
		return r;
  802869:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286c:	eb 18                	jmp    802886 <close+0x49>
	else
		return fd_close(fd, 1);
  80286e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802872:	be 01 00 00 00       	mov    $0x1,%esi
  802877:	48 89 c7             	mov    %rax,%rdi
  80287a:	48 b8 bd 26 80 00 00 	movabs $0x8026bd,%rax
  802881:	00 00 00 
  802884:	ff d0                	callq  *%rax
}
  802886:	c9                   	leaveq 
  802887:	c3                   	retq   

0000000000802888 <close_all>:

void
close_all(void)
{
  802888:	55                   	push   %rbp
  802889:	48 89 e5             	mov    %rsp,%rbp
  80288c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802890:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802897:	eb 15                	jmp    8028ae <close_all+0x26>
		close(i);
  802899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289c:	89 c7                	mov    %eax,%edi
  80289e:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  8028a5:	00 00 00 
  8028a8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8028aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028ae:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028b2:	7e e5                	jle    802899 <close_all+0x11>
		close(i);
}
  8028b4:	c9                   	leaveq 
  8028b5:	c3                   	retq   

00000000008028b6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8028b6:	55                   	push   %rbp
  8028b7:	48 89 e5             	mov    %rsp,%rbp
  8028ba:	48 83 ec 40          	sub    $0x40,%rsp
  8028be:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028c1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028c4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028c8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028cb:	48 89 d6             	mov    %rdx,%rsi
  8028ce:	89 c7                	mov    %eax,%edi
  8028d0:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
  8028dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e3:	79 08                	jns    8028ed <dup+0x37>
		return r;
  8028e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e8:	e9 70 01 00 00       	jmpq   802a5d <dup+0x1a7>
	close(newfdnum);
  8028ed:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028f0:	89 c7                	mov    %eax,%edi
  8028f2:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028fe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802901:	48 98                	cltq   
  802903:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802909:	48 c1 e0 0c          	shl    $0xc,%rax
  80290d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802915:	48 89 c7             	mov    %rax,%rdi
  802918:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802928:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292c:	48 89 c7             	mov    %rax,%rdi
  80292f:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
  80293b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80293f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802943:	48 c1 e8 15          	shr    $0x15,%rax
  802947:	48 89 c2             	mov    %rax,%rdx
  80294a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802951:	01 00 00 
  802954:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802958:	83 e0 01             	and    $0x1,%eax
  80295b:	48 85 c0             	test   %rax,%rax
  80295e:	74 73                	je     8029d3 <dup+0x11d>
  802960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802964:	48 c1 e8 0c          	shr    $0xc,%rax
  802968:	48 89 c2             	mov    %rax,%rdx
  80296b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802972:	01 00 00 
  802975:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802979:	83 e0 01             	and    $0x1,%eax
  80297c:	48 85 c0             	test   %rax,%rax
  80297f:	74 52                	je     8029d3 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802985:	48 c1 e8 0c          	shr    $0xc,%rax
  802989:	48 89 c2             	mov    %rax,%rdx
  80298c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802993:	01 00 00 
  802996:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80299a:	25 07 0e 00 00       	and    $0xe07,%eax
  80299f:	89 c1                	mov    %eax,%ecx
  8029a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a9:	41 89 c8             	mov    %ecx,%r8d
  8029ac:	48 89 d1             	mov    %rdx,%rcx
  8029af:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b4:	48 89 c6             	mov    %rax,%rsi
  8029b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029bc:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
  8029c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cf:	79 02                	jns    8029d3 <dup+0x11d>
			goto err;
  8029d1:	eb 57                	jmp    802a2a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029d7:	48 c1 e8 0c          	shr    $0xc,%rax
  8029db:	48 89 c2             	mov    %rax,%rdx
  8029de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029e5:	01 00 00 
  8029e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8029f1:	89 c1                	mov    %eax,%ecx
  8029f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029fb:	41 89 c8             	mov    %ecx,%r8d
  8029fe:	48 89 d1             	mov    %rdx,%rcx
  802a01:	ba 00 00 00 00       	mov    $0x0,%edx
  802a06:	48 89 c6             	mov    %rax,%rsi
  802a09:	bf 00 00 00 00       	mov    $0x0,%edi
  802a0e:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
  802a1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a21:	79 02                	jns    802a25 <dup+0x16f>
		goto err;
  802a23:	eb 05                	jmp    802a2a <dup+0x174>

	return newfdnum;
  802a25:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a28:	eb 33                	jmp    802a5d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2e:	48 89 c6             	mov    %rax,%rsi
  802a31:	bf 00 00 00 00       	mov    $0x0,%edi
  802a36:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  802a3d:	00 00 00 
  802a40:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a46:	48 89 c6             	mov    %rax,%rsi
  802a49:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4e:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
	return r;
  802a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a5d:	c9                   	leaveq 
  802a5e:	c3                   	retq   

0000000000802a5f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a5f:	55                   	push   %rbp
  802a60:	48 89 e5             	mov    %rsp,%rbp
  802a63:	48 83 ec 40          	sub    $0x40,%rsp
  802a67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a6e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a76:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a79:	48 89 d6             	mov    %rdx,%rsi
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
  802a8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a91:	78 24                	js     802ab7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	8b 00                	mov    (%rax),%eax
  802a99:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a9d:	48 89 d6             	mov    %rdx,%rsi
  802aa0:	89 c7                	mov    %eax,%edi
  802aa2:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
  802aae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab5:	79 05                	jns    802abc <read+0x5d>
		return r;
  802ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aba:	eb 76                	jmp    802b32 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac0:	8b 40 08             	mov    0x8(%rax),%eax
  802ac3:	83 e0 03             	and    $0x3,%eax
  802ac6:	83 f8 01             	cmp    $0x1,%eax
  802ac9:	75 3a                	jne    802b05 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802acb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ad2:	00 00 00 
  802ad5:	48 8b 00             	mov    (%rax),%rax
  802ad8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ade:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae1:	89 c6                	mov    %eax,%esi
  802ae3:	48 bf e7 44 80 00 00 	movabs $0x8044e7,%rdi
  802aea:	00 00 00 
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802af9:	00 00 00 
  802afc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802afe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b03:	eb 2d                	jmp    802b32 <read+0xd3>
	}
	if (!dev->dev_read)
  802b05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b09:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b0d:	48 85 c0             	test   %rax,%rax
  802b10:	75 07                	jne    802b19 <read+0xba>
		return -E_NOT_SUPP;
  802b12:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b17:	eb 19                	jmp    802b32 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b21:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b29:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b2d:	48 89 cf             	mov    %rcx,%rdi
  802b30:	ff d0                	callq  *%rax
}
  802b32:	c9                   	leaveq 
  802b33:	c3                   	retq   

0000000000802b34 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b34:	55                   	push   %rbp
  802b35:	48 89 e5             	mov    %rsp,%rbp
  802b38:	48 83 ec 30          	sub    $0x30,%rsp
  802b3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b43:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b4e:	eb 49                	jmp    802b99 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b53:	48 98                	cltq   
  802b55:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b59:	48 29 c2             	sub    %rax,%rdx
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5f:	48 63 c8             	movslq %eax,%rcx
  802b62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b66:	48 01 c1             	add    %rax,%rcx
  802b69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b6c:	48 89 ce             	mov    %rcx,%rsi
  802b6f:	89 c7                	mov    %eax,%edi
  802b71:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	callq  *%rax
  802b7d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b80:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b84:	79 05                	jns    802b8b <readn+0x57>
			return m;
  802b86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b89:	eb 1c                	jmp    802ba7 <readn+0x73>
		if (m == 0)
  802b8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b8f:	75 02                	jne    802b93 <readn+0x5f>
			break;
  802b91:	eb 11                	jmp    802ba4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b96:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9c:	48 98                	cltq   
  802b9e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ba2:	72 ac                	jb     802b50 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ba7:	c9                   	leaveq 
  802ba8:	c3                   	retq   

0000000000802ba9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ba9:	55                   	push   %rbp
  802baa:	48 89 e5             	mov    %rsp,%rbp
  802bad:	48 83 ec 40          	sub    $0x40,%rsp
  802bb1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bb4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bb8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bbc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bc0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bc3:	48 89 d6             	mov    %rdx,%rsi
  802bc6:	89 c7                	mov    %eax,%edi
  802bc8:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdb:	78 24                	js     802c01 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be1:	8b 00                	mov    (%rax),%eax
  802be3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802be7:	48 89 d6             	mov    %rdx,%rsi
  802bea:	89 c7                	mov    %eax,%edi
  802bec:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802bf3:	00 00 00 
  802bf6:	ff d0                	callq  *%rax
  802bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bff:	79 05                	jns    802c06 <write+0x5d>
		return r;
  802c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c04:	eb 75                	jmp    802c7b <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	8b 40 08             	mov    0x8(%rax),%eax
  802c0d:	83 e0 03             	and    $0x3,%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	75 3a                	jne    802c4e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c14:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c1b:	00 00 00 
  802c1e:	48 8b 00             	mov    (%rax),%rax
  802c21:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c27:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c2a:	89 c6                	mov    %eax,%esi
  802c2c:	48 bf 03 45 80 00 00 	movabs $0x804503,%rdi
  802c33:	00 00 00 
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802c42:	00 00 00 
  802c45:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c4c:	eb 2d                	jmp    802c7b <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c52:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c56:	48 85 c0             	test   %rax,%rax
  802c59:	75 07                	jne    802c62 <write+0xb9>
		return -E_NOT_SUPP;
  802c5b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c60:	eb 19                	jmp    802c7b <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c66:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c6a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c6e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c72:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c76:	48 89 cf             	mov    %rcx,%rdi
  802c79:	ff d0                	callq  *%rax
}
  802c7b:	c9                   	leaveq 
  802c7c:	c3                   	retq   

0000000000802c7d <seek>:

int
seek(int fdnum, off_t offset)
{
  802c7d:	55                   	push   %rbp
  802c7e:	48 89 e5             	mov    %rsp,%rbp
  802c81:	48 83 ec 18          	sub    $0x18,%rsp
  802c85:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c88:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c92:	48 89 d6             	mov    %rdx,%rsi
  802c95:	89 c7                	mov    %eax,%edi
  802c97:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
  802ca3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802caa:	79 05                	jns    802cb1 <seek+0x34>
		return r;
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caf:	eb 0f                	jmp    802cc0 <seek+0x43>
	fd->fd_offset = offset;
  802cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cb8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc0:	c9                   	leaveq 
  802cc1:	c3                   	retq   

0000000000802cc2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802cc2:	55                   	push   %rbp
  802cc3:	48 89 e5             	mov    %rsp,%rbp
  802cc6:	48 83 ec 30          	sub    $0x30,%rsp
  802cca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ccd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cd4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cd7:	48 89 d6             	mov    %rdx,%rsi
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
  802ce8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cef:	78 24                	js     802d15 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf5:	8b 00                	mov    (%rax),%eax
  802cf7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cfb:	48 89 d6             	mov    %rdx,%rsi
  802cfe:	89 c7                	mov    %eax,%edi
  802d00:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
  802d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d13:	79 05                	jns    802d1a <ftruncate+0x58>
		return r;
  802d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d18:	eb 72                	jmp    802d8c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1e:	8b 40 08             	mov    0x8(%rax),%eax
  802d21:	83 e0 03             	and    $0x3,%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	75 3a                	jne    802d62 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d28:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d2f:	00 00 00 
  802d32:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d35:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d3b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d3e:	89 c6                	mov    %eax,%esi
  802d40:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  802d47:	00 00 00 
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4f:	48 b9 00 07 80 00 00 	movabs $0x800700,%rcx
  802d56:	00 00 00 
  802d59:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d60:	eb 2a                	jmp    802d8c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d66:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d6a:	48 85 c0             	test   %rax,%rax
  802d6d:	75 07                	jne    802d76 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d6f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d74:	eb 16                	jmp    802d8c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d82:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d85:	89 ce                	mov    %ecx,%esi
  802d87:	48 89 d7             	mov    %rdx,%rdi
  802d8a:	ff d0                	callq  *%rax
}
  802d8c:	c9                   	leaveq 
  802d8d:	c3                   	retq   

0000000000802d8e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d8e:	55                   	push   %rbp
  802d8f:	48 89 e5             	mov    %rsp,%rbp
  802d92:	48 83 ec 30          	sub    $0x30,%rsp
  802d96:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802da1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802da4:	48 89 d6             	mov    %rdx,%rsi
  802da7:	89 c7                	mov    %eax,%edi
  802da9:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbc:	78 24                	js     802de2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc2:	8b 00                	mov    (%rax),%eax
  802dc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dc8:	48 89 d6             	mov    %rdx,%rsi
  802dcb:	89 c7                	mov    %eax,%edi
  802dcd:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de0:	79 05                	jns    802de7 <fstat+0x59>
		return r;
  802de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de5:	eb 5e                	jmp    802e45 <fstat+0xb7>
	if (!dev->dev_stat)
  802de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802deb:	48 8b 40 28          	mov    0x28(%rax),%rax
  802def:	48 85 c0             	test   %rax,%rax
  802df2:	75 07                	jne    802dfb <fstat+0x6d>
		return -E_NOT_SUPP;
  802df4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df9:	eb 4a                	jmp    802e45 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dff:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e06:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e0d:	00 00 00 
	stat->st_isdir = 0;
  802e10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e14:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e1b:	00 00 00 
	stat->st_dev = dev;
  802e1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e26:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e31:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e39:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e3d:	48 89 ce             	mov    %rcx,%rsi
  802e40:	48 89 d7             	mov    %rdx,%rdi
  802e43:	ff d0                	callq  *%rax
}
  802e45:	c9                   	leaveq 
  802e46:	c3                   	retq   

0000000000802e47 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e47:	55                   	push   %rbp
  802e48:	48 89 e5             	mov    %rsp,%rbp
  802e4b:	48 83 ec 20          	sub    $0x20,%rsp
  802e4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5b:	be 00 00 00 00       	mov    $0x0,%esi
  802e60:	48 89 c7             	mov    %rax,%rdi
  802e63:	48 b8 35 2f 80 00 00 	movabs $0x802f35,%rax
  802e6a:	00 00 00 
  802e6d:	ff d0                	callq  *%rax
  802e6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e76:	79 05                	jns    802e7d <stat+0x36>
		return fd;
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	eb 2f                	jmp    802eac <stat+0x65>
	r = fstat(fd, stat);
  802e7d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e84:	48 89 d6             	mov    %rdx,%rsi
  802e87:	89 c7                	mov    %eax,%edi
  802e89:	48 b8 8e 2d 80 00 00 	movabs $0x802d8e,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
  802e95:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9b:	89 c7                	mov    %eax,%edi
  802e9d:	48 b8 3d 28 80 00 00 	movabs $0x80283d,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
	return r;
  802ea9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802eac:	c9                   	leaveq 
  802ead:	c3                   	retq   

0000000000802eae <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802eae:	55                   	push   %rbp
  802eaf:	48 89 e5             	mov    %rsp,%rbp
  802eb2:	48 83 ec 10          	sub    $0x10,%rsp
  802eb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802eb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ebd:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ec4:	00 00 00 
  802ec7:	8b 00                	mov    (%rax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	75 1d                	jne    802eea <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ecd:	bf 01 00 00 00       	mov    $0x1,%edi
  802ed2:	48 b8 99 3d 80 00 00 	movabs $0x803d99,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
  802ede:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802ee5:	00 00 00 
  802ee8:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802eea:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ef1:	00 00 00 
  802ef4:	8b 00                	mov    (%rax),%eax
  802ef6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ef9:	b9 07 00 00 00       	mov    $0x7,%ecx
  802efe:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802f05:	00 00 00 
  802f08:	89 c7                	mov    %eax,%edi
  802f0a:	48 b8 01 3d 80 00 00 	movabs $0x803d01,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1f:	48 89 c6             	mov    %rax,%rsi
  802f22:	bf 00 00 00 00       	mov    $0x0,%edi
  802f27:	48 b8 38 3c 80 00 00 	movabs $0x803c38,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
}
  802f33:	c9                   	leaveq 
  802f34:	c3                   	retq   

0000000000802f35 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f35:	55                   	push   %rbp
  802f36:	48 89 e5             	mov    %rsp,%rbp
  802f39:	48 83 ec 20          	sub    $0x20,%rsp
  802f3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f41:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f5c:	7e 0a                	jle    802f68 <open+0x33>
		return -E_BAD_PATH;
  802f5e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f63:	e9 a5 00 00 00       	jmpq   80300d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802f68:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f6c:	48 89 c7             	mov    %rax,%rdi
  802f6f:	48 b8 95 25 80 00 00 	movabs $0x802595,%rax
  802f76:	00 00 00 
  802f79:	ff d0                	callq  *%rax
  802f7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f82:	79 08                	jns    802f8c <open+0x57>
		return r;
  802f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f87:	e9 81 00 00 00       	jmpq   80300d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f90:	48 89 c6             	mov    %rax,%rsi
  802f93:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f9a:	00 00 00 
  802f9d:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802fa9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fb0:	00 00 00 
  802fb3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fb6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc0:	48 89 c6             	mov    %rax,%rsi
  802fc3:	bf 01 00 00 00       	mov    $0x1,%edi
  802fc8:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
  802fd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdb:	79 1d                	jns    802ffa <open+0xc5>
		fd_close(fd, 0);
  802fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe1:	be 00 00 00 00       	mov    $0x0,%esi
  802fe6:	48 89 c7             	mov    %rax,%rdi
  802fe9:	48 b8 bd 26 80 00 00 	movabs $0x8026bd,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
		return r;
  802ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff8:	eb 13                	jmp    80300d <open+0xd8>
	}

	return fd2num(fd);
  802ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffe:	48 89 c7             	mov    %rax,%rdi
  803001:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803008:	00 00 00 
  80300b:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80300d:	c9                   	leaveq 
  80300e:	c3                   	retq   

000000000080300f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80300f:	55                   	push   %rbp
  803010:	48 89 e5             	mov    %rsp,%rbp
  803013:	48 83 ec 10          	sub    $0x10,%rsp
  803017:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80301b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301f:	8b 50 0c             	mov    0xc(%rax),%edx
  803022:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803029:	00 00 00 
  80302c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80302e:	be 00 00 00 00       	mov    $0x0,%esi
  803033:	bf 06 00 00 00       	mov    $0x6,%edi
  803038:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
}
  803044:	c9                   	leaveq 
  803045:	c3                   	retq   

0000000000803046 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 83 ec 30          	sub    $0x30,%rsp
  80304e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803056:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80305a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305e:	8b 50 0c             	mov    0xc(%rax),%edx
  803061:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803068:	00 00 00 
  80306b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80306d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803074:	00 00 00 
  803077:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80307b:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80307f:	be 00 00 00 00       	mov    $0x0,%esi
  803084:	bf 03 00 00 00       	mov    $0x3,%edi
  803089:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  803090:	00 00 00 
  803093:	ff d0                	callq  *%rax
  803095:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803098:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80309c:	79 05                	jns    8030a3 <devfile_read+0x5d>
		return r;
  80309e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a1:	eb 26                	jmp    8030c9 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8030a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a6:	48 63 d0             	movslq %eax,%rdx
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030b4:	00 00 00 
  8030b7:	48 89 c7             	mov    %rax,%rdi
  8030ba:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax

	return r;
  8030c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 30          	sub    $0x30,%rsp
  8030d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8030df:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030e6:	00 
  8030e7:	76 08                	jbe    8030f1 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8030e9:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030f0:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030ff:	00 00 00 
  803102:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803104:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80310b:	00 00 00 
  80310e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803112:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  803116:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80311a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311e:	48 89 c6             	mov    %rax,%rsi
  803121:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803128:	00 00 00 
  80312b:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803137:	be 00 00 00 00       	mov    $0x0,%esi
  80313c:	bf 04 00 00 00       	mov    $0x4,%edi
  803141:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
  80314d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803154:	79 05                	jns    80315b <devfile_write+0x90>
		return r;
  803156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803159:	eb 03                	jmp    80315e <devfile_write+0x93>

	return r;
  80315b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80315e:	c9                   	leaveq 
  80315f:	c3                   	retq   

0000000000803160 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
  803164:	48 83 ec 20          	sub    $0x20,%rsp
  803168:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80316c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803174:	8b 50 0c             	mov    0xc(%rax),%edx
  803177:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80317e:	00 00 00 
  803181:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803183:	be 00 00 00 00       	mov    $0x0,%esi
  803188:	bf 05 00 00 00       	mov    $0x5,%edi
  80318d:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a0:	79 05                	jns    8031a7 <devfile_stat+0x47>
		return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a5:	eb 56                	jmp    8031fd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ab:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031b2:	00 00 00 
  8031b5:	48 89 c7             	mov    %rax,%rdi
  8031b8:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031cb:	00 00 00 
  8031ce:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e5:	00 00 00 
  8031e8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031fd:	c9                   	leaveq 
  8031fe:	c3                   	retq   

00000000008031ff <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031ff:	55                   	push   %rbp
  803200:	48 89 e5             	mov    %rsp,%rbp
  803203:	48 83 ec 10          	sub    $0x10,%rsp
  803207:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80320b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80320e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803212:	8b 50 0c             	mov    0xc(%rax),%edx
  803215:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321c:	00 00 00 
  80321f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803221:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803228:	00 00 00 
  80322b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80322e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803231:	be 00 00 00 00       	mov    $0x0,%esi
  803236:	bf 02 00 00 00       	mov    $0x2,%edi
  80323b:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
}
  803247:	c9                   	leaveq 
  803248:	c3                   	retq   

0000000000803249 <remove>:

// Delete a file
int
remove(const char *path)
{
  803249:	55                   	push   %rbp
  80324a:	48 89 e5             	mov    %rsp,%rbp
  80324d:	48 83 ec 10          	sub    $0x10,%rsp
  803251:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803259:	48 89 c7             	mov    %rax,%rdi
  80325c:	48 b8 3c 14 80 00 00 	movabs $0x80143c,%rax
  803263:	00 00 00 
  803266:	ff d0                	callq  *%rax
  803268:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80326d:	7e 07                	jle    803276 <remove+0x2d>
		return -E_BAD_PATH;
  80326f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803274:	eb 33                	jmp    8032a9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327a:	48 89 c6             	mov    %rax,%rsi
  80327d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803284:	00 00 00 
  803287:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803293:	be 00 00 00 00       	mov    $0x0,%esi
  803298:	bf 07 00 00 00       	mov    $0x7,%edi
  80329d:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
}
  8032a9:	c9                   	leaveq 
  8032aa:	c3                   	retq   

00000000008032ab <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032ab:	55                   	push   %rbp
  8032ac:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032af:	be 00 00 00 00       	mov    $0x0,%esi
  8032b4:	bf 08 00 00 00       	mov    $0x8,%edi
  8032b9:	48 b8 ae 2e 80 00 00 	movabs $0x802eae,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
}
  8032c5:	5d                   	pop    %rbp
  8032c6:	c3                   	retq   

00000000008032c7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032c7:	55                   	push   %rbp
  8032c8:	48 89 e5             	mov    %rsp,%rbp
  8032cb:	53                   	push   %rbx
  8032cc:	48 83 ec 38          	sub    $0x38,%rsp
  8032d0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032d4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032d8:	48 89 c7             	mov    %rax,%rdi
  8032db:	48 b8 95 25 80 00 00 	movabs $0x802595,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ee:	0f 88 bf 01 00 00    	js     8034b3 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f8:	ba 07 04 00 00       	mov    $0x407,%edx
  8032fd:	48 89 c6             	mov    %rax,%rsi
  803300:	bf 00 00 00 00       	mov    $0x0,%edi
  803305:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
  803311:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803314:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803318:	0f 88 95 01 00 00    	js     8034b3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80331e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803322:	48 89 c7             	mov    %rax,%rdi
  803325:	48 b8 95 25 80 00 00 	movabs $0x802595,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803334:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803338:	0f 88 5d 01 00 00    	js     80349b <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803342:	ba 07 04 00 00       	mov    $0x407,%edx
  803347:	48 89 c6             	mov    %rax,%rsi
  80334a:	bf 00 00 00 00       	mov    $0x0,%edi
  80334f:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
  80335b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803362:	0f 88 33 01 00 00    	js     80349b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336c:	48 89 c7             	mov    %rax,%rdi
  80336f:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
  80337b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80337f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803383:	ba 07 04 00 00       	mov    $0x407,%edx
  803388:	48 89 c6             	mov    %rax,%rsi
  80338b:	bf 00 00 00 00       	mov    $0x0,%edi
  803390:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
  80339c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a3:	79 05                	jns    8033aa <pipe+0xe3>
		goto err2;
  8033a5:	e9 d9 00 00 00       	jmpq   803483 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ae:	48 89 c7             	mov    %rax,%rdi
  8033b1:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
  8033bd:	48 89 c2             	mov    %rax,%rdx
  8033c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033ca:	48 89 d1             	mov    %rdx,%rcx
  8033cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d2:	48 89 c6             	mov    %rax,%rsi
  8033d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033da:	48 b8 27 1e 80 00 00 	movabs $0x801e27,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
  8033e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033ed:	79 1b                	jns    80340a <pipe+0x143>
		goto err3;
  8033ef:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8033f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f4:	48 89 c6             	mov    %rax,%rsi
  8033f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fc:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	eb 79                	jmp    803483 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80340a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803415:	00 00 00 
  803418:	8b 12                	mov    (%rdx),%edx
  80341a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80341c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803420:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803427:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80342b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803432:	00 00 00 
  803435:	8b 12                	mov    (%rdx),%edx
  803437:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803439:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803448:	48 89 c7             	mov    %rax,%rdi
  80344b:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
  803457:	89 c2                	mov    %eax,%edx
  803459:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80345d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80345f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803463:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803467:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346b:	48 89 c7             	mov    %rax,%rdi
  80346e:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
  80347a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80347c:	b8 00 00 00 00       	mov    $0x0,%eax
  803481:	eb 33                	jmp    8034b6 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803483:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803487:	48 89 c6             	mov    %rax,%rsi
  80348a:	bf 00 00 00 00       	mov    $0x0,%edi
  80348f:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803496:	00 00 00 
  803499:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80349b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349f:	48 89 c6             	mov    %rax,%rsi
  8034a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a7:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax
    err:
	return r;
  8034b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034b6:	48 83 c4 38          	add    $0x38,%rsp
  8034ba:	5b                   	pop    %rbx
  8034bb:	5d                   	pop    %rbp
  8034bc:	c3                   	retq   

00000000008034bd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034bd:	55                   	push   %rbp
  8034be:	48 89 e5             	mov    %rsp,%rbp
  8034c1:	53                   	push   %rbx
  8034c2:	48 83 ec 28          	sub    $0x28,%rsp
  8034c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034d5:	00 00 00 
  8034d8:	48 8b 00             	mov    (%rax),%rax
  8034db:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e8:	48 89 c7             	mov    %rax,%rdi
  8034eb:	48 b8 1b 3e 80 00 00 	movabs $0x803e1b,%rax
  8034f2:	00 00 00 
  8034f5:	ff d0                	callq  *%rax
  8034f7:	89 c3                	mov    %eax,%ebx
  8034f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fd:	48 89 c7             	mov    %rax,%rdi
  803500:	48 b8 1b 3e 80 00 00 	movabs $0x803e1b,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
  80350c:	39 c3                	cmp    %eax,%ebx
  80350e:	0f 94 c0             	sete   %al
  803511:	0f b6 c0             	movzbl %al,%eax
  803514:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803517:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80351e:	00 00 00 
  803521:	48 8b 00             	mov    (%rax),%rax
  803524:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80352a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80352d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803530:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803533:	75 05                	jne    80353a <_pipeisclosed+0x7d>
			return ret;
  803535:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803538:	eb 4f                	jmp    803589 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80353a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80353d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803540:	74 42                	je     803584 <_pipeisclosed+0xc7>
  803542:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803546:	75 3c                	jne    803584 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803548:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80354f:	00 00 00 
  803552:	48 8b 00             	mov    (%rax),%rax
  803555:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80355b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80355e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803561:	89 c6                	mov    %eax,%esi
  803563:	48 bf 4b 45 80 00 00 	movabs $0x80454b,%rdi
  80356a:	00 00 00 
  80356d:	b8 00 00 00 00       	mov    $0x0,%eax
  803572:	49 b8 00 07 80 00 00 	movabs $0x800700,%r8
  803579:	00 00 00 
  80357c:	41 ff d0             	callq  *%r8
	}
  80357f:	e9 4a ff ff ff       	jmpq   8034ce <_pipeisclosed+0x11>
  803584:	e9 45 ff ff ff       	jmpq   8034ce <_pipeisclosed+0x11>
}
  803589:	48 83 c4 28          	add    $0x28,%rsp
  80358d:	5b                   	pop    %rbx
  80358e:	5d                   	pop    %rbp
  80358f:	c3                   	retq   

0000000000803590 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803590:	55                   	push   %rbp
  803591:	48 89 e5             	mov    %rsp,%rbp
  803594:	48 83 ec 30          	sub    $0x30,%rsp
  803598:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80359b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80359f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035a2:	48 89 d6             	mov    %rdx,%rsi
  8035a5:	89 c7                	mov    %eax,%edi
  8035a7:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ba:	79 05                	jns    8035c1 <pipeisclosed+0x31>
		return r;
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bf:	eb 31                	jmp    8035f2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c5:	48 89 c7             	mov    %rax,%rdi
  8035c8:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035e0:	48 89 d6             	mov    %rdx,%rsi
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 bd 34 80 00 00 	movabs $0x8034bd,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
}
  8035f2:	c9                   	leaveq 
  8035f3:	c3                   	retq   

00000000008035f4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035f4:	55                   	push   %rbp
  8035f5:	48 89 e5             	mov    %rsp,%rbp
  8035f8:	48 83 ec 40          	sub    $0x40,%rsp
  8035fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803600:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803604:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
  80361b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80361f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803623:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803627:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80362e:	00 
  80362f:	e9 92 00 00 00       	jmpq   8036c6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803634:	eb 41                	jmp    803677 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803636:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80363b:	74 09                	je     803646 <devpipe_read+0x52>
				return i;
  80363d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803641:	e9 92 00 00 00       	jmpq   8036d8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803646:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80364a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364e:	48 89 d6             	mov    %rdx,%rsi
  803651:	48 89 c7             	mov    %rax,%rdi
  803654:	48 b8 bd 34 80 00 00 	movabs $0x8034bd,%rax
  80365b:	00 00 00 
  80365e:	ff d0                	callq  *%rax
  803660:	85 c0                	test   %eax,%eax
  803662:	74 07                	je     80366b <devpipe_read+0x77>
				return 0;
  803664:	b8 00 00 00 00       	mov    $0x0,%eax
  803669:	eb 6d                	jmp    8036d8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80366b:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367b:	8b 10                	mov    (%rax),%edx
  80367d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803681:	8b 40 04             	mov    0x4(%rax),%eax
  803684:	39 c2                	cmp    %eax,%edx
  803686:	74 ae                	je     803636 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803690:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803698:	8b 00                	mov    (%rax),%eax
  80369a:	99                   	cltd   
  80369b:	c1 ea 1b             	shr    $0x1b,%edx
  80369e:	01 d0                	add    %edx,%eax
  8036a0:	83 e0 1f             	and    $0x1f,%eax
  8036a3:	29 d0                	sub    %edx,%eax
  8036a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a9:	48 98                	cltq   
  8036ab:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036b0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b6:	8b 00                	mov    (%rax),%eax
  8036b8:	8d 50 01             	lea    0x1(%rax),%edx
  8036bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ca:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036ce:	0f 82 60 ff ff ff    	jb     803634 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036d8:	c9                   	leaveq 
  8036d9:	c3                   	retq   

00000000008036da <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036da:	55                   	push   %rbp
  8036db:	48 89 e5             	mov    %rsp,%rbp
  8036de:	48 83 ec 40          	sub    $0x40,%rsp
  8036e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f2:	48 89 c7             	mov    %rax,%rdi
  8036f5:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  8036fc:	00 00 00 
  8036ff:	ff d0                	callq  *%rax
  803701:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803705:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803709:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80370d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803714:	00 
  803715:	e9 8e 00 00 00       	jmpq   8037a8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80371a:	eb 31                	jmp    80374d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80371c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803724:	48 89 d6             	mov    %rdx,%rsi
  803727:	48 89 c7             	mov    %rax,%rdi
  80372a:	48 b8 bd 34 80 00 00 	movabs $0x8034bd,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 07                	je     803741 <devpipe_write+0x67>
				return 0;
  80373a:	b8 00 00 00 00       	mov    $0x0,%eax
  80373f:	eb 79                	jmp    8037ba <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803741:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80374d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803751:	8b 40 04             	mov    0x4(%rax),%eax
  803754:	48 63 d0             	movslq %eax,%rdx
  803757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375b:	8b 00                	mov    (%rax),%eax
  80375d:	48 98                	cltq   
  80375f:	48 83 c0 20          	add    $0x20,%rax
  803763:	48 39 c2             	cmp    %rax,%rdx
  803766:	73 b4                	jae    80371c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803768:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80376c:	8b 40 04             	mov    0x4(%rax),%eax
  80376f:	99                   	cltd   
  803770:	c1 ea 1b             	shr    $0x1b,%edx
  803773:	01 d0                	add    %edx,%eax
  803775:	83 e0 1f             	and    $0x1f,%eax
  803778:	29 d0                	sub    %edx,%eax
  80377a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80377e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803782:	48 01 ca             	add    %rcx,%rdx
  803785:	0f b6 0a             	movzbl (%rdx),%ecx
  803788:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80378c:	48 98                	cltq   
  80378e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803796:	8b 40 04             	mov    0x4(%rax),%eax
  803799:	8d 50 01             	lea    0x1(%rax),%edx
  80379c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ac:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037b0:	0f 82 64 ff ff ff    	jb     80371a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037ba:	c9                   	leaveq 
  8037bb:	c3                   	retq   

00000000008037bc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037bc:	55                   	push   %rbp
  8037bd:	48 89 e5             	mov    %rsp,%rbp
  8037c0:	48 83 ec 20          	sub    $0x20,%rsp
  8037c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
  8037df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e7:	48 be 5e 45 80 00 00 	movabs $0x80455e,%rsi
  8037ee:	00 00 00 
  8037f1:	48 89 c7             	mov    %rax,%rdi
  8037f4:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803804:	8b 50 04             	mov    0x4(%rax),%edx
  803807:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380b:	8b 00                	mov    (%rax),%eax
  80380d:	29 c2                	sub    %eax,%edx
  80380f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803813:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803819:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803824:	00 00 00 
	stat->st_dev = &devpipe;
  803827:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80382b:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803832:	00 00 00 
  803835:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80383c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803841:	c9                   	leaveq 
  803842:	c3                   	retq   

0000000000803843 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803843:	55                   	push   %rbp
  803844:	48 89 e5             	mov    %rsp,%rbp
  803847:	48 83 ec 10          	sub    $0x10,%rsp
  80384b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80384f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803853:	48 89 c6             	mov    %rax,%rsi
  803856:	bf 00 00 00 00       	mov    $0x0,%edi
  80385b:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803862:	00 00 00 
  803865:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803867:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80386b:	48 89 c7             	mov    %rax,%rdi
  80386e:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  803875:	00 00 00 
  803878:	ff d0                	callq  *%rax
  80387a:	48 89 c6             	mov    %rax,%rsi
  80387d:	bf 00 00 00 00       	mov    $0x0,%edi
  803882:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  803889:	00 00 00 
  80388c:	ff d0                	callq  *%rax
}
  80388e:	c9                   	leaveq 
  80388f:	c3                   	retq   

0000000000803890 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803890:	55                   	push   %rbp
  803891:	48 89 e5             	mov    %rsp,%rbp
  803894:	48 83 ec 20          	sub    $0x20,%rsp
  803898:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80389b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038a1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038a5:	be 01 00 00 00       	mov    $0x1,%esi
  8038aa:	48 89 c7             	mov    %rax,%rdi
  8038ad:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
}
  8038b9:	c9                   	leaveq 
  8038ba:	c3                   	retq   

00000000008038bb <getchar>:

int
getchar(void)
{
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
  8038bf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038c3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038c7:	ba 01 00 00 00       	mov    $0x1,%edx
  8038cc:	48 89 c6             	mov    %rax,%rsi
  8038cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d4:	48 b8 5f 2a 80 00 00 	movabs $0x802a5f,%rax
  8038db:	00 00 00 
  8038de:	ff d0                	callq  *%rax
  8038e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e7:	79 05                	jns    8038ee <getchar+0x33>
		return r;
  8038e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ec:	eb 14                	jmp    803902 <getchar+0x47>
	if (r < 1)
  8038ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f2:	7f 07                	jg     8038fb <getchar+0x40>
		return -E_EOF;
  8038f4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038f9:	eb 07                	jmp    803902 <getchar+0x47>
	return c;
  8038fb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038ff:	0f b6 c0             	movzbl %al,%eax
}
  803902:	c9                   	leaveq 
  803903:	c3                   	retq   

0000000000803904 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803904:	55                   	push   %rbp
  803905:	48 89 e5             	mov    %rsp,%rbp
  803908:	48 83 ec 20          	sub    $0x20,%rsp
  80390c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80390f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803913:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803916:	48 89 d6             	mov    %rdx,%rsi
  803919:	89 c7                	mov    %eax,%edi
  80391b:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  803922:	00 00 00 
  803925:	ff d0                	callq  *%rax
  803927:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392e:	79 05                	jns    803935 <iscons+0x31>
		return r;
  803930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803933:	eb 1a                	jmp    80394f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803935:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803939:	8b 10                	mov    (%rax),%edx
  80393b:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803942:	00 00 00 
  803945:	8b 00                	mov    (%rax),%eax
  803947:	39 c2                	cmp    %eax,%edx
  803949:	0f 94 c0             	sete   %al
  80394c:	0f b6 c0             	movzbl %al,%eax
}
  80394f:	c9                   	leaveq 
  803950:	c3                   	retq   

0000000000803951 <opencons>:

int
opencons(void)
{
  803951:	55                   	push   %rbp
  803952:	48 89 e5             	mov    %rsp,%rbp
  803955:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803959:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80395d:	48 89 c7             	mov    %rax,%rdi
  803960:	48 b8 95 25 80 00 00 	movabs $0x802595,%rax
  803967:	00 00 00 
  80396a:	ff d0                	callq  *%rax
  80396c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803973:	79 05                	jns    80397a <opencons+0x29>
		return r;
  803975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803978:	eb 5b                	jmp    8039d5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80397a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397e:	ba 07 04 00 00       	mov    $0x407,%edx
  803983:	48 89 c6             	mov    %rax,%rsi
  803986:	bf 00 00 00 00       	mov    $0x0,%edi
  80398b:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803992:	00 00 00 
  803995:	ff d0                	callq  *%rax
  803997:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399e:	79 05                	jns    8039a5 <opencons+0x54>
		return r;
  8039a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a3:	eb 30                	jmp    8039d5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a9:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8039b0:	00 00 00 
  8039b3:	8b 12                	mov    (%rdx),%edx
  8039b5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c6:	48 89 c7             	mov    %rax,%rdi
  8039c9:	48 b8 47 25 80 00 00 	movabs $0x802547,%rax
  8039d0:	00 00 00 
  8039d3:	ff d0                	callq  *%rax
}
  8039d5:	c9                   	leaveq 
  8039d6:	c3                   	retq   

00000000008039d7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039d7:	55                   	push   %rbp
  8039d8:	48 89 e5             	mov    %rsp,%rbp
  8039db:	48 83 ec 30          	sub    $0x30,%rsp
  8039df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039f0:	75 07                	jne    8039f9 <devcons_read+0x22>
		return 0;
  8039f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f7:	eb 4b                	jmp    803a44 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039f9:	eb 0c                	jmp    803a07 <devcons_read+0x30>
		sys_yield();
  8039fb:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a07:	48 b8 d9 1c 80 00 00 	movabs $0x801cd9,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
  803a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a1a:	74 df                	je     8039fb <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803a1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a20:	79 05                	jns    803a27 <devcons_read+0x50>
		return c;
  803a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a25:	eb 1d                	jmp    803a44 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a27:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a2b:	75 07                	jne    803a34 <devcons_read+0x5d>
		return 0;
  803a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a32:	eb 10                	jmp    803a44 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a37:	89 c2                	mov    %eax,%edx
  803a39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3d:	88 10                	mov    %dl,(%rax)
	return 1;
  803a3f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a44:	c9                   	leaveq 
  803a45:	c3                   	retq   

0000000000803a46 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a46:	55                   	push   %rbp
  803a47:	48 89 e5             	mov    %rsp,%rbp
  803a4a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a51:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a58:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a5f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a6d:	eb 76                	jmp    803ae5 <devcons_write+0x9f>
		m = n - tot;
  803a6f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a76:	89 c2                	mov    %eax,%edx
  803a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7b:	29 c2                	sub    %eax,%edx
  803a7d:	89 d0                	mov    %edx,%eax
  803a7f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a85:	83 f8 7f             	cmp    $0x7f,%eax
  803a88:	76 07                	jbe    803a91 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a8a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a94:	48 63 d0             	movslq %eax,%rdx
  803a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9a:	48 63 c8             	movslq %eax,%rcx
  803a9d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803aa4:	48 01 c1             	add    %rax,%rcx
  803aa7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aae:	48 89 ce             	mov    %rcx,%rsi
  803ab1:	48 89 c7             	mov    %rax,%rdi
  803ab4:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ac0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ac3:	48 63 d0             	movslq %eax,%rdx
  803ac6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803acd:	48 89 d6             	mov    %rdx,%rsi
  803ad0:	48 89 c7             	mov    %rax,%rdi
  803ad3:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803adf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae8:	48 98                	cltq   
  803aea:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803af1:	0f 82 78 ff ff ff    	jb     803a6f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803afa:	c9                   	leaveq 
  803afb:	c3                   	retq   

0000000000803afc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	48 83 ec 08          	sub    $0x8,%rsp
  803b04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b0d:	c9                   	leaveq 
  803b0e:	c3                   	retq   

0000000000803b0f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b0f:	55                   	push   %rbp
  803b10:	48 89 e5             	mov    %rsp,%rbp
  803b13:	48 83 ec 10          	sub    $0x10,%rsp
  803b17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b23:	48 be 6a 45 80 00 00 	movabs $0x80456a,%rsi
  803b2a:	00 00 00 
  803b2d:	48 89 c7             	mov    %rax,%rdi
  803b30:	48 b8 a8 14 80 00 00 	movabs $0x8014a8,%rax
  803b37:	00 00 00 
  803b3a:	ff d0                	callq  *%rax
	return 0;
  803b3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b41:	c9                   	leaveq 
  803b42:	c3                   	retq   

0000000000803b43 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b43:	55                   	push   %rbp
  803b44:	48 89 e5             	mov    %rsp,%rbp
  803b47:	48 83 ec 10          	sub    $0x10,%rsp
  803b4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b4f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b56:	00 00 00 
  803b59:	48 8b 00             	mov    (%rax),%rax
  803b5c:	48 85 c0             	test   %rax,%rax
  803b5f:	75 3a                	jne    803b9b <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803b61:	ba 07 00 00 00       	mov    $0x7,%edx
  803b66:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b70:	48 b8 d7 1d 80 00 00 	movabs $0x801dd7,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	75 1b                	jne    803b9b <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b80:	48 be ae 3b 80 00 00 	movabs $0x803bae,%rsi
  803b87:	00 00 00 
  803b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8f:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b9b:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ba2:	00 00 00 
  803ba5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ba9:	48 89 10             	mov    %rdx,(%rax)
}
  803bac:	c9                   	leaveq 
  803bad:	c3                   	retq   

0000000000803bae <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803bae:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803bb1:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803bb8:	00 00 00 
	call *%rax
  803bbb:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803bbd:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803bc0:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803bc7:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803bc8:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803bcf:	00 
	pushq %rbx		// push utf_rip into new stack
  803bd0:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803bd1:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803bd8:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803bdb:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803bdf:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803be3:	4c 8b 3c 24          	mov    (%rsp),%r15
  803be7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bec:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803bf1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803bf6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803bfb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c00:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c05:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c0a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c0f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c14:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c19:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c1e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c23:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c28:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c2d:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803c31:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803c35:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803c36:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803c37:	c3                   	retq   

0000000000803c38 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c38:	55                   	push   %rbp
  803c39:	48 89 e5             	mov    %rsp,%rbp
  803c3c:	48 83 ec 30          	sub    $0x30,%rsp
  803c40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803c54:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c59:	75 0e                	jne    803c69 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803c5b:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803c62:	00 00 00 
  803c65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803c69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c6d:	48 89 c7             	mov    %rax,%rdi
  803c70:	48 b8 00 20 80 00 00 	movabs $0x802000,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c83:	79 27                	jns    803cac <ipc_recv+0x74>
		if (from_env_store != NULL)
  803c85:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c8a:	74 0a                	je     803c96 <ipc_recv+0x5e>
			*from_env_store = 0;
  803c8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c90:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803c96:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c9b:	74 0a                	je     803ca7 <ipc_recv+0x6f>
			*perm_store = 0;
  803c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803ca7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803caa:	eb 53                	jmp    803cff <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803cac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cb1:	74 19                	je     803ccc <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803cb3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cba:	00 00 00 
  803cbd:	48 8b 00             	mov    (%rax),%rax
  803cc0:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cca:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803ccc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cd1:	74 19                	je     803cec <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803cd3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cda:	00 00 00 
  803cdd:	48 8b 00             	mov    (%rax),%rax
  803ce0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cea:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803cec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cf3:	00 00 00 
  803cf6:	48 8b 00             	mov    (%rax),%rax
  803cf9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803cff:	c9                   	leaveq 
  803d00:	c3                   	retq   

0000000000803d01 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d01:	55                   	push   %rbp
  803d02:	48 89 e5             	mov    %rsp,%rbp
  803d05:	48 83 ec 30          	sub    $0x30,%rsp
  803d09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d0c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d0f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d13:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803d16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803d1e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d23:	75 10                	jne    803d35 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803d25:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d2c:	00 00 00 
  803d2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803d33:	eb 0e                	jmp    803d43 <ipc_send+0x42>
  803d35:	eb 0c                	jmp    803d43 <ipc_send+0x42>
		sys_yield();
  803d37:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803d43:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d46:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d49:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d4d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d50:	89 c7                	mov    %eax,%edi
  803d52:	48 b8 ab 1f 80 00 00 	movabs $0x801fab,%rax
  803d59:	00 00 00 
  803d5c:	ff d0                	callq  *%rax
  803d5e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803d61:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803d65:	74 d0                	je     803d37 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803d6b:	74 2a                	je     803d97 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803d6d:	48 ba 71 45 80 00 00 	movabs $0x804571,%rdx
  803d74:	00 00 00 
  803d77:	be 49 00 00 00       	mov    $0x49,%esi
  803d7c:	48 bf 8d 45 80 00 00 	movabs $0x80458d,%rdi
  803d83:	00 00 00 
  803d86:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8b:	48 b9 c7 04 80 00 00 	movabs $0x8004c7,%rcx
  803d92:	00 00 00 
  803d95:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803d97:	c9                   	leaveq 
  803d98:	c3                   	retq   

0000000000803d99 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d99:	55                   	push   %rbp
  803d9a:	48 89 e5             	mov    %rsp,%rbp
  803d9d:	48 83 ec 14          	sub    $0x14,%rsp
  803da1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dab:	eb 5e                	jmp    803e0b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803dad:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803db4:	00 00 00 
  803db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dba:	48 63 d0             	movslq %eax,%rdx
  803dbd:	48 89 d0             	mov    %rdx,%rax
  803dc0:	48 c1 e0 03          	shl    $0x3,%rax
  803dc4:	48 01 d0             	add    %rdx,%rax
  803dc7:	48 c1 e0 05          	shl    $0x5,%rax
  803dcb:	48 01 c8             	add    %rcx,%rax
  803dce:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dd4:	8b 00                	mov    (%rax),%eax
  803dd6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dd9:	75 2c                	jne    803e07 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ddb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803de2:	00 00 00 
  803de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de8:	48 63 d0             	movslq %eax,%rdx
  803deb:	48 89 d0             	mov    %rdx,%rax
  803dee:	48 c1 e0 03          	shl    $0x3,%rax
  803df2:	48 01 d0             	add    %rdx,%rax
  803df5:	48 c1 e0 05          	shl    $0x5,%rax
  803df9:	48 01 c8             	add    %rcx,%rax
  803dfc:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e02:	8b 40 08             	mov    0x8(%rax),%eax
  803e05:	eb 12                	jmp    803e19 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803e07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e0b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e12:	7e 99                	jle    803dad <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e19:	c9                   	leaveq 
  803e1a:	c3                   	retq   

0000000000803e1b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e1b:	55                   	push   %rbp
  803e1c:	48 89 e5             	mov    %rsp,%rbp
  803e1f:	48 83 ec 18          	sub    $0x18,%rsp
  803e23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e2b:	48 c1 e8 15          	shr    $0x15,%rax
  803e2f:	48 89 c2             	mov    %rax,%rdx
  803e32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e39:	01 00 00 
  803e3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e40:	83 e0 01             	and    $0x1,%eax
  803e43:	48 85 c0             	test   %rax,%rax
  803e46:	75 07                	jne    803e4f <pageref+0x34>
		return 0;
  803e48:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4d:	eb 53                	jmp    803ea2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e53:	48 c1 e8 0c          	shr    $0xc,%rax
  803e57:	48 89 c2             	mov    %rax,%rdx
  803e5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e61:	01 00 00 
  803e64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e70:	83 e0 01             	and    $0x1,%eax
  803e73:	48 85 c0             	test   %rax,%rax
  803e76:	75 07                	jne    803e7f <pageref+0x64>
		return 0;
  803e78:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7d:	eb 23                	jmp    803ea2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e83:	48 c1 e8 0c          	shr    $0xc,%rax
  803e87:	48 89 c2             	mov    %rax,%rdx
  803e8a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e91:	00 00 00 
  803e94:	48 c1 e2 04          	shl    $0x4,%rdx
  803e98:	48 01 d0             	add    %rdx,%rax
  803e9b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e9f:	0f b7 c0             	movzwl %ax,%eax
}
  803ea2:	c9                   	leaveq 
  803ea3:	c3                   	retq   
