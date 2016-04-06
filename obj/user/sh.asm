
obj/user/sh.debug:     file format elf64-x86-64


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
  80003c:	e8 08 11 00 00       	callq  801149 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf 08 5d 80 00 00 	movabs $0x805d08,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf 20 5d 80 00 00 	movabs $0x805d20,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 a9 40 80 00 00 	movabs $0x8040a9,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 46 5d 80 00 00 	movabs $0x805d46,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 2a 3a 80 00 00 	movabs $0x803a2a,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf 60 5d 80 00 00 	movabs $0x805d60,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 a9 40 80 00 00 	movabs $0x8040a9,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 86 5d 80 00 00 	movabs $0x805d86,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 2a 3a 80 00 00 	movabs $0x803a2a,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 2b 53 80 00 00 	movabs $0x80532b,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 9c 5d 80 00 00 	movabs $0x805d9c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf a5 5d 80 00 00 	movabs $0x805da5,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf b2 5d 80 00 00 	movabs $0x805db2,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 2a 3a 80 00 00 	movabs $0x803a2a,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 2a 3a 80 00 00 	movabs $0x803a2a,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba bb 5d 80 00 00 	movabs $0x805dbb,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if (argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf e1 5d 80 00 00 	movabs $0x805de1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for (i = 0; i < npaths; i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 bb 3f 80 00 00 	movabs $0x803fbb,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if (r == 0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for (i = 0; i < npaths; i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf f0 5d 80 00 00 	movabs $0x805df0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf fe 5d 80 00 00 	movabs $0x805dfe,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf 02 5e 80 00 00 	movabs $0x805e02,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 3f 47 80 00 00 	movabs $0x80473f,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf 04 5e 80 00 00 	movabs $0x805e04,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 fc 39 80 00 00 	movabs $0x8039fc,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf 12 5e 80 00 00 	movabs $0x805e12,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 35 14 80 00 00 	movabs $0x801435,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 f4 58 80 00 00 	movabs $0x8058f4,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 27 5e 80 00 00 	movabs $0x805e27,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 3d 5e 80 00 00 	movabs $0x805e3d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 f4 58 80 00 00 	movabs $0x8058f4,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 27 5e 80 00 00 	movabs $0x805e27,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 5a 5e 80 00 00 	movabs $0x805e5a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 69 5e 80 00 00 	movabs $0x805e69,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 77 5e 80 00 00 	movabs $0x805e77,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 5d 25 80 00 00 	movabs $0x80255d,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 7c 5e 80 00 00 	movabs $0x805e7c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 81 5e 80 00 00 	movabs $0x805e81,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 5d 25 80 00 00 	movabs $0x80255d,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 89 5e 80 00 00 	movabs $0x805e89,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 91 5e 80 00 00 	movabs $0x805e91,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 5d 25 80 00 00 	movabs $0x80255d,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 9d 5e 80 00 00 	movabs $0x805e9d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 90 80 00 00 	movabs $0x809018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 90 80 00 00 	movabs $0x809010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 90 80 00 00 	movabs $0x809008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 90 80 00 00 	movabs $0x809018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c 90 80 00 00 	movabs $0x80901c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf a8 5e 80 00 00 	movabs $0x805ea8,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800b5e:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6c:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b70:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b74:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b78:	48 89 ce             	mov    %rcx,%rsi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 d6 33 80 00 00 	movabs $0x8033d6,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8a:	eb 4d                	jmp    800bd9 <umain+0x8a>
		switch (r) {
  800b8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8f:	83 f8 69             	cmp    $0x69,%eax
  800b92:	74 27                	je     800bbb <umain+0x6c>
  800b94:	83 f8 78             	cmp    $0x78,%eax
  800b97:	74 2b                	je     800bc4 <umain+0x75>
  800b99:	83 f8 64             	cmp    $0x64,%eax
  800b9c:	75 2f                	jne    800bcd <umain+0x7e>
		case 'd':
			debug++;
  800b9e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800bb4:	00 00 00 
  800bb7:	89 10                	mov    %edx,(%rax)
			break;
  800bb9:	eb 1e                	jmp    800bd9 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc2:	eb 15                	jmp    800bd9 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcb:	eb 0c                	jmp    800bd9 <umain+0x8a>
		default:
			usage();
  800bcd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 3a 34 80 00 00 	movabs $0x80343a,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
			break;
		default:
			usage();
		}

	if (argc > 2)
  800bf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf8:	83 f8 02             	cmp    $0x2,%eax
  800bfb:	7e 0c                	jle    800c09 <umain+0xba>
		usage();
  800bfd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c09:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0c:	83 f8 02             	cmp    $0x2,%eax
  800c0f:	0f 85 b3 00 00 00    	jne    800cc8 <umain+0x179>
		close(0);
  800c15:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1a:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 a9 40 80 00 00 	movabs $0x8040a9,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
  800c45:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4c:	79 3f                	jns    800c8d <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c52:	48 83 c0 08          	add    $0x8,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5c:	41 89 d0             	mov    %edx,%r8d
  800c5f:	48 89 c1             	mov    %rax,%rcx
  800c62:	48 ba c9 5e 80 00 00 	movabs $0x805ec9,%rdx
  800c69:	00 00 00 
  800c6c:	be 2b 01 00 00       	mov    $0x12b,%esi
  800c71:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 fc 11 80 00 00 	movabs $0x8011fc,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 d5 5e 80 00 00 	movabs $0x805ed5,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba dc 5e 80 00 00 	movabs $0x805edc,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2c 01 00 00       	mov    $0x12c,%esi
  800cac:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 0a 0f 80 00 00 	movabs $0x800f0a,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 f1 5e 80 00 00 	movabs $0x805ef1,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf f4 5e 80 00 00 	movabs $0x805ef4,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if (debug)
  800d4a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800d51:	00 00 00 
  800d54:	8b 00                	mov    (%rax),%eax
  800d56:	85 c0                	test   %eax,%eax
  800d58:	74 22                	je     800d7c <umain+0x22d>
			cprintf("LINE: %s\n", buf);
  800d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5e:	48 89 c6             	mov    %rax,%rsi
  800d61:	48 bf fd 5e 80 00 00 	movabs $0x805efd,%rdi
  800d68:	00 00 00 
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800d77:	00 00 00 
  800d7a:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	0f b6 00             	movzbl (%rax),%eax
  800d83:	3c 23                	cmp    $0x23,%al
  800d85:	75 05                	jne    800d8c <umain+0x23d>
			continue;
  800d87:	e9 05 01 00 00       	jmpq   800e91 <umain+0x342>
		if (echocmds)
  800d8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d90:	74 22                	je     800db4 <umain+0x265>
			printf("# %s\n", buf);
  800d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d96:	48 89 c6             	mov    %rax,%rsi
  800d99:	48 bf 07 5f 80 00 00 	movabs $0x805f07,%rdi
  800da0:	00 00 00 
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	48 ba 89 46 80 00 00 	movabs $0x804689,%rdx
  800daf:	00 00 00 
  800db2:	ff d2                	callq  *%rdx
		if (debug)
  800db4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800dbb:	00 00 00 
  800dbe:	8b 00                	mov    (%rax),%eax
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	74 1b                	je     800ddf <umain+0x290>
			cprintf("BEFORE FORK\n");
  800dc4:	48 bf 0d 5f 80 00 00 	movabs $0x805f0d,%rdi
  800dcb:	00 00 00 
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd3:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800dda:	00 00 00 
  800ddd:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800ddf:	48 b8 3c 31 80 00 00 	movabs $0x80313c,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800df2:	79 30                	jns    800e24 <umain+0x2d5>
			panic("fork: %e", r);
  800df4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800df7:	89 c1                	mov    %eax,%ecx
  800df9:	48 ba b2 5d 80 00 00 	movabs $0x805db2,%rdx
  800e00:	00 00 00 
  800e03:	be 43 01 00 00       	mov    $0x143,%esi
  800e08:	48 bf d7 5d 80 00 00 	movabs $0x805dd7,%rdi
  800e0f:	00 00 00 
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
  800e17:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  800e1e:	00 00 00 
  800e21:	41 ff d0             	callq  *%r8
		if (debug)
  800e24:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800e2b:	00 00 00 
  800e2e:	8b 00                	mov    (%rax),%eax
  800e30:	85 c0                	test   %eax,%eax
  800e32:	74 20                	je     800e54 <umain+0x305>
			cprintf("FORK: %d\n", r);
  800e34:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	48 bf 1a 5f 80 00 00 	movabs $0x805f1a,%rdi
  800e40:	00 00 00 
  800e43:	b8 00 00 00 00       	mov    $0x0,%eax
  800e48:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  800e4f:	00 00 00 
  800e52:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e58:	75 21                	jne    800e7b <umain+0x32c>
			runcmd(buf);
  800e5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5e:	48 89 c7             	mov    %rax,%rdi
  800e61:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
			exit();
  800e6d:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  800e74:	00 00 00 
  800e77:	ff d0                	callq  *%rax
  800e79:	eb 16                	jmp    800e91 <umain+0x342>
		} else
			wait(r);
  800e7b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	48 b8 f4 58 80 00 00 	movabs $0x8058f4,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
	}
  800e8c:	e9 51 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800e91:	e9 4c fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800e96 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800e96:	55                   	push   %rbp
  800e97:	48 89 e5             	mov    %rsp,%rbp
  800e9a:	48 83 ec 20          	sub    $0x20,%rsp
  800e9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ea4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ea7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800eab:	be 01 00 00 00       	mov    $0x1,%esi
  800eb0:	48 89 c7             	mov    %rax,%rdi
  800eb3:	48 b8 1e 2b 80 00 00 	movabs $0x802b1e,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	callq  *%rax
}
  800ebf:	c9                   	leaveq 
  800ec0:	c3                   	retq   

0000000000800ec1 <getchar>:

int
getchar(void)
{
  800ec1:	55                   	push   %rbp
  800ec2:	48 89 e5             	mov    %rsp,%rbp
  800ec5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ec9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800ecd:	ba 01 00 00 00       	mov    $0x1,%edx
  800ed2:	48 89 c6             	mov    %rax,%rsi
  800ed5:	bf 00 00 00 00       	mov    $0x0,%edi
  800eda:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  800ee1:	00 00 00 
  800ee4:	ff d0                	callq  *%rax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eed:	79 05                	jns    800ef4 <getchar+0x33>
		return r;
  800eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ef2:	eb 14                	jmp    800f08 <getchar+0x47>
	if (r < 1)
  800ef4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ef8:	7f 07                	jg     800f01 <getchar+0x40>
		return -E_EOF;
  800efa:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800eff:	eb 07                	jmp    800f08 <getchar+0x47>
	return c;
  800f01:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f05:	0f b6 c0             	movzbl %al,%eax
}
  800f08:	c9                   	leaveq 
  800f09:	c3                   	retq   

0000000000800f0a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f0a:	55                   	push   %rbp
  800f0b:	48 89 e5             	mov    %rsp,%rbp
  800f0e:	48 83 ec 20          	sub    $0x20,%rsp
  800f12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f1c:	48 89 d6             	mov    %rdx,%rsi
  800f1f:	89 c7                	mov    %eax,%edi
  800f21:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	callq  *%rax
  800f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f34:	79 05                	jns    800f3b <iscons+0x31>
		return r;
  800f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f39:	eb 1a                	jmp    800f55 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3f:	8b 10                	mov    (%rax),%edx
  800f41:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800f48:	00 00 00 
  800f4b:	8b 00                	mov    (%rax),%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	0f 94 c0             	sete   %al
  800f52:	0f b6 c0             	movzbl %al,%eax
}
  800f55:	c9                   	leaveq 
  800f56:	c3                   	retq   

0000000000800f57 <opencons>:

int
opencons(void)
{
  800f57:	55                   	push   %rbp
  800f58:	48 89 e5             	mov    %rsp,%rbp
  800f5b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f5f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f63:	48 89 c7             	mov    %rax,%rdi
  800f66:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	callq  *%rax
  800f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f79:	79 05                	jns    800f80 <opencons+0x29>
		return r;
  800f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f7e:	eb 5b                	jmp    800fdb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f84:	ba 07 04 00 00       	mov    $0x407,%edx
  800f89:	48 89 c6             	mov    %rax,%rsi
  800f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f91:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	callq  *%rax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa4:	79 05                	jns    800fab <opencons+0x54>
		return r;
  800fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa9:	eb 30                	jmp    800fdb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800faf:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  800fb6:	00 00 00 
  800fb9:	8b 12                	mov    (%rdx),%edx
  800fbb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcc:	48 89 c7             	mov    %rax,%rdi
  800fcf:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	callq  *%rax
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 30          	sub    $0x30,%rsp
  800fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800ff1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff6:	75 07                	jne    800fff <devcons_read+0x22>
		return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	eb 4b                	jmp    80104a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800fff:	eb 0c                	jmp    80100d <devcons_read+0x30>
		sys_yield();
  801001:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  801008:	00 00 00 
  80100b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80100d:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  801014:	00 00 00 
  801017:	ff d0                	callq  *%rax
  801019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801020:	74 df                	je     801001 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801026:	79 05                	jns    80102d <devcons_read+0x50>
		return c;
  801028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80102b:	eb 1d                	jmp    80104a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80102d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801031:	75 07                	jne    80103a <devcons_read+0x5d>
		return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	eb 10                	jmp    80104a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80103a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801043:	88 10                	mov    %dl,(%rax)
	return 1;
  801045:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104a:	c9                   	leaveq 
  80104b:	c3                   	retq   

000000000080104c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801057:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80105e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801065:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80106c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801073:	eb 76                	jmp    8010eb <devcons_write+0x9f>
		m = n - tot;
  801075:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801088:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80108b:	83 f8 7f             	cmp    $0x7f,%eax
  80108e:	76 07                	jbe    801097 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801090:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80109a:	48 63 d0             	movslq %eax,%rdx
  80109d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010a0:	48 63 c8             	movslq %eax,%rcx
  8010a3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010aa:	48 01 c1             	add    %rax,%rcx
  8010ad:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010b4:	48 89 ce             	mov    %rcx,%rsi
  8010b7:	48 89 c7             	mov    %rax,%rdi
  8010ba:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  8010c1:	00 00 00 
  8010c4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c9:	48 63 d0             	movslq %eax,%rdx
  8010cc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010d3:	48 89 d6             	mov    %rdx,%rsi
  8010d6:	48 89 c7             	mov    %rax,%rdi
  8010d9:	48 b8 1e 2b 80 00 00 	movabs $0x802b1e,%rax
  8010e0:	00 00 00 
  8010e3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010e8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8010eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ee:	48 98                	cltq   
  8010f0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8010f7:	0f 82 78 ff ff ff    	jb     801075 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8010fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801100:	c9                   	leaveq 
  801101:	c3                   	retq   

0000000000801102 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801102:	55                   	push   %rbp
  801103:	48 89 e5             	mov    %rsp,%rbp
  801106:	48 83 ec 08          	sub    $0x8,%rsp
  80110a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 83 ec 10          	sub    $0x10,%rsp
  80111d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801121:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801129:	48 be 29 5f 80 00 00 	movabs $0x805f29,%rsi
  801130:	00 00 00 
  801133:	48 89 c7             	mov    %rax,%rdi
  801136:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  80113d:	00 00 00 
  801140:	ff d0                	callq  *%rax
	return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 10          	sub    $0x10,%rsp
  801151:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801154:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  801158:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
  801164:	48 98                	cltq   
  801166:	25 ff 03 00 00       	and    $0x3ff,%eax
  80116b:	48 89 c2             	mov    %rax,%rdx
  80116e:	48 89 d0             	mov    %rdx,%rax
  801171:	48 c1 e0 03          	shl    $0x3,%rax
  801175:	48 01 d0             	add    %rdx,%rax
  801178:	48 c1 e0 05          	shl    $0x5,%rax
  80117c:	48 89 c2             	mov    %rax,%rdx
  80117f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801186:	00 00 00 
  801189:	48 01 c2             	add    %rax,%rdx
  80118c:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  801193:	00 00 00 
  801196:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80119d:	7e 14                	jle    8011b3 <libmain+0x6a>
		binaryname = argv[0];
  80119f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a3:	48 8b 10             	mov    (%rax),%rdx
  8011a6:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  8011ad:	00 00 00 
  8011b0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ba:	48 89 d6             	mov    %rdx,%rsi
  8011bd:	89 c7                	mov    %eax,%edi
  8011bf:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011c6:	00 00 00 
  8011c9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8011cb:	48 b8 d9 11 80 00 00 	movabs $0x8011d9,%rax
  8011d2:	00 00 00 
  8011d5:	ff d0                	callq  *%rax
}
  8011d7:	c9                   	leaveq 
  8011d8:	c3                   	retq   

00000000008011d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8011dd:	48 b8 fc 39 80 00 00 	movabs $0x8039fc,%rax
  8011e4:	00 00 00 
  8011e7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8011e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ee:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  8011f5:	00 00 00 
  8011f8:	ff d0                	callq  *%rax
}
  8011fa:	5d                   	pop    %rbp
  8011fb:	c3                   	retq   

00000000008011fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	53                   	push   %rbx
  801201:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801208:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80120f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801215:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80121c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801223:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80122a:	84 c0                	test   %al,%al
  80122c:	74 23                	je     801251 <_panic+0x55>
  80122e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801235:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801239:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80123d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801241:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801245:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801249:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80124d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801251:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801258:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80125f:	00 00 00 
  801262:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801269:	00 00 00 
  80126c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801270:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801277:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80127e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801285:	48 b8 58 80 80 00 00 	movabs $0x808058,%rax
  80128c:	00 00 00 
  80128f:	48 8b 18             	mov    (%rax),%rbx
  801292:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  801299:	00 00 00 
  80129c:	ff d0                	callq  *%rax
  80129e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012ab:	41 89 c8             	mov    %ecx,%r8d
  8012ae:	48 89 d1             	mov    %rdx,%rcx
  8012b1:	48 89 da             	mov    %rbx,%rdx
  8012b4:	89 c6                	mov    %eax,%esi
  8012b6:	48 bf 40 5f 80 00 00 	movabs $0x805f40,%rdi
  8012bd:	00 00 00 
  8012c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c5:	49 b9 35 14 80 00 00 	movabs $0x801435,%r9
  8012cc:	00 00 00 
  8012cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8012d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012e0:	48 89 d6             	mov    %rdx,%rsi
  8012e3:	48 89 c7             	mov    %rax,%rdi
  8012e6:	48 b8 89 13 80 00 00 	movabs $0x801389,%rax
  8012ed:	00 00 00 
  8012f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8012f2:	48 bf 63 5f 80 00 00 	movabs $0x805f63,%rdi
  8012f9:	00 00 00 
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801301:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  801308:	00 00 00 
  80130b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80130d:	cc                   	int3   
  80130e:	eb fd                	jmp    80130d <_panic+0x111>

0000000000801310 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 10          	sub    $0x10,%rsp
  801318:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80131b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80131f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801323:	8b 00                	mov    (%rax),%eax
  801325:	8d 48 01             	lea    0x1(%rax),%ecx
  801328:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80132c:	89 0a                	mov    %ecx,(%rdx)
  80132e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801331:	89 d1                	mov    %edx,%ecx
  801333:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801337:	48 98                	cltq   
  801339:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80133d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801341:	8b 00                	mov    (%rax),%eax
  801343:	3d ff 00 00 00       	cmp    $0xff,%eax
  801348:	75 2c                	jne    801376 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	8b 00                	mov    (%rax),%eax
  801350:	48 98                	cltq   
  801352:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801356:	48 83 c2 08          	add    $0x8,%rdx
  80135a:	48 89 c6             	mov    %rax,%rsi
  80135d:	48 89 d7             	mov    %rdx,%rdi
  801360:	48 b8 1e 2b 80 00 00 	movabs $0x802b1e,%rax
  801367:	00 00 00 
  80136a:	ff d0                	callq  *%rax
		b->idx = 0;
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137a:	8b 40 04             	mov    0x4(%rax),%eax
  80137d:	8d 50 01             	lea    0x1(%rax),%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	89 50 04             	mov    %edx,0x4(%rax)
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801394:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80139b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8013a2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013a9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013b0:	48 8b 0a             	mov    (%rdx),%rcx
  8013b3:	48 89 08             	mov    %rcx,(%rax)
  8013b6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013ba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013be:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013c2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8013c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013cd:	00 00 00 
	b.cnt = 0;
  8013d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8013d7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8013da:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8013e1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8013e8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8013ef:	48 89 c6             	mov    %rax,%rsi
  8013f2:	48 bf 10 13 80 00 00 	movabs $0x801310,%rdi
  8013f9:	00 00 00 
  8013fc:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  801403:	00 00 00 
  801406:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801408:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80140e:	48 98                	cltq   
  801410:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801417:	48 83 c2 08          	add    $0x8,%rdx
  80141b:	48 89 c6             	mov    %rax,%rsi
  80141e:	48 89 d7             	mov    %rdx,%rdi
  801421:	48 b8 1e 2b 80 00 00 	movabs $0x802b1e,%rax
  801428:	00 00 00 
  80142b:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80142d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801433:	c9                   	leaveq 
  801434:	c3                   	retq   

0000000000801435 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801435:	55                   	push   %rbp
  801436:	48 89 e5             	mov    %rsp,%rbp
  801439:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801440:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801447:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80144e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801455:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80145c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801463:	84 c0                	test   %al,%al
  801465:	74 20                	je     801487 <cprintf+0x52>
  801467:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80146b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80146f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801473:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801477:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80147b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80147f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801483:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801487:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80148e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801495:	00 00 00 
  801498:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80149f:	00 00 00 
  8014a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014ad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014b4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8014bb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014c2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014c9:	48 8b 0a             	mov    (%rdx),%rcx
  8014cc:	48 89 08             	mov    %rcx,(%rax)
  8014cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014d3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014d7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014db:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8014df:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8014e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8014ed:	48 89 d6             	mov    %rdx,%rsi
  8014f0:	48 89 c7             	mov    %rax,%rdi
  8014f3:	48 b8 89 13 80 00 00 	movabs $0x801389,%rax
  8014fa:	00 00 00 
  8014fd:	ff d0                	callq  *%rax
  8014ff:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801505:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80150b:	c9                   	leaveq 
  80150c:	c3                   	retq   

000000000080150d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80150d:	55                   	push   %rbp
  80150e:	48 89 e5             	mov    %rsp,%rbp
  801511:	53                   	push   %rbx
  801512:	48 83 ec 38          	sub    $0x38,%rsp
  801516:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801522:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801525:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801529:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80152d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801530:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801534:	77 3b                	ja     801571 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801536:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801539:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80153d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801544:	ba 00 00 00 00       	mov    $0x0,%edx
  801549:	48 f7 f3             	div    %rbx
  80154c:	48 89 c2             	mov    %rax,%rdx
  80154f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801552:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801555:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155d:	41 89 f9             	mov    %edi,%r9d
  801560:	48 89 c7             	mov    %rax,%rdi
  801563:	48 b8 0d 15 80 00 00 	movabs $0x80150d,%rax
  80156a:	00 00 00 
  80156d:	ff d0                	callq  *%rax
  80156f:	eb 1e                	jmp    80158f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801571:	eb 12                	jmp    801585 <printnum+0x78>
			putch(padc, putdat);
  801573:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801577:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80157a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157e:	48 89 ce             	mov    %rcx,%rsi
  801581:	89 d7                	mov    %edx,%edi
  801583:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801585:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801589:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80158d:	7f e4                	jg     801573 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80158f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	ba 00 00 00 00       	mov    $0x0,%edx
  80159b:	48 f7 f1             	div    %rcx
  80159e:	48 89 d0             	mov    %rdx,%rax
  8015a1:	48 ba 48 61 80 00 00 	movabs $0x806148,%rdx
  8015a8:	00 00 00 
  8015ab:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015af:	0f be d0             	movsbl %al,%edx
  8015b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ba:	48 89 ce             	mov    %rcx,%rsi
  8015bd:	89 d7                	mov    %edx,%edi
  8015bf:	ff d0                	callq  *%rax
}
  8015c1:	48 83 c4 38          	add    $0x38,%rsp
  8015c5:	5b                   	pop    %rbx
  8015c6:	5d                   	pop    %rbp
  8015c7:	c3                   	retq   

00000000008015c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8015d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8015db:	7e 52                	jle    80162f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8015dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e1:	8b 00                	mov    (%rax),%eax
  8015e3:	83 f8 30             	cmp    $0x30,%eax
  8015e6:	73 24                	jae    80160c <getuint+0x44>
  8015e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8015f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f4:	8b 00                	mov    (%rax),%eax
  8015f6:	89 c0                	mov    %eax,%eax
  8015f8:	48 01 d0             	add    %rdx,%rax
  8015fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ff:	8b 12                	mov    (%rdx),%edx
  801601:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801604:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801608:	89 0a                	mov    %ecx,(%rdx)
  80160a:	eb 17                	jmp    801623 <getuint+0x5b>
  80160c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801610:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801614:	48 89 d0             	mov    %rdx,%rax
  801617:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80161b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80161f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801623:	48 8b 00             	mov    (%rax),%rax
  801626:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80162a:	e9 a3 00 00 00       	jmpq   8016d2 <getuint+0x10a>
	else if (lflag)
  80162f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801633:	74 4f                	je     801684 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801639:	8b 00                	mov    (%rax),%eax
  80163b:	83 f8 30             	cmp    $0x30,%eax
  80163e:	73 24                	jae    801664 <getuint+0x9c>
  801640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801644:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164c:	8b 00                	mov    (%rax),%eax
  80164e:	89 c0                	mov    %eax,%eax
  801650:	48 01 d0             	add    %rdx,%rax
  801653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801657:	8b 12                	mov    (%rdx),%edx
  801659:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80165c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801660:	89 0a                	mov    %ecx,(%rdx)
  801662:	eb 17                	jmp    80167b <getuint+0xb3>
  801664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801668:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80166c:	48 89 d0             	mov    %rdx,%rax
  80166f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801677:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80167b:	48 8b 00             	mov    (%rax),%rax
  80167e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801682:	eb 4e                	jmp    8016d2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	8b 00                	mov    (%rax),%eax
  80168a:	83 f8 30             	cmp    $0x30,%eax
  80168d:	73 24                	jae    8016b3 <getuint+0xeb>
  80168f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801693:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169b:	8b 00                	mov    (%rax),%eax
  80169d:	89 c0                	mov    %eax,%eax
  80169f:	48 01 d0             	add    %rdx,%rax
  8016a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a6:	8b 12                	mov    (%rdx),%edx
  8016a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016af:	89 0a                	mov    %ecx,(%rdx)
  8016b1:	eb 17                	jmp    8016ca <getuint+0x102>
  8016b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016bb:	48 89 d0             	mov    %rdx,%rax
  8016be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016ca:	8b 00                	mov    (%rax),%eax
  8016cc:	89 c0                	mov    %eax,%eax
  8016ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d6:	c9                   	leaveq 
  8016d7:	c3                   	retq   

