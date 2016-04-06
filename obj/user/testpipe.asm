
obj/user/testpipe.debug:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb c4 40 80 00 00 	movabs $0x8040c4,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 f2 33 80 00 00 	movabs $0x8033f2,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba d0 40 80 00 00 	movabs $0x8040d0,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 d8 23 80 00 00 	movabs $0x8023d8,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba e9 40 80 00 00 	movabs $0x8040e9,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf f2 40 80 00 00 	movabs $0x8040f2,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf 0f 41 80 00 00 	movabs $0x80410f,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 2c 41 80 00 00 	movabs $0x80412c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 35 17 80 00 00 	movabs $0x801735,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf 35 41 80 00 00 	movabs $0x804135,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf 51 41 80 00 00 	movabs $0x804151,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf f2 40 80 00 00 	movabs $0x8040f2,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf 64 41 80 00 00 	movabs $0x804164,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba 81 41 80 00 00 	movabs $0x804181,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 bb 39 80 00 00 	movabs $0x8039bb,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb 8b 41 80 00 00 	movabs $0x80418b,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 f2 33 80 00 00 	movabs $0x8033f2,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba d0 40 80 00 00 	movabs $0x8040d0,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 d8 23 80 00 00 	movabs $0x8023d8,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba e9 40 80 00 00 	movabs $0x8040e9,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf d9 40 80 00 00 	movabs $0x8040d9,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf 98 41 80 00 00 	movabs $0x804198,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be 9a 41 80 00 00 	movabs $0x80419a,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 d4 2c 80 00 00 	movabs $0x802cd4,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf 9c 41 80 00 00 	movabs $0x80419c,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 bb 39 80 00 00 	movabs $0x8039bb,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80054e:	48 b8 86 1e 80 00 00 	movabs $0x801e86,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	48 98                	cltq   
  80055c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800561:	48 89 c2             	mov    %rax,%rdx
  800564:	48 89 d0             	mov    %rdx,%rax
  800567:	48 c1 e0 03          	shl    $0x3,%rax
  80056b:	48 01 d0             	add    %rdx,%rax
  80056e:	48 c1 e0 05          	shl    $0x5,%rax
  800572:	48 89 c2             	mov    %rax,%rdx
  800575:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80057c:	00 00 00 
  80057f:	48 01 c2             	add    %rax,%rdx
  800582:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800589:	00 00 00 
  80058c:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80058f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800593:	7e 14                	jle    8005a9 <libmain+0x6a>
		binaryname = argv[0];
  800595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800599:	48 8b 10             	mov    (%rax),%rdx
  80059c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8005a3:	00 00 00 
  8005a6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005b0:	48 89 d6             	mov    %rdx,%rsi
  8005b3:	89 c7                	mov    %eax,%edi
  8005b5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005c1:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
}
  8005cd:	c9                   	leaveq 
  8005ce:	c3                   	retq   

00000000008005cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005d3:	48 b8 b3 29 80 00 00 	movabs $0x8029b3,%rax
  8005da:	00 00 00 
  8005dd:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005df:	bf 00 00 00 00       	mov    $0x0,%edi
  8005e4:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  8005eb:	00 00 00 
  8005ee:	ff d0                	callq  *%rax
}
  8005f0:	5d                   	pop    %rbp
  8005f1:	c3                   	retq   

00000000008005f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005f2:	55                   	push   %rbp
  8005f3:	48 89 e5             	mov    %rsp,%rbp
  8005f6:	53                   	push   %rbx
  8005f7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005fe:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800605:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80060b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800612:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800619:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800620:	84 c0                	test   %al,%al
  800622:	74 23                	je     800647 <_panic+0x55>
  800624:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80062b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80062f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800633:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800637:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80063b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80063f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800643:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800647:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80064e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800655:	00 00 00 
  800658:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80065f:	00 00 00 
  800662:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800666:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80066d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800674:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80067b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800682:	00 00 00 
  800685:	48 8b 18             	mov    (%rax),%rbx
  800688:	48 b8 86 1e 80 00 00 	movabs $0x801e86,%rax
  80068f:	00 00 00 
  800692:	ff d0                	callq  *%rax
  800694:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80069a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8006a1:	41 89 c8             	mov    %ecx,%r8d
  8006a4:	48 89 d1             	mov    %rdx,%rcx
  8006a7:	48 89 da             	mov    %rbx,%rdx
  8006aa:	89 c6                	mov    %eax,%esi
  8006ac:	48 bf d8 41 80 00 00 	movabs $0x8041d8,%rdi
  8006b3:	00 00 00 
  8006b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bb:	49 b9 2b 08 80 00 00 	movabs $0x80082b,%r9
  8006c2:	00 00 00 
  8006c5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006c8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d6:	48 89 d6             	mov    %rdx,%rsi
  8006d9:	48 89 c7             	mov    %rax,%rdi
  8006dc:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8006e3:	00 00 00 
  8006e6:	ff d0                	callq  *%rax
	cprintf("\n");
  8006e8:	48 bf fb 41 80 00 00 	movabs $0x8041fb,%rdi
  8006ef:	00 00 00 
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	48 ba 2b 08 80 00 00 	movabs $0x80082b,%rdx
  8006fe:	00 00 00 
  800701:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800703:	cc                   	int3   
  800704:	eb fd                	jmp    800703 <_panic+0x111>

0000000000800706 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800706:	55                   	push   %rbp
  800707:	48 89 e5             	mov    %rsp,%rbp
  80070a:	48 83 ec 10          	sub    $0x10,%rsp
  80070e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800711:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800719:	8b 00                	mov    (%rax),%eax
  80071b:	8d 48 01             	lea    0x1(%rax),%ecx
  80071e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800722:	89 0a                	mov    %ecx,(%rdx)
  800724:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800727:	89 d1                	mov    %edx,%ecx
  800729:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80072d:	48 98                	cltq   
  80072f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073e:	75 2c                	jne    80076c <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	48 98                	cltq   
  800748:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80074c:	48 83 c2 08          	add    $0x8,%rdx
  800750:	48 89 c6             	mov    %rax,%rsi
  800753:	48 89 d7             	mov    %rdx,%rdi
  800756:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  80075d:	00 00 00 
  800760:	ff d0                	callq  *%rax
		b->idx = 0;
  800762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800766:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80076c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800770:	8b 40 04             	mov    0x4(%rax),%eax
  800773:	8d 50 01             	lea    0x1(%rax),%edx
  800776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80077a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80077d:	c9                   	leaveq 
  80077e:	c3                   	retq   

000000000080077f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80077f:	55                   	push   %rbp
  800780:	48 89 e5             	mov    %rsp,%rbp
  800783:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80078a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800791:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800798:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80079f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007a6:	48 8b 0a             	mov    (%rdx),%rcx
  8007a9:	48 89 08             	mov    %rcx,(%rax)
  8007ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8007bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007c3:	00 00 00 
	b.cnt = 0;
  8007c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007cd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8007d0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007d7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007de:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007e5:	48 89 c6             	mov    %rax,%rsi
  8007e8:	48 bf 06 07 80 00 00 	movabs $0x800706,%rdi
  8007ef:	00 00 00 
  8007f2:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  8007f9:	00 00 00 
  8007fc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007fe:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800804:	48 98                	cltq   
  800806:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80080d:	48 83 c2 08          	add    $0x8,%rdx
  800811:	48 89 c6             	mov    %rax,%rsi
  800814:	48 89 d7             	mov    %rdx,%rdi
  800817:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  80081e:	00 00 00 
  800821:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800823:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800829:	c9                   	leaveq 
  80082a:	c3                   	retq   

000000000080082b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80082b:	55                   	push   %rbp
  80082c:	48 89 e5             	mov    %rsp,%rbp
  80082f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800836:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80083d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800844:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80084b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800852:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800859:	84 c0                	test   %al,%al
  80085b:	74 20                	je     80087d <cprintf+0x52>
  80085d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800861:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800865:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800869:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80086d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800871:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800875:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800879:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80087d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800884:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80088b:	00 00 00 
  80088e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800895:	00 00 00 
  800898:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80089c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008a3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8008aa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8008b1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008b8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008bf:	48 8b 0a             	mov    (%rdx),%rcx
  8008c2:	48 89 08             	mov    %rcx,(%rax)
  8008c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8008d5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008e3:	48 89 d6             	mov    %rdx,%rsi
  8008e6:	48 89 c7             	mov    %rax,%rdi
  8008e9:	48 b8 7f 07 80 00 00 	movabs $0x80077f,%rax
  8008f0:	00 00 00 
  8008f3:	ff d0                	callq  *%rax
  8008f5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008fb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800901:	c9                   	leaveq 
  800902:	c3                   	retq   

0000000000800903 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800903:	55                   	push   %rbp
  800904:	48 89 e5             	mov    %rsp,%rbp
  800907:	53                   	push   %rbx
  800908:	48 83 ec 38          	sub    $0x38,%rsp
  80090c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800914:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800918:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80091b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80091f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800923:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800926:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80092a:	77 3b                	ja     800967 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80092c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80092f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800933:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	48 f7 f3             	div    %rbx
  800942:	48 89 c2             	mov    %rax,%rdx
  800945:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800948:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80094b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	41 89 f9             	mov    %edi,%r9d
  800956:	48 89 c7             	mov    %rax,%rdi
  800959:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  800960:	00 00 00 
  800963:	ff d0                	callq  *%rax
  800965:	eb 1e                	jmp    800985 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800967:	eb 12                	jmp    80097b <printnum+0x78>
			putch(padc, putdat);
  800969:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80096d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800974:	48 89 ce             	mov    %rcx,%rsi
  800977:	89 d7                	mov    %edx,%edi
  800979:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80097b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80097f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800983:	7f e4                	jg     800969 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800985:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	48 f7 f1             	div    %rcx
  800994:	48 89 d0             	mov    %rdx,%rax
  800997:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  80099e:	00 00 00 
  8009a1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8009a5:	0f be d0             	movsbl %al,%edx
  8009a8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	48 89 ce             	mov    %rcx,%rsi
  8009b3:	89 d7                	mov    %edx,%edi
  8009b5:	ff d0                	callq  *%rax
}
  8009b7:	48 83 c4 38          	add    $0x38,%rsp
  8009bb:	5b                   	pop    %rbx
  8009bc:	5d                   	pop    %rbp
  8009bd:	c3                   	retq   

00000000008009be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009be:	55                   	push   %rbp
  8009bf:	48 89 e5             	mov    %rsp,%rbp
  8009c2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8009cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009d1:	7e 52                	jle    800a25 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d7:	8b 00                	mov    (%rax),%eax
  8009d9:	83 f8 30             	cmp    $0x30,%eax
  8009dc:	73 24                	jae    800a02 <getuint+0x44>
  8009de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ea:	8b 00                	mov    (%rax),%eax
  8009ec:	89 c0                	mov    %eax,%eax
  8009ee:	48 01 d0             	add    %rdx,%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	8b 12                	mov    (%rdx),%edx
  8009f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fe:	89 0a                	mov    %ecx,(%rdx)
  800a00:	eb 17                	jmp    800a19 <getuint+0x5b>
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0a:	48 89 d0             	mov    %rdx,%rax
  800a0d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a19:	48 8b 00             	mov    (%rax),%rax
  800a1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a20:	e9 a3 00 00 00       	jmpq   800ac8 <getuint+0x10a>
	else if (lflag)
  800a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a29:	74 4f                	je     800a7a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2f:	8b 00                	mov    (%rax),%eax
  800a31:	83 f8 30             	cmp    $0x30,%eax
  800a34:	73 24                	jae    800a5a <getuint+0x9c>
  800a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a42:	8b 00                	mov    (%rax),%eax
  800a44:	89 c0                	mov    %eax,%eax
  800a46:	48 01 d0             	add    %rdx,%rax
  800a49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4d:	8b 12                	mov    (%rdx),%edx
  800a4f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a56:	89 0a                	mov    %ecx,(%rdx)
  800a58:	eb 17                	jmp    800a71 <getuint+0xb3>
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a62:	48 89 d0             	mov    %rdx,%rax
  800a65:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a71:	48 8b 00             	mov    (%rax),%rax
  800a74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a78:	eb 4e                	jmp    800ac8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7e:	8b 00                	mov    (%rax),%eax
  800a80:	83 f8 30             	cmp    $0x30,%eax
  800a83:	73 24                	jae    800aa9 <getuint+0xeb>
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a91:	8b 00                	mov    (%rax),%eax
  800a93:	89 c0                	mov    %eax,%eax
  800a95:	48 01 d0             	add    %rdx,%rax
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	8b 12                	mov    (%rdx),%edx
  800a9e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa5:	89 0a                	mov    %ecx,(%rdx)
  800aa7:	eb 17                	jmp    800ac0 <getuint+0x102>
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ab1:	48 89 d0             	mov    %rdx,%rax
  800ab4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ac0:	8b 00                	mov    (%rax),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ac8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800acc:	c9                   	leaveq 
  800acd:	c3                   	retq   

0000000000800ace <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ace:	55                   	push   %rbp
  800acf:	48 89 e5             	mov    %rsp,%rbp
  800ad2:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ad6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ada:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800add:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ae1:	7e 52                	jle    800b35 <getint+0x67>
		x=va_arg(*ap, long long);
  800ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae7:	8b 00                	mov    (%rax),%eax
  800ae9:	83 f8 30             	cmp    $0x30,%eax
  800aec:	73 24                	jae    800b12 <getint+0x44>
  800aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afa:	8b 00                	mov    (%rax),%eax
  800afc:	89 c0                	mov    %eax,%eax
  800afe:	48 01 d0             	add    %rdx,%rax
  800b01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b05:	8b 12                	mov    (%rdx),%edx
  800b07:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0e:	89 0a                	mov    %ecx,(%rdx)
  800b10:	eb 17                	jmp    800b29 <getint+0x5b>
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b1a:	48 89 d0             	mov    %rdx,%rax
  800b1d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b25:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b29:	48 8b 00             	mov    (%rax),%rax
  800b2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b30:	e9 a3 00 00 00       	jmpq   800bd8 <getint+0x10a>
	else if (lflag)
  800b35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b39:	74 4f                	je     800b8a <getint+0xbc>
		x=va_arg(*ap, long);
  800b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3f:	8b 00                	mov    (%rax),%eax
  800b41:	83 f8 30             	cmp    $0x30,%eax
  800b44:	73 24                	jae    800b6a <getint+0x9c>
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b52:	8b 00                	mov    (%rax),%eax
  800b54:	89 c0                	mov    %eax,%eax
  800b56:	48 01 d0             	add    %rdx,%rax
  800b59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5d:	8b 12                	mov    (%rdx),%edx
  800b5f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b66:	89 0a                	mov    %ecx,(%rdx)
  800b68:	eb 17                	jmp    800b81 <getint+0xb3>
  800b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b72:	48 89 d0             	mov    %rdx,%rax
  800b75:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b81:	48 8b 00             	mov    (%rax),%rax
  800b84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b88:	eb 4e                	jmp    800bd8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8e:	8b 00                	mov    (%rax),%eax
  800b90:	83 f8 30             	cmp    $0x30,%eax
  800b93:	73 24                	jae    800bb9 <getint+0xeb>
  800b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b99:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	8b 00                	mov    (%rax),%eax
  800ba3:	89 c0                	mov    %eax,%eax
  800ba5:	48 01 d0             	add    %rdx,%rax
  800ba8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bac:	8b 12                	mov    (%rdx),%edx
  800bae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bb5:	89 0a                	mov    %ecx,(%rdx)
  800bb7:	eb 17                	jmp    800bd0 <getint+0x102>
  800bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bbd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bc1:	48 89 d0             	mov    %rdx,%rax
  800bc4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bcc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bd0:	8b 00                	mov    (%rax),%eax
  800bd2:	48 98                	cltq   
  800bd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bdc:	c9                   	leaveq 
  800bdd:	c3                   	retq   

