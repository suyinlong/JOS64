
obj/user/sendpage.debug:     file format elf64-x86-64


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
  80003c:	e8 66 02 00 00       	callq  8002a7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 2c 20 80 00 00 	movabs $0x80202c,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf 8c 3d 80 00 00 	movabs $0x803d8c,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf a8 3d 80 00 00 	movabs $0x803da8,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 62 16 80 00 00 	movabs $0x801662,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 62 16 80 00 00 	movabs $0x801662,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf 8c 3d 80 00 00 	movabs $0x803d8c,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf c8 3d 80 00 00 	movabs $0x803dc8,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 10          	sub    $0x10,%rsp
  8002af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8002b6:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	48 98                	cltq   
  8002c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c9:	48 89 c2             	mov    %rax,%rdx
  8002cc:	48 89 d0             	mov    %rdx,%rax
  8002cf:	48 c1 e0 03          	shl    $0x3,%rax
  8002d3:	48 01 d0             	add    %rdx,%rax
  8002d6:	48 c1 e0 05          	shl    $0x5,%rax
  8002da:	48 89 c2             	mov    %rax,%rdx
  8002dd:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002e4:	00 00 00 
  8002e7:	48 01 c2             	add    %rax,%rdx
  8002ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002f1:	00 00 00 
  8002f4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002fb:	7e 14                	jle    800311 <libmain+0x6a>
		binaryname = argv[0];
  8002fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800301:	48 8b 10             	mov    (%rax),%rdx
  800304:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80030b:	00 00 00 
  80030e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800315:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800318:	48 89 d6             	mov    %rdx,%rsi
  80031b:	89 c7                	mov    %eax,%edi
  80031d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800329:	48 b8 37 03 80 00 00 	movabs $0x800337,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
}
  800335:	c9                   	leaveq 
  800336:	c3                   	retq   

0000000000800337 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800337:	55                   	push   %rbp
  800338:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80033b:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  800342:	00 00 00 
  800345:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800347:	bf 00 00 00 00       	mov    $0x0,%edi
  80034c:	48 b8 96 1a 80 00 00 	movabs $0x801a96,%rax
  800353:	00 00 00 
  800356:	ff d0                	callq  *%rax
}
  800358:	5d                   	pop    %rbp
  800359:	c3                   	retq   

000000000080035a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80035a:	55                   	push   %rbp
  80035b:	48 89 e5             	mov    %rsp,%rbp
  80035e:	48 83 ec 10          	sub    $0x10,%rsp
  800362:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800365:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036d:	8b 00                	mov    (%rax),%eax
  80036f:	8d 48 01             	lea    0x1(%rax),%ecx
  800372:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800376:	89 0a                	mov    %ecx,(%rdx)
  800378:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800381:	48 98                	cltq   
  800383:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038b:	8b 00                	mov    (%rax),%eax
  80038d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800392:	75 2c                	jne    8003c0 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800398:	8b 00                	mov    (%rax),%eax
  80039a:	48 98                	cltq   
  80039c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a0:	48 83 c2 08          	add    $0x8,%rdx
  8003a4:	48 89 c6             	mov    %rax,%rsi
  8003a7:	48 89 d7             	mov    %rdx,%rdi
  8003aa:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax
		b->idx = 0;
  8003b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	8b 40 04             	mov    0x4(%rax),%eax
  8003c7:	8d 50 01             	lea    0x1(%rax),%edx
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003de:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003e5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003ec:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003f3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003fa:	48 8b 0a             	mov    (%rdx),%rcx
  8003fd:	48 89 08             	mov    %rcx,(%rax)
  800400:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800404:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800408:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80040c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800417:	00 00 00 
	b.cnt = 0;
  80041a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800421:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800424:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80042b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800432:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800439:	48 89 c6             	mov    %rax,%rsi
  80043c:	48 bf 5a 03 80 00 00 	movabs $0x80035a,%rdi
  800443:	00 00 00 
  800446:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800452:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800458:	48 98                	cltq   
  80045a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800461:	48 83 c2 08          	add    $0x8,%rdx
  800465:	48 89 c6             	mov    %rax,%rsi
  800468:	48 89 d7             	mov    %rdx,%rdi
  80046b:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  800472:	00 00 00 
  800475:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800477:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80047d:	c9                   	leaveq 
  80047e:	c3                   	retq   

000000000080047f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80047f:	55                   	push   %rbp
  800480:	48 89 e5             	mov    %rsp,%rbp
  800483:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80048a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800491:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800498:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80049f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004ad:	84 c0                	test   %al,%al
  8004af:	74 20                	je     8004d1 <cprintf+0x52>
  8004b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004d8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004df:	00 00 00 
  8004e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004e9:	00 00 00 
  8004ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800505:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80050c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800513:	48 8b 0a             	mov    (%rdx),%rcx
  800516:	48 89 08             	mov    %rcx,(%rax)
  800519:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80051d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800521:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800525:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800529:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800530:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800537:	48 89 d6             	mov    %rdx,%rsi
  80053a:	48 89 c7             	mov    %rax,%rdi
  80053d:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  800544:	00 00 00 
  800547:	ff d0                	callq  *%rax
  800549:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80054f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800555:	c9                   	leaveq 
  800556:	c3                   	retq   

0000000000800557 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800557:	55                   	push   %rbp
  800558:	48 89 e5             	mov    %rsp,%rbp
  80055b:	53                   	push   %rbx
  80055c:	48 83 ec 38          	sub    $0x38,%rsp
  800560:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800564:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800568:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80056c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80056f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800573:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800577:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80057a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80057e:	77 3b                	ja     8005bb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800580:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800583:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800587:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80058a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80058e:	ba 00 00 00 00       	mov    $0x0,%edx
  800593:	48 f7 f3             	div    %rbx
  800596:	48 89 c2             	mov    %rax,%rdx
  800599:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80059c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a7:	41 89 f9             	mov    %edi,%r9d
  8005aa:	48 89 c7             	mov    %rax,%rdi
  8005ad:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  8005b4:	00 00 00 
  8005b7:	ff d0                	callq  *%rax
  8005b9:	eb 1e                	jmp    8005d9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bb:	eb 12                	jmp    8005cf <printnum+0x78>
			putch(padc, putdat);
  8005bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 89 ce             	mov    %rcx,%rsi
  8005cb:	89 d7                	mov    %edx,%edi
  8005cd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005cf:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005d7:	7f e4                	jg     8005bd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	48 f7 f1             	div    %rcx
  8005e8:	48 89 d0             	mov    %rdx,%rax
  8005eb:	48 ba c8 3f 80 00 00 	movabs $0x803fc8,%rdx
  8005f2:	00 00 00 
  8005f5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005f9:	0f be d0             	movsbl %al,%edx
  8005fc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 89 ce             	mov    %rcx,%rsi
  800607:	89 d7                	mov    %edx,%edi
  800609:	ff d0                	callq  *%rax
}
  80060b:	48 83 c4 38          	add    $0x38,%rsp
  80060f:	5b                   	pop    %rbx
  800610:	5d                   	pop    %rbp
  800611:	c3                   	retq   

0000000000800612 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800612:	55                   	push   %rbp
  800613:	48 89 e5             	mov    %rsp,%rbp
  800616:	48 83 ec 1c          	sub    $0x1c,%rsp
  80061a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800621:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800625:	7e 52                	jle    800679 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	83 f8 30             	cmp    $0x30,%eax
  800630:	73 24                	jae    800656 <getuint+0x44>
  800632:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800636:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	8b 00                	mov    (%rax),%eax
  800640:	89 c0                	mov    %eax,%eax
  800642:	48 01 d0             	add    %rdx,%rax
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	8b 12                	mov    (%rdx),%edx
  80064b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	89 0a                	mov    %ecx,(%rdx)
  800654:	eb 17                	jmp    80066d <getuint+0x5b>
  800656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80065e:	48 89 d0             	mov    %rdx,%rax
  800661:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80066d:	48 8b 00             	mov    (%rax),%rax
  800670:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800674:	e9 a3 00 00 00       	jmpq   80071c <getuint+0x10a>
	else if (lflag)
  800679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80067d:	74 4f                	je     8006ce <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	83 f8 30             	cmp    $0x30,%eax
  800688:	73 24                	jae    8006ae <getuint+0x9c>
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	8b 12                	mov    (%rdx),%edx
  8006a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	89 0a                	mov    %ecx,(%rdx)
  8006ac:	eb 17                	jmp    8006c5 <getuint+0xb3>
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b6:	48 89 d0             	mov    %rdx,%rax
  8006b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c5:	48 8b 00             	mov    (%rax),%rax
  8006c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cc:	eb 4e                	jmp    80071c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	83 f8 30             	cmp    $0x30,%eax
  8006d7:	73 24                	jae    8006fd <getuint+0xeb>
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	8b 00                	mov    (%rax),%eax
  8006e7:	89 c0                	mov    %eax,%eax
  8006e9:	48 01 d0             	add    %rdx,%rax
  8006ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f0:	8b 12                	mov    (%rdx),%edx
  8006f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f9:	89 0a                	mov    %ecx,(%rdx)
  8006fb:	eb 17                	jmp    800714 <getuint+0x102>
  8006fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800701:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800705:	48 89 d0             	mov    %rdx,%rax
  800708:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80070c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800710:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800714:	8b 00                	mov    (%rax),%eax
  800716:	89 c0                	mov    %eax,%eax
  800718:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80071c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800720:	c9                   	leaveq 
  800721:	c3                   	retq   

0000000000800722 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800731:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800735:	7e 52                	jle    800789 <getint+0x67>
		x=va_arg(*ap, long long);
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	83 f8 30             	cmp    $0x30,%eax
  800740:	73 24                	jae    800766 <getint+0x44>
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 01 d0             	add    %rdx,%rax
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	8b 12                	mov    (%rdx),%edx
  80075b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	89 0a                	mov    %ecx,(%rdx)
  800764:	eb 17                	jmp    80077d <getint+0x5b>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076e:	48 89 d0             	mov    %rdx,%rax
  800771:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800784:	e9 a3 00 00 00       	jmpq   80082c <getint+0x10a>
	else if (lflag)
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078d:	74 4f                	je     8007de <getint+0xbc>
		x=va_arg(*ap, long);
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	83 f8 30             	cmp    $0x30,%eax
  800798:	73 24                	jae    8007be <getint+0x9c>
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	8b 00                	mov    (%rax),%eax
  8007a8:	89 c0                	mov    %eax,%eax
  8007aa:	48 01 d0             	add    %rdx,%rax
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	8b 12                	mov    (%rdx),%edx
  8007b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	89 0a                	mov    %ecx,(%rdx)
  8007bc:	eb 17                	jmp    8007d5 <getint+0xb3>
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c6:	48 89 d0             	mov    %rdx,%rax
  8007c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dc:	eb 4e                	jmp    80082c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getint+0xeb>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	8b 12                	mov    (%rdx),%edx
  800802:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	89 0a                	mov    %ecx,(%rdx)
  80080b:	eb 17                	jmp    800824 <getint+0x102>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800824:	8b 00                	mov    (%rax),%eax
  800826:	48 98                	cltq   
  800828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80082c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800830:	c9                   	leaveq 
  800831:	c3                   	retq   