00000000008016d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8016e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8016e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8016eb:	7e 52                	jle    80173f <getint+0x67>
		x=va_arg(*ap, long long);
  8016ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f1:	8b 00                	mov    (%rax),%eax
  8016f3:	83 f8 30             	cmp    $0x30,%eax
  8016f6:	73 24                	jae    80171c <getint+0x44>
  8016f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	8b 00                	mov    (%rax),%eax
  801706:	89 c0                	mov    %eax,%eax
  801708:	48 01 d0             	add    %rdx,%rax
  80170b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170f:	8b 12                	mov    (%rdx),%edx
  801711:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801714:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801718:	89 0a                	mov    %ecx,(%rdx)
  80171a:	eb 17                	jmp    801733 <getint+0x5b>
  80171c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801720:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801724:	48 89 d0             	mov    %rdx,%rax
  801727:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80172b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801733:	48 8b 00             	mov    (%rax),%rax
  801736:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80173a:	e9 a3 00 00 00       	jmpq   8017e2 <getint+0x10a>
	else if (lflag)
  80173f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801743:	74 4f                	je     801794 <getint+0xbc>
		x=va_arg(*ap, long);
  801745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801749:	8b 00                	mov    (%rax),%eax
  80174b:	83 f8 30             	cmp    $0x30,%eax
  80174e:	73 24                	jae    801774 <getint+0x9c>
  801750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801754:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175c:	8b 00                	mov    (%rax),%eax
  80175e:	89 c0                	mov    %eax,%eax
  801760:	48 01 d0             	add    %rdx,%rax
  801763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801767:	8b 12                	mov    (%rdx),%edx
  801769:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80176c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801770:	89 0a                	mov    %ecx,(%rdx)
  801772:	eb 17                	jmp    80178b <getint+0xb3>
  801774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801778:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80177c:	48 89 d0             	mov    %rdx,%rax
  80177f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801787:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80178b:	48 8b 00             	mov    (%rax),%rax
  80178e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801792:	eb 4e                	jmp    8017e2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801798:	8b 00                	mov    (%rax),%eax
  80179a:	83 f8 30             	cmp    $0x30,%eax
  80179d:	73 24                	jae    8017c3 <getint+0xeb>
  80179f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ab:	8b 00                	mov    (%rax),%eax
  8017ad:	89 c0                	mov    %eax,%eax
  8017af:	48 01 d0             	add    %rdx,%rax
  8017b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017b6:	8b 12                	mov    (%rdx),%edx
  8017b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017bf:	89 0a                	mov    %ecx,(%rdx)
  8017c1:	eb 17                	jmp    8017da <getint+0x102>
  8017c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017cb:	48 89 d0             	mov    %rdx,%rax
  8017ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017da:	8b 00                	mov    (%rax),%eax
  8017dc:	48 98                	cltq   
  8017de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e6:	c9                   	leaveq 
  8017e7:	c3                   	retq   

00000000008017e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8017e8:	55                   	push   %rbp
  8017e9:	48 89 e5             	mov    %rsp,%rbp
  8017ec:	41 54                	push   %r12
  8017ee:	53                   	push   %rbx
  8017ef:	48 83 ec 60          	sub    $0x60,%rsp
  8017f3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8017f7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8017fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8017ff:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801803:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801807:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80180b:	48 8b 0a             	mov    (%rdx),%rcx
  80180e:	48 89 08             	mov    %rcx,(%rax)
  801811:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801815:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801819:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80181d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  801821:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801825:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801829:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80182d:	0f b6 00             	movzbl (%rax),%eax
  801830:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  801833:	eb 29                	jmp    80185e <vprintfmt+0x76>
			if (ch == '\0')
  801835:	85 db                	test   %ebx,%ebx
  801837:	0f 84 ad 06 00 00    	je     801eea <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80183d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801841:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801845:	48 89 d6             	mov    %rdx,%rsi
  801848:	89 df                	mov    %ebx,%edi
  80184a:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80184c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801850:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801854:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801858:	0f b6 00             	movzbl (%rax),%eax
  80185b:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80185e:	83 fb 25             	cmp    $0x25,%ebx
  801861:	74 05                	je     801868 <vprintfmt+0x80>
  801863:	83 fb 1b             	cmp    $0x1b,%ebx
  801866:	75 cd                	jne    801835 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  801868:	83 fb 1b             	cmp    $0x1b,%ebx
  80186b:	0f 85 ae 01 00 00    	jne    801a1f <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  801871:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801878:	00 00 00 
  80187b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  801881:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801885:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801889:	48 89 d6             	mov    %rdx,%rsi
  80188c:	89 df                	mov    %ebx,%edi
  80188e:	ff d0                	callq  *%rax
			putch('[', putdat);
  801890:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801894:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801898:	48 89 d6             	mov    %rdx,%rsi
  80189b:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8018a0:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8018a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8018a8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8018ad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018b1:	0f b6 00             	movzbl (%rax),%eax
  8018b4:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8018b7:	eb 32                	jmp    8018eb <vprintfmt+0x103>
					putch(ch, putdat);
  8018b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8018bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8018c1:	48 89 d6             	mov    %rdx,%rsi
  8018c4:	89 df                	mov    %ebx,%edi
  8018c6:	ff d0                	callq  *%rax
					esc_color *= 10;
  8018c8:	44 89 e0             	mov    %r12d,%eax
  8018cb:	c1 e0 02             	shl    $0x2,%eax
  8018ce:	44 01 e0             	add    %r12d,%eax
  8018d1:	01 c0                	add    %eax,%eax
  8018d3:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8018d6:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8018d9:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8018dc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8018e1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8018eb:	83 fb 3b             	cmp    $0x3b,%ebx
  8018ee:	74 05                	je     8018f5 <vprintfmt+0x10d>
  8018f0:	83 fb 6d             	cmp    $0x6d,%ebx
  8018f3:	75 c4                	jne    8018b9 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8018f5:	45 85 e4             	test   %r12d,%r12d
  8018f8:	75 15                	jne    80190f <vprintfmt+0x127>
					color_flag = 0x07;
  8018fa:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801901:	00 00 00 
  801904:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80190a:	e9 dc 00 00 00       	jmpq   8019eb <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80190f:	41 83 fc 1d          	cmp    $0x1d,%r12d
  801913:	7e 69                	jle    80197e <vprintfmt+0x196>
  801915:	41 83 fc 25          	cmp    $0x25,%r12d
  801919:	7f 63                	jg     80197e <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  80191b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801922:	00 00 00 
  801925:	8b 00                	mov    (%rax),%eax
  801927:	25 f8 00 00 00       	and    $0xf8,%eax
  80192c:	89 c2                	mov    %eax,%edx
  80192e:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801935:	00 00 00 
  801938:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  80193a:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80193e:	44 89 e0             	mov    %r12d,%eax
  801941:	83 e0 04             	and    $0x4,%eax
  801944:	c1 f8 02             	sar    $0x2,%eax
  801947:	89 c2                	mov    %eax,%edx
  801949:	44 89 e0             	mov    %r12d,%eax
  80194c:	83 e0 02             	and    $0x2,%eax
  80194f:	09 c2                	or     %eax,%edx
  801951:	44 89 e0             	mov    %r12d,%eax
  801954:	83 e0 01             	and    $0x1,%eax
  801957:	c1 e0 02             	shl    $0x2,%eax
  80195a:	09 c2                	or     %eax,%edx
  80195c:	41 89 d4             	mov    %edx,%r12d
  80195f:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801966:	00 00 00 
  801969:	8b 00                	mov    (%rax),%eax
  80196b:	44 89 e2             	mov    %r12d,%edx
  80196e:	09 c2                	or     %eax,%edx
  801970:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801977:	00 00 00 
  80197a:	89 10                	mov    %edx,(%rax)
  80197c:	eb 6d                	jmp    8019eb <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80197e:	41 83 fc 27          	cmp    $0x27,%r12d
  801982:	7e 67                	jle    8019eb <vprintfmt+0x203>
  801984:	41 83 fc 2f          	cmp    $0x2f,%r12d
  801988:	7f 61                	jg     8019eb <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  80198a:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801991:	00 00 00 
  801994:	8b 00                	mov    (%rax),%eax
  801996:	25 8f 00 00 00       	and    $0x8f,%eax
  80199b:	89 c2                	mov    %eax,%edx
  80199d:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8019a4:	00 00 00 
  8019a7:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8019a9:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8019ad:	44 89 e0             	mov    %r12d,%eax
  8019b0:	83 e0 04             	and    $0x4,%eax
  8019b3:	c1 f8 02             	sar    $0x2,%eax
  8019b6:	89 c2                	mov    %eax,%edx
  8019b8:	44 89 e0             	mov    %r12d,%eax
  8019bb:	83 e0 02             	and    $0x2,%eax
  8019be:	09 c2                	or     %eax,%edx
  8019c0:	44 89 e0             	mov    %r12d,%eax
  8019c3:	83 e0 01             	and    $0x1,%eax
  8019c6:	c1 e0 06             	shl    $0x6,%eax
  8019c9:	09 c2                	or     %eax,%edx
  8019cb:	41 89 d4             	mov    %edx,%r12d
  8019ce:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8019d5:	00 00 00 
  8019d8:	8b 00                	mov    (%rax),%eax
  8019da:	44 89 e2             	mov    %r12d,%edx
  8019dd:	09 c2                	or     %eax,%edx
  8019df:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8019e6:	00 00 00 
  8019e9:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8019eb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8019ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019f3:	48 89 d6             	mov    %rdx,%rsi
  8019f6:	89 df                	mov    %ebx,%edi
  8019f8:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8019fa:	83 fb 6d             	cmp    $0x6d,%ebx
  8019fd:	75 1b                	jne    801a1a <vprintfmt+0x232>
					fmt ++;
  8019ff:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  801a04:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  801a05:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801a0c:	00 00 00 
  801a0f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  801a15:	e9 cb 04 00 00       	jmpq   801ee5 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  801a1a:	e9 83 fe ff ff       	jmpq   8018a2 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  801a1f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801a23:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801a2a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801a31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801a38:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a3f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801a43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801a4b:	0f b6 00             	movzbl (%rax),%eax
  801a4e:	0f b6 d8             	movzbl %al,%ebx
  801a51:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801a54:	83 f8 55             	cmp    $0x55,%eax
  801a57:	0f 87 5a 04 00 00    	ja     801eb7 <vprintfmt+0x6cf>
  801a5d:	89 c0                	mov    %eax,%eax
  801a5f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801a66:	00 
  801a67:	48 b8 70 61 80 00 00 	movabs $0x806170,%rax
  801a6e:	00 00 00 
  801a71:	48 01 d0             	add    %rdx,%rax
  801a74:	48 8b 00             	mov    (%rax),%rax
  801a77:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a79:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801a7d:	eb c0                	jmp    801a3f <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a7f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801a83:	eb ba                	jmp    801a3f <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a85:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801a8c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801a8f:	89 d0                	mov    %edx,%eax
  801a91:	c1 e0 02             	shl    $0x2,%eax
  801a94:	01 d0                	add    %edx,%eax
  801a96:	01 c0                	add    %eax,%eax
  801a98:	01 d8                	add    %ebx,%eax
  801a9a:	83 e8 30             	sub    $0x30,%eax
  801a9d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801aa0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801aa4:	0f b6 00             	movzbl (%rax),%eax
  801aa7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801aaa:	83 fb 2f             	cmp    $0x2f,%ebx
  801aad:	7e 0c                	jle    801abb <vprintfmt+0x2d3>
  801aaf:	83 fb 39             	cmp    $0x39,%ebx
  801ab2:	7f 07                	jg     801abb <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ab4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ab9:	eb d1                	jmp    801a8c <vprintfmt+0x2a4>
			goto process_precision;
  801abb:	eb 58                	jmp    801b15 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  801abd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ac0:	83 f8 30             	cmp    $0x30,%eax
  801ac3:	73 17                	jae    801adc <vprintfmt+0x2f4>
  801ac5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801ac9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801acc:	89 c0                	mov    %eax,%eax
  801ace:	48 01 d0             	add    %rdx,%rax
  801ad1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ad4:	83 c2 08             	add    $0x8,%edx
  801ad7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801ada:	eb 0f                	jmp    801aeb <vprintfmt+0x303>
  801adc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ae0:	48 89 d0             	mov    %rdx,%rax
  801ae3:	48 83 c2 08          	add    $0x8,%rdx
  801ae7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aeb:	8b 00                	mov    (%rax),%eax
  801aed:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801af0:	eb 23                	jmp    801b15 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  801af2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801af6:	79 0c                	jns    801b04 <vprintfmt+0x31c>
				width = 0;
  801af8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801aff:	e9 3b ff ff ff       	jmpq   801a3f <vprintfmt+0x257>
  801b04:	e9 36 ff ff ff       	jmpq   801a3f <vprintfmt+0x257>

		case '#':
			altflag = 1;
  801b09:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801b10:	e9 2a ff ff ff       	jmpq   801a3f <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  801b15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b19:	79 12                	jns    801b2d <vprintfmt+0x345>
				width = precision, precision = -1;
  801b1b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801b1e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801b21:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801b28:	e9 12 ff ff ff       	jmpq   801a3f <vprintfmt+0x257>
  801b2d:	e9 0d ff ff ff       	jmpq   801a3f <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b32:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801b36:	e9 04 ff ff ff       	jmpq   801a3f <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801b3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b3e:	83 f8 30             	cmp    $0x30,%eax
  801b41:	73 17                	jae    801b5a <vprintfmt+0x372>
  801b43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801b47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b4a:	89 c0                	mov    %eax,%eax
  801b4c:	48 01 d0             	add    %rdx,%rax
  801b4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b52:	83 c2 08             	add    $0x8,%edx
  801b55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b58:	eb 0f                	jmp    801b69 <vprintfmt+0x381>
  801b5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801b5e:	48 89 d0             	mov    %rdx,%rax
  801b61:	48 83 c2 08          	add    $0x8,%rdx
  801b65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b69:	8b 10                	mov    (%rax),%edx
  801b6b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801b6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b73:	48 89 ce             	mov    %rcx,%rsi
  801b76:	89 d7                	mov    %edx,%edi
  801b78:	ff d0                	callq  *%rax
			break;
  801b7a:	e9 66 03 00 00       	jmpq   801ee5 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  801b7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b82:	83 f8 30             	cmp    $0x30,%eax
  801b85:	73 17                	jae    801b9e <vprintfmt+0x3b6>
  801b87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801b8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b8e:	89 c0                	mov    %eax,%eax
  801b90:	48 01 d0             	add    %rdx,%rax
  801b93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b96:	83 c2 08             	add    $0x8,%edx
  801b99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b9c:	eb 0f                	jmp    801bad <vprintfmt+0x3c5>
  801b9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801ba2:	48 89 d0             	mov    %rdx,%rax
  801ba5:	48 83 c2 08          	add    $0x8,%rdx
  801ba9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801bad:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801baf:	85 db                	test   %ebx,%ebx
  801bb1:	79 02                	jns    801bb5 <vprintfmt+0x3cd>
				err = -err;
  801bb3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bb5:	83 fb 10             	cmp    $0x10,%ebx
  801bb8:	7f 16                	jg     801bd0 <vprintfmt+0x3e8>
  801bba:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  801bc1:	00 00 00 
  801bc4:	48 63 d3             	movslq %ebx,%rdx
  801bc7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801bcb:	4d 85 e4             	test   %r12,%r12
  801bce:	75 2e                	jne    801bfe <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  801bd0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801bd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bd8:	89 d9                	mov    %ebx,%ecx
  801bda:	48 ba 59 61 80 00 00 	movabs $0x806159,%rdx
  801be1:	00 00 00 
  801be4:	48 89 c7             	mov    %rax,%rdi
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bec:	49 b8 f3 1e 80 00 00 	movabs $0x801ef3,%r8
  801bf3:	00 00 00 
  801bf6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bf9:	e9 e7 02 00 00       	jmpq   801ee5 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bfe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801c02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c06:	4c 89 e1             	mov    %r12,%rcx
  801c09:	48 ba 62 61 80 00 00 	movabs $0x806162,%rdx
  801c10:	00 00 00 
  801c13:	48 89 c7             	mov    %rax,%rdi
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1b:	49 b8 f3 1e 80 00 00 	movabs $0x801ef3,%r8
  801c22:	00 00 00 
  801c25:	41 ff d0             	callq  *%r8
			break;
  801c28:	e9 b8 02 00 00       	jmpq   801ee5 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801c2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c30:	83 f8 30             	cmp    $0x30,%eax
  801c33:	73 17                	jae    801c4c <vprintfmt+0x464>
  801c35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c3c:	89 c0                	mov    %eax,%eax
  801c3e:	48 01 d0             	add    %rdx,%rax
  801c41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c44:	83 c2 08             	add    $0x8,%edx
  801c47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801c4a:	eb 0f                	jmp    801c5b <vprintfmt+0x473>
  801c4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c50:	48 89 d0             	mov    %rdx,%rax
  801c53:	48 83 c2 08          	add    $0x8,%rdx
  801c57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c5b:	4c 8b 20             	mov    (%rax),%r12
  801c5e:	4d 85 e4             	test   %r12,%r12
  801c61:	75 0a                	jne    801c6d <vprintfmt+0x485>
				p = "(null)";
  801c63:	49 bc 65 61 80 00 00 	movabs $0x806165,%r12
  801c6a:	00 00 00 
			if (width > 0 && padc != '-')
  801c6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c71:	7e 3f                	jle    801cb2 <vprintfmt+0x4ca>
  801c73:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801c77:	74 39                	je     801cb2 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c79:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801c7c:	48 98                	cltq   
  801c7e:	48 89 c6             	mov    %rax,%rsi
  801c81:	4c 89 e7             	mov    %r12,%rdi
  801c84:	48 b8 f9 22 80 00 00 	movabs $0x8022f9,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
  801c90:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801c93:	eb 17                	jmp    801cac <vprintfmt+0x4c4>
					putch(padc, putdat);
  801c95:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801c99:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801c9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ca1:	48 89 ce             	mov    %rcx,%rsi
  801ca4:	89 d7                	mov    %edx,%edi
  801ca6:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ca8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801cac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801cb0:	7f e3                	jg     801c95 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cb2:	eb 37                	jmp    801ceb <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  801cb4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801cb8:	74 1e                	je     801cd8 <vprintfmt+0x4f0>
  801cba:	83 fb 1f             	cmp    $0x1f,%ebx
  801cbd:	7e 05                	jle    801cc4 <vprintfmt+0x4dc>
  801cbf:	83 fb 7e             	cmp    $0x7e,%ebx
  801cc2:	7e 14                	jle    801cd8 <vprintfmt+0x4f0>
					putch('?', putdat);
  801cc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ccc:	48 89 d6             	mov    %rdx,%rsi
  801ccf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801cd4:	ff d0                	callq  *%rax
  801cd6:	eb 0f                	jmp    801ce7 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  801cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ce0:	48 89 d6             	mov    %rdx,%rsi
  801ce3:	89 df                	mov    %ebx,%edi
  801ce5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ce7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801ceb:	4c 89 e0             	mov    %r12,%rax
  801cee:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801cf2:	0f b6 00             	movzbl (%rax),%eax
  801cf5:	0f be d8             	movsbl %al,%ebx
  801cf8:	85 db                	test   %ebx,%ebx
  801cfa:	74 10                	je     801d0c <vprintfmt+0x524>
  801cfc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d00:	78 b2                	js     801cb4 <vprintfmt+0x4cc>
  801d02:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801d06:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801d0a:	79 a8                	jns    801cb4 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d0c:	eb 16                	jmp    801d24 <vprintfmt+0x53c>
				putch(' ', putdat);
  801d0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d16:	48 89 d6             	mov    %rdx,%rsi
  801d19:	bf 20 00 00 00       	mov    $0x20,%edi
  801d1e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d20:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801d24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801d28:	7f e4                	jg     801d0e <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  801d2a:	e9 b6 01 00 00       	jmpq   801ee5 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801d2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d33:	be 03 00 00 00       	mov    $0x3,%esi
  801d38:	48 89 c7             	mov    %rax,%rdi
  801d3b:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801d42:	00 00 00 
  801d45:	ff d0                	callq  *%rax
  801d47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801d4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4f:	48 85 c0             	test   %rax,%rax
  801d52:	79 1d                	jns    801d71 <vprintfmt+0x589>
				putch('-', putdat);
  801d54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d5c:	48 89 d6             	mov    %rdx,%rsi
  801d5f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801d64:	ff d0                	callq  *%rax
				num = -(long long) num;
  801d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6a:	48 f7 d8             	neg    %rax
  801d6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801d71:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801d78:	e9 fb 00 00 00       	jmpq   801e78 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801d7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d81:	be 03 00 00 00       	mov    $0x3,%esi
  801d86:	48 89 c7             	mov    %rax,%rdi
  801d89:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  801d90:	00 00 00 
  801d93:	ff d0                	callq  *%rax
  801d95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801d99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801da0:	e9 d3 00 00 00       	jmpq   801e78 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  801da5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801da9:	be 03 00 00 00       	mov    $0x3,%esi
  801dae:	48 89 c7             	mov    %rax,%rdi
  801db1:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801db8:	00 00 00 
  801dbb:	ff d0                	callq  *%rax
  801dbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc5:	48 85 c0             	test   %rax,%rax
  801dc8:	79 1d                	jns    801de7 <vprintfmt+0x5ff>
				putch('-', putdat);
  801dca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dd2:	48 89 d6             	mov    %rdx,%rsi
  801dd5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801dda:	ff d0                	callq  *%rax
				num = -(long long) num;
  801ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de0:	48 f7 d8             	neg    %rax
  801de3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  801de7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801dee:	e9 85 00 00 00       	jmpq   801e78 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801df3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dfb:	48 89 d6             	mov    %rdx,%rsi
  801dfe:	bf 30 00 00 00       	mov    $0x30,%edi
  801e03:	ff d0                	callq  *%rax
			putch('x', putdat);
  801e05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801e09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801e0d:	48 89 d6             	mov    %rdx,%rsi
  801e10:	bf 78 00 00 00       	mov    $0x78,%edi
  801e15:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801e17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e1a:	83 f8 30             	cmp    $0x30,%eax
  801e1d:	73 17                	jae    801e36 <vprintfmt+0x64e>
  801e1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801e23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801e26:	89 c0                	mov    %eax,%eax
  801e28:	48 01 d0             	add    %rdx,%rax
  801e2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801e2e:	83 c2 08             	add    $0x8,%edx
  801e31:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e34:	eb 0f                	jmp    801e45 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801e36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e3a:	48 89 d0             	mov    %rdx,%rax
  801e3d:	48 83 c2 08          	add    $0x8,%rdx
  801e41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801e45:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801e4c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801e53:	eb 23                	jmp    801e78 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801e55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801e59:	be 03 00 00 00       	mov    $0x3,%esi
  801e5e:	48 89 c7             	mov    %rax,%rdi
  801e61:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	callq  *%rax
  801e6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801e71:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e78:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801e7d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801e80:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801e83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e87:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801e8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801e8f:	45 89 c1             	mov    %r8d,%r9d
  801e92:	41 89 f8             	mov    %edi,%r8d
  801e95:	48 89 c7             	mov    %rax,%rdi
  801e98:	48 b8 0d 15 80 00 00 	movabs $0x80150d,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	callq  *%rax
			break;
  801ea4:	eb 3f                	jmp    801ee5 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ea6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801eaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801eae:	48 89 d6             	mov    %rdx,%rsi
  801eb1:	89 df                	mov    %ebx,%edi
  801eb3:	ff d0                	callq  *%rax
			break;
  801eb5:	eb 2e                	jmp    801ee5 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801eb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801ebb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ebf:	48 89 d6             	mov    %rdx,%rsi
  801ec2:	bf 25 00 00 00       	mov    $0x25,%edi
  801ec7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ec9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801ece:	eb 05                	jmp    801ed5 <vprintfmt+0x6ed>
  801ed0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801ed5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801ed9:	48 83 e8 01          	sub    $0x1,%rax
  801edd:	0f b6 00             	movzbl (%rax),%eax
  801ee0:	3c 25                	cmp    $0x25,%al
  801ee2:	75 ec                	jne    801ed0 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801ee4:	90                   	nop
		}
	}
  801ee5:	e9 37 f9 ff ff       	jmpq   801821 <vprintfmt+0x39>
    va_end(aq);
}
  801eea:	48 83 c4 60          	add    $0x60,%rsp
  801eee:	5b                   	pop    %rbx
  801eef:	41 5c                	pop    %r12
  801ef1:	5d                   	pop    %rbp
  801ef2:	c3                   	retq   