0000000000800bde <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bde:	55                   	push   %rbp
  800bdf:	48 89 e5             	mov    %rsp,%rbp
  800be2:	41 54                	push   %r12
  800be4:	53                   	push   %rbx
  800be5:	48 83 ec 60          	sub    $0x60,%rsp
  800be9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bed:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bf1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bf5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bf9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c01:	48 8b 0a             	mov    (%rdx),%rcx
  800c04:	48 89 08             	mov    %rcx,(%rax)
  800c07:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c0b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c0f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c13:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800c17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c1f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c23:	0f b6 00             	movzbl (%rax),%eax
  800c26:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800c29:	eb 29                	jmp    800c54 <vprintfmt+0x76>
			if (ch == '\0')
  800c2b:	85 db                	test   %ebx,%ebx
  800c2d:	0f 84 ad 06 00 00    	je     8012e0 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800c33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 d6             	mov    %rdx,%rsi
  800c3e:	89 df                	mov    %ebx,%edi
  800c40:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800c42:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c46:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c4a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c4e:	0f b6 00             	movzbl (%rax),%eax
  800c51:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800c54:	83 fb 25             	cmp    $0x25,%ebx
  800c57:	74 05                	je     800c5e <vprintfmt+0x80>
  800c59:	83 fb 1b             	cmp    $0x1b,%ebx
  800c5c:	75 cd                	jne    800c2b <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800c5e:	83 fb 1b             	cmp    $0x1b,%ebx
  800c61:	0f 85 ae 01 00 00    	jne    800e15 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800c67:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800c6e:	00 00 00 
  800c71:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800c77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	89 df                	mov    %ebx,%edi
  800c84:	ff d0                	callq  *%rax
			putch('[', putdat);
  800c86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8e:	48 89 d6             	mov    %rdx,%rsi
  800c91:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800c96:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800c98:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800c9e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ca3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca7:	0f b6 00             	movzbl (%rax),%eax
  800caa:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800cad:	eb 32                	jmp    800ce1 <vprintfmt+0x103>
					putch(ch, putdat);
  800caf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb7:	48 89 d6             	mov    %rdx,%rsi
  800cba:	89 df                	mov    %ebx,%edi
  800cbc:	ff d0                	callq  *%rax
					esc_color *= 10;
  800cbe:	44 89 e0             	mov    %r12d,%eax
  800cc1:	c1 e0 02             	shl    $0x2,%eax
  800cc4:	44 01 e0             	add    %r12d,%eax
  800cc7:	01 c0                	add    %eax,%eax
  800cc9:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800ccc:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800ccf:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800cd2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800cd7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cdb:	0f b6 00             	movzbl (%rax),%eax
  800cde:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800ce1:	83 fb 3b             	cmp    $0x3b,%ebx
  800ce4:	74 05                	je     800ceb <vprintfmt+0x10d>
  800ce6:	83 fb 6d             	cmp    $0x6d,%ebx
  800ce9:	75 c4                	jne    800caf <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800ceb:	45 85 e4             	test   %r12d,%r12d
  800cee:	75 15                	jne    800d05 <vprintfmt+0x127>
					color_flag = 0x07;
  800cf0:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800cf7:	00 00 00 
  800cfa:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800d00:	e9 dc 00 00 00       	jmpq   800de1 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800d05:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800d09:	7e 69                	jle    800d74 <vprintfmt+0x196>
  800d0b:	41 83 fc 25          	cmp    $0x25,%r12d
  800d0f:	7f 63                	jg     800d74 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800d11:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d18:	00 00 00 
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	25 f8 00 00 00       	and    $0xf8,%eax
  800d22:	89 c2                	mov    %eax,%edx
  800d24:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d2b:	00 00 00 
  800d2e:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800d30:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800d34:	44 89 e0             	mov    %r12d,%eax
  800d37:	83 e0 04             	and    $0x4,%eax
  800d3a:	c1 f8 02             	sar    $0x2,%eax
  800d3d:	89 c2                	mov    %eax,%edx
  800d3f:	44 89 e0             	mov    %r12d,%eax
  800d42:	83 e0 02             	and    $0x2,%eax
  800d45:	09 c2                	or     %eax,%edx
  800d47:	44 89 e0             	mov    %r12d,%eax
  800d4a:	83 e0 01             	and    $0x1,%eax
  800d4d:	c1 e0 02             	shl    $0x2,%eax
  800d50:	09 c2                	or     %eax,%edx
  800d52:	41 89 d4             	mov    %edx,%r12d
  800d55:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d5c:	00 00 00 
  800d5f:	8b 00                	mov    (%rax),%eax
  800d61:	44 89 e2             	mov    %r12d,%edx
  800d64:	09 c2                	or     %eax,%edx
  800d66:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d6d:	00 00 00 
  800d70:	89 10                	mov    %edx,(%rax)
  800d72:	eb 6d                	jmp    800de1 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800d74:	41 83 fc 27          	cmp    $0x27,%r12d
  800d78:	7e 67                	jle    800de1 <vprintfmt+0x203>
  800d7a:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800d7e:	7f 61                	jg     800de1 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800d80:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d87:	00 00 00 
  800d8a:	8b 00                	mov    (%rax),%eax
  800d8c:	25 8f 00 00 00       	and    $0x8f,%eax
  800d91:	89 c2                	mov    %eax,%edx
  800d93:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800d9a:	00 00 00 
  800d9d:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800d9f:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800da3:	44 89 e0             	mov    %r12d,%eax
  800da6:	83 e0 04             	and    $0x4,%eax
  800da9:	c1 f8 02             	sar    $0x2,%eax
  800dac:	89 c2                	mov    %eax,%edx
  800dae:	44 89 e0             	mov    %r12d,%eax
  800db1:	83 e0 02             	and    $0x2,%eax
  800db4:	09 c2                	or     %eax,%edx
  800db6:	44 89 e0             	mov    %r12d,%eax
  800db9:	83 e0 01             	and    $0x1,%eax
  800dbc:	c1 e0 06             	shl    $0x6,%eax
  800dbf:	09 c2                	or     %eax,%edx
  800dc1:	41 89 d4             	mov    %edx,%r12d
  800dc4:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800dcb:	00 00 00 
  800dce:	8b 00                	mov    (%rax),%eax
  800dd0:	44 89 e2             	mov    %r12d,%edx
  800dd3:	09 c2                	or     %eax,%edx
  800dd5:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800ddc:	00 00 00 
  800ddf:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800de1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de9:	48 89 d6             	mov    %rdx,%rsi
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800df0:	83 fb 6d             	cmp    $0x6d,%ebx
  800df3:	75 1b                	jne    800e10 <vprintfmt+0x232>
					fmt ++;
  800df5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800dfa:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800dfb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800e02:	00 00 00 
  800e05:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800e0b:	e9 cb 04 00 00       	jmpq   8012db <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800e10:	e9 83 fe ff ff       	jmpq   800c98 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800e15:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800e19:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800e20:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800e27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800e2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800e41:	0f b6 00             	movzbl (%rax),%eax
  800e44:	0f b6 d8             	movzbl %al,%ebx
  800e47:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800e4a:	83 f8 55             	cmp    $0x55,%eax
  800e4d:	0f 87 5a 04 00 00    	ja     8012ad <vprintfmt+0x6cf>
  800e53:	89 c0                	mov    %eax,%eax
  800e55:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800e5c:	00 
  800e5d:	48 b8 f0 43 80 00 00 	movabs $0x8043f0,%rax
  800e64:	00 00 00 
  800e67:	48 01 d0             	add    %rdx,%rax
  800e6a:	48 8b 00             	mov    (%rax),%rax
  800e6d:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e6f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800e73:	eb c0                	jmp    800e35 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e75:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800e79:	eb ba                	jmp    800e35 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e7b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800e82:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800e85:	89 d0                	mov    %edx,%eax
  800e87:	c1 e0 02             	shl    $0x2,%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	01 c0                	add    %eax,%eax
  800e8e:	01 d8                	add    %ebx,%eax
  800e90:	83 e8 30             	sub    $0x30,%eax
  800e93:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800e96:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e9a:	0f b6 00             	movzbl (%rax),%eax
  800e9d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ea0:	83 fb 2f             	cmp    $0x2f,%ebx
  800ea3:	7e 0c                	jle    800eb1 <vprintfmt+0x2d3>
  800ea5:	83 fb 39             	cmp    $0x39,%ebx
  800ea8:	7f 07                	jg     800eb1 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eaa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eaf:	eb d1                	jmp    800e82 <vprintfmt+0x2a4>
			goto process_precision;
  800eb1:	eb 58                	jmp    800f0b <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800eb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eb6:	83 f8 30             	cmp    $0x30,%eax
  800eb9:	73 17                	jae    800ed2 <vprintfmt+0x2f4>
  800ebb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ebf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec2:	89 c0                	mov    %eax,%eax
  800ec4:	48 01 d0             	add    %rdx,%rax
  800ec7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eca:	83 c2 08             	add    $0x8,%edx
  800ecd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ed0:	eb 0f                	jmp    800ee1 <vprintfmt+0x303>
  800ed2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ed6:	48 89 d0             	mov    %rdx,%rax
  800ed9:	48 83 c2 08          	add    $0x8,%rdx
  800edd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ee1:	8b 00                	mov    (%rax),%eax
  800ee3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ee6:	eb 23                	jmp    800f0b <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800ee8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eec:	79 0c                	jns    800efa <vprintfmt+0x31c>
				width = 0;
  800eee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ef5:	e9 3b ff ff ff       	jmpq   800e35 <vprintfmt+0x257>
  800efa:	e9 36 ff ff ff       	jmpq   800e35 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800eff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800f06:	e9 2a ff ff ff       	jmpq   800e35 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800f0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f0f:	79 12                	jns    800f23 <vprintfmt+0x345>
				width = precision, precision = -1;
  800f11:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f14:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800f17:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800f1e:	e9 12 ff ff ff       	jmpq   800e35 <vprintfmt+0x257>
  800f23:	e9 0d ff ff ff       	jmpq   800e35 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f28:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800f2c:	e9 04 ff ff ff       	jmpq   800e35 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f34:	83 f8 30             	cmp    $0x30,%eax
  800f37:	73 17                	jae    800f50 <vprintfmt+0x372>
  800f39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f40:	89 c0                	mov    %eax,%eax
  800f42:	48 01 d0             	add    %rdx,%rax
  800f45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f48:	83 c2 08             	add    $0x8,%edx
  800f4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f4e:	eb 0f                	jmp    800f5f <vprintfmt+0x381>
  800f50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 83 c2 08          	add    $0x8,%rdx
  800f5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f5f:	8b 10                	mov    (%rax),%edx
  800f61:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800f65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f69:	48 89 ce             	mov    %rcx,%rsi
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	ff d0                	callq  *%rax
			break;
  800f70:	e9 66 03 00 00       	jmpq   8012db <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800f75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f78:	83 f8 30             	cmp    $0x30,%eax
  800f7b:	73 17                	jae    800f94 <vprintfmt+0x3b6>
  800f7d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f84:	89 c0                	mov    %eax,%eax
  800f86:	48 01 d0             	add    %rdx,%rax
  800f89:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f8c:	83 c2 08             	add    $0x8,%edx
  800f8f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f92:	eb 0f                	jmp    800fa3 <vprintfmt+0x3c5>
  800f94:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f98:	48 89 d0             	mov    %rdx,%rax
  800f9b:	48 83 c2 08          	add    $0x8,%rdx
  800f9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fa3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800fa5:	85 db                	test   %ebx,%ebx
  800fa7:	79 02                	jns    800fab <vprintfmt+0x3cd>
				err = -err;
  800fa9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800fab:	83 fb 10             	cmp    $0x10,%ebx
  800fae:	7f 16                	jg     800fc6 <vprintfmt+0x3e8>
  800fb0:	48 b8 40 43 80 00 00 	movabs $0x804340,%rax
  800fb7:	00 00 00 
  800fba:	48 63 d3             	movslq %ebx,%rdx
  800fbd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800fc1:	4d 85 e4             	test   %r12,%r12
  800fc4:	75 2e                	jne    800ff4 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800fc6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fce:	89 d9                	mov    %ebx,%ecx
  800fd0:	48 ba d9 43 80 00 00 	movabs $0x8043d9,%rdx
  800fd7:	00 00 00 
  800fda:	48 89 c7             	mov    %rax,%rdi
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  800fe9:	00 00 00 
  800fec:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fef:	e9 e7 02 00 00       	jmpq   8012db <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ff4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ff8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ffc:	4c 89 e1             	mov    %r12,%rcx
  800fff:	48 ba e2 43 80 00 00 	movabs $0x8043e2,%rdx
  801006:	00 00 00 
  801009:	48 89 c7             	mov    %rax,%rdi
  80100c:	b8 00 00 00 00       	mov    $0x0,%eax
  801011:	49 b8 e9 12 80 00 00 	movabs $0x8012e9,%r8
  801018:	00 00 00 
  80101b:	41 ff d0             	callq  *%r8
			break;
  80101e:	e9 b8 02 00 00       	jmpq   8012db <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801023:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801026:	83 f8 30             	cmp    $0x30,%eax
  801029:	73 17                	jae    801042 <vprintfmt+0x464>
  80102b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80102f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801032:	89 c0                	mov    %eax,%eax
  801034:	48 01 d0             	add    %rdx,%rax
  801037:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80103a:	83 c2 08             	add    $0x8,%edx
  80103d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801040:	eb 0f                	jmp    801051 <vprintfmt+0x473>
  801042:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801046:	48 89 d0             	mov    %rdx,%rax
  801049:	48 83 c2 08          	add    $0x8,%rdx
  80104d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801051:	4c 8b 20             	mov    (%rax),%r12
  801054:	4d 85 e4             	test   %r12,%r12
  801057:	75 0a                	jne    801063 <vprintfmt+0x485>
				p = "(null)";
  801059:	49 bc e5 43 80 00 00 	movabs $0x8043e5,%r12
  801060:	00 00 00 
			if (width > 0 && padc != '-')
  801063:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801067:	7e 3f                	jle    8010a8 <vprintfmt+0x4ca>
  801069:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80106d:	74 39                	je     8010a8 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  80106f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801072:	48 98                	cltq   
  801074:	48 89 c6             	mov    %rax,%rsi
  801077:	4c 89 e7             	mov    %r12,%rdi
  80107a:	48 b8 95 15 80 00 00 	movabs $0x801595,%rax
  801081:	00 00 00 
  801084:	ff d0                	callq  *%rax
  801086:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801089:	eb 17                	jmp    8010a2 <vprintfmt+0x4c4>
					putch(padc, putdat);
  80108b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80108f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801093:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801097:	48 89 ce             	mov    %rcx,%rsi
  80109a:	89 d7                	mov    %edx,%edi
  80109c:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80109e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8010a6:	7f e3                	jg     80108b <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a8:	eb 37                	jmp    8010e1 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8010aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8010ae:	74 1e                	je     8010ce <vprintfmt+0x4f0>
  8010b0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b3:	7e 05                	jle    8010ba <vprintfmt+0x4dc>
  8010b5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010b8:	7e 14                	jle    8010ce <vprintfmt+0x4f0>
					putch('?', putdat);
  8010ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c2:	48 89 d6             	mov    %rdx,%rsi
  8010c5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8010ca:	ff d0                	callq  *%rax
  8010cc:	eb 0f                	jmp    8010dd <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  8010ce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d6:	48 89 d6             	mov    %rdx,%rsi
  8010d9:	89 df                	mov    %ebx,%edi
  8010db:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010dd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8010e1:	4c 89 e0             	mov    %r12,%rax
  8010e4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8010e8:	0f b6 00             	movzbl (%rax),%eax
  8010eb:	0f be d8             	movsbl %al,%ebx
  8010ee:	85 db                	test   %ebx,%ebx
  8010f0:	74 10                	je     801102 <vprintfmt+0x524>
  8010f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8010f6:	78 b2                	js     8010aa <vprintfmt+0x4cc>
  8010f8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8010fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801100:	79 a8                	jns    8010aa <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801102:	eb 16                	jmp    80111a <vprintfmt+0x53c>
				putch(' ', putdat);
  801104:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801108:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80110c:	48 89 d6             	mov    %rdx,%rsi
  80110f:	bf 20 00 00 00       	mov    $0x20,%edi
  801114:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801116:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80111a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80111e:	7f e4                	jg     801104 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  801120:	e9 b6 01 00 00       	jmpq   8012db <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801125:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801129:	be 03 00 00 00       	mov    $0x3,%esi
  80112e:	48 89 c7             	mov    %rax,%rdi
  801131:	48 b8 ce 0a 80 00 00 	movabs $0x800ace,%rax
  801138:	00 00 00 
  80113b:	ff d0                	callq  *%rax
  80113d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801145:	48 85 c0             	test   %rax,%rax
  801148:	79 1d                	jns    801167 <vprintfmt+0x589>
				putch('-', putdat);
  80114a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80114e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801152:	48 89 d6             	mov    %rdx,%rsi
  801155:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80115a:	ff d0                	callq  *%rax
				num = -(long long) num;
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	48 f7 d8             	neg    %rax
  801163:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801167:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80116e:	e9 fb 00 00 00       	jmpq   80126e <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801173:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801177:	be 03 00 00 00       	mov    $0x3,%esi
  80117c:	48 89 c7             	mov    %rax,%rdi
  80117f:	48 b8 be 09 80 00 00 	movabs $0x8009be,%rax
  801186:	00 00 00 
  801189:	ff d0                	callq  *%rax
  80118b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80118f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801196:	e9 d3 00 00 00       	jmpq   80126e <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  80119b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80119f:	be 03 00 00 00       	mov    $0x3,%esi
  8011a4:	48 89 c7             	mov    %rax,%rdi
  8011a7:	48 b8 ce 0a 80 00 00 	movabs $0x800ace,%rax
  8011ae:	00 00 00 
  8011b1:	ff d0                	callq  *%rax
  8011b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8011b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bb:	48 85 c0             	test   %rax,%rax
  8011be:	79 1d                	jns    8011dd <vprintfmt+0x5ff>
				putch('-', putdat);
  8011c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011c8:	48 89 d6             	mov    %rdx,%rsi
  8011cb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8011d0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8011d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d6:	48 f7 d8             	neg    %rax
  8011d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8011dd:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8011e4:	e9 85 00 00 00       	jmpq   80126e <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8011e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011f1:	48 89 d6             	mov    %rdx,%rsi
  8011f4:	bf 30 00 00 00       	mov    $0x30,%edi
  8011f9:	ff d0                	callq  *%rax
			putch('x', putdat);
  8011fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801203:	48 89 d6             	mov    %rdx,%rsi
  801206:	bf 78 00 00 00       	mov    $0x78,%edi
  80120b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80120d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801210:	83 f8 30             	cmp    $0x30,%eax
  801213:	73 17                	jae    80122c <vprintfmt+0x64e>
  801215:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801219:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80121c:	89 c0                	mov    %eax,%eax
  80121e:	48 01 d0             	add    %rdx,%rax
  801221:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801224:	83 c2 08             	add    $0x8,%edx
  801227:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80122a:	eb 0f                	jmp    80123b <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  80122c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801230:	48 89 d0             	mov    %rdx,%rax
  801233:	48 83 c2 08          	add    $0x8,%rdx
  801237:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80123b:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80123e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801242:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801249:	eb 23                	jmp    80126e <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80124b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80124f:	be 03 00 00 00       	mov    $0x3,%esi
  801254:	48 89 c7             	mov    %rax,%rdi
  801257:	48 b8 be 09 80 00 00 	movabs $0x8009be,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
  801263:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801267:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80126e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801273:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801276:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801279:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801281:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801285:	45 89 c1             	mov    %r8d,%r9d
  801288:	41 89 f8             	mov    %edi,%r8d
  80128b:	48 89 c7             	mov    %rax,%rdi
  80128e:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  801295:	00 00 00 
  801298:	ff d0                	callq  *%rax
			break;
  80129a:	eb 3f                	jmp    8012db <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80129c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012a4:	48 89 d6             	mov    %rdx,%rsi
  8012a7:	89 df                	mov    %ebx,%edi
  8012a9:	ff d0                	callq  *%rax
			break;
  8012ab:	eb 2e                	jmp    8012db <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012b5:	48 89 d6             	mov    %rdx,%rsi
  8012b8:	bf 25 00 00 00       	mov    $0x25,%edi
  8012bd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012bf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8012c4:	eb 05                	jmp    8012cb <vprintfmt+0x6ed>
  8012c6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8012cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8012cf:	48 83 e8 01          	sub    $0x1,%rax
  8012d3:	0f b6 00             	movzbl (%rax),%eax
  8012d6:	3c 25                	cmp    $0x25,%al
  8012d8:	75 ec                	jne    8012c6 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8012da:	90                   	nop
		}
	}
  8012db:	e9 37 f9 ff ff       	jmpq   800c17 <vprintfmt+0x39>
    va_end(aq);
}
  8012e0:	48 83 c4 60          	add    $0x60,%rsp
  8012e4:	5b                   	pop    %rbx
  8012e5:	41 5c                	pop    %r12
  8012e7:	5d                   	pop    %rbp
  8012e8:	c3                   	retq   