0000000000800832 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800832:	55                   	push   %rbp
  800833:	48 89 e5             	mov    %rsp,%rbp
  800836:	41 54                	push   %r12
  800838:	53                   	push   %rbx
  800839:	48 83 ec 60          	sub    $0x60,%rsp
  80083d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800841:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800845:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800849:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80084d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800851:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800855:	48 8b 0a             	mov    (%rdx),%rcx
  800858:	48 89 08             	mov    %rcx,(%rax)
  80085b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800863:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800867:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80086b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800873:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800877:	0f b6 00             	movzbl (%rax),%eax
  80087a:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80087d:	eb 29                	jmp    8008a8 <vprintfmt+0x76>
			if (ch == '\0')
  80087f:	85 db                	test   %ebx,%ebx
  800881:	0f 84 ad 06 00 00    	je     800f34 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800887:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80088b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088f:	48 89 d6             	mov    %rdx,%rsi
  800892:	89 df                	mov    %ebx,%edi
  800894:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800896:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80089e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a2:	0f b6 00             	movzbl (%rax),%eax
  8008a5:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8008a8:	83 fb 25             	cmp    $0x25,%ebx
  8008ab:	74 05                	je     8008b2 <vprintfmt+0x80>
  8008ad:	83 fb 1b             	cmp    $0x1b,%ebx
  8008b0:	75 cd                	jne    80087f <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8008b2:	83 fb 1b             	cmp    $0x1b,%ebx
  8008b5:	0f 85 ae 01 00 00    	jne    800a69 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8008bb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8008c2:	00 00 00 
  8008c5:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8008cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d3:	48 89 d6             	mov    %rdx,%rsi
  8008d6:	89 df                	mov    %ebx,%edi
  8008d8:	ff d0                	callq  *%rax
			putch('[', putdat);
  8008da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e2:	48 89 d6             	mov    %rdx,%rsi
  8008e5:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8008ea:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8008ec:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8008f2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008f7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008fb:	0f b6 00             	movzbl (%rax),%eax
  8008fe:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800901:	eb 32                	jmp    800935 <vprintfmt+0x103>
					putch(ch, putdat);
  800903:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800907:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090b:	48 89 d6             	mov    %rdx,%rsi
  80090e:	89 df                	mov    %ebx,%edi
  800910:	ff d0                	callq  *%rax
					esc_color *= 10;
  800912:	44 89 e0             	mov    %r12d,%eax
  800915:	c1 e0 02             	shl    $0x2,%eax
  800918:	44 01 e0             	add    %r12d,%eax
  80091b:	01 c0                	add    %eax,%eax
  80091d:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800920:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800923:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800926:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80092b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092f:	0f b6 00             	movzbl (%rax),%eax
  800932:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800935:	83 fb 3b             	cmp    $0x3b,%ebx
  800938:	74 05                	je     80093f <vprintfmt+0x10d>
  80093a:	83 fb 6d             	cmp    $0x6d,%ebx
  80093d:	75 c4                	jne    800903 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80093f:	45 85 e4             	test   %r12d,%r12d
  800942:	75 15                	jne    800959 <vprintfmt+0x127>
					color_flag = 0x07;
  800944:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  80094b:	00 00 00 
  80094e:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800954:	e9 dc 00 00 00       	jmpq   800a35 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800959:	41 83 fc 1d          	cmp    $0x1d,%r12d
  80095d:	7e 69                	jle    8009c8 <vprintfmt+0x196>
  80095f:	41 83 fc 25          	cmp    $0x25,%r12d
  800963:	7f 63                	jg     8009c8 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800965:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  80096c:	00 00 00 
  80096f:	8b 00                	mov    (%rax),%eax
  800971:	25 f8 00 00 00       	and    $0xf8,%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  80097f:	00 00 00 
  800982:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800984:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800988:	44 89 e0             	mov    %r12d,%eax
  80098b:	83 e0 04             	and    $0x4,%eax
  80098e:	c1 f8 02             	sar    $0x2,%eax
  800991:	89 c2                	mov    %eax,%edx
  800993:	44 89 e0             	mov    %r12d,%eax
  800996:	83 e0 02             	and    $0x2,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	44 89 e0             	mov    %r12d,%eax
  80099e:	83 e0 01             	and    $0x1,%eax
  8009a1:	c1 e0 02             	shl    $0x2,%eax
  8009a4:	09 c2                	or     %eax,%edx
  8009a6:	41 89 d4             	mov    %edx,%r12d
  8009a9:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  8009b0:	00 00 00 
  8009b3:	8b 00                	mov    (%rax),%eax
  8009b5:	44 89 e2             	mov    %r12d,%edx
  8009b8:	09 c2                	or     %eax,%edx
  8009ba:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  8009c1:	00 00 00 
  8009c4:	89 10                	mov    %edx,(%rax)
  8009c6:	eb 6d                	jmp    800a35 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8009c8:	41 83 fc 27          	cmp    $0x27,%r12d
  8009cc:	7e 67                	jle    800a35 <vprintfmt+0x203>
  8009ce:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8009d2:	7f 61                	jg     800a35 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8009d4:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  8009db:	00 00 00 
  8009de:	8b 00                	mov    (%rax),%eax
  8009e0:	25 8f 00 00 00       	and    $0x8f,%eax
  8009e5:	89 c2                	mov    %eax,%edx
  8009e7:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  8009ee:	00 00 00 
  8009f1:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8009f3:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8009f7:	44 89 e0             	mov    %r12d,%eax
  8009fa:	83 e0 04             	and    $0x4,%eax
  8009fd:	c1 f8 02             	sar    $0x2,%eax
  800a00:	89 c2                	mov    %eax,%edx
  800a02:	44 89 e0             	mov    %r12d,%eax
  800a05:	83 e0 02             	and    $0x2,%eax
  800a08:	09 c2                	or     %eax,%edx
  800a0a:	44 89 e0             	mov    %r12d,%eax
  800a0d:	83 e0 01             	and    $0x1,%eax
  800a10:	c1 e0 06             	shl    $0x6,%eax
  800a13:	09 c2                	or     %eax,%edx
  800a15:	41 89 d4             	mov    %edx,%r12d
  800a18:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800a1f:	00 00 00 
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	44 89 e2             	mov    %r12d,%edx
  800a27:	09 c2                	or     %eax,%edx
  800a29:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800a30:	00 00 00 
  800a33:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800a35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3d:	48 89 d6             	mov    %rdx,%rsi
  800a40:	89 df                	mov    %ebx,%edi
  800a42:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800a44:	83 fb 6d             	cmp    $0x6d,%ebx
  800a47:	75 1b                	jne    800a64 <vprintfmt+0x232>
					fmt ++;
  800a49:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800a4e:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800a4f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800a56:	00 00 00 
  800a59:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800a5f:	e9 cb 04 00 00       	jmpq   800f2f <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800a64:	e9 83 fe ff ff       	jmpq   8008ec <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800a69:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a6d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a74:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a82:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a89:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a8d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a91:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a95:	0f b6 00             	movzbl (%rax),%eax
  800a98:	0f b6 d8             	movzbl %al,%ebx
  800a9b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a9e:	83 f8 55             	cmp    $0x55,%eax
  800aa1:	0f 87 5a 04 00 00    	ja     800f01 <vprintfmt+0x6cf>
  800aa7:	89 c0                	mov    %eax,%eax
  800aa9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ab0:	00 
  800ab1:	48 b8 f0 3f 80 00 00 	movabs $0x803ff0,%rax
  800ab8:	00 00 00 
  800abb:	48 01 d0             	add    %rdx,%rax
  800abe:	48 8b 00             	mov    (%rax),%rax
  800ac1:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ac7:	eb c0                	jmp    800a89 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800acd:	eb ba                	jmp    800a89 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800acf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ad6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad9:	89 d0                	mov    %edx,%eax
  800adb:	c1 e0 02             	shl    $0x2,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	01 c0                	add    %eax,%eax
  800ae2:	01 d8                	add    %ebx,%eax
  800ae4:	83 e8 30             	sub    $0x30,%eax
  800ae7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aea:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aee:	0f b6 00             	movzbl (%rax),%eax
  800af1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800af4:	83 fb 2f             	cmp    $0x2f,%ebx
  800af7:	7e 0c                	jle    800b05 <vprintfmt+0x2d3>
  800af9:	83 fb 39             	cmp    $0x39,%ebx
  800afc:	7f 07                	jg     800b05 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800afe:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b03:	eb d1                	jmp    800ad6 <vprintfmt+0x2a4>
			goto process_precision;
  800b05:	eb 58                	jmp    800b5f <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800b07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0a:	83 f8 30             	cmp    $0x30,%eax
  800b0d:	73 17                	jae    800b26 <vprintfmt+0x2f4>
  800b0f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b16:	89 c0                	mov    %eax,%eax
  800b18:	48 01 d0             	add    %rdx,%rax
  800b1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b24:	eb 0f                	jmp    800b35 <vprintfmt+0x303>
  800b26:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2a:	48 89 d0             	mov    %rdx,%rax
  800b2d:	48 83 c2 08          	add    $0x8,%rdx
  800b31:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b35:	8b 00                	mov    (%rax),%eax
  800b37:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800b3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b40:	79 0c                	jns    800b4e <vprintfmt+0x31c>
				width = 0;
  800b42:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b49:	e9 3b ff ff ff       	jmpq   800a89 <vprintfmt+0x257>
  800b4e:	e9 36 ff ff ff       	jmpq   800a89 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800b53:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b5a:	e9 2a ff ff ff       	jmpq   800a89 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800b5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b63:	79 12                	jns    800b77 <vprintfmt+0x345>
				width = precision, precision = -1;
  800b65:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b68:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b6b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b72:	e9 12 ff ff ff       	jmpq   800a89 <vprintfmt+0x257>
  800b77:	e9 0d ff ff ff       	jmpq   800a89 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b7c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b80:	e9 04 ff ff ff       	jmpq   800a89 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b88:	83 f8 30             	cmp    $0x30,%eax
  800b8b:	73 17                	jae    800ba4 <vprintfmt+0x372>
  800b8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b94:	89 c0                	mov    %eax,%eax
  800b96:	48 01 d0             	add    %rdx,%rax
  800b99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9c:	83 c2 08             	add    $0x8,%edx
  800b9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba2:	eb 0f                	jmp    800bb3 <vprintfmt+0x381>
  800ba4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba8:	48 89 d0             	mov    %rdx,%rax
  800bab:	48 83 c2 08          	add    $0x8,%rdx
  800baf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb3:	8b 10                	mov    (%rax),%edx
  800bb5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbd:	48 89 ce             	mov    %rcx,%rsi
  800bc0:	89 d7                	mov    %edx,%edi
  800bc2:	ff d0                	callq  *%rax
			break;
  800bc4:	e9 66 03 00 00       	jmpq   800f2f <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	83 f8 30             	cmp    $0x30,%eax
  800bcf:	73 17                	jae    800be8 <vprintfmt+0x3b6>
  800bd1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd8:	89 c0                	mov    %eax,%eax
  800bda:	48 01 d0             	add    %rdx,%rax
  800bdd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be0:	83 c2 08             	add    $0x8,%edx
  800be3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be6:	eb 0f                	jmp    800bf7 <vprintfmt+0x3c5>
  800be8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bec:	48 89 d0             	mov    %rdx,%rax
  800bef:	48 83 c2 08          	add    $0x8,%rdx
  800bf3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf9:	85 db                	test   %ebx,%ebx
  800bfb:	79 02                	jns    800bff <vprintfmt+0x3cd>
				err = -err;
  800bfd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bff:	83 fb 10             	cmp    $0x10,%ebx
  800c02:	7f 16                	jg     800c1a <vprintfmt+0x3e8>
  800c04:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  800c0b:	00 00 00 
  800c0e:	48 63 d3             	movslq %ebx,%rdx
  800c11:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c15:	4d 85 e4             	test   %r12,%r12
  800c18:	75 2e                	jne    800c48 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800c1a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c22:	89 d9                	mov    %ebx,%ecx
  800c24:	48 ba d9 3f 80 00 00 	movabs $0x803fd9,%rdx
  800c2b:	00 00 00 
  800c2e:	48 89 c7             	mov    %rax,%rdi
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	49 b8 3d 0f 80 00 00 	movabs $0x800f3d,%r8
  800c3d:	00 00 00 
  800c40:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c43:	e9 e7 02 00 00       	jmpq   800f2f <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c48:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c50:	4c 89 e1             	mov    %r12,%rcx
  800c53:	48 ba e2 3f 80 00 00 	movabs $0x803fe2,%rdx
  800c5a:	00 00 00 
  800c5d:	48 89 c7             	mov    %rax,%rdi
  800c60:	b8 00 00 00 00       	mov    $0x0,%eax
  800c65:	49 b8 3d 0f 80 00 00 	movabs $0x800f3d,%r8
  800c6c:	00 00 00 
  800c6f:	41 ff d0             	callq  *%r8
			break;
  800c72:	e9 b8 02 00 00       	jmpq   800f2f <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7a:	83 f8 30             	cmp    $0x30,%eax
  800c7d:	73 17                	jae    800c96 <vprintfmt+0x464>
  800c7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 01 d0             	add    %rdx,%rax
  800c8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c8e:	83 c2 08             	add    $0x8,%edx
  800c91:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c94:	eb 0f                	jmp    800ca5 <vprintfmt+0x473>
  800c96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9a:	48 89 d0             	mov    %rdx,%rax
  800c9d:	48 83 c2 08          	add    $0x8,%rdx
  800ca1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca5:	4c 8b 20             	mov    (%rax),%r12
  800ca8:	4d 85 e4             	test   %r12,%r12
  800cab:	75 0a                	jne    800cb7 <vprintfmt+0x485>
				p = "(null)";
  800cad:	49 bc e5 3f 80 00 00 	movabs $0x803fe5,%r12
  800cb4:	00 00 00 
			if (width > 0 && padc != '-')
  800cb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbb:	7e 3f                	jle    800cfc <vprintfmt+0x4ca>
  800cbd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cc1:	74 39                	je     800cfc <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cc6:	48 98                	cltq   
  800cc8:	48 89 c6             	mov    %rax,%rsi
  800ccb:	4c 89 e7             	mov    %r12,%rdi
  800cce:	48 b8 e9 11 80 00 00 	movabs $0x8011e9,%rax
  800cd5:	00 00 00 
  800cd8:	ff d0                	callq  *%rax
  800cda:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cdd:	eb 17                	jmp    800cf6 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800cdf:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ce3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ce7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ceb:	48 89 ce             	mov    %rcx,%rsi
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfa:	7f e3                	jg     800cdf <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cfc:	eb 37                	jmp    800d35 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d02:	74 1e                	je     800d22 <vprintfmt+0x4f0>
  800d04:	83 fb 1f             	cmp    $0x1f,%ebx
  800d07:	7e 05                	jle    800d0e <vprintfmt+0x4dc>
  800d09:	83 fb 7e             	cmp    $0x7e,%ebx
  800d0c:	7e 14                	jle    800d22 <vprintfmt+0x4f0>
					putch('?', putdat);
  800d0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d16:	48 89 d6             	mov    %rdx,%rsi
  800d19:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d1e:	ff d0                	callq  *%rax
  800d20:	eb 0f                	jmp    800d31 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	48 89 d6             	mov    %rdx,%rsi
  800d2d:	89 df                	mov    %ebx,%edi
  800d2f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d31:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d35:	4c 89 e0             	mov    %r12,%rax
  800d38:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d3c:	0f b6 00             	movzbl (%rax),%eax
  800d3f:	0f be d8             	movsbl %al,%ebx
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	74 10                	je     800d56 <vprintfmt+0x524>
  800d46:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4a:	78 b2                	js     800cfe <vprintfmt+0x4cc>
  800d4c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d50:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d54:	79 a8                	jns    800cfe <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d56:	eb 16                	jmp    800d6e <vprintfmt+0x53c>
				putch(' ', putdat);
  800d58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d60:	48 89 d6             	mov    %rdx,%rsi
  800d63:	bf 20 00 00 00       	mov    $0x20,%edi
  800d68:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d72:	7f e4                	jg     800d58 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800d74:	e9 b6 01 00 00       	jmpq   800f2f <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d79:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7d:	be 03 00 00 00       	mov    $0x3,%esi
  800d82:	48 89 c7             	mov    %rax,%rdi
  800d85:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800d8c:	00 00 00 
  800d8f:	ff d0                	callq  *%rax
  800d91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d99:	48 85 c0             	test   %rax,%rax
  800d9c:	79 1d                	jns    800dbb <vprintfmt+0x589>
				putch('-', putdat);
  800d9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da6:	48 89 d6             	mov    %rdx,%rsi
  800da9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dae:	ff d0                	callq  *%rax
				num = -(long long) num;
  800db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db4:	48 f7 d8             	neg    %rax
  800db7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dbb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dc2:	e9 fb 00 00 00       	jmpq   800ec2 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dcb:	be 03 00 00 00       	mov    $0x3,%esi
  800dd0:	48 89 c7             	mov    %rax,%rdi
  800dd3:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	callq  *%rax
  800ddf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800de3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dea:	e9 d3 00 00 00       	jmpq   800ec2 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800def:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df3:	be 03 00 00 00       	mov    $0x3,%esi
  800df8:	48 89 c7             	mov    %rax,%rdi
  800dfb:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	callq  *%rax
  800e07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0f:	48 85 c0             	test   %rax,%rax
  800e12:	79 1d                	jns    800e31 <vprintfmt+0x5ff>
				putch('-', putdat);
  800e14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1c:	48 89 d6             	mov    %rdx,%rsi
  800e1f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e24:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2a:	48 f7 d8             	neg    %rax
  800e2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800e31:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e38:	e9 85 00 00 00       	jmpq   800ec2 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800e3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e45:	48 89 d6             	mov    %rdx,%rsi
  800e48:	bf 30 00 00 00       	mov    $0x30,%edi
  800e4d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e57:	48 89 d6             	mov    %rdx,%rsi
  800e5a:	bf 78 00 00 00       	mov    $0x78,%edi
  800e5f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e64:	83 f8 30             	cmp    $0x30,%eax
  800e67:	73 17                	jae    800e80 <vprintfmt+0x64e>
  800e69:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e70:	89 c0                	mov    %eax,%eax
  800e72:	48 01 d0             	add    %rdx,%rax
  800e75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e78:	83 c2 08             	add    $0x8,%edx
  800e7b:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7e:	eb 0f                	jmp    800e8f <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800e80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e84:	48 89 d0             	mov    %rdx,%rax
  800e87:	48 83 c2 08          	add    $0x8,%rdx
  800e8b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e8f:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e96:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e9d:	eb 23                	jmp    800ec2 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e9f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea3:	be 03 00 00 00       	mov    $0x3,%esi
  800ea8:	48 89 c7             	mov    %rax,%rdi
  800eab:	48 b8 12 06 80 00 00 	movabs $0x800612,%rax
  800eb2:	00 00 00 
  800eb5:	ff d0                	callq  *%rax
  800eb7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ebb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ec7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eca:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ecd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ed1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ed5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed9:	45 89 c1             	mov    %r8d,%r9d
  800edc:	41 89 f8             	mov    %edi,%r8d
  800edf:	48 89 c7             	mov    %rax,%rdi
  800ee2:	48 b8 57 05 80 00 00 	movabs $0x800557,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	callq  *%rax
			break;
  800eee:	eb 3f                	jmp    800f2f <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef8:	48 89 d6             	mov    %rdx,%rsi
  800efb:	89 df                	mov    %ebx,%edi
  800efd:	ff d0                	callq  *%rax
			break;
  800eff:	eb 2e                	jmp    800f2f <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f09:	48 89 d6             	mov    %rdx,%rsi
  800f0c:	bf 25 00 00 00       	mov    $0x25,%edi
  800f11:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f13:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f18:	eb 05                	jmp    800f1f <vprintfmt+0x6ed>
  800f1a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f1f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f23:	48 83 e8 01          	sub    $0x1,%rax
  800f27:	0f b6 00             	movzbl (%rax),%eax
  800f2a:	3c 25                	cmp    $0x25,%al
  800f2c:	75 ec                	jne    800f1a <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800f2e:	90                   	nop
		}
	}
  800f2f:	e9 37 f9 ff ff       	jmpq   80086b <vprintfmt+0x39>
    va_end(aq);
}
  800f34:	48 83 c4 60          	add    $0x60,%rsp
  800f38:	5b                   	pop    %rbx
  800f39:	41 5c                	pop    %r12
  800f3b:	5d                   	pop    %rbp
  800f3c:	c3                   	retq   

0000000000800f3d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f48:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f4f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f6b:	84 c0                	test   %al,%al
  800f6d:	74 20                	je     800f8f <printfmt+0x52>
  800f6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f8f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f96:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f9d:	00 00 00 
  800fa0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fa7:	00 00 00 
  800faa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fb5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fbc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fd1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fd8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fdf:	48 89 c7             	mov    %rax,%rdi
  800fe2:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800fe9:	00 00 00 
  800fec:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 10          	sub    $0x10,%rsp
  800ff8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ffb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801003:	8b 40 10             	mov    0x10(%rax),%eax
  801006:	8d 50 01             	lea    0x1(%rax),%edx
  801009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801014:	48 8b 10             	mov    (%rax),%rdx
  801017:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80101f:	48 39 c2             	cmp    %rax,%rdx
  801022:	73 17                	jae    80103b <sprintputch+0x4b>
		*b->buf++ = ch;
  801024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801028:	48 8b 00             	mov    (%rax),%rax
  80102b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80102f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801033:	48 89 0a             	mov    %rcx,(%rdx)
  801036:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801039:	88 10                	mov    %dl,(%rax)
}
  80103b:	c9                   	leaveq 
  80103c:	c3                   	retq   