0000000000801ef3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ef3:	55                   	push   %rbp
  801ef4:	48 89 e5             	mov    %rsp,%rbp
  801ef7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801efe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801f05:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801f0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801f13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801f1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801f21:	84 c0                	test   %al,%al
  801f23:	74 20                	je     801f45 <printfmt+0x52>
  801f25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801f29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801f2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f45:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801f4c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801f53:	00 00 00 
  801f56:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801f5d:	00 00 00 
  801f60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f64:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801f6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f72:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801f79:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801f80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801f87:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801f8e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801f95:	48 89 c7             	mov    %rax,%rdi
  801f98:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	callq  *%rax
	va_end(ap);
}
  801fa4:	c9                   	leaveq 
  801fa5:	c3                   	retq   

0000000000801fa6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801fa6:	55                   	push   %rbp
  801fa7:	48 89 e5             	mov    %rsp,%rbp
  801faa:	48 83 ec 10          	sub    $0x10,%rsp
  801fae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb9:	8b 40 10             	mov    0x10(%rax),%eax
  801fbc:	8d 50 01             	lea    0x1(%rax),%edx
  801fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fca:	48 8b 10             	mov    (%rax),%rdx
  801fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd1:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fd5:	48 39 c2             	cmp    %rax,%rdx
  801fd8:	73 17                	jae    801ff1 <sprintputch+0x4b>
		*b->buf++ = ch;
  801fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fde:	48 8b 00             	mov    (%rax),%rax
  801fe1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801fe5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fe9:	48 89 0a             	mov    %rcx,(%rdx)
  801fec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fef:	88 10                	mov    %dl,(%rax)
}
  801ff1:	c9                   	leaveq 
  801ff2:	c3                   	retq   

0000000000801ff3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ff3:	55                   	push   %rbp
  801ff4:	48 89 e5             	mov    %rsp,%rbp
  801ff7:	48 83 ec 50          	sub    $0x50,%rsp
  801ffb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801fff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802002:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802006:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80200a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80200e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802012:	48 8b 0a             	mov    (%rdx),%rcx
  802015:	48 89 08             	mov    %rcx,(%rax)
  802018:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80201c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802020:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802024:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802028:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80202c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802030:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802033:	48 98                	cltq   
  802035:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802039:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80203d:	48 01 d0             	add    %rdx,%rax
  802040:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802044:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80204b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802050:	74 06                	je     802058 <vsnprintf+0x65>
  802052:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802056:	7f 07                	jg     80205f <vsnprintf+0x6c>
		return -E_INVAL;
  802058:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80205d:	eb 2f                	jmp    80208e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80205f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802063:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802067:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80206b:	48 89 c6             	mov    %rax,%rsi
  80206e:	48 bf a6 1f 80 00 00 	movabs $0x801fa6,%rdi
  802075:	00 00 00 
  802078:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802084:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802088:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80208b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80208e:	c9                   	leaveq 
  80208f:	c3                   	retq   

0000000000802090 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802090:	55                   	push   %rbp
  802091:	48 89 e5             	mov    %rsp,%rbp
  802094:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80209b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8020a2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8020a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8020af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8020b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8020bd:	84 c0                	test   %al,%al
  8020bf:	74 20                	je     8020e1 <snprintf+0x51>
  8020c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8020c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8020c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8020cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8020d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8020d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8020d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8020dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8020e1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8020e8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8020ef:	00 00 00 
  8020f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8020f9:	00 00 00 
  8020fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802100:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802107:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80210e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802115:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80211c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802123:	48 8b 0a             	mov    (%rdx),%rcx
  802126:	48 89 08             	mov    %rcx,(%rax)
  802129:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80212d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802131:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802135:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802139:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802140:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802147:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80214d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802154:	48 89 c7             	mov    %rax,%rdi
  802157:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  80215e:	00 00 00 
  802161:	ff d0                	callq  *%rax
  802163:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802169:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 20          	sub    $0x20,%rsp
  802179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80217d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802182:	74 27                	je     8021ab <readline+0x3a>
		fprintf(1, "%s", prompt);
  802184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802188:	48 89 c2             	mov    %rax,%rdx
  80218b:	48 be 20 64 80 00 00 	movabs $0x806420,%rsi
  802192:	00 00 00 
  802195:	bf 01 00 00 00       	mov    $0x1,%edi
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	48 b9 d1 45 80 00 00 	movabs $0x8045d1,%rcx
  8021a6:	00 00 00 
  8021a9:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8021ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8021b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b7:	48 b8 0a 0f 80 00 00 	movabs $0x800f0a,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax
  8021c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8021c6:	48 b8 c1 0e 80 00 00 	movabs $0x800ec1,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8021d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021d9:	79 30                	jns    80220b <readline+0x9a>
			if (c != -E_EOF)
  8021db:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8021df:	74 20                	je     802201 <readline+0x90>
				cprintf("read error: %e\n", c);
  8021e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021e4:	89 c6                	mov    %eax,%esi
  8021e6:	48 bf 23 64 80 00 00 	movabs $0x806423,%rdi
  8021ed:	00 00 00 
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	48 ba 35 14 80 00 00 	movabs $0x801435,%rdx
  8021fc:	00 00 00 
  8021ff:	ff d2                	callq  *%rdx
			return NULL;
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	e9 be 00 00 00       	jmpq   8022c9 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80220b:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80220f:	74 06                	je     802217 <readline+0xa6>
  802211:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802215:	75 26                	jne    80223d <readline+0xcc>
  802217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221b:	7e 20                	jle    80223d <readline+0xcc>
			if (echoing)
  80221d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802221:	74 11                	je     802234 <readline+0xc3>
				cputchar('\b');
  802223:	bf 08 00 00 00       	mov    $0x8,%edi
  802228:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  80222f:	00 00 00 
  802232:	ff d0                	callq  *%rax
			i--;
  802234:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802238:	e9 87 00 00 00       	jmpq   8022c4 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80223d:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802241:	7e 3f                	jle    802282 <readline+0x111>
  802243:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80224a:	7f 36                	jg     802282 <readline+0x111>
			if (echoing)
  80224c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802250:	74 11                	je     802263 <readline+0xf2>
				cputchar(c);
  802252:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802255:	89 c7                	mov    %eax,%edi
  802257:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
			buf[i++] = c;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802266:	8d 50 01             	lea    0x1(%rax),%edx
  802269:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80226c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80226f:	89 d1                	mov    %edx,%ecx
  802271:	48 ba 40 90 80 00 00 	movabs $0x809040,%rdx
  802278:	00 00 00 
  80227b:	48 98                	cltq   
  80227d:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  802280:	eb 42                	jmp    8022c4 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  802282:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  802286:	74 06                	je     80228e <readline+0x11d>
  802288:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80228c:	75 36                	jne    8022c4 <readline+0x153>
			if (echoing)
  80228e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802292:	74 11                	je     8022a5 <readline+0x134>
				cputchar('\n');
  802294:	bf 0a 00 00 00       	mov    $0xa,%edi
  802299:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  8022a0:	00 00 00 
  8022a3:	ff d0                	callq  *%rax
			buf[i] = 0;
  8022a5:	48 ba 40 90 80 00 00 	movabs $0x809040,%rdx
  8022ac:	00 00 00 
  8022af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b2:	48 98                	cltq   
  8022b4:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8022b8:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  8022bf:	00 00 00 
  8022c2:	eb 05                	jmp    8022c9 <readline+0x158>
		}
	}
  8022c4:	e9 fd fe ff ff       	jmpq   8021c6 <readline+0x55>
}
  8022c9:	c9                   	leaveq 
  8022ca:	c3                   	retq   

00000000008022cb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8022cb:	55                   	push   %rbp
  8022cc:	48 89 e5             	mov    %rsp,%rbp
  8022cf:	48 83 ec 18          	sub    $0x18,%rsp
  8022d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8022d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022de:	eb 09                	jmp    8022e9 <strlen+0x1e>
		n++;
  8022e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8022e4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8022e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ed:	0f b6 00             	movzbl (%rax),%eax
  8022f0:	84 c0                	test   %al,%al
  8022f2:	75 ec                	jne    8022e0 <strlen+0x15>
		n++;
	return n;
  8022f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f7:	c9                   	leaveq 
  8022f8:	c3                   	retq   

00000000008022f9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8022f9:	55                   	push   %rbp
  8022fa:	48 89 e5             	mov    %rsp,%rbp
  8022fd:	48 83 ec 20          	sub    $0x20,%rsp
  802301:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802305:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802310:	eb 0e                	jmp    802320 <strnlen+0x27>
		n++;
  802312:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802316:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80231b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802320:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802325:	74 0b                	je     802332 <strnlen+0x39>
  802327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232b:	0f b6 00             	movzbl (%rax),%eax
  80232e:	84 c0                	test   %al,%al
  802330:	75 e0                	jne    802312 <strnlen+0x19>
		n++;
	return n;
  802332:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802335:	c9                   	leaveq 
  802336:	c3                   	retq   

0000000000802337 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802337:	55                   	push   %rbp
  802338:	48 89 e5             	mov    %rsp,%rbp
  80233b:	48 83 ec 20          	sub    $0x20,%rsp
  80233f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802343:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80234f:	90                   	nop
  802350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802354:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802358:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80235c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802360:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802364:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802368:	0f b6 12             	movzbl (%rdx),%edx
  80236b:	88 10                	mov    %dl,(%rax)
  80236d:	0f b6 00             	movzbl (%rax),%eax
  802370:	84 c0                	test   %al,%al
  802372:	75 dc                	jne    802350 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802378:	c9                   	leaveq 
  802379:	c3                   	retq   

000000000080237a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80237a:	55                   	push   %rbp
  80237b:	48 89 e5             	mov    %rsp,%rbp
  80237e:	48 83 ec 20          	sub    $0x20,%rsp
  802382:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802386:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80238a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238e:	48 89 c7             	mov    %rax,%rdi
  802391:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  802398:	00 00 00 
  80239b:	ff d0                	callq  *%rax
  80239d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8023a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a3:	48 63 d0             	movslq %eax,%rdx
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	48 01 c2             	add    %rax,%rdx
  8023ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b1:	48 89 c6             	mov    %rax,%rsi
  8023b4:	48 89 d7             	mov    %rdx,%rdi
  8023b7:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	callq  *%rax
	return dst;
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8023c7:	c9                   	leaveq 
  8023c8:	c3                   	retq   

00000000008023c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	48 83 ec 28          	sub    $0x28,%rsp
  8023d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8023dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8023e5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8023ec:	00 
  8023ed:	eb 2a                	jmp    802419 <strncpy+0x50>
		*dst++ = *src;
  8023ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023ff:	0f b6 12             	movzbl (%rdx),%edx
  802402:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802404:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802408:	0f b6 00             	movzbl (%rax),%eax
  80240b:	84 c0                	test   %al,%al
  80240d:	74 05                	je     802414 <strncpy+0x4b>
			src++;
  80240f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802414:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80241d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802421:	72 cc                	jb     8023ef <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 28          	sub    $0x28,%rsp
  802431:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802435:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802439:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80243d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802441:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802445:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80244a:	74 3d                	je     802489 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80244c:	eb 1d                	jmp    80246b <strlcpy+0x42>
			*dst++ = *src++;
  80244e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802452:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802456:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80245a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80245e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802462:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802466:	0f b6 12             	movzbl (%rdx),%edx
  802469:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80246b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802470:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802475:	74 0b                	je     802482 <strlcpy+0x59>
  802477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247b:	0f b6 00             	movzbl (%rax),%eax
  80247e:	84 c0                	test   %al,%al
  802480:	75 cc                	jne    80244e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802486:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802489:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80248d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802491:	48 29 c2             	sub    %rax,%rdx
  802494:	48 89 d0             	mov    %rdx,%rax
}
  802497:	c9                   	leaveq 
  802498:	c3                   	retq   

0000000000802499 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802499:	55                   	push   %rbp
  80249a:	48 89 e5             	mov    %rsp,%rbp
  80249d:	48 83 ec 10          	sub    $0x10,%rsp
  8024a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8024a9:	eb 0a                	jmp    8024b5 <strcmp+0x1c>
		p++, q++;
  8024ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8024b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b9:	0f b6 00             	movzbl (%rax),%eax
  8024bc:	84 c0                	test   %al,%al
  8024be:	74 12                	je     8024d2 <strcmp+0x39>
  8024c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c4:	0f b6 10             	movzbl (%rax),%edx
  8024c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cb:	0f b6 00             	movzbl (%rax),%eax
  8024ce:	38 c2                	cmp    %al,%dl
  8024d0:	74 d9                	je     8024ab <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8024d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d6:	0f b6 00             	movzbl (%rax),%eax
  8024d9:	0f b6 d0             	movzbl %al,%edx
  8024dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e0:	0f b6 00             	movzbl (%rax),%eax
  8024e3:	0f b6 c0             	movzbl %al,%eax
  8024e6:	29 c2                	sub    %eax,%edx
  8024e8:	89 d0                	mov    %edx,%eax
}
  8024ea:	c9                   	leaveq 
  8024eb:	c3                   	retq   

00000000008024ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8024ec:	55                   	push   %rbp
  8024ed:	48 89 e5             	mov    %rsp,%rbp
  8024f0:	48 83 ec 18          	sub    $0x18,%rsp
  8024f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802500:	eb 0f                	jmp    802511 <strncmp+0x25>
		n--, p++, q++;
  802502:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802507:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80250c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802511:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802516:	74 1d                	je     802535 <strncmp+0x49>
  802518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251c:	0f b6 00             	movzbl (%rax),%eax
  80251f:	84 c0                	test   %al,%al
  802521:	74 12                	je     802535 <strncmp+0x49>
  802523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802527:	0f b6 10             	movzbl (%rax),%edx
  80252a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252e:	0f b6 00             	movzbl (%rax),%eax
  802531:	38 c2                	cmp    %al,%dl
  802533:	74 cd                	je     802502 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802535:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80253a:	75 07                	jne    802543 <strncmp+0x57>
		return 0;
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
  802541:	eb 18                	jmp    80255b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802547:	0f b6 00             	movzbl (%rax),%eax
  80254a:	0f b6 d0             	movzbl %al,%edx
  80254d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802551:	0f b6 00             	movzbl (%rax),%eax
  802554:	0f b6 c0             	movzbl %al,%eax
  802557:	29 c2                	sub    %eax,%edx
  802559:	89 d0                	mov    %edx,%eax
}
  80255b:	c9                   	leaveq 
  80255c:	c3                   	retq   

000000000080255d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80255d:	55                   	push   %rbp
  80255e:	48 89 e5             	mov    %rsp,%rbp
  802561:	48 83 ec 0c          	sub    $0xc,%rsp
  802565:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802569:	89 f0                	mov    %esi,%eax
  80256b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80256e:	eb 17                	jmp    802587 <strchr+0x2a>
		if (*s == c)
  802570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802574:	0f b6 00             	movzbl (%rax),%eax
  802577:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80257a:	75 06                	jne    802582 <strchr+0x25>
			return (char *) s;
  80257c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802580:	eb 15                	jmp    802597 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802582:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258b:	0f b6 00             	movzbl (%rax),%eax
  80258e:	84 c0                	test   %al,%al
  802590:	75 de                	jne    802570 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802597:	c9                   	leaveq 
  802598:	c3                   	retq   

0000000000802599 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802599:	55                   	push   %rbp
  80259a:	48 89 e5             	mov    %rsp,%rbp
  80259d:	48 83 ec 0c          	sub    $0xc,%rsp
  8025a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8025aa:	eb 13                	jmp    8025bf <strfind+0x26>
		if (*s == c)
  8025ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025b0:	0f b6 00             	movzbl (%rax),%eax
  8025b3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8025b6:	75 02                	jne    8025ba <strfind+0x21>
			break;
  8025b8:	eb 10                	jmp    8025ca <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8025ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8025bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c3:	0f b6 00             	movzbl (%rax),%eax
  8025c6:	84 c0                	test   %al,%al
  8025c8:	75 e2                	jne    8025ac <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8025ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8025ce:	c9                   	leaveq 
  8025cf:	c3                   	retq   

00000000008025d0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8025d0:	55                   	push   %rbp
  8025d1:	48 89 e5             	mov    %rsp,%rbp
  8025d4:	48 83 ec 18          	sub    $0x18,%rsp
  8025d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025dc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8025df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8025e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025e8:	75 06                	jne    8025f0 <memset+0x20>
		return v;
  8025ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ee:	eb 69                	jmp    802659 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8025f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025f4:	83 e0 03             	and    $0x3,%eax
  8025f7:	48 85 c0             	test   %rax,%rax
  8025fa:	75 48                	jne    802644 <memset+0x74>
  8025fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802600:	83 e0 03             	and    $0x3,%eax
  802603:	48 85 c0             	test   %rax,%rax
  802606:	75 3c                	jne    802644 <memset+0x74>
		c &= 0xFF;
  802608:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80260f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802612:	c1 e0 18             	shl    $0x18,%eax
  802615:	89 c2                	mov    %eax,%edx
  802617:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80261a:	c1 e0 10             	shl    $0x10,%eax
  80261d:	09 c2                	or     %eax,%edx
  80261f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802622:	c1 e0 08             	shl    $0x8,%eax
  802625:	09 d0                	or     %edx,%eax
  802627:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80262a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262e:	48 c1 e8 02          	shr    $0x2,%rax
  802632:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802635:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802639:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80263c:	48 89 d7             	mov    %rdx,%rdi
  80263f:	fc                   	cld    
  802640:	f3 ab                	rep stos %eax,%es:(%rdi)
  802642:	eb 11                	jmp    802655 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802648:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80264b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80264f:	48 89 d7             	mov    %rdx,%rdi
  802652:	fc                   	cld    
  802653:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802659:	c9                   	leaveq 
  80265a:	c3                   	retq   

000000000080265b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80265b:	55                   	push   %rbp
  80265c:	48 89 e5             	mov    %rsp,%rbp
  80265f:	48 83 ec 28          	sub    $0x28,%rsp
  802663:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802667:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80266b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80266f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802673:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80267f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802683:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802687:	0f 83 88 00 00 00    	jae    802715 <memmove+0xba>
  80268d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802691:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802695:	48 01 d0             	add    %rdx,%rax
  802698:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80269c:	76 77                	jbe    802715 <memmove+0xba>
		s += n;
  80269e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8026a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026aa:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8026ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026b2:	83 e0 03             	and    $0x3,%eax
  8026b5:	48 85 c0             	test   %rax,%rax
  8026b8:	75 3b                	jne    8026f5 <memmove+0x9a>
  8026ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026be:	83 e0 03             	and    $0x3,%eax
  8026c1:	48 85 c0             	test   %rax,%rax
  8026c4:	75 2f                	jne    8026f5 <memmove+0x9a>
  8026c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ca:	83 e0 03             	and    $0x3,%eax
  8026cd:	48 85 c0             	test   %rax,%rax
  8026d0:	75 23                	jne    8026f5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8026d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d6:	48 83 e8 04          	sub    $0x4,%rax
  8026da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026de:	48 83 ea 04          	sub    $0x4,%rdx
  8026e2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8026e6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8026ea:	48 89 c7             	mov    %rax,%rdi
  8026ed:	48 89 d6             	mov    %rdx,%rsi
  8026f0:	fd                   	std    
  8026f1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8026f3:	eb 1d                	jmp    802712 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8026f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8026fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802701:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802709:	48 89 d7             	mov    %rdx,%rdi
  80270c:	48 89 c1             	mov    %rax,%rcx
  80270f:	fd                   	std    
  802710:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802712:	fc                   	cld    
  802713:	eb 57                	jmp    80276c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802719:	83 e0 03             	and    $0x3,%eax
  80271c:	48 85 c0             	test   %rax,%rax
  80271f:	75 36                	jne    802757 <memmove+0xfc>
  802721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802725:	83 e0 03             	and    $0x3,%eax
  802728:	48 85 c0             	test   %rax,%rax
  80272b:	75 2a                	jne    802757 <memmove+0xfc>
  80272d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802731:	83 e0 03             	and    $0x3,%eax
  802734:	48 85 c0             	test   %rax,%rax
  802737:	75 1e                	jne    802757 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273d:	48 c1 e8 02          	shr    $0x2,%rax
  802741:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802748:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80274c:	48 89 c7             	mov    %rax,%rdi
  80274f:	48 89 d6             	mov    %rdx,%rsi
  802752:	fc                   	cld    
  802753:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802755:	eb 15                	jmp    80276c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80275f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802763:	48 89 c7             	mov    %rax,%rdi
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	fc                   	cld    
  80276a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80276c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802770:	c9                   	leaveq 
  802771:	c3                   	retq   

0000000000802772 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802772:	55                   	push   %rbp
  802773:	48 89 e5             	mov    %rsp,%rbp
  802776:	48 83 ec 18          	sub    $0x18,%rsp
  80277a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80277e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802782:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80278a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80278e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802792:	48 89 ce             	mov    %rcx,%rsi
  802795:	48 89 c7             	mov    %rax,%rdi
  802798:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	callq  *%rax
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 28          	sub    $0x28,%rsp
  8027ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8027ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8027c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8027ca:	eb 36                	jmp    802802 <memcmp+0x5c>
		if (*s1 != *s2)
  8027cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d0:	0f b6 10             	movzbl (%rax),%edx
  8027d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d7:	0f b6 00             	movzbl (%rax),%eax
  8027da:	38 c2                	cmp    %al,%dl
  8027dc:	74 1a                	je     8027f8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8027de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e2:	0f b6 00             	movzbl (%rax),%eax
  8027e5:	0f b6 d0             	movzbl %al,%edx
  8027e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ec:	0f b6 00             	movzbl (%rax),%eax
  8027ef:	0f b6 c0             	movzbl %al,%eax
  8027f2:	29 c2                	sub    %eax,%edx
  8027f4:	89 d0                	mov    %edx,%eax
  8027f6:	eb 20                	jmp    802818 <memcmp+0x72>
		s1++, s2++;
  8027f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8027fd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802806:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80280a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80280e:	48 85 c0             	test   %rax,%rax
  802811:	75 b9                	jne    8027cc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802818:	c9                   	leaveq 
  802819:	c3                   	retq   

000000000080281a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80281a:	55                   	push   %rbp
  80281b:	48 89 e5             	mov    %rsp,%rbp
  80281e:	48 83 ec 28          	sub    $0x28,%rsp
  802822:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802826:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802829:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80282d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802835:	48 01 d0             	add    %rdx,%rax
  802838:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80283c:	eb 15                	jmp    802853 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80283e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802842:	0f b6 10             	movzbl (%rax),%edx
  802845:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802848:	38 c2                	cmp    %al,%dl
  80284a:	75 02                	jne    80284e <memfind+0x34>
			break;
  80284c:	eb 0f                	jmp    80285d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80284e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802853:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802857:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80285b:	72 e1                	jb     80283e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80285d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802861:	c9                   	leaveq 
  802862:	c3                   	retq   

