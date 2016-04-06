
obj/user/faultregs.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 09 00 00       	callq  800a36 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be e0 3f 80 00 00 	movabs $0x803fe0,%rsi
  80007b:	00 00 00 
  80007e:	48 bf e1 3f 80 00 00 	movabs $0x803fe1,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be f1 3f 80 00 00 	movabs $0x803ff1,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be 13 40 80 00 00 	movabs $0x804013,%rsi
  800147:	00 00 00 
  80014a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be 17 40 80 00 00 	movabs $0x804017,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be 1b 40 80 00 00 	movabs $0x80401b,%rsi
  800267:	00 00 00 
  80026a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be 1f 40 80 00 00 	movabs $0x80401f,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be 23 40 80 00 00 	movabs $0x804023,%rsi
  800387:	00 00 00 
  80038a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be 27 40 80 00 00 	movabs $0x804027,%rsi
  800417:	00 00 00 
  80041a:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be 2b 40 80 00 00 	movabs $0x80402b,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be 2f 40 80 00 00 	movabs $0x80402f,%rsi
  80053d:	00 00 00 
  800540:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be 36 40 80 00 00 	movabs $0x804036,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf f5 3f 80 00 00 	movabs $0x803ff5,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf 05 40 80 00 00 	movabs $0x804005,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf 09 40 80 00 00 	movabs $0x804009,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK

	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf 3a 40 80 00 00 	movabs $0x80403a,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006b9:	74 43                	je     8006fe <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	49 89 d0             	mov    %rdx,%r8
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  8006da:	00 00 00 
  8006dd:	be 5e 00 00 00       	mov    $0x5e,%esi
  8006e2:	48 bf 99 40 80 00 00 	movabs $0x804099,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 e9 0a 80 00 00 	movabs $0x800ae9,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800705:	00 00 00 
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  80071f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800723:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800727:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072b:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  80072f:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800733:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800737:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073b:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  80073f:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800743:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800747:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074b:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  80074f:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800753:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800757:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075b:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  80075f:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800763:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800767:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076b:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  80076f:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800773:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800777:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077b:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800782:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800791:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 aa 40 80 00 00 	movabs $0x8040aa,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 b8 40 80 00 00 	movabs $0x8040b8,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be bf 40 80 00 00 	movabs $0x8040bf,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba c6 40 80 00 00 	movabs $0x8040c6,%rdx
  80084d:	00 00 00 
  800850:	be 69 00 00 00       	mov    $0x69,%esi
  800855:	48 bf 99 40 80 00 00 	movabs $0x804099,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 e9 0a 80 00 00 	movabs $0x800ae9,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <umain>:

void
umain(int argc, char **argv)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 10          	sub    $0x10,%rsp
  80087b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800882:	48 bf a0 06 80 00 00 	movabs $0x8006a0,%rdi
  800889:	00 00 00 
  80088c:	48 b8 66 26 80 00 00 	movabs $0x802666,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  8008a9:	00 00 00 
  8008ac:	50                   	push   %rax
  8008ad:	52                   	push   %rdx
  8008ae:	50                   	push   %rax
  8008af:	9c                   	pushfq 
  8008b0:	58                   	pop    %rax
  8008b1:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b7:	50                   	push   %rax
  8008b8:	9d                   	popfq  
  8008b9:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008be:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c5:	48 8d 04 25 11 09 80 	lea    0x800911,%rax
  8008cc:	00 
  8008cd:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d1:	58                   	pop    %rax
  8008d2:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d6:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008da:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008de:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e2:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e6:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ea:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008ee:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f2:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f6:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fa:	49 89 57 58          	mov    %rdx,0x58(%r15)
  8008fe:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800902:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800906:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800911:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800918:	2a 00 00 00 
  80091c:	4c 8b 3c 24          	mov    (%rsp),%r15
  800920:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800924:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800928:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092c:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800930:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800934:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800938:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093c:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800940:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800944:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800948:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094c:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800950:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800954:	49 89 47 70          	mov    %rax,0x70(%r15)
  800958:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  80095f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800964:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800968:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096c:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800970:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800974:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800978:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097c:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800980:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800984:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800988:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098c:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800990:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800994:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800998:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099c:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a3:	50                   	push   %rax
  8009a4:	9c                   	pushfq 
  8009a5:	58                   	pop    %rax
  8009a6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ab:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b2:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b3:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	83 f8 2a             	cmp    $0x2a,%eax
  8009bd:	74 1b                	je     8009da <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009bf:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 71 80 00 00 	movabs $0x807140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 ff 40 80 00 00 	movabs $0x8040ff,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 10 41 80 00 00 	movabs $0x804110,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  800a11:	00 00 00 
  800a14:	48 be bf 40 80 00 00 	movabs $0x8040bf,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800a25:	00 00 00 
  800a28:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
}
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 10          	sub    $0x10,%rsp
  800a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800a45:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	48 98                	cltq   
  800a53:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a58:	48 89 c2             	mov    %rax,%rdx
  800a5b:	48 89 d0             	mov    %rdx,%rax
  800a5e:	48 c1 e0 03          	shl    $0x3,%rax
  800a62:	48 01 d0             	add    %rdx,%rax
  800a65:	48 c1 e0 05          	shl    $0x5,%rax
  800a69:	48 89 c2             	mov    %rax,%rdx
  800a6c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a73:	00 00 00 
  800a76:	48 01 c2             	add    %rax,%rdx
  800a79:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  800a80:	00 00 00 
  800a83:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a8a:	7e 14                	jle    800aa0 <libmain+0x6a>
		binaryname = argv[0];
  800a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a90:	48 8b 10             	mov    (%rax),%rdx
  800a93:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a9a:	00 00 00 
  800a9d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800aa0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa7:	48 89 d6             	mov    %rdx,%rsi
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800ab3:	00 00 00 
  800ab6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ab8:	48 b8 c6 0a 80 00 00 	movabs $0x800ac6,%rax
  800abf:	00 00 00 
  800ac2:	ff d0                	callq  *%rax
}
  800ac4:	c9                   	leaveq 
  800ac5:	c3                   	retq   

0000000000800ac6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac6:	55                   	push   %rbp
  800ac7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800aca:	48 b8 9c 2a 80 00 00 	movabs $0x802a9c,%rax
  800ad1:	00 00 00 
  800ad4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ad6:	bf 00 00 00 00       	mov    $0x0,%edi
  800adb:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  800ae2:	00 00 00 
  800ae5:	ff d0                	callq  *%rax
}
  800ae7:	5d                   	pop    %rbp
  800ae8:	c3                   	retq   

0000000000800ae9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ae9:	55                   	push   %rbp
  800aea:	48 89 e5             	mov    %rsp,%rbp
  800aed:	53                   	push   %rbx
  800aee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800af5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800afc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b02:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b09:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b10:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b17:	84 c0                	test   %al,%al
  800b19:	74 23                	je     800b3e <_panic+0x55>
  800b1b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b22:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b26:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b2a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b2e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b32:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b36:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b3a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b3e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b45:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b4c:	00 00 00 
  800b4f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b56:	00 00 00 
  800b59:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b5d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b64:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b6b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b72:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800b79:	00 00 00 
  800b7c:	48 8b 18             	mov    (%rax),%rbx
  800b7f:	48 b8 7d 23 80 00 00 	movabs $0x80237d,%rax
  800b86:	00 00 00 
  800b89:	ff d0                	callq  *%rax
  800b8b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b91:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b98:	41 89 c8             	mov    %ecx,%r8d
  800b9b:	48 89 d1             	mov    %rdx,%rcx
  800b9e:	48 89 da             	mov    %rbx,%rdx
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	48 bf 20 41 80 00 00 	movabs $0x804120,%rdi
  800baa:	00 00 00 
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	49 b9 22 0d 80 00 00 	movabs $0x800d22,%r9
  800bb9:	00 00 00 
  800bbc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bbf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bc6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bcd:	48 89 d6             	mov    %rdx,%rsi
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
	cprintf("\n");
  800bdf:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  800be6:	00 00 00 
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	48 ba 22 0d 80 00 00 	movabs $0x800d22,%rdx
  800bf5:	00 00 00 
  800bf8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bfa:	cc                   	int3   
  800bfb:	eb fd                	jmp    800bfa <_panic+0x111>

0000000000800bfd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800bfd:	55                   	push   %rbp
  800bfe:	48 89 e5             	mov    %rsp,%rbp
  800c01:	48 83 ec 10          	sub    $0x10,%rsp
  800c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	8b 00                	mov    (%rax),%eax
  800c12:	8d 48 01             	lea    0x1(%rax),%ecx
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	89 0a                	mov    %ecx,(%rdx)
  800c1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c24:	48 98                	cltq   
  800c26:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2e:	8b 00                	mov    (%rax),%eax
  800c30:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c35:	75 2c                	jne    800c63 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3b:	8b 00                	mov    (%rax),%eax
  800c3d:	48 98                	cltq   
  800c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c43:	48 83 c2 08          	add    $0x8,%rdx
  800c47:	48 89 c6             	mov    %rax,%rsi
  800c4a:	48 89 d7             	mov    %rdx,%rdi
  800c4d:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  800c54:	00 00 00 
  800c57:	ff d0                	callq  *%rax
		b->idx = 0;
  800c59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800c63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c67:	8b 40 04             	mov    0x4(%rax),%eax
  800c6a:	8d 50 01             	lea    0x1(%rax),%edx
  800c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c71:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c74:	c9                   	leaveq 
  800c75:	c3                   	retq   

0000000000800c76 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800c76:	55                   	push   %rbp
  800c77:	48 89 e5             	mov    %rsp,%rbp
  800c7a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c81:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c88:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800c8f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c96:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c9d:	48 8b 0a             	mov    (%rdx),%rcx
  800ca0:	48 89 08             	mov    %rcx,(%rax)
  800ca3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800caf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800cb3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cba:	00 00 00 
	b.cnt = 0;
  800cbd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cc4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800cc7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cce:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cd5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cdc:	48 89 c6             	mov    %rax,%rsi
  800cdf:	48 bf fd 0b 80 00 00 	movabs $0x800bfd,%rdi
  800ce6:	00 00 00 
  800ce9:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800cf5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cfb:	48 98                	cltq   
  800cfd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d04:	48 83 c2 08          	add    $0x8,%rdx
  800d08:	48 89 c6             	mov    %rax,%rsi
  800d0b:	48 89 d7             	mov    %rdx,%rdi
  800d0e:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  800d15:	00 00 00 
  800d18:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800d1a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d20:	c9                   	leaveq 
  800d21:	c3                   	retq   

0000000000800d22 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d22:	55                   	push   %rbp
  800d23:	48 89 e5             	mov    %rsp,%rbp
  800d26:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d2d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d34:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d3b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d42:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d49:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d50:	84 c0                	test   %al,%al
  800d52:	74 20                	je     800d74 <cprintf+0x52>
  800d54:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d58:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d5c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d60:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d64:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d68:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d6c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d70:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d74:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800d7b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d82:	00 00 00 
  800d85:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d8c:	00 00 00 
  800d8f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d9a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800da1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800da8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800daf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db6:	48 8b 0a             	mov    (%rdx),%rcx
  800db9:	48 89 08             	mov    %rcx,(%rax)
  800dbc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800dcc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dd3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dda:	48 89 d6             	mov    %rdx,%rsi
  800ddd:	48 89 c7             	mov    %rax,%rdi
  800de0:	48 b8 76 0c 80 00 00 	movabs $0x800c76,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
  800dec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800df2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df8:	c9                   	leaveq 
  800df9:	c3                   	retq   

0000000000800dfa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dfa:	55                   	push   %rbp
  800dfb:	48 89 e5             	mov    %rsp,%rbp
  800dfe:	53                   	push   %rbx
  800dff:	48 83 ec 38          	sub    $0x38,%rsp
  800e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e0f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e12:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e16:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e1a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e1d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e21:	77 3b                	ja     800e5e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e23:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e26:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e2a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	48 f7 f3             	div    %rbx
  800e39:	48 89 c2             	mov    %rax,%rdx
  800e3c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e3f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e42:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	41 89 f9             	mov    %edi,%r9d
  800e4d:	48 89 c7             	mov    %rax,%rdi
  800e50:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  800e57:	00 00 00 
  800e5a:	ff d0                	callq  *%rax
  800e5c:	eb 1e                	jmp    800e7c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e5e:	eb 12                	jmp    800e72 <printnum+0x78>
			putch(padc, putdat);
  800e60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e64:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6b:	48 89 ce             	mov    %rcx,%rsi
  800e6e:	89 d7                	mov    %edx,%edi
  800e70:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e72:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e76:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e7a:	7f e4                	jg     800e60 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e7c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e83:	ba 00 00 00 00       	mov    $0x0,%edx
  800e88:	48 f7 f1             	div    %rcx
  800e8b:	48 89 d0             	mov    %rdx,%rax
  800e8e:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  800e95:	00 00 00 
  800e98:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e9c:	0f be d0             	movsbl %al,%edx
  800e9f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 89 ce             	mov    %rcx,%rsi
  800eaa:	89 d7                	mov    %edx,%edi
  800eac:	ff d0                	callq  *%rax
}
  800eae:	48 83 c4 38          	add    $0x38,%rsp
  800eb2:	5b                   	pop    %rbx
  800eb3:	5d                   	pop    %rbp
  800eb4:	c3                   	retq   

0000000000800eb5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800ec4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ec8:	7e 52                	jle    800f1c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	8b 00                	mov    (%rax),%eax
  800ed0:	83 f8 30             	cmp    $0x30,%eax
  800ed3:	73 24                	jae    800ef9 <getuint+0x44>
  800ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	8b 00                	mov    (%rax),%eax
  800ee3:	89 c0                	mov    %eax,%eax
  800ee5:	48 01 d0             	add    %rdx,%rax
  800ee8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eec:	8b 12                	mov    (%rdx),%edx
  800eee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ef1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef5:	89 0a                	mov    %ecx,(%rdx)
  800ef7:	eb 17                	jmp    800f10 <getuint+0x5b>
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f01:	48 89 d0             	mov    %rdx,%rax
  800f04:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f10:	48 8b 00             	mov    (%rax),%rax
  800f13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f17:	e9 a3 00 00 00       	jmpq   800fbf <getuint+0x10a>
	else if (lflag)
  800f1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f20:	74 4f                	je     800f71 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	8b 00                	mov    (%rax),%eax
  800f28:	83 f8 30             	cmp    $0x30,%eax
  800f2b:	73 24                	jae    800f51 <getuint+0x9c>
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	8b 00                	mov    (%rax),%eax
  800f3b:	89 c0                	mov    %eax,%eax
  800f3d:	48 01 d0             	add    %rdx,%rax
  800f40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f44:	8b 12                	mov    (%rdx),%edx
  800f46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4d:	89 0a                	mov    %ecx,(%rdx)
  800f4f:	eb 17                	jmp    800f68 <getuint+0xb3>
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f59:	48 89 d0             	mov    %rdx,%rax
  800f5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f68:	48 8b 00             	mov    (%rax),%rax
  800f6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f6f:	eb 4e                	jmp    800fbf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f75:	8b 00                	mov    (%rax),%eax
  800f77:	83 f8 30             	cmp    $0x30,%eax
  800f7a:	73 24                	jae    800fa0 <getuint+0xeb>
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f88:	8b 00                	mov    (%rax),%eax
  800f8a:	89 c0                	mov    %eax,%eax
  800f8c:	48 01 d0             	add    %rdx,%rax
  800f8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f93:	8b 12                	mov    (%rdx),%edx
  800f95:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9c:	89 0a                	mov    %ecx,(%rdx)
  800f9e:	eb 17                	jmp    800fb7 <getuint+0x102>
  800fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fa8:	48 89 d0             	mov    %rdx,%rax
  800fab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800faf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fb7:	8b 00                	mov    (%rax),%eax
  800fb9:	89 c0                	mov    %eax,%eax
  800fbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc3:	c9                   	leaveq 
  800fc4:	c3                   	retq   