00000000008012e9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8012f4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8012fb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801302:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801309:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801310:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801317:	84 c0                	test   %al,%al
  801319:	74 20                	je     80133b <printfmt+0x52>
  80131b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80131f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801323:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801327:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80132b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80132f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801333:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801337:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80133b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801342:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801349:	00 00 00 
  80134c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801353:	00 00 00 
  801356:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80135a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801361:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801368:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80136f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801376:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80137d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801384:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80138b:	48 89 c7             	mov    %rax,%rdi
  80138e:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
	va_end(ap);
}
  80139a:	c9                   	leaveq 
  80139b:	c3                   	retq   

000000000080139c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80139c:	55                   	push   %rbp
  80139d:	48 89 e5             	mov    %rsp,%rbp
  8013a0:	48 83 ec 10          	sub    $0x10,%rsp
  8013a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8013a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8013ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013af:	8b 40 10             	mov    0x10(%rax),%eax
  8013b2:	8d 50 01             	lea    0x1(%rax),%edx
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8013bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c0:	48 8b 10             	mov    (%rax),%rdx
  8013c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8013cb:	48 39 c2             	cmp    %rax,%rdx
  8013ce:	73 17                	jae    8013e7 <sprintputch+0x4b>
		*b->buf++ = ch;
  8013d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d4:	48 8b 00             	mov    (%rax),%rax
  8013d7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8013db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013df:	48 89 0a             	mov    %rcx,(%rdx)
  8013e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8013e5:	88 10                	mov    %dl,(%rax)
}
  8013e7:	c9                   	leaveq 
  8013e8:	c3                   	retq   

00000000008013e9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013e9:	55                   	push   %rbp
  8013ea:	48 89 e5             	mov    %rsp,%rbp
  8013ed:	48 83 ec 50          	sub    $0x50,%rsp
  8013f1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8013f5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8013f8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8013fc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801400:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801404:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801408:	48 8b 0a             	mov    (%rdx),%rcx
  80140b:	48 89 08             	mov    %rcx,(%rax)
  80140e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801412:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801416:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80141a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80141e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801422:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801426:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801429:	48 98                	cltq   
  80142b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80142f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801433:	48 01 d0             	add    %rdx,%rax
  801436:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80143a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801441:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801446:	74 06                	je     80144e <vsnprintf+0x65>
  801448:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80144c:	7f 07                	jg     801455 <vsnprintf+0x6c>
		return -E_INVAL;
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb 2f                	jmp    801484 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801455:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801459:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80145d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801461:	48 89 c6             	mov    %rax,%rsi
  801464:	48 bf 9c 13 80 00 00 	movabs $0x80139c,%rdi
  80146b:	00 00 00 
  80146e:	48 b8 de 0b 80 00 00 	movabs $0x800bde,%rax
  801475:	00 00 00 
  801478:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80147a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80147e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801481:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801484:	c9                   	leaveq 
  801485:	c3                   	retq   

0000000000801486 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801486:	55                   	push   %rbp
  801487:	48 89 e5             	mov    %rsp,%rbp
  80148a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801491:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801498:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80149e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8014a5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8014ac:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 20                	je     8014d7 <snprintf+0x51>
  8014b7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8014bb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8014bf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8014c3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8014c7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014cb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014cf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014d3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014d7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8014de:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8014e5:	00 00 00 
  8014e8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014ef:	00 00 00 
  8014f2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014fd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801504:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80150b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801512:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801519:	48 8b 0a             	mov    (%rdx),%rcx
  80151c:	48 89 08             	mov    %rcx,(%rax)
  80151f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801523:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801527:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80152b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80152f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801536:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80153d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801543:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80154a:	48 89 c7             	mov    %rax,%rdi
  80154d:	48 b8 e9 13 80 00 00 	movabs $0x8013e9,%rax
  801554:	00 00 00 
  801557:	ff d0                	callq  *%rax
  801559:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80155f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801565:	c9                   	leaveq 
  801566:	c3                   	retq   

0000000000801567 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801567:	55                   	push   %rbp
  801568:	48 89 e5             	mov    %rsp,%rbp
  80156b:	48 83 ec 18          	sub    $0x18,%rsp
  80156f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80157a:	eb 09                	jmp    801585 <strlen+0x1e>
		n++;
  80157c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801589:	0f b6 00             	movzbl (%rax),%eax
  80158c:	84 c0                	test   %al,%al
  80158e:	75 ec                	jne    80157c <strlen+0x15>
		n++;
	return n;
  801590:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801593:	c9                   	leaveq 
  801594:	c3                   	retq   

0000000000801595 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801595:	55                   	push   %rbp
  801596:	48 89 e5             	mov    %rsp,%rbp
  801599:	48 83 ec 20          	sub    $0x20,%rsp
  80159d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8015ac:	eb 0e                	jmp    8015bc <strnlen+0x27>
		n++;
  8015ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8015bc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8015c1:	74 0b                	je     8015ce <strnlen+0x39>
  8015c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e0                	jne    8015ae <strnlen+0x19>
		n++;
	return n;
  8015ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8015d1:	c9                   	leaveq 
  8015d2:	c3                   	retq   

00000000008015d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015d3:	55                   	push   %rbp
  8015d4:	48 89 e5             	mov    %rsp,%rbp
  8015d7:	48 83 ec 20          	sub    $0x20,%rsp
  8015db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8015e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8015eb:	90                   	nop
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015fc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801600:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801604:	0f b6 12             	movzbl (%rdx),%edx
  801607:	88 10                	mov    %dl,(%rax)
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	84 c0                	test   %al,%al
  80160e:	75 dc                	jne    8015ec <strcpy+0x19>
		/* do nothing */;
	return ret;
  801610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 20          	sub    $0x20,%rsp
  80161e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801622:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80162a:	48 89 c7             	mov    %rax,%rdi
  80162d:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  801634:	00 00 00 
  801637:	ff d0                	callq  *%rax
  801639:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80163c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80163f:	48 63 d0             	movslq %eax,%rdx
  801642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801646:	48 01 c2             	add    %rax,%rdx
  801649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80164d:	48 89 c6             	mov    %rax,%rsi
  801650:	48 89 d7             	mov    %rdx,%rdi
  801653:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  80165a:	00 00 00 
  80165d:	ff d0                	callq  *%rax
	return dst;
  80165f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801663:	c9                   	leaveq 
  801664:	c3                   	retq   

0000000000801665 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801665:	55                   	push   %rbp
  801666:	48 89 e5             	mov    %rsp,%rbp
  801669:	48 83 ec 28          	sub    $0x28,%rsp
  80166d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801671:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801675:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801681:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801688:	00 
  801689:	eb 2a                	jmp    8016b5 <strncpy+0x50>
		*dst++ = *src;
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801693:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801697:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80169b:	0f b6 12             	movzbl (%rdx),%edx
  80169e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8016a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	84 c0                	test   %al,%al
  8016a9:	74 05                	je     8016b0 <strncpy+0x4b>
			src++;
  8016ab:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8016bd:	72 cc                	jb     80168b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8016bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 28          	sub    $0x28,%rsp
  8016cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8016d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8016e1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016e6:	74 3d                	je     801725 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8016e8:	eb 1d                	jmp    801707 <strlcpy+0x42>
			*dst++ = *src++;
  8016ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016fa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016fe:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801702:	0f b6 12             	movzbl (%rdx),%edx
  801705:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801707:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80170c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801711:	74 0b                	je     80171e <strlcpy+0x59>
  801713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	84 c0                	test   %al,%al
  80171c:	75 cc                	jne    8016ea <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80172d:	48 29 c2             	sub    %rax,%rdx
  801730:	48 89 d0             	mov    %rdx,%rax
}
  801733:	c9                   	leaveq 
  801734:	c3                   	retq   

0000000000801735 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801735:	55                   	push   %rbp
  801736:	48 89 e5             	mov    %rsp,%rbp
  801739:	48 83 ec 10          	sub    $0x10,%rsp
  80173d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801741:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801745:	eb 0a                	jmp    801751 <strcmp+0x1c>
		p++, q++;
  801747:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80174c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801755:	0f b6 00             	movzbl (%rax),%eax
  801758:	84 c0                	test   %al,%al
  80175a:	74 12                	je     80176e <strcmp+0x39>
  80175c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801760:	0f b6 10             	movzbl (%rax),%edx
  801763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	38 c2                	cmp    %al,%dl
  80176c:	74 d9                	je     801747 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80176e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	0f b6 d0             	movzbl %al,%edx
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177c:	0f b6 00             	movzbl (%rax),%eax
  80177f:	0f b6 c0             	movzbl %al,%eax
  801782:	29 c2                	sub    %eax,%edx
  801784:	89 d0                	mov    %edx,%eax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	48 83 ec 18          	sub    $0x18,%rsp
  801790:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801794:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801798:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80179c:	eb 0f                	jmp    8017ad <strncmp+0x25>
		n--, p++, q++;
  80179e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8017a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8017ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017b2:	74 1d                	je     8017d1 <strncmp+0x49>
  8017b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b8:	0f b6 00             	movzbl (%rax),%eax
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 12                	je     8017d1 <strncmp+0x49>
  8017bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c3:	0f b6 10             	movzbl (%rax),%edx
  8017c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	38 c2                	cmp    %al,%dl
  8017cf:	74 cd                	je     80179e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8017d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017d6:	75 07                	jne    8017df <strncmp+0x57>
		return 0;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	eb 18                	jmp    8017f7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	0f b6 d0             	movzbl %al,%edx
  8017e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	0f b6 c0             	movzbl %al,%eax
  8017f3:	29 c2                	sub    %eax,%edx
  8017f5:	89 d0                	mov    %edx,%eax
}
  8017f7:	c9                   	leaveq 
  8017f8:	c3                   	retq   

00000000008017f9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f9:	55                   	push   %rbp
  8017fa:	48 89 e5             	mov    %rsp,%rbp
  8017fd:	48 83 ec 0c          	sub    $0xc,%rsp
  801801:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801805:	89 f0                	mov    %esi,%eax
  801807:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80180a:	eb 17                	jmp    801823 <strchr+0x2a>
		if (*s == c)
  80180c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801810:	0f b6 00             	movzbl (%rax),%eax
  801813:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801816:	75 06                	jne    80181e <strchr+0x25>
			return (char *) s;
  801818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181c:	eb 15                	jmp    801833 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80181e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801827:	0f b6 00             	movzbl (%rax),%eax
  80182a:	84 c0                	test   %al,%al
  80182c:	75 de                	jne    80180c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801833:	c9                   	leaveq 
  801834:	c3                   	retq   

0000000000801835 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801835:	55                   	push   %rbp
  801836:	48 89 e5             	mov    %rsp,%rbp
  801839:	48 83 ec 0c          	sub    $0xc,%rsp
  80183d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801841:	89 f0                	mov    %esi,%eax
  801843:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801846:	eb 13                	jmp    80185b <strfind+0x26>
		if (*s == c)
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801852:	75 02                	jne    801856 <strfind+0x21>
			break;
  801854:	eb 10                	jmp    801866 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801856:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	84 c0                	test   %al,%al
  801864:	75 e2                	jne    801848 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80186a:	c9                   	leaveq 
  80186b:	c3                   	retq   

000000000080186c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80186c:	55                   	push   %rbp
  80186d:	48 89 e5             	mov    %rsp,%rbp
  801870:	48 83 ec 18          	sub    $0x18,%rsp
  801874:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801878:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80187b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80187f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801884:	75 06                	jne    80188c <memset+0x20>
		return v;
  801886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188a:	eb 69                	jmp    8018f5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80188c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801890:	83 e0 03             	and    $0x3,%eax
  801893:	48 85 c0             	test   %rax,%rax
  801896:	75 48                	jne    8018e0 <memset+0x74>
  801898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189c:	83 e0 03             	and    $0x3,%eax
  80189f:	48 85 c0             	test   %rax,%rax
  8018a2:	75 3c                	jne    8018e0 <memset+0x74>
		c &= 0xFF;
  8018a4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8018ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018ae:	c1 e0 18             	shl    $0x18,%eax
  8018b1:	89 c2                	mov    %eax,%edx
  8018b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018b6:	c1 e0 10             	shl    $0x10,%eax
  8018b9:	09 c2                	or     %eax,%edx
  8018bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018be:	c1 e0 08             	shl    $0x8,%eax
  8018c1:	09 d0                	or     %edx,%eax
  8018c3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8018c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ca:	48 c1 e8 02          	shr    $0x2,%rax
  8018ce:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8018d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018d8:	48 89 d7             	mov    %rdx,%rdi
  8018db:	fc                   	cld    
  8018dc:	f3 ab                	rep stos %eax,%es:(%rdi)
  8018de:	eb 11                	jmp    8018f1 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8018e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018e7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018eb:	48 89 d7             	mov    %rdx,%rdi
  8018ee:	fc                   	cld    
  8018ef:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8018f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018f5:	c9                   	leaveq 
  8018f6:	c3                   	retq   

00000000008018f7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
  8018fb:	48 83 ec 28          	sub    $0x28,%rsp
  8018ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801903:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801907:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80190b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80190f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801917:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80191b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801923:	0f 83 88 00 00 00    	jae    8019b1 <memmove+0xba>
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801931:	48 01 d0             	add    %rdx,%rax
  801934:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801938:	76 77                	jbe    8019b1 <memmove+0xba>
		s += n;
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801942:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801946:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80194a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194e:	83 e0 03             	and    $0x3,%eax
  801951:	48 85 c0             	test   %rax,%rax
  801954:	75 3b                	jne    801991 <memmove+0x9a>
  801956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195a:	83 e0 03             	and    $0x3,%eax
  80195d:	48 85 c0             	test   %rax,%rax
  801960:	75 2f                	jne    801991 <memmove+0x9a>
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	83 e0 03             	and    $0x3,%eax
  801969:	48 85 c0             	test   %rax,%rax
  80196c:	75 23                	jne    801991 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80196e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801972:	48 83 e8 04          	sub    $0x4,%rax
  801976:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80197a:	48 83 ea 04          	sub    $0x4,%rdx
  80197e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801982:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801986:	48 89 c7             	mov    %rax,%rdi
  801989:	48 89 d6             	mov    %rdx,%rsi
  80198c:	fd                   	std    
  80198d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80198f:	eb 1d                	jmp    8019ae <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801995:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801999:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80199d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8019a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a5:	48 89 d7             	mov    %rdx,%rdi
  8019a8:	48 89 c1             	mov    %rax,%rcx
  8019ab:	fd                   	std    
  8019ac:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019ae:	fc                   	cld    
  8019af:	eb 57                	jmp    801a08 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8019b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b5:	83 e0 03             	and    $0x3,%eax
  8019b8:	48 85 c0             	test   %rax,%rax
  8019bb:	75 36                	jne    8019f3 <memmove+0xfc>
  8019bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c1:	83 e0 03             	and    $0x3,%eax
  8019c4:	48 85 c0             	test   %rax,%rax
  8019c7:	75 2a                	jne    8019f3 <memmove+0xfc>
  8019c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cd:	83 e0 03             	and    $0x3,%eax
  8019d0:	48 85 c0             	test   %rax,%rax
  8019d3:	75 1e                	jne    8019f3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d9:	48 c1 e8 02          	shr    $0x2,%rax
  8019dd:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8019e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e8:	48 89 c7             	mov    %rax,%rdi
  8019eb:	48 89 d6             	mov    %rdx,%rsi
  8019ee:	fc                   	cld    
  8019ef:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8019f1:	eb 15                	jmp    801a08 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019fb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8019ff:	48 89 c7             	mov    %rax,%rdi
  801a02:	48 89 d6             	mov    %rdx,%rsi
  801a05:	fc                   	cld    
  801a06:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a0c:	c9                   	leaveq 
  801a0d:	c3                   	retq   