0000000000802863 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802863:	55                   	push   %rbp
  802864:	48 89 e5             	mov    %rsp,%rbp
  802867:	48 83 ec 34          	sub    $0x34,%rsp
  80286b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80286f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802873:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802876:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80287d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802884:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802885:	eb 05                	jmp    80288c <strtol+0x29>
		s++;
  802887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80288c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802890:	0f b6 00             	movzbl (%rax),%eax
  802893:	3c 20                	cmp    $0x20,%al
  802895:	74 f0                	je     802887 <strtol+0x24>
  802897:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289b:	0f b6 00             	movzbl (%rax),%eax
  80289e:	3c 09                	cmp    $0x9,%al
  8028a0:	74 e5                	je     802887 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8028a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a6:	0f b6 00             	movzbl (%rax),%eax
  8028a9:	3c 2b                	cmp    $0x2b,%al
  8028ab:	75 07                	jne    8028b4 <strtol+0x51>
		s++;
  8028ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028b2:	eb 17                	jmp    8028cb <strtol+0x68>
	else if (*s == '-')
  8028b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b8:	0f b6 00             	movzbl (%rax),%eax
  8028bb:	3c 2d                	cmp    $0x2d,%al
  8028bd:	75 0c                	jne    8028cb <strtol+0x68>
		s++, neg = 1;
  8028bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8028cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8028cf:	74 06                	je     8028d7 <strtol+0x74>
  8028d1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8028d5:	75 28                	jne    8028ff <strtol+0x9c>
  8028d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028db:	0f b6 00             	movzbl (%rax),%eax
  8028de:	3c 30                	cmp    $0x30,%al
  8028e0:	75 1d                	jne    8028ff <strtol+0x9c>
  8028e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e6:	48 83 c0 01          	add    $0x1,%rax
  8028ea:	0f b6 00             	movzbl (%rax),%eax
  8028ed:	3c 78                	cmp    $0x78,%al
  8028ef:	75 0e                	jne    8028ff <strtol+0x9c>
		s += 2, base = 16;
  8028f1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8028f6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8028fd:	eb 2c                	jmp    80292b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8028ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802903:	75 19                	jne    80291e <strtol+0xbb>
  802905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802909:	0f b6 00             	movzbl (%rax),%eax
  80290c:	3c 30                	cmp    $0x30,%al
  80290e:	75 0e                	jne    80291e <strtol+0xbb>
		s++, base = 8;
  802910:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802915:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80291c:	eb 0d                	jmp    80292b <strtol+0xc8>
	else if (base == 0)
  80291e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802922:	75 07                	jne    80292b <strtol+0xc8>
		base = 10;
  802924:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80292b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80292f:	0f b6 00             	movzbl (%rax),%eax
  802932:	3c 2f                	cmp    $0x2f,%al
  802934:	7e 1d                	jle    802953 <strtol+0xf0>
  802936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293a:	0f b6 00             	movzbl (%rax),%eax
  80293d:	3c 39                	cmp    $0x39,%al
  80293f:	7f 12                	jg     802953 <strtol+0xf0>
			dig = *s - '0';
  802941:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802945:	0f b6 00             	movzbl (%rax),%eax
  802948:	0f be c0             	movsbl %al,%eax
  80294b:	83 e8 30             	sub    $0x30,%eax
  80294e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802951:	eb 4e                	jmp    8029a1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802957:	0f b6 00             	movzbl (%rax),%eax
  80295a:	3c 60                	cmp    $0x60,%al
  80295c:	7e 1d                	jle    80297b <strtol+0x118>
  80295e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802962:	0f b6 00             	movzbl (%rax),%eax
  802965:	3c 7a                	cmp    $0x7a,%al
  802967:	7f 12                	jg     80297b <strtol+0x118>
			dig = *s - 'a' + 10;
  802969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80296d:	0f b6 00             	movzbl (%rax),%eax
  802970:	0f be c0             	movsbl %al,%eax
  802973:	83 e8 57             	sub    $0x57,%eax
  802976:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802979:	eb 26                	jmp    8029a1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80297b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297f:	0f b6 00             	movzbl (%rax),%eax
  802982:	3c 40                	cmp    $0x40,%al
  802984:	7e 48                	jle    8029ce <strtol+0x16b>
  802986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298a:	0f b6 00             	movzbl (%rax),%eax
  80298d:	3c 5a                	cmp    $0x5a,%al
  80298f:	7f 3d                	jg     8029ce <strtol+0x16b>
			dig = *s - 'A' + 10;
  802991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802995:	0f b6 00             	movzbl (%rax),%eax
  802998:	0f be c0             	movsbl %al,%eax
  80299b:	83 e8 37             	sub    $0x37,%eax
  80299e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8029a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8029a7:	7c 02                	jl     8029ab <strtol+0x148>
			break;
  8029a9:	eb 23                	jmp    8029ce <strtol+0x16b>
		s++, val = (val * base) + dig;
  8029ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8029b0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029b3:	48 98                	cltq   
  8029b5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8029ba:	48 89 c2             	mov    %rax,%rdx
  8029bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c0:	48 98                	cltq   
  8029c2:	48 01 d0             	add    %rdx,%rax
  8029c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8029c9:	e9 5d ff ff ff       	jmpq   80292b <strtol+0xc8>

	if (endptr)
  8029ce:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8029d3:	74 0b                	je     8029e0 <strtol+0x17d>
		*endptr = (char *) s;
  8029d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029d9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029dd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8029e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e4:	74 09                	je     8029ef <strtol+0x18c>
  8029e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ea:	48 f7 d8             	neg    %rax
  8029ed:	eb 04                	jmp    8029f3 <strtol+0x190>
  8029ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 30          	sub    $0x30,%rsp
  8029fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  802a05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a09:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a0d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802a11:	0f b6 00             	movzbl (%rax),%eax
  802a14:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  802a17:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802a1b:	75 06                	jne    802a23 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  802a1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a21:	eb 6b                	jmp    802a8e <strstr+0x99>

    len = strlen(str);
  802a23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	48 98                	cltq   
  802a38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  802a3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a40:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a44:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802a48:	0f b6 00             	movzbl (%rax),%eax
  802a4b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  802a4e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802a52:	75 07                	jne    802a5b <strstr+0x66>
                return (char *) 0;
  802a54:	b8 00 00 00 00       	mov    $0x0,%eax
  802a59:	eb 33                	jmp    802a8e <strstr+0x99>
        } while (sc != c);
  802a5b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802a5f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802a62:	75 d8                	jne    802a3c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  802a64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a68:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a70:	48 89 ce             	mov    %rcx,%rsi
  802a73:	48 89 c7             	mov    %rax,%rdi
  802a76:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 b6                	jne    802a3c <strstr+0x47>

    return (char *) (in - 1);
  802a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8a:	48 83 e8 01          	sub    $0x1,%rax
}
  802a8e:	c9                   	leaveq 
  802a8f:	c3                   	retq   

0000000000802a90 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802a90:	55                   	push   %rbp
  802a91:	48 89 e5             	mov    %rsp,%rbp
  802a94:	53                   	push   %rbx
  802a95:	48 83 ec 48          	sub    $0x48,%rsp
  802a99:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a9c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802a9f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802aa3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802aa7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802aab:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aaf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ab2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802ab6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802aba:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802abe:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802ac2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802ac6:	4c 89 c3             	mov    %r8,%rbx
  802ac9:	cd 30                	int    $0x30
  802acb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  802acf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ad3:	74 3e                	je     802b13 <syscall+0x83>
  802ad5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ada:	7e 37                	jle    802b13 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802adc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae3:	49 89 d0             	mov    %rdx,%r8
  802ae6:	89 c1                	mov    %eax,%ecx
  802ae8:	48 ba 33 64 80 00 00 	movabs $0x806433,%rdx
  802aef:	00 00 00 
  802af2:	be 23 00 00 00       	mov    $0x23,%esi
  802af7:	48 bf 50 64 80 00 00 	movabs $0x806450,%rdi
  802afe:	00 00 00 
  802b01:	b8 00 00 00 00       	mov    $0x0,%eax
  802b06:	49 b9 fc 11 80 00 00 	movabs $0x8011fc,%r9
  802b0d:	00 00 00 
  802b10:	41 ff d1             	callq  *%r9

	return ret;
  802b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802b17:	48 83 c4 48          	add    $0x48,%rsp
  802b1b:	5b                   	pop    %rbx
  802b1c:	5d                   	pop    %rbp
  802b1d:	c3                   	retq   

0000000000802b1e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802b1e:	55                   	push   %rbp
  802b1f:	48 89 e5             	mov    %rsp,%rbp
  802b22:	48 83 ec 20          	sub    $0x20,%rsp
  802b26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b3d:	00 
  802b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b4a:	48 89 d1             	mov    %rdx,%rcx
  802b4d:	48 89 c2             	mov    %rax,%rdx
  802b50:	be 00 00 00 00       	mov    $0x0,%esi
  802b55:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5a:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
}
  802b66:	c9                   	leaveq 
  802b67:	c3                   	retq   

0000000000802b68 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
  802b6c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802b70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b77:	00 
  802b78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b89:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8e:	be 00 00 00 00       	mov    $0x0,%esi
  802b93:	bf 01 00 00 00       	mov    $0x1,%edi
  802b98:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 10          	sub    $0x10,%rsp
  802bae:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb4:	48 98                	cltq   
  802bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bbd:	00 
  802bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bca:	b9 00 00 00 00       	mov    $0x0,%ecx
  802bcf:	48 89 c2             	mov    %rax,%rdx
  802bd2:	be 01 00 00 00       	mov    $0x1,%esi
  802bd7:	bf 03 00 00 00       	mov    $0x3,%edi
  802bdc:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802bf2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bf9:	00 
  802bfa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c06:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c10:	be 00 00 00 00       	mov    $0x0,%esi
  802c15:	bf 02 00 00 00       	mov    $0x2,%edi
  802c1a:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
}
  802c26:	c9                   	leaveq 
  802c27:	c3                   	retq   

0000000000802c28 <sys_yield>:

void
sys_yield(void)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802c30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c37:	00 
  802c38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c44:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c49:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4e:	be 00 00 00 00       	mov    $0x0,%esi
  802c53:	bf 0b 00 00 00       	mov    $0xb,%edi
  802c58:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
}
  802c64:	c9                   	leaveq 
  802c65:	c3                   	retq   

0000000000802c66 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802c66:	55                   	push   %rbp
  802c67:	48 89 e5             	mov    %rsp,%rbp
  802c6a:	48 83 ec 20          	sub    $0x20,%rsp
  802c6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c75:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802c78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c7b:	48 63 c8             	movslq %eax,%rcx
  802c7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c85:	48 98                	cltq   
  802c87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c8e:	00 
  802c8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c95:	49 89 c8             	mov    %rcx,%r8
  802c98:	48 89 d1             	mov    %rdx,%rcx
  802c9b:	48 89 c2             	mov    %rax,%rdx
  802c9e:	be 01 00 00 00       	mov    $0x1,%esi
  802ca3:	bf 04 00 00 00       	mov    $0x4,%edi
  802ca8:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
}
  802cb4:	c9                   	leaveq 
  802cb5:	c3                   	retq   

0000000000802cb6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802cb6:	55                   	push   %rbp
  802cb7:	48 89 e5             	mov    %rsp,%rbp
  802cba:	48 83 ec 30          	sub    $0x30,%rsp
  802cbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802cc5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802cc8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802ccc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802cd0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cd3:	48 63 c8             	movslq %eax,%rcx
  802cd6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802cda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cdd:	48 63 f0             	movslq %eax,%rsi
  802ce0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce7:	48 98                	cltq   
  802ce9:	48 89 0c 24          	mov    %rcx,(%rsp)
  802ced:	49 89 f9             	mov    %rdi,%r9
  802cf0:	49 89 f0             	mov    %rsi,%r8
  802cf3:	48 89 d1             	mov    %rdx,%rcx
  802cf6:	48 89 c2             	mov    %rax,%rdx
  802cf9:	be 01 00 00 00       	mov    $0x1,%esi
  802cfe:	bf 05 00 00 00       	mov    $0x5,%edi
  802d03:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802d0a:	00 00 00 
  802d0d:	ff d0                	callq  *%rax
}
  802d0f:	c9                   	leaveq 
  802d10:	c3                   	retq   

0000000000802d11 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802d11:	55                   	push   %rbp
  802d12:	48 89 e5             	mov    %rsp,%rbp
  802d15:	48 83 ec 20          	sub    $0x20,%rsp
  802d19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802d20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d27:	48 98                	cltq   
  802d29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d30:	00 
  802d31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d3d:	48 89 d1             	mov    %rdx,%rcx
  802d40:	48 89 c2             	mov    %rax,%rdx
  802d43:	be 01 00 00 00       	mov    $0x1,%esi
  802d48:	bf 06 00 00 00       	mov    $0x6,%edi
  802d4d:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
}
  802d59:	c9                   	leaveq 
  802d5a:	c3                   	retq   

0000000000802d5b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
  802d5f:	48 83 ec 10          	sub    $0x10,%rsp
  802d63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d66:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802d69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d6c:	48 63 d0             	movslq %eax,%rdx
  802d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d72:	48 98                	cltq   
  802d74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d7b:	00 
  802d7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d88:	48 89 d1             	mov    %rdx,%rcx
  802d8b:	48 89 c2             	mov    %rax,%rdx
  802d8e:	be 01 00 00 00       	mov    $0x1,%esi
  802d93:	bf 08 00 00 00       	mov    $0x8,%edi
  802d98:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
}
  802da4:	c9                   	leaveq 
  802da5:	c3                   	retq   

0000000000802da6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802da6:	55                   	push   %rbp
  802da7:	48 89 e5             	mov    %rsp,%rbp
  802daa:	48 83 ec 20          	sub    $0x20,%rsp
  802dae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802db1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802db5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbc:	48 98                	cltq   
  802dbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802dc5:	00 
  802dc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802dd2:	48 89 d1             	mov    %rdx,%rcx
  802dd5:	48 89 c2             	mov    %rax,%rdx
  802dd8:	be 01 00 00 00       	mov    $0x1,%esi
  802ddd:	bf 09 00 00 00       	mov    $0x9,%edi
  802de2:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
}
  802dee:	c9                   	leaveq 
  802def:	c3                   	retq   

0000000000802df0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802df0:	55                   	push   %rbp
  802df1:	48 89 e5             	mov    %rsp,%rbp
  802df4:	48 83 ec 20          	sub    $0x20,%rsp
  802df8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802dff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e06:	48 98                	cltq   
  802e08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802e0f:	00 
  802e10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e1c:	48 89 d1             	mov    %rdx,%rcx
  802e1f:	48 89 c2             	mov    %rax,%rdx
  802e22:	be 01 00 00 00       	mov    $0x1,%esi
  802e27:	bf 0a 00 00 00       	mov    $0xa,%edi
  802e2c:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
}
  802e38:	c9                   	leaveq 
  802e39:	c3                   	retq   

0000000000802e3a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802e3a:	55                   	push   %rbp
  802e3b:	48 89 e5             	mov    %rsp,%rbp
  802e3e:	48 83 ec 20          	sub    $0x20,%rsp
  802e42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e49:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802e4d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802e50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e53:	48 63 f0             	movslq %eax,%rsi
  802e56:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5d:	48 98                	cltq   
  802e5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802e6a:	00 
  802e6b:	49 89 f1             	mov    %rsi,%r9
  802e6e:	49 89 c8             	mov    %rcx,%r8
  802e71:	48 89 d1             	mov    %rdx,%rcx
  802e74:	48 89 c2             	mov    %rax,%rdx
  802e77:	be 00 00 00 00       	mov    $0x0,%esi
  802e7c:	bf 0c 00 00 00       	mov    $0xc,%edi
  802e81:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
}
  802e8d:	c9                   	leaveq 
  802e8e:	c3                   	retq   

0000000000802e8f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802e8f:	55                   	push   %rbp
  802e90:	48 89 e5             	mov    %rsp,%rbp
  802e93:	48 83 ec 10          	sub    $0x10,%rsp
  802e97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ea6:	00 
  802ea7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ead:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802eb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  802eb8:	48 89 c2             	mov    %rax,%rdx
  802ebb:	be 01 00 00 00       	mov    $0x1,%esi
  802ec0:	bf 0d 00 00 00       	mov    $0xd,%edi
  802ec5:	48 b8 90 2a 80 00 00 	movabs $0x802a90,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
}
  802ed1:	c9                   	leaveq 
  802ed2:	c3                   	retq   

0000000000802ed3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802ed3:	55                   	push   %rbp
  802ed4:	48 89 e5             	mov    %rsp,%rbp
  802ed7:	48 83 ec 30          	sub    $0x30,%rsp
  802edb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee3:	48 8b 00             	mov    (%rax),%rax
  802ee6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eee:	48 8b 40 08          	mov    0x8(%rax),%rax
  802ef2:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  802ef5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ef8:	83 e0 02             	and    $0x2,%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 23                	je     802f22 <pgfault+0x4f>
  802eff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f03:	48 c1 e8 0c          	shr    $0xc,%rax
  802f07:	48 89 c2             	mov    %rax,%rdx
  802f0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f11:	01 00 00 
  802f14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f18:	25 00 08 00 00       	and    $0x800,%eax
  802f1d:	48 85 c0             	test   %rax,%rax
  802f20:	75 2a                	jne    802f4c <pgfault+0x79>
		panic("fail check at fork pgfault");
  802f22:	48 ba 5e 64 80 00 00 	movabs $0x80645e,%rdx
  802f29:	00 00 00 
  802f2c:	be 1d 00 00 00       	mov    $0x1d,%esi
  802f31:	48 bf 79 64 80 00 00 	movabs $0x806479,%rdi
  802f38:	00 00 00 
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f40:	48 b9 fc 11 80 00 00 	movabs $0x8011fc,%rcx
  802f47:	00 00 00 
  802f4a:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  802f4c:	ba 07 00 00 00       	mov    $0x7,%edx
  802f51:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802f56:	bf 00 00 00 00       	mov    $0x0,%edi
  802f5b:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  802f67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f73:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802f79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f81:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f86:	48 89 c6             	mov    %rax,%rsi
  802f89:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802f8e:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  802f9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802fa4:	48 89 c1             	mov    %rax,%rcx
  802fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  802fac:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb6:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  802fc2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802fc7:	bf 00 00 00 00       	mov    $0x0,%edi
  802fcc:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  802fd3:	00 00 00 
  802fd6:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  802fd8:	c9                   	leaveq 
  802fd9:	c3                   	retq   

0000000000802fda <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802fda:	55                   	push   %rbp
  802fdb:	48 89 e5             	mov    %rsp,%rbp
  802fde:	48 83 ec 20          	sub    $0x20,%rsp
  802fe2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  802fe8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802feb:	48 c1 e0 0c          	shl    $0xc,%rax
  802fef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  802ff3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ffa:	01 00 00 
  802ffd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803000:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803004:	25 00 04 00 00       	and    $0x400,%eax
  803009:	48 85 c0             	test   %rax,%rax
  80300c:	74 55                	je     803063 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  80300e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803015:	01 00 00 
  803018:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80301b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80301f:	25 07 0e 00 00       	and    $0xe07,%eax
  803024:	89 c6                	mov    %eax,%esi
  803026:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80302a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80302d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803031:	41 89 f0             	mov    %esi,%r8d
  803034:	48 89 c6             	mov    %rax,%rsi
  803037:	bf 00 00 00 00       	mov    $0x0,%edi
  80303c:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
  803048:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80304b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80304f:	79 08                	jns    803059 <duppage+0x7f>
			return r;
  803051:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803054:	e9 e1 00 00 00       	jmpq   80313a <duppage+0x160>
		return 0;
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	e9 d7 00 00 00       	jmpq   80313a <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  803063:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80306a:	01 00 00 
  80306d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803070:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803074:	25 05 06 00 00       	and    $0x605,%eax
  803079:	80 cc 08             	or     $0x8,%ah
  80307c:	89 c6                	mov    %eax,%esi
  80307e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803082:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803085:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803089:	41 89 f0             	mov    %esi,%r8d
  80308c:	48 89 c6             	mov    %rax,%rsi
  80308f:	bf 00 00 00 00       	mov    $0x0,%edi
  803094:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
  8030a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8030a7:	79 08                	jns    8030b1 <duppage+0xd7>
		return r;
  8030a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030ac:	e9 89 00 00 00       	jmpq   80313a <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8030b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030b8:	01 00 00 
  8030bb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030c2:	83 e0 02             	and    $0x2,%eax
  8030c5:	48 85 c0             	test   %rax,%rax
  8030c8:	75 1b                	jne    8030e5 <duppage+0x10b>
  8030ca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030d1:	01 00 00 
  8030d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030db:	25 00 08 00 00       	and    $0x800,%eax
  8030e0:	48 85 c0             	test   %rax,%rax
  8030e3:	74 50                	je     803135 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8030e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030ec:	01 00 00 
  8030ef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030f6:	25 05 06 00 00       	and    $0x605,%eax
  8030fb:	80 cc 08             	or     $0x8,%ah
  8030fe:	89 c1                	mov    %eax,%ecx
  803100:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803108:	41 89 c8             	mov    %ecx,%r8d
  80310b:	48 89 d1             	mov    %rdx,%rcx
  80310e:	ba 00 00 00 00       	mov    $0x0,%edx
  803113:	48 89 c6             	mov    %rax,%rsi
  803116:	bf 00 00 00 00       	mov    $0x0,%edi
  80311b:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
  803127:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80312a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80312e:	79 05                	jns    803135 <duppage+0x15b>
			return r;
  803130:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803133:	eb 05                	jmp    80313a <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80313a:	c9                   	leaveq 
  80313b:	c3                   	retq   

000000000080313c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80313c:	55                   	push   %rbp
  80313d:	48 89 e5             	mov    %rsp,%rbp
  803140:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  803144:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  80314b:	48 bf d3 2e 80 00 00 	movabs $0x802ed3,%rdi
  803152:	00 00 00 
  803155:	48 b8 91 59 80 00 00 	movabs $0x805991,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803161:	b8 07 00 00 00       	mov    $0x7,%eax
  803166:	cd 30                	int    $0x30
  803168:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80316b:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  80316e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803171:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803175:	79 08                	jns    80317f <fork+0x43>
		return envid;
  803177:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80317a:	e9 27 02 00 00       	jmpq   8033a6 <fork+0x26a>
	else if (envid == 0) {
  80317f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803183:	75 46                	jne    8031cb <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  803185:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	25 ff 03 00 00       	and    $0x3ff,%eax
  803196:	48 63 d0             	movslq %eax,%rdx
  803199:	48 89 d0             	mov    %rdx,%rax
  80319c:	48 c1 e0 03          	shl    $0x3,%rax
  8031a0:	48 01 d0             	add    %rdx,%rax
  8031a3:	48 c1 e0 05          	shl    $0x5,%rax
  8031a7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8031ae:	00 00 00 
  8031b1:	48 01 c2             	add    %rax,%rdx
  8031b4:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8031bb:	00 00 00 
  8031be:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c6:	e9 db 01 00 00       	jmpq   8033a6 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8031cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031ce:	ba 07 00 00 00       	mov    $0x7,%edx
  8031d3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8031d8:	89 c7                	mov    %eax,%edi
  8031da:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
  8031e6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8031e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8031ed:	79 08                	jns    8031f7 <fork+0xbb>
		return r;
  8031ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031f2:	e9 af 01 00 00       	jmpq   8033a6 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8031f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031fe:	e9 49 01 00 00       	jmpq   80334c <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803203:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803206:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  80320c:	85 c0                	test   %eax,%eax
  80320e:	0f 48 c2             	cmovs  %edx,%eax
  803211:	c1 f8 1b             	sar    $0x1b,%eax
  803214:	89 c2                	mov    %eax,%edx
  803216:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80321d:	01 00 00 
  803220:	48 63 d2             	movslq %edx,%rdx
  803223:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803227:	83 e0 01             	and    $0x1,%eax
  80322a:	48 85 c0             	test   %rax,%rax
  80322d:	75 0c                	jne    80323b <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  80322f:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  803236:	e9 0d 01 00 00       	jmpq   803348 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80323b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  803242:	e9 f4 00 00 00       	jmpq   80333b <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803247:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80324a:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  803250:	85 c0                	test   %eax,%eax
  803252:	0f 48 c2             	cmovs  %edx,%eax
  803255:	c1 f8 12             	sar    $0x12,%eax
  803258:	89 c2                	mov    %eax,%edx
  80325a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803261:	01 00 00 
  803264:	48 63 d2             	movslq %edx,%rdx
  803267:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80326b:	83 e0 01             	and    $0x1,%eax
  80326e:	48 85 c0             	test   %rax,%rax
  803271:	75 0c                	jne    80327f <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  803273:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80327a:	e9 b8 00 00 00       	jmpq   803337 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80327f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803286:	e9 9f 00 00 00       	jmpq   80332a <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80328b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80328e:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  803294:	85 c0                	test   %eax,%eax
  803296:	0f 48 c2             	cmovs  %edx,%eax
  803299:	c1 f8 09             	sar    $0x9,%eax
  80329c:	89 c2                	mov    %eax,%edx
  80329e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8032a5:	01 00 00 
  8032a8:	48 63 d2             	movslq %edx,%rdx
  8032ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032af:	83 e0 01             	and    $0x1,%eax
  8032b2:	48 85 c0             	test   %rax,%rax
  8032b5:	75 09                	jne    8032c0 <fork+0x184>
					ptx += NPTENTRIES;
  8032b7:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8032be:	eb 66                	jmp    803326 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8032c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8032c7:	eb 54                	jmp    80331d <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8032c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032d0:	01 00 00 
  8032d3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032d6:	48 63 d2             	movslq %edx,%rdx
  8032d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032dd:	83 e0 01             	and    $0x1,%eax
  8032e0:	48 85 c0             	test   %rax,%rax
  8032e3:	74 30                	je     803315 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  8032e5:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  8032ec:	74 27                	je     803315 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  8032ee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032f1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032f4:	89 d6                	mov    %edx,%esi
  8032f6:	89 c7                	mov    %eax,%edi
  8032f8:	48 b8 da 2f 80 00 00 	movabs $0x802fda,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
  803304:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803307:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80330b:	79 08                	jns    803315 <fork+0x1d9>
								return r;
  80330d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803310:	e9 91 00 00 00       	jmpq   8033a6 <fork+0x26a>
					ptx++;
  803315:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803319:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80331d:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  803324:	7e a3                	jle    8032c9 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803326:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80332a:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  803331:	0f 8e 54 ff ff ff    	jle    80328b <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803337:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80333b:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  803342:	0f 8e ff fe ff ff    	jle    803247 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803348:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80334c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803350:	0f 84 ad fe ff ff    	je     803203 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  803356:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803359:	48 be fc 59 80 00 00 	movabs $0x8059fc,%rsi
  803360:	00 00 00 
  803363:	89 c7                	mov    %eax,%edi
  803365:	48 b8 f0 2d 80 00 00 	movabs $0x802df0,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803374:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803378:	79 05                	jns    80337f <fork+0x243>
		return r;
  80337a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80337d:	eb 27                	jmp    8033a6 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80337f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803382:	be 02 00 00 00       	mov    $0x2,%esi
  803387:	89 c7                	mov    %eax,%edi
  803389:	48 b8 5b 2d 80 00 00 	movabs $0x802d5b,%rax
  803390:	00 00 00 
  803393:	ff d0                	callq  *%rax
  803395:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  803398:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80339c:	79 05                	jns    8033a3 <fork+0x267>
		return r;
  80339e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033a1:	eb 03                	jmp    8033a6 <fork+0x26a>

	return envid;
  8033a3:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  8033a6:	c9                   	leaveq 
  8033a7:	c3                   	retq   

00000000008033a8 <sfork>:

// Challenge!
int
sfork(void)
{
  8033a8:	55                   	push   %rbp
  8033a9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8033ac:	48 ba 84 64 80 00 00 	movabs $0x806484,%rdx
  8033b3:	00 00 00 
  8033b6:	be a7 00 00 00       	mov    $0xa7,%esi
  8033bb:	48 bf 79 64 80 00 00 	movabs $0x806479,%rdi
  8033c2:	00 00 00 
  8033c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ca:	48 b9 fc 11 80 00 00 	movabs $0x8011fc,%rcx
  8033d1:	00 00 00 
  8033d4:	ff d1                	callq  *%rcx

00000000008033d6 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8033d6:	55                   	push   %rbp
  8033d7:	48 89 e5             	mov    %rsp,%rbp
  8033da:	48 83 ec 18          	sub    $0x18,%rsp
  8033de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8033ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033f2:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8033f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033fd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803401:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803405:	8b 00                	mov    (%rax),%eax
  803407:	83 f8 01             	cmp    $0x1,%eax
  80340a:	7e 13                	jle    80341f <argstart+0x49>
  80340c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  803411:	74 0c                	je     80341f <argstart+0x49>
  803413:	48 b8 9a 64 80 00 00 	movabs $0x80649a,%rax
  80341a:	00 00 00 
  80341d:	eb 05                	jmp    803424 <argstart+0x4e>
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
  803424:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803428:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  80342c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803430:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803437:	00 
}
  803438:	c9                   	leaveq 
  803439:	c3                   	retq   

000000000080343a <argnext>:

int
argnext(struct Argstate *args)
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	48 83 ec 20          	sub    $0x20,%rsp
  803442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  803446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80344a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803451:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803456:	48 8b 40 10          	mov    0x10(%rax),%rax
  80345a:	48 85 c0             	test   %rax,%rax
  80345d:	75 0a                	jne    803469 <argnext+0x2f>
		return -1;
  80345f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803464:	e9 25 01 00 00       	jmpq   80358e <argnext+0x154>

	if (!*args->curarg) {
  803469:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803471:	0f b6 00             	movzbl (%rax),%eax
  803474:	84 c0                	test   %al,%al
  803476:	0f 85 d7 00 00 00    	jne    803553 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80347c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803480:	48 8b 00             	mov    (%rax),%rax
  803483:	8b 00                	mov    (%rax),%eax
  803485:	83 f8 01             	cmp    $0x1,%eax
  803488:	0f 84 ef 00 00 00    	je     80357d <argnext+0x143>
		    || args->argv[1][0] != '-'
  80348e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803492:	48 8b 40 08          	mov    0x8(%rax),%rax
  803496:	48 83 c0 08          	add    $0x8,%rax
  80349a:	48 8b 00             	mov    (%rax),%rax
  80349d:	0f b6 00             	movzbl (%rax),%eax
  8034a0:	3c 2d                	cmp    $0x2d,%al
  8034a2:	0f 85 d5 00 00 00    	jne    80357d <argnext+0x143>
		    || args->argv[1][1] == '\0')
  8034a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ac:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034b0:	48 83 c0 08          	add    $0x8,%rax
  8034b4:	48 8b 00             	mov    (%rax),%rax
  8034b7:	48 83 c0 01          	add    $0x1,%rax
  8034bb:	0f b6 00             	movzbl (%rax),%eax
  8034be:	84 c0                	test   %al,%al
  8034c0:	0f 84 b7 00 00 00    	je     80357d <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8034c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ca:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034ce:	48 83 c0 08          	add    $0x8,%rax
  8034d2:	48 8b 00             	mov    (%rax),%rax
  8034d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8034e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e5:	48 8b 00             	mov    (%rax),%rax
  8034e8:	8b 00                	mov    (%rax),%eax
  8034ea:	83 e8 01             	sub    $0x1,%eax
  8034ed:	48 98                	cltq   
  8034ef:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034f6:	00 
  8034f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034ff:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803507:	48 8b 40 08          	mov    0x8(%rax),%rax
  80350b:	48 83 c0 08          	add    $0x8,%rax
  80350f:	48 89 ce             	mov    %rcx,%rsi
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
		(*args->argc)--;
  803521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803525:	48 8b 00             	mov    (%rax),%rax
  803528:	8b 10                	mov    (%rax),%edx
  80352a:	83 ea 01             	sub    $0x1,%edx
  80352d:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80352f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803533:	48 8b 40 10          	mov    0x10(%rax),%rax
  803537:	0f b6 00             	movzbl (%rax),%eax
  80353a:	3c 2d                	cmp    $0x2d,%al
  80353c:	75 15                	jne    803553 <argnext+0x119>
  80353e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803542:	48 8b 40 10          	mov    0x10(%rax),%rax
  803546:	48 83 c0 01          	add    $0x1,%rax
  80354a:	0f b6 00             	movzbl (%rax),%eax
  80354d:	84 c0                	test   %al,%al
  80354f:	75 02                	jne    803553 <argnext+0x119>
			goto endofargs;
  803551:	eb 2a                	jmp    80357d <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  803553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803557:	48 8b 40 10          	mov    0x10(%rax),%rax
  80355b:	0f b6 00             	movzbl (%rax),%eax
  80355e:	0f b6 c0             	movzbl %al,%eax
  803561:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803568:	48 8b 40 10          	mov    0x10(%rax),%rax
  80356c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803574:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357b:	eb 11                	jmp    80358e <argnext+0x154>

    endofargs:
	args->curarg = 0;
  80357d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803581:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803588:	00 
	return -1;
  803589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80358e:	c9                   	leaveq 
  80358f:	c3                   	retq   

0000000000803590 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803590:	55                   	push   %rbp
  803591:	48 89 e5             	mov    %rsp,%rbp
  803594:	48 83 ec 10          	sub    $0x10,%rsp
  803598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80359c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035a4:	48 85 c0             	test   %rax,%rax
  8035a7:	74 0a                	je     8035b3 <argvalue+0x23>
  8035a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ad:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035b1:	eb 13                	jmp    8035c6 <argvalue+0x36>
  8035b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b7:	48 89 c7             	mov    %rax,%rdi
  8035ba:	48 b8 c8 35 80 00 00 	movabs $0x8035c8,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
}
  8035c6:	c9                   	leaveq 
  8035c7:	c3                   	retq   