0000000000800fc5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fc5:	55                   	push   %rbp
  800fc6:	48 89 e5             	mov    %rsp,%rbp
  800fc9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fd4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd8:	7e 52                	jle    80102c <getint+0x67>
		x=va_arg(*ap, long long);
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	8b 00                	mov    (%rax),%eax
  800fe0:	83 f8 30             	cmp    $0x30,%eax
  800fe3:	73 24                	jae    801009 <getint+0x44>
  800fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff1:	8b 00                	mov    (%rax),%eax
  800ff3:	89 c0                	mov    %eax,%eax
  800ff5:	48 01 d0             	add    %rdx,%rax
  800ff8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffc:	8b 12                	mov    (%rdx),%edx
  800ffe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801001:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801005:	89 0a                	mov    %ecx,(%rdx)
  801007:	eb 17                	jmp    801020 <getint+0x5b>
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801011:	48 89 d0             	mov    %rdx,%rax
  801014:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801018:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801020:	48 8b 00             	mov    (%rax),%rax
  801023:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801027:	e9 a3 00 00 00       	jmpq   8010cf <getint+0x10a>
	else if (lflag)
  80102c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801030:	74 4f                	je     801081 <getint+0xbc>
		x=va_arg(*ap, long);
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	8b 00                	mov    (%rax),%eax
  801038:	83 f8 30             	cmp    $0x30,%eax
  80103b:	73 24                	jae    801061 <getint+0x9c>
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	8b 00                	mov    (%rax),%eax
  80104b:	89 c0                	mov    %eax,%eax
  80104d:	48 01 d0             	add    %rdx,%rax
  801050:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801054:	8b 12                	mov    (%rdx),%edx
  801056:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801059:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105d:	89 0a                	mov    %ecx,(%rdx)
  80105f:	eb 17                	jmp    801078 <getint+0xb3>
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801069:	48 89 d0             	mov    %rdx,%rax
  80106c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801074:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801078:	48 8b 00             	mov    (%rax),%rax
  80107b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80107f:	eb 4e                	jmp    8010cf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	8b 00                	mov    (%rax),%eax
  801087:	83 f8 30             	cmp    $0x30,%eax
  80108a:	73 24                	jae    8010b0 <getint+0xeb>
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801098:	8b 00                	mov    (%rax),%eax
  80109a:	89 c0                	mov    %eax,%eax
  80109c:	48 01 d0             	add    %rdx,%rax
  80109f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a3:	8b 12                	mov    (%rdx),%edx
  8010a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ac:	89 0a                	mov    %ecx,(%rdx)
  8010ae:	eb 17                	jmp    8010c7 <getint+0x102>
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010b8:	48 89 d0             	mov    %rdx,%rax
  8010bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010c7:	8b 00                	mov    (%rax),%eax
  8010c9:	48 98                	cltq   
  8010cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d3:	c9                   	leaveq 
  8010d4:	c3                   	retq   

00000000008010d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	41 54                	push   %r12
  8010db:	53                   	push   %rbx
  8010dc:	48 83 ec 60          	sub    $0x60,%rsp
  8010e0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010e4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010e8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010ec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010f4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010f8:	48 8b 0a             	mov    (%rdx),%rcx
  8010fb:	48 89 08             	mov    %rcx,(%rax)
  8010fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801102:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801106:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80110a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80110e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801112:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801116:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  801120:	eb 29                	jmp    80114b <vprintfmt+0x76>
			if (ch == '\0')
  801122:	85 db                	test   %ebx,%ebx
  801124:	0f 84 ad 06 00 00    	je     8017d7 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80112a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80112e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801132:	48 89 d6             	mov    %rdx,%rsi
  801135:	89 df                	mov    %ebx,%edi
  801137:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  801139:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80113d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801141:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801145:	0f b6 00             	movzbl (%rax),%eax
  801148:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80114b:	83 fb 25             	cmp    $0x25,%ebx
  80114e:	74 05                	je     801155 <vprintfmt+0x80>
  801150:	83 fb 1b             	cmp    $0x1b,%ebx
  801153:	75 cd                	jne    801122 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  801155:	83 fb 1b             	cmp    $0x1b,%ebx
  801158:	0f 85 ae 01 00 00    	jne    80130c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80115e:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  801165:	00 00 00 
  801168:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80116e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801172:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801176:	48 89 d6             	mov    %rdx,%rsi
  801179:	89 df                	mov    %ebx,%edi
  80117b:	ff d0                	callq  *%rax
			putch('[', putdat);
  80117d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801181:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801185:	48 89 d6             	mov    %rdx,%rsi
  801188:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80118d:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80118f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  801195:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80119a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8011a4:	eb 32                	jmp    8011d8 <vprintfmt+0x103>
					putch(ch, putdat);
  8011a6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011ae:	48 89 d6             	mov    %rdx,%rsi
  8011b1:	89 df                	mov    %ebx,%edi
  8011b3:	ff d0                	callq  *%rax
					esc_color *= 10;
  8011b5:	44 89 e0             	mov    %r12d,%eax
  8011b8:	c1 e0 02             	shl    $0x2,%eax
  8011bb:	44 01 e0             	add    %r12d,%eax
  8011be:	01 c0                	add    %eax,%eax
  8011c0:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8011c3:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8011c6:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8011c9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8011ce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011d2:	0f b6 00             	movzbl (%rax),%eax
  8011d5:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8011d8:	83 fb 3b             	cmp    $0x3b,%ebx
  8011db:	74 05                	je     8011e2 <vprintfmt+0x10d>
  8011dd:	83 fb 6d             	cmp    $0x6d,%ebx
  8011e0:	75 c4                	jne    8011a6 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8011e2:	45 85 e4             	test   %r12d,%r12d
  8011e5:	75 15                	jne    8011fc <vprintfmt+0x127>
					color_flag = 0x07;
  8011e7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8011ee:	00 00 00 
  8011f1:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8011f7:	e9 dc 00 00 00       	jmpq   8012d8 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8011fc:	41 83 fc 1d          	cmp    $0x1d,%r12d
  801200:	7e 69                	jle    80126b <vprintfmt+0x196>
  801202:	41 83 fc 25          	cmp    $0x25,%r12d
  801206:	7f 63                	jg     80126b <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  801208:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80120f:	00 00 00 
  801212:	8b 00                	mov    (%rax),%eax
  801214:	25 f8 00 00 00       	and    $0xf8,%eax
  801219:	89 c2                	mov    %eax,%edx
  80121b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801222:	00 00 00 
  801225:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  801227:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80122b:	44 89 e0             	mov    %r12d,%eax
  80122e:	83 e0 04             	and    $0x4,%eax
  801231:	c1 f8 02             	sar    $0x2,%eax
  801234:	89 c2                	mov    %eax,%edx
  801236:	44 89 e0             	mov    %r12d,%eax
  801239:	83 e0 02             	and    $0x2,%eax
  80123c:	09 c2                	or     %eax,%edx
  80123e:	44 89 e0             	mov    %r12d,%eax
  801241:	83 e0 01             	and    $0x1,%eax
  801244:	c1 e0 02             	shl    $0x2,%eax
  801247:	09 c2                	or     %eax,%edx
  801249:	41 89 d4             	mov    %edx,%r12d
  80124c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801253:	00 00 00 
  801256:	8b 00                	mov    (%rax),%eax
  801258:	44 89 e2             	mov    %r12d,%edx
  80125b:	09 c2                	or     %eax,%edx
  80125d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801264:	00 00 00 
  801267:	89 10                	mov    %edx,(%rax)
  801269:	eb 6d                	jmp    8012d8 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80126b:	41 83 fc 27          	cmp    $0x27,%r12d
  80126f:	7e 67                	jle    8012d8 <vprintfmt+0x203>
  801271:	41 83 fc 2f          	cmp    $0x2f,%r12d
  801275:	7f 61                	jg     8012d8 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  801277:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80127e:	00 00 00 
  801281:	8b 00                	mov    (%rax),%eax
  801283:	25 8f 00 00 00       	and    $0x8f,%eax
  801288:	89 c2                	mov    %eax,%edx
  80128a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801291:	00 00 00 
  801294:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  801296:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80129a:	44 89 e0             	mov    %r12d,%eax
  80129d:	83 e0 04             	and    $0x4,%eax
  8012a0:	c1 f8 02             	sar    $0x2,%eax
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	44 89 e0             	mov    %r12d,%eax
  8012a8:	83 e0 02             	and    $0x2,%eax
  8012ab:	09 c2                	or     %eax,%edx
  8012ad:	44 89 e0             	mov    %r12d,%eax
  8012b0:	83 e0 01             	and    $0x1,%eax
  8012b3:	c1 e0 06             	shl    $0x6,%eax
  8012b6:	09 c2                	or     %eax,%edx
  8012b8:	41 89 d4             	mov    %edx,%r12d
  8012bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8012c2:	00 00 00 
  8012c5:	8b 00                	mov    (%rax),%eax
  8012c7:	44 89 e2             	mov    %r12d,%edx
  8012ca:	09 c2                	or     %eax,%edx
  8012cc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8012d3:	00 00 00 
  8012d6:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8012d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012e0:	48 89 d6             	mov    %rdx,%rsi
  8012e3:	89 df                	mov    %ebx,%edi
  8012e5:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8012e7:	83 fb 6d             	cmp    $0x6d,%ebx
  8012ea:	75 1b                	jne    801307 <vprintfmt+0x232>
					fmt ++;
  8012ec:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8012f1:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8012f2:	48 b8 d0 71 80 00 00 	movabs $0x8071d0,%rax
  8012f9:	00 00 00 
  8012fc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  801302:	e9 cb 04 00 00       	jmpq   8017d2 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  801307:	e9 83 fe ff ff       	jmpq   80118f <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80130c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801310:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801317:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80131e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801325:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80132c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801330:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801334:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801338:	0f b6 00             	movzbl (%rax),%eax
  80133b:	0f b6 d8             	movzbl %al,%ebx
  80133e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801341:	83 f8 55             	cmp    $0x55,%eax
  801344:	0f 87 5a 04 00 00    	ja     8017a4 <vprintfmt+0x6cf>
  80134a:	89 c0                	mov    %eax,%eax
  80134c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801353:	00 
  801354:	48 b8 50 43 80 00 00 	movabs $0x804350,%rax
  80135b:	00 00 00 
  80135e:	48 01 d0             	add    %rdx,%rax
  801361:	48 8b 00             	mov    (%rax),%rax
  801364:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  801366:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80136a:	eb c0                	jmp    80132c <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80136c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801370:	eb ba                	jmp    80132c <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801372:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801379:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80137c:	89 d0                	mov    %edx,%eax
  80137e:	c1 e0 02             	shl    $0x2,%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d8                	add    %ebx,%eax
  801387:	83 e8 30             	sub    $0x30,%eax
  80138a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80138d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801397:	83 fb 2f             	cmp    $0x2f,%ebx
  80139a:	7e 0c                	jle    8013a8 <vprintfmt+0x2d3>
  80139c:	83 fb 39             	cmp    $0x39,%ebx
  80139f:	7f 07                	jg     8013a8 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013a1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8013a6:	eb d1                	jmp    801379 <vprintfmt+0x2a4>
			goto process_precision;
  8013a8:	eb 58                	jmp    801402 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8013aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013ad:	83 f8 30             	cmp    $0x30,%eax
  8013b0:	73 17                	jae    8013c9 <vprintfmt+0x2f4>
  8013b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013b9:	89 c0                	mov    %eax,%eax
  8013bb:	48 01 d0             	add    %rdx,%rax
  8013be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013c1:	83 c2 08             	add    $0x8,%edx
  8013c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013c7:	eb 0f                	jmp    8013d8 <vprintfmt+0x303>
  8013c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013cd:	48 89 d0             	mov    %rdx,%rax
  8013d0:	48 83 c2 08          	add    $0x8,%rdx
  8013d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013d8:	8b 00                	mov    (%rax),%eax
  8013da:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8013dd:	eb 23                	jmp    801402 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8013df:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013e3:	79 0c                	jns    8013f1 <vprintfmt+0x31c>
				width = 0;
  8013e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8013ec:	e9 3b ff ff ff       	jmpq   80132c <vprintfmt+0x257>
  8013f1:	e9 36 ff ff ff       	jmpq   80132c <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8013f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8013fd:	e9 2a ff ff ff       	jmpq   80132c <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  801402:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801406:	79 12                	jns    80141a <vprintfmt+0x345>
				width = precision, precision = -1;
  801408:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80140b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80140e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801415:	e9 12 ff ff ff       	jmpq   80132c <vprintfmt+0x257>
  80141a:	e9 0d ff ff ff       	jmpq   80132c <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80141f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801423:	e9 04 ff ff ff       	jmpq   80132c <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801428:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142b:	83 f8 30             	cmp    $0x30,%eax
  80142e:	73 17                	jae    801447 <vprintfmt+0x372>
  801430:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801434:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801437:	89 c0                	mov    %eax,%eax
  801439:	48 01 d0             	add    %rdx,%rax
  80143c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80143f:	83 c2 08             	add    $0x8,%edx
  801442:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801445:	eb 0f                	jmp    801456 <vprintfmt+0x381>
  801447:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80144b:	48 89 d0             	mov    %rdx,%rax
  80144e:	48 83 c2 08          	add    $0x8,%rdx
  801452:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801456:	8b 10                	mov    (%rax),%edx
  801458:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80145c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801460:	48 89 ce             	mov    %rcx,%rsi
  801463:	89 d7                	mov    %edx,%edi
  801465:	ff d0                	callq  *%rax
			break;
  801467:	e9 66 03 00 00       	jmpq   8017d2 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80146c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80146f:	83 f8 30             	cmp    $0x30,%eax
  801472:	73 17                	jae    80148b <vprintfmt+0x3b6>
  801474:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801478:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80147b:	89 c0                	mov    %eax,%eax
  80147d:	48 01 d0             	add    %rdx,%rax
  801480:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801483:	83 c2 08             	add    $0x8,%edx
  801486:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801489:	eb 0f                	jmp    80149a <vprintfmt+0x3c5>
  80148b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80148f:	48 89 d0             	mov    %rdx,%rax
  801492:	48 83 c2 08          	add    $0x8,%rdx
  801496:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80149a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80149c:	85 db                	test   %ebx,%ebx
  80149e:	79 02                	jns    8014a2 <vprintfmt+0x3cd>
				err = -err;
  8014a0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8014a2:	83 fb 10             	cmp    $0x10,%ebx
  8014a5:	7f 16                	jg     8014bd <vprintfmt+0x3e8>
  8014a7:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  8014ae:	00 00 00 
  8014b1:	48 63 d3             	movslq %ebx,%rdx
  8014b4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8014b8:	4d 85 e4             	test   %r12,%r12
  8014bb:	75 2e                	jne    8014eb <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  8014bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014c5:	89 d9                	mov    %ebx,%ecx
  8014c7:	48 ba 39 43 80 00 00 	movabs $0x804339,%rdx
  8014ce:	00 00 00 
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	49 b8 e0 17 80 00 00 	movabs $0x8017e0,%r8
  8014e0:	00 00 00 
  8014e3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014e6:	e9 e7 02 00 00       	jmpq   8017d2 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014eb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8014ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014f3:	4c 89 e1             	mov    %r12,%rcx
  8014f6:	48 ba 42 43 80 00 00 	movabs $0x804342,%rdx
  8014fd:	00 00 00 
  801500:	48 89 c7             	mov    %rax,%rdi
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	49 b8 e0 17 80 00 00 	movabs $0x8017e0,%r8
  80150f:	00 00 00 
  801512:	41 ff d0             	callq  *%r8
			break;
  801515:	e9 b8 02 00 00       	jmpq   8017d2 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80151a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151d:	83 f8 30             	cmp    $0x30,%eax
  801520:	73 17                	jae    801539 <vprintfmt+0x464>
  801522:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801526:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801529:	89 c0                	mov    %eax,%eax
  80152b:	48 01 d0             	add    %rdx,%rax
  80152e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801531:	83 c2 08             	add    $0x8,%edx
  801534:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801537:	eb 0f                	jmp    801548 <vprintfmt+0x473>
  801539:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80153d:	48 89 d0             	mov    %rdx,%rax
  801540:	48 83 c2 08          	add    $0x8,%rdx
  801544:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801548:	4c 8b 20             	mov    (%rax),%r12
  80154b:	4d 85 e4             	test   %r12,%r12
  80154e:	75 0a                	jne    80155a <vprintfmt+0x485>
				p = "(null)";
  801550:	49 bc 45 43 80 00 00 	movabs $0x804345,%r12
  801557:	00 00 00 
			if (width > 0 && padc != '-')
  80155a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80155e:	7e 3f                	jle    80159f <vprintfmt+0x4ca>
  801560:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801564:	74 39                	je     80159f <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  801566:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801569:	48 98                	cltq   
  80156b:	48 89 c6             	mov    %rax,%rsi
  80156e:	4c 89 e7             	mov    %r12,%rdi
  801571:	48 b8 8c 1a 80 00 00 	movabs $0x801a8c,%rax
  801578:	00 00 00 
  80157b:	ff d0                	callq  *%rax
  80157d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801580:	eb 17                	jmp    801599 <vprintfmt+0x4c4>
					putch(padc, putdat);
  801582:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801586:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80158a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80158e:	48 89 ce             	mov    %rcx,%rsi
  801591:	89 d7                	mov    %edx,%edi
  801593:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801595:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801599:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80159d:	7f e3                	jg     801582 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80159f:	eb 37                	jmp    8015d8 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8015a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8015a5:	74 1e                	je     8015c5 <vprintfmt+0x4f0>
  8015a7:	83 fb 1f             	cmp    $0x1f,%ebx
  8015aa:	7e 05                	jle    8015b1 <vprintfmt+0x4dc>
  8015ac:	83 fb 7e             	cmp    $0x7e,%ebx
  8015af:	7e 14                	jle    8015c5 <vprintfmt+0x4f0>
					putch('?', putdat);
  8015b1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b9:	48 89 d6             	mov    %rdx,%rsi
  8015bc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8015c1:	ff d0                	callq  *%rax
  8015c3:	eb 0f                	jmp    8015d4 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  8015c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015cd:	48 89 d6             	mov    %rdx,%rsi
  8015d0:	89 df                	mov    %ebx,%edi
  8015d2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8015d8:	4c 89 e0             	mov    %r12,%rax
  8015db:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	0f be d8             	movsbl %al,%ebx
  8015e5:	85 db                	test   %ebx,%ebx
  8015e7:	74 10                	je     8015f9 <vprintfmt+0x524>
  8015e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015ed:	78 b2                	js     8015a1 <vprintfmt+0x4cc>
  8015ef:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8015f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015f7:	79 a8                	jns    8015a1 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8015f9:	eb 16                	jmp    801611 <vprintfmt+0x53c>
				putch(' ', putdat);
  8015fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801603:	48 89 d6             	mov    %rdx,%rsi
  801606:	bf 20 00 00 00       	mov    $0x20,%edi
  80160b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80160d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801611:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801615:	7f e4                	jg     8015fb <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  801617:	e9 b6 01 00 00       	jmpq   8017d2 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80161c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801620:	be 03 00 00 00       	mov    $0x3,%esi
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 b8 c5 0f 80 00 00 	movabs $0x800fc5,%rax
  80162f:	00 00 00 
  801632:	ff d0                	callq  *%rax
  801634:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163c:	48 85 c0             	test   %rax,%rax
  80163f:	79 1d                	jns    80165e <vprintfmt+0x589>
				putch('-', putdat);
  801641:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801645:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801649:	48 89 d6             	mov    %rdx,%rsi
  80164c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801651:	ff d0                	callq  *%rax
				num = -(long long) num;
  801653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801657:	48 f7 d8             	neg    %rax
  80165a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80165e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801665:	e9 fb 00 00 00       	jmpq   801765 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80166a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80166e:	be 03 00 00 00       	mov    $0x3,%esi
  801673:	48 89 c7             	mov    %rax,%rdi
  801676:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  80167d:	00 00 00 
  801680:	ff d0                	callq  *%rax
  801682:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801686:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80168d:	e9 d3 00 00 00       	jmpq   801765 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  801692:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801696:	be 03 00 00 00       	mov    $0x3,%esi
  80169b:	48 89 c7             	mov    %rax,%rdi
  80169e:	48 b8 c5 0f 80 00 00 	movabs $0x800fc5,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
  8016aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b2:	48 85 c0             	test   %rax,%rax
  8016b5:	79 1d                	jns    8016d4 <vprintfmt+0x5ff>
				putch('-', putdat);
  8016b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016bf:	48 89 d6             	mov    %rdx,%rsi
  8016c2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016c7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cd:	48 f7 d8             	neg    %rax
  8016d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8016d4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8016db:	e9 85 00 00 00       	jmpq   801765 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8016e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016e8:	48 89 d6             	mov    %rdx,%rsi
  8016eb:	bf 30 00 00 00       	mov    $0x30,%edi
  8016f0:	ff d0                	callq  *%rax
			putch('x', putdat);
  8016f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016fa:	48 89 d6             	mov    %rdx,%rsi
  8016fd:	bf 78 00 00 00       	mov    $0x78,%edi
  801702:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801704:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801707:	83 f8 30             	cmp    $0x30,%eax
  80170a:	73 17                	jae    801723 <vprintfmt+0x64e>
  80170c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801710:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801713:	89 c0                	mov    %eax,%eax
  801715:	48 01 d0             	add    %rdx,%rax
  801718:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80171b:	83 c2 08             	add    $0x8,%edx
  80171e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801721:	eb 0f                	jmp    801732 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801723:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801727:	48 89 d0             	mov    %rdx,%rax
  80172a:	48 83 c2 08          	add    $0x8,%rdx
  80172e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801732:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801735:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801739:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801740:	eb 23                	jmp    801765 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801742:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801746:	be 03 00 00 00       	mov    $0x3,%esi
  80174b:	48 89 c7             	mov    %rax,%rdi
  80174e:	48 b8 b5 0e 80 00 00 	movabs $0x800eb5,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
  80175a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80175e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801765:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80176a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80176d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801774:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801778:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80177c:	45 89 c1             	mov    %r8d,%r9d
  80177f:	41 89 f8             	mov    %edi,%r8d
  801782:	48 89 c7             	mov    %rax,%rdi
  801785:	48 b8 fa 0d 80 00 00 	movabs $0x800dfa,%rax
  80178c:	00 00 00 
  80178f:	ff d0                	callq  *%rax
			break;
  801791:	eb 3f                	jmp    8017d2 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801793:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801797:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80179b:	48 89 d6             	mov    %rdx,%rsi
  80179e:	89 df                	mov    %ebx,%edi
  8017a0:	ff d0                	callq  *%rax
			break;
  8017a2:	eb 2e                	jmp    8017d2 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ac:	48 89 d6             	mov    %rdx,%rsi
  8017af:	bf 25 00 00 00       	mov    $0x25,%edi
  8017b4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017b6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017bb:	eb 05                	jmp    8017c2 <vprintfmt+0x6ed>
  8017bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8017c2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8017c6:	48 83 e8 01          	sub    $0x1,%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 25                	cmp    $0x25,%al
  8017cf:	75 ec                	jne    8017bd <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8017d1:	90                   	nop
		}
	}
  8017d2:	e9 37 f9 ff ff       	jmpq   80110e <vprintfmt+0x39>
    va_end(aq);
}
  8017d7:	48 83 c4 60          	add    $0x60,%rsp
  8017db:	5b                   	pop    %rbx
  8017dc:	41 5c                	pop    %r12
  8017de:	5d                   	pop    %rbp
  8017df:	c3                   	retq   