000000000080103d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	48 83 ec 50          	sub    $0x50,%rsp
  801045:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801049:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80104c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801050:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801054:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801058:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80105c:	48 8b 0a             	mov    (%rdx),%rcx
  80105f:	48 89 08             	mov    %rcx,(%rax)
  801062:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801066:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80106a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80106e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801072:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801076:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80107a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80107d:	48 98                	cltq   
  80107f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801083:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801087:	48 01 d0             	add    %rdx,%rax
  80108a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80108e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801095:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80109a:	74 06                	je     8010a2 <vsnprintf+0x65>
  80109c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010a0:	7f 07                	jg     8010a9 <vsnprintf+0x6c>
		return -E_INVAL;
  8010a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a7:	eb 2f                	jmp    8010d8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010a9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010ad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010b1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010b5:	48 89 c6             	mov    %rax,%rsi
  8010b8:	48 bf f0 0f 80 00 00 	movabs $0x800ff0,%rdi
  8010bf:	00 00 00 
  8010c2:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  8010c9:	00 00 00 
  8010cc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010d5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010e5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010ec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010f2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010f9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801100:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801107:	84 c0                	test   %al,%al
  801109:	74 20                	je     80112b <snprintf+0x51>
  80110b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80110f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801113:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801117:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80111b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80111f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801123:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801127:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80112b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801132:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801139:	00 00 00 
  80113c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801143:	00 00 00 
  801146:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80114a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801151:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801158:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80115f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801166:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80116d:	48 8b 0a             	mov    (%rdx),%rcx
  801170:	48 89 08             	mov    %rcx,(%rax)
  801173:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801177:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80117b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80117f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801183:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80118a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801191:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801197:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80119e:	48 89 c7             	mov    %rax,%rdi
  8011a1:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  8011a8:	00 00 00 
  8011ab:	ff d0                	callq  *%rax
  8011ad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011b3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011b9:	c9                   	leaveq 
  8011ba:	c3                   	retq   

00000000008011bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011bb:	55                   	push   %rbp
  8011bc:	48 89 e5             	mov    %rsp,%rbp
  8011bf:	48 83 ec 18          	sub    $0x18,%rsp
  8011c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ce:	eb 09                	jmp    8011d9 <strlen+0x1e>
		n++;
  8011d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011d4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	84 c0                	test   %al,%al
  8011e2:	75 ec                	jne    8011d0 <strlen+0x15>
		n++;
	return n;
  8011e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011e7:	c9                   	leaveq 
  8011e8:	c3                   	retq   

00000000008011e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011e9:	55                   	push   %rbp
  8011ea:	48 89 e5             	mov    %rsp,%rbp
  8011ed:	48 83 ec 20          	sub    $0x20,%rsp
  8011f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801200:	eb 0e                	jmp    801210 <strnlen+0x27>
		n++;
  801202:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801206:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801210:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801215:	74 0b                	je     801222 <strnlen+0x39>
  801217:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121b:	0f b6 00             	movzbl (%rax),%eax
  80121e:	84 c0                	test   %al,%al
  801220:	75 e0                	jne    801202 <strnlen+0x19>
		n++;
	return n;
  801222:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801225:	c9                   	leaveq 
  801226:	c3                   	retq   

0000000000801227 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801227:	55                   	push   %rbp
  801228:	48 89 e5             	mov    %rsp,%rbp
  80122b:	48 83 ec 20          	sub    $0x20,%rsp
  80122f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801233:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80123f:	90                   	nop
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801244:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801248:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80124c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801250:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801254:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801258:	0f b6 12             	movzbl (%rdx),%edx
  80125b:	88 10                	mov    %dl,(%rax)
  80125d:	0f b6 00             	movzbl (%rax),%eax
  801260:	84 c0                	test   %al,%al
  801262:	75 dc                	jne    801240 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 83 ec 20          	sub    $0x20,%rsp
  801272:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801276:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	48 89 c7             	mov    %rax,%rdi
  801281:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  801288:	00 00 00 
  80128b:	ff d0                	callq  *%rax
  80128d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801290:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801293:	48 63 d0             	movslq %eax,%rdx
  801296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129a:	48 01 c2             	add    %rax,%rdx
  80129d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a1:	48 89 c6             	mov    %rax,%rsi
  8012a4:	48 89 d7             	mov    %rdx,%rdi
  8012a7:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  8012ae:	00 00 00 
  8012b1:	ff d0                	callq  *%rax
	return dst;
  8012b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 28          	sub    $0x28,%rsp
  8012c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012d5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012dc:	00 
  8012dd:	eb 2a                	jmp    801309 <strncpy+0x50>
		*dst++ = *src;
  8012df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012ef:	0f b6 12             	movzbl (%rdx),%edx
  8012f2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f8:	0f b6 00             	movzbl (%rax),%eax
  8012fb:	84 c0                	test   %al,%al
  8012fd:	74 05                	je     801304 <strncpy+0x4b>
			src++;
  8012ff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801304:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801311:	72 cc                	jb     8012df <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 28          	sub    $0x28,%rsp
  801321:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801329:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80132d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801331:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801335:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80133a:	74 3d                	je     801379 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80133c:	eb 1d                	jmp    80135b <strlcpy+0x42>
			*dst++ = *src++;
  80133e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801342:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801346:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80134a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80134e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801352:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801356:	0f b6 12             	movzbl (%rdx),%edx
  801359:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801360:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801365:	74 0b                	je     801372 <strlcpy+0x59>
  801367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136b:	0f b6 00             	movzbl (%rax),%eax
  80136e:	84 c0                	test   %al,%al
  801370:	75 cc                	jne    80133e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801376:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801379:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	48 29 c2             	sub    %rax,%rdx
  801384:	48 89 d0             	mov    %rdx,%rax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 10          	sub    $0x10,%rsp
  801391:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801399:	eb 0a                	jmp    8013a5 <strcmp+0x1c>
		p++, q++;
  80139b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	0f b6 00             	movzbl (%rax),%eax
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 12                	je     8013c2 <strcmp+0x39>
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	0f b6 10             	movzbl (%rax),%edx
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	0f b6 00             	movzbl (%rax),%eax
  8013be:	38 c2                	cmp    %al,%dl
  8013c0:	74 d9                	je     80139b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c6:	0f b6 00             	movzbl (%rax),%eax
  8013c9:	0f b6 d0             	movzbl %al,%edx
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	0f b6 00             	movzbl (%rax),%eax
  8013d3:	0f b6 c0             	movzbl %al,%eax
  8013d6:	29 c2                	sub    %eax,%edx
  8013d8:	89 d0                	mov    %edx,%eax
}
  8013da:	c9                   	leaveq 
  8013db:	c3                   	retq   

00000000008013dc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013dc:	55                   	push   %rbp
  8013dd:	48 89 e5             	mov    %rsp,%rbp
  8013e0:	48 83 ec 18          	sub    $0x18,%rsp
  8013e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013f0:	eb 0f                	jmp    801401 <strncmp+0x25>
		n--, p++, q++;
  8013f2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801401:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801406:	74 1d                	je     801425 <strncmp+0x49>
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	84 c0                	test   %al,%al
  801411:	74 12                	je     801425 <strncmp+0x49>
  801413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801417:	0f b6 10             	movzbl (%rax),%edx
  80141a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141e:	0f b6 00             	movzbl (%rax),%eax
  801421:	38 c2                	cmp    %al,%dl
  801423:	74 cd                	je     8013f2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801425:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142a:	75 07                	jne    801433 <strncmp+0x57>
		return 0;
  80142c:	b8 00 00 00 00       	mov    $0x0,%eax
  801431:	eb 18                	jmp    80144b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	0f b6 d0             	movzbl %al,%edx
  80143d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	0f b6 c0             	movzbl %al,%eax
  801447:	29 c2                	sub    %eax,%edx
  801449:	89 d0                	mov    %edx,%eax
}
  80144b:	c9                   	leaveq 
  80144c:	c3                   	retq   

000000000080144d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144d:	55                   	push   %rbp
  80144e:	48 89 e5             	mov    %rsp,%rbp
  801451:	48 83 ec 0c          	sub    $0xc,%rsp
  801455:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801459:	89 f0                	mov    %esi,%eax
  80145b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80145e:	eb 17                	jmp    801477 <strchr+0x2a>
		if (*s == c)
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80146a:	75 06                	jne    801472 <strchr+0x25>
			return (char *) s;
  80146c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801470:	eb 15                	jmp    801487 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801472:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	0f b6 00             	movzbl (%rax),%eax
  80147e:	84 c0                	test   %al,%al
  801480:	75 de                	jne    801460 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801487:	c9                   	leaveq 
  801488:	c3                   	retq   

0000000000801489 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801489:	55                   	push   %rbp
  80148a:	48 89 e5             	mov    %rsp,%rbp
  80148d:	48 83 ec 0c          	sub    $0xc,%rsp
  801491:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801495:	89 f0                	mov    %esi,%eax
  801497:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80149a:	eb 13                	jmp    8014af <strfind+0x26>
		if (*s == c)
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014a6:	75 02                	jne    8014aa <strfind+0x21>
			break;
  8014a8:	eb 10                	jmp    8014ba <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b3:	0f b6 00             	movzbl (%rax),%eax
  8014b6:	84 c0                	test   %al,%al
  8014b8:	75 e2                	jne    80149c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 18          	sub    $0x18,%rsp
  8014c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014cc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d8:	75 06                	jne    8014e0 <memset+0x20>
		return v;
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	eb 69                	jmp    801549 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e4:	83 e0 03             	and    $0x3,%eax
  8014e7:	48 85 c0             	test   %rax,%rax
  8014ea:	75 48                	jne    801534 <memset+0x74>
  8014ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f0:	83 e0 03             	and    $0x3,%eax
  8014f3:	48 85 c0             	test   %rax,%rax
  8014f6:	75 3c                	jne    801534 <memset+0x74>
		c &= 0xFF;
  8014f8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801502:	c1 e0 18             	shl    $0x18,%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150a:	c1 e0 10             	shl    $0x10,%eax
  80150d:	09 c2                	or     %eax,%edx
  80150f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801512:	c1 e0 08             	shl    $0x8,%eax
  801515:	09 d0                	or     %edx,%eax
  801517:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151e:	48 c1 e8 02          	shr    $0x2,%rax
  801522:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801525:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801529:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152c:	48 89 d7             	mov    %rdx,%rdi
  80152f:	fc                   	cld    
  801530:	f3 ab                	rep stos %eax,%es:(%rdi)
  801532:	eb 11                	jmp    801545 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801534:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801538:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80153f:	48 89 d7             	mov    %rdx,%rdi
  801542:	fc                   	cld    
  801543:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	48 83 ec 28          	sub    $0x28,%rsp
  801553:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801557:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80155b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80155f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801577:	0f 83 88 00 00 00    	jae    801605 <memmove+0xba>
  80157d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801581:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801585:	48 01 d0             	add    %rdx,%rax
  801588:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80158c:	76 77                	jbe    801605 <memmove+0xba>
		s += n;
  80158e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801592:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80159e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a2:	83 e0 03             	and    $0x3,%eax
  8015a5:	48 85 c0             	test   %rax,%rax
  8015a8:	75 3b                	jne    8015e5 <memmove+0x9a>
  8015aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ae:	83 e0 03             	and    $0x3,%eax
  8015b1:	48 85 c0             	test   %rax,%rax
  8015b4:	75 2f                	jne    8015e5 <memmove+0x9a>
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	83 e0 03             	and    $0x3,%eax
  8015bd:	48 85 c0             	test   %rax,%rax
  8015c0:	75 23                	jne    8015e5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c6:	48 83 e8 04          	sub    $0x4,%rax
  8015ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ce:	48 83 ea 04          	sub    $0x4,%rdx
  8015d2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015d6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015da:	48 89 c7             	mov    %rax,%rdi
  8015dd:	48 89 d6             	mov    %rdx,%rsi
  8015e0:	fd                   	std    
  8015e1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015e3:	eb 1d                	jmp    801602 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	48 89 d7             	mov    %rdx,%rdi
  8015fc:	48 89 c1             	mov    %rax,%rcx
  8015ff:	fd                   	std    
  801600:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801602:	fc                   	cld    
  801603:	eb 57                	jmp    80165c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801609:	83 e0 03             	and    $0x3,%eax
  80160c:	48 85 c0             	test   %rax,%rax
  80160f:	75 36                	jne    801647 <memmove+0xfc>
  801611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801615:	83 e0 03             	and    $0x3,%eax
  801618:	48 85 c0             	test   %rax,%rax
  80161b:	75 2a                	jne    801647 <memmove+0xfc>
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	83 e0 03             	and    $0x3,%eax
  801624:	48 85 c0             	test   %rax,%rax
  801627:	75 1e                	jne    801647 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	48 c1 e8 02          	shr    $0x2,%rax
  801631:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801638:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163c:	48 89 c7             	mov    %rax,%rdi
  80163f:	48 89 d6             	mov    %rdx,%rsi
  801642:	fc                   	cld    
  801643:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801645:	eb 15                	jmp    80165c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80164f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801653:	48 89 c7             	mov    %rax,%rdi
  801656:	48 89 d6             	mov    %rdx,%rsi
  801659:	fc                   	cld    
  80165a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80165c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801660:	c9                   	leaveq 
  801661:	c3                   	retq   

0000000000801662 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801662:	55                   	push   %rbp
  801663:	48 89 e5             	mov    %rsp,%rbp
  801666:	48 83 ec 18          	sub    $0x18,%rsp
  80166a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80166e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801672:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	48 89 ce             	mov    %rcx,%rsi
  801685:	48 89 c7             	mov    %rax,%rdi
  801688:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	48 83 ec 28          	sub    $0x28,%rsp
  80169e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016ba:	eb 36                	jmp    8016f2 <memcmp+0x5c>
		if (*s1 != *s2)
  8016bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c0:	0f b6 10             	movzbl (%rax),%edx
  8016c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c7:	0f b6 00             	movzbl (%rax),%eax
  8016ca:	38 c2                	cmp    %al,%dl
  8016cc:	74 1a                	je     8016e8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d2:	0f b6 00             	movzbl (%rax),%eax
  8016d5:	0f b6 d0             	movzbl %al,%edx
  8016d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	0f b6 c0             	movzbl %al,%eax
  8016e2:	29 c2                	sub    %eax,%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	eb 20                	jmp    801708 <memcmp+0x72>
		s1++, s2++;
  8016e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016fe:	48 85 c0             	test   %rax,%rax
  801701:	75 b9                	jne    8016bc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801708:	c9                   	leaveq 
  801709:	c3                   	retq   

000000000080170a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80170a:	55                   	push   %rbp
  80170b:	48 89 e5             	mov    %rsp,%rbp
  80170e:	48 83 ec 28          	sub    $0x28,%rsp
  801712:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801716:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801719:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801725:	48 01 d0             	add    %rdx,%rax
  801728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80172c:	eb 15                	jmp    801743 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80172e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801732:	0f b6 10             	movzbl (%rax),%edx
  801735:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801738:	38 c2                	cmp    %al,%dl
  80173a:	75 02                	jne    80173e <memfind+0x34>
			break;
  80173c:	eb 0f                	jmp    80174d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80173e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801747:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80174b:	72 e1                	jb     80172e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80174d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801751:	c9                   	leaveq 
  801752:	c3                   	retq   