00000000008035c8 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8035c8:	55                   	push   %rbp
  8035c9:	48 89 e5             	mov    %rsp,%rbp
  8035cc:	53                   	push   %rbx
  8035cd:	48 83 ec 18          	sub    $0x18,%rsp
  8035d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  8035d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035dd:	48 85 c0             	test   %rax,%rax
  8035e0:	75 0a                	jne    8035ec <argnextvalue+0x24>
		return 0;
  8035e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e7:	e9 c8 00 00 00       	jmpq   8036b4 <argnextvalue+0xec>
	if (*args->curarg) {
  8035ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035f4:	0f b6 00             	movzbl (%rax),%eax
  8035f7:	84 c0                	test   %al,%al
  8035f9:	74 27                	je     803622 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  8035fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803607:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  80360b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360f:	48 bb 9a 64 80 00 00 	movabs $0x80649a,%rbx
  803616:	00 00 00 
  803619:	48 89 58 10          	mov    %rbx,0x10(%rax)
  80361d:	e9 8a 00 00 00       	jmpq   8036ac <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  803622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803626:	48 8b 00             	mov    (%rax),%rax
  803629:	8b 00                	mov    (%rax),%eax
  80362b:	83 f8 01             	cmp    $0x1,%eax
  80362e:	7e 64                	jle    803694 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  803630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803634:	48 8b 40 08          	mov    0x8(%rax),%rax
  803638:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80363c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803640:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803648:	48 8b 00             	mov    (%rax),%rax
  80364b:	8b 00                	mov    (%rax),%eax
  80364d:	83 e8 01             	sub    $0x1,%eax
  803650:	48 98                	cltq   
  803652:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803659:	00 
  80365a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803662:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80366e:	48 83 c0 08          	add    $0x8,%rax
  803672:	48 89 ce             	mov    %rcx,%rsi
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
		(*args->argc)--;
  803684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803688:	48 8b 00             	mov    (%rax),%rax
  80368b:	8b 10                	mov    (%rax),%edx
  80368d:	83 ea 01             	sub    $0x1,%edx
  803690:	89 10                	mov    %edx,(%rax)
  803692:	eb 18                	jmp    8036ac <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  803694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803698:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80369f:	00 
		args->curarg = 0;
  8036a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a4:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8036ab:	00 
	}
	return (char*) args->argvalue;
  8036ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b0:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  8036b4:	48 83 c4 18          	add    $0x18,%rsp
  8036b8:	5b                   	pop    %rbx
  8036b9:	5d                   	pop    %rbp
  8036ba:	c3                   	retq   

00000000008036bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8036bb:	55                   	push   %rbp
  8036bc:	48 89 e5             	mov    %rsp,%rbp
  8036bf:	48 83 ec 08          	sub    $0x8,%rsp
  8036c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8036c7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036cb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8036d2:	ff ff ff 
  8036d5:	48 01 d0             	add    %rdx,%rax
  8036d8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8036dc:	c9                   	leaveq 
  8036dd:	c3                   	retq   

00000000008036de <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8036de:	55                   	push   %rbp
  8036df:	48 89 e5             	mov    %rsp,%rbp
  8036e2:	48 83 ec 08          	sub    $0x8,%rsp
  8036e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8036ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ee:	48 89 c7             	mov    %rax,%rdi
  8036f1:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
  8036fd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  803703:	48 c1 e0 0c          	shl    $0xc,%rax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	48 83 ec 18          	sub    $0x18,%rsp
  803711:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80371c:	eb 6b                	jmp    803789 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80371e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803721:	48 98                	cltq   
  803723:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803729:	48 c1 e0 0c          	shl    $0xc,%rax
  80372d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  803731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803735:	48 c1 e8 15          	shr    $0x15,%rax
  803739:	48 89 c2             	mov    %rax,%rdx
  80373c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803743:	01 00 00 
  803746:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80374a:	83 e0 01             	and    $0x1,%eax
  80374d:	48 85 c0             	test   %rax,%rax
  803750:	74 21                	je     803773 <fd_alloc+0x6a>
  803752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803756:	48 c1 e8 0c          	shr    $0xc,%rax
  80375a:	48 89 c2             	mov    %rax,%rdx
  80375d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803764:	01 00 00 
  803767:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80376b:	83 e0 01             	and    $0x1,%eax
  80376e:	48 85 c0             	test   %rax,%rax
  803771:	75 12                	jne    803785 <fd_alloc+0x7c>
			*fd_store = fd;
  803773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803777:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80377b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80377e:	b8 00 00 00 00       	mov    $0x0,%eax
  803783:	eb 1a                	jmp    80379f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803785:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803789:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80378d:	7e 8f                	jle    80371e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80378f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803793:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80379a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80379f:	c9                   	leaveq 
  8037a0:	c3                   	retq   

00000000008037a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8037a1:	55                   	push   %rbp
  8037a2:	48 89 e5             	mov    %rsp,%rbp
  8037a5:	48 83 ec 20          	sub    $0x20,%rsp
  8037a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8037b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b4:	78 06                	js     8037bc <fd_lookup+0x1b>
  8037b6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8037ba:	7e 07                	jle    8037c3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8037bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8037c1:	eb 6c                	jmp    80382f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8037c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c6:	48 98                	cltq   
  8037c8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8037ce:	48 c1 e0 0c          	shl    $0xc,%rax
  8037d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8037d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037da:	48 c1 e8 15          	shr    $0x15,%rax
  8037de:	48 89 c2             	mov    %rax,%rdx
  8037e1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037e8:	01 00 00 
  8037eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037ef:	83 e0 01             	and    $0x1,%eax
  8037f2:	48 85 c0             	test   %rax,%rax
  8037f5:	74 21                	je     803818 <fd_lookup+0x77>
  8037f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fb:	48 c1 e8 0c          	shr    $0xc,%rax
  8037ff:	48 89 c2             	mov    %rax,%rdx
  803802:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803809:	01 00 00 
  80380c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803810:	83 e0 01             	and    $0x1,%eax
  803813:	48 85 c0             	test   %rax,%rax
  803816:	75 07                	jne    80381f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803818:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80381d:	eb 10                	jmp    80382f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80381f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803823:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803827:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80382a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80382f:	c9                   	leaveq 
  803830:	c3                   	retq   

0000000000803831 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803831:	55                   	push   %rbp
  803832:	48 89 e5             	mov    %rsp,%rbp
  803835:	48 83 ec 30          	sub    $0x30,%rsp
  803839:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80383d:	89 f0                	mov    %esi,%eax
  80383f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803846:	48 89 c7             	mov    %rax,%rdi
  803849:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  803850:	00 00 00 
  803853:	ff d0                	callq  *%rax
  803855:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803859:	48 89 d6             	mov    %rdx,%rsi
  80385c:	89 c7                	mov    %eax,%edi
  80385e:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803871:	78 0a                	js     80387d <fd_close+0x4c>
	    || fd != fd2)
  803873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803877:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80387b:	74 12                	je     80388f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80387d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803881:	74 05                	je     803888 <fd_close+0x57>
  803883:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803886:	eb 05                	jmp    80388d <fd_close+0x5c>
  803888:	b8 00 00 00 00       	mov    $0x0,%eax
  80388d:	eb 69                	jmp    8038f8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80388f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803893:	8b 00                	mov    (%rax),%eax
  803895:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803899:	48 89 d6             	mov    %rdx,%rsi
  80389c:	89 c7                	mov    %eax,%edi
  80389e:	48 b8 fa 38 80 00 00 	movabs $0x8038fa,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
  8038aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b1:	78 2a                	js     8038dd <fd_close+0xac>
		if (dev->dev_close)
  8038b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8038bb:	48 85 c0             	test   %rax,%rax
  8038be:	74 16                	je     8038d6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8038c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8038c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8038cc:	48 89 d7             	mov    %rdx,%rdi
  8038cf:	ff d0                	callq  *%rax
  8038d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d4:	eb 07                	jmp    8038dd <fd_close+0xac>
		else
			r = 0;
  8038d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8038dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e1:	48 89 c6             	mov    %rax,%rsi
  8038e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e9:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
	return r;
  8038f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038f8:	c9                   	leaveq 
  8038f9:	c3                   	retq   

00000000008038fa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8038fa:	55                   	push   %rbp
  8038fb:	48 89 e5             	mov    %rsp,%rbp
  8038fe:	48 83 ec 20          	sub    $0x20,%rsp
  803902:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803905:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803909:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803910:	eb 41                	jmp    803953 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803912:	48 b8 80 80 80 00 00 	movabs $0x808080,%rax
  803919:	00 00 00 
  80391c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80391f:	48 63 d2             	movslq %edx,%rdx
  803922:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803926:	8b 00                	mov    (%rax),%eax
  803928:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80392b:	75 22                	jne    80394f <dev_lookup+0x55>
			*dev = devtab[i];
  80392d:	48 b8 80 80 80 00 00 	movabs $0x808080,%rax
  803934:	00 00 00 
  803937:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80393a:	48 63 d2             	movslq %edx,%rdx
  80393d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803941:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803945:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803948:	b8 00 00 00 00       	mov    $0x0,%eax
  80394d:	eb 60                	jmp    8039af <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80394f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803953:	48 b8 80 80 80 00 00 	movabs $0x808080,%rax
  80395a:	00 00 00 
  80395d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803960:	48 63 d2             	movslq %edx,%rdx
  803963:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803967:	48 85 c0             	test   %rax,%rax
  80396a:	75 a6                	jne    803912 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80396c:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803973:	00 00 00 
  803976:	48 8b 00             	mov    (%rax),%rax
  803979:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80397f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803982:	89 c6                	mov    %eax,%esi
  803984:	48 bf a0 64 80 00 00 	movabs $0x8064a0,%rdi
  80398b:	00 00 00 
  80398e:	b8 00 00 00 00       	mov    $0x0,%eax
  803993:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  80399a:	00 00 00 
  80399d:	ff d1                	callq  *%rcx
	*dev = 0;
  80399f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8039aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8039af:	c9                   	leaveq 
  8039b0:	c3                   	retq   

00000000008039b1 <close>:

int
close(int fdnum)
{
  8039b1:	55                   	push   %rbp
  8039b2:	48 89 e5             	mov    %rsp,%rbp
  8039b5:	48 83 ec 20          	sub    $0x20,%rsp
  8039b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c3:	48 89 d6             	mov    %rdx,%rsi
  8039c6:	89 c7                	mov    %eax,%edi
  8039c8:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  8039cf:	00 00 00 
  8039d2:	ff d0                	callq  *%rax
  8039d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039db:	79 05                	jns    8039e2 <close+0x31>
		return r;
  8039dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e0:	eb 18                	jmp    8039fa <close+0x49>
	else
		return fd_close(fd, 1);
  8039e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e6:	be 01 00 00 00       	mov    $0x1,%esi
  8039eb:	48 89 c7             	mov    %rax,%rdi
  8039ee:	48 b8 31 38 80 00 00 	movabs $0x803831,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
}
  8039fa:	c9                   	leaveq 
  8039fb:	c3                   	retq   

00000000008039fc <close_all>:

void
close_all(void)
{
  8039fc:	55                   	push   %rbp
  8039fd:	48 89 e5             	mov    %rsp,%rbp
  803a00:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a0b:	eb 15                	jmp    803a22 <close_all+0x26>
		close(i);
  803a0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a10:	89 c7                	mov    %eax,%edi
  803a12:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803a1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a22:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803a26:	7e e5                	jle    803a0d <close_all+0x11>
		close(i);
}
  803a28:	c9                   	leaveq 
  803a29:	c3                   	retq   

0000000000803a2a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803a2a:	55                   	push   %rbp
  803a2b:	48 89 e5             	mov    %rsp,%rbp
  803a2e:	48 83 ec 40          	sub    $0x40,%rsp
  803a32:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803a35:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803a38:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803a3c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803a3f:	48 89 d6             	mov    %rdx,%rsi
  803a42:	89 c7                	mov    %eax,%edi
  803a44:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
  803a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a57:	79 08                	jns    803a61 <dup+0x37>
		return r;
  803a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5c:	e9 70 01 00 00       	jmpq   803bd1 <dup+0x1a7>
	close(newfdnum);
  803a61:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803a64:	89 c7                	mov    %eax,%edi
  803a66:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803a72:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803a75:	48 98                	cltq   
  803a77:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803a7d:	48 c1 e0 0c          	shl    $0xc,%rax
  803a81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a89:	48 89 c7             	mov    %rax,%rdi
  803a8c:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  803a93:	00 00 00 
  803a96:	ff d0                	callq  *%rax
  803a98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803a9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa0:	48 89 c7             	mov    %rax,%rdi
  803aa3:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
  803aaf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab7:	48 c1 e8 15          	shr    $0x15,%rax
  803abb:	48 89 c2             	mov    %rax,%rdx
  803abe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ac5:	01 00 00 
  803ac8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803acc:	83 e0 01             	and    $0x1,%eax
  803acf:	48 85 c0             	test   %rax,%rax
  803ad2:	74 73                	je     803b47 <dup+0x11d>
  803ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ad8:	48 c1 e8 0c          	shr    $0xc,%rax
  803adc:	48 89 c2             	mov    %rax,%rdx
  803adf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ae6:	01 00 00 
  803ae9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803aed:	83 e0 01             	and    $0x1,%eax
  803af0:	48 85 c0             	test   %rax,%rax
  803af3:	74 52                	je     803b47 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af9:	48 c1 e8 0c          	shr    $0xc,%rax
  803afd:	48 89 c2             	mov    %rax,%rdx
  803b00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b07:	01 00 00 
  803b0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b0e:	25 07 0e 00 00       	and    $0xe07,%eax
  803b13:	89 c1                	mov    %eax,%ecx
  803b15:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b1d:	41 89 c8             	mov    %ecx,%r8d
  803b20:	48 89 d1             	mov    %rdx,%rcx
  803b23:	ba 00 00 00 00       	mov    $0x0,%edx
  803b28:	48 89 c6             	mov    %rax,%rsi
  803b2b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b30:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  803b37:	00 00 00 
  803b3a:	ff d0                	callq  *%rax
  803b3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b43:	79 02                	jns    803b47 <dup+0x11d>
			goto err;
  803b45:	eb 57                	jmp    803b9e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803b47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b4b:	48 c1 e8 0c          	shr    $0xc,%rax
  803b4f:	48 89 c2             	mov    %rax,%rdx
  803b52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b59:	01 00 00 
  803b5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b60:	25 07 0e 00 00       	and    $0xe07,%eax
  803b65:	89 c1                	mov    %eax,%ecx
  803b67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b6f:	41 89 c8             	mov    %ecx,%r8d
  803b72:	48 89 d1             	mov    %rdx,%rcx
  803b75:	ba 00 00 00 00       	mov    $0x0,%edx
  803b7a:	48 89 c6             	mov    %rax,%rsi
  803b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b82:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	callq  *%rax
  803b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b95:	79 02                	jns    803b99 <dup+0x16f>
		goto err;
  803b97:	eb 05                	jmp    803b9e <dup+0x174>

	return newfdnum;
  803b99:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b9c:	eb 33                	jmp    803bd1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803b9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba2:	48 89 c6             	mov    %rax,%rsi
  803ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  803baa:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803bb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bba:	48 89 c6             	mov    %rax,%rsi
  803bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc2:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
	return r;
  803bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bd1:	c9                   	leaveq 
  803bd2:	c3                   	retq   

0000000000803bd3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803bd3:	55                   	push   %rbp
  803bd4:	48 89 e5             	mov    %rsp,%rbp
  803bd7:	48 83 ec 40          	sub    $0x40,%rsp
  803bdb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803bde:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803be2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803be6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803bea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803bed:	48 89 d6             	mov    %rdx,%rsi
  803bf0:	89 c7                	mov    %eax,%edi
  803bf2:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
  803bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c05:	78 24                	js     803c2b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c0b:	8b 00                	mov    (%rax),%eax
  803c0d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c11:	48 89 d6             	mov    %rdx,%rsi
  803c14:	89 c7                	mov    %eax,%edi
  803c16:	48 b8 fa 38 80 00 00 	movabs $0x8038fa,%rax
  803c1d:	00 00 00 
  803c20:	ff d0                	callq  *%rax
  803c22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c29:	79 05                	jns    803c30 <read+0x5d>
		return r;
  803c2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2e:	eb 76                	jmp    803ca6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803c30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c34:	8b 40 08             	mov    0x8(%rax),%eax
  803c37:	83 e0 03             	and    $0x3,%eax
  803c3a:	83 f8 01             	cmp    $0x1,%eax
  803c3d:	75 3a                	jne    803c79 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803c3f:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803c46:	00 00 00 
  803c49:	48 8b 00             	mov    (%rax),%rax
  803c4c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c52:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c55:	89 c6                	mov    %eax,%esi
  803c57:	48 bf bf 64 80 00 00 	movabs $0x8064bf,%rdi
  803c5e:	00 00 00 
  803c61:	b8 00 00 00 00       	mov    $0x0,%eax
  803c66:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  803c6d:	00 00 00 
  803c70:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803c72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803c77:	eb 2d                	jmp    803ca6 <read+0xd3>
	}
	if (!dev->dev_read)
  803c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803c81:	48 85 c0             	test   %rax,%rax
  803c84:	75 07                	jne    803c8d <read+0xba>
		return -E_NOT_SUPP;
  803c86:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803c8b:	eb 19                	jmp    803ca6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c91:	48 8b 40 10          	mov    0x10(%rax),%rax
  803c95:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c9d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803ca1:	48 89 cf             	mov    %rcx,%rdi
  803ca4:	ff d0                	callq  *%rax
}
  803ca6:	c9                   	leaveq 
  803ca7:	c3                   	retq   

0000000000803ca8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803ca8:	55                   	push   %rbp
  803ca9:	48 89 e5             	mov    %rsp,%rbp
  803cac:	48 83 ec 30          	sub    $0x30,%rsp
  803cb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cb7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cc2:	eb 49                	jmp    803d0d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc7:	48 98                	cltq   
  803cc9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ccd:	48 29 c2             	sub    %rax,%rdx
  803cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd3:	48 63 c8             	movslq %eax,%rcx
  803cd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cda:	48 01 c1             	add    %rax,%rcx
  803cdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce0:	48 89 ce             	mov    %rcx,%rsi
  803ce3:	89 c7                	mov    %eax,%edi
  803ce5:	48 b8 d3 3b 80 00 00 	movabs $0x803bd3,%rax
  803cec:	00 00 00 
  803cef:	ff d0                	callq  *%rax
  803cf1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803cf4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803cf8:	79 05                	jns    803cff <readn+0x57>
			return m;
  803cfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cfd:	eb 1c                	jmp    803d1b <readn+0x73>
		if (m == 0)
  803cff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d03:	75 02                	jne    803d07 <readn+0x5f>
			break;
  803d05:	eb 11                	jmp    803d18 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d0a:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d10:	48 98                	cltq   
  803d12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803d16:	72 ac                	jb     803cc4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d1b:	c9                   	leaveq 
  803d1c:	c3                   	retq   

0000000000803d1d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803d1d:	55                   	push   %rbp
  803d1e:	48 89 e5             	mov    %rsp,%rbp
  803d21:	48 83 ec 40          	sub    $0x40,%rsp
  803d25:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d2c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803d30:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d34:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d37:	48 89 d6             	mov    %rdx,%rsi
  803d3a:	89 c7                	mov    %eax,%edi
  803d3c:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803d43:	00 00 00 
  803d46:	ff d0                	callq  *%rax
  803d48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d4f:	78 24                	js     803d75 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d55:	8b 00                	mov    (%rax),%eax
  803d57:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d5b:	48 89 d6             	mov    %rdx,%rsi
  803d5e:	89 c7                	mov    %eax,%edi
  803d60:	48 b8 fa 38 80 00 00 	movabs $0x8038fa,%rax
  803d67:	00 00 00 
  803d6a:	ff d0                	callq  *%rax
  803d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d73:	79 05                	jns    803d7a <write+0x5d>
		return r;
  803d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d78:	eb 75                	jmp    803def <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d7e:	8b 40 08             	mov    0x8(%rax),%eax
  803d81:	83 e0 03             	and    $0x3,%eax
  803d84:	85 c0                	test   %eax,%eax
  803d86:	75 3a                	jne    803dc2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803d88:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803d8f:	00 00 00 
  803d92:	48 8b 00             	mov    (%rax),%rax
  803d95:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d9b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d9e:	89 c6                	mov    %eax,%esi
  803da0:	48 bf db 64 80 00 00 	movabs $0x8064db,%rdi
  803da7:	00 00 00 
  803daa:	b8 00 00 00 00       	mov    $0x0,%eax
  803daf:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  803db6:	00 00 00 
  803db9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803dbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803dc0:	eb 2d                	jmp    803def <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc6:	48 8b 40 18          	mov    0x18(%rax),%rax
  803dca:	48 85 c0             	test   %rax,%rax
  803dcd:	75 07                	jne    803dd6 <write+0xb9>
		return -E_NOT_SUPP;
  803dcf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803dd4:	eb 19                	jmp    803def <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dda:	48 8b 40 18          	mov    0x18(%rax),%rax
  803dde:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803de2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803de6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803dea:	48 89 cf             	mov    %rcx,%rdi
  803ded:	ff d0                	callq  *%rax
}
  803def:	c9                   	leaveq 
  803df0:	c3                   	retq   