00000000008017e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017e0:	55                   	push   %rbp
  8017e1:	48 89 e5             	mov    %rsp,%rbp
  8017e4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8017eb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8017f2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8017f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801800:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801807:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80180e:	84 c0                	test   %al,%al
  801810:	74 20                	je     801832 <printfmt+0x52>
  801812:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801816:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80181a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80181e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801822:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801826:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80182a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80182e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801832:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801839:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801840:	00 00 00 
  801843:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80184a:	00 00 00 
  80184d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801851:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801858:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80185f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801866:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80186d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801874:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80187b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801882:	48 89 c7             	mov    %rax,%rdi
  801885:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  80188c:	00 00 00 
  80188f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801891:	c9                   	leaveq 
  801892:	c3                   	retq   

0000000000801893 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801893:	55                   	push   %rbp
  801894:	48 89 e5             	mov    %rsp,%rbp
  801897:	48 83 ec 10          	sub    $0x10,%rsp
  80189b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80189e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a6:	8b 40 10             	mov    0x10(%rax),%eax
  8018a9:	8d 50 01             	lea    0x1(%rax),%edx
  8018ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8018b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b7:	48 8b 10             	mov    (%rax),%rdx
  8018ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018c2:	48 39 c2             	cmp    %rax,%rdx
  8018c5:	73 17                	jae    8018de <sprintputch+0x4b>
		*b->buf++ = ch;
  8018c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cb:	48 8b 00             	mov    (%rax),%rax
  8018ce:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8018d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d6:	48 89 0a             	mov    %rcx,(%rdx)
  8018d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8018dc:	88 10                	mov    %dl,(%rax)
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 50          	sub    $0x50,%rsp
  8018e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8018ec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8018ef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8018f3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8018f7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8018fb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8018ff:	48 8b 0a             	mov    (%rdx),%rcx
  801902:	48 89 08             	mov    %rcx,(%rax)
  801905:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801909:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80190d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801911:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801915:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801919:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80191d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801920:	48 98                	cltq   
  801922:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801926:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80192a:	48 01 d0             	add    %rdx,%rax
  80192d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801931:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801938:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80193d:	74 06                	je     801945 <vsnprintf+0x65>
  80193f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801943:	7f 07                	jg     80194c <vsnprintf+0x6c>
		return -E_INVAL;
  801945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194a:	eb 2f                	jmp    80197b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80194c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801950:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801954:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801958:	48 89 c6             	mov    %rax,%rsi
  80195b:	48 bf 93 18 80 00 00 	movabs $0x801893,%rdi
  801962:	00 00 00 
  801965:	48 b8 d5 10 80 00 00 	movabs $0x8010d5,%rax
  80196c:	00 00 00 
  80196f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801971:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801975:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801978:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801988:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80198f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801995:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80199c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019a3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019aa:	84 c0                	test   %al,%al
  8019ac:	74 20                	je     8019ce <snprintf+0x51>
  8019ae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8019b2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8019b6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8019ba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8019be:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8019c2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8019c6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8019ca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8019ce:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8019d5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8019dc:	00 00 00 
  8019df:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8019e6:	00 00 00 
  8019e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019ed:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8019f4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8019fb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a02:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a09:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a10:	48 8b 0a             	mov    (%rdx),%rcx
  801a13:	48 89 08             	mov    %rcx,(%rax)
  801a16:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a1a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a1e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a22:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a26:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a2d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a34:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a3a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a41:	48 89 c7             	mov    %rax,%rdi
  801a44:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  801a4b:	00 00 00 
  801a4e:	ff d0                	callq  *%rax
  801a50:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801a56:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801a5c:	c9                   	leaveq 
  801a5d:	c3                   	retq   

0000000000801a5e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801a5e:	55                   	push   %rbp
  801a5f:	48 89 e5             	mov    %rsp,%rbp
  801a62:	48 83 ec 18          	sub    $0x18,%rsp
  801a66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801a6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a71:	eb 09                	jmp    801a7c <strlen+0x1e>
		n++;
  801a73:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801a77:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a80:	0f b6 00             	movzbl (%rax),%eax
  801a83:	84 c0                	test   %al,%al
  801a85:	75 ec                	jne    801a73 <strlen+0x15>
		n++;
	return n;
  801a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801a8a:	c9                   	leaveq 
  801a8b:	c3                   	retq   

0000000000801a8c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801a8c:	55                   	push   %rbp
  801a8d:	48 89 e5             	mov    %rsp,%rbp
  801a90:	48 83 ec 20          	sub    $0x20,%rsp
  801a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aa3:	eb 0e                	jmp    801ab3 <strnlen+0x27>
		n++;
  801aa5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aa9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801aae:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801ab3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801ab8:	74 0b                	je     801ac5 <strnlen+0x39>
  801aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801abe:	0f b6 00             	movzbl (%rax),%eax
  801ac1:	84 c0                	test   %al,%al
  801ac3:	75 e0                	jne    801aa5 <strnlen+0x19>
		n++;
	return n;
  801ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ac8:	c9                   	leaveq 
  801ac9:	c3                   	retq   

0000000000801aca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801aca:	55                   	push   %rbp
  801acb:	48 89 e5             	mov    %rsp,%rbp
  801ace:	48 83 ec 20          	sub    $0x20,%rsp
  801ad2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ade:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801ae2:	90                   	nop
  801ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aeb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801aef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801af3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801af7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801afb:	0f b6 12             	movzbl (%rdx),%edx
  801afe:	88 10                	mov    %dl,(%rax)
  801b00:	0f b6 00             	movzbl (%rax),%eax
  801b03:	84 c0                	test   %al,%al
  801b05:	75 dc                	jne    801ae3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 20          	sub    $0x20,%rsp
  801b15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b21:	48 89 c7             	mov    %rax,%rdi
  801b24:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	callq  *%rax
  801b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b36:	48 63 d0             	movslq %eax,%rdx
  801b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b3d:	48 01 c2             	add    %rax,%rdx
  801b40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b44:	48 89 c6             	mov    %rax,%rsi
  801b47:	48 89 d7             	mov    %rdx,%rdi
  801b4a:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
	return dst;
  801b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b5a:	c9                   	leaveq 
  801b5b:	c3                   	retq   

0000000000801b5c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801b5c:	55                   	push   %rbp
  801b5d:	48 89 e5             	mov    %rsp,%rbp
  801b60:	48 83 ec 28          	sub    $0x28,%rsp
  801b64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b74:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801b78:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801b7f:	00 
  801b80:	eb 2a                	jmp    801bac <strncpy+0x50>
		*dst++ = *src;
  801b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b86:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b8a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b8e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b92:	0f b6 12             	movzbl (%rdx),%edx
  801b95:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b9b:	0f b6 00             	movzbl (%rax),%eax
  801b9e:	84 c0                	test   %al,%al
  801ba0:	74 05                	je     801ba7 <strncpy+0x4b>
			src++;
  801ba2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ba7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801bb4:	72 cc                	jb     801b82 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 28          	sub    $0x28,%rsp
  801bc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bcc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801bd8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bdd:	74 3d                	je     801c1c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801bdf:	eb 1d                	jmp    801bfe <strlcpy+0x42>
			*dst++ = *src++;
  801be1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801be9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801bf1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801bf5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801bf9:	0f b6 12             	movzbl (%rdx),%edx
  801bfc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801bfe:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c03:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c08:	74 0b                	je     801c15 <strlcpy+0x59>
  801c0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0e:	0f b6 00             	movzbl (%rax),%eax
  801c11:	84 c0                	test   %al,%al
  801c13:	75 cc                	jne    801be1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c19:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c24:	48 29 c2             	sub    %rax,%rdx
  801c27:	48 89 d0             	mov    %rdx,%rax
}
  801c2a:	c9                   	leaveq 
  801c2b:	c3                   	retq   

0000000000801c2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	48 83 ec 10          	sub    $0x10,%rsp
  801c34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c3c:	eb 0a                	jmp    801c48 <strcmp+0x1c>
		p++, q++;
  801c3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c43:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4c:	0f b6 00             	movzbl (%rax),%eax
  801c4f:	84 c0                	test   %al,%al
  801c51:	74 12                	je     801c65 <strcmp+0x39>
  801c53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c57:	0f b6 10             	movzbl (%rax),%edx
  801c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5e:	0f b6 00             	movzbl (%rax),%eax
  801c61:	38 c2                	cmp    %al,%dl
  801c63:	74 d9                	je     801c3e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c69:	0f b6 00             	movzbl (%rax),%eax
  801c6c:	0f b6 d0             	movzbl %al,%edx
  801c6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c73:	0f b6 00             	movzbl (%rax),%eax
  801c76:	0f b6 c0             	movzbl %al,%eax
  801c79:	29 c2                	sub    %eax,%edx
  801c7b:	89 d0                	mov    %edx,%eax
}
  801c7d:	c9                   	leaveq 
  801c7e:	c3                   	retq   

0000000000801c7f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	48 83 ec 18          	sub    $0x18,%rsp
  801c87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801c93:	eb 0f                	jmp    801ca4 <strncmp+0x25>
		n--, p++, q++;
  801c95:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801c9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c9f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ca4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ca9:	74 1d                	je     801cc8 <strncmp+0x49>
  801cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801caf:	0f b6 00             	movzbl (%rax),%eax
  801cb2:	84 c0                	test   %al,%al
  801cb4:	74 12                	je     801cc8 <strncmp+0x49>
  801cb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cba:	0f b6 10             	movzbl (%rax),%edx
  801cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc1:	0f b6 00             	movzbl (%rax),%eax
  801cc4:	38 c2                	cmp    %al,%dl
  801cc6:	74 cd                	je     801c95 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801cc8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ccd:	75 07                	jne    801cd6 <strncmp+0x57>
		return 0;
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	eb 18                	jmp    801cee <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cda:	0f b6 00             	movzbl (%rax),%eax
  801cdd:	0f b6 d0             	movzbl %al,%edx
  801ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce4:	0f b6 00             	movzbl (%rax),%eax
  801ce7:	0f b6 c0             	movzbl %al,%eax
  801cea:	29 c2                	sub    %eax,%edx
  801cec:	89 d0                	mov    %edx,%eax
}
  801cee:	c9                   	leaveq 
  801cef:	c3                   	retq   