0000000000801753 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801753:	55                   	push   %rbp
  801754:	48 89 e5             	mov    %rsp,%rbp
  801757:	48 83 ec 34          	sub    $0x34,%rsp
  80175b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80175f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801763:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801766:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80176d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801774:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801775:	eb 05                	jmp    80177c <strtol+0x29>
		s++;
  801777:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80177c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	3c 20                	cmp    $0x20,%al
  801785:	74 f0                	je     801777 <strtol+0x24>
  801787:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178b:	0f b6 00             	movzbl (%rax),%eax
  80178e:	3c 09                	cmp    $0x9,%al
  801790:	74 e5                	je     801777 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	3c 2b                	cmp    $0x2b,%al
  80179b:	75 07                	jne    8017a4 <strtol+0x51>
		s++;
  80179d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a2:	eb 17                	jmp    8017bb <strtol+0x68>
	else if (*s == '-')
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	0f b6 00             	movzbl (%rax),%eax
  8017ab:	3c 2d                	cmp    $0x2d,%al
  8017ad:	75 0c                	jne    8017bb <strtol+0x68>
		s++, neg = 1;
  8017af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017bf:	74 06                	je     8017c7 <strtol+0x74>
  8017c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017c5:	75 28                	jne    8017ef <strtol+0x9c>
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 1d                	jne    8017ef <strtol+0x9c>
  8017d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d6:	48 83 c0 01          	add    $0x1,%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	3c 78                	cmp    $0x78,%al
  8017df:	75 0e                	jne    8017ef <strtol+0x9c>
		s += 2, base = 16;
  8017e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017ed:	eb 2c                	jmp    80181b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f3:	75 19                	jne    80180e <strtol+0xbb>
  8017f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f9:	0f b6 00             	movzbl (%rax),%eax
  8017fc:	3c 30                	cmp    $0x30,%al
  8017fe:	75 0e                	jne    80180e <strtol+0xbb>
		s++, base = 8;
  801800:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801805:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80180c:	eb 0d                	jmp    80181b <strtol+0xc8>
	else if (base == 0)
  80180e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801812:	75 07                	jne    80181b <strtol+0xc8>
		base = 10;
  801814:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181f:	0f b6 00             	movzbl (%rax),%eax
  801822:	3c 2f                	cmp    $0x2f,%al
  801824:	7e 1d                	jle    801843 <strtol+0xf0>
  801826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182a:	0f b6 00             	movzbl (%rax),%eax
  80182d:	3c 39                	cmp    $0x39,%al
  80182f:	7f 12                	jg     801843 <strtol+0xf0>
			dig = *s - '0';
  801831:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801835:	0f b6 00             	movzbl (%rax),%eax
  801838:	0f be c0             	movsbl %al,%eax
  80183b:	83 e8 30             	sub    $0x30,%eax
  80183e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801841:	eb 4e                	jmp    801891 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801847:	0f b6 00             	movzbl (%rax),%eax
  80184a:	3c 60                	cmp    $0x60,%al
  80184c:	7e 1d                	jle    80186b <strtol+0x118>
  80184e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801852:	0f b6 00             	movzbl (%rax),%eax
  801855:	3c 7a                	cmp    $0x7a,%al
  801857:	7f 12                	jg     80186b <strtol+0x118>
			dig = *s - 'a' + 10;
  801859:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185d:	0f b6 00             	movzbl (%rax),%eax
  801860:	0f be c0             	movsbl %al,%eax
  801863:	83 e8 57             	sub    $0x57,%eax
  801866:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801869:	eb 26                	jmp    801891 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80186b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186f:	0f b6 00             	movzbl (%rax),%eax
  801872:	3c 40                	cmp    $0x40,%al
  801874:	7e 48                	jle    8018be <strtol+0x16b>
  801876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	3c 5a                	cmp    $0x5a,%al
  80187f:	7f 3d                	jg     8018be <strtol+0x16b>
			dig = *s - 'A' + 10;
  801881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	0f be c0             	movsbl %al,%eax
  80188b:	83 e8 37             	sub    $0x37,%eax
  80188e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801891:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801894:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801897:	7c 02                	jl     80189b <strtol+0x148>
			break;
  801899:	eb 23                	jmp    8018be <strtol+0x16b>
		s++, val = (val * base) + dig;
  80189b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018a3:	48 98                	cltq   
  8018a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018aa:	48 89 c2             	mov    %rax,%rdx
  8018ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b0:	48 98                	cltq   
  8018b2:	48 01 d0             	add    %rdx,%rax
  8018b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018b9:	e9 5d ff ff ff       	jmpq   80181b <strtol+0xc8>

	if (endptr)
  8018be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018c3:	74 0b                	je     8018d0 <strtol+0x17d>
		*endptr = (char *) s;
  8018c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018cd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018d4:	74 09                	je     8018df <strtol+0x18c>
  8018d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018da:	48 f7 d8             	neg    %rax
  8018dd:	eb 04                	jmp    8018e3 <strtol+0x190>
  8018df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018e3:	c9                   	leaveq 
  8018e4:	c3                   	retq   

00000000008018e5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
  8018e9:	48 83 ec 30          	sub    $0x30,%rsp
  8018ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018fd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801907:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80190b:	75 06                	jne    801913 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	eb 6b                	jmp    80197e <strstr+0x99>

    len = strlen(str);
  801913:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801917:	48 89 c7             	mov    %rax,%rdi
  80191a:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  801921:	00 00 00 
  801924:	ff d0                	callq  *%rax
  801926:	48 98                	cltq   
  801928:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80192c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801930:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801934:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80193e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801942:	75 07                	jne    80194b <strstr+0x66>
                return (char *) 0;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb 33                	jmp    80197e <strstr+0x99>
        } while (sc != c);
  80194b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80194f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801952:	75 d8                	jne    80192c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801954:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801958:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80195c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801960:	48 89 ce             	mov    %rcx,%rsi
  801963:	48 89 c7             	mov    %rax,%rdi
  801966:	48 b8 dc 13 80 00 00 	movabs $0x8013dc,%rax
  80196d:	00 00 00 
  801970:	ff d0                	callq  *%rax
  801972:	85 c0                	test   %eax,%eax
  801974:	75 b6                	jne    80192c <strstr+0x47>

    return (char *) (in - 1);
  801976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197a:	48 83 e8 01          	sub    $0x1,%rax
}
  80197e:	c9                   	leaveq 
  80197f:	c3                   	retq   

0000000000801980 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801980:	55                   	push   %rbp
  801981:	48 89 e5             	mov    %rsp,%rbp
  801984:	53                   	push   %rbx
  801985:	48 83 ec 48          	sub    $0x48,%rsp
  801989:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80198c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80198f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801993:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801997:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80199b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80199f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019a6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019aa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019ae:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019b2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019b6:	4c 89 c3             	mov    %r8,%rbx
  8019b9:	cd 30                	int    $0x30
  8019bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8019bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019c3:	74 3e                	je     801a03 <syscall+0x83>
  8019c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ca:	7e 37                	jle    801a03 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019d3:	49 89 d0             	mov    %rdx,%r8
  8019d6:	89 c1                	mov    %eax,%ecx
  8019d8:	48 ba a0 42 80 00 00 	movabs $0x8042a0,%rdx
  8019df:	00 00 00 
  8019e2:	be 23 00 00 00       	mov    $0x23,%esi
  8019e7:	48 bf bd 42 80 00 00 	movabs $0x8042bd,%rdi
  8019ee:	00 00 00 
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f6:	49 b9 a5 3a 80 00 00 	movabs $0x803aa5,%r9
  8019fd:	00 00 00 
  801a00:	41 ff d1             	callq  *%r9

	return ret;
  801a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a07:	48 83 c4 48          	add    $0x48,%rsp
  801a0b:	5b                   	pop    %rbx
  801a0c:	5d                   	pop    %rbp
  801a0d:	c3                   	retq   

0000000000801a0e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
  801a12:	48 83 ec 20          	sub    $0x20,%rsp
  801a16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a26:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2d:	00 
  801a2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a3a:	48 89 d1             	mov    %rdx,%rcx
  801a3d:	48 89 c2             	mov    %rax,%rdx
  801a40:	be 00 00 00 00       	mov    $0x0,%esi
  801a45:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4a:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801a51:	00 00 00 
  801a54:	ff d0                	callq  *%rax
}
  801a56:	c9                   	leaveq 
  801a57:	c3                   	retq   

0000000000801a58 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a58:	55                   	push   %rbp
  801a59:	48 89 e5             	mov    %rsp,%rbp
  801a5c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a67:	00 
  801a68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a74:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7e:	be 00 00 00 00       	mov    $0x0,%esi
  801a83:	bf 01 00 00 00       	mov    $0x1,%edi
  801a88:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
}
  801a94:	c9                   	leaveq 
  801a95:	c3                   	retq   

0000000000801a96 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a96:	55                   	push   %rbp
  801a97:	48 89 e5             	mov    %rsp,%rbp
  801a9a:	48 83 ec 10          	sub    $0x10,%rsp
  801a9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa4:	48 98                	cltq   
  801aa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aad:	00 
  801aae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abf:	48 89 c2             	mov    %rax,%rdx
  801ac2:	be 01 00 00 00       	mov    $0x1,%esi
  801ac7:	bf 03 00 00 00       	mov    $0x3,%edi
  801acc:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	callq  *%rax
}
  801ad8:	c9                   	leaveq 
  801ad9:	c3                   	retq   

0000000000801ada <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ae2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae9:	00 
  801aea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afb:	ba 00 00 00 00       	mov    $0x0,%edx
  801b00:	be 00 00 00 00       	mov    $0x0,%esi
  801b05:	bf 02 00 00 00       	mov    $0x2,%edi
  801b0a:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801b11:	00 00 00 
  801b14:	ff d0                	callq  *%rax
}
  801b16:	c9                   	leaveq 
  801b17:	c3                   	retq   

0000000000801b18 <sys_yield>:

void
sys_yield(void)
{
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
  801b1c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b27:	00 
  801b28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b34:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b39:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3e:	be 00 00 00 00       	mov    $0x0,%esi
  801b43:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b48:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801b4f:	00 00 00 
  801b52:	ff d0                	callq  *%rax
}
  801b54:	c9                   	leaveq 
  801b55:	c3                   	retq   

0000000000801b56 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b56:	55                   	push   %rbp
  801b57:	48 89 e5             	mov    %rsp,%rbp
  801b5a:	48 83 ec 20          	sub    $0x20,%rsp
  801b5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b65:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b6b:	48 63 c8             	movslq %eax,%rcx
  801b6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b75:	48 98                	cltq   
  801b77:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7e:	00 
  801b7f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b85:	49 89 c8             	mov    %rcx,%r8
  801b88:	48 89 d1             	mov    %rdx,%rcx
  801b8b:	48 89 c2             	mov    %rax,%rdx
  801b8e:	be 01 00 00 00       	mov    $0x1,%esi
  801b93:	bf 04 00 00 00       	mov    $0x4,%edi
  801b98:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801b9f:	00 00 00 
  801ba2:	ff d0                	callq  *%rax
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 30          	sub    $0x30,%rsp
  801bae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bb8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bbc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bc0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc3:	48 63 c8             	movslq %eax,%rcx
  801bc6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcd:	48 63 f0             	movslq %eax,%rsi
  801bd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd7:	48 98                	cltq   
  801bd9:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bdd:	49 89 f9             	mov    %rdi,%r9
  801be0:	49 89 f0             	mov    %rsi,%r8
  801be3:	48 89 d1             	mov    %rdx,%rcx
  801be6:	48 89 c2             	mov    %rax,%rdx
  801be9:	be 01 00 00 00       	mov    $0x1,%esi
  801bee:	bf 05 00 00 00       	mov    $0x5,%edi
  801bf3:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 20          	sub    $0x20,%rsp
  801c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c17:	48 98                	cltq   
  801c19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c20:	00 
  801c21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2d:	48 89 d1             	mov    %rdx,%rcx
  801c30:	48 89 c2             	mov    %rax,%rdx
  801c33:	be 01 00 00 00       	mov    $0x1,%esi
  801c38:	bf 06 00 00 00       	mov    $0x6,%edi
  801c3d:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801c44:	00 00 00 
  801c47:	ff d0                	callq  *%rax
}
  801c49:	c9                   	leaveq 
  801c4a:	c3                   	retq   

0000000000801c4b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c4b:	55                   	push   %rbp
  801c4c:	48 89 e5             	mov    %rsp,%rbp
  801c4f:	48 83 ec 10          	sub    $0x10,%rsp
  801c53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c56:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c5c:	48 63 d0             	movslq %eax,%rdx
  801c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c62:	48 98                	cltq   
  801c64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6b:	00 
  801c6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c78:	48 89 d1             	mov    %rdx,%rcx
  801c7b:	48 89 c2             	mov    %rax,%rdx
  801c7e:	be 01 00 00 00       	mov    $0x1,%esi
  801c83:	bf 08 00 00 00       	mov    $0x8,%edi
  801c88:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	callq  *%rax
}
  801c94:	c9                   	leaveq 
  801c95:	c3                   	retq   

0000000000801c96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c96:	55                   	push   %rbp
  801c97:	48 89 e5             	mov    %rsp,%rbp
  801c9a:	48 83 ec 20          	sub    $0x20,%rsp
  801c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ca5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cac:	48 98                	cltq   
  801cae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb5:	00 
  801cb6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc2:	48 89 d1             	mov    %rdx,%rcx
  801cc5:	48 89 c2             	mov    %rax,%rdx
  801cc8:	be 01 00 00 00       	mov    $0x1,%esi
  801ccd:	bf 09 00 00 00       	mov    $0x9,%edi
  801cd2:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 20          	sub    $0x20,%rsp
  801ce8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ceb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf6:	48 98                	cltq   
  801cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cff:	00 
  801d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0c:	48 89 d1             	mov    %rdx,%rcx
  801d0f:	48 89 c2             	mov    %rax,%rdx
  801d12:	be 01 00 00 00       	mov    $0x1,%esi
  801d17:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d1c:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
}
  801d28:	c9                   	leaveq 
  801d29:	c3                   	retq   

0000000000801d2a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d2a:	55                   	push   %rbp
  801d2b:	48 89 e5             	mov    %rsp,%rbp
  801d2e:	48 83 ec 20          	sub    $0x20,%rsp
  801d32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d39:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d3d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d43:	48 63 f0             	movslq %eax,%rsi
  801d46:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4d:	48 98                	cltq   
  801d4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5a:	00 
  801d5b:	49 89 f1             	mov    %rsi,%r9
  801d5e:	49 89 c8             	mov    %rcx,%r8
  801d61:	48 89 d1             	mov    %rdx,%rcx
  801d64:	48 89 c2             	mov    %rax,%rdx
  801d67:	be 00 00 00 00       	mov    $0x0,%esi
  801d6c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d71:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
}
  801d7d:	c9                   	leaveq 
  801d7e:	c3                   	retq   

0000000000801d7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d7f:	55                   	push   %rbp
  801d80:	48 89 e5             	mov    %rsp,%rbp
  801d83:	48 83 ec 10          	sub    $0x10,%rsp
  801d87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d96:	00 
  801d97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801da8:	48 89 c2             	mov    %rax,%rdx
  801dab:	be 01 00 00 00       	mov    $0x1,%esi
  801db0:	bf 0d 00 00 00       	mov    $0xd,%edi
  801db5:	48 b8 80 19 80 00 00 	movabs $0x801980,%rax
  801dbc:	00 00 00 
  801dbf:	ff d0                	callq  *%rax
}
  801dc1:	c9                   	leaveq 
  801dc2:	c3                   	retq   

0000000000801dc3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801dc3:	55                   	push   %rbp
  801dc4:	48 89 e5             	mov    %rsp,%rbp
  801dc7:	48 83 ec 30          	sub    $0x30,%rsp
  801dcb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dd3:	48 8b 00             	mov    (%rax),%rax
  801dd6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dde:	48 8b 40 08          	mov    0x8(%rax),%rax
  801de2:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801de5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de8:	83 e0 02             	and    $0x2,%eax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	74 23                	je     801e12 <pgfault+0x4f>
  801def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df3:	48 c1 e8 0c          	shr    $0xc,%rax
  801df7:	48 89 c2             	mov    %rax,%rdx
  801dfa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e01:	01 00 00 
  801e04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e08:	25 00 08 00 00       	and    $0x800,%eax
  801e0d:	48 85 c0             	test   %rax,%rax
  801e10:	75 2a                	jne    801e3c <pgfault+0x79>
		panic("fail check at fork pgfault");
  801e12:	48 ba cb 42 80 00 00 	movabs $0x8042cb,%rdx
  801e19:	00 00 00 
  801e1c:	be 1d 00 00 00       	mov    $0x1d,%esi
  801e21:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  801e28:	00 00 00 
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	48 b9 a5 3a 80 00 00 	movabs $0x803aa5,%rcx
  801e37:	00 00 00 
  801e3a:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801e3c:	ba 07 00 00 00       	mov    $0x7,%edx
  801e41:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e46:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4b:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e63:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e71:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e76:	48 89 c6             	mov    %rax,%rsi
  801e79:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e7e:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  801e85:	00 00 00 
  801e88:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e8e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e94:	48 89 c1             	mov    %rax,%rcx
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea6:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  801ead:	00 00 00 
  801eb0:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801eb2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebc:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801ec8:	c9                   	leaveq 
  801ec9:	c3                   	retq   