0000000000803df1 <seek>:

int
seek(int fdnum, off_t offset)
{
  803df1:	55                   	push   %rbp
  803df2:	48 89 e5             	mov    %rsp,%rbp
  803df5:	48 83 ec 18          	sub    $0x18,%rsp
  803df9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dfc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e06:	48 89 d6             	mov    %rdx,%rsi
  803e09:	89 c7                	mov    %eax,%edi
  803e0b:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803e12:	00 00 00 
  803e15:	ff d0                	callq  *%rax
  803e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1e:	79 05                	jns    803e25 <seek+0x34>
		return r;
  803e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e23:	eb 0f                	jmp    803e34 <seek+0x43>
	fd->fd_offset = offset;
  803e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e29:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e2c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e34:	c9                   	leaveq 
  803e35:	c3                   	retq   

0000000000803e36 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803e36:	55                   	push   %rbp
  803e37:	48 89 e5             	mov    %rsp,%rbp
  803e3a:	48 83 ec 30          	sub    $0x30,%rsp
  803e3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803e41:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803e44:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e48:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e4b:	48 89 d6             	mov    %rdx,%rsi
  803e4e:	89 c7                	mov    %eax,%edi
  803e50:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803e57:	00 00 00 
  803e5a:	ff d0                	callq  *%rax
  803e5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e63:	78 24                	js     803e89 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e69:	8b 00                	mov    (%rax),%eax
  803e6b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e6f:	48 89 d6             	mov    %rdx,%rsi
  803e72:	89 c7                	mov    %eax,%edi
  803e74:	48 b8 fa 38 80 00 00 	movabs $0x8038fa,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
  803e80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e87:	79 05                	jns    803e8e <ftruncate+0x58>
		return r;
  803e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8c:	eb 72                	jmp    803f00 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e92:	8b 40 08             	mov    0x8(%rax),%eax
  803e95:	83 e0 03             	and    $0x3,%eax
  803e98:	85 c0                	test   %eax,%eax
  803e9a:	75 3a                	jne    803ed6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803e9c:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  803ea3:	00 00 00 
  803ea6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803ea9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803eaf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803eb2:	89 c6                	mov    %eax,%esi
  803eb4:	48 bf f8 64 80 00 00 	movabs $0x8064f8,%rdi
  803ebb:	00 00 00 
  803ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec3:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  803eca:	00 00 00 
  803ecd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803ecf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803ed4:	eb 2a                	jmp    803f00 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eda:	48 8b 40 30          	mov    0x30(%rax),%rax
  803ede:	48 85 c0             	test   %rax,%rax
  803ee1:	75 07                	jne    803eea <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803ee3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803ee8:	eb 16                	jmp    803f00 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eee:	48 8b 40 30          	mov    0x30(%rax),%rax
  803ef2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ef6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803ef9:	89 ce                	mov    %ecx,%esi
  803efb:	48 89 d7             	mov    %rdx,%rdi
  803efe:	ff d0                	callq  *%rax
}
  803f00:	c9                   	leaveq 
  803f01:	c3                   	retq   

0000000000803f02 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803f02:	55                   	push   %rbp
  803f03:	48 89 e5             	mov    %rsp,%rbp
  803f06:	48 83 ec 30          	sub    $0x30,%rsp
  803f0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803f11:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f18:	48 89 d6             	mov    %rdx,%rsi
  803f1b:	89 c7                	mov    %eax,%edi
  803f1d:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  803f24:	00 00 00 
  803f27:	ff d0                	callq  *%rax
  803f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f30:	78 24                	js     803f56 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f36:	8b 00                	mov    (%rax),%eax
  803f38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f3c:	48 89 d6             	mov    %rdx,%rsi
  803f3f:	89 c7                	mov    %eax,%edi
  803f41:	48 b8 fa 38 80 00 00 	movabs $0x8038fa,%rax
  803f48:	00 00 00 
  803f4b:	ff d0                	callq  *%rax
  803f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f54:	79 05                	jns    803f5b <fstat+0x59>
		return r;
  803f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f59:	eb 5e                	jmp    803fb9 <fstat+0xb7>
	if (!dev->dev_stat)
  803f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5f:	48 8b 40 28          	mov    0x28(%rax),%rax
  803f63:	48 85 c0             	test   %rax,%rax
  803f66:	75 07                	jne    803f6f <fstat+0x6d>
		return -E_NOT_SUPP;
  803f68:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f6d:	eb 4a                	jmp    803fb9 <fstat+0xb7>
	stat->st_name[0] = 0;
  803f6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f73:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803f76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803f81:	00 00 00 
	stat->st_isdir = 0;
  803f84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f88:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f8f:	00 00 00 
	stat->st_dev = dev;
  803f92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f9a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa5:	48 8b 40 28          	mov    0x28(%rax),%rax
  803fa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fad:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803fb1:	48 89 ce             	mov    %rcx,%rsi
  803fb4:	48 89 d7             	mov    %rdx,%rdi
  803fb7:	ff d0                	callq  *%rax
}
  803fb9:	c9                   	leaveq 
  803fba:	c3                   	retq   

0000000000803fbb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803fbb:	55                   	push   %rbp
  803fbc:	48 89 e5             	mov    %rsp,%rbp
  803fbf:	48 83 ec 20          	sub    $0x20,%rsp
  803fc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fcf:	be 00 00 00 00       	mov    $0x0,%esi
  803fd4:	48 89 c7             	mov    %rax,%rdi
  803fd7:	48 b8 a9 40 80 00 00 	movabs $0x8040a9,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fea:	79 05                	jns    803ff1 <stat+0x36>
		return fd;
  803fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fef:	eb 2f                	jmp    804020 <stat+0x65>
	r = fstat(fd, stat);
  803ff1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff8:	48 89 d6             	mov    %rdx,%rsi
  803ffb:	89 c7                	mov    %eax,%edi
  803ffd:	48 b8 02 3f 80 00 00 	movabs $0x803f02,%rax
  804004:	00 00 00 
  804007:	ff d0                	callq  *%rax
  804009:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80400c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400f:	89 c7                	mov    %eax,%edi
  804011:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  804018:	00 00 00 
  80401b:	ff d0                	callq  *%rax
	return r;
  80401d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  804020:	c9                   	leaveq 
  804021:	c3                   	retq   

0000000000804022 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  804022:	55                   	push   %rbp
  804023:	48 89 e5             	mov    %rsp,%rbp
  804026:	48 83 ec 10          	sub    $0x10,%rsp
  80402a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80402d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  804031:	48 b8 40 94 80 00 00 	movabs $0x809440,%rax
  804038:	00 00 00 
  80403b:	8b 00                	mov    (%rax),%eax
  80403d:	85 c0                	test   %eax,%eax
  80403f:	75 1d                	jne    80405e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  804041:	bf 01 00 00 00       	mov    $0x1,%edi
  804046:	48 b8 e7 5b 80 00 00 	movabs $0x805be7,%rax
  80404d:	00 00 00 
  804050:	ff d0                	callq  *%rax
  804052:	48 ba 40 94 80 00 00 	movabs $0x809440,%rdx
  804059:	00 00 00 
  80405c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80405e:	48 b8 40 94 80 00 00 	movabs $0x809440,%rax
  804065:	00 00 00 
  804068:	8b 00                	mov    (%rax),%eax
  80406a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80406d:	b9 07 00 00 00       	mov    $0x7,%ecx
  804072:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  804079:	00 00 00 
  80407c:	89 c7                	mov    %eax,%edi
  80407e:	48 b8 4f 5b 80 00 00 	movabs $0x805b4f,%rax
  804085:	00 00 00 
  804088:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80408a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408e:	ba 00 00 00 00       	mov    $0x0,%edx
  804093:	48 89 c6             	mov    %rax,%rsi
  804096:	bf 00 00 00 00       	mov    $0x0,%edi
  80409b:	48 b8 86 5a 80 00 00 	movabs $0x805a86,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
}
  8040a7:	c9                   	leaveq 
  8040a8:	c3                   	retq   

00000000008040a9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8040a9:	55                   	push   %rbp
  8040aa:	48 89 e5             	mov    %rsp,%rbp
  8040ad:	48 83 ec 20          	sub    $0x20,%rsp
  8040b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040b5:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8040b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040bc:	48 89 c7             	mov    %rax,%rdi
  8040bf:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  8040c6:	00 00 00 
  8040c9:	ff d0                	callq  *%rax
  8040cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8040d0:	7e 0a                	jle    8040dc <open+0x33>
		return -E_BAD_PATH;
  8040d2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8040d7:	e9 a5 00 00 00       	jmpq   804181 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8040dc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040e0:	48 89 c7             	mov    %rax,%rdi
  8040e3:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  8040ea:	00 00 00 
  8040ed:	ff d0                	callq  *%rax
  8040ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f6:	79 08                	jns    804100 <open+0x57>
		return r;
  8040f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040fb:	e9 81 00 00 00       	jmpq   804181 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  804100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804104:	48 89 c6             	mov    %rax,%rsi
  804107:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  80410e:	00 00 00 
  804111:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  804118:	00 00 00 
  80411b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80411d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804124:	00 00 00 
  804127:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80412a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  804130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804134:	48 89 c6             	mov    %rax,%rsi
  804137:	bf 01 00 00 00       	mov    $0x1,%edi
  80413c:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  804143:	00 00 00 
  804146:	ff d0                	callq  *%rax
  804148:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80414f:	79 1d                	jns    80416e <open+0xc5>
		fd_close(fd, 0);
  804151:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804155:	be 00 00 00 00       	mov    $0x0,%esi
  80415a:	48 89 c7             	mov    %rax,%rdi
  80415d:	48 b8 31 38 80 00 00 	movabs $0x803831,%rax
  804164:	00 00 00 
  804167:	ff d0                	callq  *%rax
		return r;
  804169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416c:	eb 13                	jmp    804181 <open+0xd8>
	}

	return fd2num(fd);
  80416e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804172:	48 89 c7             	mov    %rax,%rdi
  804175:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  80417c:	00 00 00 
  80417f:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  804181:	c9                   	leaveq 
  804182:	c3                   	retq   

0000000000804183 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804183:	55                   	push   %rbp
  804184:	48 89 e5             	mov    %rsp,%rbp
  804187:	48 83 ec 10          	sub    $0x10,%rsp
  80418b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80418f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804193:	8b 50 0c             	mov    0xc(%rax),%edx
  804196:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80419d:	00 00 00 
  8041a0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8041a2:	be 00 00 00 00       	mov    $0x0,%esi
  8041a7:	bf 06 00 00 00       	mov    $0x6,%edi
  8041ac:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
}
  8041b8:	c9                   	leaveq 
  8041b9:	c3                   	retq   

00000000008041ba <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8041ba:	55                   	push   %rbp
  8041bb:	48 89 e5             	mov    %rsp,%rbp
  8041be:	48 83 ec 30          	sub    $0x30,%rsp
  8041c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8041ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8041d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041dc:	00 00 00 
  8041df:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8041e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8041e8:	00 00 00 
  8041eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041ef:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8041f3:	be 00 00 00 00       	mov    $0x0,%esi
  8041f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8041fd:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  804204:	00 00 00 
  804207:	ff d0                	callq  *%rax
  804209:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80420c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804210:	79 05                	jns    804217 <devfile_read+0x5d>
		return r;
  804212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804215:	eb 26                	jmp    80423d <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  804217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421a:	48 63 d0             	movslq %eax,%rdx
  80421d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804221:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  804228:	00 00 00 
  80422b:	48 89 c7             	mov    %rax,%rdi
  80422e:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  804235:	00 00 00 
  804238:	ff d0                	callq  *%rax

	return r;
  80423a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80423d:	c9                   	leaveq 
  80423e:	c3                   	retq   

000000000080423f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80423f:	55                   	push   %rbp
  804240:	48 89 e5             	mov    %rsp,%rbp
  804243:	48 83 ec 30          	sub    $0x30,%rsp
  804247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80424b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80424f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  804253:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80425a:	00 
  80425b:	76 08                	jbe    804265 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80425d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  804264:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804265:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804269:	8b 50 0c             	mov    0xc(%rax),%edx
  80426c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804273:	00 00 00 
  804276:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  804278:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80427f:	00 00 00 
  804282:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804286:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80428a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80428e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804292:	48 89 c6             	mov    %rax,%rsi
  804295:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  80429c:	00 00 00 
  80429f:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  8042a6:	00 00 00 
  8042a9:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8042ab:	be 00 00 00 00       	mov    $0x0,%esi
  8042b0:	bf 04 00 00 00       	mov    $0x4,%edi
  8042b5:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  8042bc:	00 00 00 
  8042bf:	ff d0                	callq  *%rax
  8042c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c8:	79 05                	jns    8042cf <devfile_write+0x90>
		return r;
  8042ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cd:	eb 03                	jmp    8042d2 <devfile_write+0x93>

	return r;
  8042cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8042d2:	c9                   	leaveq 
  8042d3:	c3                   	retq   

00000000008042d4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8042d4:	55                   	push   %rbp
  8042d5:	48 89 e5             	mov    %rsp,%rbp
  8042d8:	48 83 ec 20          	sub    $0x20,%rsp
  8042dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8042e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8042eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8042f2:	00 00 00 
  8042f5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8042f7:	be 00 00 00 00       	mov    $0x0,%esi
  8042fc:	bf 05 00 00 00       	mov    $0x5,%edi
  804301:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  804308:	00 00 00 
  80430b:	ff d0                	callq  *%rax
  80430d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804310:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804314:	79 05                	jns    80431b <devfile_stat+0x47>
		return r;
  804316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804319:	eb 56                	jmp    804371 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80431b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80431f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  804326:	00 00 00 
  804329:	48 89 c7             	mov    %rax,%rdi
  80432c:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  804333:	00 00 00 
  804336:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804338:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80433f:	00 00 00 
  804342:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804348:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80434c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804352:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804359:	00 00 00 
  80435c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  804362:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804366:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80436c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804371:	c9                   	leaveq 
  804372:	c3                   	retq   

0000000000804373 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  804373:	55                   	push   %rbp
  804374:	48 89 e5             	mov    %rsp,%rbp
  804377:	48 83 ec 10          	sub    $0x10,%rsp
  80437b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80437f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  804382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804386:	8b 50 0c             	mov    0xc(%rax),%edx
  804389:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  804390:	00 00 00 
  804393:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  804395:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80439c:	00 00 00 
  80439f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8043a2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8043a5:	be 00 00 00 00       	mov    $0x0,%esi
  8043aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8043af:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  8043b6:	00 00 00 
  8043b9:	ff d0                	callq  *%rax
}
  8043bb:	c9                   	leaveq 
  8043bc:	c3                   	retq   

00000000008043bd <remove>:

// Delete a file
int
remove(const char *path)
{
  8043bd:	55                   	push   %rbp
  8043be:	48 89 e5             	mov    %rsp,%rbp
  8043c1:	48 83 ec 10          	sub    $0x10,%rsp
  8043c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8043c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043cd:	48 89 c7             	mov    %rax,%rdi
  8043d0:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  8043d7:	00 00 00 
  8043da:	ff d0                	callq  *%rax
  8043dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8043e1:	7e 07                	jle    8043ea <remove+0x2d>
		return -E_BAD_PATH;
  8043e3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8043e8:	eb 33                	jmp    80441d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8043ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ee:	48 89 c6             	mov    %rax,%rsi
  8043f1:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8043f8:	00 00 00 
  8043fb:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  804402:	00 00 00 
  804405:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  804407:	be 00 00 00 00       	mov    $0x0,%esi
  80440c:	bf 07 00 00 00       	mov    $0x7,%edi
  804411:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  804418:	00 00 00 
  80441b:	ff d0                	callq  *%rax
}
  80441d:	c9                   	leaveq 
  80441e:	c3                   	retq   

000000000080441f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80441f:	55                   	push   %rbp
  804420:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  804423:	be 00 00 00 00       	mov    $0x0,%esi
  804428:	bf 08 00 00 00       	mov    $0x8,%edi
  80442d:	48 b8 22 40 80 00 00 	movabs $0x804022,%rax
  804434:	00 00 00 
  804437:	ff d0                	callq  *%rax
}
  804439:	5d                   	pop    %rbp
  80443a:	c3                   	retq   

000000000080443b <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80443b:	55                   	push   %rbp
  80443c:	48 89 e5             	mov    %rsp,%rbp
  80443f:	48 83 ec 20          	sub    $0x20,%rsp
  804443:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804447:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80444b:	8b 40 0c             	mov    0xc(%rax),%eax
  80444e:	85 c0                	test   %eax,%eax
  804450:	7e 67                	jle    8044b9 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  804452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804456:	8b 40 04             	mov    0x4(%rax),%eax
  804459:	48 63 d0             	movslq %eax,%rdx
  80445c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804460:	48 8d 48 10          	lea    0x10(%rax),%rcx
  804464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804468:	8b 00                	mov    (%rax),%eax
  80446a:	48 89 ce             	mov    %rcx,%rsi
  80446d:	89 c7                	mov    %eax,%edi
  80446f:	48 b8 1d 3d 80 00 00 	movabs $0x803d1d,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
  80447b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80447e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804482:	7e 13                	jle    804497 <writebuf+0x5c>
			b->result += result;
  804484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804488:	8b 50 08             	mov    0x8(%rax),%edx
  80448b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80448e:	01 c2                	add    %eax,%edx
  804490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804494:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  804497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80449b:	8b 40 04             	mov    0x4(%rax),%eax
  80449e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8044a1:	74 16                	je     8044b9 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8044a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ac:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8044b0:	89 c2                	mov    %eax,%edx
  8044b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b6:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8044b9:	c9                   	leaveq 
  8044ba:	c3                   	retq   

00000000008044bb <putch>:

static void
putch(int ch, void *thunk)
{
  8044bb:	55                   	push   %rbp
  8044bc:	48 89 e5             	mov    %rsp,%rbp
  8044bf:	48 83 ec 20          	sub    $0x20,%rsp
  8044c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8044c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8044ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8044d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d6:	8b 40 04             	mov    0x4(%rax),%eax
  8044d9:	8d 48 01             	lea    0x1(%rax),%ecx
  8044dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044e0:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8044e3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8044e6:	89 d1                	mov    %edx,%ecx
  8044e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044ec:	48 98                	cltq   
  8044ee:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8044f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f6:	8b 40 04             	mov    0x4(%rax),%eax
  8044f9:	3d 00 01 00 00       	cmp    $0x100,%eax
  8044fe:	75 1e                	jne    80451e <putch+0x63>
		writebuf(b);
  804500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804504:	48 89 c7             	mov    %rax,%rdi
  804507:	48 b8 3b 44 80 00 00 	movabs $0x80443b,%rax
  80450e:	00 00 00 
  804511:	ff d0                	callq  *%rax
		b->idx = 0;
  804513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80451e:	c9                   	leaveq 
  80451f:	c3                   	retq   

0000000000804520 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804520:	55                   	push   %rbp
  804521:	48 89 e5             	mov    %rsp,%rbp
  804524:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  80452b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804531:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804538:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80453f:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804545:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  80454b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804552:	00 00 00 
	b.result = 0;
  804555:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  80455c:	00 00 00 
	b.error = 1;
  80455f:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804566:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804569:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  804570:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804577:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80457e:	48 89 c6             	mov    %rax,%rsi
  804581:	48 bf bb 44 80 00 00 	movabs $0x8044bb,%rdi
  804588:	00 00 00 
  80458b:	48 b8 e8 17 80 00 00 	movabs $0x8017e8,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804597:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80459d:	85 c0                	test   %eax,%eax
  80459f:	7e 16                	jle    8045b7 <vfprintf+0x97>
		writebuf(&b);
  8045a1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8045a8:	48 89 c7             	mov    %rax,%rdi
  8045ab:	48 b8 3b 44 80 00 00 	movabs $0x80443b,%rax
  8045b2:	00 00 00 
  8045b5:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8045b7:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8045bd:	85 c0                	test   %eax,%eax
  8045bf:	74 08                	je     8045c9 <vfprintf+0xa9>
  8045c1:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8045c7:	eb 06                	jmp    8045cf <vfprintf+0xaf>
  8045c9:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8045cf:	c9                   	leaveq 
  8045d0:	c3                   	retq   

00000000008045d1 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8045d1:	55                   	push   %rbp
  8045d2:	48 89 e5             	mov    %rsp,%rbp
  8045d5:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8045dc:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8045e2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8045e9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8045f0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8045f7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8045fe:	84 c0                	test   %al,%al
  804600:	74 20                	je     804622 <fprintf+0x51>
  804602:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804606:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80460a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80460e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804612:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804616:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80461a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80461e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804622:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804629:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804630:	00 00 00 
  804633:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80463a:	00 00 00 
  80463d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804641:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804648:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80464f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804656:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80465d:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804664:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80466a:	48 89 ce             	mov    %rcx,%rsi
  80466d:	89 c7                	mov    %eax,%edi
  80466f:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  804676:	00 00 00 
  804679:	ff d0                	callq  *%rax
  80467b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804681:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804687:	c9                   	leaveq 
  804688:	c3                   	retq   

0000000000804689 <printf>:

int
printf(const char *fmt, ...)
{
  804689:	55                   	push   %rbp
  80468a:	48 89 e5             	mov    %rsp,%rbp
  80468d:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804694:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80469b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8046a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8046a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8046b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8046b7:	84 c0                	test   %al,%al
  8046b9:	74 20                	je     8046db <printf+0x52>
  8046bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8046bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8046c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8046c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8046cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8046cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8046d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8046d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8046db:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8046e2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8046e9:	00 00 00 
  8046ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8046f3:	00 00 00 
  8046f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8046fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804701:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804708:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80470f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804716:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80471d:	48 89 c6             	mov    %rax,%rsi
  804720:	bf 01 00 00 00       	mov    $0x1,%edi
  804725:	48 b8 20 45 80 00 00 	movabs $0x804520,%rax
  80472c:	00 00 00 
  80472f:	ff d0                	callq  *%rax
  804731:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804737:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80473d:	c9                   	leaveq 
  80473e:	c3                   	retq   

000000000080473f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80473f:	55                   	push   %rbp
  804740:	48 89 e5             	mov    %rsp,%rbp
  804743:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80474a:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804751:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804758:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80475f:	be 00 00 00 00       	mov    $0x0,%esi
  804764:	48 89 c7             	mov    %rax,%rdi
  804767:	48 b8 a9 40 80 00 00 	movabs $0x8040a9,%rax
  80476e:	00 00 00 
  804771:	ff d0                	callq  *%rax
  804773:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804776:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80477a:	79 08                	jns    804784 <spawn+0x45>
		return r;
  80477c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80477f:	e9 14 03 00 00       	jmpq   804a98 <spawn+0x359>
	fd = r;
  804784:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804787:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  80478a:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804791:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804795:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80479c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80479f:	ba 00 02 00 00       	mov    $0x200,%edx
  8047a4:	48 89 ce             	mov    %rcx,%rsi
  8047a7:	89 c7                	mov    %eax,%edi
  8047a9:	48 b8 a8 3c 80 00 00 	movabs $0x803ca8,%rax
  8047b0:	00 00 00 
  8047b3:	ff d0                	callq  *%rax
  8047b5:	3d 00 02 00 00       	cmp    $0x200,%eax
  8047ba:	75 0d                	jne    8047c9 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  8047bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047c0:	8b 00                	mov    (%rax),%eax
  8047c2:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8047c7:	74 43                	je     80480c <spawn+0xcd>
		close(fd);
  8047c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8047cc:	89 c7                	mov    %eax,%edi
  8047ce:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  8047d5:	00 00 00 
  8047d8:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8047da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047de:	8b 00                	mov    (%rax),%eax
  8047e0:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8047e5:	89 c6                	mov    %eax,%esi
  8047e7:	48 bf 20 65 80 00 00 	movabs $0x806520,%rdi
  8047ee:	00 00 00 
  8047f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8047f6:	48 b9 35 14 80 00 00 	movabs $0x801435,%rcx
  8047fd:	00 00 00 
  804800:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804802:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804807:	e9 8c 02 00 00       	jmpq   804a98 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80480c:	b8 07 00 00 00       	mov    $0x7,%eax
  804811:	cd 30                	int    $0x30
  804813:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804816:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804819:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80481c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804820:	79 08                	jns    80482a <spawn+0xeb>
		return r;
  804822:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804825:	e9 6e 02 00 00       	jmpq   804a98 <spawn+0x359>
	child = r;
  80482a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80482d:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804830:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804833:	25 ff 03 00 00       	and    $0x3ff,%eax
  804838:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80483f:	00 00 00 
  804842:	48 63 d0             	movslq %eax,%rdx
  804845:	48 89 d0             	mov    %rdx,%rax
  804848:	48 c1 e0 03          	shl    $0x3,%rax
  80484c:	48 01 d0             	add    %rdx,%rax
  80484f:	48 c1 e0 05          	shl    $0x5,%rax
  804853:	48 01 c8             	add    %rcx,%rax
  804856:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80485d:	48 89 c6             	mov    %rax,%rsi
  804860:	b8 18 00 00 00       	mov    $0x18,%eax
  804865:	48 89 d7             	mov    %rdx,%rdi
  804868:	48 89 c1             	mov    %rax,%rcx
  80486b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  80486e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804872:	48 8b 40 18          	mov    0x18(%rax),%rax
  804876:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  80487d:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804884:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80488b:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804892:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804895:	48 89 ce             	mov    %rcx,%rsi
  804898:	89 c7                	mov    %eax,%edi
  80489a:	48 b8 02 4d 80 00 00 	movabs $0x804d02,%rax
  8048a1:	00 00 00 
  8048a4:	ff d0                	callq  *%rax
  8048a6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8048a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8048ad:	79 08                	jns    8048b7 <spawn+0x178>
		return r;
  8048af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8048b2:	e9 e1 01 00 00       	jmpq   804a98 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8048b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048bb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8048bf:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8048c6:	48 01 d0             	add    %rdx,%rax
  8048c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8048cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048d4:	e9 a3 00 00 00       	jmpq   80497c <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8048d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048dd:	8b 00                	mov    (%rax),%eax
  8048df:	83 f8 01             	cmp    $0x1,%eax
  8048e2:	74 05                	je     8048e9 <spawn+0x1aa>
			continue;
  8048e4:	e9 8a 00 00 00       	jmpq   804973 <spawn+0x234>
		perm = PTE_P | PTE_U;
  8048e9:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8048f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048f4:	8b 40 04             	mov    0x4(%rax),%eax
  8048f7:	83 e0 02             	and    $0x2,%eax
  8048fa:	85 c0                	test   %eax,%eax
  8048fc:	74 04                	je     804902 <spawn+0x1c3>
			perm |= PTE_W;
  8048fe:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804902:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804906:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80490a:	41 89 c1             	mov    %eax,%r9d
  80490d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804911:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804915:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804919:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80491d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804921:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804925:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804928:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80492b:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80492e:	89 3c 24             	mov    %edi,(%rsp)
  804931:	89 c7                	mov    %eax,%edi
  804933:	48 b8 ab 4f 80 00 00 	movabs $0x804fab,%rax
  80493a:	00 00 00 
  80493d:	ff d0                	callq  *%rax
  80493f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804942:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804946:	79 2b                	jns    804973 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804948:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804949:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80494c:	89 c7                	mov    %eax,%edi
  80494e:	48 b8 a6 2b 80 00 00 	movabs $0x802ba6,%rax
  804955:	00 00 00 
  804958:	ff d0                	callq  *%rax
	close(fd);
  80495a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80495d:	89 c7                	mov    %eax,%edi
  80495f:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  804966:	00 00 00 
  804969:	ff d0                	callq  *%rax
	return r;
  80496b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80496e:	e9 25 01 00 00       	jmpq   804a98 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804973:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804977:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80497c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804980:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804984:	0f b7 c0             	movzwl %ax,%eax
  804987:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80498a:	0f 8f 49 ff ff ff    	jg     8048d9 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804990:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804993:	89 c7                	mov    %eax,%edi
  804995:	48 b8 b1 39 80 00 00 	movabs $0x8039b1,%rax
  80499c:	00 00 00 
  80499f:	ff d0                	callq  *%rax
	fd = -1;
  8049a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8049a8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049ab:	89 c7                	mov    %eax,%edi
  8049ad:	48 b8 97 51 80 00 00 	movabs $0x805197,%rax
  8049b4:	00 00 00 
  8049b7:	ff d0                	callq  *%rax
  8049b9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8049bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8049c0:	79 30                	jns    8049f2 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8049c2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8049c5:	89 c1                	mov    %eax,%ecx
  8049c7:	48 ba 3a 65 80 00 00 	movabs $0x80653a,%rdx
  8049ce:	00 00 00 
  8049d1:	be 82 00 00 00       	mov    $0x82,%esi
  8049d6:	48 bf 50 65 80 00 00 	movabs $0x806550,%rdi
  8049dd:	00 00 00 
  8049e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8049e5:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  8049ec:	00 00 00 
  8049ef:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8049f2:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8049f9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8049fc:	48 89 d6             	mov    %rdx,%rsi
  8049ff:	89 c7                	mov    %eax,%edi
  804a01:	48 b8 a6 2d 80 00 00 	movabs $0x802da6,%rax
  804a08:	00 00 00 
  804a0b:	ff d0                	callq  *%rax
  804a0d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a10:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a14:	79 30                	jns    804a46 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804a16:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a19:	89 c1                	mov    %eax,%ecx
  804a1b:	48 ba 5c 65 80 00 00 	movabs $0x80655c,%rdx
  804a22:	00 00 00 
  804a25:	be 85 00 00 00       	mov    $0x85,%esi
  804a2a:	48 bf 50 65 80 00 00 	movabs $0x806550,%rdi
  804a31:	00 00 00 
  804a34:	b8 00 00 00 00       	mov    $0x0,%eax
  804a39:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  804a40:	00 00 00 
  804a43:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804a46:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804a49:	be 02 00 00 00       	mov    $0x2,%esi
  804a4e:	89 c7                	mov    %eax,%edi
  804a50:	48 b8 5b 2d 80 00 00 	movabs $0x802d5b,%rax
  804a57:	00 00 00 
  804a5a:	ff d0                	callq  *%rax
  804a5c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a63:	79 30                	jns    804a95 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804a65:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a68:	89 c1                	mov    %eax,%ecx
  804a6a:	48 ba 76 65 80 00 00 	movabs $0x806576,%rdx
  804a71:	00 00 00 
  804a74:	be 88 00 00 00       	mov    $0x88,%esi
  804a79:	48 bf 50 65 80 00 00 	movabs $0x806550,%rdi
  804a80:	00 00 00 
  804a83:	b8 00 00 00 00       	mov    $0x0,%eax
  804a88:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  804a8f:	00 00 00 
  804a92:	41 ff d0             	callq  *%r8

	return child;
  804a95:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804a98:	c9                   	leaveq 
  804a99:	c3                   	retq   

0000000000804a9a <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804a9a:	55                   	push   %rbp
  804a9b:	48 89 e5             	mov    %rsp,%rbp
  804a9e:	41 55                	push   %r13
  804aa0:	41 54                	push   %r12
  804aa2:	53                   	push   %rbx
  804aa3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804aaa:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804ab1:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804ab8:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804abf:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804ac6:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804acd:	84 c0                	test   %al,%al
  804acf:	74 26                	je     804af7 <spawnl+0x5d>
  804ad1:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804ad8:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804adf:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804ae3:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804ae7:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804aeb:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804aef:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804af3:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804af7:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804afe:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804b05:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804b08:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804b0f:	00 00 00 
  804b12:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804b19:	00 00 00 
  804b1c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b20:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804b27:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804b2e:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  804b35:	eb 07                	jmp    804b3e <spawnl+0xa4>
		argc++;
  804b37:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  804b3e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804b44:	83 f8 30             	cmp    $0x30,%eax
  804b47:	73 23                	jae    804b6c <spawnl+0xd2>
  804b49:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804b50:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804b56:	89 c0                	mov    %eax,%eax
  804b58:	48 01 d0             	add    %rdx,%rax
  804b5b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804b61:	83 c2 08             	add    $0x8,%edx
  804b64:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804b6a:	eb 15                	jmp    804b81 <spawnl+0xe7>
  804b6c:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804b73:	48 89 d0             	mov    %rdx,%rax
  804b76:	48 83 c2 08          	add    $0x8,%rdx
  804b7a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804b81:	48 8b 00             	mov    (%rax),%rax
  804b84:	48 85 c0             	test   %rax,%rax
  804b87:	75 ae                	jne    804b37 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804b89:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804b8f:	83 c0 02             	add    $0x2,%eax
  804b92:	48 89 e2             	mov    %rsp,%rdx
  804b95:	48 89 d3             	mov    %rdx,%rbx
  804b98:	48 63 d0             	movslq %eax,%rdx
  804b9b:	48 83 ea 01          	sub    $0x1,%rdx
  804b9f:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804ba6:	48 63 d0             	movslq %eax,%rdx
  804ba9:	49 89 d4             	mov    %rdx,%r12
  804bac:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804bb2:	48 63 d0             	movslq %eax,%rdx
  804bb5:	49 89 d2             	mov    %rdx,%r10
  804bb8:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804bbe:	48 98                	cltq   
  804bc0:	48 c1 e0 03          	shl    $0x3,%rax
  804bc4:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804bc8:	b8 10 00 00 00       	mov    $0x10,%eax
  804bcd:	48 83 e8 01          	sub    $0x1,%rax
  804bd1:	48 01 d0             	add    %rdx,%rax
  804bd4:	bf 10 00 00 00       	mov    $0x10,%edi
  804bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  804bde:	48 f7 f7             	div    %rdi
  804be1:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804be5:	48 29 c4             	sub    %rax,%rsp
  804be8:	48 89 e0             	mov    %rsp,%rax
  804beb:	48 83 c0 07          	add    $0x7,%rax
  804bef:	48 c1 e8 03          	shr    $0x3,%rax
  804bf3:	48 c1 e0 03          	shl    $0x3,%rax
  804bf7:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804bfe:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c05:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804c0c:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804c0f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804c15:	8d 50 01             	lea    0x1(%rax),%edx
  804c18:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804c1f:	48 63 d2             	movslq %edx,%rdx
  804c22:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804c29:	00 

	va_start(vl, arg0);
  804c2a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804c31:	00 00 00 
  804c34:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804c3b:	00 00 00 
  804c3e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804c42:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804c49:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804c50:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  804c57:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804c5e:	00 00 00 
  804c61:	eb 63                	jmp    804cc6 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804c63:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804c69:	8d 70 01             	lea    0x1(%rax),%esi
  804c6c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804c72:	83 f8 30             	cmp    $0x30,%eax
  804c75:	73 23                	jae    804c9a <spawnl+0x200>
  804c77:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804c7e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804c84:	89 c0                	mov    %eax,%eax
  804c86:	48 01 d0             	add    %rdx,%rax
  804c89:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804c8f:	83 c2 08             	add    $0x8,%edx
  804c92:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804c98:	eb 15                	jmp    804caf <spawnl+0x215>
  804c9a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804ca1:	48 89 d0             	mov    %rdx,%rax
  804ca4:	48 83 c2 08          	add    $0x8,%rdx
  804ca8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804caf:	48 8b 08             	mov    (%rax),%rcx
  804cb2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804cb9:	89 f2                	mov    %esi,%edx
  804cbb:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  804cbf:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804cc6:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804ccc:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804cd2:	77 8f                	ja     804c63 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804cd4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804cdb:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804ce2:	48 89 d6             	mov    %rdx,%rsi
  804ce5:	48 89 c7             	mov    %rax,%rdi
  804ce8:	48 b8 3f 47 80 00 00 	movabs $0x80473f,%rax
  804cef:	00 00 00 
  804cf2:	ff d0                	callq  *%rax
  804cf4:	48 89 dc             	mov    %rbx,%rsp
}
  804cf7:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  804cfb:	5b                   	pop    %rbx
  804cfc:	41 5c                	pop    %r12
  804cfe:	41 5d                	pop    %r13
  804d00:	5d                   	pop    %rbp
  804d01:	c3                   	retq   

0000000000804d02 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  804d02:	55                   	push   %rbp
  804d03:	48 89 e5             	mov    %rsp,%rbp
  804d06:	48 83 ec 50          	sub    $0x50,%rsp
  804d0a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  804d0d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  804d11:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  804d15:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804d1c:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  804d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  804d24:	eb 33                	jmp    804d59 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  804d26:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d29:	48 98                	cltq   
  804d2b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804d32:	00 
  804d33:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804d37:	48 01 d0             	add    %rdx,%rax
  804d3a:	48 8b 00             	mov    (%rax),%rax
  804d3d:	48 89 c7             	mov    %rax,%rdi
  804d40:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  804d47:	00 00 00 
  804d4a:	ff d0                	callq  *%rax
  804d4c:	83 c0 01             	add    $0x1,%eax
  804d4f:	48 98                	cltq   
  804d51:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  804d55:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  804d59:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804d5c:	48 98                	cltq   
  804d5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804d65:	00 
  804d66:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804d6a:	48 01 d0             	add    %rdx,%rax
  804d6d:	48 8b 00             	mov    (%rax),%rax
  804d70:	48 85 c0             	test   %rax,%rax
  804d73:	75 b1                	jne    804d26 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  804d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d79:	48 f7 d8             	neg    %rax
  804d7c:	48 05 00 10 40 00    	add    $0x401000,%rax
  804d82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  804d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  804d8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d92:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  804d96:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804d99:	83 c2 01             	add    $0x1,%edx
  804d9c:	c1 e2 03             	shl    $0x3,%edx
  804d9f:	48 63 d2             	movslq %edx,%rdx
  804da2:	48 f7 da             	neg    %rdx
  804da5:	48 01 d0             	add    %rdx,%rax
  804da8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  804dac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804db0:	48 83 e8 10          	sub    $0x10,%rax
  804db4:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  804dba:	77 0a                	ja     804dc6 <init_stack+0xc4>
		return -E_NO_MEM;
  804dbc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  804dc1:	e9 e3 01 00 00       	jmpq   804fa9 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804dc6:	ba 07 00 00 00       	mov    $0x7,%edx
  804dcb:	be 00 00 40 00       	mov    $0x400000,%esi
  804dd0:	bf 00 00 00 00       	mov    $0x0,%edi
  804dd5:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  804ddc:	00 00 00 
  804ddf:	ff d0                	callq  *%rax
  804de1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804de4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804de8:	79 08                	jns    804df2 <init_stack+0xf0>
		return r;
  804dea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ded:	e9 b7 01 00 00       	jmpq   804fa9 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804df2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  804df9:	e9 8a 00 00 00       	jmpq   804e88 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  804dfe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e01:	48 98                	cltq   
  804e03:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e0a:	00 
  804e0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804e0f:	48 01 c2             	add    %rax,%rdx
  804e12:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804e17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e1b:	48 01 c8             	add    %rcx,%rax
  804e1e:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804e24:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  804e27:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e2a:	48 98                	cltq   
  804e2c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e33:	00 
  804e34:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804e38:	48 01 d0             	add    %rdx,%rax
  804e3b:	48 8b 10             	mov    (%rax),%rdx
  804e3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e42:	48 89 d6             	mov    %rdx,%rsi
  804e45:	48 89 c7             	mov    %rax,%rdi
  804e48:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  804e4f:	00 00 00 
  804e52:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  804e54:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e57:	48 98                	cltq   
  804e59:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804e60:	00 
  804e61:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  804e65:	48 01 d0             	add    %rdx,%rax
  804e68:	48 8b 00             	mov    (%rax),%rax
  804e6b:	48 89 c7             	mov    %rax,%rdi
  804e6e:	48 b8 cb 22 80 00 00 	movabs $0x8022cb,%rax
  804e75:	00 00 00 
  804e78:	ff d0                	callq  *%rax
  804e7a:	48 98                	cltq   
  804e7c:	48 83 c0 01          	add    $0x1,%rax
  804e80:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  804e84:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  804e88:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e8b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  804e8e:	0f 8c 6a ff ff ff    	jl     804dfe <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  804e94:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804e97:	48 98                	cltq   
  804e99:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804ea0:	00 
  804ea1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ea5:	48 01 d0             	add    %rdx,%rax
  804ea8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  804eaf:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  804eb6:	00 
  804eb7:	74 35                	je     804eee <init_stack+0x1ec>
  804eb9:	48 b9 90 65 80 00 00 	movabs $0x806590,%rcx
  804ec0:	00 00 00 
  804ec3:	48 ba b6 65 80 00 00 	movabs $0x8065b6,%rdx
  804eca:	00 00 00 
  804ecd:	be f1 00 00 00       	mov    $0xf1,%esi
  804ed2:	48 bf 50 65 80 00 00 	movabs $0x806550,%rdi
  804ed9:	00 00 00 
  804edc:	b8 00 00 00 00       	mov    $0x0,%eax
  804ee1:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  804ee8:	00 00 00 
  804eeb:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  804eee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804ef2:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  804ef6:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804efb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eff:	48 01 c8             	add    %rcx,%rax
  804f02:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f08:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  804f0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f0f:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  804f13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f16:	48 98                	cltq   
  804f18:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  804f1b:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  804f20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f24:	48 01 d0             	add    %rdx,%rax
  804f27:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  804f2d:	48 89 c2             	mov    %rax,%rdx
  804f30:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f34:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  804f37:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804f3a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  804f40:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  804f45:	89 c2                	mov    %eax,%edx
  804f47:	be 00 00 40 00       	mov    $0x400000,%esi
  804f4c:	bf 00 00 00 00       	mov    $0x0,%edi
  804f51:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  804f58:	00 00 00 
  804f5b:	ff d0                	callq  *%rax
  804f5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f60:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f64:	79 02                	jns    804f68 <init_stack+0x266>
		goto error;
  804f66:	eb 28                	jmp    804f90 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  804f68:	be 00 00 40 00       	mov    $0x400000,%esi
  804f6d:	bf 00 00 00 00       	mov    $0x0,%edi
  804f72:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  804f79:	00 00 00 
  804f7c:	ff d0                	callq  *%rax
  804f7e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804f81:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804f85:	79 02                	jns    804f89 <init_stack+0x287>
		goto error;
  804f87:	eb 07                	jmp    804f90 <init_stack+0x28e>

	return 0;
  804f89:	b8 00 00 00 00       	mov    $0x0,%eax
  804f8e:	eb 19                	jmp    804fa9 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  804f90:	be 00 00 40 00       	mov    $0x400000,%esi
  804f95:	bf 00 00 00 00       	mov    $0x0,%edi
  804f9a:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  804fa1:	00 00 00 
  804fa4:	ff d0                	callq  *%rax
	return r;
  804fa6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804fa9:	c9                   	leaveq 
  804faa:	c3                   	retq   

0000000000804fab <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  804fab:	55                   	push   %rbp
  804fac:	48 89 e5             	mov    %rsp,%rbp
  804faf:	48 83 ec 50          	sub    $0x50,%rsp
  804fb3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804fb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804fba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  804fbe:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  804fc1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804fc5:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  804fc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804fcd:	25 ff 0f 00 00       	and    $0xfff,%eax
  804fd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fd9:	74 21                	je     804ffc <map_segment+0x51>
		va -= i;
  804fdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fde:	48 98                	cltq   
  804fe0:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  804fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fe7:	48 98                	cltq   
  804fe9:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  804fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff0:	48 98                	cltq   
  804ff2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  804ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff9:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805003:	e9 79 01 00 00       	jmpq   805181 <map_segment+0x1d6>
		if (i >= filesz) {
  805008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80500b:	48 98                	cltq   
  80500d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805011:	72 3c                	jb     80504f <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  805013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805016:	48 63 d0             	movslq %eax,%rdx
  805019:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80501d:	48 01 d0             	add    %rdx,%rax
  805020:	48 89 c1             	mov    %rax,%rcx
  805023:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805026:	8b 55 10             	mov    0x10(%rbp),%edx
  805029:	48 89 ce             	mov    %rcx,%rsi
  80502c:	89 c7                	mov    %eax,%edi
  80502e:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  805035:	00 00 00 
  805038:	ff d0                	callq  *%rax
  80503a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80503d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805041:	0f 89 33 01 00 00    	jns    80517a <map_segment+0x1cf>
				return r;
  805047:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80504a:	e9 46 01 00 00       	jmpq   805195 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80504f:	ba 07 00 00 00       	mov    $0x7,%edx
  805054:	be 00 00 40 00       	mov    $0x400000,%esi
  805059:	bf 00 00 00 00       	mov    $0x0,%edi
  80505e:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  805065:	00 00 00 
  805068:	ff d0                	callq  *%rax
  80506a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80506d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805071:	79 08                	jns    80507b <map_segment+0xd0>
				return r;
  805073:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805076:	e9 1a 01 00 00       	jmpq   805195 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80507b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80507e:	8b 55 bc             	mov    -0x44(%rbp),%edx
  805081:	01 c2                	add    %eax,%edx
  805083:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805086:	89 d6                	mov    %edx,%esi
  805088:	89 c7                	mov    %eax,%edi
  80508a:	48 b8 f1 3d 80 00 00 	movabs $0x803df1,%rax
  805091:	00 00 00 
  805094:	ff d0                	callq  *%rax
  805096:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805099:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80509d:	79 08                	jns    8050a7 <map_segment+0xfc>
				return r;
  80509f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050a2:	e9 ee 00 00 00       	jmpq   805195 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8050a7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8050ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050b1:	48 98                	cltq   
  8050b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8050b7:	48 29 c2             	sub    %rax,%rdx
  8050ba:	48 89 d0             	mov    %rdx,%rax
  8050bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8050c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050c4:	48 63 d0             	movslq %eax,%rdx
  8050c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050cb:	48 39 c2             	cmp    %rax,%rdx
  8050ce:	48 0f 47 d0          	cmova  %rax,%rdx
  8050d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8050d5:	be 00 00 40 00       	mov    $0x400000,%esi
  8050da:	89 c7                	mov    %eax,%edi
  8050dc:	48 b8 a8 3c 80 00 00 	movabs $0x803ca8,%rax
  8050e3:	00 00 00 
  8050e6:	ff d0                	callq  *%rax
  8050e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8050eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8050ef:	79 08                	jns    8050f9 <map_segment+0x14e>
				return r;
  8050f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8050f4:	e9 9c 00 00 00       	jmpq   805195 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8050f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050fc:	48 63 d0             	movslq %eax,%rdx
  8050ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805103:	48 01 d0             	add    %rdx,%rax
  805106:	48 89 c2             	mov    %rax,%rdx
  805109:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80510c:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805110:	48 89 d1             	mov    %rdx,%rcx
  805113:	89 c2                	mov    %eax,%edx
  805115:	be 00 00 40 00       	mov    $0x400000,%esi
  80511a:	bf 00 00 00 00       	mov    $0x0,%edi
  80511f:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  805126:	00 00 00 
  805129:	ff d0                	callq  *%rax
  80512b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80512e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805132:	79 30                	jns    805164 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  805134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805137:	89 c1                	mov    %eax,%ecx
  805139:	48 ba cb 65 80 00 00 	movabs $0x8065cb,%rdx
  805140:	00 00 00 
  805143:	be 24 01 00 00       	mov    $0x124,%esi
  805148:	48 bf 50 65 80 00 00 	movabs $0x806550,%rdi
  80514f:	00 00 00 
  805152:	b8 00 00 00 00       	mov    $0x0,%eax
  805157:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  80515e:	00 00 00 
  805161:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805164:	be 00 00 40 00       	mov    $0x400000,%esi
  805169:	bf 00 00 00 00       	mov    $0x0,%edi
  80516e:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  805175:	00 00 00 
  805178:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80517a:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  805181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805184:	48 98                	cltq   
  805186:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80518a:	0f 82 78 fe ff ff    	jb     805008 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  805190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805195:	c9                   	leaveq 
  805196:	c3                   	retq   

0000000000805197 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  805197:	55                   	push   %rbp
  805198:	48 89 e5             	mov    %rsp,%rbp
  80519b:	48 83 ec 50          	sub    $0x50,%rsp
  80519f:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  8051a2:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8051a9:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8051aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8051b1:	00 
  8051b2:	e9 62 01 00 00       	jmpq   805319 <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8051b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051bb:	48 c1 e8 1b          	shr    $0x1b,%rax
  8051bf:	48 89 c2             	mov    %rax,%rdx
  8051c2:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8051c9:	01 00 00 
  8051cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051d0:	83 e0 01             	and    $0x1,%eax
  8051d3:	48 85 c0             	test   %rax,%rax
  8051d6:	75 0d                	jne    8051e5 <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8051d8:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  8051df:	08 
			continue;
  8051e0:	e9 2f 01 00 00       	jmpq   805314 <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8051e5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8051ec:	00 
  8051ed:	e9 14 01 00 00       	jmpq   805306 <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8051f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051f6:	48 c1 e8 12          	shr    $0x12,%rax
  8051fa:	48 89 c2             	mov    %rax,%rdx
  8051fd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805204:	01 00 00 
  805207:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80520b:	83 e0 01             	and    $0x1,%eax
  80520e:	48 85 c0             	test   %rax,%rax
  805211:	75 0d                	jne    805220 <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  805213:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  80521a:	00 
				continue;
  80521b:	e9 e1 00 00 00       	jmpq   805301 <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  805220:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  805227:	00 
  805228:	e9 c6 00 00 00       	jmpq   8052f3 <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80522d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805231:	48 c1 e8 09          	shr    $0x9,%rax
  805235:	48 89 c2             	mov    %rax,%rdx
  805238:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80523f:	01 00 00 
  805242:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805246:	83 e0 01             	and    $0x1,%eax
  805249:	48 85 c0             	test   %rax,%rax
  80524c:	75 0d                	jne    80525b <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  80524e:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  805255:	00 
					continue;
  805256:	e9 93 00 00 00       	jmpq   8052ee <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80525b:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  805262:	00 
  805263:	eb 7b                	jmp    8052e0 <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  805265:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80526c:	01 00 00 
  80526f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805273:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805277:	25 00 04 00 00       	and    $0x400,%eax
  80527c:	48 85 c0             	test   %rax,%rax
  80527f:	74 55                	je     8052d6 <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  805281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805285:	48 c1 e0 0c          	shl    $0xc,%rax
  805289:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  80528d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805294:	01 00 00 
  805297:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80529b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80529f:	25 07 0e 00 00       	and    $0xe07,%eax
  8052a4:	89 c6                	mov    %eax,%esi
  8052a6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8052aa:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8052ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052b1:	41 89 f0             	mov    %esi,%r8d
  8052b4:	48 89 c6             	mov    %rax,%rsi
  8052b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8052bc:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  8052c3:	00 00 00 
  8052c6:	ff d0                	callq  *%rax
  8052c8:	89 45 cc             	mov    %eax,-0x34(%rbp)
  8052cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8052cf:	79 05                	jns    8052d6 <copy_shared_pages+0x13f>
							return r;
  8052d1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8052d4:	eb 53                	jmp    805329 <copy_shared_pages+0x192>
					}
					ptx++;
  8052d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8052db:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8052e0:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8052e7:	00 
  8052e8:	0f 86 77 ff ff ff    	jbe    805265 <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8052ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8052f3:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8052fa:	00 
  8052fb:	0f 86 2c ff ff ff    	jbe    80522d <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  805301:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  805306:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  80530d:	00 
  80530e:	0f 86 de fe ff ff    	jbe    8051f2 <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  805314:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805319:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80531e:	0f 84 93 fe ff ff    	je     8051b7 <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  805324:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805329:	c9                   	leaveq 
  80532a:	c3                   	retq   

000000000080532b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80532b:	55                   	push   %rbp
  80532c:	48 89 e5             	mov    %rsp,%rbp
  80532f:	53                   	push   %rbx
  805330:	48 83 ec 38          	sub    $0x38,%rsp
  805334:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805338:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80533c:	48 89 c7             	mov    %rax,%rdi
  80533f:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  805346:	00 00 00 
  805349:	ff d0                	callq  *%rax
  80534b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80534e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805352:	0f 88 bf 01 00 00    	js     805517 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80535c:	ba 07 04 00 00       	mov    $0x407,%edx
  805361:	48 89 c6             	mov    %rax,%rsi
  805364:	bf 00 00 00 00       	mov    $0x0,%edi
  805369:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  805370:	00 00 00 
  805373:	ff d0                	callq  *%rax
  805375:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805378:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80537c:	0f 88 95 01 00 00    	js     805517 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805382:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805386:	48 89 c7             	mov    %rax,%rdi
  805389:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  805390:	00 00 00 
  805393:	ff d0                	callq  *%rax
  805395:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805398:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80539c:	0f 88 5d 01 00 00    	js     8054ff <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8053ab:	48 89 c6             	mov    %rax,%rsi
  8053ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8053b3:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  8053ba:	00 00 00 
  8053bd:	ff d0                	callq  *%rax
  8053bf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053c6:	0f 88 33 01 00 00    	js     8054ff <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8053cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053d0:	48 89 c7             	mov    %rax,%rdi
  8053d3:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  8053da:	00 00 00 
  8053dd:	ff d0                	callq  *%rax
  8053df:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8053e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053e7:	ba 07 04 00 00       	mov    $0x407,%edx
  8053ec:	48 89 c6             	mov    %rax,%rsi
  8053ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8053f4:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  8053fb:	00 00 00 
  8053fe:	ff d0                	callq  *%rax
  805400:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805403:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805407:	79 05                	jns    80540e <pipe+0xe3>
		goto err2;
  805409:	e9 d9 00 00 00       	jmpq   8054e7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80540e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805412:	48 89 c7             	mov    %rax,%rdi
  805415:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  80541c:	00 00 00 
  80541f:	ff d0                	callq  *%rax
  805421:	48 89 c2             	mov    %rax,%rdx
  805424:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805428:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80542e:	48 89 d1             	mov    %rdx,%rcx
  805431:	ba 00 00 00 00       	mov    $0x0,%edx
  805436:	48 89 c6             	mov    %rax,%rsi
  805439:	bf 00 00 00 00       	mov    $0x0,%edi
  80543e:	48 b8 b6 2c 80 00 00 	movabs $0x802cb6,%rax
  805445:	00 00 00 
  805448:	ff d0                	callq  *%rax
  80544a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80544d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805451:	79 1b                	jns    80546e <pipe+0x143>
		goto err3;
  805453:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  805454:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805458:	48 89 c6             	mov    %rax,%rsi
  80545b:	bf 00 00 00 00       	mov    $0x0,%edi
  805460:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  805467:	00 00 00 
  80546a:	ff d0                	callq  *%rax
  80546c:	eb 79                	jmp    8054e7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80546e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805472:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  805479:	00 00 00 
  80547c:	8b 12                	mov    (%rdx),%edx
  80547e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805484:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80548b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80548f:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  805496:	00 00 00 
  805499:	8b 12                	mov    (%rdx),%edx
  80549b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80549d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8054a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054ac:	48 89 c7             	mov    %rax,%rdi
  8054af:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  8054b6:	00 00 00 
  8054b9:	ff d0                	callq  *%rax
  8054bb:	89 c2                	mov    %eax,%edx
  8054bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8054c1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8054c3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8054c7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8054cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054cf:	48 89 c7             	mov    %rax,%rdi
  8054d2:	48 b8 bb 36 80 00 00 	movabs $0x8036bb,%rax
  8054d9:	00 00 00 
  8054dc:	ff d0                	callq  *%rax
  8054de:	89 03                	mov    %eax,(%rbx)
	return 0;
  8054e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8054e5:	eb 33                	jmp    80551a <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8054e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054eb:	48 89 c6             	mov    %rax,%rsi
  8054ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8054f3:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8054fa:	00 00 00 
  8054fd:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8054ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805503:	48 89 c6             	mov    %rax,%rsi
  805506:	bf 00 00 00 00       	mov    $0x0,%edi
  80550b:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  805512:	00 00 00 
  805515:	ff d0                	callq  *%rax
    err:
	return r;
  805517:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80551a:	48 83 c4 38          	add    $0x38,%rsp
  80551e:	5b                   	pop    %rbx
  80551f:	5d                   	pop    %rbp
  805520:	c3                   	retq   

0000000000805521 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805521:	55                   	push   %rbp
  805522:	48 89 e5             	mov    %rsp,%rbp
  805525:	53                   	push   %rbx
  805526:	48 83 ec 28          	sub    $0x28,%rsp
  80552a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80552e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805532:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805539:	00 00 00 
  80553c:	48 8b 00             	mov    (%rax),%rax
  80553f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805545:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80554c:	48 89 c7             	mov    %rax,%rdi
  80554f:	48 b8 69 5c 80 00 00 	movabs $0x805c69,%rax
  805556:	00 00 00 
  805559:	ff d0                	callq  *%rax
  80555b:	89 c3                	mov    %eax,%ebx
  80555d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805561:	48 89 c7             	mov    %rax,%rdi
  805564:	48 b8 69 5c 80 00 00 	movabs $0x805c69,%rax
  80556b:	00 00 00 
  80556e:	ff d0                	callq  *%rax
  805570:	39 c3                	cmp    %eax,%ebx
  805572:	0f 94 c0             	sete   %al
  805575:	0f b6 c0             	movzbl %al,%eax
  805578:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80557b:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805582:	00 00 00 
  805585:	48 8b 00             	mov    (%rax),%rax
  805588:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80558e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  805591:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805594:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  805597:	75 05                	jne    80559e <_pipeisclosed+0x7d>
			return ret;
  805599:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80559c:	eb 4f                	jmp    8055ed <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80559e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055a1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8055a4:	74 42                	je     8055e8 <_pipeisclosed+0xc7>
  8055a6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8055aa:	75 3c                	jne    8055e8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8055ac:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  8055b3:	00 00 00 
  8055b6:	48 8b 00             	mov    (%rax),%rax
  8055b9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8055bf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8055c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055c5:	89 c6                	mov    %eax,%esi
  8055c7:	48 bf ed 65 80 00 00 	movabs $0x8065ed,%rdi
  8055ce:	00 00 00 
  8055d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8055d6:	49 b8 35 14 80 00 00 	movabs $0x801435,%r8
  8055dd:	00 00 00 
  8055e0:	41 ff d0             	callq  *%r8
	}
  8055e3:	e9 4a ff ff ff       	jmpq   805532 <_pipeisclosed+0x11>
  8055e8:	e9 45 ff ff ff       	jmpq   805532 <_pipeisclosed+0x11>
}
  8055ed:	48 83 c4 28          	add    $0x28,%rsp
  8055f1:	5b                   	pop    %rbx
  8055f2:	5d                   	pop    %rbp
  8055f3:	c3                   	retq   