0000000000801cf0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801cf0:	55                   	push   %rbp
  801cf1:	48 89 e5             	mov    %rsp,%rbp
  801cf4:	48 83 ec 0c          	sub    $0xc,%rsp
  801cf8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cfc:	89 f0                	mov    %esi,%eax
  801cfe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d01:	eb 17                	jmp    801d1a <strchr+0x2a>
		if (*s == c)
  801d03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d07:	0f b6 00             	movzbl (%rax),%eax
  801d0a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d0d:	75 06                	jne    801d15 <strchr+0x25>
			return (char *) s;
  801d0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d13:	eb 15                	jmp    801d2a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d15:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	84 c0                	test   %al,%al
  801d23:	75 de                	jne    801d03 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2a:	c9                   	leaveq 
  801d2b:	c3                   	retq   

0000000000801d2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d2c:	55                   	push   %rbp
  801d2d:	48 89 e5             	mov    %rsp,%rbp
  801d30:	48 83 ec 0c          	sub    $0xc,%rsp
  801d34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d38:	89 f0                	mov    %esi,%eax
  801d3a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d3d:	eb 13                	jmp    801d52 <strfind+0x26>
		if (*s == c)
  801d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d43:	0f b6 00             	movzbl (%rax),%eax
  801d46:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d49:	75 02                	jne    801d4d <strfind+0x21>
			break;
  801d4b:	eb 10                	jmp    801d5d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d4d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d56:	0f b6 00             	movzbl (%rax),%eax
  801d59:	84 c0                	test   %al,%al
  801d5b:	75 e2                	jne    801d3f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 18          	sub    $0x18,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801d72:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801d76:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d7b:	75 06                	jne    801d83 <memset+0x20>
		return v;
  801d7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d81:	eb 69                	jmp    801dec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d87:	83 e0 03             	and    $0x3,%eax
  801d8a:	48 85 c0             	test   %rax,%rax
  801d8d:	75 48                	jne    801dd7 <memset+0x74>
  801d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d93:	83 e0 03             	and    $0x3,%eax
  801d96:	48 85 c0             	test   %rax,%rax
  801d99:	75 3c                	jne    801dd7 <memset+0x74>
		c &= 0xFF;
  801d9b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801da2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801da5:	c1 e0 18             	shl    $0x18,%eax
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dad:	c1 e0 10             	shl    $0x10,%eax
  801db0:	09 c2                	or     %eax,%edx
  801db2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801db5:	c1 e0 08             	shl    $0x8,%eax
  801db8:	09 d0                	or     %edx,%eax
  801dba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc1:	48 c1 e8 02          	shr    $0x2,%rax
  801dc5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801dc8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dcf:	48 89 d7             	mov    %rdx,%rdi
  801dd2:	fc                   	cld    
  801dd3:	f3 ab                	rep stos %eax,%es:(%rdi)
  801dd5:	eb 11                	jmp    801de8 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801dd7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ddb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dde:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801de2:	48 89 d7             	mov    %rdx,%rdi
  801de5:	fc                   	cld    
  801de6:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801dec:	c9                   	leaveq 
  801ded:	c3                   	retq   

0000000000801dee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801dee:	55                   	push   %rbp
  801def:	48 89 e5             	mov    %rsp,%rbp
  801df2:	48 83 ec 28          	sub    $0x28,%rsp
  801df6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801dfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e16:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e1a:	0f 83 88 00 00 00    	jae    801ea8 <memmove+0xba>
  801e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e28:	48 01 d0             	add    %rdx,%rax
  801e2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e2f:	76 77                	jbe    801ea8 <memmove+0xba>
		s += n;
  801e31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e35:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e45:	83 e0 03             	and    $0x3,%eax
  801e48:	48 85 c0             	test   %rax,%rax
  801e4b:	75 3b                	jne    801e88 <memmove+0x9a>
  801e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e51:	83 e0 03             	and    $0x3,%eax
  801e54:	48 85 c0             	test   %rax,%rax
  801e57:	75 2f                	jne    801e88 <memmove+0x9a>
  801e59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5d:	83 e0 03             	and    $0x3,%eax
  801e60:	48 85 c0             	test   %rax,%rax
  801e63:	75 23                	jne    801e88 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e69:	48 83 e8 04          	sub    $0x4,%rax
  801e6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e71:	48 83 ea 04          	sub    $0x4,%rdx
  801e75:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e79:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801e7d:	48 89 c7             	mov    %rax,%rdi
  801e80:	48 89 d6             	mov    %rdx,%rsi
  801e83:	fd                   	std    
  801e84:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801e86:	eb 1d                	jmp    801ea5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9c:	48 89 d7             	mov    %rdx,%rdi
  801e9f:	48 89 c1             	mov    %rax,%rcx
  801ea2:	fd                   	std    
  801ea3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ea5:	fc                   	cld    
  801ea6:	eb 57                	jmp    801eff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eac:	83 e0 03             	and    $0x3,%eax
  801eaf:	48 85 c0             	test   %rax,%rax
  801eb2:	75 36                	jne    801eea <memmove+0xfc>
  801eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb8:	83 e0 03             	and    $0x3,%eax
  801ebb:	48 85 c0             	test   %rax,%rax
  801ebe:	75 2a                	jne    801eea <memmove+0xfc>
  801ec0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec4:	83 e0 03             	and    $0x3,%eax
  801ec7:	48 85 c0             	test   %rax,%rax
  801eca:	75 1e                	jne    801eea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed0:	48 c1 e8 02          	shr    $0x2,%rax
  801ed4:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801edf:	48 89 c7             	mov    %rax,%rdi
  801ee2:	48 89 d6             	mov    %rdx,%rsi
  801ee5:	fc                   	cld    
  801ee6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ee8:	eb 15                	jmp    801eff <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ef6:	48 89 c7             	mov    %rax,%rdi
  801ef9:	48 89 d6             	mov    %rdx,%rsi
  801efc:	fc                   	cld    
  801efd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f03:	c9                   	leaveq 
  801f04:	c3                   	retq   

0000000000801f05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f05:	55                   	push   %rbp
  801f06:	48 89 e5             	mov    %rsp,%rbp
  801f09:	48 83 ec 18          	sub    $0x18,%rsp
  801f0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f1d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f25:	48 89 ce             	mov    %rcx,%rsi
  801f28:	48 89 c7             	mov    %rax,%rdi
  801f2b:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
}
  801f37:	c9                   	leaveq 
  801f38:	c3                   	retq   

0000000000801f39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	48 83 ec 28          	sub    $0x28,%rsp
  801f41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801f55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801f5d:	eb 36                	jmp    801f95 <memcmp+0x5c>
		if (*s1 != *s2)
  801f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f63:	0f b6 10             	movzbl (%rax),%edx
  801f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f6a:	0f b6 00             	movzbl (%rax),%eax
  801f6d:	38 c2                	cmp    %al,%dl
  801f6f:	74 1a                	je     801f8b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f75:	0f b6 00             	movzbl (%rax),%eax
  801f78:	0f b6 d0             	movzbl %al,%edx
  801f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7f:	0f b6 00             	movzbl (%rax),%eax
  801f82:	0f b6 c0             	movzbl %al,%eax
  801f85:	29 c2                	sub    %eax,%edx
  801f87:	89 d0                	mov    %edx,%eax
  801f89:	eb 20                	jmp    801fab <memcmp+0x72>
		s1++, s2++;
  801f8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f90:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fa1:	48 85 c0             	test   %rax,%rax
  801fa4:	75 b9                	jne    801f5f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leaveq 
  801fac:	c3                   	retq   

0000000000801fad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fad:	55                   	push   %rbp
  801fae:	48 89 e5             	mov    %rsp,%rbp
  801fb1:	48 83 ec 28          	sub    $0x28,%rsp
  801fb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fb9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801fbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801fc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fc8:	48 01 d0             	add    %rdx,%rax
  801fcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801fcf:	eb 15                	jmp    801fe6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd5:	0f b6 10             	movzbl (%rax),%edx
  801fd8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fdb:	38 c2                	cmp    %al,%dl
  801fdd:	75 02                	jne    801fe1 <memfind+0x34>
			break;
  801fdf:	eb 0f                	jmp    801ff0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801fe1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fea:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801fee:	72 e1                	jb     801fd1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ff4:	c9                   	leaveq 
  801ff5:	c3                   	retq   

0000000000801ff6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ff6:	55                   	push   %rbp
  801ff7:	48 89 e5             	mov    %rsp,%rbp
  801ffa:	48 83 ec 34          	sub    $0x34,%rsp
  801ffe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802002:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802006:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802009:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802010:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802017:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802018:	eb 05                	jmp    80201f <strtol+0x29>
		s++;
  80201a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80201f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802023:	0f b6 00             	movzbl (%rax),%eax
  802026:	3c 20                	cmp    $0x20,%al
  802028:	74 f0                	je     80201a <strtol+0x24>
  80202a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202e:	0f b6 00             	movzbl (%rax),%eax
  802031:	3c 09                	cmp    $0x9,%al
  802033:	74 e5                	je     80201a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802035:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802039:	0f b6 00             	movzbl (%rax),%eax
  80203c:	3c 2b                	cmp    $0x2b,%al
  80203e:	75 07                	jne    802047 <strtol+0x51>
		s++;
  802040:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802045:	eb 17                	jmp    80205e <strtol+0x68>
	else if (*s == '-')
  802047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204b:	0f b6 00             	movzbl (%rax),%eax
  80204e:	3c 2d                	cmp    $0x2d,%al
  802050:	75 0c                	jne    80205e <strtol+0x68>
		s++, neg = 1;
  802052:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802057:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80205e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802062:	74 06                	je     80206a <strtol+0x74>
  802064:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802068:	75 28                	jne    802092 <strtol+0x9c>
  80206a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206e:	0f b6 00             	movzbl (%rax),%eax
  802071:	3c 30                	cmp    $0x30,%al
  802073:	75 1d                	jne    802092 <strtol+0x9c>
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	48 83 c0 01          	add    $0x1,%rax
  80207d:	0f b6 00             	movzbl (%rax),%eax
  802080:	3c 78                	cmp    $0x78,%al
  802082:	75 0e                	jne    802092 <strtol+0x9c>
		s += 2, base = 16;
  802084:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802089:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802090:	eb 2c                	jmp    8020be <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802092:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802096:	75 19                	jne    8020b1 <strtol+0xbb>
  802098:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209c:	0f b6 00             	movzbl (%rax),%eax
  80209f:	3c 30                	cmp    $0x30,%al
  8020a1:	75 0e                	jne    8020b1 <strtol+0xbb>
		s++, base = 8;
  8020a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020a8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8020af:	eb 0d                	jmp    8020be <strtol+0xc8>
	else if (base == 0)
  8020b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020b5:	75 07                	jne    8020be <strtol+0xc8>
		base = 10;
  8020b7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8020be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c2:	0f b6 00             	movzbl (%rax),%eax
  8020c5:	3c 2f                	cmp    $0x2f,%al
  8020c7:	7e 1d                	jle    8020e6 <strtol+0xf0>
  8020c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020cd:	0f b6 00             	movzbl (%rax),%eax
  8020d0:	3c 39                	cmp    $0x39,%al
  8020d2:	7f 12                	jg     8020e6 <strtol+0xf0>
			dig = *s - '0';
  8020d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d8:	0f b6 00             	movzbl (%rax),%eax
  8020db:	0f be c0             	movsbl %al,%eax
  8020de:	83 e8 30             	sub    $0x30,%eax
  8020e1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020e4:	eb 4e                	jmp    802134 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8020e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ea:	0f b6 00             	movzbl (%rax),%eax
  8020ed:	3c 60                	cmp    $0x60,%al
  8020ef:	7e 1d                	jle    80210e <strtol+0x118>
  8020f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f5:	0f b6 00             	movzbl (%rax),%eax
  8020f8:	3c 7a                	cmp    $0x7a,%al
  8020fa:	7f 12                	jg     80210e <strtol+0x118>
			dig = *s - 'a' + 10;
  8020fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802100:	0f b6 00             	movzbl (%rax),%eax
  802103:	0f be c0             	movsbl %al,%eax
  802106:	83 e8 57             	sub    $0x57,%eax
  802109:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80210c:	eb 26                	jmp    802134 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80210e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802112:	0f b6 00             	movzbl (%rax),%eax
  802115:	3c 40                	cmp    $0x40,%al
  802117:	7e 48                	jle    802161 <strtol+0x16b>
  802119:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211d:	0f b6 00             	movzbl (%rax),%eax
  802120:	3c 5a                	cmp    $0x5a,%al
  802122:	7f 3d                	jg     802161 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802124:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802128:	0f b6 00             	movzbl (%rax),%eax
  80212b:	0f be c0             	movsbl %al,%eax
  80212e:	83 e8 37             	sub    $0x37,%eax
  802131:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802134:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802137:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80213a:	7c 02                	jl     80213e <strtol+0x148>
			break;
  80213c:	eb 23                	jmp    802161 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80213e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802143:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802146:	48 98                	cltq   
  802148:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80214d:	48 89 c2             	mov    %rax,%rdx
  802150:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802153:	48 98                	cltq   
  802155:	48 01 d0             	add    %rdx,%rax
  802158:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80215c:	e9 5d ff ff ff       	jmpq   8020be <strtol+0xc8>

	if (endptr)
  802161:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802166:	74 0b                	je     802173 <strtol+0x17d>
		*endptr = (char *) s;
  802168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80216c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802170:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802173:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802177:	74 09                	je     802182 <strtol+0x18c>
  802179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217d:	48 f7 d8             	neg    %rax
  802180:	eb 04                	jmp    802186 <strtol+0x190>
  802182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <strstr>:

char * strstr(const char *in, const char *str)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
  80218c:	48 83 ec 30          	sub    $0x30,%rsp
  802190:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802194:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  802198:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80219c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021a0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8021a4:	0f b6 00             	movzbl (%rax),%eax
  8021a7:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8021aa:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021ae:	75 06                	jne    8021b6 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8021b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b4:	eb 6b                	jmp    802221 <strstr+0x99>

    len = strlen(str);
  8021b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ba:	48 89 c7             	mov    %rax,%rdi
  8021bd:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	48 98                	cltq   
  8021cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8021cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021db:	0f b6 00             	movzbl (%rax),%eax
  8021de:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8021e1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8021e5:	75 07                	jne    8021ee <strstr+0x66>
                return (char *) 0;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	eb 33                	jmp    802221 <strstr+0x99>
        } while (sc != c);
  8021ee:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8021f2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8021f5:	75 d8                	jne    8021cf <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8021f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8021ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802203:	48 89 ce             	mov    %rcx,%rsi
  802206:	48 89 c7             	mov    %rax,%rdi
  802209:	48 b8 7f 1c 80 00 00 	movabs $0x801c7f,%rax
  802210:	00 00 00 
  802213:	ff d0                	callq  *%rax
  802215:	85 c0                	test   %eax,%eax
  802217:	75 b6                	jne    8021cf <strstr+0x47>

    return (char *) (in - 1);
  802219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80221d:	48 83 e8 01          	sub    $0x1,%rax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	53                   	push   %rbx
  802228:	48 83 ec 48          	sub    $0x48,%rsp
  80222c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80222f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802232:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802236:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80223a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80223e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802242:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802245:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802249:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80224d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802251:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802255:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802259:	4c 89 c3             	mov    %r8,%rbx
  80225c:	cd 30                	int    $0x30
  80225e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  802262:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802266:	74 3e                	je     8022a6 <syscall+0x83>
  802268:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80226d:	7e 37                	jle    8022a6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80226f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802273:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802276:	49 89 d0             	mov    %rdx,%r8
  802279:	89 c1                	mov    %eax,%ecx
  80227b:	48 ba 00 46 80 00 00 	movabs $0x804600,%rdx
  802282:	00 00 00 
  802285:	be 23 00 00 00       	mov    $0x23,%esi
  80228a:	48 bf 1d 46 80 00 00 	movabs $0x80461d,%rdi
  802291:	00 00 00 
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	49 b9 e9 0a 80 00 00 	movabs $0x800ae9,%r9
  8022a0:	00 00 00 
  8022a3:	41 ff d1             	callq  *%r9

	return ret;
  8022a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022aa:	48 83 c4 48          	add    $0x48,%rsp
  8022ae:	5b                   	pop    %rbx
  8022af:	5d                   	pop    %rbp
  8022b0:	c3                   	retq   

00000000008022b1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8022b1:	55                   	push   %rbp
  8022b2:	48 89 e5             	mov    %rsp,%rbp
  8022b5:	48 83 ec 20          	sub    $0x20,%rsp
  8022b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8022c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022d0:	00 
  8022d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022dd:	48 89 d1             	mov    %rdx,%rcx
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	be 00 00 00 00       	mov    $0x0,%esi
  8022e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ed:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
}
  8022f9:	c9                   	leaveq 
  8022fa:	c3                   	retq   