0000000000801eca <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	48 83 ec 20          	sub    $0x20,%rsp
  801ed2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801ed8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801edb:	48 c1 e0 0c          	shl    $0xc,%rax
  801edf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801ee3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eea:	01 00 00 
  801eed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ef0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef4:	25 00 04 00 00       	and    $0x400,%eax
  801ef9:	48 85 c0             	test   %rax,%rax
  801efc:	74 55                	je     801f53 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801efe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f05:	01 00 00 
  801f08:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0f:	25 07 0e 00 00       	and    $0xe07,%eax
  801f14:	89 c6                	mov    %eax,%esi
  801f16:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f21:	41 89 f0             	mov    %esi,%r8d
  801f24:	48 89 c6             	mov    %rax,%rsi
  801f27:	bf 00 00 00 00       	mov    $0x0,%edi
  801f2c:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  801f33:	00 00 00 
  801f36:	ff d0                	callq  *%rax
  801f38:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f3f:	79 08                	jns    801f49 <duppage+0x7f>
			return r;
  801f41:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f44:	e9 e1 00 00 00       	jmpq   80202a <duppage+0x160>
		return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	e9 d7 00 00 00       	jmpq   80202a <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801f53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5a:	01 00 00 
  801f5d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f64:	25 05 06 00 00       	and    $0x605,%eax
  801f69:	80 cc 08             	or     $0x8,%ah
  801f6c:	89 c6                	mov    %eax,%esi
  801f6e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f72:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f79:	41 89 f0             	mov    %esi,%r8d
  801f7c:	48 89 c6             	mov    %rax,%rsi
  801f7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f84:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  801f8b:	00 00 00 
  801f8e:	ff d0                	callq  *%rax
  801f90:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f97:	79 08                	jns    801fa1 <duppage+0xd7>
		return r;
  801f99:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f9c:	e9 89 00 00 00       	jmpq   80202a <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801fa1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa8:	01 00 00 
  801fab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb2:	83 e0 02             	and    $0x2,%eax
  801fb5:	48 85 c0             	test   %rax,%rax
  801fb8:	75 1b                	jne    801fd5 <duppage+0x10b>
  801fba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc1:	01 00 00 
  801fc4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcb:	25 00 08 00 00       	and    $0x800,%eax
  801fd0:	48 85 c0             	test   %rax,%rax
  801fd3:	74 50                	je     802025 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801fd5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fdc:	01 00 00 
  801fdf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fe2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe6:	25 05 06 00 00       	and    $0x605,%eax
  801feb:	80 cc 08             	or     $0x8,%ah
  801fee:	89 c1                	mov    %eax,%ecx
  801ff0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ff4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff8:	41 89 c8             	mov    %ecx,%r8d
  801ffb:	48 89 d1             	mov    %rdx,%rcx
  801ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  802003:	48 89 c6             	mov    %rax,%rsi
  802006:	bf 00 00 00 00       	mov    $0x0,%edi
  80200b:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  802012:	00 00 00 
  802015:	ff d0                	callq  *%rax
  802017:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80201a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80201e:	79 05                	jns    802025 <duppage+0x15b>
			return r;
  802020:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802023:	eb 05                	jmp    80202a <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202a:	c9                   	leaveq 
  80202b:	c3                   	retq   

000000000080202c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80202c:	55                   	push   %rbp
  80202d:	48 89 e5             	mov    %rsp,%rbp
  802030:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  802034:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  80203b:	48 bf c3 1d 80 00 00 	movabs $0x801dc3,%rdi
  802042:	00 00 00 
  802045:	48 b8 b9 3b 80 00 00 	movabs $0x803bb9,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802051:	b8 07 00 00 00       	mov    $0x7,%eax
  802056:	cd 30                	int    $0x30
  802058:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80205b:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  80205e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802061:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802065:	79 08                	jns    80206f <fork+0x43>
		return envid;
  802067:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80206a:	e9 27 02 00 00       	jmpq   802296 <fork+0x26a>
	else if (envid == 0) {
  80206f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802073:	75 46                	jne    8020bb <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802075:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	25 ff 03 00 00       	and    $0x3ff,%eax
  802086:	48 63 d0             	movslq %eax,%rdx
  802089:	48 89 d0             	mov    %rdx,%rax
  80208c:	48 c1 e0 03          	shl    $0x3,%rax
  802090:	48 01 d0             	add    %rdx,%rax
  802093:	48 c1 e0 05          	shl    $0x5,%rax
  802097:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80209e:	00 00 00 
  8020a1:	48 01 c2             	add    %rax,%rdx
  8020a4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020ab:	00 00 00 
  8020ae:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	e9 db 01 00 00       	jmpq   802296 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020be:	ba 07 00 00 00       	mov    $0x7,%edx
  8020c3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020c8:	89 c7                	mov    %eax,%edi
  8020ca:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8020d1:	00 00 00 
  8020d4:	ff d0                	callq  *%rax
  8020d6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8020d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020dd:	79 08                	jns    8020e7 <fork+0xbb>
		return r;
  8020df:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020e2:	e9 af 01 00 00       	jmpq   802296 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8020e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ee:	e9 49 01 00 00       	jmpq   80223c <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8020f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f6:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	0f 48 c2             	cmovs  %edx,%eax
  802101:	c1 f8 1b             	sar    $0x1b,%eax
  802104:	89 c2                	mov    %eax,%edx
  802106:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80210d:	01 00 00 
  802110:	48 63 d2             	movslq %edx,%rdx
  802113:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802117:	83 e0 01             	and    $0x1,%eax
  80211a:	48 85 c0             	test   %rax,%rax
  80211d:	75 0c                	jne    80212b <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  80211f:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  802126:	e9 0d 01 00 00       	jmpq   802238 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80212b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  802132:	e9 f4 00 00 00       	jmpq   80222b <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802137:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80213a:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  802140:	85 c0                	test   %eax,%eax
  802142:	0f 48 c2             	cmovs  %edx,%eax
  802145:	c1 f8 12             	sar    $0x12,%eax
  802148:	89 c2                	mov    %eax,%edx
  80214a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802151:	01 00 00 
  802154:	48 63 d2             	movslq %edx,%rdx
  802157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215b:	83 e0 01             	and    $0x1,%eax
  80215e:	48 85 c0             	test   %rax,%rax
  802161:	75 0c                	jne    80216f <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802163:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80216a:	e9 b8 00 00 00       	jmpq   802227 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80216f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802176:	e9 9f 00 00 00       	jmpq   80221a <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80217b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217e:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802184:	85 c0                	test   %eax,%eax
  802186:	0f 48 c2             	cmovs  %edx,%eax
  802189:	c1 f8 09             	sar    $0x9,%eax
  80218c:	89 c2                	mov    %eax,%edx
  80218e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802195:	01 00 00 
  802198:	48 63 d2             	movslq %edx,%rdx
  80219b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219f:	83 e0 01             	and    $0x1,%eax
  8021a2:	48 85 c0             	test   %rax,%rax
  8021a5:	75 09                	jne    8021b0 <fork+0x184>
					ptx += NPTENTRIES;
  8021a7:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8021ae:	eb 66                	jmp    802216 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8021b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8021b7:	eb 54                	jmp    80220d <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8021b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c0:	01 00 00 
  8021c3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021c6:	48 63 d2             	movslq %edx,%rdx
  8021c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cd:	83 e0 01             	and    $0x1,%eax
  8021d0:	48 85 c0             	test   %rax,%rax
  8021d3:	74 30                	je     802205 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  8021d5:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  8021dc:	74 27                	je     802205 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  8021de:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021e1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021e4:	89 d6                	mov    %edx,%esi
  8021e6:	89 c7                	mov    %eax,%edi
  8021e8:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
  8021f4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8021f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021fb:	79 08                	jns    802205 <fork+0x1d9>
								return r;
  8021fd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802200:	e9 91 00 00 00       	jmpq   802296 <fork+0x26a>
					ptx++;
  802205:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802209:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80220d:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  802214:	7e a3                	jle    8021b9 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802216:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80221a:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  802221:	0f 8e 54 ff ff ff    	jle    80217b <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802227:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80222b:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  802232:	0f 8e ff fe ff ff    	jle    802137 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802238:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80223c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802240:	0f 84 ad fe ff ff    	je     8020f3 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802246:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802249:	48 be 24 3c 80 00 00 	movabs $0x803c24,%rsi
  802250:	00 00 00 
  802253:	89 c7                	mov    %eax,%edi
  802255:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802264:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802268:	79 05                	jns    80226f <fork+0x243>
		return r;
  80226a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80226d:	eb 27                	jmp    802296 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80226f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802272:	be 02 00 00 00       	mov    $0x2,%esi
  802277:	89 c7                	mov    %eax,%edi
  802279:	48 b8 4b 1c 80 00 00 	movabs $0x801c4b,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
  802285:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802288:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80228c:	79 05                	jns    802293 <fork+0x267>
		return r;
  80228e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802291:	eb 03                	jmp    802296 <fork+0x26a>

	return envid;
  802293:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802296:	c9                   	leaveq 
  802297:	c3                   	retq   

0000000000802298 <sfork>:

// Challenge!
int
sfork(void)
{
  802298:	55                   	push   %rbp
  802299:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80229c:	48 ba f1 42 80 00 00 	movabs $0x8042f1,%rdx
  8022a3:	00 00 00 
  8022a6:	be a7 00 00 00       	mov    $0xa7,%esi
  8022ab:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  8022b2:	00 00 00 
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	48 b9 a5 3a 80 00 00 	movabs $0x803aa5,%rcx
  8022c1:	00 00 00 
  8022c4:	ff d1                	callq  *%rcx

00000000008022c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c6:	55                   	push   %rbp
  8022c7:	48 89 e5             	mov    %rsp,%rbp
  8022ca:	48 83 ec 30          	sub    $0x30,%rsp
  8022ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8022da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8022e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8022e7:	75 0e                	jne    8022f7 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8022e9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8022f0:	00 00 00 
  8022f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8022f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fb:	48 89 c7             	mov    %rax,%rdi
  8022fe:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80230d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802311:	79 27                	jns    80233a <ipc_recv+0x74>
		if (from_env_store != NULL)
  802313:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802318:	74 0a                	je     802324 <ipc_recv+0x5e>
			*from_env_store = 0;
  80231a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  802324:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802329:	74 0a                	je     802335 <ipc_recv+0x6f>
			*perm_store = 0;
  80232b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802335:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802338:	eb 53                	jmp    80238d <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80233a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80233f:	74 19                	je     80235a <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  802341:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802348:	00 00 00 
  80234b:	48 8b 00             	mov    (%rax),%rax
  80234e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802358:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80235a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80235f:	74 19                	je     80237a <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  802361:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802368:	00 00 00 
  80236b:	48 8b 00             	mov    (%rax),%rax
  80236e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802378:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80237a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802381:	00 00 00 
  802384:	48 8b 00             	mov    (%rax),%rax
  802387:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 30          	sub    $0x30,%rsp
  802397:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80239a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80239d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023a1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8023a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8023ac:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8023b1:	75 10                	jne    8023c3 <ipc_send+0x34>
		page = (void *)KERNBASE;
  8023b3:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8023ba:	00 00 00 
  8023bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8023c1:	eb 0e                	jmp    8023d1 <ipc_send+0x42>
  8023c3:	eb 0c                	jmp    8023d1 <ipc_send+0x42>
		sys_yield();
  8023c5:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  8023cc:	00 00 00 
  8023cf:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8023d1:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023d4:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8023d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  8023e7:	00 00 00 
  8023ea:	ff d0                	callq  *%rax
  8023ec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023ef:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8023f3:	74 d0                	je     8023c5 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023f9:	74 2a                	je     802425 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8023fb:	48 ba 07 43 80 00 00 	movabs $0x804307,%rdx
  802402:	00 00 00 
  802405:	be 49 00 00 00       	mov    $0x49,%esi
  80240a:	48 bf 23 43 80 00 00 	movabs $0x804323,%rdi
  802411:	00 00 00 
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
  802419:	48 b9 a5 3a 80 00 00 	movabs $0x803aa5,%rcx
  802420:	00 00 00 
  802423:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  802425:	c9                   	leaveq 
  802426:	c3                   	retq   

0000000000802427 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802427:	55                   	push   %rbp
  802428:	48 89 e5             	mov    %rsp,%rbp
  80242b:	48 83 ec 14          	sub    $0x14,%rsp
  80242f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802432:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802439:	eb 5e                	jmp    802499 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80243b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802442:	00 00 00 
  802445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802448:	48 63 d0             	movslq %eax,%rdx
  80244b:	48 89 d0             	mov    %rdx,%rax
  80244e:	48 c1 e0 03          	shl    $0x3,%rax
  802452:	48 01 d0             	add    %rdx,%rax
  802455:	48 c1 e0 05          	shl    $0x5,%rax
  802459:	48 01 c8             	add    %rcx,%rax
  80245c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802462:	8b 00                	mov    (%rax),%eax
  802464:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802467:	75 2c                	jne    802495 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802469:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802470:	00 00 00 
  802473:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802476:	48 63 d0             	movslq %eax,%rdx
  802479:	48 89 d0             	mov    %rdx,%rax
  80247c:	48 c1 e0 03          	shl    $0x3,%rax
  802480:	48 01 d0             	add    %rdx,%rax
  802483:	48 c1 e0 05          	shl    $0x5,%rax
  802487:	48 01 c8             	add    %rcx,%rax
  80248a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802490:	8b 40 08             	mov    0x8(%rax),%eax
  802493:	eb 12                	jmp    8024a7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802495:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802499:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8024a0:	7e 99                	jle    80243b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 08          	sub    $0x8,%rsp
  8024b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024b9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024c0:	ff ff ff 
  8024c3:	48 01 d0             	add    %rdx,%rax
  8024c6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024ca:	c9                   	leaveq 
  8024cb:	c3                   	retq   

00000000008024cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024cc:	55                   	push   %rbp
  8024cd:	48 89 e5             	mov    %rsp,%rbp
  8024d0:	48 83 ec 08          	sub    $0x8,%rsp
  8024d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024dc:	48 89 c7             	mov    %rax,%rdi
  8024df:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8024e6:	00 00 00 
  8024e9:	ff d0                	callq  *%rax
  8024eb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024f1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024f5:	c9                   	leaveq 
  8024f6:	c3                   	retq   

00000000008024f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024f7:	55                   	push   %rbp
  8024f8:	48 89 e5             	mov    %rsp,%rbp
  8024fb:	48 83 ec 18          	sub    $0x18,%rsp
  8024ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802503:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80250a:	eb 6b                	jmp    802577 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80250c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250f:	48 98                	cltq   
  802511:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802517:	48 c1 e0 0c          	shl    $0xc,%rax
  80251b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80251f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802523:	48 c1 e8 15          	shr    $0x15,%rax
  802527:	48 89 c2             	mov    %rax,%rdx
  80252a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802531:	01 00 00 
  802534:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802538:	83 e0 01             	and    $0x1,%eax
  80253b:	48 85 c0             	test   %rax,%rax
  80253e:	74 21                	je     802561 <fd_alloc+0x6a>
  802540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802544:	48 c1 e8 0c          	shr    $0xc,%rax
  802548:	48 89 c2             	mov    %rax,%rdx
  80254b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802552:	01 00 00 
  802555:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802559:	83 e0 01             	and    $0x1,%eax
  80255c:	48 85 c0             	test   %rax,%rax
  80255f:	75 12                	jne    802573 <fd_alloc+0x7c>
			*fd_store = fd;
  802561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802565:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802569:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	eb 1a                	jmp    80258d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802573:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802577:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80257b:	7e 8f                	jle    80250c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80257d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802581:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802588:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   

000000000080258f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80258f:	55                   	push   %rbp
  802590:	48 89 e5             	mov    %rsp,%rbp
  802593:	48 83 ec 20          	sub    $0x20,%rsp
  802597:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80259a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80259e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025a2:	78 06                	js     8025aa <fd_lookup+0x1b>
  8025a4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025a8:	7e 07                	jle    8025b1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025af:	eb 6c                	jmp    80261d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b4:	48 98                	cltq   
  8025b6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8025c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c8:	48 c1 e8 15          	shr    $0x15,%rax
  8025cc:	48 89 c2             	mov    %rax,%rdx
  8025cf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025d6:	01 00 00 
  8025d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025dd:	83 e0 01             	and    $0x1,%eax
  8025e0:	48 85 c0             	test   %rax,%rax
  8025e3:	74 21                	je     802606 <fd_lookup+0x77>
  8025e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ed:	48 89 c2             	mov    %rax,%rdx
  8025f0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f7:	01 00 00 
  8025fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fe:	83 e0 01             	and    $0x1,%eax
  802601:	48 85 c0             	test   %rax,%rax
  802604:	75 07                	jne    80260d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80260b:	eb 10                	jmp    80261d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80260d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802611:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802615:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 30          	sub    $0x30,%rsp
  802627:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80262b:	89 f0                	mov    %esi,%eax
  80262d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802634:	48 89 c7             	mov    %rax,%rdi
  802637:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
  802643:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	78 0a                	js     80266b <fd_close+0x4c>
	    || fd != fd2)
  802661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802665:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802669:	74 12                	je     80267d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80266b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80266f:	74 05                	je     802676 <fd_close+0x57>
  802671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802674:	eb 05                	jmp    80267b <fd_close+0x5c>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	eb 69                	jmp    8026e6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80267d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802681:	8b 00                	mov    (%rax),%eax
  802683:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802687:	48 89 d6             	mov    %rdx,%rsi
  80268a:	89 c7                	mov    %eax,%edi
  80268c:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
  802698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269f:	78 2a                	js     8026cb <fd_close+0xac>
		if (dev->dev_close)
  8026a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026a9:	48 85 c0             	test   %rax,%rax
  8026ac:	74 16                	je     8026c4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ba:	48 89 d7             	mov    %rdx,%rdi
  8026bd:	ff d0                	callq  *%rax
  8026bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c2:	eb 07                	jmp    8026cb <fd_close+0xac>
		else
			r = 0;
  8026c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026cf:	48 89 c6             	mov    %rax,%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
	return r;
  8026e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
  8026f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026fe:	eb 41                	jmp    802741 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802700:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802707:	00 00 00 
  80270a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80270d:	48 63 d2             	movslq %edx,%rdx
  802710:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802714:	8b 00                	mov    (%rax),%eax
  802716:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802719:	75 22                	jne    80273d <dev_lookup+0x55>
			*dev = devtab[i];
  80271b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802722:	00 00 00 
  802725:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802728:	48 63 d2             	movslq %edx,%rdx
  80272b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80272f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802733:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802736:	b8 00 00 00 00       	mov    $0x0,%eax
  80273b:	eb 60                	jmp    80279d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80273d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802741:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802748:	00 00 00 
  80274b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80274e:	48 63 d2             	movslq %edx,%rdx
  802751:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802755:	48 85 c0             	test   %rax,%rax
  802758:	75 a6                	jne    802700 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80275a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802761:	00 00 00 
  802764:	48 8b 00             	mov    (%rax),%rax
  802767:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80276d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802770:	89 c6                	mov    %eax,%esi
  802772:	48 bf 30 43 80 00 00 	movabs $0x804330,%rdi
  802779:	00 00 00 
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  802788:	00 00 00 
  80278b:	ff d1                	callq  *%rcx
	*dev = 0;
  80278d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802791:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80279d:	c9                   	leaveq 
  80279e:	c3                   	retq   

000000000080279f <close>:

int
close(int fdnum)
{
  80279f:	55                   	push   %rbp
  8027a0:	48 89 e5             	mov    %rsp,%rbp
  8027a3:	48 83 ec 20          	sub    $0x20,%rsp
  8027a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027aa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027b1:	48 89 d6             	mov    %rdx,%rsi
  8027b4:	89 c7                	mov    %eax,%edi
  8027b6:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
  8027c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c9:	79 05                	jns    8027d0 <close+0x31>
		return r;
  8027cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ce:	eb 18                	jmp    8027e8 <close+0x49>
	else
		return fd_close(fd, 1);
  8027d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d4:	be 01 00 00 00       	mov    $0x1,%esi
  8027d9:	48 89 c7             	mov    %rax,%rdi
  8027dc:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  8027e3:	00 00 00 
  8027e6:	ff d0                	callq  *%rax
}
  8027e8:	c9                   	leaveq 
  8027e9:	c3                   	retq   

00000000008027ea <close_all>:

void
close_all(void)
{
  8027ea:	55                   	push   %rbp
  8027eb:	48 89 e5             	mov    %rsp,%rbp
  8027ee:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f9:	eb 15                	jmp    802810 <close_all+0x26>
		close(i);
  8027fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fe:	89 c7                	mov    %eax,%edi
  802800:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80280c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802810:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802814:	7e e5                	jle    8027fb <close_all+0x11>
		close(i);
}
  802816:	c9                   	leaveq 
  802817:	c3                   	retq   

0000000000802818 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802818:	55                   	push   %rbp
  802819:	48 89 e5             	mov    %rsp,%rbp
  80281c:	48 83 ec 40          	sub    $0x40,%rsp
  802820:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802823:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802826:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80282a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80282d:	48 89 d6             	mov    %rdx,%rsi
  802830:	89 c7                	mov    %eax,%edi
  802832:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
  80283e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802845:	79 08                	jns    80284f <dup+0x37>
		return r;
  802847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284a:	e9 70 01 00 00       	jmpq   8029bf <dup+0x1a7>
	close(newfdnum);
  80284f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802852:	89 c7                	mov    %eax,%edi
  802854:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  80285b:	00 00 00 
  80285e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802860:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802863:	48 98                	cltq   
  802865:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80286b:	48 c1 e0 0c          	shl    $0xc,%rax
  80286f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802877:	48 89 c7             	mov    %rax,%rdi
  80287a:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  802881:	00 00 00 
  802884:	ff d0                	callq  *%rax
  802886:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80288a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288e:	48 89 c7             	mov    %rax,%rdi
  802891:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
  80289d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a5:	48 c1 e8 15          	shr    $0x15,%rax
  8028a9:	48 89 c2             	mov    %rax,%rdx
  8028ac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028b3:	01 00 00 
  8028b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ba:	83 e0 01             	and    $0x1,%eax
  8028bd:	48 85 c0             	test   %rax,%rax
  8028c0:	74 73                	je     802935 <dup+0x11d>
  8028c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ca:	48 89 c2             	mov    %rax,%rdx
  8028cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d4:	01 00 00 
  8028d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028db:	83 e0 01             	and    $0x1,%eax
  8028de:	48 85 c0             	test   %rax,%rax
  8028e1:	74 52                	je     802935 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8028eb:	48 89 c2             	mov    %rax,%rdx
  8028ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f5:	01 00 00 
  8028f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028fc:	25 07 0e 00 00       	and    $0xe07,%eax
  802901:	89 c1                	mov    %eax,%ecx
  802903:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290b:	41 89 c8             	mov    %ecx,%r8d
  80290e:	48 89 d1             	mov    %rdx,%rcx
  802911:	ba 00 00 00 00       	mov    $0x0,%edx
  802916:	48 89 c6             	mov    %rax,%rsi
  802919:	bf 00 00 00 00       	mov    $0x0,%edi
  80291e:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
  80292a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802931:	79 02                	jns    802935 <dup+0x11d>
			goto err;
  802933:	eb 57                	jmp    80298c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802939:	48 c1 e8 0c          	shr    $0xc,%rax
  80293d:	48 89 c2             	mov    %rax,%rdx
  802940:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802947:	01 00 00 
  80294a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294e:	25 07 0e 00 00       	and    $0xe07,%eax
  802953:	89 c1                	mov    %eax,%ecx
  802955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802959:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295d:	41 89 c8             	mov    %ecx,%r8d
  802960:	48 89 d1             	mov    %rdx,%rcx
  802963:	ba 00 00 00 00       	mov    $0x0,%edx
  802968:	48 89 c6             	mov    %rax,%rsi
  80296b:	bf 00 00 00 00       	mov    $0x0,%edi
  802970:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802983:	79 02                	jns    802987 <dup+0x16f>
		goto err;
  802985:	eb 05                	jmp    80298c <dup+0x174>

	return newfdnum;
  802987:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80298a:	eb 33                	jmp    8029bf <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80298c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802990:	48 89 c6             	mov    %rax,%rsi
  802993:	bf 00 00 00 00       	mov    $0x0,%edi
  802998:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a8:	48 89 c6             	mov    %rax,%rsi
  8029ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b0:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
	return r;
  8029bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029bf:	c9                   	leaveq 
  8029c0:	c3                   	retq   

00000000008029c1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029c1:	55                   	push   %rbp
  8029c2:	48 89 e5             	mov    %rsp,%rbp
  8029c5:	48 83 ec 40          	sub    $0x40,%rsp
  8029c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029d0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029db:	48 89 d6             	mov    %rdx,%rsi
  8029de:	89 c7                	mov    %eax,%edi
  8029e0:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f3:	78 24                	js     802a19 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f9:	8b 00                	mov    (%rax),%eax
  8029fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029ff:	48 89 d6             	mov    %rdx,%rsi
  802a02:	89 c7                	mov    %eax,%edi
  802a04:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
  802a10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a17:	79 05                	jns    802a1e <read+0x5d>
		return r;
  802a19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1c:	eb 76                	jmp    802a94 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a22:	8b 40 08             	mov    0x8(%rax),%eax
  802a25:	83 e0 03             	and    $0x3,%eax
  802a28:	83 f8 01             	cmp    $0x1,%eax
  802a2b:	75 3a                	jne    802a67 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a2d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a34:	00 00 00 
  802a37:	48 8b 00             	mov    (%rax),%rax
  802a3a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a40:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a43:	89 c6                	mov    %eax,%esi
  802a45:	48 bf 4f 43 80 00 00 	movabs $0x80434f,%rdi
  802a4c:	00 00 00 
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  802a5b:	00 00 00 
  802a5e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a65:	eb 2d                	jmp    802a94 <read+0xd3>
	}
	if (!dev->dev_read)
  802a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a6f:	48 85 c0             	test   %rax,%rax
  802a72:	75 07                	jne    802a7b <read+0xba>
		return -E_NOT_SUPP;
  802a74:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a79:	eb 19                	jmp    802a94 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a83:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a8b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a8f:	48 89 cf             	mov    %rcx,%rdi
  802a92:	ff d0                	callq  *%rax
}
  802a94:	c9                   	leaveq 
  802a95:	c3                   	retq   