0000000000801a0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a0e:	55                   	push   %rbp
  801a0f:	48 89 e5             	mov    %rsp,%rbp
  801a12:	48 83 ec 18          	sub    $0x18,%rsp
  801a16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a1e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a26:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801a2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a2e:	48 89 ce             	mov    %rcx,%rsi
  801a31:	48 89 c7             	mov    %rax,%rdi
  801a34:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
}
  801a40:	c9                   	leaveq 
  801a41:	c3                   	retq   

0000000000801a42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	48 83 ec 28          	sub    $0x28,%rsp
  801a4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801a5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801a66:	eb 36                	jmp    801a9e <memcmp+0x5c>
		if (*s1 != *s2)
  801a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6c:	0f b6 10             	movzbl (%rax),%edx
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	0f b6 00             	movzbl (%rax),%eax
  801a76:	38 c2                	cmp    %al,%dl
  801a78:	74 1a                	je     801a94 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7e:	0f b6 00             	movzbl (%rax),%eax
  801a81:	0f b6 d0             	movzbl %al,%edx
  801a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	0f b6 c0             	movzbl %al,%eax
  801a8e:	29 c2                	sub    %eax,%edx
  801a90:	89 d0                	mov    %edx,%eax
  801a92:	eb 20                	jmp    801ab4 <memcmp+0x72>
		s1++, s2++;
  801a94:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a99:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801aa6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801aaa:	48 85 c0             	test   %rax,%rax
  801aad:	75 b9                	jne    801a68 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab4:	c9                   	leaveq 
  801ab5:	c3                   	retq   

0000000000801ab6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ab6:	55                   	push   %rbp
  801ab7:	48 89 e5             	mov    %rsp,%rbp
  801aba:	48 83 ec 28          	sub    $0x28,%rsp
  801abe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ac2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801ac5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801ac9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801acd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ad1:	48 01 d0             	add    %rdx,%rax
  801ad4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801ad8:	eb 15                	jmp    801aef <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ade:	0f b6 10             	movzbl (%rax),%edx
  801ae1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ae4:	38 c2                	cmp    %al,%dl
  801ae6:	75 02                	jne    801aea <memfind+0x34>
			break;
  801ae8:	eb 0f                	jmp    801af9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801aea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801af3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801af7:	72 e1                	jb     801ada <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 34          	sub    $0x34,%rsp
  801b07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801b0f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801b12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801b19:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801b20:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b21:	eb 05                	jmp    801b28 <strtol+0x29>
		s++;
  801b23:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2c:	0f b6 00             	movzbl (%rax),%eax
  801b2f:	3c 20                	cmp    $0x20,%al
  801b31:	74 f0                	je     801b23 <strtol+0x24>
  801b33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b37:	0f b6 00             	movzbl (%rax),%eax
  801b3a:	3c 09                	cmp    $0x9,%al
  801b3c:	74 e5                	je     801b23 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b42:	0f b6 00             	movzbl (%rax),%eax
  801b45:	3c 2b                	cmp    $0x2b,%al
  801b47:	75 07                	jne    801b50 <strtol+0x51>
		s++;
  801b49:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b4e:	eb 17                	jmp    801b67 <strtol+0x68>
	else if (*s == '-')
  801b50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b54:	0f b6 00             	movzbl (%rax),%eax
  801b57:	3c 2d                	cmp    $0x2d,%al
  801b59:	75 0c                	jne    801b67 <strtol+0x68>
		s++, neg = 1;
  801b5b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b60:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b67:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b6b:	74 06                	je     801b73 <strtol+0x74>
  801b6d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801b71:	75 28                	jne    801b9b <strtol+0x9c>
  801b73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b77:	0f b6 00             	movzbl (%rax),%eax
  801b7a:	3c 30                	cmp    $0x30,%al
  801b7c:	75 1d                	jne    801b9b <strtol+0x9c>
  801b7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b82:	48 83 c0 01          	add    $0x1,%rax
  801b86:	0f b6 00             	movzbl (%rax),%eax
  801b89:	3c 78                	cmp    $0x78,%al
  801b8b:	75 0e                	jne    801b9b <strtol+0x9c>
		s += 2, base = 16;
  801b8d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801b92:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801b99:	eb 2c                	jmp    801bc7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801b9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801b9f:	75 19                	jne    801bba <strtol+0xbb>
  801ba1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba5:	0f b6 00             	movzbl (%rax),%eax
  801ba8:	3c 30                	cmp    $0x30,%al
  801baa:	75 0e                	jne    801bba <strtol+0xbb>
		s++, base = 8;
  801bac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801bb1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801bb8:	eb 0d                	jmp    801bc7 <strtol+0xc8>
	else if (base == 0)
  801bba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801bbe:	75 07                	jne    801bc7 <strtol+0xc8>
		base = 10;
  801bc0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcb:	0f b6 00             	movzbl (%rax),%eax
  801bce:	3c 2f                	cmp    $0x2f,%al
  801bd0:	7e 1d                	jle    801bef <strtol+0xf0>
  801bd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd6:	0f b6 00             	movzbl (%rax),%eax
  801bd9:	3c 39                	cmp    $0x39,%al
  801bdb:	7f 12                	jg     801bef <strtol+0xf0>
			dig = *s - '0';
  801bdd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be1:	0f b6 00             	movzbl (%rax),%eax
  801be4:	0f be c0             	movsbl %al,%eax
  801be7:	83 e8 30             	sub    $0x30,%eax
  801bea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801bed:	eb 4e                	jmp    801c3d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801bef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf3:	0f b6 00             	movzbl (%rax),%eax
  801bf6:	3c 60                	cmp    $0x60,%al
  801bf8:	7e 1d                	jle    801c17 <strtol+0x118>
  801bfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfe:	0f b6 00             	movzbl (%rax),%eax
  801c01:	3c 7a                	cmp    $0x7a,%al
  801c03:	7f 12                	jg     801c17 <strtol+0x118>
			dig = *s - 'a' + 10;
  801c05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c09:	0f b6 00             	movzbl (%rax),%eax
  801c0c:	0f be c0             	movsbl %al,%eax
  801c0f:	83 e8 57             	sub    $0x57,%eax
  801c12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c15:	eb 26                	jmp    801c3d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c1b:	0f b6 00             	movzbl (%rax),%eax
  801c1e:	3c 40                	cmp    $0x40,%al
  801c20:	7e 48                	jle    801c6a <strtol+0x16b>
  801c22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c26:	0f b6 00             	movzbl (%rax),%eax
  801c29:	3c 5a                	cmp    $0x5a,%al
  801c2b:	7f 3d                	jg     801c6a <strtol+0x16b>
			dig = *s - 'A' + 10;
  801c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c31:	0f b6 00             	movzbl (%rax),%eax
  801c34:	0f be c0             	movsbl %al,%eax
  801c37:	83 e8 37             	sub    $0x37,%eax
  801c3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801c3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c40:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801c43:	7c 02                	jl     801c47 <strtol+0x148>
			break;
  801c45:	eb 23                	jmp    801c6a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801c47:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c4c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801c4f:	48 98                	cltq   
  801c51:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801c56:	48 89 c2             	mov    %rax,%rdx
  801c59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c5c:	48 98                	cltq   
  801c5e:	48 01 d0             	add    %rdx,%rax
  801c61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801c65:	e9 5d ff ff ff       	jmpq   801bc7 <strtol+0xc8>

	if (endptr)
  801c6a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801c6f:	74 0b                	je     801c7c <strtol+0x17d>
		*endptr = (char *) s;
  801c71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c75:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c79:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801c7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c80:	74 09                	je     801c8b <strtol+0x18c>
  801c82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c86:	48 f7 d8             	neg    %rax
  801c89:	eb 04                	jmp    801c8f <strtol+0x190>
  801c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c8f:	c9                   	leaveq 
  801c90:	c3                   	retq   

0000000000801c91 <strstr>:

char * strstr(const char *in, const char *str)
{
  801c91:	55                   	push   %rbp
  801c92:	48 89 e5             	mov    %rsp,%rbp
  801c95:	48 83 ec 30          	sub    $0x30,%rsp
  801c99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801ca1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ca5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ca9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801cad:	0f b6 00             	movzbl (%rax),%eax
  801cb0:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801cb3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801cb7:	75 06                	jne    801cbf <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801cb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbd:	eb 6b                	jmp    801d2a <strstr+0x99>

    len = strlen(str);
  801cbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cc3:	48 89 c7             	mov    %rax,%rdi
  801cc6:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
  801cd2:	48 98                	cltq   
  801cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ce0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ce4:	0f b6 00             	movzbl (%rax),%eax
  801ce7:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801cea:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801cee:	75 07                	jne    801cf7 <strstr+0x66>
                return (char *) 0;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	eb 33                	jmp    801d2a <strstr+0x99>
        } while (sc != c);
  801cf7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801cfb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801cfe:	75 d8                	jne    801cd8 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801d00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d04:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0c:	48 89 ce             	mov    %rcx,%rsi
  801d0f:	48 89 c7             	mov    %rax,%rdi
  801d12:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	75 b6                	jne    801cd8 <strstr+0x47>

    return (char *) (in - 1);
  801d22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d26:	48 83 e8 01          	sub    $0x1,%rax
}
  801d2a:	c9                   	leaveq 
  801d2b:	c3                   	retq   

0000000000801d2c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801d2c:	55                   	push   %rbp
  801d2d:	48 89 e5             	mov    %rsp,%rbp
  801d30:	53                   	push   %rbx
  801d31:	48 83 ec 48          	sub    $0x48,%rsp
  801d35:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d38:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801d3b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d3f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801d43:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801d47:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d4e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801d52:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801d56:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801d5a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801d5e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801d62:	4c 89 c3             	mov    %r8,%rbx
  801d65:	cd 30                	int    $0x30
  801d67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801d6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d6f:	74 3e                	je     801daf <syscall+0x83>
  801d71:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d76:	7e 37                	jle    801daf <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801d78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d7f:	49 89 d0             	mov    %rdx,%r8
  801d82:	89 c1                	mov    %eax,%ecx
  801d84:	48 ba a0 46 80 00 00 	movabs $0x8046a0,%rdx
  801d8b:	00 00 00 
  801d8e:	be 23 00 00 00       	mov    $0x23,%esi
  801d93:	48 bf bd 46 80 00 00 	movabs $0x8046bd,%rdi
  801d9a:	00 00 00 
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	49 b9 f2 05 80 00 00 	movabs $0x8005f2,%r9
  801da9:	00 00 00 
  801dac:	41 ff d1             	callq  *%r9

	return ret;
  801daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801db3:	48 83 c4 48          	add    $0x48,%rsp
  801db7:	5b                   	pop    %rbx
  801db8:	5d                   	pop    %rbp
  801db9:	c3                   	retq   

0000000000801dba <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 20          	sub    $0x20,%rsp
  801dc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd9:	00 
  801dda:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801de6:	48 89 d1             	mov    %rdx,%rcx
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	be 00 00 00 00       	mov    $0x0,%esi
  801df1:	bf 00 00 00 00       	mov    $0x0,%edi
  801df6:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
}
  801e02:	c9                   	leaveq 
  801e03:	c3                   	retq   

0000000000801e04 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e04:	55                   	push   %rbp
  801e05:	48 89 e5             	mov    %rsp,%rbp
  801e08:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801e0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e13:	00 
  801e14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e25:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2a:	be 00 00 00 00       	mov    $0x0,%esi
  801e2f:	bf 01 00 00 00       	mov    $0x1,%edi
  801e34:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
}
  801e40:	c9                   	leaveq 
  801e41:	c3                   	retq   

0000000000801e42 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	48 83 ec 10          	sub    $0x10,%rsp
  801e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801e4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e50:	48 98                	cltq   
  801e52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e59:	00 
  801e5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e6b:	48 89 c2             	mov    %rax,%rdx
  801e6e:	be 01 00 00 00       	mov    $0x1,%esi
  801e73:	bf 03 00 00 00       	mov    $0x3,%edi
  801e78:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801e7f:	00 00 00 
  801e82:	ff d0                	callq  *%rax
}
  801e84:	c9                   	leaveq 
  801e85:	c3                   	retq   

0000000000801e86 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801e86:	55                   	push   %rbp
  801e87:	48 89 e5             	mov    %rsp,%rbp
  801e8a:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801e8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e95:	00 
  801e96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eac:	be 00 00 00 00       	mov    $0x0,%esi
  801eb1:	bf 02 00 00 00       	mov    $0x2,%edi
  801eb6:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
}
  801ec2:	c9                   	leaveq 
  801ec3:	c3                   	retq   

0000000000801ec4 <sys_yield>:

void
sys_yield(void)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ecc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ed3:	00 
  801ed4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eea:	be 00 00 00 00       	mov    $0x0,%esi
  801eef:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ef4:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801efb:	00 00 00 
  801efe:	ff d0                	callq  *%rax
}
  801f00:	c9                   	leaveq 
  801f01:	c3                   	retq   

0000000000801f02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801f02:	55                   	push   %rbp
  801f03:	48 89 e5             	mov    %rsp,%rbp
  801f06:	48 83 ec 20          	sub    $0x20,%rsp
  801f0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f11:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801f14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f17:	48 63 c8             	movslq %eax,%rcx
  801f1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f21:	48 98                	cltq   
  801f23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2a:	00 
  801f2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f31:	49 89 c8             	mov    %rcx,%r8
  801f34:	48 89 d1             	mov    %rdx,%rcx
  801f37:	48 89 c2             	mov    %rax,%rdx
  801f3a:	be 01 00 00 00       	mov    $0x1,%esi
  801f3f:	bf 04 00 00 00       	mov    $0x4,%edi
  801f44:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
}
  801f50:	c9                   	leaveq 
  801f51:	c3                   	retq   

0000000000801f52 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801f52:	55                   	push   %rbp
  801f53:	48 89 e5             	mov    %rsp,%rbp
  801f56:	48 83 ec 30          	sub    $0x30,%rsp
  801f5a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f61:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f64:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f68:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801f6c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f6f:	48 63 c8             	movslq %eax,%rcx
  801f72:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f79:	48 63 f0             	movslq %eax,%rsi
  801f7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f83:	48 98                	cltq   
  801f85:	48 89 0c 24          	mov    %rcx,(%rsp)
  801f89:	49 89 f9             	mov    %rdi,%r9
  801f8c:	49 89 f0             	mov    %rsi,%r8
  801f8f:	48 89 d1             	mov    %rdx,%rcx
  801f92:	48 89 c2             	mov    %rax,%rdx
  801f95:	be 01 00 00 00       	mov    $0x1,%esi
  801f9a:	bf 05 00 00 00       	mov    $0x5,%edi
  801f9f:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801fa6:	00 00 00 
  801fa9:	ff d0                	callq  *%rax
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	48 83 ec 20          	sub    $0x20,%rsp
  801fb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801fbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	48 98                	cltq   
  801fc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fcc:	00 
  801fcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd9:	48 89 d1             	mov    %rdx,%rcx
  801fdc:	48 89 c2             	mov    %rax,%rdx
  801fdf:	be 01 00 00 00       	mov    $0x1,%esi
  801fe4:	bf 06 00 00 00       	mov    $0x6,%edi
  801fe9:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
}
  801ff5:	c9                   	leaveq 
  801ff6:	c3                   	retq   

0000000000801ff7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ff7:	55                   	push   %rbp
  801ff8:	48 89 e5             	mov    %rsp,%rbp
  801ffb:	48 83 ec 10          	sub    $0x10,%rsp
  801fff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802002:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802005:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802008:	48 63 d0             	movslq %eax,%rdx
  80200b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200e:	48 98                	cltq   
  802010:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802017:	00 
  802018:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80201e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802024:	48 89 d1             	mov    %rdx,%rcx
  802027:	48 89 c2             	mov    %rax,%rdx
  80202a:	be 01 00 00 00       	mov    $0x1,%esi
  80202f:	bf 08 00 00 00       	mov    $0x8,%edi
  802034:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	callq  *%rax
}
  802040:	c9                   	leaveq 
  802041:	c3                   	retq   

0000000000802042 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802042:	55                   	push   %rbp
  802043:	48 89 e5             	mov    %rsp,%rbp
  802046:	48 83 ec 20          	sub    $0x20,%rsp
  80204a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80204d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802051:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802058:	48 98                	cltq   
  80205a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802061:	00 
  802062:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802068:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206e:	48 89 d1             	mov    %rdx,%rcx
  802071:	48 89 c2             	mov    %rax,%rdx
  802074:	be 01 00 00 00       	mov    $0x1,%esi
  802079:	bf 09 00 00 00       	mov    $0x9,%edi
  80207e:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 20          	sub    $0x20,%rsp
  802094:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802097:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80209b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80209f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a2:	48 98                	cltq   
  8020a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020ab:	00 
  8020ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020b8:	48 89 d1             	mov    %rdx,%rcx
  8020bb:	48 89 c2             	mov    %rax,%rdx
  8020be:	be 01 00 00 00       	mov    $0x1,%esi
  8020c3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020c8:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	callq  *%rax
}
  8020d4:	c9                   	leaveq 
  8020d5:	c3                   	retq   