00000000008022fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8022fb:	55                   	push   %rbp
  8022fc:	48 89 e5             	mov    %rsp,%rbp
  8022ff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802303:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80230a:	00 
  80230b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802311:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80231c:	ba 00 00 00 00       	mov    $0x0,%edx
  802321:	be 00 00 00 00       	mov    $0x0,%esi
  802326:	bf 01 00 00 00       	mov    $0x1,%edi
  80232b:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 10          	sub    $0x10,%rsp
  802341:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802347:	48 98                	cltq   
  802349:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802350:	00 
  802351:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802357:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80235d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802362:	48 89 c2             	mov    %rax,%rdx
  802365:	be 01 00 00 00       	mov    $0x1,%esi
  80236a:	bf 03 00 00 00       	mov    $0x3,%edi
  80236f:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
}
  80237b:	c9                   	leaveq 
  80237c:	c3                   	retq   

000000000080237d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80237d:	55                   	push   %rbp
  80237e:	48 89 e5             	mov    %rsp,%rbp
  802381:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802385:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80238c:	00 
  80238d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802393:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802399:	b9 00 00 00 00       	mov    $0x0,%ecx
  80239e:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a3:	be 00 00 00 00       	mov    $0x0,%esi
  8023a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8023ad:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	callq  *%rax
}
  8023b9:	c9                   	leaveq 
  8023ba:	c3                   	retq   

00000000008023bb <sys_yield>:

void
sys_yield(void)
{
  8023bb:	55                   	push   %rbp
  8023bc:	48 89 e5             	mov    %rsp,%rbp
  8023bf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8023c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023ca:	00 
  8023cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e1:	be 00 00 00 00       	mov    $0x0,%esi
  8023e6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8023eb:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
}
  8023f7:	c9                   	leaveq 
  8023f8:	c3                   	retq   

00000000008023f9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8023f9:	55                   	push   %rbp
  8023fa:	48 89 e5             	mov    %rsp,%rbp
  8023fd:	48 83 ec 20          	sub    $0x20,%rsp
  802401:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802404:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802408:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80240b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240e:	48 63 c8             	movslq %eax,%rcx
  802411:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802418:	48 98                	cltq   
  80241a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802421:	00 
  802422:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802428:	49 89 c8             	mov    %rcx,%r8
  80242b:	48 89 d1             	mov    %rdx,%rcx
  80242e:	48 89 c2             	mov    %rax,%rdx
  802431:	be 01 00 00 00       	mov    $0x1,%esi
  802436:	bf 04 00 00 00       	mov    $0x4,%edi
  80243b:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
}
  802447:	c9                   	leaveq 
  802448:	c3                   	retq   

0000000000802449 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802449:	55                   	push   %rbp
  80244a:	48 89 e5             	mov    %rsp,%rbp
  80244d:	48 83 ec 30          	sub    $0x30,%rsp
  802451:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802454:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802458:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80245b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80245f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802463:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802466:	48 63 c8             	movslq %eax,%rcx
  802469:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80246d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802470:	48 63 f0             	movslq %eax,%rsi
  802473:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802477:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247a:	48 98                	cltq   
  80247c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802480:	49 89 f9             	mov    %rdi,%r9
  802483:	49 89 f0             	mov    %rsi,%r8
  802486:	48 89 d1             	mov    %rdx,%rcx
  802489:	48 89 c2             	mov    %rax,%rdx
  80248c:	be 01 00 00 00       	mov    $0x1,%esi
  802491:	bf 05 00 00 00       	mov    $0x5,%edi
  802496:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
}
  8024a2:	c9                   	leaveq 
  8024a3:	c3                   	retq   

00000000008024a4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024a4:	55                   	push   %rbp
  8024a5:	48 89 e5             	mov    %rsp,%rbp
  8024a8:	48 83 ec 20          	sub    $0x20,%rsp
  8024ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8024b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ba:	48 98                	cltq   
  8024bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024c3:	00 
  8024c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024d0:	48 89 d1             	mov    %rdx,%rcx
  8024d3:	48 89 c2             	mov    %rax,%rdx
  8024d6:	be 01 00 00 00       	mov    $0x1,%esi
  8024db:	bf 06 00 00 00       	mov    $0x6,%edi
  8024e0:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
}
  8024ec:	c9                   	leaveq 
  8024ed:	c3                   	retq   

00000000008024ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8024ee:	55                   	push   %rbp
  8024ef:	48 89 e5             	mov    %rsp,%rbp
  8024f2:	48 83 ec 10          	sub    $0x10,%rsp
  8024f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8024fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ff:	48 63 d0             	movslq %eax,%rdx
  802502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802505:	48 98                	cltq   
  802507:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80250e:	00 
  80250f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802515:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80251b:	48 89 d1             	mov    %rdx,%rcx
  80251e:	48 89 c2             	mov    %rax,%rdx
  802521:	be 01 00 00 00       	mov    $0x1,%esi
  802526:	bf 08 00 00 00       	mov    $0x8,%edi
  80252b:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
}
  802537:	c9                   	leaveq 
  802538:	c3                   	retq   

0000000000802539 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802539:	55                   	push   %rbp
  80253a:	48 89 e5             	mov    %rsp,%rbp
  80253d:	48 83 ec 20          	sub    $0x20,%rsp
  802541:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802544:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802548:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80254c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254f:	48 98                	cltq   
  802551:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802558:	00 
  802559:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80255f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802565:	48 89 d1             	mov    %rdx,%rcx
  802568:	48 89 c2             	mov    %rax,%rdx
  80256b:	be 01 00 00 00       	mov    $0x1,%esi
  802570:	bf 09 00 00 00       	mov    $0x9,%edi
  802575:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80257c:	00 00 00 
  80257f:	ff d0                	callq  *%rax
}
  802581:	c9                   	leaveq 
  802582:	c3                   	retq   

0000000000802583 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802583:	55                   	push   %rbp
  802584:	48 89 e5             	mov    %rsp,%rbp
  802587:	48 83 ec 20          	sub    $0x20,%rsp
  80258b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80258e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802592:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	48 98                	cltq   
  80259b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025a2:	00 
  8025a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025af:	48 89 d1             	mov    %rdx,%rcx
  8025b2:	48 89 c2             	mov    %rax,%rdx
  8025b5:	be 01 00 00 00       	mov    $0x1,%esi
  8025ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8025bf:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8025c6:	00 00 00 
  8025c9:	ff d0                	callq  *%rax
}
  8025cb:	c9                   	leaveq 
  8025cc:	c3                   	retq   

00000000008025cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8025cd:	55                   	push   %rbp
  8025ce:	48 89 e5             	mov    %rsp,%rbp
  8025d1:	48 83 ec 20          	sub    $0x20,%rsp
  8025d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8025e0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8025e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025e6:	48 63 f0             	movslq %eax,%rsi
  8025e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f0:	48 98                	cltq   
  8025f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025fd:	00 
  8025fe:	49 89 f1             	mov    %rsi,%r9
  802601:	49 89 c8             	mov    %rcx,%r8
  802604:	48 89 d1             	mov    %rdx,%rcx
  802607:	48 89 c2             	mov    %rax,%rdx
  80260a:	be 00 00 00 00       	mov    $0x0,%esi
  80260f:	bf 0c 00 00 00       	mov    $0xc,%edi
  802614:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
}
  802620:	c9                   	leaveq 
  802621:	c3                   	retq   

0000000000802622 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802622:	55                   	push   %rbp
  802623:	48 89 e5             	mov    %rsp,%rbp
  802626:	48 83 ec 10          	sub    $0x10,%rsp
  80262a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80262e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802632:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802639:	00 
  80263a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802640:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802646:	b9 00 00 00 00       	mov    $0x0,%ecx
  80264b:	48 89 c2             	mov    %rax,%rdx
  80264e:	be 01 00 00 00       	mov    $0x1,%esi
  802653:	bf 0d 00 00 00       	mov    $0xd,%edi
  802658:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
}
  802664:	c9                   	leaveq 
  802665:	c3                   	retq   

0000000000802666 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802666:	55                   	push   %rbp
  802667:	48 89 e5             	mov    %rsp,%rbp
  80266a:	48 83 ec 10          	sub    $0x10,%rsp
  80266e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  802672:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  802679:	00 00 00 
  80267c:	48 8b 00             	mov    (%rax),%rax
  80267f:	48 85 c0             	test   %rax,%rax
  802682:	75 3a                	jne    8026be <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  802684:	ba 07 00 00 00       	mov    $0x7,%edx
  802689:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80268e:	bf 00 00 00 00       	mov    $0x0,%edi
  802693:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 1b                	jne    8026be <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8026a3:	48 be d1 26 80 00 00 	movabs $0x8026d1,%rsi
  8026aa:	00 00 00 
  8026ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b2:	48 b8 83 25 80 00 00 	movabs $0x802583,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026be:	48 b8 e0 71 80 00 00 	movabs $0x8071e0,%rax
  8026c5:	00 00 00 
  8026c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026cc:	48 89 10             	mov    %rdx,(%rax)
}
  8026cf:	c9                   	leaveq 
  8026d0:	c3                   	retq   

00000000008026d1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8026d1:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8026d4:	48 a1 e0 71 80 00 00 	movabs 0x8071e0,%rax
  8026db:	00 00 00 
	call *%rax
  8026de:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  8026e0:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  8026e3:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8026ea:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  8026eb:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8026f2:	00 
	pushq %rbx		// push utf_rip into new stack
  8026f3:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  8026f4:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  8026fb:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  8026fe:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  802702:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  802706:	4c 8b 3c 24          	mov    (%rsp),%r15
  80270a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80270f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802714:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802719:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80271e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802723:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802728:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80272d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802732:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802737:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80273c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802741:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802746:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80274b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802750:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  802754:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  802758:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  802759:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80275a:	c3                   	retq   

000000000080275b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80275b:	55                   	push   %rbp
  80275c:	48 89 e5             	mov    %rsp,%rbp
  80275f:	48 83 ec 08          	sub    $0x8,%rsp
  802763:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802767:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80276b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802772:	ff ff ff 
  802775:	48 01 d0             	add    %rdx,%rax
  802778:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80277c:	c9                   	leaveq 
  80277d:	c3                   	retq   

000000000080277e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80277e:	55                   	push   %rbp
  80277f:	48 89 e5             	mov    %rsp,%rbp
  802782:	48 83 ec 08          	sub    $0x8,%rsp
  802786:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80278a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278e:	48 89 c7             	mov    %rax,%rdi
  802791:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027a3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027a7:	c9                   	leaveq 
  8027a8:	c3                   	retq   

00000000008027a9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027a9:	55                   	push   %rbp
  8027aa:	48 89 e5             	mov    %rsp,%rbp
  8027ad:	48 83 ec 18          	sub    $0x18,%rsp
  8027b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027bc:	eb 6b                	jmp    802829 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c1:	48 98                	cltq   
  8027c3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027c9:	48 c1 e0 0c          	shl    $0xc,%rax
  8027cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8027d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d5:	48 c1 e8 15          	shr    $0x15,%rax
  8027d9:	48 89 c2             	mov    %rax,%rdx
  8027dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027e3:	01 00 00 
  8027e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ea:	83 e0 01             	and    $0x1,%eax
  8027ed:	48 85 c0             	test   %rax,%rax
  8027f0:	74 21                	je     802813 <fd_alloc+0x6a>
  8027f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8027fa:	48 89 c2             	mov    %rax,%rdx
  8027fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802804:	01 00 00 
  802807:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280b:	83 e0 01             	and    $0x1,%eax
  80280e:	48 85 c0             	test   %rax,%rax
  802811:	75 12                	jne    802825 <fd_alloc+0x7c>
			*fd_store = fd;
  802813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80281b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	eb 1a                	jmp    80283f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802825:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802829:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80282d:	7e 8f                	jle    8027be <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80282f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802833:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80283a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80283f:	c9                   	leaveq 
  802840:	c3                   	retq   

0000000000802841 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802841:	55                   	push   %rbp
  802842:	48 89 e5             	mov    %rsp,%rbp
  802845:	48 83 ec 20          	sub    $0x20,%rsp
  802849:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80284c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802850:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802854:	78 06                	js     80285c <fd_lookup+0x1b>
  802856:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80285a:	7e 07                	jle    802863 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80285c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802861:	eb 6c                	jmp    8028cf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802863:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802866:	48 98                	cltq   
  802868:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80286e:	48 c1 e0 0c          	shl    $0xc,%rax
  802872:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802876:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80287a:	48 c1 e8 15          	shr    $0x15,%rax
  80287e:	48 89 c2             	mov    %rax,%rdx
  802881:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802888:	01 00 00 
  80288b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80288f:	83 e0 01             	and    $0x1,%eax
  802892:	48 85 c0             	test   %rax,%rax
  802895:	74 21                	je     8028b8 <fd_lookup+0x77>
  802897:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289b:	48 c1 e8 0c          	shr    $0xc,%rax
  80289f:	48 89 c2             	mov    %rax,%rdx
  8028a2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028a9:	01 00 00 
  8028ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b0:	83 e0 01             	and    $0x1,%eax
  8028b3:	48 85 c0             	test   %rax,%rax
  8028b6:	75 07                	jne    8028bf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028bd:	eb 10                	jmp    8028cf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8028bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028c7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8028ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028cf:	c9                   	leaveq 
  8028d0:	c3                   	retq   

00000000008028d1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8028d1:	55                   	push   %rbp
  8028d2:	48 89 e5             	mov    %rsp,%rbp
  8028d5:	48 83 ec 30          	sub    $0x30,%rsp
  8028d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028dd:	89 f0                	mov    %esi,%eax
  8028df:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8028e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e6:	48 89 c7             	mov    %rax,%rdi
  8028e9:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f9:	48 89 d6             	mov    %rdx,%rsi
  8028fc:	89 c7                	mov    %eax,%edi
  8028fe:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax
  80290a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802911:	78 0a                	js     80291d <fd_close+0x4c>
	    || fd != fd2)
  802913:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802917:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80291b:	74 12                	je     80292f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80291d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802921:	74 05                	je     802928 <fd_close+0x57>
  802923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802926:	eb 05                	jmp    80292d <fd_close+0x5c>
  802928:	b8 00 00 00 00       	mov    $0x0,%eax
  80292d:	eb 69                	jmp    802998 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80292f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802933:	8b 00                	mov    (%rax),%eax
  802935:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802939:	48 89 d6             	mov    %rdx,%rsi
  80293c:	89 c7                	mov    %eax,%edi
  80293e:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802945:	00 00 00 
  802948:	ff d0                	callq  *%rax
  80294a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802951:	78 2a                	js     80297d <fd_close+0xac>
		if (dev->dev_close)
  802953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802957:	48 8b 40 20          	mov    0x20(%rax),%rax
  80295b:	48 85 c0             	test   %rax,%rax
  80295e:	74 16                	je     802976 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802964:	48 8b 40 20          	mov    0x20(%rax),%rax
  802968:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80296c:	48 89 d7             	mov    %rdx,%rdi
  80296f:	ff d0                	callq  *%rax
  802971:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802974:	eb 07                	jmp    80297d <fd_close+0xac>
		else
			r = 0;
  802976:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80297d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802981:	48 89 c6             	mov    %rax,%rsi
  802984:	bf 00 00 00 00       	mov    $0x0,%edi
  802989:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
	return r;
  802995:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802998:	c9                   	leaveq 
  802999:	c3                   	retq   

000000000080299a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80299a:	55                   	push   %rbp
  80299b:	48 89 e5             	mov    %rsp,%rbp
  80299e:	48 83 ec 20          	sub    $0x20,%rsp
  8029a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029b0:	eb 41                	jmp    8029f3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029b2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8029b9:	00 00 00 
  8029bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029bf:	48 63 d2             	movslq %edx,%rdx
  8029c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c6:	8b 00                	mov    (%rax),%eax
  8029c8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8029cb:	75 22                	jne    8029ef <dev_lookup+0x55>
			*dev = devtab[i];
  8029cd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8029d4:	00 00 00 
  8029d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029da:	48 63 d2             	movslq %edx,%rdx
  8029dd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8029e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8029e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ed:	eb 60                	jmp    802a4f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8029ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029f3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8029fa:	00 00 00 
  8029fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a00:	48 63 d2             	movslq %edx,%rdx
  802a03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a07:	48 85 c0             	test   %rax,%rax
  802a0a:	75 a6                	jne    8029b2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a0c:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802a13:	00 00 00 
  802a16:	48 8b 00             	mov    (%rax),%rax
  802a19:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a1f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a22:	89 c6                	mov    %eax,%esi
  802a24:	48 bf 30 46 80 00 00 	movabs $0x804630,%rdi
  802a2b:	00 00 00 
  802a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a33:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802a3a:	00 00 00 
  802a3d:	ff d1                	callq  *%rcx
	*dev = 0;
  802a3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a43:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a4f:	c9                   	leaveq 
  802a50:	c3                   	retq   