0000000000802a96 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a96:	55                   	push   %rbp
  802a97:	48 89 e5             	mov    %rsp,%rbp
  802a9a:	48 83 ec 30          	sub    $0x30,%rsp
  802a9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aa1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802aa5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ab0:	eb 49                	jmp    802afb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab5:	48 98                	cltq   
  802ab7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802abb:	48 29 c2             	sub    %rax,%rdx
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	48 63 c8             	movslq %eax,%rcx
  802ac4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac8:	48 01 c1             	add    %rax,%rcx
  802acb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ace:	48 89 ce             	mov    %rcx,%rsi
  802ad1:	89 c7                	mov    %eax,%edi
  802ad3:	48 b8 c1 29 80 00 00 	movabs $0x8029c1,%rax
  802ada:	00 00 00 
  802add:	ff d0                	callq  *%rax
  802adf:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ae2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ae6:	79 05                	jns    802aed <readn+0x57>
			return m;
  802ae8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aeb:	eb 1c                	jmp    802b09 <readn+0x73>
		if (m == 0)
  802aed:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802af1:	75 02                	jne    802af5 <readn+0x5f>
			break;
  802af3:	eb 11                	jmp    802b06 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802af5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afe:	48 98                	cltq   
  802b00:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b04:	72 ac                	jb     802ab2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b06:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b09:	c9                   	leaveq 
  802b0a:	c3                   	retq   

0000000000802b0b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b0b:	55                   	push   %rbp
  802b0c:	48 89 e5             	mov    %rsp,%rbp
  802b0f:	48 83 ec 40          	sub    $0x40,%rsp
  802b13:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b16:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b1a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b1e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b25:	48 89 d6             	mov    %rdx,%rsi
  802b28:	89 c7                	mov    %eax,%edi
  802b2a:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
  802b36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3d:	78 24                	js     802b63 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b43:	8b 00                	mov    (%rax),%eax
  802b45:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b49:	48 89 d6             	mov    %rdx,%rsi
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b61:	79 05                	jns    802b68 <write+0x5d>
		return r;
  802b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b66:	eb 75                	jmp    802bdd <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6c:	8b 40 08             	mov    0x8(%rax),%eax
  802b6f:	83 e0 03             	and    $0x3,%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 3a                	jne    802bb0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b76:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b7d:	00 00 00 
  802b80:	48 8b 00             	mov    (%rax),%rax
  802b83:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b89:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b8c:	89 c6                	mov    %eax,%esi
  802b8e:	48 bf 6b 43 80 00 00 	movabs $0x80436b,%rdi
  802b95:	00 00 00 
  802b98:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9d:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  802ba4:	00 00 00 
  802ba7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ba9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bae:	eb 2d                	jmp    802bdd <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb4:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bb8:	48 85 c0             	test   %rax,%rax
  802bbb:	75 07                	jne    802bc4 <write+0xb9>
		return -E_NOT_SUPP;
  802bbd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc2:	eb 19                	jmp    802bdd <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bcc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bd8:	48 89 cf             	mov    %rcx,%rdi
  802bdb:	ff d0                	callq  *%rax
}
  802bdd:	c9                   	leaveq 
  802bde:	c3                   	retq   

0000000000802bdf <seek>:

int
seek(int fdnum, off_t offset)
{
  802bdf:	55                   	push   %rbp
  802be0:	48 89 e5             	mov    %rsp,%rbp
  802be3:	48 83 ec 18          	sub    $0x18,%rsp
  802be7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf4:	48 89 d6             	mov    %rdx,%rsi
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
  802c05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0c:	79 05                	jns    802c13 <seek+0x34>
		return r;
  802c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c11:	eb 0f                	jmp    802c22 <seek+0x43>
	fd->fd_offset = offset;
  802c13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c17:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c1a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c22:	c9                   	leaveq 
  802c23:	c3                   	retq   

0000000000802c24 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	48 83 ec 30          	sub    $0x30,%rsp
  802c2c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c2f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c32:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c36:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c39:	48 89 d6             	mov    %rdx,%rsi
  802c3c:	89 c7                	mov    %eax,%edi
  802c3e:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
  802c4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c51:	78 24                	js     802c77 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c57:	8b 00                	mov    (%rax),%eax
  802c59:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c5d:	48 89 d6             	mov    %rdx,%rsi
  802c60:	89 c7                	mov    %eax,%edi
  802c62:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
  802c6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c75:	79 05                	jns    802c7c <ftruncate+0x58>
		return r;
  802c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7a:	eb 72                	jmp    802cee <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c80:	8b 40 08             	mov    0x8(%rax),%eax
  802c83:	83 e0 03             	and    $0x3,%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	75 3a                	jne    802cc4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c8a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c91:	00 00 00 
  802c94:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c97:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c9d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ca0:	89 c6                	mov    %eax,%esi
  802ca2:	48 bf 88 43 80 00 00 	movabs $0x804388,%rdi
  802ca9:	00 00 00 
  802cac:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb1:	48 b9 7f 04 80 00 00 	movabs $0x80047f,%rcx
  802cb8:	00 00 00 
  802cbb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cbd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cc2:	eb 2a                	jmp    802cee <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc8:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ccc:	48 85 c0             	test   %rax,%rax
  802ccf:	75 07                	jne    802cd8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cd1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cd6:	eb 16                	jmp    802cee <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cdc:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ce0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ce4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ce7:	89 ce                	mov    %ecx,%esi
  802ce9:	48 89 d7             	mov    %rdx,%rdi
  802cec:	ff d0                	callq  *%rax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 30          	sub    $0x30,%rsp
  802cf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cfb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d03:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d06:	48 89 d6             	mov    %rdx,%rsi
  802d09:	89 c7                	mov    %eax,%edi
  802d0b:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  802d12:	00 00 00 
  802d15:	ff d0                	callq  *%rax
  802d17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d1e:	78 24                	js     802d44 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d24:	8b 00                	mov    (%rax),%eax
  802d26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2a:	48 89 d6             	mov    %rdx,%rsi
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
  802d3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d42:	79 05                	jns    802d49 <fstat+0x59>
		return r;
  802d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d47:	eb 5e                	jmp    802da7 <fstat+0xb7>
	if (!dev->dev_stat)
  802d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d51:	48 85 c0             	test   %rax,%rax
  802d54:	75 07                	jne    802d5d <fstat+0x6d>
		return -E_NOT_SUPP;
  802d56:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d5b:	eb 4a                	jmp    802da7 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d61:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d64:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d68:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d6f:	00 00 00 
	stat->st_isdir = 0;
  802d72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d76:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d7d:	00 00 00 
	stat->st_dev = dev;
  802d80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d88:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d93:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d9b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d9f:	48 89 ce             	mov    %rcx,%rsi
  802da2:	48 89 d7             	mov    %rdx,%rdi
  802da5:	ff d0                	callq  *%rax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 20          	sub    $0x20,%rsp
  802db1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbd:	be 00 00 00 00       	mov    $0x0,%esi
  802dc2:	48 89 c7             	mov    %rax,%rdi
  802dc5:	48 b8 97 2e 80 00 00 	movabs $0x802e97,%rax
  802dcc:	00 00 00 
  802dcf:	ff d0                	callq  *%rax
  802dd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd8:	79 05                	jns    802ddf <stat+0x36>
		return fd;
  802dda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddd:	eb 2f                	jmp    802e0e <stat+0x65>
	r = fstat(fd, stat);
  802ddf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	48 89 d6             	mov    %rdx,%rsi
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
  802df7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	89 c7                	mov    %eax,%edi
  802dff:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  802e06:	00 00 00 
  802e09:	ff d0                	callq  *%rax
	return r;
  802e0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e0e:	c9                   	leaveq 
  802e0f:	c3                   	retq   

0000000000802e10 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e10:	55                   	push   %rbp
  802e11:	48 89 e5             	mov    %rsp,%rbp
  802e14:	48 83 ec 10          	sub    $0x10,%rsp
  802e18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e1f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e26:	00 00 00 
  802e29:	8b 00                	mov    (%rax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	75 1d                	jne    802e4c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e2f:	bf 01 00 00 00       	mov    $0x1,%edi
  802e34:	48 b8 27 24 80 00 00 	movabs $0x802427,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802e47:	00 00 00 
  802e4a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e4c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e53:	00 00 00 
  802e56:	8b 00                	mov    (%rax),%eax
  802e58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e5b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e60:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e67:	00 00 00 
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e81:	48 89 c6             	mov    %rax,%rsi
  802e84:	bf 00 00 00 00       	mov    $0x0,%edi
  802e89:	48 b8 c6 22 80 00 00 	movabs $0x8022c6,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
}
  802e95:	c9                   	leaveq 
  802e96:	c3                   	retq   

0000000000802e97 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e97:	55                   	push   %rbp
  802e98:	48 89 e5             	mov    %rsp,%rbp
  802e9b:	48 83 ec 20          	sub    $0x20,%rsp
  802e9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea3:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eaa:	48 89 c7             	mov    %rax,%rdi
  802ead:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ebe:	7e 0a                	jle    802eca <open+0x33>
		return -E_BAD_PATH;
  802ec0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ec5:	e9 a5 00 00 00       	jmpq   802f6f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802eca:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ece:	48 89 c7             	mov    %rax,%rdi
  802ed1:	48 b8 f7 24 80 00 00 	movabs $0x8024f7,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
  802edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee4:	79 08                	jns    802eee <open+0x57>
		return r;
  802ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee9:	e9 81 00 00 00       	jmpq   802f6f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef2:	48 89 c6             	mov    %rax,%rsi
  802ef5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802efc:	00 00 00 
  802eff:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802f0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f12:	00 00 00 
  802f15:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f18:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f22:	48 89 c6             	mov    %rax,%rsi
  802f25:	bf 01 00 00 00       	mov    $0x1,%edi
  802f2a:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3d:	79 1d                	jns    802f5c <open+0xc5>
		fd_close(fd, 0);
  802f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f43:	be 00 00 00 00       	mov    $0x0,%esi
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 1f 26 80 00 00 	movabs $0x80261f,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
		return r;
  802f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5a:	eb 13                	jmp    802f6f <open+0xd8>
	}

	return fd2num(fd);
  802f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f60:	48 89 c7             	mov    %rax,%rdi
  802f63:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  802f6a:	00 00 00 
  802f6d:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802f6f:	c9                   	leaveq 
  802f70:	c3                   	retq   