00000000008020d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8020d6:	55                   	push   %rbp
  8020d7:	48 89 e5             	mov    %rsp,%rbp
  8020da:	48 83 ec 20          	sub    $0x20,%rsp
  8020de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8020e9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8020ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ef:	48 63 f0             	movslq %eax,%rsi
  8020f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f9:	48 98                	cltq   
  8020fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802106:	00 
  802107:	49 89 f1             	mov    %rsi,%r9
  80210a:	49 89 c8             	mov    %rcx,%r8
  80210d:	48 89 d1             	mov    %rdx,%rcx
  802110:	48 89 c2             	mov    %rax,%rdx
  802113:	be 00 00 00 00       	mov    $0x0,%esi
  802118:	bf 0c 00 00 00       	mov    $0xc,%edi
  80211d:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 10          	sub    $0x10,%rsp
  802133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802142:	00 
  802143:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802149:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80214f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802154:	48 89 c2             	mov    %rax,%rdx
  802157:	be 01 00 00 00       	mov    $0x1,%esi
  80215c:	bf 0d 00 00 00       	mov    $0xd,%edi
  802161:	48 b8 2c 1d 80 00 00 	movabs $0x801d2c,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 30          	sub    $0x30,%rsp
  802177:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80217b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217f:	48 8b 00             	mov    (%rax),%rax
  802182:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802186:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80218e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  802191:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802194:	83 e0 02             	and    $0x2,%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	74 23                	je     8021be <pgfault+0x4f>
  80219b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219f:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a3:	48 89 c2             	mov    %rax,%rdx
  8021a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ad:	01 00 00 
  8021b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b4:	25 00 08 00 00       	and    $0x800,%eax
  8021b9:	48 85 c0             	test   %rax,%rax
  8021bc:	75 2a                	jne    8021e8 <pgfault+0x79>
		panic("fail check at fork pgfault");
  8021be:	48 ba cb 46 80 00 00 	movabs $0x8046cb,%rdx
  8021c5:	00 00 00 
  8021c8:	be 1d 00 00 00       	mov    $0x1d,%esi
  8021cd:	48 bf e6 46 80 00 00 	movabs $0x8046e6,%rdi
  8021d4:	00 00 00 
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dc:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  8021e3:	00 00 00 
  8021e6:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8021e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8021ed:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f7:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  802203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802207:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80220b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802215:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80221d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802222:	48 89 c6             	mov    %rax,%rsi
  802225:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80222a:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  802236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802240:	48 89 c1             	mov    %rax,%rcx
  802243:	ba 00 00 00 00       	mov    $0x0,%edx
  802248:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80224d:	bf 00 00 00 00       	mov    $0x0,%edi
  802252:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  802259:	00 00 00 
  80225c:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  80225e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802263:	bf 00 00 00 00       	mov    $0x0,%edi
  802268:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  80226f:	00 00 00 
  802272:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  802274:	c9                   	leaveq 
  802275:	c3                   	retq   

0000000000802276 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802276:	55                   	push   %rbp
  802277:	48 89 e5             	mov    %rsp,%rbp
  80227a:	48 83 ec 20          	sub    $0x20,%rsp
  80227e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802281:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  802284:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802287:	48 c1 e0 0c          	shl    $0xc,%rax
  80228b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  80228f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802296:	01 00 00 
  802299:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80229c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a0:	25 00 04 00 00       	and    $0x400,%eax
  8022a5:	48 85 c0             	test   %rax,%rax
  8022a8:	74 55                	je     8022ff <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  8022aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b1:	01 00 00 
  8022b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8022c0:	89 c6                	mov    %eax,%esi
  8022c2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8022c6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cd:	41 89 f0             	mov    %esi,%r8d
  8022d0:	48 89 c6             	mov    %rax,%rsi
  8022d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d8:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax
  8022e4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8022e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022eb:	79 08                	jns    8022f5 <duppage+0x7f>
			return r;
  8022ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f0:	e9 e1 00 00 00       	jmpq   8023d6 <duppage+0x160>
		return 0;
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	e9 d7 00 00 00       	jmpq   8023d6 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8022ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802306:	01 00 00 
  802309:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80230c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802310:	25 05 06 00 00       	and    $0x605,%eax
  802315:	80 cc 08             	or     $0x8,%ah
  802318:	89 c6                	mov    %eax,%esi
  80231a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80231e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802325:	41 89 f0             	mov    %esi,%r8d
  802328:	48 89 c6             	mov    %rax,%rsi
  80232b:	bf 00 00 00 00       	mov    $0x0,%edi
  802330:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  802337:	00 00 00 
  80233a:	ff d0                	callq  *%rax
  80233c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80233f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802343:	79 08                	jns    80234d <duppage+0xd7>
		return r;
  802345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802348:	e9 89 00 00 00       	jmpq   8023d6 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  80234d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802354:	01 00 00 
  802357:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80235a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235e:	83 e0 02             	and    $0x2,%eax
  802361:	48 85 c0             	test   %rax,%rax
  802364:	75 1b                	jne    802381 <duppage+0x10b>
  802366:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80236d:	01 00 00 
  802370:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802373:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802377:	25 00 08 00 00       	and    $0x800,%eax
  80237c:	48 85 c0             	test   %rax,%rax
  80237f:	74 50                	je     8023d1 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  802381:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802388:	01 00 00 
  80238b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80238e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802392:	25 05 06 00 00       	and    $0x605,%eax
  802397:	80 cc 08             	or     $0x8,%ah
  80239a:	89 c1                	mov    %eax,%ecx
  80239c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a4:	41 89 c8             	mov    %ecx,%r8d
  8023a7:	48 89 d1             	mov    %rdx,%rcx
  8023aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8023af:	48 89 c6             	mov    %rax,%rsi
  8023b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b7:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	callq  *%rax
  8023c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8023ca:	79 05                	jns    8023d1 <duppage+0x15b>
			return r;
  8023cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023cf:	eb 05                	jmp    8023d6 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d6:	c9                   	leaveq 
  8023d7:	c3                   	retq   

00000000008023d8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023d8:	55                   	push   %rbp
  8023d9:	48 89 e5             	mov    %rsp,%rbp
  8023dc:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  8023e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  8023e7:	48 bf 6f 21 80 00 00 	movabs $0x80216f,%rdi
  8023ee:	00 00 00 
  8023f1:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8023fd:	b8 07 00 00 00       	mov    $0x7,%eax
  802402:	cd 30                	int    $0x30
  802404:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802407:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  80240a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80240d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802411:	79 08                	jns    80241b <fork+0x43>
		return envid;
  802413:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802416:	e9 27 02 00 00       	jmpq   802642 <fork+0x26a>
	else if (envid == 0) {
  80241b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80241f:	75 46                	jne    802467 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802421:	48 b8 86 1e 80 00 00 	movabs $0x801e86,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
  80242d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802432:	48 63 d0             	movslq %eax,%rdx
  802435:	48 89 d0             	mov    %rdx,%rax
  802438:	48 c1 e0 03          	shl    $0x3,%rax
  80243c:	48 01 d0             	add    %rdx,%rax
  80243f:	48 c1 e0 05          	shl    $0x5,%rax
  802443:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80244a:	00 00 00 
  80244d:	48 01 c2             	add    %rax,%rdx
  802450:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802457:	00 00 00 
  80245a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	e9 db 01 00 00       	jmpq   802642 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802467:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80246a:	ba 07 00 00 00       	mov    $0x7,%edx
  80246f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802485:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802489:	79 08                	jns    802493 <fork+0xbb>
		return r;
  80248b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80248e:	e9 af 01 00 00       	jmpq   802642 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802493:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80249a:	e9 49 01 00 00       	jmpq   8025e8 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80249f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a2:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	0f 48 c2             	cmovs  %edx,%eax
  8024ad:	c1 f8 1b             	sar    $0x1b,%eax
  8024b0:	89 c2                	mov    %eax,%edx
  8024b2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8024b9:	01 00 00 
  8024bc:	48 63 d2             	movslq %edx,%rdx
  8024bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024c3:	83 e0 01             	and    $0x1,%eax
  8024c6:	48 85 c0             	test   %rax,%rax
  8024c9:	75 0c                	jne    8024d7 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8024cb:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  8024d2:	e9 0d 01 00 00       	jmpq   8025e4 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8024d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8024de:	e9 f4 00 00 00       	jmpq   8025d7 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8024e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e6:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	0f 48 c2             	cmovs  %edx,%eax
  8024f1:	c1 f8 12             	sar    $0x12,%eax
  8024f4:	89 c2                	mov    %eax,%edx
  8024f6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024fd:	01 00 00 
  802500:	48 63 d2             	movslq %edx,%rdx
  802503:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802507:	83 e0 01             	and    $0x1,%eax
  80250a:	48 85 c0             	test   %rax,%rax
  80250d:	75 0c                	jne    80251b <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  80250f:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  802516:	e9 b8 00 00 00       	jmpq   8025d3 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80251b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802522:	e9 9f 00 00 00       	jmpq   8025c6 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802527:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80252a:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802530:	85 c0                	test   %eax,%eax
  802532:	0f 48 c2             	cmovs  %edx,%eax
  802535:	c1 f8 09             	sar    $0x9,%eax
  802538:	89 c2                	mov    %eax,%edx
  80253a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802541:	01 00 00 
  802544:	48 63 d2             	movslq %edx,%rdx
  802547:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254b:	83 e0 01             	and    $0x1,%eax
  80254e:	48 85 c0             	test   %rax,%rax
  802551:	75 09                	jne    80255c <fork+0x184>
					ptx += NPTENTRIES;
  802553:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  80255a:	eb 66                	jmp    8025c2 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80255c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802563:	eb 54                	jmp    8025b9 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802565:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80256c:	01 00 00 
  80256f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802572:	48 63 d2             	movslq %edx,%rdx
  802575:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802579:	83 e0 01             	and    $0x1,%eax
  80257c:	48 85 c0             	test   %rax,%rax
  80257f:	74 30                	je     8025b1 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802581:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  802588:	74 27                	je     8025b1 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80258a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80258d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802590:	89 d6                	mov    %edx,%esi
  802592:	89 c7                	mov    %eax,%edi
  802594:	48 b8 76 22 80 00 00 	movabs $0x802276,%rax
  80259b:	00 00 00 
  80259e:	ff d0                	callq  *%rax
  8025a0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8025a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8025a7:	79 08                	jns    8025b1 <fork+0x1d9>
								return r;
  8025a9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8025ac:	e9 91 00 00 00       	jmpq   802642 <fork+0x26a>
					ptx++;
  8025b1:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8025b5:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8025b9:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8025c0:	7e a3                	jle    802565 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8025c2:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8025c6:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8025cd:	0f 8e 54 ff ff ff    	jle    802527 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8025d3:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8025d7:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8025de:	0f 8e ff fe ff ff    	jle    8024e3 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8025e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ec:	0f 84 ad fe ff ff    	je     80249f <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8025f2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8025f5:	48 be 76 3d 80 00 00 	movabs $0x803d76,%rsi
  8025fc:	00 00 00 
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802614:	79 05                	jns    80261b <fork+0x243>
		return r;
  802616:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802619:	eb 27                	jmp    802642 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80261b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80261e:	be 02 00 00 00       	mov    $0x2,%esi
  802623:	89 c7                	mov    %eax,%edi
  802625:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802634:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802638:	79 05                	jns    80263f <fork+0x267>
		return r;
  80263a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80263d:	eb 03                	jmp    802642 <fork+0x26a>

	return envid;
  80263f:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802642:	c9                   	leaveq 
  802643:	c3                   	retq   

0000000000802644 <sfork>:

// Challenge!
int
sfork(void)
{
  802644:	55                   	push   %rbp
  802645:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802648:	48 ba f1 46 80 00 00 	movabs $0x8046f1,%rdx
  80264f:	00 00 00 
  802652:	be a7 00 00 00       	mov    $0xa7,%esi
  802657:	48 bf e6 46 80 00 00 	movabs $0x8046e6,%rdi
  80265e:	00 00 00 
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  80266d:	00 00 00 
  802670:	ff d1                	callq  *%rcx

0000000000802672 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802672:	55                   	push   %rbp
  802673:	48 89 e5             	mov    %rsp,%rbp
  802676:	48 83 ec 08          	sub    $0x8,%rsp
  80267a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80267e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802682:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802689:	ff ff ff 
  80268c:	48 01 d0             	add    %rdx,%rax
  80268f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802693:	c9                   	leaveq 
  802694:	c3                   	retq   

0000000000802695 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 08          	sub    $0x8,%rsp
  80269d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a5:	48 89 c7             	mov    %rax,%rdi
  8026a8:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax
  8026b4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026ba:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 18          	sub    $0x18,%rsp
  8026c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d3:	eb 6b                	jmp    802740 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d8:	48 98                	cltq   
  8026da:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e0:	48 c1 e0 0c          	shl    $0xc,%rax
  8026e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ec:	48 c1 e8 15          	shr    $0x15,%rax
  8026f0:	48 89 c2             	mov    %rax,%rdx
  8026f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026fa:	01 00 00 
  8026fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802701:	83 e0 01             	and    $0x1,%eax
  802704:	48 85 c0             	test   %rax,%rax
  802707:	74 21                	je     80272a <fd_alloc+0x6a>
  802709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80270d:	48 c1 e8 0c          	shr    $0xc,%rax
  802711:	48 89 c2             	mov    %rax,%rdx
  802714:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271b:	01 00 00 
  80271e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802722:	83 e0 01             	and    $0x1,%eax
  802725:	48 85 c0             	test   %rax,%rax
  802728:	75 12                	jne    80273c <fd_alloc+0x7c>
			*fd_store = fd;
  80272a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802732:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	eb 1a                	jmp    802756 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80273c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802740:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802744:	7e 8f                	jle    8026d5 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802751:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802756:	c9                   	leaveq 
  802757:	c3                   	retq   

0000000000802758 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802758:	55                   	push   %rbp
  802759:	48 89 e5             	mov    %rsp,%rbp
  80275c:	48 83 ec 20          	sub    $0x20,%rsp
  802760:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802763:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802767:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80276b:	78 06                	js     802773 <fd_lookup+0x1b>
  80276d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802771:	7e 07                	jle    80277a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802778:	eb 6c                	jmp    8027e6 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80277a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277d:	48 98                	cltq   
  80277f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802785:	48 c1 e0 0c          	shl    $0xc,%rax
  802789:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80278d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802791:	48 c1 e8 15          	shr    $0x15,%rax
  802795:	48 89 c2             	mov    %rax,%rdx
  802798:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80279f:	01 00 00 
  8027a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a6:	83 e0 01             	and    $0x1,%eax
  8027a9:	48 85 c0             	test   %rax,%rax
  8027ac:	74 21                	je     8027cf <fd_lookup+0x77>
  8027ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b2:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b6:	48 89 c2             	mov    %rax,%rdx
  8027b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c0:	01 00 00 
  8027c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c7:	83 e0 01             	and    $0x1,%eax
  8027ca:	48 85 c0             	test   %rax,%rax
  8027cd:	75 07                	jne    8027d6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d4:	eb 10                	jmp    8027e6 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027de:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e6:	c9                   	leaveq 
  8027e7:	c3                   	retq   

00000000008027e8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027e8:	55                   	push   %rbp
  8027e9:	48 89 e5             	mov    %rsp,%rbp
  8027ec:	48 83 ec 30          	sub    $0x30,%rsp
  8027f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027f4:	89 f0                	mov    %esi,%eax
  8027f6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8027f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fd:	48 89 c7             	mov    %rax,%rdi
  802800:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax
  80280c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802810:	48 89 d6             	mov    %rdx,%rsi
  802813:	89 c7                	mov    %eax,%edi
  802815:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
  802821:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802828:	78 0a                	js     802834 <fd_close+0x4c>
	    || fd != fd2)
  80282a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802832:	74 12                	je     802846 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802834:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802838:	74 05                	je     80283f <fd_close+0x57>
  80283a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283d:	eb 05                	jmp    802844 <fd_close+0x5c>
  80283f:	b8 00 00 00 00       	mov    $0x0,%eax
  802844:	eb 69                	jmp    8028af <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284a:	8b 00                	mov    (%rax),%eax
  80284c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802850:	48 89 d6             	mov    %rdx,%rsi
  802853:	89 c7                	mov    %eax,%edi
  802855:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  80285c:	00 00 00 
  80285f:	ff d0                	callq  *%rax
  802861:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802864:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802868:	78 2a                	js     802894 <fd_close+0xac>
		if (dev->dev_close)
  80286a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802872:	48 85 c0             	test   %rax,%rax
  802875:	74 16                	je     80288d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80287f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802883:	48 89 d7             	mov    %rdx,%rdi
  802886:	ff d0                	callq  *%rax
  802888:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288b:	eb 07                	jmp    802894 <fd_close+0xac>
		else
			r = 0;
  80288d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802898:	48 89 c6             	mov    %rax,%rsi
  80289b:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a0:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  8028a7:	00 00 00 
  8028aa:	ff d0                	callq  *%rax
	return r;
  8028ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028af:	c9                   	leaveq 
  8028b0:	c3                   	retq   

00000000008028b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	48 83 ec 20          	sub    $0x20,%rsp
  8028b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028c7:	eb 41                	jmp    80290a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028c9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028d0:	00 00 00 
  8028d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028d6:	48 63 d2             	movslq %edx,%rdx
  8028d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028dd:	8b 00                	mov    (%rax),%eax
  8028df:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028e2:	75 22                	jne    802906 <dev_lookup+0x55>
			*dev = devtab[i];
  8028e4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8028eb:	00 00 00 
  8028ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f1:	48 63 d2             	movslq %edx,%rdx
  8028f4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8028f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	eb 60                	jmp    802966 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802906:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80290a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802911:	00 00 00 
  802914:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802917:	48 63 d2             	movslq %edx,%rdx
  80291a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291e:	48 85 c0             	test   %rax,%rax
  802921:	75 a6                	jne    8028c9 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802923:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80292a:	00 00 00 
  80292d:	48 8b 00             	mov    (%rax),%rax
  802930:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802936:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802939:	89 c6                	mov    %eax,%esi
  80293b:	48 bf 08 47 80 00 00 	movabs $0x804708,%rdi
  802942:	00 00 00 
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802951:	00 00 00 
  802954:	ff d1                	callq  *%rcx
	*dev = 0;
  802956:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802961:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802966:	c9                   	leaveq 
  802967:	c3                   	retq   

0000000000802968 <close>:

int
close(int fdnum)
{
  802968:	55                   	push   %rbp
  802969:	48 89 e5             	mov    %rsp,%rbp
  80296c:	48 83 ec 20          	sub    $0x20,%rsp
  802970:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802973:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802977:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80297a:	48 89 d6             	mov    %rdx,%rsi
  80297d:	89 c7                	mov    %eax,%edi
  80297f:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
  80298b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802992:	79 05                	jns    802999 <close+0x31>
		return r;
  802994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802997:	eb 18                	jmp    8029b1 <close+0x49>
	else
		return fd_close(fd, 1);
  802999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299d:	be 01 00 00 00       	mov    $0x1,%esi
  8029a2:	48 89 c7             	mov    %rax,%rdi
  8029a5:	48 b8 e8 27 80 00 00 	movabs $0x8027e8,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <close_all>:

void
close_all(void)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c2:	eb 15                	jmp    8029d9 <close_all+0x26>
		close(i);
  8029c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029d9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029dd:	7e e5                	jle    8029c4 <close_all+0x11>
		close(i);
}
  8029df:	c9                   	leaveq 
  8029e0:	c3                   	retq   

00000000008029e1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029e1:	55                   	push   %rbp
  8029e2:	48 89 e5             	mov    %rsp,%rbp
  8029e5:	48 83 ec 40          	sub    $0x40,%rsp
  8029e9:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029ec:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029ef:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029f3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029f6:	48 89 d6             	mov    %rdx,%rsi
  8029f9:	89 c7                	mov    %eax,%edi
  8029fb:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
  802a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0e:	79 08                	jns    802a18 <dup+0x37>
		return r;
  802a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a13:	e9 70 01 00 00       	jmpq   802b88 <dup+0x1a7>
	close(newfdnum);
  802a18:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a2c:	48 98                	cltq   
  802a2e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a34:	48 c1 e0 0c          	shl    $0xc,%rax
  802a38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a40:	48 89 c7             	mov    %rax,%rdi
  802a43:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802a4a:	00 00 00 
  802a4d:	ff d0                	callq  *%rax
  802a4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a57:	48 89 c7             	mov    %rax,%rdi
  802a5a:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	callq  *%rax
  802a66:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6e:	48 c1 e8 15          	shr    $0x15,%rax
  802a72:	48 89 c2             	mov    %rax,%rdx
  802a75:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a7c:	01 00 00 
  802a7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a83:	83 e0 01             	and    $0x1,%eax
  802a86:	48 85 c0             	test   %rax,%rax
  802a89:	74 73                	je     802afe <dup+0x11d>
  802a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8f:	48 c1 e8 0c          	shr    $0xc,%rax
  802a93:	48 89 c2             	mov    %rax,%rdx
  802a96:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a9d:	01 00 00 
  802aa0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aa4:	83 e0 01             	and    $0x1,%eax
  802aa7:	48 85 c0             	test   %rax,%rax
  802aaa:	74 52                	je     802afe <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ab4:	48 89 c2             	mov    %rax,%rdx
  802ab7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802abe:	01 00 00 
  802ac1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac5:	25 07 0e 00 00       	and    $0xe07,%eax
  802aca:	89 c1                	mov    %eax,%ecx
  802acc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad4:	41 89 c8             	mov    %ecx,%r8d
  802ad7:	48 89 d1             	mov    %rdx,%rcx
  802ada:	ba 00 00 00 00       	mov    $0x0,%edx
  802adf:	48 89 c6             	mov    %rax,%rsi
  802ae2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae7:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
  802af3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afa:	79 02                	jns    802afe <dup+0x11d>
			goto err;
  802afc:	eb 57                	jmp    802b55 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802afe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b02:	48 c1 e8 0c          	shr    $0xc,%rax
  802b06:	48 89 c2             	mov    %rax,%rdx
  802b09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b10:	01 00 00 
  802b13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b17:	25 07 0e 00 00       	and    $0xe07,%eax
  802b1c:	89 c1                	mov    %eax,%ecx
  802b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b26:	41 89 c8             	mov    %ecx,%r8d
  802b29:	48 89 d1             	mov    %rdx,%rcx
  802b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b31:	48 89 c6             	mov    %rax,%rsi
  802b34:	bf 00 00 00 00       	mov    $0x0,%edi
  802b39:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  802b40:	00 00 00 
  802b43:	ff d0                	callq  *%rax
  802b45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4c:	79 02                	jns    802b50 <dup+0x16f>
		goto err;
  802b4e:	eb 05                	jmp    802b55 <dup+0x174>

	return newfdnum;
  802b50:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b53:	eb 33                	jmp    802b88 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b59:	48 89 c6             	mov    %rax,%rsi
  802b5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b61:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b71:	48 89 c6             	mov    %rax,%rsi
  802b74:	bf 00 00 00 00       	mov    $0x0,%edi
  802b79:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
	return r;
  802b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b88:	c9                   	leaveq 
  802b89:	c3                   	retq   

0000000000802b8a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b8a:	55                   	push   %rbp
  802b8b:	48 89 e5             	mov    %rsp,%rbp
  802b8e:	48 83 ec 40          	sub    $0x40,%rsp
  802b92:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b95:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b99:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ba4:	48 89 d6             	mov    %rdx,%rsi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbc:	78 24                	js     802be2 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc2:	8b 00                	mov    (%rax),%eax
  802bc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bc8:	48 89 d6             	mov    %rdx,%rsi
  802bcb:	89 c7                	mov    %eax,%edi
  802bcd:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
  802bd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be0:	79 05                	jns    802be7 <read+0x5d>
		return r;
  802be2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be5:	eb 76                	jmp    802c5d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	8b 40 08             	mov    0x8(%rax),%eax
  802bee:	83 e0 03             	and    $0x3,%eax
  802bf1:	83 f8 01             	cmp    $0x1,%eax
  802bf4:	75 3a                	jne    802c30 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bfd:	00 00 00 
  802c00:	48 8b 00             	mov    (%rax),%rax
  802c03:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c09:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c0c:	89 c6                	mov    %eax,%esi
  802c0e:	48 bf 27 47 80 00 00 	movabs $0x804727,%rdi
  802c15:	00 00 00 
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802c24:	00 00 00 
  802c27:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c2e:	eb 2d                	jmp    802c5d <read+0xd3>
	}
	if (!dev->dev_read)
  802c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c34:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c38:	48 85 c0             	test   %rax,%rax
  802c3b:	75 07                	jne    802c44 <read+0xba>
		return -E_NOT_SUPP;
  802c3d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c42:	eb 19                	jmp    802c5d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c48:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c4c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c54:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c58:	48 89 cf             	mov    %rcx,%rdi
  802c5b:	ff d0                	callq  *%rax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 30          	sub    $0x30,%rsp
  802c67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c6e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c79:	eb 49                	jmp    802cc4 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7e:	48 98                	cltq   
  802c80:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c84:	48 29 c2             	sub    %rax,%rdx
  802c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8a:	48 63 c8             	movslq %eax,%rcx
  802c8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c91:	48 01 c1             	add    %rax,%rcx
  802c94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c97:	48 89 ce             	mov    %rcx,%rsi
  802c9a:	89 c7                	mov    %eax,%edi
  802c9c:	48 b8 8a 2b 80 00 00 	movabs $0x802b8a,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
  802ca8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802caf:	79 05                	jns    802cb6 <readn+0x57>
			return m;
  802cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb4:	eb 1c                	jmp    802cd2 <readn+0x73>
		if (m == 0)
  802cb6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cba:	75 02                	jne    802cbe <readn+0x5f>
			break;
  802cbc:	eb 11                	jmp    802ccf <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc1:	01 45 fc             	add    %eax,-0x4(%rbp)
  802cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc7:	48 98                	cltq   
  802cc9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ccd:	72 ac                	jb     802c7b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd2:	c9                   	leaveq 
  802cd3:	c3                   	retq   