0000000000802a51 <close>:

int
close(int fdnum)
{
  802a51:	55                   	push   %rbp
  802a52:	48 89 e5             	mov    %rsp,%rbp
  802a55:	48 83 ec 20          	sub    $0x20,%rsp
  802a59:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a63:	48 89 d6             	mov    %rdx,%rsi
  802a66:	89 c7                	mov    %eax,%edi
  802a68:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802a6f:	00 00 00 
  802a72:	ff d0                	callq  *%rax
  802a74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7b:	79 05                	jns    802a82 <close+0x31>
		return r;
  802a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a80:	eb 18                	jmp    802a9a <close+0x49>
	else
		return fd_close(fd, 1);
  802a82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a86:	be 01 00 00 00       	mov    $0x1,%esi
  802a8b:	48 89 c7             	mov    %rax,%rdi
  802a8e:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
}
  802a9a:	c9                   	leaveq 
  802a9b:	c3                   	retq   

0000000000802a9c <close_all>:

void
close_all(void)
{
  802a9c:	55                   	push   %rbp
  802a9d:	48 89 e5             	mov    %rsp,%rbp
  802aa0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802aa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aab:	eb 15                	jmp    802ac2 <close_all+0x26>
		close(i);
  802aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab0:	89 c7                	mov    %eax,%edi
  802ab2:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802abe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ac2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802ac6:	7e e5                	jle    802aad <close_all+0x11>
		close(i);
}
  802ac8:	c9                   	leaveq 
  802ac9:	c3                   	retq   

0000000000802aca <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	48 83 ec 40          	sub    $0x40,%rsp
  802ad2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ad5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ad8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802adc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802adf:	48 89 d6             	mov    %rdx,%rsi
  802ae2:	89 c7                	mov    %eax,%edi
  802ae4:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802aeb:	00 00 00 
  802aee:	ff d0                	callq  *%rax
  802af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af7:	79 08                	jns    802b01 <dup+0x37>
		return r;
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	e9 70 01 00 00       	jmpq   802c71 <dup+0x1a7>
	close(newfdnum);
  802b01:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b04:	89 c7                	mov    %eax,%edi
  802b06:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  802b0d:	00 00 00 
  802b10:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b12:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b15:	48 98                	cltq   
  802b17:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b1d:	48 c1 e0 0c          	shl    $0xc,%rax
  802b21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b29:	48 89 c7             	mov    %rax,%rdi
  802b2c:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b40:	48 89 c7             	mov    %rax,%rdi
  802b43:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
  802b4f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b57:	48 c1 e8 15          	shr    $0x15,%rax
  802b5b:	48 89 c2             	mov    %rax,%rdx
  802b5e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b65:	01 00 00 
  802b68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b6c:	83 e0 01             	and    $0x1,%eax
  802b6f:	48 85 c0             	test   %rax,%rax
  802b72:	74 73                	je     802be7 <dup+0x11d>
  802b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b78:	48 c1 e8 0c          	shr    $0xc,%rax
  802b7c:	48 89 c2             	mov    %rax,%rdx
  802b7f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b86:	01 00 00 
  802b89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b8d:	83 e0 01             	and    $0x1,%eax
  802b90:	48 85 c0             	test   %rax,%rax
  802b93:	74 52                	je     802be7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b99:	48 c1 e8 0c          	shr    $0xc,%rax
  802b9d:	48 89 c2             	mov    %rax,%rdx
  802ba0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ba7:	01 00 00 
  802baa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bae:	25 07 0e 00 00       	and    $0xe07,%eax
  802bb3:	89 c1                	mov    %eax,%ecx
  802bb5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbd:	41 89 c8             	mov    %ecx,%r8d
  802bc0:	48 89 d1             	mov    %rdx,%rcx
  802bc3:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc8:	48 89 c6             	mov    %rax,%rsi
  802bcb:	bf 00 00 00 00       	mov    $0x0,%edi
  802bd0:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
  802bdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be3:	79 02                	jns    802be7 <dup+0x11d>
			goto err;
  802be5:	eb 57                	jmp    802c3e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802be7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802beb:	48 c1 e8 0c          	shr    $0xc,%rax
  802bef:	48 89 c2             	mov    %rax,%rdx
  802bf2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bf9:	01 00 00 
  802bfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c00:	25 07 0e 00 00       	and    $0xe07,%eax
  802c05:	89 c1                	mov    %eax,%ecx
  802c07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c0f:	41 89 c8             	mov    %ecx,%r8d
  802c12:	48 89 d1             	mov    %rdx,%rcx
  802c15:	ba 00 00 00 00       	mov    $0x0,%edx
  802c1a:	48 89 c6             	mov    %rax,%rsi
  802c1d:	bf 00 00 00 00       	mov    $0x0,%edi
  802c22:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c35:	79 02                	jns    802c39 <dup+0x16f>
		goto err;
  802c37:	eb 05                	jmp    802c3e <dup+0x174>

	return newfdnum;
  802c39:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c3c:	eb 33                	jmp    802c71 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4a:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5a:	48 89 c6             	mov    %rax,%rsi
  802c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802c62:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
	return r;
  802c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c71:	c9                   	leaveq 
  802c72:	c3                   	retq   

0000000000802c73 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 83 ec 40          	sub    $0x40,%rsp
  802c7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c7e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c82:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c8d:	48 89 d6             	mov    %rdx,%rsi
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	78 24                	js     802ccb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ca7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cab:	8b 00                	mov    (%rax),%eax
  802cad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb1:	48 89 d6             	mov    %rdx,%rsi
  802cb4:	89 c7                	mov    %eax,%edi
  802cb6:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc9:	79 05                	jns    802cd0 <read+0x5d>
		return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	eb 76                	jmp    802d46 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd4:	8b 40 08             	mov    0x8(%rax),%eax
  802cd7:	83 e0 03             	and    $0x3,%eax
  802cda:	83 f8 01             	cmp    $0x1,%eax
  802cdd:	75 3a                	jne    802d19 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802cdf:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802ce6:	00 00 00 
  802ce9:	48 8b 00             	mov    (%rax),%rax
  802cec:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cf5:	89 c6                	mov    %eax,%esi
  802cf7:	48 bf 4f 46 80 00 00 	movabs $0x80464f,%rdi
  802cfe:	00 00 00 
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802d0d:	00 00 00 
  802d10:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d17:	eb 2d                	jmp    802d46 <read+0xd3>
	}
	if (!dev->dev_read)
  802d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d21:	48 85 c0             	test   %rax,%rax
  802d24:	75 07                	jne    802d2d <read+0xba>
		return -E_NOT_SUPP;
  802d26:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d2b:	eb 19                	jmp    802d46 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d31:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d35:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d3d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d41:	48 89 cf             	mov    %rcx,%rdi
  802d44:	ff d0                	callq  *%rax
}
  802d46:	c9                   	leaveq 
  802d47:	c3                   	retq   

0000000000802d48 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d48:	55                   	push   %rbp
  802d49:	48 89 e5             	mov    %rsp,%rbp
  802d4c:	48 83 ec 30          	sub    $0x30,%rsp
  802d50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d62:	eb 49                	jmp    802dad <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d67:	48 98                	cltq   
  802d69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d6d:	48 29 c2             	sub    %rax,%rdx
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d73:	48 63 c8             	movslq %eax,%rcx
  802d76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7a:	48 01 c1             	add    %rax,%rcx
  802d7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d80:	48 89 ce             	mov    %rcx,%rsi
  802d83:	89 c7                	mov    %eax,%edi
  802d85:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d94:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d98:	79 05                	jns    802d9f <readn+0x57>
			return m;
  802d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d9d:	eb 1c                	jmp    802dbb <readn+0x73>
		if (m == 0)
  802d9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802da3:	75 02                	jne    802da7 <readn+0x5f>
			break;
  802da5:	eb 11                	jmp    802db8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802da7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802daa:	01 45 fc             	add    %eax,-0x4(%rbp)
  802dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db0:	48 98                	cltq   
  802db2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802db6:	72 ac                	jb     802d64 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802dbb:	c9                   	leaveq 
  802dbc:	c3                   	retq   

0000000000802dbd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802dbd:	55                   	push   %rbp
  802dbe:	48 89 e5             	mov    %rsp,%rbp
  802dc1:	48 83 ec 40          	sub    $0x40,%rsp
  802dc5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802dc8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dcc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802dd4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dd7:	48 89 d6             	mov    %rdx,%rsi
  802dda:	89 c7                	mov    %eax,%edi
  802ddc:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	callq  *%rax
  802de8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802def:	78 24                	js     802e15 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df5:	8b 00                	mov    (%rax),%eax
  802df7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dfb:	48 89 d6             	mov    %rdx,%rsi
  802dfe:	89 c7                	mov    %eax,%edi
  802e00:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	callq  *%rax
  802e0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e13:	79 05                	jns    802e1a <write+0x5d>
		return r;
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	eb 75                	jmp    802e8f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1e:	8b 40 08             	mov    0x8(%rax),%eax
  802e21:	83 e0 03             	and    $0x3,%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	75 3a                	jne    802e62 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e28:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802e2f:	00 00 00 
  802e32:	48 8b 00             	mov    (%rax),%rax
  802e35:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e3b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e3e:	89 c6                	mov    %eax,%esi
  802e40:	48 bf 6b 46 80 00 00 	movabs $0x80466b,%rdi
  802e47:	00 00 00 
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802e56:	00 00 00 
  802e59:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e5b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e60:	eb 2d                	jmp    802e8f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e66:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e6a:	48 85 c0             	test   %rax,%rax
  802e6d:	75 07                	jne    802e76 <write+0xb9>
		return -E_NOT_SUPP;
  802e6f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e74:	eb 19                	jmp    802e8f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e7e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e82:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e86:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e8a:	48 89 cf             	mov    %rcx,%rdi
  802e8d:	ff d0                	callq  *%rax
}
  802e8f:	c9                   	leaveq 
  802e90:	c3                   	retq   

0000000000802e91 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e91:	55                   	push   %rbp
  802e92:	48 89 e5             	mov    %rsp,%rbp
  802e95:	48 83 ec 18          	sub    $0x18,%rsp
  802e99:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ea3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea6:	48 89 d6             	mov    %rdx,%rsi
  802ea9:	89 c7                	mov    %eax,%edi
  802eab:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebe:	79 05                	jns    802ec5 <seek+0x34>
		return r;
  802ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec3:	eb 0f                	jmp    802ed4 <seek+0x43>
	fd->fd_offset = offset;
  802ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed4:	c9                   	leaveq 
  802ed5:	c3                   	retq   

0000000000802ed6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ed6:	55                   	push   %rbp
  802ed7:	48 89 e5             	mov    %rsp,%rbp
  802eda:	48 83 ec 30          	sub    $0x30,%rsp
  802ede:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ee1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ee4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ee8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
  802efc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f03:	78 24                	js     802f29 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f09:	8b 00                	mov    (%rax),%eax
  802f0b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f0f:	48 89 d6             	mov    %rdx,%rsi
  802f12:	89 c7                	mov    %eax,%edi
  802f14:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
  802f20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f27:	79 05                	jns    802f2e <ftruncate+0x58>
		return r;
  802f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2c:	eb 72                	jmp    802fa0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f32:	8b 40 08             	mov    0x8(%rax),%eax
  802f35:	83 e0 03             	and    $0x3,%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	75 3a                	jne    802f76 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f3c:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  802f43:	00 00 00 
  802f46:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f49:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f4f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f52:	89 c6                	mov    %eax,%esi
  802f54:	48 bf 88 46 80 00 00 	movabs $0x804688,%rdi
  802f5b:	00 00 00 
  802f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f63:	48 b9 22 0d 80 00 00 	movabs $0x800d22,%rcx
  802f6a:	00 00 00 
  802f6d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802f6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f74:	eb 2a                	jmp    802fa0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802f76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f7e:	48 85 c0             	test   %rax,%rax
  802f81:	75 07                	jne    802f8a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802f83:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f88:	eb 16                	jmp    802fa0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f96:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f99:	89 ce                	mov    %ecx,%esi
  802f9b:	48 89 d7             	mov    %rdx,%rdi
  802f9e:	ff d0                	callq  *%rax
}
  802fa0:	c9                   	leaveq 
  802fa1:	c3                   	retq   

0000000000802fa2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fa2:	55                   	push   %rbp
  802fa3:	48 89 e5             	mov    %rsp,%rbp
  802fa6:	48 83 ec 30          	sub    $0x30,%rsp
  802faa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fb8:	48 89 d6             	mov    %rdx,%rsi
  802fbb:	89 c7                	mov    %eax,%edi
  802fbd:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  802fc4:	00 00 00 
  802fc7:	ff d0                	callq  *%rax
  802fc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd0:	78 24                	js     802ff6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd6:	8b 00                	mov    (%rax),%eax
  802fd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fdc:	48 89 d6             	mov    %rdx,%rsi
  802fdf:	89 c7                	mov    %eax,%edi
  802fe1:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff4:	79 05                	jns    802ffb <fstat+0x59>
		return r;
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	eb 5e                	jmp    803059 <fstat+0xb7>
	if (!dev->dev_stat)
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	48 8b 40 28          	mov    0x28(%rax),%rax
  803003:	48 85 c0             	test   %rax,%rax
  803006:	75 07                	jne    80300f <fstat+0x6d>
		return -E_NOT_SUPP;
  803008:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80300d:	eb 4a                	jmp    803059 <fstat+0xb7>
	stat->st_name[0] = 0;
  80300f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803013:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803016:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80301a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803021:	00 00 00 
	stat->st_isdir = 0;
  803024:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803028:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80302f:	00 00 00 
	stat->st_dev = dev;
  803032:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803036:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803045:	48 8b 40 28          	mov    0x28(%rax),%rax
  803049:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80304d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803051:	48 89 ce             	mov    %rcx,%rsi
  803054:	48 89 d7             	mov    %rdx,%rdi
  803057:	ff d0                	callq  *%rax
}
  803059:	c9                   	leaveq 
  80305a:	c3                   	retq   

000000000080305b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80305b:	55                   	push   %rbp
  80305c:	48 89 e5             	mov    %rsp,%rbp
  80305f:	48 83 ec 20          	sub    $0x20,%rsp
  803063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803067:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80306b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306f:	be 00 00 00 00       	mov    $0x0,%esi
  803074:	48 89 c7             	mov    %rax,%rdi
  803077:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308a:	79 05                	jns    803091 <stat+0x36>
		return fd;
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	eb 2f                	jmp    8030c0 <stat+0x65>
	r = fstat(fd, stat);
  803091:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803098:	48 89 d6             	mov    %rdx,%rsi
  80309b:	89 c7                	mov    %eax,%edi
  80309d:	48 b8 a2 2f 80 00 00 	movabs $0x802fa2,%rax
  8030a4:	00 00 00 
  8030a7:	ff d0                	callq  *%rax
  8030a9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030af:	89 c7                	mov    %eax,%edi
  8030b1:	48 b8 51 2a 80 00 00 	movabs $0x802a51,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
	return r;
  8030bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8030c0:	c9                   	leaveq 
  8030c1:	c3                   	retq   