0000000000802f71 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f71:	55                   	push   %rbp
  802f72:	48 89 e5             	mov    %rsp,%rbp
  802f75:	48 83 ec 10          	sub    $0x10,%rsp
  802f79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f81:	8b 50 0c             	mov    0xc(%rax),%edx
  802f84:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8b:	00 00 00 
  802f8e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f90:	be 00 00 00 00       	mov    $0x0,%esi
  802f95:	bf 06 00 00 00       	mov    $0x6,%edi
  802f9a:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  802fa1:	00 00 00 
  802fa4:	ff d0                	callq  *%rax
}
  802fa6:	c9                   	leaveq 
  802fa7:	c3                   	retq   

0000000000802fa8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fa8:	55                   	push   %rbp
  802fa9:	48 89 e5             	mov    %rsp,%rbp
  802fac:	48 83 ec 30          	sub    $0x30,%rsp
  802fb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc0:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fca:	00 00 00 
  802fcd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fcf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd6:	00 00 00 
  802fd9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fdd:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fe1:	be 00 00 00 00       	mov    $0x0,%esi
  802fe6:	bf 03 00 00 00       	mov    $0x3,%edi
  802feb:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffe:	79 05                	jns    803005 <devfile_read+0x5d>
		return r;
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	eb 26                	jmp    80302b <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803008:	48 63 d0             	movslq %eax,%rdx
  80300b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803016:	00 00 00 
  803019:	48 89 c7             	mov    %rax,%rdi
  80301c:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax

	return r;
  803028:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 30          	sub    $0x30,%rsp
  803035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803039:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80303d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  803041:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803048:	00 
  803049:	76 08                	jbe    803053 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80304b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803052:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803057:	8b 50 0c             	mov    0xc(%rax),%edx
  80305a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803061:	00 00 00 
  803064:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803066:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80306d:	00 00 00 
  803070:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803074:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  803078:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80307c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803080:	48 89 c6             	mov    %rax,%rsi
  803083:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80308a:	00 00 00 
  80308d:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803099:	be 00 00 00 00       	mov    $0x0,%esi
  80309e:	bf 04 00 00 00       	mov    $0x4,%edi
  8030a3:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
  8030af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b6:	79 05                	jns    8030bd <devfile_write+0x90>
		return r;
  8030b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bb:	eb 03                	jmp    8030c0 <devfile_write+0x93>

	return r;
  8030bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030c0:	c9                   	leaveq 
  8030c1:	c3                   	retq   

00000000008030c2 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030c2:	55                   	push   %rbp
  8030c3:	48 89 e5             	mov    %rsp,%rbp
  8030c6:	48 83 ec 20          	sub    $0x20,%rsp
  8030ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d6:	8b 50 0c             	mov    0xc(%rax),%edx
  8030d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e0:	00 00 00 
  8030e3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030e5:	be 00 00 00 00       	mov    $0x0,%esi
  8030ea:	bf 05 00 00 00       	mov    $0x5,%edi
  8030ef:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  8030f6:	00 00 00 
  8030f9:	ff d0                	callq  *%rax
  8030fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803102:	79 05                	jns    803109 <devfile_stat+0x47>
		return r;
  803104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803107:	eb 56                	jmp    80315f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803114:	00 00 00 
  803117:	48 89 c7             	mov    %rax,%rdi
  80311a:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  803121:	00 00 00 
  803124:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803126:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80312d:	00 00 00 
  803130:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803136:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80313a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803140:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803147:	00 00 00 
  80314a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803154:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315f:	c9                   	leaveq 
  803160:	c3                   	retq   

0000000000803161 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
  803165:	48 83 ec 10          	sub    $0x10,%rsp
  803169:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80316d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803174:	8b 50 0c             	mov    0xc(%rax),%edx
  803177:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80317e:	00 00 00 
  803181:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803183:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80318a:	00 00 00 
  80318d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803190:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803193:	be 00 00 00 00       	mov    $0x0,%esi
  803198:	bf 02 00 00 00       	mov    $0x2,%edi
  80319d:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
}
  8031a9:	c9                   	leaveq 
  8031aa:	c3                   	retq   

00000000008031ab <remove>:

// Delete a file
int
remove(const char *path)
{
  8031ab:	55                   	push   %rbp
  8031ac:	48 89 e5             	mov    %rsp,%rbp
  8031af:	48 83 ec 10          	sub    $0x10,%rsp
  8031b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bb:	48 89 c7             	mov    %rax,%rdi
  8031be:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
  8031ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031cf:	7e 07                	jle    8031d8 <remove+0x2d>
		return -E_BAD_PATH;
  8031d1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031d6:	eb 33                	jmp    80320b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031dc:	48 89 c6             	mov    %rax,%rsi
  8031df:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031e6:	00 00 00 
  8031e9:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031f5:	be 00 00 00 00       	mov    $0x0,%esi
  8031fa:	bf 07 00 00 00       	mov    $0x7,%edi
  8031ff:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
}
  80320b:	c9                   	leaveq 
  80320c:	c3                   	retq   

000000000080320d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80320d:	55                   	push   %rbp
  80320e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803211:	be 00 00 00 00       	mov    $0x0,%esi
  803216:	bf 08 00 00 00       	mov    $0x8,%edi
  80321b:	48 b8 10 2e 80 00 00 	movabs $0x802e10,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
}
  803227:	5d                   	pop    %rbp
  803228:	c3                   	retq   

0000000000803229 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803229:	55                   	push   %rbp
  80322a:	48 89 e5             	mov    %rsp,%rbp
  80322d:	53                   	push   %rbx
  80322e:	48 83 ec 38          	sub    $0x38,%rsp
  803232:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803236:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 f7 24 80 00 00 	movabs $0x8024f7,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803250:	0f 88 bf 01 00 00    	js     803415 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803256:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325a:	ba 07 04 00 00       	mov    $0x407,%edx
  80325f:	48 89 c6             	mov    %rax,%rsi
  803262:	bf 00 00 00 00       	mov    $0x0,%edi
  803267:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
  803273:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803276:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80327a:	0f 88 95 01 00 00    	js     803415 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803280:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803284:	48 89 c7             	mov    %rax,%rdi
  803287:	48 b8 f7 24 80 00 00 	movabs $0x8024f7,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329a:	0f 88 5d 01 00 00    	js     8033fd <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032a9:	48 89 c6             	mov    %rax,%rsi
  8032ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b1:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
  8032bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c4:	0f 88 33 01 00 00    	js     8033fd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ce:	48 89 c7             	mov    %rax,%rdi
  8032d1:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
  8032dd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8032ea:	48 89 c6             	mov    %rax,%rsi
  8032ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f2:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8032f9:	00 00 00 
  8032fc:	ff d0                	callq  *%rax
  8032fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803301:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803305:	79 05                	jns    80330c <pipe+0xe3>
		goto err2;
  803307:	e9 d9 00 00 00       	jmpq   8033e5 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80330c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803310:	48 89 c7             	mov    %rax,%rdi
  803313:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  80331a:	00 00 00 
  80331d:	ff d0                	callq  *%rax
  80331f:	48 89 c2             	mov    %rax,%rdx
  803322:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803326:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80332c:	48 89 d1             	mov    %rdx,%rcx
  80332f:	ba 00 00 00 00       	mov    $0x0,%edx
  803334:	48 89 c6             	mov    %rax,%rsi
  803337:	bf 00 00 00 00       	mov    $0x0,%edi
  80333c:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80334b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80334f:	79 1b                	jns    80336c <pipe+0x143>
		goto err3;
  803351:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803352:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803356:	48 89 c6             	mov    %rax,%rsi
  803359:	bf 00 00 00 00       	mov    $0x0,%edi
  80335e:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	eb 79                	jmp    8033e5 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80336c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803370:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803377:	00 00 00 
  80337a:	8b 12                	mov    (%rdx),%edx
  80337c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80337e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803382:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803389:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338d:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803394:	00 00 00 
  803397:	8b 12                	mov    (%rdx),%edx
  803399:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80339b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
  8033b9:	89 c2                	mov    %eax,%edx
  8033bb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033bf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033c5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033cd:	48 89 c7             	mov    %rax,%rdi
  8033d0:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8033d7:	00 00 00 
  8033da:	ff d0                	callq  *%rax
  8033dc:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033de:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e3:	eb 33                	jmp    803418 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8033e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e9:	48 89 c6             	mov    %rax,%rsi
  8033ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f1:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  8033f8:	00 00 00 
  8033fb:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8033fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803401:	48 89 c6             	mov    %rax,%rsi
  803404:	bf 00 00 00 00       	mov    $0x0,%edi
  803409:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
    err:
	return r;
  803415:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803418:	48 83 c4 38          	add    $0x38,%rsp
  80341c:	5b                   	pop    %rbx
  80341d:	5d                   	pop    %rbp
  80341e:	c3                   	retq   

000000000080341f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80341f:	55                   	push   %rbp
  803420:	48 89 e5             	mov    %rsp,%rbp
  803423:	53                   	push   %rbx
  803424:	48 83 ec 28          	sub    $0x28,%rsp
  803428:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80342c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803430:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803437:	00 00 00 
  80343a:	48 8b 00             	mov    (%rax),%rax
  80343d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803443:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344a:	48 89 c7             	mov    %rax,%rdi
  80344d:	48 b8 ae 3c 80 00 00 	movabs $0x803cae,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	89 c3                	mov    %eax,%ebx
  80345b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345f:	48 89 c7             	mov    %rax,%rdi
  803462:	48 b8 ae 3c 80 00 00 	movabs $0x803cae,%rax
  803469:	00 00 00 
  80346c:	ff d0                	callq  *%rax
  80346e:	39 c3                	cmp    %eax,%ebx
  803470:	0f 94 c0             	sete   %al
  803473:	0f b6 c0             	movzbl %al,%eax
  803476:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803479:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803480:	00 00 00 
  803483:	48 8b 00             	mov    (%rax),%rax
  803486:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80348c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80348f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803492:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803495:	75 05                	jne    80349c <_pipeisclosed+0x7d>
			return ret;
  803497:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80349a:	eb 4f                	jmp    8034eb <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80349c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034a2:	74 42                	je     8034e6 <_pipeisclosed+0xc7>
  8034a4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034a8:	75 3c                	jne    8034e6 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034aa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034b1:	00 00 00 
  8034b4:	48 8b 00             	mov    (%rax),%rax
  8034b7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034bd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c3:	89 c6                	mov    %eax,%esi
  8034c5:	48 bf b3 43 80 00 00 	movabs $0x8043b3,%rdi
  8034cc:	00 00 00 
  8034cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d4:	49 b8 7f 04 80 00 00 	movabs $0x80047f,%r8
  8034db:	00 00 00 
  8034de:	41 ff d0             	callq  *%r8
	}
  8034e1:	e9 4a ff ff ff       	jmpq   803430 <_pipeisclosed+0x11>
  8034e6:	e9 45 ff ff ff       	jmpq   803430 <_pipeisclosed+0x11>
}
  8034eb:	48 83 c4 28          	add    $0x28,%rsp
  8034ef:	5b                   	pop    %rbx
  8034f0:	5d                   	pop    %rbp
  8034f1:	c3                   	retq   

00000000008034f2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034f2:	55                   	push   %rbp
  8034f3:	48 89 e5             	mov    %rsp,%rbp
  8034f6:	48 83 ec 30          	sub    $0x30,%rsp
  8034fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803501:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803504:	48 89 d6             	mov    %rdx,%rsi
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351c:	79 05                	jns    803523 <pipeisclosed+0x31>
		return r;
  80351e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803521:	eb 31                	jmp    803554 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803527:	48 89 c7             	mov    %rax,%rdi
  80352a:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
  803536:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80353a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803542:	48 89 d6             	mov    %rdx,%rsi
  803545:	48 89 c7             	mov    %rax,%rdi
  803548:	48 b8 1f 34 80 00 00 	movabs $0x80341f,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
}
  803554:	c9                   	leaveq 
  803555:	c3                   	retq   

0000000000803556 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803556:	55                   	push   %rbp
  803557:	48 89 e5             	mov    %rsp,%rbp
  80355a:	48 83 ec 40          	sub    $0x40,%rsp
  80355e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803562:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803566:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80356a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80356e:	48 89 c7             	mov    %rax,%rdi
  803571:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
  80357d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803581:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803585:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803589:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803590:	00 
  803591:	e9 92 00 00 00       	jmpq   803628 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803596:	eb 41                	jmp    8035d9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803598:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80359d:	74 09                	je     8035a8 <devpipe_read+0x52>
				return i;
  80359f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a3:	e9 92 00 00 00       	jmpq   80363a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b0:	48 89 d6             	mov    %rdx,%rsi
  8035b3:	48 89 c7             	mov    %rax,%rdi
  8035b6:	48 b8 1f 34 80 00 00 	movabs $0x80341f,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	74 07                	je     8035cd <devpipe_read+0x77>
				return 0;
  8035c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cb:	eb 6d                	jmp    80363a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035cd:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035dd:	8b 10                	mov    (%rax),%edx
  8035df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e3:	8b 40 04             	mov    0x4(%rax),%eax
  8035e6:	39 c2                	cmp    %eax,%edx
  8035e8:	74 ae                	je     803598 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035f2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fa:	8b 00                	mov    (%rax),%eax
  8035fc:	99                   	cltd   
  8035fd:	c1 ea 1b             	shr    $0x1b,%edx
  803600:	01 d0                	add    %edx,%eax
  803602:	83 e0 1f             	and    $0x1f,%eax
  803605:	29 d0                	sub    %edx,%eax
  803607:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80360b:	48 98                	cltq   
  80360d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803612:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803618:	8b 00                	mov    (%rax),%eax
  80361a:	8d 50 01             	lea    0x1(%rax),%edx
  80361d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803621:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803623:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803630:	0f 82 60 ff ff ff    	jb     803596 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80363a:	c9                   	leaveq 
  80363b:	c3                   	retq   