0000000000802cd4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cd4:	55                   	push   %rbp
  802cd5:	48 89 e5             	mov    %rsp,%rbp
  802cd8:	48 83 ec 40          	sub    $0x40,%rsp
  802cdc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cdf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ce3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ce7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ceb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cee:	48 89 d6             	mov    %rdx,%rsi
  802cf1:	89 c7                	mov    %eax,%edi
  802cf3:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d06:	78 24                	js     802d2c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0c:	8b 00                	mov    (%rax),%eax
  802d0e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d12:	48 89 d6             	mov    %rdx,%rsi
  802d15:	89 c7                	mov    %eax,%edi
  802d17:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
  802d23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2a:	79 05                	jns    802d31 <write+0x5d>
		return r;
  802d2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2f:	eb 75                	jmp    802da6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d35:	8b 40 08             	mov    0x8(%rax),%eax
  802d38:	83 e0 03             	and    $0x3,%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	75 3a                	jne    802d79 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d3f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d46:	00 00 00 
  802d49:	48 8b 00             	mov    (%rax),%rax
  802d4c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d52:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d55:	89 c6                	mov    %eax,%esi
  802d57:	48 bf 43 47 80 00 00 	movabs $0x804743,%rdi
  802d5e:	00 00 00 
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
  802d66:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802d6d:	00 00 00 
  802d70:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d77:	eb 2d                	jmp    802da6 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d81:	48 85 c0             	test   %rax,%rax
  802d84:	75 07                	jne    802d8d <write+0xb9>
		return -E_NOT_SUPP;
  802d86:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d8b:	eb 19                	jmp    802da6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d91:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d95:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d9d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da1:	48 89 cf             	mov    %rcx,%rdi
  802da4:	ff d0                	callq  *%rax
}
  802da6:	c9                   	leaveq 
  802da7:	c3                   	retq   

0000000000802da8 <seek>:

int
seek(int fdnum, off_t offset)
{
  802da8:	55                   	push   %rbp
  802da9:	48 89 e5             	mov    %rsp,%rbp
  802dac:	48 83 ec 18          	sub    $0x18,%rsp
  802db0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802db6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dbd:	48 89 d6             	mov    %rdx,%rsi
  802dc0:	89 c7                	mov    %eax,%edi
  802dc2:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802dc9:	00 00 00 
  802dcc:	ff d0                	callq  *%rax
  802dce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd5:	79 05                	jns    802ddc <seek+0x34>
		return r;
  802dd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dda:	eb 0f                	jmp    802deb <seek+0x43>
	fd->fd_offset = offset;
  802ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802deb:	c9                   	leaveq 
  802dec:	c3                   	retq   

0000000000802ded <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ded:	55                   	push   %rbp
  802dee:	48 89 e5             	mov    %rsp,%rbp
  802df1:	48 83 ec 30          	sub    $0x30,%rsp
  802df5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802df8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e02:	48 89 d6             	mov    %rdx,%rsi
  802e05:	89 c7                	mov    %eax,%edi
  802e07:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
  802e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1a:	78 24                	js     802e40 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e20:	8b 00                	mov    (%rax),%eax
  802e22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e26:	48 89 d6             	mov    %rdx,%rsi
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3e:	79 05                	jns    802e45 <ftruncate+0x58>
		return r;
  802e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e43:	eb 72                	jmp    802eb7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e49:	8b 40 08             	mov    0x8(%rax),%eax
  802e4c:	83 e0 03             	and    $0x3,%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	75 3a                	jne    802e8d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e53:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e5a:	00 00 00 
  802e5d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e60:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e66:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e69:	89 c6                	mov    %eax,%esi
  802e6b:	48 bf 60 47 80 00 00 	movabs $0x804760,%rdi
  802e72:	00 00 00 
  802e75:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7a:	48 b9 2b 08 80 00 00 	movabs $0x80082b,%rcx
  802e81:	00 00 00 
  802e84:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e8b:	eb 2a                	jmp    802eb7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e91:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e95:	48 85 c0             	test   %rax,%rax
  802e98:	75 07                	jne    802ea1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e9f:	eb 16                	jmp    802eb7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea5:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ea9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ead:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802eb0:	89 ce                	mov    %ecx,%esi
  802eb2:	48 89 d7             	mov    %rdx,%rdi
  802eb5:	ff d0                	callq  *%rax
}
  802eb7:	c9                   	leaveq 
  802eb8:	c3                   	retq   

0000000000802eb9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802eb9:	55                   	push   %rbp
  802eba:	48 89 e5             	mov    %rsp,%rbp
  802ebd:	48 83 ec 30          	sub    $0x30,%rsp
  802ec1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ec4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ec8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ecc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ecf:	48 89 d6             	mov    %rdx,%rsi
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee7:	78 24                	js     802f0d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eed:	8b 00                	mov    (%rax),%eax
  802eef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef3:	48 89 d6             	mov    %rdx,%rsi
  802ef6:	89 c7                	mov    %eax,%edi
  802ef8:	48 b8 b1 28 80 00 00 	movabs $0x8028b1,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
  802f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0b:	79 05                	jns    802f12 <fstat+0x59>
		return r;
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f10:	eb 5e                	jmp    802f70 <fstat+0xb7>
	if (!dev->dev_stat)
  802f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f16:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f1a:	48 85 c0             	test   %rax,%rax
  802f1d:	75 07                	jne    802f26 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f1f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f24:	eb 4a                	jmp    802f70 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f2a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f31:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f38:	00 00 00 
	stat->st_isdir = 0;
  802f3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f3f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f46:	00 00 00 
	stat->st_dev = dev;
  802f49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f51:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f64:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f68:	48 89 ce             	mov    %rcx,%rsi
  802f6b:	48 89 d7             	mov    %rdx,%rdi
  802f6e:	ff d0                	callq  *%rax
}
  802f70:	c9                   	leaveq 
  802f71:	c3                   	retq   

0000000000802f72 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f72:	55                   	push   %rbp
  802f73:	48 89 e5             	mov    %rsp,%rbp
  802f76:	48 83 ec 20          	sub    $0x20,%rsp
  802f7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f86:	be 00 00 00 00       	mov    $0x0,%esi
  802f8b:	48 89 c7             	mov    %rax,%rdi
  802f8e:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa1:	79 05                	jns    802fa8 <stat+0x36>
		return fd;
  802fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa6:	eb 2f                	jmp    802fd7 <stat+0x65>
	r = fstat(fd, stat);
  802fa8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faf:	48 89 d6             	mov    %rdx,%rsi
  802fb2:	89 c7                	mov    %eax,%edi
  802fb4:	48 b8 b9 2e 80 00 00 	movabs $0x802eb9,%rax
  802fbb:	00 00 00 
  802fbe:	ff d0                	callq  *%rax
  802fc0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc6:	89 c7                	mov    %eax,%edi
  802fc8:	48 b8 68 29 80 00 00 	movabs $0x802968,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	callq  *%rax
	return r;
  802fd4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 83 ec 10          	sub    $0x10,%rsp
  802fe1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fe4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802fe8:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802fef:	00 00 00 
  802ff2:	8b 00                	mov    (%rax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	75 1d                	jne    803015 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ff8:	bf 01 00 00 00       	mov    $0x1,%edi
  802ffd:	48 b8 61 3f 80 00 00 	movabs $0x803f61,%rax
  803004:	00 00 00 
  803007:	ff d0                	callq  *%rax
  803009:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803010:	00 00 00 
  803013:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803015:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80301c:	00 00 00 
  80301f:	8b 00                	mov    (%rax),%eax
  803021:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803024:	b9 07 00 00 00       	mov    $0x7,%ecx
  803029:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803030:	00 00 00 
  803033:	89 c7                	mov    %eax,%edi
  803035:	48 b8 c9 3e 80 00 00 	movabs $0x803ec9,%rax
  80303c:	00 00 00 
  80303f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	ba 00 00 00 00       	mov    $0x0,%edx
  80304a:	48 89 c6             	mov    %rax,%rsi
  80304d:	bf 00 00 00 00       	mov    $0x0,%edi
  803052:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 20          	sub    $0x20,%rsp
  803068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80306c:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80306f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803073:	48 89 c7             	mov    %rax,%rdi
  803076:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  80307d:	00 00 00 
  803080:	ff d0                	callq  *%rax
  803082:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803087:	7e 0a                	jle    803093 <open+0x33>
		return -E_BAD_PATH;
  803089:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80308e:	e9 a5 00 00 00       	jmpq   803138 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803093:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803097:	48 89 c7             	mov    %rax,%rdi
  80309a:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
  8030a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ad:	79 08                	jns    8030b7 <open+0x57>
		return r;
  8030af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b2:	e9 81 00 00 00       	jmpq   803138 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8030b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bb:	48 89 c6             	mov    %rax,%rsi
  8030be:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030c5:	00 00 00 
  8030c8:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8030d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030db:	00 00 00 
  8030de:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030e1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8030e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030eb:	48 89 c6             	mov    %rax,%rsi
  8030ee:	bf 01 00 00 00       	mov    $0x1,%edi
  8030f3:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803106:	79 1d                	jns    803125 <open+0xc5>
		fd_close(fd, 0);
  803108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310c:	be 00 00 00 00       	mov    $0x0,%esi
  803111:	48 89 c7             	mov    %rax,%rdi
  803114:	48 b8 e8 27 80 00 00 	movabs $0x8027e8,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
		return r;
  803120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803123:	eb 13                	jmp    803138 <open+0xd8>
	}

	return fd2num(fd);
  803125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803129:	48 89 c7             	mov    %rax,%rdi
  80312c:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  803138:	c9                   	leaveq 
  803139:	c3                   	retq   

000000000080313a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80313a:	55                   	push   %rbp
  80313b:	48 89 e5             	mov    %rsp,%rbp
  80313e:	48 83 ec 10          	sub    $0x10,%rsp
  803142:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80314a:	8b 50 0c             	mov    0xc(%rax),%edx
  80314d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803154:	00 00 00 
  803157:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803159:	be 00 00 00 00       	mov    $0x0,%esi
  80315e:	bf 06 00 00 00       	mov    $0x6,%edi
  803163:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
}
  80316f:	c9                   	leaveq 
  803170:	c3                   	retq   