00000000008030c2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8030c2:	55                   	push   %rbp
  8030c3:	48 89 e5             	mov    %rsp,%rbp
  8030c6:	48 83 ec 10          	sub    $0x10,%rsp
  8030ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8030d1:	48 b8 d4 71 80 00 00 	movabs $0x8071d4,%rax
  8030d8:	00 00 00 
  8030db:	8b 00                	mov    (%rax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	75 1d                	jne    8030fe <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8030e1:	bf 01 00 00 00       	mov    $0x1,%edi
  8030e6:	48 b8 b8 3e 80 00 00 	movabs $0x803eb8,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	48 ba d4 71 80 00 00 	movabs $0x8071d4,%rdx
  8030f9:	00 00 00 
  8030fc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030fe:	48 b8 d4 71 80 00 00 	movabs $0x8071d4,%rax
  803105:	00 00 00 
  803108:	8b 00                	mov    (%rax),%eax
  80310a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80310d:	b9 07 00 00 00       	mov    $0x7,%ecx
  803112:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803119:	00 00 00 
  80311c:	89 c7                	mov    %eax,%edi
  80311e:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  803125:	00 00 00 
  803128:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80312a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80312e:	ba 00 00 00 00       	mov    $0x0,%edx
  803133:	48 89 c6             	mov    %rax,%rsi
  803136:	bf 00 00 00 00       	mov    $0x0,%edi
  80313b:	48 b8 57 3d 80 00 00 	movabs $0x803d57,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 20          	sub    $0x20,%rsp
  803151:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803155:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  803158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315c:	48 89 c7             	mov    %rax,%rdi
  80315f:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803166:	00 00 00 
  803169:	ff d0                	callq  *%rax
  80316b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803170:	7e 0a                	jle    80317c <open+0x33>
		return -E_BAD_PATH;
  803172:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803177:	e9 a5 00 00 00       	jmpq   803221 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80317c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 a9 27 80 00 00 	movabs $0x8027a9,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803196:	79 08                	jns    8031a0 <open+0x57>
		return r;
  803198:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319b:	e9 81 00 00 00       	jmpq   803221 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8031a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a4:	48 89 c6             	mov    %rax,%rsi
  8031a7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031ae:	00 00 00 
  8031b1:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8031bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c4:	00 00 00 
  8031c7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031ca:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8031d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d4:	48 89 c6             	mov    %rax,%rsi
  8031d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8031dc:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ef:	79 1d                	jns    80320e <open+0xc5>
		fd_close(fd, 0);
  8031f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f5:	be 00 00 00 00       	mov    $0x0,%esi
  8031fa:	48 89 c7             	mov    %rax,%rdi
  8031fd:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
		return r;
  803209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320c:	eb 13                	jmp    803221 <open+0xd8>
	}

	return fd2num(fd);
  80320e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803212:	48 89 c7             	mov    %rax,%rdi
  803215:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  80321c:	00 00 00 
  80321f:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  803221:	c9                   	leaveq 
  803222:	c3                   	retq   

0000000000803223 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803223:	55                   	push   %rbp
  803224:	48 89 e5             	mov    %rsp,%rbp
  803227:	48 83 ec 10          	sub    $0x10,%rsp
  80322b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80322f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803233:	8b 50 0c             	mov    0xc(%rax),%edx
  803236:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80323d:	00 00 00 
  803240:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803242:	be 00 00 00 00       	mov    $0x0,%esi
  803247:	bf 06 00 00 00       	mov    $0x6,%edi
  80324c:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
}
  803258:	c9                   	leaveq 
  803259:	c3                   	retq   

000000000080325a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80325a:	55                   	push   %rbp
  80325b:	48 89 e5             	mov    %rsp,%rbp
  80325e:	48 83 ec 30          	sub    $0x30,%rsp
  803262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80326a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80326e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803272:	8b 50 0c             	mov    0xc(%rax),%edx
  803275:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80327c:	00 00 00 
  80327f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803281:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803288:	00 00 00 
  80328b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80328f:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803293:	be 00 00 00 00       	mov    $0x0,%esi
  803298:	bf 03 00 00 00       	mov    $0x3,%edi
  80329d:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
  8032a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b0:	79 05                	jns    8032b7 <devfile_read+0x5d>
		return r;
  8032b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b5:	eb 26                	jmp    8032dd <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8032b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ba:	48 63 d0             	movslq %eax,%rdx
  8032bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8032c8:	00 00 00 
  8032cb:	48 89 c7             	mov    %rax,%rdi
  8032ce:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax

	return r;
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8032dd:	c9                   	leaveq 
  8032de:	c3                   	retq   

00000000008032df <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032df:	55                   	push   %rbp
  8032e0:	48 89 e5             	mov    %rsp,%rbp
  8032e3:	48 83 ec 30          	sub    $0x30,%rsp
  8032e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8032f3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032fa:	00 
  8032fb:	76 08                	jbe    803305 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8032fd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803304:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803309:	8b 50 0c             	mov    0xc(%rax),%edx
  80330c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803313:	00 00 00 
  803316:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803318:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80331f:	00 00 00 
  803322:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803326:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80332a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80332e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803332:	48 89 c6             	mov    %rax,%rsi
  803335:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80333c:	00 00 00 
  80333f:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80334b:	be 00 00 00 00       	mov    $0x0,%esi
  803350:	bf 04 00 00 00       	mov    $0x4,%edi
  803355:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  80335c:	00 00 00 
  80335f:	ff d0                	callq  *%rax
  803361:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803364:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803368:	79 05                	jns    80336f <devfile_write+0x90>
		return r;
  80336a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336d:	eb 03                	jmp    803372 <devfile_write+0x93>

	return r;
  80336f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803372:	c9                   	leaveq 
  803373:	c3                   	retq   

0000000000803374 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803374:	55                   	push   %rbp
  803375:	48 89 e5             	mov    %rsp,%rbp
  803378:	48 83 ec 20          	sub    $0x20,%rsp
  80337c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803380:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803388:	8b 50 0c             	mov    0xc(%rax),%edx
  80338b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803392:	00 00 00 
  803395:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803397:	be 00 00 00 00       	mov    $0x0,%esi
  80339c:	bf 05 00 00 00       	mov    $0x5,%edi
  8033a1:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
  8033ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b4:	79 05                	jns    8033bb <devfile_stat+0x47>
		return r;
  8033b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b9:	eb 56                	jmp    803411 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033bf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8033c6:	00 00 00 
  8033c9:	48 89 c7             	mov    %rax,%rdi
  8033cc:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033df:	00 00 00 
  8033e2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ec:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033f9:	00 00 00 
  8033fc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803402:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803406:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803411:	c9                   	leaveq 
  803412:	c3                   	retq   

0000000000803413 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803413:	55                   	push   %rbp
  803414:	48 89 e5             	mov    %rsp,%rbp
  803417:	48 83 ec 10          	sub    $0x10,%rsp
  80341b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80341f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803426:	8b 50 0c             	mov    0xc(%rax),%edx
  803429:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803430:	00 00 00 
  803433:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803435:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80343c:	00 00 00 
  80343f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803442:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803445:	be 00 00 00 00       	mov    $0x0,%esi
  80344a:	bf 02 00 00 00       	mov    $0x2,%edi
  80344f:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
}
  80345b:	c9                   	leaveq 
  80345c:	c3                   	retq   

000000000080345d <remove>:

// Delete a file
int
remove(const char *path)
{
  80345d:	55                   	push   %rbp
  80345e:	48 89 e5             	mov    %rsp,%rbp
  803461:	48 83 ec 10          	sub    $0x10,%rsp
  803465:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803481:	7e 07                	jle    80348a <remove+0x2d>
		return -E_BAD_PATH;
  803483:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803488:	eb 33                	jmp    8034bd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80348a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348e:	48 89 c6             	mov    %rax,%rsi
  803491:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803498:	00 00 00 
  80349b:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  8034a2:	00 00 00 
  8034a5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034a7:	be 00 00 00 00       	mov    $0x0,%esi
  8034ac:	bf 07 00 00 00       	mov    $0x7,%edi
  8034b1:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
}
  8034bd:	c9                   	leaveq 
  8034be:	c3                   	retq   

00000000008034bf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034bf:	55                   	push   %rbp
  8034c0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034c3:	be 00 00 00 00       	mov    $0x0,%esi
  8034c8:	bf 08 00 00 00       	mov    $0x8,%edi
  8034cd:	48 b8 c2 30 80 00 00 	movabs $0x8030c2,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	5d                   	pop    %rbp
  8034da:	c3                   	retq   

00000000008034db <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	53                   	push   %rbx
  8034e0:	48 83 ec 38          	sub    $0x38,%rsp
  8034e4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034e8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 a9 27 80 00 00 	movabs $0x8027a9,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
  8034fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803502:	0f 88 bf 01 00 00    	js     8036c7 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803508:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350c:	ba 07 04 00 00       	mov    $0x407,%edx
  803511:	48 89 c6             	mov    %rax,%rsi
  803514:	bf 00 00 00 00       	mov    $0x0,%edi
  803519:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803520:	00 00 00 
  803523:	ff d0                	callq  *%rax
  803525:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803528:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80352c:	0f 88 95 01 00 00    	js     8036c7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803532:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803536:	48 89 c7             	mov    %rax,%rdi
  803539:	48 b8 a9 27 80 00 00 	movabs $0x8027a9,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
  803545:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803548:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80354c:	0f 88 5d 01 00 00    	js     8036af <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803552:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803556:	ba 07 04 00 00       	mov    $0x407,%edx
  80355b:	48 89 c6             	mov    %rax,%rsi
  80355e:	bf 00 00 00 00       	mov    $0x0,%edi
  803563:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
  80356f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803572:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803576:	0f 88 33 01 00 00    	js     8036af <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80357c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803580:	48 89 c7             	mov    %rax,%rdi
  803583:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803593:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803597:	ba 07 04 00 00       	mov    $0x407,%edx
  80359c:	48 89 c6             	mov    %rax,%rsi
  80359f:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a4:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  8035ab:	00 00 00 
  8035ae:	ff d0                	callq  *%rax
  8035b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b7:	79 05                	jns    8035be <pipe+0xe3>
		goto err2;
  8035b9:	e9 d9 00 00 00       	jmpq   803697 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c2:	48 89 c7             	mov    %rax,%rdi
  8035c5:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	48 89 c2             	mov    %rax,%rdx
  8035d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035de:	48 89 d1             	mov    %rdx,%rcx
  8035e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035e6:	48 89 c6             	mov    %rax,%rsi
  8035e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ee:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
  8035fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803601:	79 1b                	jns    80361e <pipe+0x143>
		goto err3;
  803603:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803604:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803608:	48 89 c6             	mov    %rax,%rsi
  80360b:	bf 00 00 00 00       	mov    $0x0,%edi
  803610:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	eb 79                	jmp    803697 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80361e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803622:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803629:	00 00 00 
  80362c:	8b 12                	mov    (%rdx),%edx
  80362e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803634:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80363b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80363f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803646:	00 00 00 
  803649:	8b 12                	mov    (%rdx),%edx
  80364b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80364d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803651:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80365c:	48 89 c7             	mov    %rax,%rdi
  80365f:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  803666:	00 00 00 
  803669:	ff d0                	callq  *%rax
  80366b:	89 c2                	mov    %eax,%edx
  80366d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803671:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803673:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803677:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80367b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367f:	48 89 c7             	mov    %rax,%rdi
  803682:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
  80368e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803690:	b8 00 00 00 00       	mov    $0x0,%eax
  803695:	eb 33                	jmp    8036ca <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803697:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80369b:	48 89 c6             	mov    %rax,%rsi
  80369e:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a3:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8036af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b3:	48 89 c6             	mov    %rax,%rsi
  8036b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bb:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  8036c2:	00 00 00 
  8036c5:	ff d0                	callq  *%rax
    err:
	return r;
  8036c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036ca:	48 83 c4 38          	add    $0x38,%rsp
  8036ce:	5b                   	pop    %rbx
  8036cf:	5d                   	pop    %rbp
  8036d0:	c3                   	retq   

00000000008036d1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036d1:	55                   	push   %rbp
  8036d2:	48 89 e5             	mov    %rsp,%rbp
  8036d5:	53                   	push   %rbx
  8036d6:	48 83 ec 28          	sub    $0x28,%rsp
  8036da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036e2:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  8036e9:	00 00 00 
  8036ec:	48 8b 00             	mov    (%rax),%rax
  8036ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036fc:	48 89 c7             	mov    %rax,%rdi
  8036ff:	48 b8 3a 3f 80 00 00 	movabs $0x803f3a,%rax
  803706:	00 00 00 
  803709:	ff d0                	callq  *%rax
  80370b:	89 c3                	mov    %eax,%ebx
  80370d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803711:	48 89 c7             	mov    %rax,%rdi
  803714:	48 b8 3a 3f 80 00 00 	movabs $0x803f3a,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
  803720:	39 c3                	cmp    %eax,%ebx
  803722:	0f 94 c0             	sete   %al
  803725:	0f b6 c0             	movzbl %al,%eax
  803728:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80372b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803732:	00 00 00 
  803735:	48 8b 00             	mov    (%rax),%rax
  803738:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80373e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803741:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803744:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803747:	75 05                	jne    80374e <_pipeisclosed+0x7d>
			return ret;
  803749:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80374c:	eb 4f                	jmp    80379d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80374e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803751:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803754:	74 42                	je     803798 <_pipeisclosed+0xc7>
  803756:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80375a:	75 3c                	jne    803798 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80375c:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803763:	00 00 00 
  803766:	48 8b 00             	mov    (%rax),%rax
  803769:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80376f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803772:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803775:	89 c6                	mov    %eax,%esi
  803777:	48 bf b3 46 80 00 00 	movabs $0x8046b3,%rdi
  80377e:	00 00 00 
  803781:	b8 00 00 00 00       	mov    $0x0,%eax
  803786:	49 b8 22 0d 80 00 00 	movabs $0x800d22,%r8
  80378d:	00 00 00 
  803790:	41 ff d0             	callq  *%r8
	}
  803793:	e9 4a ff ff ff       	jmpq   8036e2 <_pipeisclosed+0x11>
  803798:	e9 45 ff ff ff       	jmpq   8036e2 <_pipeisclosed+0x11>
}
  80379d:	48 83 c4 28          	add    $0x28,%rsp
  8037a1:	5b                   	pop    %rbx
  8037a2:	5d                   	pop    %rbp
  8037a3:	c3                   	retq   

00000000008037a4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037a4:	55                   	push   %rbp
  8037a5:	48 89 e5             	mov    %rsp,%rbp
  8037a8:	48 83 ec 30          	sub    $0x30,%rsp
  8037ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037b6:	48 89 d6             	mov    %rdx,%rsi
  8037b9:	89 c7                	mov    %eax,%edi
  8037bb:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ce:	79 05                	jns    8037d5 <pipeisclosed+0x31>
		return r;
  8037d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d3:	eb 31                	jmp    803806 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d9:	48 89 c7             	mov    %rax,%rdi
  8037dc:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
  8037e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037f4:	48 89 d6             	mov    %rdx,%rsi
  8037f7:	48 89 c7             	mov    %rax,%rdi
  8037fa:	48 b8 d1 36 80 00 00 	movabs $0x8036d1,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
}
  803806:	c9                   	leaveq 
  803807:	c3                   	retq   

0000000000803808 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 40          	sub    $0x40,%rsp
  803810:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803814:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803818:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80381c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803820:	48 89 c7             	mov    %rax,%rdi
  803823:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
  80382f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803833:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803837:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80383b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803842:	00 
  803843:	e9 92 00 00 00       	jmpq   8038da <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803848:	eb 41                	jmp    80388b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80384a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80384f:	74 09                	je     80385a <devpipe_read+0x52>
				return i;
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803855:	e9 92 00 00 00       	jmpq   8038ec <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80385a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80385e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803862:	48 89 d6             	mov    %rdx,%rsi
  803865:	48 89 c7             	mov    %rax,%rdi
  803868:	48 b8 d1 36 80 00 00 	movabs $0x8036d1,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
  803874:	85 c0                	test   %eax,%eax
  803876:	74 07                	je     80387f <devpipe_read+0x77>
				return 0;
  803878:	b8 00 00 00 00       	mov    $0x0,%eax
  80387d:	eb 6d                	jmp    8038ec <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80387f:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80388b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388f:	8b 10                	mov    (%rax),%edx
  803891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803895:	8b 40 04             	mov    0x4(%rax),%eax
  803898:	39 c2                	cmp    %eax,%edx
  80389a:	74 ae                	je     80384a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80389c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038a4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ac:	8b 00                	mov    (%rax),%eax
  8038ae:	99                   	cltd   
  8038af:	c1 ea 1b             	shr    $0x1b,%edx
  8038b2:	01 d0                	add    %edx,%eax
  8038b4:	83 e0 1f             	and    $0x1f,%eax
  8038b7:	29 d0                	sub    %edx,%eax
  8038b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038bd:	48 98                	cltq   
  8038bf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038c4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ca:	8b 00                	mov    (%rax),%eax
  8038cc:	8d 50 01             	lea    0x1(%rax),%edx
  8038cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038e2:	0f 82 60 ff ff ff    	jb     803848 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038ec:	c9                   	leaveq 
  8038ed:	c3                   	retq   