000000000080363c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80363c:	55                   	push   %rbp
  80363d:	48 89 e5             	mov    %rsp,%rbp
  803640:	48 83 ec 40          	sub    $0x40,%rsp
  803644:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803648:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80364c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803654:	48 89 c7             	mov    %rax,%rdi
  803657:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803667:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80366f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803676:	00 
  803677:	e9 8e 00 00 00       	jmpq   80370a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80367c:	eb 31                	jmp    8036af <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80367e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803686:	48 89 d6             	mov    %rdx,%rsi
  803689:	48 89 c7             	mov    %rax,%rdi
  80368c:	48 b8 1f 34 80 00 00 	movabs $0x80341f,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 07                	je     8036a3 <devpipe_write+0x67>
				return 0;
  80369c:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a1:	eb 79                	jmp    80371c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036a3:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b3:	8b 40 04             	mov    0x4(%rax),%eax
  8036b6:	48 63 d0             	movslq %eax,%rdx
  8036b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	48 98                	cltq   
  8036c1:	48 83 c0 20          	add    $0x20,%rax
  8036c5:	48 39 c2             	cmp    %rax,%rdx
  8036c8:	73 b4                	jae    80367e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ce:	8b 40 04             	mov    0x4(%rax),%eax
  8036d1:	99                   	cltd   
  8036d2:	c1 ea 1b             	shr    $0x1b,%edx
  8036d5:	01 d0                	add    %edx,%eax
  8036d7:	83 e0 1f             	and    $0x1f,%eax
  8036da:	29 d0                	sub    %edx,%eax
  8036dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036e0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036e4:	48 01 ca             	add    %rcx,%rdx
  8036e7:	0f b6 0a             	movzbl (%rdx),%ecx
  8036ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036ee:	48 98                	cltq   
  8036f0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f8:	8b 40 04             	mov    0x4(%rax),%eax
  8036fb:	8d 50 01             	lea    0x1(%rax),%edx
  8036fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803702:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803705:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80370a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803712:	0f 82 64 ff ff ff    	jb     80367c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80371c:	c9                   	leaveq 
  80371d:	c3                   	retq   

000000000080371e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80371e:	55                   	push   %rbp
  80371f:	48 89 e5             	mov    %rsp,%rbp
  803722:	48 83 ec 20          	sub    $0x20,%rsp
  803726:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80372a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80372e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803732:	48 89 c7             	mov    %rax,%rdi
  803735:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
  803741:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803745:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803749:	48 be c6 43 80 00 00 	movabs $0x8043c6,%rsi
  803750:	00 00 00 
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803766:	8b 50 04             	mov    0x4(%rax),%edx
  803769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376d:	8b 00                	mov    (%rax),%eax
  80376f:	29 c2                	sub    %eax,%edx
  803771:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803775:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80377b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80377f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803786:	00 00 00 
	stat->st_dev = &devpipe;
  803789:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378d:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803794:	00 00 00 
  803797:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80379e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037a3:	c9                   	leaveq 
  8037a4:	c3                   	retq   

00000000008037a5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	48 83 ec 10          	sub    $0x10,%rsp
  8037ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b5:	48 89 c6             	mov    %rax,%rsi
  8037b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037bd:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  8037c4:	00 00 00 
  8037c7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037cd:	48 89 c7             	mov    %rax,%rdi
  8037d0:	48 b8 cc 24 80 00 00 	movabs $0x8024cc,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	48 89 c6             	mov    %rax,%rsi
  8037df:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e4:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
}
  8037f0:	c9                   	leaveq 
  8037f1:	c3                   	retq   

00000000008037f2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8037f2:	55                   	push   %rbp
  8037f3:	48 89 e5             	mov    %rsp,%rbp
  8037f6:	48 83 ec 20          	sub    $0x20,%rsp
  8037fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8037fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803800:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803803:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803807:	be 01 00 00 00       	mov    $0x1,%esi
  80380c:	48 89 c7             	mov    %rax,%rdi
  80380f:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
}
  80381b:	c9                   	leaveq 
  80381c:	c3                   	retq   

000000000080381d <getchar>:

int
getchar(void)
{
  80381d:	55                   	push   %rbp
  80381e:	48 89 e5             	mov    %rsp,%rbp
  803821:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803825:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803829:	ba 01 00 00 00       	mov    $0x1,%edx
  80382e:	48 89 c6             	mov    %rax,%rsi
  803831:	bf 00 00 00 00       	mov    $0x0,%edi
  803836:	48 b8 c1 29 80 00 00 	movabs $0x8029c1,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
  803842:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803845:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803849:	79 05                	jns    803850 <getchar+0x33>
		return r;
  80384b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384e:	eb 14                	jmp    803864 <getchar+0x47>
	if (r < 1)
  803850:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803854:	7f 07                	jg     80385d <getchar+0x40>
		return -E_EOF;
  803856:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80385b:	eb 07                	jmp    803864 <getchar+0x47>
	return c;
  80385d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803861:	0f b6 c0             	movzbl %al,%eax
}
  803864:	c9                   	leaveq 
  803865:	c3                   	retq   

0000000000803866 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803866:	55                   	push   %rbp
  803867:	48 89 e5             	mov    %rsp,%rbp
  80386a:	48 83 ec 20          	sub    $0x20,%rsp
  80386e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803871:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803875:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803878:	48 89 d6             	mov    %rdx,%rsi
  80387b:	89 c7                	mov    %eax,%edi
  80387d:	48 b8 8f 25 80 00 00 	movabs $0x80258f,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
  803889:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803890:	79 05                	jns    803897 <iscons+0x31>
		return r;
  803892:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803895:	eb 1a                	jmp    8038b1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389b:	8b 10                	mov    (%rax),%edx
  80389d:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8038a4:	00 00 00 
  8038a7:	8b 00                	mov    (%rax),%eax
  8038a9:	39 c2                	cmp    %eax,%edx
  8038ab:	0f 94 c0             	sete   %al
  8038ae:	0f b6 c0             	movzbl %al,%eax
}
  8038b1:	c9                   	leaveq 
  8038b2:	c3                   	retq   

00000000008038b3 <opencons>:

int
opencons(void)
{
  8038b3:	55                   	push   %rbp
  8038b4:	48 89 e5             	mov    %rsp,%rbp
  8038b7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038bf:	48 89 c7             	mov    %rax,%rdi
  8038c2:	48 b8 f7 24 80 00 00 	movabs $0x8024f7,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
  8038ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d5:	79 05                	jns    8038dc <opencons+0x29>
		return r;
  8038d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038da:	eb 5b                	jmp    803937 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8038dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e0:	ba 07 04 00 00       	mov    $0x407,%edx
  8038e5:	48 89 c6             	mov    %rax,%rsi
  8038e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ed:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
  8038f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803900:	79 05                	jns    803907 <opencons+0x54>
		return r;
  803902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803905:	eb 30                	jmp    803937 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390b:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803912:	00 00 00 
  803915:	8b 12                	mov    (%rdx),%edx
  803917:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803924:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
}
  803937:	c9                   	leaveq 
  803938:	c3                   	retq   

0000000000803939 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803939:	55                   	push   %rbp
  80393a:	48 89 e5             	mov    %rsp,%rbp
  80393d:	48 83 ec 30          	sub    $0x30,%rsp
  803941:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803945:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803949:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80394d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803952:	75 07                	jne    80395b <devcons_read+0x22>
		return 0;
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
  803959:	eb 4b                	jmp    8039a6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80395b:	eb 0c                	jmp    803969 <devcons_read+0x30>
		sys_yield();
  80395d:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803969:	48 b8 58 1a 80 00 00 	movabs $0x801a58,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397c:	74 df                	je     80395d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80397e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803982:	79 05                	jns    803989 <devcons_read+0x50>
		return c;
  803984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803987:	eb 1d                	jmp    8039a6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803989:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80398d:	75 07                	jne    803996 <devcons_read+0x5d>
		return 0;
  80398f:	b8 00 00 00 00       	mov    $0x0,%eax
  803994:	eb 10                	jmp    8039a6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803999:	89 c2                	mov    %eax,%edx
  80399b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80399f:	88 10                	mov    %dl,(%rax)
	return 1;
  8039a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039a6:	c9                   	leaveq 
  8039a7:	c3                   	retq   

00000000008039a8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039a8:	55                   	push   %rbp
  8039a9:	48 89 e5             	mov    %rsp,%rbp
  8039ac:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039b3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039ba:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039c1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039cf:	eb 76                	jmp    803a47 <devcons_write+0x9f>
		m = n - tot;
  8039d1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039d8:	89 c2                	mov    %eax,%edx
  8039da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039dd:	29 c2                	sub    %eax,%edx
  8039df:	89 d0                	mov    %edx,%eax
  8039e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8039e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039e7:	83 f8 7f             	cmp    $0x7f,%eax
  8039ea:	76 07                	jbe    8039f3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8039ec:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8039f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f6:	48 63 d0             	movslq %eax,%rdx
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	48 63 c8             	movslq %eax,%rcx
  8039ff:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a06:	48 01 c1             	add    %rax,%rcx
  803a09:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a10:	48 89 ce             	mov    %rcx,%rsi
  803a13:	48 89 c7             	mov    %rax,%rdi
  803a16:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a25:	48 63 d0             	movslq %eax,%rdx
  803a28:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a2f:	48 89 d6             	mov    %rdx,%rsi
  803a32:	48 89 c7             	mov    %rax,%rdi
  803a35:	48 b8 0e 1a 80 00 00 	movabs $0x801a0e,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a44:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4a:	48 98                	cltq   
  803a4c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a53:	0f 82 78 ff ff ff    	jb     8039d1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a5c:	c9                   	leaveq 
  803a5d:	c3                   	retq   

0000000000803a5e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a5e:	55                   	push   %rbp
  803a5f:	48 89 e5             	mov    %rsp,%rbp
  803a62:	48 83 ec 08          	sub    $0x8,%rsp
  803a66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a6f:	c9                   	leaveq 
  803a70:	c3                   	retq   

0000000000803a71 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a71:	55                   	push   %rbp
  803a72:	48 89 e5             	mov    %rsp,%rbp
  803a75:	48 83 ec 10          	sub    $0x10,%rsp
  803a79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a85:	48 be d2 43 80 00 00 	movabs $0x8043d2,%rsi
  803a8c:	00 00 00 
  803a8f:	48 89 c7             	mov    %rax,%rdi
  803a92:	48 b8 27 12 80 00 00 	movabs $0x801227,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
	return 0;
  803a9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aa3:	c9                   	leaveq 
  803aa4:	c3                   	retq   

0000000000803aa5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803aa5:	55                   	push   %rbp
  803aa6:	48 89 e5             	mov    %rsp,%rbp
  803aa9:	53                   	push   %rbx
  803aaa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ab1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ab8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803abe:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ac5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803acc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ad3:	84 c0                	test   %al,%al
  803ad5:	74 23                	je     803afa <_panic+0x55>
  803ad7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803ade:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ae2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ae6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803aea:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803aee:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803af2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803af6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803afa:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b01:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b08:	00 00 00 
  803b0b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b12:	00 00 00 
  803b15:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b19:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b20:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b27:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b2e:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803b35:	00 00 00 
  803b38:	48 8b 18             	mov    (%rax),%rbx
  803b3b:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
  803b47:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b4d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b54:	41 89 c8             	mov    %ecx,%r8d
  803b57:	48 89 d1             	mov    %rdx,%rcx
  803b5a:	48 89 da             	mov    %rbx,%rdx
  803b5d:	89 c6                	mov    %eax,%esi
  803b5f:	48 bf e0 43 80 00 00 	movabs $0x8043e0,%rdi
  803b66:	00 00 00 
  803b69:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6e:	49 b9 7f 04 80 00 00 	movabs $0x80047f,%r9
  803b75:	00 00 00 
  803b78:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b7b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803b82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b89:	48 89 d6             	mov    %rdx,%rsi
  803b8c:	48 89 c7             	mov    %rax,%rdi
  803b8f:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
	cprintf("\n");
  803b9b:	48 bf 03 44 80 00 00 	movabs $0x804403,%rdi
  803ba2:	00 00 00 
  803ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  803baa:	48 ba 7f 04 80 00 00 	movabs $0x80047f,%rdx
  803bb1:	00 00 00 
  803bb4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803bb6:	cc                   	int3   
  803bb7:	eb fd                	jmp    803bb6 <_panic+0x111>

0000000000803bb9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803bb9:	55                   	push   %rbp
  803bba:	48 89 e5             	mov    %rsp,%rbp
  803bbd:	48 83 ec 10          	sub    $0x10,%rsp
  803bc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803bc5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803bcc:	00 00 00 
  803bcf:	48 8b 00             	mov    (%rax),%rax
  803bd2:	48 85 c0             	test   %rax,%rax
  803bd5:	75 3a                	jne    803c11 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803bd7:	ba 07 00 00 00       	mov    $0x7,%edx
  803bdc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803be1:	bf 00 00 00 00       	mov    $0x0,%edi
  803be6:	48 b8 56 1b 80 00 00 	movabs $0x801b56,%rax
  803bed:	00 00 00 
  803bf0:	ff d0                	callq  *%rax
  803bf2:	85 c0                	test   %eax,%eax
  803bf4:	75 1b                	jne    803c11 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803bf6:	48 be 24 3c 80 00 00 	movabs $0x803c24,%rsi
  803bfd:	00 00 00 
  803c00:	bf 00 00 00 00       	mov    $0x0,%edi
  803c05:	48 b8 e0 1c 80 00 00 	movabs $0x801ce0,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803c11:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c18:	00 00 00 
  803c1b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c1f:	48 89 10             	mov    %rdx,(%rax)
}
  803c22:	c9                   	leaveq 
  803c23:	c3                   	retq   

0000000000803c24 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803c24:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803c27:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c2e:	00 00 00 
	call *%rax
  803c31:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803c33:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803c36:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803c3d:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803c3e:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803c45:	00 
	pushq %rbx		// push utf_rip into new stack
  803c46:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803c47:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803c4e:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803c51:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803c55:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803c59:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c5d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c62:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c67:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c6c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c71:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c76:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c7b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c80:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c85:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c8a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c8f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c94:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c99:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c9e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ca3:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803ca7:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803cab:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803cac:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803cad:	c3                   	retq   

0000000000803cae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803cae:	55                   	push   %rbp
  803caf:	48 89 e5             	mov    %rsp,%rbp
  803cb2:	48 83 ec 18          	sub    $0x18,%rsp
  803cb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803cba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbe:	48 c1 e8 15          	shr    $0x15,%rax
  803cc2:	48 89 c2             	mov    %rax,%rdx
  803cc5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ccc:	01 00 00 
  803ccf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cd3:	83 e0 01             	and    $0x1,%eax
  803cd6:	48 85 c0             	test   %rax,%rax
  803cd9:	75 07                	jne    803ce2 <pageref+0x34>
		return 0;
  803cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce0:	eb 53                	jmp    803d35 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ce2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ce6:	48 c1 e8 0c          	shr    $0xc,%rax
  803cea:	48 89 c2             	mov    %rax,%rdx
  803ced:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cf4:	01 00 00 
  803cf7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cfb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803cff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d03:	83 e0 01             	and    $0x1,%eax
  803d06:	48 85 c0             	test   %rax,%rax
  803d09:	75 07                	jne    803d12 <pageref+0x64>
		return 0;
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d10:	eb 23                	jmp    803d35 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d16:	48 c1 e8 0c          	shr    $0xc,%rax
  803d1a:	48 89 c2             	mov    %rax,%rdx
  803d1d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d24:	00 00 00 
  803d27:	48 c1 e2 04          	shl    $0x4,%rdx
  803d2b:	48 01 d0             	add    %rdx,%rax
  803d2e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d32:	0f b7 c0             	movzwl %ax,%eax
}
  803d35:	c9                   	leaveq 
  803d36:	c3                   	retq   