0000000000803171 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 83 ec 30          	sub    $0x30,%rsp
  803179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80317d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803181:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803189:	8b 50 0c             	mov    0xc(%rax),%edx
  80318c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803193:	00 00 00 
  803196:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803198:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80319f:	00 00 00 
  8031a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031a6:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8031aa:	be 00 00 00 00       	mov    $0x0,%esi
  8031af:	bf 03 00 00 00       	mov    $0x3,%edi
  8031b4:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
  8031c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c7:	79 05                	jns    8031ce <devfile_read+0x5d>
		return r;
  8031c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cc:	eb 26                	jmp    8031f4 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	48 63 d0             	movslq %eax,%rdx
  8031d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d8:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031df:	00 00 00 
  8031e2:	48 89 c7             	mov    %rax,%rdi
  8031e5:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax

	return r;
  8031f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8031f4:	c9                   	leaveq 
  8031f5:	c3                   	retq   

00000000008031f6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031f6:	55                   	push   %rbp
  8031f7:	48 89 e5             	mov    %rsp,%rbp
  8031fa:	48 83 ec 30          	sub    $0x30,%rsp
  8031fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803202:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803206:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  80320a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803211:	00 
  803212:	76 08                	jbe    80321c <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  803214:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80321b:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80321c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803220:	8b 50 0c             	mov    0xc(%rax),%edx
  803223:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80322a:	00 00 00 
  80322d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80322f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803236:	00 00 00 
  803239:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80323d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  803241:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803249:	48 89 c6             	mov    %rax,%rsi
  80324c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803253:	00 00 00 
  803256:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803262:	be 00 00 00 00       	mov    $0x0,%esi
  803267:	bf 04 00 00 00       	mov    $0x4,%edi
  80326c:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
  803278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327f:	79 05                	jns    803286 <devfile_write+0x90>
		return r;
  803281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803284:	eb 03                	jmp    803289 <devfile_write+0x93>

	return r;
  803286:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803289:	c9                   	leaveq 
  80328a:	c3                   	retq   

000000000080328b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80328b:	55                   	push   %rbp
  80328c:	48 89 e5             	mov    %rsp,%rbp
  80328f:	48 83 ec 20          	sub    $0x20,%rsp
  803293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803297:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80329b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329f:	8b 50 0c             	mov    0xc(%rax),%edx
  8032a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032a9:	00 00 00 
  8032ac:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032ae:	be 00 00 00 00       	mov    $0x0,%esi
  8032b3:	bf 05 00 00 00       	mov    $0x5,%edi
  8032b8:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
  8032c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cb:	79 05                	jns    8032d2 <devfile_stat+0x47>
		return r;
  8032cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d0:	eb 56                	jmp    803328 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8032d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032dd:	00 00 00 
  8032e0:	48 89 c7             	mov    %rax,%rdi
  8032e3:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032f6:	00 00 00 
  8032f9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803303:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803309:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803310:	00 00 00 
  803313:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803328:	c9                   	leaveq 
  803329:	c3                   	retq   

000000000080332a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80332a:	55                   	push   %rbp
  80332b:	48 89 e5             	mov    %rsp,%rbp
  80332e:	48 83 ec 10          	sub    $0x10,%rsp
  803332:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803336:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80333d:	8b 50 0c             	mov    0xc(%rax),%edx
  803340:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803347:	00 00 00 
  80334a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80334c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803353:	00 00 00 
  803356:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80335c:	be 00 00 00 00       	mov    $0x0,%esi
  803361:	bf 02 00 00 00       	mov    $0x2,%edi
  803366:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  80336d:	00 00 00 
  803370:	ff d0                	callq  *%rax
}
  803372:	c9                   	leaveq 
  803373:	c3                   	retq   

0000000000803374 <remove>:

// Delete a file
int
remove(const char *path)
{
  803374:	55                   	push   %rbp
  803375:	48 89 e5             	mov    %rsp,%rbp
  803378:	48 83 ec 10          	sub    $0x10,%rsp
  80337c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803384:	48 89 c7             	mov    %rax,%rdi
  803387:	48 b8 67 15 80 00 00 	movabs $0x801567,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
  803393:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803398:	7e 07                	jle    8033a1 <remove+0x2d>
		return -E_BAD_PATH;
  80339a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80339f:	eb 33                	jmp    8033d4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a5:	48 89 c6             	mov    %rax,%rsi
  8033a8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033af:	00 00 00 
  8033b2:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033be:	be 00 00 00 00       	mov    $0x0,%esi
  8033c3:	bf 07 00 00 00       	mov    $0x7,%edi
  8033c8:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
}
  8033d4:	c9                   	leaveq 
  8033d5:	c3                   	retq   

00000000008033d6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8033d6:	55                   	push   %rbp
  8033d7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8033da:	be 00 00 00 00       	mov    $0x0,%esi
  8033df:	bf 08 00 00 00       	mov    $0x8,%edi
  8033e4:	48 b8 d9 2f 80 00 00 	movabs $0x802fd9,%rax
  8033eb:	00 00 00 
  8033ee:	ff d0                	callq  *%rax
}
  8033f0:	5d                   	pop    %rbp
  8033f1:	c3                   	retq   

00000000008033f2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033f2:	55                   	push   %rbp
  8033f3:	48 89 e5             	mov    %rsp,%rbp
  8033f6:	53                   	push   %rbx
  8033f7:	48 83 ec 38          	sub    $0x38,%rsp
  8033fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033ff:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803403:	48 89 c7             	mov    %rax,%rdi
  803406:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
  803412:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803415:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803419:	0f 88 bf 01 00 00    	js     8035de <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80341f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803423:	ba 07 04 00 00       	mov    $0x407,%edx
  803428:	48 89 c6             	mov    %rax,%rsi
  80342b:	bf 00 00 00 00       	mov    $0x0,%edi
  803430:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80343f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803443:	0f 88 95 01 00 00    	js     8035de <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803449:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80344d:	48 89 c7             	mov    %rax,%rdi
  803450:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
  80345c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80345f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803463:	0f 88 5d 01 00 00    	js     8035c6 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803469:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346d:	ba 07 04 00 00       	mov    $0x407,%edx
  803472:	48 89 c6             	mov    %rax,%rsi
  803475:	bf 00 00 00 00       	mov    $0x0,%edi
  80347a:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
  803486:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803489:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80348d:	0f 88 33 01 00 00    	js     8035c6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803497:	48 89 c7             	mov    %rax,%rdi
  80349a:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
  8034a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8034b3:	48 89 c6             	mov    %rax,%rsi
  8034b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8034bb:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
  8034c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ce:	79 05                	jns    8034d5 <pipe+0xe3>
		goto err2;
  8034d0:	e9 d9 00 00 00       	jmpq   8035ae <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d9:	48 89 c7             	mov    %rax,%rdi
  8034dc:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
  8034e8:	48 89 c2             	mov    %rax,%rdx
  8034eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ef:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034f5:	48 89 d1             	mov    %rdx,%rcx
  8034f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8034fd:	48 89 c6             	mov    %rax,%rsi
  803500:	bf 00 00 00 00       	mov    $0x0,%edi
  803505:	48 b8 52 1f 80 00 00 	movabs $0x801f52,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803514:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803518:	79 1b                	jns    803535 <pipe+0x143>
		goto err3;
  80351a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80351b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80351f:	48 89 c6             	mov    %rax,%rsi
  803522:	bf 00 00 00 00       	mov    $0x0,%edi
  803527:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
  803533:	eb 79                	jmp    8035ae <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803539:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803540:	00 00 00 
  803543:	8b 12                	mov    (%rdx),%edx
  803545:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803552:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803556:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80355d:	00 00 00 
  803560:	8b 12                	mov    (%rdx),%edx
  803562:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803564:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803568:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80356f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803573:	48 89 c7             	mov    %rax,%rdi
  803576:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
  803582:	89 c2                	mov    %eax,%edx
  803584:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803588:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80358a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80358e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803592:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803596:	48 89 c7             	mov    %rax,%rdi
  803599:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
  8035a5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8035a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ac:	eb 33                	jmp    8035e1 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8035ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b2:	48 89 c6             	mov    %rax,%rsi
  8035b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ba:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8035c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ca:	48 89 c6             	mov    %rax,%rsi
  8035cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d2:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
    err:
	return r;
  8035de:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035e1:	48 83 c4 38          	add    $0x38,%rsp
  8035e5:	5b                   	pop    %rbx
  8035e6:	5d                   	pop    %rbp
  8035e7:	c3                   	retq   

00000000008035e8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035e8:	55                   	push   %rbp
  8035e9:	48 89 e5             	mov    %rsp,%rbp
  8035ec:	53                   	push   %rbx
  8035ed:	48 83 ec 28          	sub    $0x28,%rsp
  8035f1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035f5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035f9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803600:	00 00 00 
  803603:	48 8b 00             	mov    (%rax),%rax
  803606:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80360c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80360f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803613:	48 89 c7             	mov    %rax,%rdi
  803616:	48 b8 e3 3f 80 00 00 	movabs $0x803fe3,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
  803622:	89 c3                	mov    %eax,%ebx
  803624:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803628:	48 89 c7             	mov    %rax,%rdi
  80362b:	48 b8 e3 3f 80 00 00 	movabs $0x803fe3,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	39 c3                	cmp    %eax,%ebx
  803639:	0f 94 c0             	sete   %al
  80363c:	0f b6 c0             	movzbl %al,%eax
  80363f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803642:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803649:	00 00 00 
  80364c:	48 8b 00             	mov    (%rax),%rax
  80364f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803655:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803658:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80365b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80365e:	75 05                	jne    803665 <_pipeisclosed+0x7d>
			return ret;
  803660:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803663:	eb 4f                	jmp    8036b4 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803665:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803668:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80366b:	74 42                	je     8036af <_pipeisclosed+0xc7>
  80366d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803671:	75 3c                	jne    8036af <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803673:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80367a:	00 00 00 
  80367d:	48 8b 00             	mov    (%rax),%rax
  803680:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803686:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803689:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368c:	89 c6                	mov    %eax,%esi
  80368e:	48 bf 8b 47 80 00 00 	movabs $0x80478b,%rdi
  803695:	00 00 00 
  803698:	b8 00 00 00 00       	mov    $0x0,%eax
  80369d:	49 b8 2b 08 80 00 00 	movabs $0x80082b,%r8
  8036a4:	00 00 00 
  8036a7:	41 ff d0             	callq  *%r8
	}
  8036aa:	e9 4a ff ff ff       	jmpq   8035f9 <_pipeisclosed+0x11>
  8036af:	e9 45 ff ff ff       	jmpq   8035f9 <_pipeisclosed+0x11>
}
  8036b4:	48 83 c4 28          	add    $0x28,%rsp
  8036b8:	5b                   	pop    %rbx
  8036b9:	5d                   	pop    %rbp
  8036ba:	c3                   	retq   

00000000008036bb <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8036bb:	55                   	push   %rbp
  8036bc:	48 89 e5             	mov    %rsp,%rbp
  8036bf:	48 83 ec 30          	sub    $0x30,%rsp
  8036c3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036cd:	48 89 d6             	mov    %rdx,%rsi
  8036d0:	89 c7                	mov    %eax,%edi
  8036d2:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  8036d9:	00 00 00 
  8036dc:	ff d0                	callq  *%rax
  8036de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e5:	79 05                	jns    8036ec <pipeisclosed+0x31>
		return r;
  8036e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ea:	eb 31                	jmp    80371d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
  8036ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80370b:	48 89 d6             	mov    %rdx,%rsi
  80370e:	48 89 c7             	mov    %rax,%rdi
  803711:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
}
  80371d:	c9                   	leaveq 
  80371e:	c3                   	retq   

000000000080371f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80371f:	55                   	push   %rbp
  803720:	48 89 e5             	mov    %rsp,%rbp
  803723:	48 83 ec 40          	sub    $0x40,%rsp
  803727:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80372b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80372f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803737:	48 89 c7             	mov    %rax,%rdi
  80373a:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80374a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803752:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803759:	00 
  80375a:	e9 92 00 00 00       	jmpq   8037f1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80375f:	eb 41                	jmp    8037a2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803761:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803766:	74 09                	je     803771 <devpipe_read+0x52>
				return i;
  803768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376c:	e9 92 00 00 00       	jmpq   803803 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803771:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803779:	48 89 d6             	mov    %rdx,%rsi
  80377c:	48 89 c7             	mov    %rax,%rdi
  80377f:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  803786:	00 00 00 
  803789:	ff d0                	callq  *%rax
  80378b:	85 c0                	test   %eax,%eax
  80378d:	74 07                	je     803796 <devpipe_read+0x77>
				return 0;
  80378f:	b8 00 00 00 00       	mov    $0x0,%eax
  803794:	eb 6d                	jmp    803803 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803796:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  80379d:	00 00 00 
  8037a0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a6:	8b 10                	mov    (%rax),%edx
  8037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ac:	8b 40 04             	mov    0x4(%rax),%eax
  8037af:	39 c2                	cmp    %eax,%edx
  8037b1:	74 ae                	je     803761 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037bb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8037bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c3:	8b 00                	mov    (%rax),%eax
  8037c5:	99                   	cltd   
  8037c6:	c1 ea 1b             	shr    $0x1b,%edx
  8037c9:	01 d0                	add    %edx,%eax
  8037cb:	83 e0 1f             	and    $0x1f,%eax
  8037ce:	29 d0                	sub    %edx,%eax
  8037d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037d4:	48 98                	cltq   
  8037d6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037db:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e1:	8b 00                	mov    (%rax),%eax
  8037e3:	8d 50 01             	lea    0x1(%rax),%edx
  8037e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ea:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037f9:	0f 82 60 ff ff ff    	jb     80375f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803803:	c9                   	leaveq 
  803804:	c3                   	retq   

0000000000803805 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803805:	55                   	push   %rbp
  803806:	48 89 e5             	mov    %rsp,%rbp
  803809:	48 83 ec 40          	sub    $0x40,%rsp
  80380d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803811:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803815:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381d:	48 89 c7             	mov    %rax,%rdi
  803820:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  803827:	00 00 00 
  80382a:	ff d0                	callq  *%rax
  80382c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803830:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803834:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803838:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80383f:	00 
  803840:	e9 8e 00 00 00       	jmpq   8038d3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803845:	eb 31                	jmp    803878 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803847:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80384b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384f:	48 89 d6             	mov    %rdx,%rsi
  803852:	48 89 c7             	mov    %rax,%rdi
  803855:	48 b8 e8 35 80 00 00 	movabs $0x8035e8,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
  803861:	85 c0                	test   %eax,%eax
  803863:	74 07                	je     80386c <devpipe_write+0x67>
				return 0;
  803865:	b8 00 00 00 00       	mov    $0x0,%eax
  80386a:	eb 79                	jmp    8038e5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80386c:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803878:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387c:	8b 40 04             	mov    0x4(%rax),%eax
  80387f:	48 63 d0             	movslq %eax,%rdx
  803882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803886:	8b 00                	mov    (%rax),%eax
  803888:	48 98                	cltq   
  80388a:	48 83 c0 20          	add    $0x20,%rax
  80388e:	48 39 c2             	cmp    %rax,%rdx
  803891:	73 b4                	jae    803847 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803897:	8b 40 04             	mov    0x4(%rax),%eax
  80389a:	99                   	cltd   
  80389b:	c1 ea 1b             	shr    $0x1b,%edx
  80389e:	01 d0                	add    %edx,%eax
  8038a0:	83 e0 1f             	and    $0x1f,%eax
  8038a3:	29 d0                	sub    %edx,%eax
  8038a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038a9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8038ad:	48 01 ca             	add    %rcx,%rdx
  8038b0:	0f b6 0a             	movzbl (%rdx),%ecx
  8038b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b7:	48 98                	cltq   
  8038b9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8038bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c1:	8b 40 04             	mov    0x4(%rax),%eax
  8038c4:	8d 50 01             	lea    0x1(%rax),%edx
  8038c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038d7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038db:	0f 82 64 ff ff ff    	jb     803845 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038e5:	c9                   	leaveq 
  8038e6:	c3                   	retq   

00000000008038e7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038e7:	55                   	push   %rbp
  8038e8:	48 89 e5             	mov    %rsp,%rbp
  8038eb:	48 83 ec 20          	sub    $0x20,%rsp
  8038ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fb:	48 89 c7             	mov    %rax,%rdi
  8038fe:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80390e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803912:	48 be 9e 47 80 00 00 	movabs $0x80479e,%rsi
  803919:	00 00 00 
  80391c:	48 89 c7             	mov    %rax,%rdi
  80391f:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80392b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392f:	8b 50 04             	mov    0x4(%rax),%edx
  803932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803936:	8b 00                	mov    (%rax),%eax
  803938:	29 c2                	sub    %eax,%edx
  80393a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803944:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803948:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80394f:	00 00 00 
	stat->st_dev = &devpipe;
  803952:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803956:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80395d:	00 00 00 
  803960:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803967:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80396c:	c9                   	leaveq 
  80396d:	c3                   	retq   