00000000008055f4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8055f4:	55                   	push   %rbp
  8055f5:	48 89 e5             	mov    %rsp,%rbp
  8055f8:	48 83 ec 30          	sub    $0x30,%rsp
  8055fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8055ff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805603:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805606:	48 89 d6             	mov    %rdx,%rsi
  805609:	89 c7                	mov    %eax,%edi
  80560b:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  805612:	00 00 00 
  805615:	ff d0                	callq  *%rax
  805617:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80561a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80561e:	79 05                	jns    805625 <pipeisclosed+0x31>
		return r;
  805620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805623:	eb 31                	jmp    805656 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  805625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805629:	48 89 c7             	mov    %rax,%rdi
  80562c:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  805633:	00 00 00 
  805636:	ff d0                	callq  *%rax
  805638:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80563c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805640:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805644:	48 89 d6             	mov    %rdx,%rsi
  805647:	48 89 c7             	mov    %rax,%rdi
  80564a:	48 b8 21 55 80 00 00 	movabs $0x805521,%rax
  805651:	00 00 00 
  805654:	ff d0                	callq  *%rax
}
  805656:	c9                   	leaveq 
  805657:	c3                   	retq   

0000000000805658 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  805658:	55                   	push   %rbp
  805659:	48 89 e5             	mov    %rsp,%rbp
  80565c:	48 83 ec 40          	sub    $0x40,%rsp
  805660:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805664:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805668:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80566c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805670:	48 89 c7             	mov    %rax,%rdi
  805673:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  80567a:	00 00 00 
  80567d:	ff d0                	callq  *%rax
  80567f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805683:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805687:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80568b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805692:	00 
  805693:	e9 92 00 00 00       	jmpq   80572a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  805698:	eb 41                	jmp    8056db <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80569a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80569f:	74 09                	je     8056aa <devpipe_read+0x52>
				return i;
  8056a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056a5:	e9 92 00 00 00       	jmpq   80573c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8056aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8056ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056b2:	48 89 d6             	mov    %rdx,%rsi
  8056b5:	48 89 c7             	mov    %rax,%rdi
  8056b8:	48 b8 21 55 80 00 00 	movabs $0x805521,%rax
  8056bf:	00 00 00 
  8056c2:	ff d0                	callq  *%rax
  8056c4:	85 c0                	test   %eax,%eax
  8056c6:	74 07                	je     8056cf <devpipe_read+0x77>
				return 0;
  8056c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8056cd:	eb 6d                	jmp    80573c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8056cf:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8056d6:	00 00 00 
  8056d9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8056db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056df:	8b 10                	mov    (%rax),%edx
  8056e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056e5:	8b 40 04             	mov    0x4(%rax),%eax
  8056e8:	39 c2                	cmp    %eax,%edx
  8056ea:	74 ae                	je     80569a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8056ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8056f4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8056f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056fc:	8b 00                	mov    (%rax),%eax
  8056fe:	99                   	cltd   
  8056ff:	c1 ea 1b             	shr    $0x1b,%edx
  805702:	01 d0                	add    %edx,%eax
  805704:	83 e0 1f             	and    $0x1f,%eax
  805707:	29 d0                	sub    %edx,%eax
  805709:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80570d:	48 98                	cltq   
  80570f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  805714:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  805716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80571a:	8b 00                	mov    (%rax),%eax
  80571c:	8d 50 01             	lea    0x1(%rax),%edx
  80571f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805723:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805725:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80572a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80572e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805732:	0f 82 60 ff ff ff    	jb     805698 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  805738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80573c:	c9                   	leaveq 
  80573d:	c3                   	retq   

000000000080573e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80573e:	55                   	push   %rbp
  80573f:	48 89 e5             	mov    %rsp,%rbp
  805742:	48 83 ec 40          	sub    $0x40,%rsp
  805746:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80574a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80574e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  805752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805756:	48 89 c7             	mov    %rax,%rdi
  805759:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  805760:	00 00 00 
  805763:	ff d0                	callq  *%rax
  805765:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  805769:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80576d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  805771:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805778:	00 
  805779:	e9 8e 00 00 00       	jmpq   80580c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80577e:	eb 31                	jmp    8057b1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  805780:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805788:	48 89 d6             	mov    %rdx,%rsi
  80578b:	48 89 c7             	mov    %rax,%rdi
  80578e:	48 b8 21 55 80 00 00 	movabs $0x805521,%rax
  805795:	00 00 00 
  805798:	ff d0                	callq  *%rax
  80579a:	85 c0                	test   %eax,%eax
  80579c:	74 07                	je     8057a5 <devpipe_write+0x67>
				return 0;
  80579e:	b8 00 00 00 00       	mov    $0x0,%eax
  8057a3:	eb 79                	jmp    80581e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8057a5:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8057ac:	00 00 00 
  8057af:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8057b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057b5:	8b 40 04             	mov    0x4(%rax),%eax
  8057b8:	48 63 d0             	movslq %eax,%rdx
  8057bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057bf:	8b 00                	mov    (%rax),%eax
  8057c1:	48 98                	cltq   
  8057c3:	48 83 c0 20          	add    $0x20,%rax
  8057c7:	48 39 c2             	cmp    %rax,%rdx
  8057ca:	73 b4                	jae    805780 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8057cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057d0:	8b 40 04             	mov    0x4(%rax),%eax
  8057d3:	99                   	cltd   
  8057d4:	c1 ea 1b             	shr    $0x1b,%edx
  8057d7:	01 d0                	add    %edx,%eax
  8057d9:	83 e0 1f             	and    $0x1f,%eax
  8057dc:	29 d0                	sub    %edx,%eax
  8057de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8057e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8057e6:	48 01 ca             	add    %rcx,%rdx
  8057e9:	0f b6 0a             	movzbl (%rdx),%ecx
  8057ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057f0:	48 98                	cltq   
  8057f2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8057f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057fa:	8b 40 04             	mov    0x4(%rax),%eax
  8057fd:	8d 50 01             	lea    0x1(%rax),%edx
  805800:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805804:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805807:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80580c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805810:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805814:	0f 82 64 ff ff ff    	jb     80577e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80581a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80581e:	c9                   	leaveq 
  80581f:	c3                   	retq   

0000000000805820 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805820:	55                   	push   %rbp
  805821:	48 89 e5             	mov    %rsp,%rbp
  805824:	48 83 ec 20          	sub    $0x20,%rsp
  805828:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80582c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805834:	48 89 c7             	mov    %rax,%rdi
  805837:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  80583e:	00 00 00 
  805841:	ff d0                	callq  *%rax
  805843:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  805847:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80584b:	48 be 00 66 80 00 00 	movabs $0x806600,%rsi
  805852:	00 00 00 
  805855:	48 89 c7             	mov    %rax,%rdi
  805858:	48 b8 37 23 80 00 00 	movabs $0x802337,%rax
  80585f:	00 00 00 
  805862:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  805864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805868:	8b 50 04             	mov    0x4(%rax),%edx
  80586b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80586f:	8b 00                	mov    (%rax),%eax
  805871:	29 c2                	sub    %eax,%edx
  805873:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805877:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80587d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805881:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805888:	00 00 00 
	stat->st_dev = &devpipe;
  80588b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80588f:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  805896:	00 00 00 
  805899:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8058a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8058a5:	c9                   	leaveq 
  8058a6:	c3                   	retq   

00000000008058a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8058a7:	55                   	push   %rbp
  8058a8:	48 89 e5             	mov    %rsp,%rbp
  8058ab:	48 83 ec 10          	sub    $0x10,%rsp
  8058af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8058b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058b7:	48 89 c6             	mov    %rax,%rsi
  8058ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8058bf:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8058c6:	00 00 00 
  8058c9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8058cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058cf:	48 89 c7             	mov    %rax,%rdi
  8058d2:	48 b8 de 36 80 00 00 	movabs $0x8036de,%rax
  8058d9:	00 00 00 
  8058dc:	ff d0                	callq  *%rax
  8058de:	48 89 c6             	mov    %rax,%rsi
  8058e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8058e6:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8058ed:	00 00 00 
  8058f0:	ff d0                	callq  *%rax
}
  8058f2:	c9                   	leaveq 
  8058f3:	c3                   	retq   

00000000008058f4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8058f4:	55                   	push   %rbp
  8058f5:	48 89 e5             	mov    %rsp,%rbp
  8058f8:	48 83 ec 20          	sub    $0x20,%rsp
  8058fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8058ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805903:	75 35                	jne    80593a <wait+0x46>
  805905:	48 b9 07 66 80 00 00 	movabs $0x806607,%rcx
  80590c:	00 00 00 
  80590f:	48 ba 12 66 80 00 00 	movabs $0x806612,%rdx
  805916:	00 00 00 
  805919:	be 09 00 00 00       	mov    $0x9,%esi
  80591e:	48 bf 27 66 80 00 00 	movabs $0x806627,%rdi
  805925:	00 00 00 
  805928:	b8 00 00 00 00       	mov    $0x0,%eax
  80592d:	49 b8 fc 11 80 00 00 	movabs $0x8011fc,%r8
  805934:	00 00 00 
  805937:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80593a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80593d:	25 ff 03 00 00       	and    $0x3ff,%eax
  805942:	48 63 d0             	movslq %eax,%rdx
  805945:	48 89 d0             	mov    %rdx,%rax
  805948:	48 c1 e0 03          	shl    $0x3,%rax
  80594c:	48 01 d0             	add    %rdx,%rax
  80594f:	48 c1 e0 05          	shl    $0x5,%rax
  805953:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80595a:	00 00 00 
  80595d:	48 01 d0             	add    %rdx,%rax
  805960:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805964:	eb 0c                	jmp    805972 <wait+0x7e>
		sys_yield();
  805966:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  80596d:	00 00 00 
  805970:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805976:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80597c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80597f:	75 0e                	jne    80598f <wait+0x9b>
  805981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805985:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80598b:	85 c0                	test   %eax,%eax
  80598d:	75 d7                	jne    805966 <wait+0x72>
		sys_yield();
}
  80598f:	c9                   	leaveq 
  805990:	c3                   	retq   

0000000000805991 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805991:	55                   	push   %rbp
  805992:	48 89 e5             	mov    %rsp,%rbp
  805995:	48 83 ec 10          	sub    $0x10,%rsp
  805999:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80599d:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  8059a4:	00 00 00 
  8059a7:	48 8b 00             	mov    (%rax),%rax
  8059aa:	48 85 c0             	test   %rax,%rax
  8059ad:	75 3a                	jne    8059e9 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  8059af:	ba 07 00 00 00       	mov    $0x7,%edx
  8059b4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8059b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8059be:	48 b8 66 2c 80 00 00 	movabs $0x802c66,%rax
  8059c5:	00 00 00 
  8059c8:	ff d0                	callq  *%rax
  8059ca:	85 c0                	test   %eax,%eax
  8059cc:	75 1b                	jne    8059e9 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8059ce:	48 be fc 59 80 00 00 	movabs $0x8059fc,%rsi
  8059d5:	00 00 00 
  8059d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8059dd:	48 b8 f0 2d 80 00 00 	movabs $0x802df0,%rax
  8059e4:	00 00 00 
  8059e7:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8059e9:	48 b8 08 b0 80 00 00 	movabs $0x80b008,%rax
  8059f0:	00 00 00 
  8059f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8059f7:	48 89 10             	mov    %rdx,(%rax)
}
  8059fa:	c9                   	leaveq 
  8059fb:	c3                   	retq   

00000000008059fc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8059fc:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8059ff:	48 a1 08 b0 80 00 00 	movabs 0x80b008,%rax
  805a06:	00 00 00 
	call *%rax
  805a09:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  805a0b:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  805a0e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805a15:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  805a16:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  805a1d:	00 
	pushq %rbx		// push utf_rip into new stack
  805a1e:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  805a1f:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  805a26:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  805a29:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  805a2d:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  805a31:	4c 8b 3c 24          	mov    (%rsp),%r15
  805a35:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805a3a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805a3f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805a44:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805a49:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805a4e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805a53:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805a58:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805a5d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805a62:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805a67:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805a6c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805a71:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805a76:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805a7b:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  805a7f:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  805a83:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  805a84:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  805a85:	c3                   	retq   

0000000000805a86 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805a86:	55                   	push   %rbp
  805a87:	48 89 e5             	mov    %rsp,%rbp
  805a8a:	48 83 ec 30          	sub    $0x30,%rsp
  805a8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a96:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  805a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a9e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  805aa2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805aa7:	75 0e                	jne    805ab7 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  805aa9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  805ab0:	00 00 00 
  805ab3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  805ab7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805abb:	48 89 c7             	mov    %rax,%rdi
  805abe:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  805ac5:	00 00 00 
  805ac8:	ff d0                	callq  *%rax
  805aca:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805ad1:	79 27                	jns    805afa <ipc_recv+0x74>
		if (from_env_store != NULL)
  805ad3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805ad8:	74 0a                	je     805ae4 <ipc_recv+0x5e>
			*from_env_store = 0;
  805ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ade:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  805ae4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805ae9:	74 0a                	je     805af5 <ipc_recv+0x6f>
			*perm_store = 0;
  805aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805aef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  805af5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805af8:	eb 53                	jmp    805b4d <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  805afa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805aff:	74 19                	je     805b1a <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  805b01:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805b08:	00 00 00 
  805b0b:	48 8b 00             	mov    (%rax),%rax
  805b0e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b18:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  805b1a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805b1f:	74 19                	je     805b3a <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  805b21:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805b28:	00 00 00 
  805b2b:	48 8b 00             	mov    (%rax),%rax
  805b2e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805b34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805b38:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  805b3a:	48 b8 48 94 80 00 00 	movabs $0x809448,%rax
  805b41:	00 00 00 
  805b44:	48 8b 00             	mov    (%rax),%rax
  805b47:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  805b4d:	c9                   	leaveq 
  805b4e:	c3                   	retq   

0000000000805b4f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805b4f:	55                   	push   %rbp
  805b50:	48 89 e5             	mov    %rsp,%rbp
  805b53:	48 83 ec 30          	sub    $0x30,%rsp
  805b57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805b5a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805b5d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805b61:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  805b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b68:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  805b6c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  805b71:	75 10                	jne    805b83 <ipc_send+0x34>
		page = (void *)KERNBASE;
  805b73:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  805b7a:	00 00 00 
  805b7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  805b81:	eb 0e                	jmp    805b91 <ipc_send+0x42>
  805b83:	eb 0c                	jmp    805b91 <ipc_send+0x42>
		sys_yield();
  805b85:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  805b8c:	00 00 00 
  805b8f:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  805b91:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805b94:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805b97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805b9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805b9e:	89 c7                	mov    %eax,%edi
  805ba0:	48 b8 3a 2e 80 00 00 	movabs $0x802e3a,%rax
  805ba7:	00 00 00 
  805baa:	ff d0                	callq  *%rax
  805bac:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805baf:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  805bb3:	74 d0                	je     805b85 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  805bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805bb9:	74 2a                	je     805be5 <ipc_send+0x96>
		panic("error on ipc send procedure");
  805bbb:	48 ba 32 66 80 00 00 	movabs $0x806632,%rdx
  805bc2:	00 00 00 
  805bc5:	be 49 00 00 00       	mov    $0x49,%esi
  805bca:	48 bf 4e 66 80 00 00 	movabs $0x80664e,%rdi
  805bd1:	00 00 00 
  805bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  805bd9:	48 b9 fc 11 80 00 00 	movabs $0x8011fc,%rcx
  805be0:	00 00 00 
  805be3:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  805be5:	c9                   	leaveq 
  805be6:	c3                   	retq   

0000000000805be7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805be7:	55                   	push   %rbp
  805be8:	48 89 e5             	mov    %rsp,%rbp
  805beb:	48 83 ec 14          	sub    $0x14,%rsp
  805bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  805bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805bf9:	eb 5e                	jmp    805c59 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  805bfb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805c02:	00 00 00 
  805c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c08:	48 63 d0             	movslq %eax,%rdx
  805c0b:	48 89 d0             	mov    %rdx,%rax
  805c0e:	48 c1 e0 03          	shl    $0x3,%rax
  805c12:	48 01 d0             	add    %rdx,%rax
  805c15:	48 c1 e0 05          	shl    $0x5,%rax
  805c19:	48 01 c8             	add    %rcx,%rax
  805c1c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805c22:	8b 00                	mov    (%rax),%eax
  805c24:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805c27:	75 2c                	jne    805c55 <ipc_find_env+0x6e>
			return envs[i].env_id;
  805c29:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805c30:	00 00 00 
  805c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c36:	48 63 d0             	movslq %eax,%rdx
  805c39:	48 89 d0             	mov    %rdx,%rax
  805c3c:	48 c1 e0 03          	shl    $0x3,%rax
  805c40:	48 01 d0             	add    %rdx,%rax
  805c43:	48 c1 e0 05          	shl    $0x5,%rax
  805c47:	48 01 c8             	add    %rcx,%rax
  805c4a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805c50:	8b 40 08             	mov    0x8(%rax),%eax
  805c53:	eb 12                	jmp    805c67 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  805c55:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805c59:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805c60:	7e 99                	jle    805bfb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  805c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c67:	c9                   	leaveq 
  805c68:	c3                   	retq   

0000000000805c69 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805c69:	55                   	push   %rbp
  805c6a:	48 89 e5             	mov    %rsp,%rbp
  805c6d:	48 83 ec 18          	sub    $0x18,%rsp
  805c71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805c75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c79:	48 c1 e8 15          	shr    $0x15,%rax
  805c7d:	48 89 c2             	mov    %rax,%rdx
  805c80:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805c87:	01 00 00 
  805c8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805c8e:	83 e0 01             	and    $0x1,%eax
  805c91:	48 85 c0             	test   %rax,%rax
  805c94:	75 07                	jne    805c9d <pageref+0x34>
		return 0;
  805c96:	b8 00 00 00 00       	mov    $0x0,%eax
  805c9b:	eb 53                	jmp    805cf0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ca1:	48 c1 e8 0c          	shr    $0xc,%rax
  805ca5:	48 89 c2             	mov    %rax,%rdx
  805ca8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805caf:	01 00 00 
  805cb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805cb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cbe:	83 e0 01             	and    $0x1,%eax
  805cc1:	48 85 c0             	test   %rax,%rax
  805cc4:	75 07                	jne    805ccd <pageref+0x64>
		return 0;
  805cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  805ccb:	eb 23                	jmp    805cf0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cd1:	48 c1 e8 0c          	shr    $0xc,%rax
  805cd5:	48 89 c2             	mov    %rax,%rdx
  805cd8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805cdf:	00 00 00 
  805ce2:	48 c1 e2 04          	shl    $0x4,%rdx
  805ce6:	48 01 d0             	add    %rdx,%rax
  805ce9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805ced:	0f b7 c0             	movzwl %ax,%eax
}
  805cf0:	c9                   	leaveq 
  805cf1:	c3                   	retq   