00000000008038ee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038ee:	55                   	push   %rbp
  8038ef:	48 89 e5             	mov    %rsp,%rbp
  8038f2:	48 83 ec 40          	sub    $0x40,%rsp
  8038f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803906:	48 89 c7             	mov    %rax,%rdi
  803909:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803919:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80391d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803921:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803928:	00 
  803929:	e9 8e 00 00 00       	jmpq   8039bc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80392e:	eb 31                	jmp    803961 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803930:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803938:	48 89 d6             	mov    %rdx,%rsi
  80393b:	48 89 c7             	mov    %rax,%rdi
  80393e:	48 b8 d1 36 80 00 00 	movabs $0x8036d1,%rax
  803945:	00 00 00 
  803948:	ff d0                	callq  *%rax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 07                	je     803955 <devpipe_write+0x67>
				return 0;
  80394e:	b8 00 00 00 00       	mov    $0x0,%eax
  803953:	eb 79                	jmp    8039ce <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803955:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  80395c:	00 00 00 
  80395f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803965:	8b 40 04             	mov    0x4(%rax),%eax
  803968:	48 63 d0             	movslq %eax,%rdx
  80396b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396f:	8b 00                	mov    (%rax),%eax
  803971:	48 98                	cltq   
  803973:	48 83 c0 20          	add    $0x20,%rax
  803977:	48 39 c2             	cmp    %rax,%rdx
  80397a:	73 b4                	jae    803930 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80397c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803980:	8b 40 04             	mov    0x4(%rax),%eax
  803983:	99                   	cltd   
  803984:	c1 ea 1b             	shr    $0x1b,%edx
  803987:	01 d0                	add    %edx,%eax
  803989:	83 e0 1f             	and    $0x1f,%eax
  80398c:	29 d0                	sub    %edx,%eax
  80398e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803992:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803996:	48 01 ca             	add    %rcx,%rdx
  803999:	0f b6 0a             	movzbl (%rdx),%ecx
  80399c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039a0:	48 98                	cltq   
  8039a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039aa:	8b 40 04             	mov    0x4(%rax),%eax
  8039ad:	8d 50 01             	lea    0x1(%rax),%edx
  8039b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039c4:	0f 82 64 ff ff ff    	jb     80392e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039ce:	c9                   	leaveq 
  8039cf:	c3                   	retq   

00000000008039d0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 83 ec 20          	sub    $0x20,%rsp
  8039d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e4:	48 89 c7             	mov    %rax,%rdi
  8039e7:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  8039ee:	00 00 00 
  8039f1:	ff d0                	callq  *%rax
  8039f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039fb:	48 be c6 46 80 00 00 	movabs $0x8046c6,%rsi
  803a02:	00 00 00 
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a18:	8b 50 04             	mov    0x4(%rax),%edx
  803a1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1f:	8b 00                	mov    (%rax),%eax
  803a21:	29 c2                	sub    %eax,%edx
  803a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a27:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a31:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a38:	00 00 00 
	stat->st_dev = &devpipe;
  803a3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3f:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a46:	00 00 00 
  803a49:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a55:	c9                   	leaveq 
  803a56:	c3                   	retq   

0000000000803a57 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a57:	55                   	push   %rbp
  803a58:	48 89 e5             	mov    %rsp,%rbp
  803a5b:	48 83 ec 10          	sub    $0x10,%rsp
  803a5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a67:	48 89 c6             	mov    %rax,%rsi
  803a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6f:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a7f:	48 89 c7             	mov    %rax,%rdi
  803a82:	48 b8 7e 27 80 00 00 	movabs $0x80277e,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
  803a8e:	48 89 c6             	mov    %rax,%rsi
  803a91:	bf 00 00 00 00       	mov    $0x0,%edi
  803a96:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
}
  803aa2:	c9                   	leaveq 
  803aa3:	c3                   	retq   

0000000000803aa4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803aa4:	55                   	push   %rbp
  803aa5:	48 89 e5             	mov    %rsp,%rbp
  803aa8:	48 83 ec 20          	sub    $0x20,%rsp
  803aac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803aaf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ab2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ab5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ab9:	be 01 00 00 00       	mov    $0x1,%esi
  803abe:	48 89 c7             	mov    %rax,%rdi
  803ac1:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
}
  803acd:	c9                   	leaveq 
  803ace:	c3                   	retq   

0000000000803acf <getchar>:

int
getchar(void)
{
  803acf:	55                   	push   %rbp
  803ad0:	48 89 e5             	mov    %rsp,%rbp
  803ad3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ad7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803adb:	ba 01 00 00 00       	mov    $0x1,%edx
  803ae0:	48 89 c6             	mov    %rax,%rsi
  803ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae8:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  803aef:	00 00 00 
  803af2:	ff d0                	callq  *%rax
  803af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afb:	79 05                	jns    803b02 <getchar+0x33>
		return r;
  803afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b00:	eb 14                	jmp    803b16 <getchar+0x47>
	if (r < 1)
  803b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b06:	7f 07                	jg     803b0f <getchar+0x40>
		return -E_EOF;
  803b08:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b0d:	eb 07                	jmp    803b16 <getchar+0x47>
	return c;
  803b0f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b13:	0f b6 c0             	movzbl %al,%eax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	48 83 ec 20          	sub    $0x20,%rsp
  803b20:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b2a:	48 89 d6             	mov    %rdx,%rsi
  803b2d:	89 c7                	mov    %eax,%edi
  803b2f:	48 b8 41 28 80 00 00 	movabs $0x802841,%rax
  803b36:	00 00 00 
  803b39:	ff d0                	callq  *%rax
  803b3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b42:	79 05                	jns    803b49 <iscons+0x31>
		return r;
  803b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b47:	eb 1a                	jmp    803b63 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4d:	8b 10                	mov    (%rax),%edx
  803b4f:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b56:	00 00 00 
  803b59:	8b 00                	mov    (%rax),%eax
  803b5b:	39 c2                	cmp    %eax,%edx
  803b5d:	0f 94 c0             	sete   %al
  803b60:	0f b6 c0             	movzbl %al,%eax
}
  803b63:	c9                   	leaveq 
  803b64:	c3                   	retq   

0000000000803b65 <opencons>:

int
opencons(void)
{
  803b65:	55                   	push   %rbp
  803b66:	48 89 e5             	mov    %rsp,%rbp
  803b69:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b6d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b71:	48 89 c7             	mov    %rax,%rdi
  803b74:	48 b8 a9 27 80 00 00 	movabs $0x8027a9,%rax
  803b7b:	00 00 00 
  803b7e:	ff d0                	callq  *%rax
  803b80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b87:	79 05                	jns    803b8e <opencons+0x29>
		return r;
  803b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8c:	eb 5b                	jmp    803be9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b92:	ba 07 04 00 00       	mov    $0x407,%edx
  803b97:	48 89 c6             	mov    %rax,%rsi
  803b9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803b9f:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
  803bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb2:	79 05                	jns    803bb9 <opencons+0x54>
		return r;
  803bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb7:	eb 30                	jmp    803be9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbd:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803bc4:	00 00 00 
  803bc7:	8b 12                	mov    (%rdx),%edx
  803bc9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bcf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bda:	48 89 c7             	mov    %rax,%rdi
  803bdd:	48 b8 5b 27 80 00 00 	movabs $0x80275b,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
}
  803be9:	c9                   	leaveq 
  803bea:	c3                   	retq   

0000000000803beb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803beb:	55                   	push   %rbp
  803bec:	48 89 e5             	mov    %rsp,%rbp
  803bef:	48 83 ec 30          	sub    $0x30,%rsp
  803bf3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bf7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bfb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c04:	75 07                	jne    803c0d <devcons_read+0x22>
		return 0;
  803c06:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0b:	eb 4b                	jmp    803c58 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c0d:	eb 0c                	jmp    803c1b <devcons_read+0x30>
		sys_yield();
  803c0f:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c1b:	48 b8 fb 22 80 00 00 	movabs $0x8022fb,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2e:	74 df                	je     803c0f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c34:	79 05                	jns    803c3b <devcons_read+0x50>
		return c;
  803c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c39:	eb 1d                	jmp    803c58 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c3b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c3f:	75 07                	jne    803c48 <devcons_read+0x5d>
		return 0;
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	eb 10                	jmp    803c58 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c4b:	89 c2                	mov    %eax,%edx
  803c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c51:	88 10                	mov    %dl,(%rax)
	return 1;
  803c53:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c58:	c9                   	leaveq 
  803c59:	c3                   	retq   

0000000000803c5a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c5a:	55                   	push   %rbp
  803c5b:	48 89 e5             	mov    %rsp,%rbp
  803c5e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c65:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c6c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c73:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c81:	eb 76                	jmp    803cf9 <devcons_write+0x9f>
		m = n - tot;
  803c83:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c8a:	89 c2                	mov    %eax,%edx
  803c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8f:	29 c2                	sub    %eax,%edx
  803c91:	89 d0                	mov    %edx,%eax
  803c93:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c99:	83 f8 7f             	cmp    $0x7f,%eax
  803c9c:	76 07                	jbe    803ca5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c9e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ca5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca8:	48 63 d0             	movslq %eax,%rdx
  803cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cae:	48 63 c8             	movslq %eax,%rcx
  803cb1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803cb8:	48 01 c1             	add    %rax,%rcx
  803cbb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cc2:	48 89 ce             	mov    %rcx,%rsi
  803cc5:	48 89 c7             	mov    %rax,%rdi
  803cc8:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cd4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd7:	48 63 d0             	movslq %eax,%rdx
  803cda:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ce1:	48 89 d6             	mov    %rdx,%rsi
  803ce4:	48 89 c7             	mov    %rax,%rdi
  803ce7:	48 b8 b1 22 80 00 00 	movabs $0x8022b1,%rax
  803cee:	00 00 00 
  803cf1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cf3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cf6:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cfc:	48 98                	cltq   
  803cfe:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d05:	0f 82 78 ff ff ff    	jb     803c83 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d0e:	c9                   	leaveq 
  803d0f:	c3                   	retq   

0000000000803d10 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d10:	55                   	push   %rbp
  803d11:	48 89 e5             	mov    %rsp,%rbp
  803d14:	48 83 ec 08          	sub    $0x8,%rsp
  803d18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d21:	c9                   	leaveq 
  803d22:	c3                   	retq   

0000000000803d23 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d23:	55                   	push   %rbp
  803d24:	48 89 e5             	mov    %rsp,%rbp
  803d27:	48 83 ec 10          	sub    $0x10,%rsp
  803d2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d37:	48 be d2 46 80 00 00 	movabs $0x8046d2,%rsi
  803d3e:	00 00 00 
  803d41:	48 89 c7             	mov    %rax,%rdi
  803d44:	48 b8 ca 1a 80 00 00 	movabs $0x801aca,%rax
  803d4b:	00 00 00 
  803d4e:	ff d0                	callq  *%rax
	return 0;
  803d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d55:	c9                   	leaveq 
  803d56:	c3                   	retq   

0000000000803d57 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d57:	55                   	push   %rbp
  803d58:	48 89 e5             	mov    %rsp,%rbp
  803d5b:	48 83 ec 30          	sub    $0x30,%rsp
  803d5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803d6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803d73:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d78:	75 0e                	jne    803d88 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803d7a:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d81:	00 00 00 
  803d84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d8c:	48 89 c7             	mov    %rax,%rdi
  803d8f:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  803d96:	00 00 00 
  803d99:	ff d0                	callq  *%rax
  803d9b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803da2:	79 27                	jns    803dcb <ipc_recv+0x74>
		if (from_env_store != NULL)
  803da4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803da9:	74 0a                	je     803db5 <ipc_recv+0x5e>
			*from_env_store = 0;
  803dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803daf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803db5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dba:	74 0a                	je     803dc6 <ipc_recv+0x6f>
			*perm_store = 0;
  803dbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803dc6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803dc9:	eb 53                	jmp    803e1e <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803dcb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803dd0:	74 19                	je     803deb <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803dd2:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803dd9:	00 00 00 
  803ddc:	48 8b 00             	mov    (%rax),%rax
  803ddf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de9:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803deb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803df0:	74 19                	je     803e0b <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803df2:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803df9:	00 00 00 
  803dfc:	48 8b 00             	mov    (%rax),%rax
  803dff:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e09:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803e0b:	48 b8 d8 71 80 00 00 	movabs $0x8071d8,%rax
  803e12:	00 00 00 
  803e15:	48 8b 00             	mov    (%rax),%rax
  803e18:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803e1e:	c9                   	leaveq 
  803e1f:	c3                   	retq   

0000000000803e20 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e20:	55                   	push   %rbp
  803e21:	48 89 e5             	mov    %rsp,%rbp
  803e24:	48 83 ec 30          	sub    $0x30,%rsp
  803e28:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e2b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e2e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e32:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803e35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803e3d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e42:	75 10                	jne    803e54 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803e44:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e4b:	00 00 00 
  803e4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803e52:	eb 0e                	jmp    803e62 <ipc_send+0x42>
  803e54:	eb 0c                	jmp    803e62 <ipc_send+0x42>
		sys_yield();
  803e56:	48 b8 bb 23 80 00 00 	movabs $0x8023bb,%rax
  803e5d:	00 00 00 
  803e60:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803e62:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e65:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e6f:	89 c7                	mov    %eax,%edi
  803e71:	48 b8 cd 25 80 00 00 	movabs $0x8025cd,%rax
  803e78:	00 00 00 
  803e7b:	ff d0                	callq  *%rax
  803e7d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803e80:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803e84:	74 d0                	je     803e56 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803e8a:	74 2a                	je     803eb6 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803e8c:	48 ba d9 46 80 00 00 	movabs $0x8046d9,%rdx
  803e93:	00 00 00 
  803e96:	be 49 00 00 00       	mov    $0x49,%esi
  803e9b:	48 bf f5 46 80 00 00 	movabs $0x8046f5,%rdi
  803ea2:	00 00 00 
  803ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eaa:	48 b9 e9 0a 80 00 00 	movabs $0x800ae9,%rcx
  803eb1:	00 00 00 
  803eb4:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803eb6:	c9                   	leaveq 
  803eb7:	c3                   	retq   

0000000000803eb8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803eb8:	55                   	push   %rbp
  803eb9:	48 89 e5             	mov    %rsp,%rbp
  803ebc:	48 83 ec 14          	sub    $0x14,%rsp
  803ec0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803ec3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803eca:	eb 5e                	jmp    803f2a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ecc:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ed3:	00 00 00 
  803ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed9:	48 63 d0             	movslq %eax,%rdx
  803edc:	48 89 d0             	mov    %rdx,%rax
  803edf:	48 c1 e0 03          	shl    $0x3,%rax
  803ee3:	48 01 d0             	add    %rdx,%rax
  803ee6:	48 c1 e0 05          	shl    $0x5,%rax
  803eea:	48 01 c8             	add    %rcx,%rax
  803eed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ef3:	8b 00                	mov    (%rax),%eax
  803ef5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ef8:	75 2c                	jne    803f26 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803efa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f01:	00 00 00 
  803f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f07:	48 63 d0             	movslq %eax,%rdx
  803f0a:	48 89 d0             	mov    %rdx,%rax
  803f0d:	48 c1 e0 03          	shl    $0x3,%rax
  803f11:	48 01 d0             	add    %rdx,%rax
  803f14:	48 c1 e0 05          	shl    $0x5,%rax
  803f18:	48 01 c8             	add    %rcx,%rax
  803f1b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f21:	8b 40 08             	mov    0x8(%rax),%eax
  803f24:	eb 12                	jmp    803f38 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803f26:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f2a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f31:	7e 99                	jle    803ecc <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803f33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f38:	c9                   	leaveq 
  803f39:	c3                   	retq   

0000000000803f3a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f3a:	55                   	push   %rbp
  803f3b:	48 89 e5             	mov    %rsp,%rbp
  803f3e:	48 83 ec 18          	sub    $0x18,%rsp
  803f42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f4a:	48 c1 e8 15          	shr    $0x15,%rax
  803f4e:	48 89 c2             	mov    %rax,%rdx
  803f51:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f58:	01 00 00 
  803f5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f5f:	83 e0 01             	and    $0x1,%eax
  803f62:	48 85 c0             	test   %rax,%rax
  803f65:	75 07                	jne    803f6e <pageref+0x34>
		return 0;
  803f67:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6c:	eb 53                	jmp    803fc1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f72:	48 c1 e8 0c          	shr    $0xc,%rax
  803f76:	48 89 c2             	mov    %rax,%rdx
  803f79:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f80:	01 00 00 
  803f83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8f:	83 e0 01             	and    $0x1,%eax
  803f92:	48 85 c0             	test   %rax,%rax
  803f95:	75 07                	jne    803f9e <pageref+0x64>
		return 0;
  803f97:	b8 00 00 00 00       	mov    $0x0,%eax
  803f9c:	eb 23                	jmp    803fc1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa2:	48 c1 e8 0c          	shr    $0xc,%rax
  803fa6:	48 89 c2             	mov    %rax,%rdx
  803fa9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fb0:	00 00 00 
  803fb3:	48 c1 e2 04          	shl    $0x4,%rdx
  803fb7:	48 01 d0             	add    %rdx,%rax
  803fba:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fbe:	0f b7 c0             	movzwl %ax,%eax
}
  803fc1:	c9                   	leaveq 
  803fc2:	c3                   	retq   