000000000080396e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80396e:	55                   	push   %rbp
  80396f:	48 89 e5             	mov    %rsp,%rbp
  803972:	48 83 ec 10          	sub    $0x10,%rsp
  803976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80397a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80397e:	48 89 c6             	mov    %rax,%rsi
  803981:	bf 00 00 00 00       	mov    $0x0,%edi
  803986:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803992:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803996:	48 89 c7             	mov    %rax,%rdi
  803999:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8039a0:	00 00 00 
  8039a3:	ff d0                	callq  *%rax
  8039a5:	48 89 c6             	mov    %rax,%rsi
  8039a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ad:	48 b8 ad 1f 80 00 00 	movabs $0x801fad,%rax
  8039b4:	00 00 00 
  8039b7:	ff d0                	callq  *%rax
}
  8039b9:	c9                   	leaveq 
  8039ba:	c3                   	retq   

00000000008039bb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8039bb:	55                   	push   %rbp
  8039bc:	48 89 e5             	mov    %rsp,%rbp
  8039bf:	48 83 ec 20          	sub    $0x20,%rsp
  8039c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8039c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039ca:	75 35                	jne    803a01 <wait+0x46>
  8039cc:	48 b9 a5 47 80 00 00 	movabs $0x8047a5,%rcx
  8039d3:	00 00 00 
  8039d6:	48 ba b0 47 80 00 00 	movabs $0x8047b0,%rdx
  8039dd:	00 00 00 
  8039e0:	be 09 00 00 00       	mov    $0x9,%esi
  8039e5:	48 bf c5 47 80 00 00 	movabs $0x8047c5,%rdi
  8039ec:	00 00 00 
  8039ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f4:	49 b8 f2 05 80 00 00 	movabs $0x8005f2,%r8
  8039fb:	00 00 00 
  8039fe:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803a01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a04:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a09:	48 63 d0             	movslq %eax,%rdx
  803a0c:	48 89 d0             	mov    %rdx,%rax
  803a0f:	48 c1 e0 03          	shl    $0x3,%rax
  803a13:	48 01 d0             	add    %rdx,%rax
  803a16:	48 c1 e0 05          	shl    $0x5,%rax
  803a1a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a21:	00 00 00 
  803a24:	48 01 d0             	add    %rdx,%rax
  803a27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a2b:	eb 0c                	jmp    803a39 <wait+0x7e>
		sys_yield();
  803a2d:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803a34:	00 00 00 
  803a37:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a43:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803a46:	75 0e                	jne    803a56 <wait+0x9b>
  803a48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a52:	85 c0                	test   %eax,%eax
  803a54:	75 d7                	jne    803a2d <wait+0x72>
		sys_yield();
}
  803a56:	c9                   	leaveq 
  803a57:	c3                   	retq   

0000000000803a58 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a58:	55                   	push   %rbp
  803a59:	48 89 e5             	mov    %rsp,%rbp
  803a5c:	48 83 ec 20          	sub    $0x20,%rsp
  803a60:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a66:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a69:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a6d:	be 01 00 00 00       	mov    $0x1,%esi
  803a72:	48 89 c7             	mov    %rax,%rdi
  803a75:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  803a7c:	00 00 00 
  803a7f:	ff d0                	callq  *%rax
}
  803a81:	c9                   	leaveq 
  803a82:	c3                   	retq   

0000000000803a83 <getchar>:

int
getchar(void)
{
  803a83:	55                   	push   %rbp
  803a84:	48 89 e5             	mov    %rsp,%rbp
  803a87:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a8b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a8f:	ba 01 00 00 00       	mov    $0x1,%edx
  803a94:	48 89 c6             	mov    %rax,%rsi
  803a97:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9c:	48 b8 8a 2b 80 00 00 	movabs $0x802b8a,%rax
  803aa3:	00 00 00 
  803aa6:	ff d0                	callq  *%rax
  803aa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aaf:	79 05                	jns    803ab6 <getchar+0x33>
		return r;
  803ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab4:	eb 14                	jmp    803aca <getchar+0x47>
	if (r < 1)
  803ab6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aba:	7f 07                	jg     803ac3 <getchar+0x40>
		return -E_EOF;
  803abc:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ac1:	eb 07                	jmp    803aca <getchar+0x47>
	return c;
  803ac3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ac7:	0f b6 c0             	movzbl %al,%eax
}
  803aca:	c9                   	leaveq 
  803acb:	c3                   	retq   

0000000000803acc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803acc:	55                   	push   %rbp
  803acd:	48 89 e5             	mov    %rsp,%rbp
  803ad0:	48 83 ec 20          	sub    $0x20,%rsp
  803ad4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ad7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803adb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ade:	48 89 d6             	mov    %rdx,%rsi
  803ae1:	89 c7                	mov    %eax,%edi
  803ae3:	48 b8 58 27 80 00 00 	movabs $0x802758,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af6:	79 05                	jns    803afd <iscons+0x31>
		return r;
  803af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afb:	eb 1a                	jmp    803b17 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b01:	8b 10                	mov    (%rax),%edx
  803b03:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b0a:	00 00 00 
  803b0d:	8b 00                	mov    (%rax),%eax
  803b0f:	39 c2                	cmp    %eax,%edx
  803b11:	0f 94 c0             	sete   %al
  803b14:	0f b6 c0             	movzbl %al,%eax
}
  803b17:	c9                   	leaveq 
  803b18:	c3                   	retq   

0000000000803b19 <opencons>:

int
opencons(void)
{
  803b19:	55                   	push   %rbp
  803b1a:	48 89 e5             	mov    %rsp,%rbp
  803b1d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b21:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b25:	48 89 c7             	mov    %rax,%rdi
  803b28:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
  803b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3b:	79 05                	jns    803b42 <opencons+0x29>
		return r;
  803b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b40:	eb 5b                	jmp    803b9d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b46:	ba 07 04 00 00       	mov    $0x407,%edx
  803b4b:	48 89 c6             	mov    %rax,%rsi
  803b4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b53:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
  803b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b66:	79 05                	jns    803b6d <opencons+0x54>
		return r;
  803b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6b:	eb 30                	jmp    803b9d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b71:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b78:	00 00 00 
  803b7b:	8b 12                	mov    (%rdx),%edx
  803b7d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8e:	48 89 c7             	mov    %rax,%rdi
  803b91:	48 b8 72 26 80 00 00 	movabs $0x802672,%rax
  803b98:	00 00 00 
  803b9b:	ff d0                	callq  *%rax
}
  803b9d:	c9                   	leaveq 
  803b9e:	c3                   	retq   

0000000000803b9f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b9f:	55                   	push   %rbp
  803ba0:	48 89 e5             	mov    %rsp,%rbp
  803ba3:	48 83 ec 30          	sub    $0x30,%rsp
  803ba7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803baf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bb3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bb8:	75 07                	jne    803bc1 <devcons_read+0x22>
		return 0;
  803bba:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbf:	eb 4b                	jmp    803c0c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bc1:	eb 0c                	jmp    803bcf <devcons_read+0x30>
		sys_yield();
  803bc3:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803bca:	00 00 00 
  803bcd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bcf:	48 b8 04 1e 80 00 00 	movabs $0x801e04,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
  803bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be2:	74 df                	je     803bc3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803be4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be8:	79 05                	jns    803bef <devcons_read+0x50>
		return c;
  803bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bed:	eb 1d                	jmp    803c0c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bef:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bf3:	75 07                	jne    803bfc <devcons_read+0x5d>
		return 0;
  803bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfa:	eb 10                	jmp    803c0c <devcons_read+0x6d>
	*(char*)vbuf = c;
  803bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bff:	89 c2                	mov    %eax,%edx
  803c01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c05:	88 10                	mov    %dl,(%rax)
	return 1;
  803c07:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c0c:	c9                   	leaveq 
  803c0d:	c3                   	retq   

0000000000803c0e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c0e:	55                   	push   %rbp
  803c0f:	48 89 e5             	mov    %rsp,%rbp
  803c12:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c19:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c20:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c27:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c35:	eb 76                	jmp    803cad <devcons_write+0x9f>
		m = n - tot;
  803c37:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c3e:	89 c2                	mov    %eax,%edx
  803c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c43:	29 c2                	sub    %eax,%edx
  803c45:	89 d0                	mov    %edx,%eax
  803c47:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c4d:	83 f8 7f             	cmp    $0x7f,%eax
  803c50:	76 07                	jbe    803c59 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c52:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5c:	48 63 d0             	movslq %eax,%rdx
  803c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c62:	48 63 c8             	movslq %eax,%rcx
  803c65:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c6c:	48 01 c1             	add    %rax,%rcx
  803c6f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c76:	48 89 ce             	mov    %rcx,%rsi
  803c79:	48 89 c7             	mov    %rax,%rdi
  803c7c:	48 b8 f7 18 80 00 00 	movabs $0x8018f7,%rax
  803c83:	00 00 00 
  803c86:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c8b:	48 63 d0             	movslq %eax,%rdx
  803c8e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c95:	48 89 d6             	mov    %rdx,%rsi
  803c98:	48 89 c7             	mov    %rax,%rdi
  803c9b:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  803ca2:	00 00 00 
  803ca5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ca7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803caa:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb0:	48 98                	cltq   
  803cb2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cb9:	0f 82 78 ff ff ff    	jb     803c37 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cc2:	c9                   	leaveq 
  803cc3:	c3                   	retq   

0000000000803cc4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cc4:	55                   	push   %rbp
  803cc5:	48 89 e5             	mov    %rsp,%rbp
  803cc8:	48 83 ec 08          	sub    $0x8,%rsp
  803ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 10          	sub    $0x10,%rsp
  803cdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ce3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ceb:	48 be d5 47 80 00 00 	movabs $0x8047d5,%rsi
  803cf2:	00 00 00 
  803cf5:	48 89 c7             	mov    %rax,%rdi
  803cf8:	48 b8 d3 15 80 00 00 	movabs $0x8015d3,%rax
  803cff:	00 00 00 
  803d02:	ff d0                	callq  *%rax
	return 0;
  803d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d09:	c9                   	leaveq 
  803d0a:	c3                   	retq   

0000000000803d0b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 10          	sub    $0x10,%rsp
  803d13:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d17:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d1e:	00 00 00 
  803d21:	48 8b 00             	mov    (%rax),%rax
  803d24:	48 85 c0             	test   %rax,%rax
  803d27:	75 3a                	jne    803d63 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803d29:	ba 07 00 00 00       	mov    $0x7,%edx
  803d2e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d33:	bf 00 00 00 00       	mov    $0x0,%edi
  803d38:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  803d3f:	00 00 00 
  803d42:	ff d0                	callq  *%rax
  803d44:	85 c0                	test   %eax,%eax
  803d46:	75 1b                	jne    803d63 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803d48:	48 be 76 3d 80 00 00 	movabs $0x803d76,%rsi
  803d4f:	00 00 00 
  803d52:	bf 00 00 00 00       	mov    $0x0,%edi
  803d57:	48 b8 8c 20 80 00 00 	movabs $0x80208c,%rax
  803d5e:	00 00 00 
  803d61:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d63:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d6a:	00 00 00 
  803d6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d71:	48 89 10             	mov    %rdx,(%rax)
}
  803d74:	c9                   	leaveq 
  803d75:	c3                   	retq   

0000000000803d76 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803d76:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803d79:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d80:	00 00 00 
	call *%rax
  803d83:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803d85:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803d88:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803d8f:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803d90:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803d97:	00 
	pushq %rbx		// push utf_rip into new stack
  803d98:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803d99:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803da0:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803da3:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803da7:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803dab:	4c 8b 3c 24          	mov    (%rsp),%r15
  803daf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803db4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803db9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803dbe:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803dc3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803dc8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803dcd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803dd2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803dd7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803ddc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803de1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803de6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803deb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803df0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803df5:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803df9:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803dfd:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803dfe:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803dff:	c3                   	retq   

0000000000803e00 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e00:	55                   	push   %rbp
  803e01:	48 89 e5             	mov    %rsp,%rbp
  803e04:	48 83 ec 30          	sub    $0x30,%rsp
  803e08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803e14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803e1c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e21:	75 0e                	jne    803e31 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803e23:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e2a:	00 00 00 
  803e2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803e31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e35:	48 89 c7             	mov    %rax,%rdi
  803e38:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  803e3f:	00 00 00 
  803e42:	ff d0                	callq  *%rax
  803e44:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803e4b:	79 27                	jns    803e74 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803e4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e52:	74 0a                	je     803e5e <ipc_recv+0x5e>
			*from_env_store = 0;
  803e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803e5e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e63:	74 0a                	je     803e6f <ipc_recv+0x6f>
			*perm_store = 0;
  803e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e69:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803e6f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e72:	eb 53                	jmp    803ec7 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803e74:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e79:	74 19                	je     803e94 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803e7b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e82:	00 00 00 
  803e85:	48 8b 00             	mov    (%rax),%rax
  803e88:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e92:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803e94:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e99:	74 19                	je     803eb4 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803e9b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ea2:	00 00 00 
  803ea5:	48 8b 00             	mov    (%rax),%rax
  803ea8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb2:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803eb4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ebb:	00 00 00 
  803ebe:	48 8b 00             	mov    (%rax),%rax
  803ec1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803ec7:	c9                   	leaveq 
  803ec8:	c3                   	retq   

0000000000803ec9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ec9:	55                   	push   %rbp
  803eca:	48 89 e5             	mov    %rsp,%rbp
  803ecd:	48 83 ec 30          	sub    $0x30,%rsp
  803ed1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ed4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ed7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803edb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803ede:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803ee6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803eeb:	75 10                	jne    803efd <ipc_send+0x34>
		page = (void *)KERNBASE;
  803eed:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ef4:	00 00 00 
  803ef7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803efb:	eb 0e                	jmp    803f0b <ipc_send+0x42>
  803efd:	eb 0c                	jmp    803f0b <ipc_send+0x42>
		sys_yield();
  803eff:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803f06:	00 00 00 
  803f09:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803f0b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f0e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f11:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f18:	89 c7                	mov    %eax,%edi
  803f1a:	48 b8 d6 20 80 00 00 	movabs $0x8020d6,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803f29:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803f2d:	74 d0                	je     803eff <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803f33:	74 2a                	je     803f5f <ipc_send+0x96>
		panic("error on ipc send procedure");
  803f35:	48 ba dc 47 80 00 00 	movabs $0x8047dc,%rdx
  803f3c:	00 00 00 
  803f3f:	be 49 00 00 00       	mov    $0x49,%esi
  803f44:	48 bf f8 47 80 00 00 	movabs $0x8047f8,%rdi
  803f4b:	00 00 00 
  803f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f53:	48 b9 f2 05 80 00 00 	movabs $0x8005f2,%rcx
  803f5a:	00 00 00 
  803f5d:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803f5f:	c9                   	leaveq 
  803f60:	c3                   	retq   

0000000000803f61 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f61:	55                   	push   %rbp
  803f62:	48 89 e5             	mov    %rsp,%rbp
  803f65:	48 83 ec 14          	sub    $0x14,%rsp
  803f69:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f73:	eb 5e                	jmp    803fd3 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803f75:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f7c:	00 00 00 
  803f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f82:	48 63 d0             	movslq %eax,%rdx
  803f85:	48 89 d0             	mov    %rdx,%rax
  803f88:	48 c1 e0 03          	shl    $0x3,%rax
  803f8c:	48 01 d0             	add    %rdx,%rax
  803f8f:	48 c1 e0 05          	shl    $0x5,%rax
  803f93:	48 01 c8             	add    %rcx,%rax
  803f96:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f9c:	8b 00                	mov    (%rax),%eax
  803f9e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fa1:	75 2c                	jne    803fcf <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fa3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803faa:	00 00 00 
  803fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb0:	48 63 d0             	movslq %eax,%rdx
  803fb3:	48 89 d0             	mov    %rdx,%rax
  803fb6:	48 c1 e0 03          	shl    $0x3,%rax
  803fba:	48 01 d0             	add    %rdx,%rax
  803fbd:	48 c1 e0 05          	shl    $0x5,%rax
  803fc1:	48 01 c8             	add    %rcx,%rax
  803fc4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803fca:	8b 40 08             	mov    0x8(%rax),%eax
  803fcd:	eb 12                	jmp    803fe1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803fcf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803fd3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803fda:	7e 99                	jle    803f75 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803fdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fe1:	c9                   	leaveq 
  803fe2:	c3                   	retq   

0000000000803fe3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803fe3:	55                   	push   %rbp
  803fe4:	48 89 e5             	mov    %rsp,%rbp
  803fe7:	48 83 ec 18          	sub    $0x18,%rsp
  803feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ff3:	48 c1 e8 15          	shr    $0x15,%rax
  803ff7:	48 89 c2             	mov    %rax,%rdx
  803ffa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804001:	01 00 00 
  804004:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804008:	83 e0 01             	and    $0x1,%eax
  80400b:	48 85 c0             	test   %rax,%rax
  80400e:	75 07                	jne    804017 <pageref+0x34>
		return 0;
  804010:	b8 00 00 00 00       	mov    $0x0,%eax
  804015:	eb 53                	jmp    80406a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804017:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401b:	48 c1 e8 0c          	shr    $0xc,%rax
  80401f:	48 89 c2             	mov    %rax,%rdx
  804022:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804029:	01 00 00 
  80402c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804030:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804034:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804038:	83 e0 01             	and    $0x1,%eax
  80403b:	48 85 c0             	test   %rax,%rax
  80403e:	75 07                	jne    804047 <pageref+0x64>
		return 0;
  804040:	b8 00 00 00 00       	mov    $0x0,%eax
  804045:	eb 23                	jmp    80406a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80404b:	48 c1 e8 0c          	shr    $0xc,%rax
  80404f:	48 89 c2             	mov    %rax,%rdx
  804052:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804059:	00 00 00 
  80405c:	48 c1 e2 04          	shl    $0x4,%rdx
  804060:	48 01 d0             	add    %rdx,%rax
  804063:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804067:	0f b7 c0             	movzwl %ax,%eax
}
  80406a:	c9                   	leaveq 
  80406b:	c3                   	retq   
