
obj/user/testfile.debug:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 73 29 80 00 00 	movabs $0x802973,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 aa 28 80 00 00 	movabs $0x8028aa,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf 46 41 80 00 00 	movabs $0x804146,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba 51 41 80 00 00 	movabs $0x804151,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf a1 41 80 00 00 	movabs $0x8041a1,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba aa 41 80 00 00 	movabs $0x8041aa,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf f5 41 80 00 00 	movabs $0x8041f5,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba 09 42 80 00 00 	movabs $0x804209,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba 18 42 80 00 00 	movabs $0x804218,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf 3e 42 80 00 00 	movabs $0x80423e,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba 51 42 80 00 00 	movabs $0x804251,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba 5f 42 80 00 00 	movabs $0x80425f,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 7d 42 80 00 00 	movabs $0x80427d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 90 42 80 00 00 	movabs $0x804290,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 9f 42 80 00 00 	movabs $0x80429f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba b8 42 80 00 00 	movabs $0x8042b8,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf ef 42 80 00 00 	movabs $0x8042ef,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf 05 43 80 00 00 	movabs $0x804305,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba 0f 43 80 00 00 	movabs $0x80430f,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf 28 43 80 00 00 	movabs $0x804328,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 66 0f 80 00 00 	movabs $0x800f66,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba 68 43 80 00 00 	movabs $0x804368,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf 77 43 80 00 00 	movabs $0x804377,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba b0 43 80 00 00 	movabs $0x8043b0,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 70 1e 80 00 00 	movabs $0x801e70,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf 46 41 80 00 00 	movabs $0x804146,%rdi
  800833:	00 00 00 
  800836:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba 3c 44 80 00 00 	movabs $0x80443c,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba 50 44 80 00 00 	movabs $0x804450,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf a1 41 80 00 00 	movabs $0x8041a1,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba 6b 44 80 00 00 	movabs $0x80446b,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 80 44 80 00 00 	movabs $0x804480,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf a7 44 80 00 00 	movabs $0x8044a7,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf b5 44 80 00 00 	movabs $0x8044b5,%rdi
  800997:	00 00 00 
  80099a:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba ba 44 80 00 00 	movabs $0x8044ba,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 ef 30 80 00 00 	movabs $0x8030ef,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba c9 44 80 00 00 	movabs $0x8044c9,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 83 2d 80 00 00 	movabs $0x802d83,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf b5 44 80 00 00 	movabs $0x8044b5,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba db 44 80 00 00 	movabs $0x8044db,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 2d 0d 80 00 00 	movabs $0x800d2d,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 7a 30 80 00 00 	movabs $0x80307a,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba e9 44 80 00 00 	movabs $0x8044e9,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba 00 45 80 00 00 	movabs $0x804500,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 2d 0d 80 00 00 	movabs $0x800d2d,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 83 2d 80 00 00 	movabs $0x802d83,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf 57 45 80 00 00 	movabs $0x804557,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800c89:	48 b8 c1 25 80 00 00 	movabs $0x8025c1,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 98                	cltq   
  800c97:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9c:	48 89 c2             	mov    %rax,%rdx
  800c9f:	48 89 d0             	mov    %rdx,%rax
  800ca2:	48 c1 e0 03          	shl    $0x3,%rax
  800ca6:	48 01 d0             	add    %rdx,%rax
  800ca9:	48 c1 e0 05          	shl    $0x5,%rax
  800cad:	48 89 c2             	mov    %rax,%rdx
  800cb0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800cb7:	00 00 00 
  800cba:	48 01 c2             	add    %rax,%rdx
  800cbd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cc4:	00 00 00 
  800cc7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cce:	7e 14                	jle    800ce4 <libmain+0x6a>
		binaryname = argv[0];
  800cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd4:	48 8b 10             	mov    (%rax),%rdx
  800cd7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cde:	00 00 00 
  800ce1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	89 c7                	mov    %eax,%edi
  800cf0:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cfc:	48 b8 0a 0d 80 00 00 	movabs $0x800d0a,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
}
  800d08:	c9                   	leaveq 
  800d09:	c3                   	retq   

0000000000800d0a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d0a:	55                   	push   %rbp
  800d0b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d0e:	48 b8 ce 2d 80 00 00 	movabs $0x802dce,%rax
  800d15:	00 00 00 
  800d18:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1f:	48 b8 7d 25 80 00 00 	movabs $0x80257d,%rax
  800d26:	00 00 00 
  800d29:	ff d0                	callq  *%rax
}
  800d2b:	5d                   	pop    %rbp
  800d2c:	c3                   	retq   

0000000000800d2d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d2d:	55                   	push   %rbp
  800d2e:	48 89 e5             	mov    %rsp,%rbp
  800d31:	53                   	push   %rbx
  800d32:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d39:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d40:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d46:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d4d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d54:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 23                	je     800d82 <_panic+0x55>
  800d5f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d66:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d6a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d6e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d72:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d76:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d7a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d7e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d82:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d89:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d90:	00 00 00 
  800d93:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d9a:	00 00 00 
  800d9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800da8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800daf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800db6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800dbd:	00 00 00 
  800dc0:	48 8b 18             	mov    (%rax),%rbx
  800dc3:	48 b8 c1 25 80 00 00 	movabs $0x8025c1,%rax
  800dca:	00 00 00 
  800dcd:	ff d0                	callq  *%rax
  800dcf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dd5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ddc:	41 89 c8             	mov    %ecx,%r8d
  800ddf:	48 89 d1             	mov    %rdx,%rcx
  800de2:	48 89 da             	mov    %rbx,%rdx
  800de5:	89 c6                	mov    %eax,%esi
  800de7:	48 bf 78 45 80 00 00 	movabs $0x804578,%rdi
  800dee:	00 00 00 
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	49 b9 66 0f 80 00 00 	movabs $0x800f66,%r9
  800dfd:	00 00 00 
  800e00:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800e03:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800e0a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e11:	48 89 d6             	mov    %rdx,%rsi
  800e14:	48 89 c7             	mov    %rax,%rdi
  800e17:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  800e1e:	00 00 00 
  800e21:	ff d0                	callq  *%rax
	cprintf("\n");
  800e23:	48 bf 9b 45 80 00 00 	movabs $0x80459b,%rdi
  800e2a:	00 00 00 
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e32:	48 ba 66 0f 80 00 00 	movabs $0x800f66,%rdx
  800e39:	00 00 00 
  800e3c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e3e:	cc                   	int3   
  800e3f:	eb fd                	jmp    800e3e <_panic+0x111>

0000000000800e41 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 10          	sub    $0x10,%rsp
  800e49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e54:	8b 00                	mov    (%rax),%eax
  800e56:	8d 48 01             	lea    0x1(%rax),%ecx
  800e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5d:	89 0a                	mov    %ecx,(%rdx)
  800e5f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e68:	48 98                	cltq   
  800e6a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	8b 00                	mov    (%rax),%eax
  800e74:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e79:	75 2c                	jne    800ea7 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	8b 00                	mov    (%rax),%eax
  800e81:	48 98                	cltq   
  800e83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e87:	48 83 c2 08          	add    $0x8,%rdx
  800e8b:	48 89 c6             	mov    %rax,%rsi
  800e8e:	48 89 d7             	mov    %rdx,%rdi
  800e91:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
		b->idx = 0;
  800e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eab:	8b 40 04             	mov    0x4(%rax),%eax
  800eae:	8d 50 01             	lea    0x1(%rax),%edx
  800eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb5:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ec5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ecc:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800ed3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800eda:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ee1:	48 8b 0a             	mov    (%rdx),%rcx
  800ee4:	48 89 08             	mov    %rcx,(%rax)
  800ee7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eeb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ef7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800efe:	00 00 00 
	b.cnt = 0;
  800f01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800f08:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800f0b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f12:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f19:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f20:	48 89 c6             	mov    %rax,%rsi
  800f23:	48 bf 41 0e 80 00 00 	movabs $0x800e41,%rdi
  800f2a:	00 00 00 
  800f2d:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800f39:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f3f:	48 98                	cltq   
  800f41:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f48:	48 83 c2 08          	add    $0x8,%rdx
  800f4c:	48 89 c6             	mov    %rax,%rsi
  800f4f:	48 89 d7             	mov    %rdx,%rdi
  800f52:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  800f59:	00 00 00 
  800f5c:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800f5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f64:	c9                   	leaveq 
  800f65:	c3                   	retq   

0000000000800f66 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800f66:	55                   	push   %rbp
  800f67:	48 89 e5             	mov    %rsp,%rbp
  800f6a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f71:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f78:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f7f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f86:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f8d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f94:	84 c0                	test   %al,%al
  800f96:	74 20                	je     800fb8 <cprintf+0x52>
  800f98:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f9c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fa0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fa4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fac:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fb0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fb4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800fbf:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fc6:	00 00 00 
  800fc9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fd0:	00 00 00 
  800fd3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fde:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fec:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ff3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ffa:	48 8b 0a             	mov    (%rdx),%rcx
  800ffd:	48 89 08             	mov    %rcx,(%rax)
  801000:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801004:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801008:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80100c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801010:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801017:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80101e:	48 89 d6             	mov    %rdx,%rsi
  801021:	48 89 c7             	mov    %rax,%rdi
  801024:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  80102b:	00 00 00 
  80102e:	ff d0                	callq  *%rax
  801030:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801036:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80103c:	c9                   	leaveq 
  80103d:	c3                   	retq   

000000000080103e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	53                   	push   %rbx
  801043:	48 83 ec 38          	sub    $0x38,%rsp
  801047:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80104f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801053:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801056:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80105a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80105e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801061:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801065:	77 3b                	ja     8010a2 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801067:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80106a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80106e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801071:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801075:	ba 00 00 00 00       	mov    $0x0,%edx
  80107a:	48 f7 f3             	div    %rbx
  80107d:	48 89 c2             	mov    %rax,%rdx
  801080:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801083:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801086:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80108a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108e:	41 89 f9             	mov    %edi,%r9d
  801091:	48 89 c7             	mov    %rax,%rdi
  801094:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
  8010a0:	eb 1e                	jmp    8010c0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a2:	eb 12                	jmp    8010b6 <printnum+0x78>
			putch(padc, putdat);
  8010a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010a8:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 89 ce             	mov    %rcx,%rsi
  8010b2:	89 d7                	mov    %edx,%edi
  8010b4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b6:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010be:	7f e4                	jg     8010a4 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010c0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cc:	48 f7 f1             	div    %rcx
  8010cf:	48 89 d0             	mov    %rdx,%rax
  8010d2:	48 ba 68 47 80 00 00 	movabs $0x804768,%rdx
  8010d9:	00 00 00 
  8010dc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010e0:	0f be d0             	movsbl %al,%edx
  8010e3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 89 ce             	mov    %rcx,%rsi
  8010ee:	89 d7                	mov    %edx,%edi
  8010f0:	ff d0                	callq  *%rax
}
  8010f2:	48 83 c4 38          	add    $0x38,%rsp
  8010f6:	5b                   	pop    %rbx
  8010f7:	5d                   	pop    %rbp
  8010f8:	c3                   	retq   

00000000008010f9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 1c          	sub    $0x1c,%rsp
  801101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801105:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801108:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80110c:	7e 52                	jle    801160 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	8b 00                	mov    (%rax),%eax
  801114:	83 f8 30             	cmp    $0x30,%eax
  801117:	73 24                	jae    80113d <getuint+0x44>
  801119:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801125:	8b 00                	mov    (%rax),%eax
  801127:	89 c0                	mov    %eax,%eax
  801129:	48 01 d0             	add    %rdx,%rax
  80112c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801130:	8b 12                	mov    (%rdx),%edx
  801132:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801135:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801139:	89 0a                	mov    %ecx,(%rdx)
  80113b:	eb 17                	jmp    801154 <getuint+0x5b>
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801145:	48 89 d0             	mov    %rdx,%rax
  801148:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80114c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801150:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801154:	48 8b 00             	mov    (%rax),%rax
  801157:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80115b:	e9 a3 00 00 00       	jmpq   801203 <getuint+0x10a>
	else if (lflag)
  801160:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801164:	74 4f                	je     8011b5 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116a:	8b 00                	mov    (%rax),%eax
  80116c:	83 f8 30             	cmp    $0x30,%eax
  80116f:	73 24                	jae    801195 <getuint+0x9c>
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117d:	8b 00                	mov    (%rax),%eax
  80117f:	89 c0                	mov    %eax,%eax
  801181:	48 01 d0             	add    %rdx,%rax
  801184:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801188:	8b 12                	mov    (%rdx),%edx
  80118a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80118d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801191:	89 0a                	mov    %ecx,(%rdx)
  801193:	eb 17                	jmp    8011ac <getuint+0xb3>
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80119d:	48 89 d0             	mov    %rdx,%rax
  8011a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ac:	48 8b 00             	mov    (%rax),%rax
  8011af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011b3:	eb 4e                	jmp    801203 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	8b 00                	mov    (%rax),%eax
  8011bb:	83 f8 30             	cmp    $0x30,%eax
  8011be:	73 24                	jae    8011e4 <getuint+0xeb>
  8011c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cc:	8b 00                	mov    (%rax),%eax
  8011ce:	89 c0                	mov    %eax,%eax
  8011d0:	48 01 d0             	add    %rdx,%rax
  8011d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d7:	8b 12                	mov    (%rdx),%edx
  8011d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e0:	89 0a                	mov    %ecx,(%rdx)
  8011e2:	eb 17                	jmp    8011fb <getuint+0x102>
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011ec:	48 89 d0             	mov    %rdx,%rax
  8011ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011fb:	8b 00                	mov    (%rax),%eax
  8011fd:	89 c0                	mov    %eax,%eax
  8011ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 1c          	sub    $0x1c,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801218:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80121c:	7e 52                	jle    801270 <getint+0x67>
		x=va_arg(*ap, long long);
  80121e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801222:	8b 00                	mov    (%rax),%eax
  801224:	83 f8 30             	cmp    $0x30,%eax
  801227:	73 24                	jae    80124d <getint+0x44>
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	8b 00                	mov    (%rax),%eax
  801237:	89 c0                	mov    %eax,%eax
  801239:	48 01 d0             	add    %rdx,%rax
  80123c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801240:	8b 12                	mov    (%rdx),%edx
  801242:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801245:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801249:	89 0a                	mov    %ecx,(%rdx)
  80124b:	eb 17                	jmp    801264 <getint+0x5b>
  80124d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801251:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801255:	48 89 d0             	mov    %rdx,%rax
  801258:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80125c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801260:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801264:	48 8b 00             	mov    (%rax),%rax
  801267:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80126b:	e9 a3 00 00 00       	jmpq   801313 <getint+0x10a>
	else if (lflag)
  801270:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801274:	74 4f                	je     8012c5 <getint+0xbc>
		x=va_arg(*ap, long);
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127a:	8b 00                	mov    (%rax),%eax
  80127c:	83 f8 30             	cmp    $0x30,%eax
  80127f:	73 24                	jae    8012a5 <getint+0x9c>
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128d:	8b 00                	mov    (%rax),%eax
  80128f:	89 c0                	mov    %eax,%eax
  801291:	48 01 d0             	add    %rdx,%rax
  801294:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801298:	8b 12                	mov    (%rdx),%edx
  80129a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80129d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012a1:	89 0a                	mov    %ecx,(%rdx)
  8012a3:	eb 17                	jmp    8012bc <getint+0xb3>
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ad:	48 89 d0             	mov    %rdx,%rax
  8012b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012bc:	48 8b 00             	mov    (%rax),%rax
  8012bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012c3:	eb 4e                	jmp    801313 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c9:	8b 00                	mov    (%rax),%eax
  8012cb:	83 f8 30             	cmp    $0x30,%eax
  8012ce:	73 24                	jae    8012f4 <getint+0xeb>
  8012d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012dc:	8b 00                	mov    (%rax),%eax
  8012de:	89 c0                	mov    %eax,%eax
  8012e0:	48 01 d0             	add    %rdx,%rax
  8012e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e7:	8b 12                	mov    (%rdx),%edx
  8012e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f0:	89 0a                	mov    %ecx,(%rdx)
  8012f2:	eb 17                	jmp    80130b <getint+0x102>
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012fc:	48 89 d0             	mov    %rdx,%rax
  8012ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801303:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801307:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80130b:	8b 00                	mov    (%rax),%eax
  80130d:	48 98                	cltq   
  80130f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	41 54                	push   %r12
  80131f:	53                   	push   %rbx
  801320:	48 83 ec 60          	sub    $0x60,%rsp
  801324:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801328:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80132c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801330:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801334:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801338:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80133c:	48 8b 0a             	mov    (%rdx),%rcx
  80133f:	48 89 08             	mov    %rcx,(%rax)
  801342:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801346:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80134a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80134e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  801352:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801356:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80135a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  801364:	eb 29                	jmp    80138f <vprintfmt+0x76>
			if (ch == '\0')
  801366:	85 db                	test   %ebx,%ebx
  801368:	0f 84 ad 06 00 00    	je     801a1b <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80136e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801372:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801376:	48 89 d6             	mov    %rdx,%rsi
  801379:	89 df                	mov    %ebx,%edi
  80137b:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80137d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801381:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801385:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80138f:	83 fb 25             	cmp    $0x25,%ebx
  801392:	74 05                	je     801399 <vprintfmt+0x80>
  801394:	83 fb 1b             	cmp    $0x1b,%ebx
  801397:	75 cd                	jne    801366 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  801399:	83 fb 1b             	cmp    $0x1b,%ebx
  80139c:	0f 85 ae 01 00 00    	jne    801550 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8013a2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013a9:	00 00 00 
  8013ac:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8013b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013ba:	48 89 d6             	mov    %rdx,%rsi
  8013bd:	89 df                	mov    %ebx,%edi
  8013bf:	ff d0                	callq  *%rax
			putch('[', putdat);
  8013c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013c9:	48 89 d6             	mov    %rdx,%rsi
  8013cc:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8013d1:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8013d3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8013d9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8013de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8013e8:	eb 32                	jmp    80141c <vprintfmt+0x103>
					putch(ch, putdat);
  8013ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013f2:	48 89 d6             	mov    %rdx,%rsi
  8013f5:	89 df                	mov    %ebx,%edi
  8013f7:	ff d0                	callq  *%rax
					esc_color *= 10;
  8013f9:	44 89 e0             	mov    %r12d,%eax
  8013fc:	c1 e0 02             	shl    $0x2,%eax
  8013ff:	44 01 e0             	add    %r12d,%eax
  801402:	01 c0                	add    %eax,%eax
  801404:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  801407:	8d 43 d0             	lea    -0x30(%rbx),%eax
  80140a:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80140d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801412:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801416:	0f b6 00             	movzbl (%rax),%eax
  801419:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80141c:	83 fb 3b             	cmp    $0x3b,%ebx
  80141f:	74 05                	je     801426 <vprintfmt+0x10d>
  801421:	83 fb 6d             	cmp    $0x6d,%ebx
  801424:	75 c4                	jne    8013ea <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  801426:	45 85 e4             	test   %r12d,%r12d
  801429:	75 15                	jne    801440 <vprintfmt+0x127>
					color_flag = 0x07;
  80142b:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801432:	00 00 00 
  801435:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80143b:	e9 dc 00 00 00       	jmpq   80151c <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  801440:	41 83 fc 1d          	cmp    $0x1d,%r12d
  801444:	7e 69                	jle    8014af <vprintfmt+0x196>
  801446:	41 83 fc 25          	cmp    $0x25,%r12d
  80144a:	7f 63                	jg     8014af <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  80144c:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801453:	00 00 00 
  801456:	8b 00                	mov    (%rax),%eax
  801458:	25 f8 00 00 00       	and    $0xf8,%eax
  80145d:	89 c2                	mov    %eax,%edx
  80145f:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801466:	00 00 00 
  801469:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  80146b:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80146f:	44 89 e0             	mov    %r12d,%eax
  801472:	83 e0 04             	and    $0x4,%eax
  801475:	c1 f8 02             	sar    $0x2,%eax
  801478:	89 c2                	mov    %eax,%edx
  80147a:	44 89 e0             	mov    %r12d,%eax
  80147d:	83 e0 02             	and    $0x2,%eax
  801480:	09 c2                	or     %eax,%edx
  801482:	44 89 e0             	mov    %r12d,%eax
  801485:	83 e0 01             	and    $0x1,%eax
  801488:	c1 e0 02             	shl    $0x2,%eax
  80148b:	09 c2                	or     %eax,%edx
  80148d:	41 89 d4             	mov    %edx,%r12d
  801490:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801497:	00 00 00 
  80149a:	8b 00                	mov    (%rax),%eax
  80149c:	44 89 e2             	mov    %r12d,%edx
  80149f:	09 c2                	or     %eax,%edx
  8014a1:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8014a8:	00 00 00 
  8014ab:	89 10                	mov    %edx,(%rax)
  8014ad:	eb 6d                	jmp    80151c <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8014af:	41 83 fc 27          	cmp    $0x27,%r12d
  8014b3:	7e 67                	jle    80151c <vprintfmt+0x203>
  8014b5:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8014b9:	7f 61                	jg     80151c <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8014bb:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8014c2:	00 00 00 
  8014c5:	8b 00                	mov    (%rax),%eax
  8014c7:	25 8f 00 00 00       	and    $0x8f,%eax
  8014cc:	89 c2                	mov    %eax,%edx
  8014ce:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8014d5:	00 00 00 
  8014d8:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8014da:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8014de:	44 89 e0             	mov    %r12d,%eax
  8014e1:	83 e0 04             	and    $0x4,%eax
  8014e4:	c1 f8 02             	sar    $0x2,%eax
  8014e7:	89 c2                	mov    %eax,%edx
  8014e9:	44 89 e0             	mov    %r12d,%eax
  8014ec:	83 e0 02             	and    $0x2,%eax
  8014ef:	09 c2                	or     %eax,%edx
  8014f1:	44 89 e0             	mov    %r12d,%eax
  8014f4:	83 e0 01             	and    $0x1,%eax
  8014f7:	c1 e0 06             	shl    $0x6,%eax
  8014fa:	09 c2                	or     %eax,%edx
  8014fc:	41 89 d4             	mov    %edx,%r12d
  8014ff:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801506:	00 00 00 
  801509:	8b 00                	mov    (%rax),%eax
  80150b:	44 89 e2             	mov    %r12d,%edx
  80150e:	09 c2                	or     %eax,%edx
  801510:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801517:	00 00 00 
  80151a:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  80151c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801520:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801524:	48 89 d6             	mov    %rdx,%rsi
  801527:	89 df                	mov    %ebx,%edi
  801529:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  80152b:	83 fb 6d             	cmp    $0x6d,%ebx
  80152e:	75 1b                	jne    80154b <vprintfmt+0x232>
					fmt ++;
  801530:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  801535:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  801536:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80153d:	00 00 00 
  801540:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  801546:	e9 cb 04 00 00       	jmpq   801a16 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  80154b:	e9 83 fe ff ff       	jmpq   8013d3 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  801550:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801554:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80155b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801562:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801569:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801570:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801574:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801578:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	0f b6 d8             	movzbl %al,%ebx
  801582:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801585:	83 f8 55             	cmp    $0x55,%eax
  801588:	0f 87 5a 04 00 00    	ja     8019e8 <vprintfmt+0x6cf>
  80158e:	89 c0                	mov    %eax,%eax
  801590:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801597:	00 
  801598:	48 b8 90 47 80 00 00 	movabs $0x804790,%rax
  80159f:	00 00 00 
  8015a2:	48 01 d0             	add    %rdx,%rax
  8015a5:	48 8b 00             	mov    (%rax),%rax
  8015a8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8015aa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8015ae:	eb c0                	jmp    801570 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8015b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8015b4:	eb ba                	jmp    801570 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015b6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8015bd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8015c0:	89 d0                	mov    %edx,%eax
  8015c2:	c1 e0 02             	shl    $0x2,%eax
  8015c5:	01 d0                	add    %edx,%eax
  8015c7:	01 c0                	add    %eax,%eax
  8015c9:	01 d8                	add    %ebx,%eax
  8015cb:	83 e8 30             	sub    $0x30,%eax
  8015ce:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8015d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8015db:	83 fb 2f             	cmp    $0x2f,%ebx
  8015de:	7e 0c                	jle    8015ec <vprintfmt+0x2d3>
  8015e0:	83 fb 39             	cmp    $0x39,%ebx
  8015e3:	7f 07                	jg     8015ec <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015e5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8015ea:	eb d1                	jmp    8015bd <vprintfmt+0x2a4>
			goto process_precision;
  8015ec:	eb 58                	jmp    801646 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8015ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015f1:	83 f8 30             	cmp    $0x30,%eax
  8015f4:	73 17                	jae    80160d <vprintfmt+0x2f4>
  8015f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015fd:	89 c0                	mov    %eax,%eax
  8015ff:	48 01 d0             	add    %rdx,%rax
  801602:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801605:	83 c2 08             	add    $0x8,%edx
  801608:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80160b:	eb 0f                	jmp    80161c <vprintfmt+0x303>
  80160d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801611:	48 89 d0             	mov    %rdx,%rax
  801614:	48 83 c2 08          	add    $0x8,%rdx
  801618:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80161c:	8b 00                	mov    (%rax),%eax
  80161e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801621:	eb 23                	jmp    801646 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  801623:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801627:	79 0c                	jns    801635 <vprintfmt+0x31c>
				width = 0;
  801629:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801630:	e9 3b ff ff ff       	jmpq   801570 <vprintfmt+0x257>
  801635:	e9 36 ff ff ff       	jmpq   801570 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  80163a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801641:	e9 2a ff ff ff       	jmpq   801570 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  801646:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80164a:	79 12                	jns    80165e <vprintfmt+0x345>
				width = precision, precision = -1;
  80164c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80164f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801652:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801659:	e9 12 ff ff ff       	jmpq   801570 <vprintfmt+0x257>
  80165e:	e9 0d ff ff ff       	jmpq   801570 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801663:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801667:	e9 04 ff ff ff       	jmpq   801570 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80166c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80166f:	83 f8 30             	cmp    $0x30,%eax
  801672:	73 17                	jae    80168b <vprintfmt+0x372>
  801674:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801678:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80167b:	89 c0                	mov    %eax,%eax
  80167d:	48 01 d0             	add    %rdx,%rax
  801680:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801683:	83 c2 08             	add    $0x8,%edx
  801686:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801689:	eb 0f                	jmp    80169a <vprintfmt+0x381>
  80168b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80168f:	48 89 d0             	mov    %rdx,%rax
  801692:	48 83 c2 08          	add    $0x8,%rdx
  801696:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80169a:	8b 10                	mov    (%rax),%edx
  80169c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8016a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016a4:	48 89 ce             	mov    %rcx,%rsi
  8016a7:	89 d7                	mov    %edx,%edi
  8016a9:	ff d0                	callq  *%rax
			break;
  8016ab:	e9 66 03 00 00       	jmpq   801a16 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8016b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016b3:	83 f8 30             	cmp    $0x30,%eax
  8016b6:	73 17                	jae    8016cf <vprintfmt+0x3b6>
  8016b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8016bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016bf:	89 c0                	mov    %eax,%eax
  8016c1:	48 01 d0             	add    %rdx,%rax
  8016c4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8016c7:	83 c2 08             	add    $0x8,%edx
  8016ca:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8016cd:	eb 0f                	jmp    8016de <vprintfmt+0x3c5>
  8016cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8016d3:	48 89 d0             	mov    %rdx,%rax
  8016d6:	48 83 c2 08          	add    $0x8,%rdx
  8016da:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8016de:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8016e0:	85 db                	test   %ebx,%ebx
  8016e2:	79 02                	jns    8016e6 <vprintfmt+0x3cd>
				err = -err;
  8016e4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8016e6:	83 fb 10             	cmp    $0x10,%ebx
  8016e9:	7f 16                	jg     801701 <vprintfmt+0x3e8>
  8016eb:	48 b8 e0 46 80 00 00 	movabs $0x8046e0,%rax
  8016f2:	00 00 00 
  8016f5:	48 63 d3             	movslq %ebx,%rdx
  8016f8:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8016fc:	4d 85 e4             	test   %r12,%r12
  8016ff:	75 2e                	jne    80172f <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  801701:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801705:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801709:	89 d9                	mov    %ebx,%ecx
  80170b:	48 ba 79 47 80 00 00 	movabs $0x804779,%rdx
  801712:	00 00 00 
  801715:	48 89 c7             	mov    %rax,%rdi
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
  80171d:	49 b8 24 1a 80 00 00 	movabs $0x801a24,%r8
  801724:	00 00 00 
  801727:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80172a:	e9 e7 02 00 00       	jmpq   801a16 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80172f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801733:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801737:	4c 89 e1             	mov    %r12,%rcx
  80173a:	48 ba 82 47 80 00 00 	movabs $0x804782,%rdx
  801741:	00 00 00 
  801744:	48 89 c7             	mov    %rax,%rdi
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	49 b8 24 1a 80 00 00 	movabs $0x801a24,%r8
  801753:	00 00 00 
  801756:	41 ff d0             	callq  *%r8
			break;
  801759:	e9 b8 02 00 00       	jmpq   801a16 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80175e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801761:	83 f8 30             	cmp    $0x30,%eax
  801764:	73 17                	jae    80177d <vprintfmt+0x464>
  801766:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80176a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80176d:	89 c0                	mov    %eax,%eax
  80176f:	48 01 d0             	add    %rdx,%rax
  801772:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801775:	83 c2 08             	add    $0x8,%edx
  801778:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80177b:	eb 0f                	jmp    80178c <vprintfmt+0x473>
  80177d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801781:	48 89 d0             	mov    %rdx,%rax
  801784:	48 83 c2 08          	add    $0x8,%rdx
  801788:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80178c:	4c 8b 20             	mov    (%rax),%r12
  80178f:	4d 85 e4             	test   %r12,%r12
  801792:	75 0a                	jne    80179e <vprintfmt+0x485>
				p = "(null)";
  801794:	49 bc 85 47 80 00 00 	movabs $0x804785,%r12
  80179b:	00 00 00 
			if (width > 0 && padc != '-')
  80179e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8017a2:	7e 3f                	jle    8017e3 <vprintfmt+0x4ca>
  8017a4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8017a8:	74 39                	je     8017e3 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017aa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8017ad:	48 98                	cltq   
  8017af:	48 89 c6             	mov    %rax,%rsi
  8017b2:	4c 89 e7             	mov    %r12,%rdi
  8017b5:	48 b8 d0 1c 80 00 00 	movabs $0x801cd0,%rax
  8017bc:	00 00 00 
  8017bf:	ff d0                	callq  *%rax
  8017c1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8017c4:	eb 17                	jmp    8017dd <vprintfmt+0x4c4>
					putch(padc, putdat);
  8017c6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8017ca:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8017ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017d2:	48 89 ce             	mov    %rcx,%rsi
  8017d5:	89 d7                	mov    %edx,%edi
  8017d7:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017d9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8017dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8017e1:	7f e3                	jg     8017c6 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017e3:	eb 37                	jmp    80181c <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8017e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8017e9:	74 1e                	je     801809 <vprintfmt+0x4f0>
  8017eb:	83 fb 1f             	cmp    $0x1f,%ebx
  8017ee:	7e 05                	jle    8017f5 <vprintfmt+0x4dc>
  8017f0:	83 fb 7e             	cmp    $0x7e,%ebx
  8017f3:	7e 14                	jle    801809 <vprintfmt+0x4f0>
					putch('?', putdat);
  8017f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017fd:	48 89 d6             	mov    %rdx,%rsi
  801800:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801805:	ff d0                	callq  *%rax
  801807:	eb 0f                	jmp    801818 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  801809:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80180d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801811:	48 89 d6             	mov    %rdx,%rsi
  801814:	89 df                	mov    %ebx,%edi
  801816:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801818:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80181c:	4c 89 e0             	mov    %r12,%rax
  80181f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	0f be d8             	movsbl %al,%ebx
  801829:	85 db                	test   %ebx,%ebx
  80182b:	74 10                	je     80183d <vprintfmt+0x524>
  80182d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801831:	78 b2                	js     8017e5 <vprintfmt+0x4cc>
  801833:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801837:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183b:	79 a8                	jns    8017e5 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80183d:	eb 16                	jmp    801855 <vprintfmt+0x53c>
				putch(' ', putdat);
  80183f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801843:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801847:	48 89 d6             	mov    %rdx,%rsi
  80184a:	bf 20 00 00 00       	mov    $0x20,%edi
  80184f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801851:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801855:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801859:	7f e4                	jg     80183f <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  80185b:	e9 b6 01 00 00       	jmpq   801a16 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801860:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801864:	be 03 00 00 00       	mov    $0x3,%esi
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
  801878:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80187c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801880:	48 85 c0             	test   %rax,%rax
  801883:	79 1d                	jns    8018a2 <vprintfmt+0x589>
				putch('-', putdat);
  801885:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801889:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80188d:	48 89 d6             	mov    %rdx,%rsi
  801890:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801895:	ff d0                	callq  *%rax
				num = -(long long) num;
  801897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189b:	48 f7 d8             	neg    %rax
  80189e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8018a2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8018a9:	e9 fb 00 00 00       	jmpq   8019a9 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8018ae:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8018b2:	be 03 00 00 00       	mov    $0x3,%esi
  8018b7:	48 89 c7             	mov    %rax,%rdi
  8018ba:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
  8018c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8018ca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8018d1:	e9 d3 00 00 00       	jmpq   8019a9 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  8018d6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8018da:	be 03 00 00 00       	mov    $0x3,%esi
  8018df:	48 89 c7             	mov    %rax,%rdi
  8018e2:	48 b8 09 12 80 00 00 	movabs $0x801209,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
  8018ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8018f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f6:	48 85 c0             	test   %rax,%rax
  8018f9:	79 1d                	jns    801918 <vprintfmt+0x5ff>
				putch('-', putdat);
  8018fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8018ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801903:	48 89 d6             	mov    %rdx,%rsi
  801906:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80190b:	ff d0                	callq  *%rax
				num = -(long long) num;
  80190d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801911:	48 f7 d8             	neg    %rax
  801914:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  801918:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80191f:	e9 85 00 00 00       	jmpq   8019a9 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801924:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801928:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80192c:	48 89 d6             	mov    %rdx,%rsi
  80192f:	bf 30 00 00 00       	mov    $0x30,%edi
  801934:	ff d0                	callq  *%rax
			putch('x', putdat);
  801936:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80193a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80193e:	48 89 d6             	mov    %rdx,%rsi
  801941:	bf 78 00 00 00       	mov    $0x78,%edi
  801946:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801948:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80194b:	83 f8 30             	cmp    $0x30,%eax
  80194e:	73 17                	jae    801967 <vprintfmt+0x64e>
  801950:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801954:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801957:	89 c0                	mov    %eax,%eax
  801959:	48 01 d0             	add    %rdx,%rax
  80195c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80195f:	83 c2 08             	add    $0x8,%edx
  801962:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801965:	eb 0f                	jmp    801976 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801967:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80196b:	48 89 d0             	mov    %rdx,%rax
  80196e:	48 83 c2 08          	add    $0x8,%rdx
  801972:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801976:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801979:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80197d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801984:	eb 23                	jmp    8019a9 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801986:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80198a:	be 03 00 00 00       	mov    $0x3,%esi
  80198f:	48 89 c7             	mov    %rax,%rdi
  801992:	48 b8 f9 10 80 00 00 	movabs $0x8010f9,%rax
  801999:	00 00 00 
  80199c:	ff d0                	callq  *%rax
  80199e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8019a2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019a9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8019ae:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8019b1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8019b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019b8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8019bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019c0:	45 89 c1             	mov    %r8d,%r9d
  8019c3:	41 89 f8             	mov    %edi,%r8d
  8019c6:	48 89 c7             	mov    %rax,%rdi
  8019c9:	48 b8 3e 10 80 00 00 	movabs $0x80103e,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
			break;
  8019d5:	eb 3f                	jmp    801a16 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8019d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8019db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019df:	48 89 d6             	mov    %rdx,%rsi
  8019e2:	89 df                	mov    %ebx,%edi
  8019e4:	ff d0                	callq  *%rax
			break;
  8019e6:	eb 2e                	jmp    801a16 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8019e8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8019ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019f0:	48 89 d6             	mov    %rdx,%rsi
  8019f3:	bf 25 00 00 00       	mov    $0x25,%edi
  8019f8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8019fa:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8019ff:	eb 05                	jmp    801a06 <vprintfmt+0x6ed>
  801a01:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801a06:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801a0a:	48 83 e8 01          	sub    $0x1,%rax
  801a0e:	0f b6 00             	movzbl (%rax),%eax
  801a11:	3c 25                	cmp    $0x25,%al
  801a13:	75 ec                	jne    801a01 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801a15:	90                   	nop
		}
	}
  801a16:	e9 37 f9 ff ff       	jmpq   801352 <vprintfmt+0x39>
    va_end(aq);
}
  801a1b:	48 83 c4 60          	add    $0x60,%rsp
  801a1f:	5b                   	pop    %rbx
  801a20:	41 5c                	pop    %r12
  801a22:	5d                   	pop    %rbp
  801a23:	c3                   	retq   

0000000000801a24 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a24:	55                   	push   %rbp
  801a25:	48 89 e5             	mov    %rsp,%rbp
  801a28:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801a2f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801a36:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801a3d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801a44:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801a4b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801a52:	84 c0                	test   %al,%al
  801a54:	74 20                	je     801a76 <printfmt+0x52>
  801a56:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801a5a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a5e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a62:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a66:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a6a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a6e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a72:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a76:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801a7d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801a84:	00 00 00 
  801a87:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801a8e:	00 00 00 
  801a91:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a95:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801a9c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801aa3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801aaa:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801ab1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ab8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801abf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801ac6:	48 89 c7             	mov    %rax,%rdi
  801ac9:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	callq  *%rax
	va_end(ap);
}
  801ad5:	c9                   	leaveq 
  801ad6:	c3                   	retq   

0000000000801ad7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	48 83 ec 10          	sub    $0x10,%rsp
  801adf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801ae6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aea:	8b 40 10             	mov    0x10(%rax),%eax
  801aed:	8d 50 01             	lea    0x1(%rax),%edx
  801af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afb:	48 8b 10             	mov    (%rax),%rdx
  801afe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b02:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b06:	48 39 c2             	cmp    %rax,%rdx
  801b09:	73 17                	jae    801b22 <sprintputch+0x4b>
		*b->buf++ = ch;
  801b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0f:	48 8b 00             	mov    (%rax),%rax
  801b12:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801b16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1a:	48 89 0a             	mov    %rcx,(%rdx)
  801b1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b20:	88 10                	mov    %dl,(%rax)
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 50          	sub    $0x50,%rsp
  801b2c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801b30:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801b33:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801b37:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801b3b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801b3f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801b43:	48 8b 0a             	mov    (%rdx),%rcx
  801b46:	48 89 08             	mov    %rcx,(%rax)
  801b49:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801b4d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801b51:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801b55:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b59:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b5d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801b61:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801b64:	48 98                	cltq   
  801b66:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b6e:	48 01 d0             	add    %rdx,%rax
  801b71:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801b75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801b7c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801b81:	74 06                	je     801b89 <vsnprintf+0x65>
  801b83:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801b87:	7f 07                	jg     801b90 <vsnprintf+0x6c>
		return -E_INVAL;
  801b89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b8e:	eb 2f                	jmp    801bbf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801b90:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801b94:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b98:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801b9c:	48 89 c6             	mov    %rax,%rsi
  801b9f:	48 bf d7 1a 80 00 00 	movabs $0x801ad7,%rdi
  801ba6:	00 00 00 
  801ba9:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801bb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bb9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801bbc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801bbf:	c9                   	leaveq 
  801bc0:	c3                   	retq   

0000000000801bc1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801bcc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801bd3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801bd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801be0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801be7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801bee:	84 c0                	test   %al,%al
  801bf0:	74 20                	je     801c12 <snprintf+0x51>
  801bf2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801bf6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801bfa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801bfe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801c02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801c06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801c0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801c0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801c12:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801c19:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801c20:	00 00 00 
  801c23:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801c2a:	00 00 00 
  801c2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c31:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801c38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801c3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801c46:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801c4d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801c54:	48 8b 0a             	mov    (%rdx),%rcx
  801c57:	48 89 08             	mov    %rcx,(%rax)
  801c5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801c5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801c62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801c66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801c6a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801c71:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801c78:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801c7e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801c85:	48 89 c7             	mov    %rax,%rdi
  801c88:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  801c8f:	00 00 00 
  801c92:	ff d0                	callq  *%rax
  801c94:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801c9a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	48 83 ec 18          	sub    $0x18,%rsp
  801caa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801cae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cb5:	eb 09                	jmp    801cc0 <strlen+0x1e>
		n++;
  801cb7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801cbb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc4:	0f b6 00             	movzbl (%rax),%eax
  801cc7:	84 c0                	test   %al,%al
  801cc9:	75 ec                	jne    801cb7 <strlen+0x15>
		n++;
	return n;
  801ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 20          	sub    $0x20,%rsp
  801cd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cdc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce7:	eb 0e                	jmp    801cf7 <strnlen+0x27>
		n++;
  801ce9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ced:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801cf2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801cf7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801cfc:	74 0b                	je     801d09 <strnlen+0x39>
  801cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d02:	0f b6 00             	movzbl (%rax),%eax
  801d05:	84 c0                	test   %al,%al
  801d07:	75 e0                	jne    801ce9 <strnlen+0x19>
		n++;
	return n;
  801d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d0c:	c9                   	leaveq 
  801d0d:	c3                   	retq   

0000000000801d0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d0e:	55                   	push   %rbp
  801d0f:	48 89 e5             	mov    %rsp,%rbp
  801d12:	48 83 ec 20          	sub    $0x20,%rsp
  801d16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801d1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801d26:	90                   	nop
  801d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801d37:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801d3b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801d3f:	0f b6 12             	movzbl (%rdx),%edx
  801d42:	88 10                	mov    %dl,(%rax)
  801d44:	0f b6 00             	movzbl (%rax),%eax
  801d47:	84 c0                	test   %al,%al
  801d49:	75 dc                	jne    801d27 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 20          	sub    $0x20,%rsp
  801d59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d65:	48 89 c7             	mov    %rax,%rdi
  801d68:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	callq  *%rax
  801d74:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7a:	48 63 d0             	movslq %eax,%rdx
  801d7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d81:	48 01 c2             	add    %rax,%rdx
  801d84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d88:	48 89 c6             	mov    %rax,%rsi
  801d8b:	48 89 d7             	mov    %rdx,%rdi
  801d8e:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
	return dst;
  801d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d9e:	c9                   	leaveq 
  801d9f:	c3                   	retq   

0000000000801da0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801da0:	55                   	push   %rbp
  801da1:	48 89 e5             	mov    %rsp,%rbp
  801da4:	48 83 ec 28          	sub    $0x28,%rsp
  801da8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801db0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801db4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801dbc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801dc3:	00 
  801dc4:	eb 2a                	jmp    801df0 <strncpy+0x50>
		*dst++ = *src;
  801dc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801dce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801dd2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801dd6:	0f b6 12             	movzbl (%rdx),%edx
  801dd9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801ddb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ddf:	0f b6 00             	movzbl (%rax),%eax
  801de2:	84 c0                	test   %al,%al
  801de4:	74 05                	je     801deb <strncpy+0x4b>
			src++;
  801de6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801deb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801df8:	72 cc                	jb     801dc6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801dfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801dfe:	c9                   	leaveq 
  801dff:	c3                   	retq   

0000000000801e00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801e00:	55                   	push   %rbp
  801e01:	48 89 e5             	mov    %rsp,%rbp
  801e04:	48 83 ec 28          	sub    $0x28,%rsp
  801e08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801e14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801e1c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801e21:	74 3d                	je     801e60 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801e23:	eb 1d                	jmp    801e42 <strlcpy+0x42>
			*dst++ = *src++;
  801e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e29:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e35:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801e39:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801e3d:	0f b6 12             	movzbl (%rdx),%edx
  801e40:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e42:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801e47:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801e4c:	74 0b                	je     801e59 <strlcpy+0x59>
  801e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e52:	0f b6 00             	movzbl (%rax),%eax
  801e55:	84 c0                	test   %al,%al
  801e57:	75 cc                	jne    801e25 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801e60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e68:	48 29 c2             	sub    %rax,%rdx
  801e6b:	48 89 d0             	mov    %rdx,%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 10          	sub    $0x10,%rsp
  801e78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801e80:	eb 0a                	jmp    801e8c <strcmp+0x1c>
		p++, q++;
  801e82:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801e87:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e90:	0f b6 00             	movzbl (%rax),%eax
  801e93:	84 c0                	test   %al,%al
  801e95:	74 12                	je     801ea9 <strcmp+0x39>
  801e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9b:	0f b6 10             	movzbl (%rax),%edx
  801e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea2:	0f b6 00             	movzbl (%rax),%eax
  801ea5:	38 c2                	cmp    %al,%dl
  801ea7:	74 d9                	je     801e82 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ead:	0f b6 00             	movzbl (%rax),%eax
  801eb0:	0f b6 d0             	movzbl %al,%edx
  801eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb7:	0f b6 00             	movzbl (%rax),%eax
  801eba:	0f b6 c0             	movzbl %al,%eax
  801ebd:	29 c2                	sub    %eax,%edx
  801ebf:	89 d0                	mov    %edx,%eax
}
  801ec1:	c9                   	leaveq 
  801ec2:	c3                   	retq   

0000000000801ec3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ec3:	55                   	push   %rbp
  801ec4:	48 89 e5             	mov    %rsp,%rbp
  801ec7:	48 83 ec 18          	sub    $0x18,%rsp
  801ecb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ecf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ed3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ed7:	eb 0f                	jmp    801ee8 <strncmp+0x25>
		n--, p++, q++;
  801ed9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ede:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801ee3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ee8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801eed:	74 1d                	je     801f0c <strncmp+0x49>
  801eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef3:	0f b6 00             	movzbl (%rax),%eax
  801ef6:	84 c0                	test   %al,%al
  801ef8:	74 12                	je     801f0c <strncmp+0x49>
  801efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efe:	0f b6 10             	movzbl (%rax),%edx
  801f01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f05:	0f b6 00             	movzbl (%rax),%eax
  801f08:	38 c2                	cmp    %al,%dl
  801f0a:	74 cd                	je     801ed9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801f0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f11:	75 07                	jne    801f1a <strncmp+0x57>
		return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 18                	jmp    801f32 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1e:	0f b6 00             	movzbl (%rax),%eax
  801f21:	0f b6 d0             	movzbl %al,%edx
  801f24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f28:	0f b6 00             	movzbl (%rax),%eax
  801f2b:	0f b6 c0             	movzbl %al,%eax
  801f2e:	29 c2                	sub    %eax,%edx
  801f30:	89 d0                	mov    %edx,%eax
}
  801f32:	c9                   	leaveq 
  801f33:	c3                   	retq   

0000000000801f34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801f34:	55                   	push   %rbp
  801f35:	48 89 e5             	mov    %rsp,%rbp
  801f38:	48 83 ec 0c          	sub    $0xc,%rsp
  801f3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801f45:	eb 17                	jmp    801f5e <strchr+0x2a>
		if (*s == c)
  801f47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4b:	0f b6 00             	movzbl (%rax),%eax
  801f4e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801f51:	75 06                	jne    801f59 <strchr+0x25>
			return (char *) s;
  801f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f57:	eb 15                	jmp    801f6e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f59:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f62:	0f b6 00             	movzbl (%rax),%eax
  801f65:	84 c0                	test   %al,%al
  801f67:	75 de                	jne    801f47 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6e:	c9                   	leaveq 
  801f6f:	c3                   	retq   

0000000000801f70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f70:	55                   	push   %rbp
  801f71:	48 89 e5             	mov    %rsp,%rbp
  801f74:	48 83 ec 0c          	sub    $0xc,%rsp
  801f78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f7c:	89 f0                	mov    %esi,%eax
  801f7e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801f81:	eb 13                	jmp    801f96 <strfind+0x26>
		if (*s == c)
  801f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f87:	0f b6 00             	movzbl (%rax),%eax
  801f8a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801f8d:	75 02                	jne    801f91 <strfind+0x21>
			break;
  801f8f:	eb 10                	jmp    801fa1 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f91:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9a:	0f b6 00             	movzbl (%rax),%eax
  801f9d:	84 c0                	test   %al,%al
  801f9f:	75 e2                	jne    801f83 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 18          	sub    $0x18,%rsp
  801faf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fb3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801fb6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801fba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fbf:	75 06                	jne    801fc7 <memset+0x20>
		return v;
  801fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc5:	eb 69                	jmp    802030 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fcb:	83 e0 03             	and    $0x3,%eax
  801fce:	48 85 c0             	test   %rax,%rax
  801fd1:	75 48                	jne    80201b <memset+0x74>
  801fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd7:	83 e0 03             	and    $0x3,%eax
  801fda:	48 85 c0             	test   %rax,%rax
  801fdd:	75 3c                	jne    80201b <memset+0x74>
		c &= 0xFF;
  801fdf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801fe6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fe9:	c1 e0 18             	shl    $0x18,%eax
  801fec:	89 c2                	mov    %eax,%edx
  801fee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ff1:	c1 e0 10             	shl    $0x10,%eax
  801ff4:	09 c2                	or     %eax,%edx
  801ff6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ff9:	c1 e0 08             	shl    $0x8,%eax
  801ffc:	09 d0                	or     %edx,%eax
  801ffe:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802005:	48 c1 e8 02          	shr    $0x2,%rax
  802009:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80200c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802010:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802013:	48 89 d7             	mov    %rdx,%rdi
  802016:	fc                   	cld    
  802017:	f3 ab                	rep stos %eax,%es:(%rdi)
  802019:	eb 11                	jmp    80202c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80201b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80201f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802022:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802026:	48 89 d7             	mov    %rdx,%rdi
  802029:	fc                   	cld    
  80202a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80202c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802030:	c9                   	leaveq 
  802031:	c3                   	retq   

0000000000802032 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802032:	55                   	push   %rbp
  802033:	48 89 e5             	mov    %rsp,%rbp
  802036:	48 83 ec 28          	sub    $0x28,%rsp
  80203a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80203e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802042:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802046:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80204e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802052:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80205e:	0f 83 88 00 00 00    	jae    8020ec <memmove+0xba>
  802064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802068:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80206c:	48 01 d0             	add    %rdx,%rax
  80206f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802073:	76 77                	jbe    8020ec <memmove+0xba>
		s += n;
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80207d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802081:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802085:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802089:	83 e0 03             	and    $0x3,%eax
  80208c:	48 85 c0             	test   %rax,%rax
  80208f:	75 3b                	jne    8020cc <memmove+0x9a>
  802091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802095:	83 e0 03             	and    $0x3,%eax
  802098:	48 85 c0             	test   %rax,%rax
  80209b:	75 2f                	jne    8020cc <memmove+0x9a>
  80209d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a1:	83 e0 03             	and    $0x3,%eax
  8020a4:	48 85 c0             	test   %rax,%rax
  8020a7:	75 23                	jne    8020cc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8020a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ad:	48 83 e8 04          	sub    $0x4,%rax
  8020b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020b5:	48 83 ea 04          	sub    $0x4,%rdx
  8020b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8020bd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8020c1:	48 89 c7             	mov    %rax,%rdi
  8020c4:	48 89 d6             	mov    %rdx,%rsi
  8020c7:	fd                   	std    
  8020c8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8020ca:	eb 1d                	jmp    8020e9 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8020cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8020d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020d8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	48 89 d7             	mov    %rdx,%rdi
  8020e3:	48 89 c1             	mov    %rax,%rcx
  8020e6:	fd                   	std    
  8020e7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8020e9:	fc                   	cld    
  8020ea:	eb 57                	jmp    802143 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8020ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f0:	83 e0 03             	and    $0x3,%eax
  8020f3:	48 85 c0             	test   %rax,%rax
  8020f6:	75 36                	jne    80212e <memmove+0xfc>
  8020f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fc:	83 e0 03             	and    $0x3,%eax
  8020ff:	48 85 c0             	test   %rax,%rax
  802102:	75 2a                	jne    80212e <memmove+0xfc>
  802104:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802108:	83 e0 03             	and    $0x3,%eax
  80210b:	48 85 c0             	test   %rax,%rax
  80210e:	75 1e                	jne    80212e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802110:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802114:	48 c1 e8 02          	shr    $0x2,%rax
  802118:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80211b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802123:	48 89 c7             	mov    %rax,%rdi
  802126:	48 89 d6             	mov    %rdx,%rsi
  802129:	fc                   	cld    
  80212a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80212c:	eb 15                	jmp    802143 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80212e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802132:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802136:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80213a:	48 89 c7             	mov    %rax,%rdi
  80213d:	48 89 d6             	mov    %rdx,%rsi
  802140:	fc                   	cld    
  802141:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802147:	c9                   	leaveq 
  802148:	c3                   	retq   

0000000000802149 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802149:	55                   	push   %rbp
  80214a:	48 89 e5             	mov    %rsp,%rbp
  80214d:	48 83 ec 18          	sub    $0x18,%rsp
  802151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802155:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802159:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80215d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802161:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802169:	48 89 ce             	mov    %rcx,%rsi
  80216c:	48 89 c7             	mov    %rax,%rdi
  80216f:	48 b8 32 20 80 00 00 	movabs $0x802032,%rax
  802176:	00 00 00 
  802179:	ff d0                	callq  *%rax
}
  80217b:	c9                   	leaveq 
  80217c:	c3                   	retq   

000000000080217d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	48 83 ec 28          	sub    $0x28,%rsp
  802185:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802189:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80218d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802195:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80219d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8021a1:	eb 36                	jmp    8021d9 <memcmp+0x5c>
		if (*s1 != *s2)
  8021a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a7:	0f b6 10             	movzbl (%rax),%edx
  8021aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ae:	0f b6 00             	movzbl (%rax),%eax
  8021b1:	38 c2                	cmp    %al,%dl
  8021b3:	74 1a                	je     8021cf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8021b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b9:	0f b6 00             	movzbl (%rax),%eax
  8021bc:	0f b6 d0             	movzbl %al,%edx
  8021bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c3:	0f b6 00             	movzbl (%rax),%eax
  8021c6:	0f b6 c0             	movzbl %al,%eax
  8021c9:	29 c2                	sub    %eax,%edx
  8021cb:	89 d0                	mov    %edx,%eax
  8021cd:	eb 20                	jmp    8021ef <memcmp+0x72>
		s1++, s2++;
  8021cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8021d4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021dd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8021e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8021e5:	48 85 c0             	test   %rax,%rax
  8021e8:	75 b9                	jne    8021a3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ef:	c9                   	leaveq 
  8021f0:	c3                   	retq   

00000000008021f1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8021f1:	55                   	push   %rbp
  8021f2:	48 89 e5             	mov    %rsp,%rbp
  8021f5:	48 83 ec 28          	sub    $0x28,%rsp
  8021f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021fd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802200:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802208:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220c:	48 01 d0             	add    %rdx,%rax
  80220f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802213:	eb 15                	jmp    80222a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802219:	0f b6 10             	movzbl (%rax),%edx
  80221c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80221f:	38 c2                	cmp    %al,%dl
  802221:	75 02                	jne    802225 <memfind+0x34>
			break;
  802223:	eb 0f                	jmp    802234 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802225:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80222a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802232:	72 e1                	jb     802215 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802234:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802238:	c9                   	leaveq 
  802239:	c3                   	retq   

000000000080223a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80223a:	55                   	push   %rbp
  80223b:	48 89 e5             	mov    %rsp,%rbp
  80223e:	48 83 ec 34          	sub    $0x34,%rsp
  802242:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802246:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80224a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80224d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802254:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80225b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80225c:	eb 05                	jmp    802263 <strtol+0x29>
		s++;
  80225e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802263:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802267:	0f b6 00             	movzbl (%rax),%eax
  80226a:	3c 20                	cmp    $0x20,%al
  80226c:	74 f0                	je     80225e <strtol+0x24>
  80226e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802272:	0f b6 00             	movzbl (%rax),%eax
  802275:	3c 09                	cmp    $0x9,%al
  802277:	74 e5                	je     80225e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802279:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227d:	0f b6 00             	movzbl (%rax),%eax
  802280:	3c 2b                	cmp    $0x2b,%al
  802282:	75 07                	jne    80228b <strtol+0x51>
		s++;
  802284:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802289:	eb 17                	jmp    8022a2 <strtol+0x68>
	else if (*s == '-')
  80228b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228f:	0f b6 00             	movzbl (%rax),%eax
  802292:	3c 2d                	cmp    $0x2d,%al
  802294:	75 0c                	jne    8022a2 <strtol+0x68>
		s++, neg = 1;
  802296:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80229b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8022a6:	74 06                	je     8022ae <strtol+0x74>
  8022a8:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8022ac:	75 28                	jne    8022d6 <strtol+0x9c>
  8022ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b2:	0f b6 00             	movzbl (%rax),%eax
  8022b5:	3c 30                	cmp    $0x30,%al
  8022b7:	75 1d                	jne    8022d6 <strtol+0x9c>
  8022b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022bd:	48 83 c0 01          	add    $0x1,%rax
  8022c1:	0f b6 00             	movzbl (%rax),%eax
  8022c4:	3c 78                	cmp    $0x78,%al
  8022c6:	75 0e                	jne    8022d6 <strtol+0x9c>
		s += 2, base = 16;
  8022c8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8022cd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8022d4:	eb 2c                	jmp    802302 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8022d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8022da:	75 19                	jne    8022f5 <strtol+0xbb>
  8022dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022e0:	0f b6 00             	movzbl (%rax),%eax
  8022e3:	3c 30                	cmp    $0x30,%al
  8022e5:	75 0e                	jne    8022f5 <strtol+0xbb>
		s++, base = 8;
  8022e7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8022ec:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8022f3:	eb 0d                	jmp    802302 <strtol+0xc8>
	else if (base == 0)
  8022f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8022f9:	75 07                	jne    802302 <strtol+0xc8>
		base = 10;
  8022fb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802306:	0f b6 00             	movzbl (%rax),%eax
  802309:	3c 2f                	cmp    $0x2f,%al
  80230b:	7e 1d                	jle    80232a <strtol+0xf0>
  80230d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802311:	0f b6 00             	movzbl (%rax),%eax
  802314:	3c 39                	cmp    $0x39,%al
  802316:	7f 12                	jg     80232a <strtol+0xf0>
			dig = *s - '0';
  802318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80231c:	0f b6 00             	movzbl (%rax),%eax
  80231f:	0f be c0             	movsbl %al,%eax
  802322:	83 e8 30             	sub    $0x30,%eax
  802325:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802328:	eb 4e                	jmp    802378 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80232a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232e:	0f b6 00             	movzbl (%rax),%eax
  802331:	3c 60                	cmp    $0x60,%al
  802333:	7e 1d                	jle    802352 <strtol+0x118>
  802335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802339:	0f b6 00             	movzbl (%rax),%eax
  80233c:	3c 7a                	cmp    $0x7a,%al
  80233e:	7f 12                	jg     802352 <strtol+0x118>
			dig = *s - 'a' + 10;
  802340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802344:	0f b6 00             	movzbl (%rax),%eax
  802347:	0f be c0             	movsbl %al,%eax
  80234a:	83 e8 57             	sub    $0x57,%eax
  80234d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802350:	eb 26                	jmp    802378 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802352:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802356:	0f b6 00             	movzbl (%rax),%eax
  802359:	3c 40                	cmp    $0x40,%al
  80235b:	7e 48                	jle    8023a5 <strtol+0x16b>
  80235d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802361:	0f b6 00             	movzbl (%rax),%eax
  802364:	3c 5a                	cmp    $0x5a,%al
  802366:	7f 3d                	jg     8023a5 <strtol+0x16b>
			dig = *s - 'A' + 10;
  802368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236c:	0f b6 00             	movzbl (%rax),%eax
  80236f:	0f be c0             	movsbl %al,%eax
  802372:	83 e8 37             	sub    $0x37,%eax
  802375:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802378:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80237b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80237e:	7c 02                	jl     802382 <strtol+0x148>
			break;
  802380:	eb 23                	jmp    8023a5 <strtol+0x16b>
		s++, val = (val * base) + dig;
  802382:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802387:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80238a:	48 98                	cltq   
  80238c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802391:	48 89 c2             	mov    %rax,%rdx
  802394:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802397:	48 98                	cltq   
  802399:	48 01 d0             	add    %rdx,%rax
  80239c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8023a0:	e9 5d ff ff ff       	jmpq   802302 <strtol+0xc8>

	if (endptr)
  8023a5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8023aa:	74 0b                	je     8023b7 <strtol+0x17d>
		*endptr = (char *) s;
  8023ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023b4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8023b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bb:	74 09                	je     8023c6 <strtol+0x18c>
  8023bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c1:	48 f7 d8             	neg    %rax
  8023c4:	eb 04                	jmp    8023ca <strtol+0x190>
  8023c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8023ca:	c9                   	leaveq 
  8023cb:	c3                   	retq   

00000000008023cc <strstr>:

char * strstr(const char *in, const char *str)
{
  8023cc:	55                   	push   %rbp
  8023cd:	48 89 e5             	mov    %rsp,%rbp
  8023d0:	48 83 ec 30          	sub    $0x30,%rsp
  8023d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8023dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023e4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8023e8:	0f b6 00             	movzbl (%rax),%eax
  8023eb:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8023ee:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8023f2:	75 06                	jne    8023fa <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8023f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f8:	eb 6b                	jmp    802465 <strstr+0x99>

    len = strlen(str);
  8023fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023fe:	48 89 c7             	mov    %rax,%rdi
  802401:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  802408:	00 00 00 
  80240b:	ff d0                	callq  *%rax
  80240d:	48 98                	cltq   
  80240f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  802413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802417:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80241b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80241f:	0f b6 00             	movzbl (%rax),%eax
  802422:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  802425:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802429:	75 07                	jne    802432 <strstr+0x66>
                return (char *) 0;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	eb 33                	jmp    802465 <strstr+0x99>
        } while (sc != c);
  802432:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802436:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802439:	75 d8                	jne    802413 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80243b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80243f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802447:	48 89 ce             	mov    %rcx,%rsi
  80244a:	48 89 c7             	mov    %rax,%rdi
  80244d:	48 b8 c3 1e 80 00 00 	movabs $0x801ec3,%rax
  802454:	00 00 00 
  802457:	ff d0                	callq  *%rax
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 b6                	jne    802413 <strstr+0x47>

    return (char *) (in - 1);
  80245d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802461:	48 83 e8 01          	sub    $0x1,%rax
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	53                   	push   %rbx
  80246c:	48 83 ec 48          	sub    $0x48,%rsp
  802470:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802473:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802476:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80247a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80247e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802482:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802486:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802489:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80248d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802491:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802495:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802499:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80249d:	4c 89 c3             	mov    %r8,%rbx
  8024a0:	cd 30                	int    $0x30
  8024a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8024a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8024aa:	74 3e                	je     8024ea <syscall+0x83>
  8024ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024b1:	7e 37                	jle    8024ea <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8024b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ba:	49 89 d0             	mov    %rdx,%r8
  8024bd:	89 c1                	mov    %eax,%ecx
  8024bf:	48 ba 40 4a 80 00 00 	movabs $0x804a40,%rdx
  8024c6:	00 00 00 
  8024c9:	be 23 00 00 00       	mov    $0x23,%esi
  8024ce:	48 bf 5d 4a 80 00 00 	movabs $0x804a5d,%rdi
  8024d5:	00 00 00 
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dd:	49 b9 2d 0d 80 00 00 	movabs $0x800d2d,%r9
  8024e4:	00 00 00 
  8024e7:	41 ff d1             	callq  *%r9

	return ret;
  8024ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8024ee:	48 83 c4 48          	add    $0x48,%rsp
  8024f2:	5b                   	pop    %rbx
  8024f3:	5d                   	pop    %rbp
  8024f4:	c3                   	retq   

00000000008024f5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8024f5:	55                   	push   %rbp
  8024f6:	48 89 e5             	mov    %rsp,%rbp
  8024f9:	48 83 ec 20          	sub    $0x20,%rsp
  8024fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802501:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802509:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80250d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802514:	00 
  802515:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80251b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802521:	48 89 d1             	mov    %rdx,%rcx
  802524:	48 89 c2             	mov    %rax,%rdx
  802527:	be 00 00 00 00       	mov    $0x0,%esi
  80252c:	bf 00 00 00 00       	mov    $0x0,%edi
  802531:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <sys_cgetc>:

int
sys_cgetc(void)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802547:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80254e:	00 
  80254f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802555:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80255b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802560:	ba 00 00 00 00       	mov    $0x0,%edx
  802565:	be 00 00 00 00       	mov    $0x0,%esi
  80256a:	bf 01 00 00 00       	mov    $0x1,%edi
  80256f:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
}
  80257b:	c9                   	leaveq 
  80257c:	c3                   	retq   

000000000080257d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80257d:	55                   	push   %rbp
  80257e:	48 89 e5             	mov    %rsp,%rbp
  802581:	48 83 ec 10          	sub    $0x10,%rsp
  802585:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258b:	48 98                	cltq   
  80258d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802594:	00 
  802595:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80259b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025a6:	48 89 c2             	mov    %rax,%rdx
  8025a9:	be 01 00 00 00       	mov    $0x1,%esi
  8025ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8025b3:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	callq  *%rax
}
  8025bf:	c9                   	leaveq 
  8025c0:	c3                   	retq   

00000000008025c1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8025c1:	55                   	push   %rbp
  8025c2:	48 89 e5             	mov    %rsp,%rbp
  8025c5:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8025c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025d0:	00 
  8025d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e7:	be 00 00 00 00       	mov    $0x0,%esi
  8025ec:	bf 02 00 00 00       	mov    $0x2,%edi
  8025f1:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
}
  8025fd:	c9                   	leaveq 
  8025fe:	c3                   	retq   

00000000008025ff <sys_yield>:

void
sys_yield(void)
{
  8025ff:	55                   	push   %rbp
  802600:	48 89 e5             	mov    %rsp,%rbp
  802603:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802607:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80260e:	00 
  80260f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802615:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80261b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802620:	ba 00 00 00 00       	mov    $0x0,%edx
  802625:	be 00 00 00 00       	mov    $0x0,%esi
  80262a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80262f:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802636:	00 00 00 
  802639:	ff d0                	callq  *%rax
}
  80263b:	c9                   	leaveq 
  80263c:	c3                   	retq   

000000000080263d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80263d:	55                   	push   %rbp
  80263e:	48 89 e5             	mov    %rsp,%rbp
  802641:	48 83 ec 20          	sub    $0x20,%rsp
  802645:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80264c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80264f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802652:	48 63 c8             	movslq %eax,%rcx
  802655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802659:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265c:	48 98                	cltq   
  80265e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802665:	00 
  802666:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80266c:	49 89 c8             	mov    %rcx,%r8
  80266f:	48 89 d1             	mov    %rdx,%rcx
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	be 01 00 00 00       	mov    $0x1,%esi
  80267a:	bf 04 00 00 00       	mov    $0x4,%edi
  80267f:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
}
  80268b:	c9                   	leaveq 
  80268c:	c3                   	retq   

000000000080268d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80268d:	55                   	push   %rbp
  80268e:	48 89 e5             	mov    %rsp,%rbp
  802691:	48 83 ec 30          	sub    $0x30,%rsp
  802695:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802698:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80269c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80269f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8026a3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8026a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8026aa:	48 63 c8             	movslq %eax,%rcx
  8026ad:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8026b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026b4:	48 63 f0             	movslq %eax,%rsi
  8026b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026be:	48 98                	cltq   
  8026c0:	48 89 0c 24          	mov    %rcx,(%rsp)
  8026c4:	49 89 f9             	mov    %rdi,%r9
  8026c7:	49 89 f0             	mov    %rsi,%r8
  8026ca:	48 89 d1             	mov    %rdx,%rcx
  8026cd:	48 89 c2             	mov    %rax,%rdx
  8026d0:	be 01 00 00 00       	mov    $0x1,%esi
  8026d5:	bf 05 00 00 00       	mov    $0x5,%edi
  8026da:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
  8026f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8026f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fe:	48 98                	cltq   
  802700:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802707:	00 
  802708:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80270e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802714:	48 89 d1             	mov    %rdx,%rcx
  802717:	48 89 c2             	mov    %rax,%rdx
  80271a:	be 01 00 00 00       	mov    $0x1,%esi
  80271f:	bf 06 00 00 00       	mov    $0x6,%edi
  802724:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  80272b:	00 00 00 
  80272e:	ff d0                	callq  *%rax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 10          	sub    $0x10,%rsp
  80273a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80273d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802740:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802743:	48 63 d0             	movslq %eax,%rdx
  802746:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802749:	48 98                	cltq   
  80274b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802752:	00 
  802753:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802759:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80275f:	48 89 d1             	mov    %rdx,%rcx
  802762:	48 89 c2             	mov    %rax,%rdx
  802765:	be 01 00 00 00       	mov    $0x1,%esi
  80276a:	bf 08 00 00 00       	mov    $0x8,%edi
  80276f:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
}
  80277b:	c9                   	leaveq 
  80277c:	c3                   	retq   

000000000080277d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80277d:	55                   	push   %rbp
  80277e:	48 89 e5             	mov    %rsp,%rbp
  802781:	48 83 ec 20          	sub    $0x20,%rsp
  802785:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802788:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80278c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802790:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802793:	48 98                	cltq   
  802795:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80279c:	00 
  80279d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027a9:	48 89 d1             	mov    %rdx,%rcx
  8027ac:	48 89 c2             	mov    %rax,%rdx
  8027af:	be 01 00 00 00       	mov    $0x1,%esi
  8027b4:	bf 09 00 00 00       	mov    $0x9,%edi
  8027b9:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
}
  8027c5:	c9                   	leaveq 
  8027c6:	c3                   	retq   

00000000008027c7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8027c7:	55                   	push   %rbp
  8027c8:	48 89 e5             	mov    %rsp,%rbp
  8027cb:	48 83 ec 20          	sub    $0x20,%rsp
  8027cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8027d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dd:	48 98                	cltq   
  8027df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8027e6:	00 
  8027e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027f3:	48 89 d1             	mov    %rdx,%rcx
  8027f6:	48 89 c2             	mov    %rax,%rdx
  8027f9:	be 01 00 00 00       	mov    $0x1,%esi
  8027fe:	bf 0a 00 00 00       	mov    $0xa,%edi
  802803:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  80280a:	00 00 00 
  80280d:	ff d0                	callq  *%rax
}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 20          	sub    $0x20,%rsp
  802819:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80281c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802820:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802824:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802827:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80282a:	48 63 f0             	movslq %eax,%rsi
  80282d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802834:	48 98                	cltq   
  802836:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80283a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802841:	00 
  802842:	49 89 f1             	mov    %rsi,%r9
  802845:	49 89 c8             	mov    %rcx,%r8
  802848:	48 89 d1             	mov    %rdx,%rcx
  80284b:	48 89 c2             	mov    %rax,%rdx
  80284e:	be 00 00 00 00       	mov    $0x0,%esi
  802853:	bf 0c 00 00 00       	mov    $0xc,%edi
  802858:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 83 ec 10          	sub    $0x10,%rsp
  80286e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802876:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80287d:	00 
  80287e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802884:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80288a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80288f:	48 89 c2             	mov    %rax,%rdx
  802892:	be 01 00 00 00       	mov    $0x1,%esi
  802897:	bf 0d 00 00 00       	mov    $0xd,%edi
  80289c:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8028a3:	00 00 00 
  8028a6:	ff d0                	callq  *%rax
}
  8028a8:	c9                   	leaveq 
  8028a9:	c3                   	retq   

00000000008028aa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028aa:	55                   	push   %rbp
  8028ab:	48 89 e5             	mov    %rsp,%rbp
  8028ae:	48 83 ec 30          	sub    $0x30,%rsp
  8028b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8028be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8028c6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8028cb:	75 0e                	jne    8028db <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8028cd:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8028d4:	00 00 00 
  8028d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8028db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028df:	48 89 c7             	mov    %rax,%rdi
  8028e2:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8028e9:	00 00 00 
  8028ec:	ff d0                	callq  *%rax
  8028ee:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8028f5:	79 27                	jns    80291e <ipc_recv+0x74>
		if (from_env_store != NULL)
  8028f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028fc:	74 0a                	je     802908 <ipc_recv+0x5e>
			*from_env_store = 0;
  8028fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802902:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  802908:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80290d:	74 0a                	je     802919 <ipc_recv+0x6f>
			*perm_store = 0;
  80290f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802913:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802919:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80291c:	eb 53                	jmp    802971 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80291e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802923:	74 19                	je     80293e <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  802925:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80292c:	00 00 00 
  80292f:	48 8b 00             	mov    (%rax),%rax
  802932:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293c:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80293e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802943:	74 19                	je     80295e <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  802945:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80294c:	00 00 00 
  80294f:	48 8b 00             	mov    (%rax),%rax
  802952:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295c:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80295e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802965:	00 00 00 
  802968:	48 8b 00             	mov    (%rax),%rax
  80296b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 30          	sub    $0x30,%rsp
  80297b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80297e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802981:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802985:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  802988:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  802990:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802995:	75 10                	jne    8029a7 <ipc_send+0x34>
		page = (void *)KERNBASE;
  802997:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80299e:	00 00 00 
  8029a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8029a5:	eb 0e                	jmp    8029b5 <ipc_send+0x42>
  8029a7:	eb 0c                	jmp    8029b5 <ipc_send+0x42>
		sys_yield();
  8029a9:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8029b5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8029b8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8029bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029d3:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8029d7:	74 d0                	je     8029a9 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029dd:	74 2a                	je     802a09 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8029df:	48 ba 6b 4a 80 00 00 	movabs $0x804a6b,%rdx
  8029e6:	00 00 00 
  8029e9:	be 49 00 00 00       	mov    $0x49,%esi
  8029ee:	48 bf 87 4a 80 00 00 	movabs $0x804a87,%rdi
  8029f5:	00 00 00 
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fd:	48 b9 2d 0d 80 00 00 	movabs $0x800d2d,%rcx
  802a04:	00 00 00 
  802a07:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  802a09:	c9                   	leaveq 
  802a0a:	c3                   	retq   

0000000000802a0b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a0b:	55                   	push   %rbp
  802a0c:	48 89 e5             	mov    %rsp,%rbp
  802a0f:	48 83 ec 14          	sub    $0x14,%rsp
  802a13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802a16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a1d:	eb 5e                	jmp    802a7d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802a1f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802a26:	00 00 00 
  802a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2c:	48 63 d0             	movslq %eax,%rdx
  802a2f:	48 89 d0             	mov    %rdx,%rax
  802a32:	48 c1 e0 03          	shl    $0x3,%rax
  802a36:	48 01 d0             	add    %rdx,%rax
  802a39:	48 c1 e0 05          	shl    $0x5,%rax
  802a3d:	48 01 c8             	add    %rcx,%rax
  802a40:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a46:	8b 00                	mov    (%rax),%eax
  802a48:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a4b:	75 2c                	jne    802a79 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802a4d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802a54:	00 00 00 
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5a:	48 63 d0             	movslq %eax,%rdx
  802a5d:	48 89 d0             	mov    %rdx,%rax
  802a60:	48 c1 e0 03          	shl    $0x3,%rax
  802a64:	48 01 d0             	add    %rdx,%rax
  802a67:	48 c1 e0 05          	shl    $0x5,%rax
  802a6b:	48 01 c8             	add    %rcx,%rax
  802a6e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a74:	8b 40 08             	mov    0x8(%rax),%eax
  802a77:	eb 12                	jmp    802a8b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a7d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a84:	7e 99                	jle    802a1f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8b:	c9                   	leaveq 
  802a8c:	c3                   	retq   

0000000000802a8d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a8d:	55                   	push   %rbp
  802a8e:	48 89 e5             	mov    %rsp,%rbp
  802a91:	48 83 ec 08          	sub    $0x8,%rsp
  802a95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a9d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802aa4:	ff ff ff 
  802aa7:	48 01 d0             	add    %rdx,%rax
  802aaa:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 08          	sub    $0x8,%rsp
  802ab8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802abc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac0:	48 89 c7             	mov    %rax,%rdi
  802ac3:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  802aca:	00 00 00 
  802acd:	ff d0                	callq  *%rax
  802acf:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802ad5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802ad9:	c9                   	leaveq 
  802ada:	c3                   	retq   

0000000000802adb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802adb:	55                   	push   %rbp
  802adc:	48 89 e5             	mov    %rsp,%rbp
  802adf:	48 83 ec 18          	sub    $0x18,%rsp
  802ae3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ae7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aee:	eb 6b                	jmp    802b5b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af3:	48 98                	cltq   
  802af5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802afb:	48 c1 e0 0c          	shl    $0xc,%rax
  802aff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b07:	48 c1 e8 15          	shr    $0x15,%rax
  802b0b:	48 89 c2             	mov    %rax,%rdx
  802b0e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b15:	01 00 00 
  802b18:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b1c:	83 e0 01             	and    $0x1,%eax
  802b1f:	48 85 c0             	test   %rax,%rax
  802b22:	74 21                	je     802b45 <fd_alloc+0x6a>
  802b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b28:	48 c1 e8 0c          	shr    $0xc,%rax
  802b2c:	48 89 c2             	mov    %rax,%rdx
  802b2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b36:	01 00 00 
  802b39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b3d:	83 e0 01             	and    $0x1,%eax
  802b40:	48 85 c0             	test   %rax,%rax
  802b43:	75 12                	jne    802b57 <fd_alloc+0x7c>
			*fd_store = fd;
  802b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b4d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	eb 1a                	jmp    802b71 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b5b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b5f:	7e 8f                	jle    802af0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b6c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b71:	c9                   	leaveq 
  802b72:	c3                   	retq   

0000000000802b73 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b73:	55                   	push   %rbp
  802b74:	48 89 e5             	mov    %rsp,%rbp
  802b77:	48 83 ec 20          	sub    $0x20,%rsp
  802b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b86:	78 06                	js     802b8e <fd_lookup+0x1b>
  802b88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b8c:	7e 07                	jle    802b95 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b93:	eb 6c                	jmp    802c01 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b98:	48 98                	cltq   
  802b9a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ba0:	48 c1 e0 0c          	shl    $0xc,%rax
  802ba4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bac:	48 c1 e8 15          	shr    $0x15,%rax
  802bb0:	48 89 c2             	mov    %rax,%rdx
  802bb3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bba:	01 00 00 
  802bbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bc1:	83 e0 01             	and    $0x1,%eax
  802bc4:	48 85 c0             	test   %rax,%rax
  802bc7:	74 21                	je     802bea <fd_lookup+0x77>
  802bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcd:	48 c1 e8 0c          	shr    $0xc,%rax
  802bd1:	48 89 c2             	mov    %rax,%rdx
  802bd4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bdb:	01 00 00 
  802bde:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802be2:	83 e0 01             	and    $0x1,%eax
  802be5:	48 85 c0             	test   %rax,%rax
  802be8:	75 07                	jne    802bf1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bef:	eb 10                	jmp    802c01 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802bf1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bf9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c01:	c9                   	leaveq 
  802c02:	c3                   	retq   

0000000000802c03 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 83 ec 30          	sub    $0x30,%rsp
  802c0b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c0f:	89 f0                	mov    %esi,%eax
  802c11:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c18:	48 89 c7             	mov    %rax,%rdi
  802c1b:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2b:	48 89 d6             	mov    %rdx,%rsi
  802c2e:	89 c7                	mov    %eax,%edi
  802c30:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  802c37:	00 00 00 
  802c3a:	ff d0                	callq  *%rax
  802c3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c43:	78 0a                	js     802c4f <fd_close+0x4c>
	    || fd != fd2)
  802c45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c49:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c4d:	74 12                	je     802c61 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802c4f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c53:	74 05                	je     802c5a <fd_close+0x57>
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	eb 05                	jmp    802c5f <fd_close+0x5c>
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	eb 69                	jmp    802cca <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c65:	8b 00                	mov    (%rax),%eax
  802c67:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c6b:	48 89 d6             	mov    %rdx,%rsi
  802c6e:	89 c7                	mov    %eax,%edi
  802c70:	48 b8 cc 2c 80 00 00 	movabs $0x802ccc,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	callq  *%rax
  802c7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c83:	78 2a                	js     802caf <fd_close+0xac>
		if (dev->dev_close)
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c8d:	48 85 c0             	test   %rax,%rax
  802c90:	74 16                	je     802ca8 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c96:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c9e:	48 89 d7             	mov    %rdx,%rdi
  802ca1:	ff d0                	callq  *%rax
  802ca3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca6:	eb 07                	jmp    802caf <fd_close+0xac>
		else
			r = 0;
  802ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802caf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb3:	48 89 c6             	mov    %rax,%rsi
  802cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  802cbb:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
	return r;
  802cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cca:	c9                   	leaveq 
  802ccb:	c3                   	retq   

0000000000802ccc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ccc:	55                   	push   %rbp
  802ccd:	48 89 e5             	mov    %rsp,%rbp
  802cd0:	48 83 ec 20          	sub    $0x20,%rsp
  802cd4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ce2:	eb 41                	jmp    802d25 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802ce4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ceb:	00 00 00 
  802cee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cf1:	48 63 d2             	movslq %edx,%rdx
  802cf4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cf8:	8b 00                	mov    (%rax),%eax
  802cfa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cfd:	75 22                	jne    802d21 <dev_lookup+0x55>
			*dev = devtab[i];
  802cff:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802d06:	00 00 00 
  802d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d0c:	48 63 d2             	movslq %edx,%rdx
  802d0f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d17:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1f:	eb 60                	jmp    802d81 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d25:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802d2c:	00 00 00 
  802d2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d32:	48 63 d2             	movslq %edx,%rdx
  802d35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d39:	48 85 c0             	test   %rax,%rax
  802d3c:	75 a6                	jne    802ce4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d3e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d45:	00 00 00 
  802d48:	48 8b 00             	mov    (%rax),%rax
  802d4b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d51:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d54:	89 c6                	mov    %eax,%esi
  802d56:	48 bf 98 4a 80 00 00 	movabs $0x804a98,%rdi
  802d5d:	00 00 00 
  802d60:	b8 00 00 00 00       	mov    $0x0,%eax
  802d65:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  802d6c:	00 00 00 
  802d6f:	ff d1                	callq  *%rcx
	*dev = 0;
  802d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d75:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d81:	c9                   	leaveq 
  802d82:	c3                   	retq   

0000000000802d83 <close>:

int
close(int fdnum)
{
  802d83:	55                   	push   %rbp
  802d84:	48 89 e5             	mov    %rsp,%rbp
  802d87:	48 83 ec 20          	sub    $0x20,%rsp
  802d8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d95:	48 89 d6             	mov    %rdx,%rsi
  802d98:	89 c7                	mov    %eax,%edi
  802d9a:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	79 05                	jns    802db4 <close+0x31>
		return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	eb 18                	jmp    802dcc <close+0x49>
	else
		return fd_close(fd, 1);
  802db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db8:	be 01 00 00 00       	mov    $0x1,%esi
  802dbd:	48 89 c7             	mov    %rax,%rdi
  802dc0:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  802dc7:	00 00 00 
  802dca:	ff d0                	callq  *%rax
}
  802dcc:	c9                   	leaveq 
  802dcd:	c3                   	retq   

0000000000802dce <close_all>:

void
close_all(void)
{
  802dce:	55                   	push   %rbp
  802dcf:	48 89 e5             	mov    %rsp,%rbp
  802dd2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ddd:	eb 15                	jmp    802df4 <close_all+0x26>
		close(i);
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de2:	89 c7                	mov    %eax,%edi
  802de4:	48 b8 83 2d 80 00 00 	movabs $0x802d83,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802df0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802df4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802df8:	7e e5                	jle    802ddf <close_all+0x11>
		close(i);
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 40          	sub    $0x40,%rsp
  802e04:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e07:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e0a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e0e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e11:	48 89 d6             	mov    %rdx,%rsi
  802e14:	89 c7                	mov    %eax,%edi
  802e16:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
  802e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e29:	79 08                	jns    802e33 <dup+0x37>
		return r;
  802e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2e:	e9 70 01 00 00       	jmpq   802fa3 <dup+0x1a7>
	close(newfdnum);
  802e33:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 83 2d 80 00 00 	movabs $0x802d83,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e44:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e47:	48 98                	cltq   
  802e49:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e4f:	48 c1 e0 0c          	shl    $0xc,%rax
  802e53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5b:	48 89 c7             	mov    %rax,%rdi
  802e5e:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	48 89 c7             	mov    %rax,%rdi
  802e75:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
  802e81:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e89:	48 c1 e8 15          	shr    $0x15,%rax
  802e8d:	48 89 c2             	mov    %rax,%rdx
  802e90:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e97:	01 00 00 
  802e9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e9e:	83 e0 01             	and    $0x1,%eax
  802ea1:	48 85 c0             	test   %rax,%rax
  802ea4:	74 73                	je     802f19 <dup+0x11d>
  802ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eaa:	48 c1 e8 0c          	shr    $0xc,%rax
  802eae:	48 89 c2             	mov    %rax,%rdx
  802eb1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eb8:	01 00 00 
  802ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ebf:	83 e0 01             	and    $0x1,%eax
  802ec2:	48 85 c0             	test   %rax,%rax
  802ec5:	74 52                	je     802f19 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecb:	48 c1 e8 0c          	shr    $0xc,%rax
  802ecf:	48 89 c2             	mov    %rax,%rdx
  802ed2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed9:	01 00 00 
  802edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ee0:	25 07 0e 00 00       	and    $0xe07,%eax
  802ee5:	89 c1                	mov    %eax,%ecx
  802ee7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eef:	41 89 c8             	mov    %ecx,%r8d
  802ef2:	48 89 d1             	mov    %rdx,%rcx
  802ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  802efa:	48 89 c6             	mov    %rax,%rsi
  802efd:	bf 00 00 00 00       	mov    $0x0,%edi
  802f02:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f15:	79 02                	jns    802f19 <dup+0x11d>
			goto err;
  802f17:	eb 57                	jmp    802f70 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f1d:	48 c1 e8 0c          	shr    $0xc,%rax
  802f21:	48 89 c2             	mov    %rax,%rdx
  802f24:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f2b:	01 00 00 
  802f2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f32:	25 07 0e 00 00       	and    $0xe07,%eax
  802f37:	89 c1                	mov    %eax,%ecx
  802f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f41:	41 89 c8             	mov    %ecx,%r8d
  802f44:	48 89 d1             	mov    %rdx,%rcx
  802f47:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4c:	48 89 c6             	mov    %rax,%rsi
  802f4f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f54:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  802f5b:	00 00 00 
  802f5e:	ff d0                	callq  *%rax
  802f60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f67:	79 02                	jns    802f6b <dup+0x16f>
		goto err;
  802f69:	eb 05                	jmp    802f70 <dup+0x174>

	return newfdnum;
  802f6b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f6e:	eb 33                	jmp    802fa3 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f74:	48 89 c6             	mov    %rax,%rsi
  802f77:	bf 00 00 00 00       	mov    $0x0,%edi
  802f7c:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8c:	48 89 c6             	mov    %rax,%rsi
  802f8f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f94:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802f9b:	00 00 00 
  802f9e:	ff d0                	callq  *%rax
	return r;
  802fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fa3:	c9                   	leaveq 
  802fa4:	c3                   	retq   

0000000000802fa5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802fa5:	55                   	push   %rbp
  802fa6:	48 89 e5             	mov    %rsp,%rbp
  802fa9:	48 83 ec 40          	sub    $0x40,%rsp
  802fad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fb0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fb4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fb8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fbc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fbf:	48 89 d6             	mov    %rdx,%rsi
  802fc2:	89 c7                	mov    %eax,%edi
  802fc4:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  802fcb:	00 00 00 
  802fce:	ff d0                	callq  *%rax
  802fd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd7:	78 24                	js     802ffd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdd:	8b 00                	mov    (%rax),%eax
  802fdf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fe3:	48 89 d6             	mov    %rdx,%rsi
  802fe6:	89 c7                	mov    %eax,%edi
  802fe8:	48 b8 cc 2c 80 00 00 	movabs $0x802ccc,%rax
  802fef:	00 00 00 
  802ff2:	ff d0                	callq  *%rax
  802ff4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffb:	79 05                	jns    803002 <read+0x5d>
		return r;
  802ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803000:	eb 76                	jmp    803078 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803006:	8b 40 08             	mov    0x8(%rax),%eax
  803009:	83 e0 03             	and    $0x3,%eax
  80300c:	83 f8 01             	cmp    $0x1,%eax
  80300f:	75 3a                	jne    80304b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803011:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803018:	00 00 00 
  80301b:	48 8b 00             	mov    (%rax),%rax
  80301e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803024:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803027:	89 c6                	mov    %eax,%esi
  803029:	48 bf b7 4a 80 00 00 	movabs $0x804ab7,%rdi
  803030:	00 00 00 
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
  803038:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  80303f:	00 00 00 
  803042:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803044:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803049:	eb 2d                	jmp    803078 <read+0xd3>
	}
	if (!dev->dev_read)
  80304b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304f:	48 8b 40 10          	mov    0x10(%rax),%rax
  803053:	48 85 c0             	test   %rax,%rax
  803056:	75 07                	jne    80305f <read+0xba>
		return -E_NOT_SUPP;
  803058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80305d:	eb 19                	jmp    803078 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80305f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803063:	48 8b 40 10          	mov    0x10(%rax),%rax
  803067:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80306b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80306f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803073:	48 89 cf             	mov    %rcx,%rdi
  803076:	ff d0                	callq  *%rax
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 30          	sub    $0x30,%rsp
  803082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803089:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80308d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803094:	eb 49                	jmp    8030df <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803099:	48 98                	cltq   
  80309b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80309f:	48 29 c2             	sub    %rax,%rdx
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	48 63 c8             	movslq %eax,%rcx
  8030a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ac:	48 01 c1             	add    %rax,%rcx
  8030af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b2:	48 89 ce             	mov    %rcx,%rsi
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 a5 2f 80 00 00 	movabs $0x802fa5,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
  8030c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030ca:	79 05                	jns    8030d1 <readn+0x57>
			return m;
  8030cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030cf:	eb 1c                	jmp    8030ed <readn+0x73>
		if (m == 0)
  8030d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030d5:	75 02                	jne    8030d9 <readn+0x5f>
			break;
  8030d7:	eb 11                	jmp    8030ea <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030dc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e2:	48 98                	cltq   
  8030e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030e8:	72 ac                	jb     803096 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8030ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030ed:	c9                   	leaveq 
  8030ee:	c3                   	retq   

00000000008030ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8030ef:	55                   	push   %rbp
  8030f0:	48 89 e5             	mov    %rsp,%rbp
  8030f3:	48 83 ec 40          	sub    $0x40,%rsp
  8030f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803102:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803106:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803109:	48 89 d6             	mov    %rdx,%rsi
  80310c:	89 c7                	mov    %eax,%edi
  80310e:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  803115:	00 00 00 
  803118:	ff d0                	callq  *%rax
  80311a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803121:	78 24                	js     803147 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803127:	8b 00                	mov    (%rax),%eax
  803129:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80312d:	48 89 d6             	mov    %rdx,%rsi
  803130:	89 c7                	mov    %eax,%edi
  803132:	48 b8 cc 2c 80 00 00 	movabs $0x802ccc,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803145:	79 05                	jns    80314c <write+0x5d>
		return r;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	eb 75                	jmp    8031c1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80314c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803150:	8b 40 08             	mov    0x8(%rax),%eax
  803153:	83 e0 03             	and    $0x3,%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	75 3a                	jne    803194 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80315a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803161:	00 00 00 
  803164:	48 8b 00             	mov    (%rax),%rax
  803167:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80316d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803170:	89 c6                	mov    %eax,%esi
  803172:	48 bf d3 4a 80 00 00 	movabs $0x804ad3,%rdi
  803179:	00 00 00 
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
  803181:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  803188:	00 00 00 
  80318b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80318d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803192:	eb 2d                	jmp    8031c1 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803198:	48 8b 40 18          	mov    0x18(%rax),%rax
  80319c:	48 85 c0             	test   %rax,%rax
  80319f:	75 07                	jne    8031a8 <write+0xb9>
		return -E_NOT_SUPP;
  8031a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031a6:	eb 19                	jmp    8031c1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8031a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031bc:	48 89 cf             	mov    %rcx,%rdi
  8031bf:	ff d0                	callq  *%rax
}
  8031c1:	c9                   	leaveq 
  8031c2:	c3                   	retq   

00000000008031c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8031c3:	55                   	push   %rbp
  8031c4:	48 89 e5             	mov    %rsp,%rbp
  8031c7:	48 83 ec 18          	sub    $0x18,%rsp
  8031cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d8:	48 89 d6             	mov    %rdx,%rsi
  8031db:	89 c7                	mov    %eax,%edi
  8031dd:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
  8031e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f0:	79 05                	jns    8031f7 <seek+0x34>
		return r;
  8031f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f5:	eb 0f                	jmp    803206 <seek+0x43>
	fd->fd_offset = offset;
  8031f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031fe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803201:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 30          	sub    $0x30,%rsp
  803210:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803213:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803216:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80321a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80321d:	48 89 d6             	mov    %rdx,%rsi
  803220:	89 c7                	mov    %eax,%edi
  803222:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
  80322e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803231:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803235:	78 24                	js     80325b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323b:	8b 00                	mov    (%rax),%eax
  80323d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803241:	48 89 d6             	mov    %rdx,%rsi
  803244:	89 c7                	mov    %eax,%edi
  803246:	48 b8 cc 2c 80 00 00 	movabs $0x802ccc,%rax
  80324d:	00 00 00 
  803250:	ff d0                	callq  *%rax
  803252:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803255:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803259:	79 05                	jns    803260 <ftruncate+0x58>
		return r;
  80325b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325e:	eb 72                	jmp    8032d2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803264:	8b 40 08             	mov    0x8(%rax),%eax
  803267:	83 e0 03             	and    $0x3,%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	75 3a                	jne    8032a8 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80326e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803275:	00 00 00 
  803278:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80327b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803281:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803284:	89 c6                	mov    %eax,%esi
  803286:	48 bf f0 4a 80 00 00 	movabs $0x804af0,%rdi
  80328d:	00 00 00 
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
  803295:	48 b9 66 0f 80 00 00 	movabs $0x800f66,%rcx
  80329c:	00 00 00 
  80329f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032a6:	eb 2a                	jmp    8032d2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032b0:	48 85 c0             	test   %rax,%rax
  8032b3:	75 07                	jne    8032bc <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032ba:	eb 16                	jmp    8032d2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8032cb:	89 ce                	mov    %ecx,%esi
  8032cd:	48 89 d7             	mov    %rdx,%rdi
  8032d0:	ff d0                	callq  *%rax
}
  8032d2:	c9                   	leaveq 
  8032d3:	c3                   	retq   

00000000008032d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032d4:	55                   	push   %rbp
  8032d5:	48 89 e5             	mov    %rsp,%rbp
  8032d8:	48 83 ec 30          	sub    $0x30,%rsp
  8032dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032e3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032ea:	48 89 d6             	mov    %rdx,%rsi
  8032ed:	89 c7                	mov    %eax,%edi
  8032ef:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
  8032fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803302:	78 24                	js     803328 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803308:	8b 00                	mov    (%rax),%eax
  80330a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80330e:	48 89 d6             	mov    %rdx,%rsi
  803311:	89 c7                	mov    %eax,%edi
  803313:	48 b8 cc 2c 80 00 00 	movabs $0x802ccc,%rax
  80331a:	00 00 00 
  80331d:	ff d0                	callq  *%rax
  80331f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803322:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803326:	79 05                	jns    80332d <fstat+0x59>
		return r;
  803328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332b:	eb 5e                	jmp    80338b <fstat+0xb7>
	if (!dev->dev_stat)
  80332d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803331:	48 8b 40 28          	mov    0x28(%rax),%rax
  803335:	48 85 c0             	test   %rax,%rax
  803338:	75 07                	jne    803341 <fstat+0x6d>
		return -E_NOT_SUPP;
  80333a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80333f:	eb 4a                	jmp    80338b <fstat+0xb7>
	stat->st_name[0] = 0;
  803341:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803345:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803348:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80334c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803353:	00 00 00 
	stat->st_isdir = 0;
  803356:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803361:	00 00 00 
	stat->st_dev = dev;
  803364:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803368:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803377:	48 8b 40 28          	mov    0x28(%rax),%rax
  80337b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80337f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803383:	48 89 ce             	mov    %rcx,%rsi
  803386:	48 89 d7             	mov    %rdx,%rdi
  803389:	ff d0                	callq  *%rax
}
  80338b:	c9                   	leaveq 
  80338c:	c3                   	retq   

000000000080338d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80338d:	55                   	push   %rbp
  80338e:	48 89 e5             	mov    %rsp,%rbp
  803391:	48 83 ec 20          	sub    $0x20,%rsp
  803395:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803399:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80339d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a1:	be 00 00 00 00       	mov    $0x0,%esi
  8033a6:	48 89 c7             	mov    %rax,%rdi
  8033a9:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
  8033b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033bc:	79 05                	jns    8033c3 <stat+0x36>
		return fd;
  8033be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c1:	eb 2f                	jmp    8033f2 <stat+0x65>
	r = fstat(fd, stat);
  8033c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ca:	48 89 d6             	mov    %rdx,%rsi
  8033cd:	89 c7                	mov    %eax,%edi
  8033cf:	48 b8 d4 32 80 00 00 	movabs $0x8032d4,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e1:	89 c7                	mov    %eax,%edi
  8033e3:	48 b8 83 2d 80 00 00 	movabs $0x802d83,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
	return r;
  8033ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033f2:	c9                   	leaveq 
  8033f3:	c3                   	retq   

00000000008033f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033f4:	55                   	push   %rbp
  8033f5:	48 89 e5             	mov    %rsp,%rbp
  8033f8:	48 83 ec 10          	sub    $0x10,%rsp
  8033fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803403:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80340a:	00 00 00 
  80340d:	8b 00                	mov    (%rax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	75 1d                	jne    803430 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803413:	bf 01 00 00 00       	mov    $0x1,%edi
  803418:	48 b8 0b 2a 80 00 00 	movabs $0x802a0b,%rax
  80341f:	00 00 00 
  803422:	ff d0                	callq  *%rax
  803424:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80342b:	00 00 00 
  80342e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803430:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803437:	00 00 00 
  80343a:	8b 00                	mov    (%rax),%eax
  80343c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80343f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803444:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80344b:	00 00 00 
  80344e:	89 c7                	mov    %eax,%edi
  803450:	48 b8 73 29 80 00 00 	movabs $0x802973,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80345c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803460:	ba 00 00 00 00       	mov    $0x0,%edx
  803465:	48 89 c6             	mov    %rax,%rsi
  803468:	bf 00 00 00 00       	mov    $0x0,%edi
  80346d:	48 b8 aa 28 80 00 00 	movabs $0x8028aa,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
}
  803479:	c9                   	leaveq 
  80347a:	c3                   	retq   

000000000080347b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80347b:	55                   	push   %rbp
  80347c:	48 89 e5             	mov    %rsp,%rbp
  80347f:	48 83 ec 20          	sub    $0x20,%rsp
  803483:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803487:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80348a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348e:	48 89 c7             	mov    %rax,%rdi
  803491:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
  80349d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034a2:	7e 0a                	jle    8034ae <open+0x33>
		return -E_BAD_PATH;
  8034a4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034a9:	e9 a5 00 00 00       	jmpq   803553 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8034ae:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034b2:	48 89 c7             	mov    %rax,%rdi
  8034b5:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c8:	79 08                	jns    8034d2 <open+0x57>
		return r;
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cd:	e9 81 00 00 00       	jmpq   803553 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8034d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d6:	48 89 c6             	mov    %rax,%rsi
  8034d9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8034e0:	00 00 00 
  8034e3:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8034ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034f6:	00 00 00 
  8034f9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034fc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803506:	48 89 c6             	mov    %rax,%rsi
  803509:	bf 01 00 00 00       	mov    $0x1,%edi
  80350e:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803515:	00 00 00 
  803518:	ff d0                	callq  *%rax
  80351a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80351d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803521:	79 1d                	jns    803540 <open+0xc5>
		fd_close(fd, 0);
  803523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803527:	be 00 00 00 00       	mov    $0x0,%esi
  80352c:	48 89 c7             	mov    %rax,%rdi
  80352f:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
		return r;
  80353b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353e:	eb 13                	jmp    803553 <open+0xd8>
	}

	return fd2num(fd);
  803540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803544:	48 89 c7             	mov    %rax,%rdi
  803547:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 10          	sub    $0x10,%rsp
  80355d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803565:	8b 50 0c             	mov    0xc(%rax),%edx
  803568:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80356f:	00 00 00 
  803572:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803574:	be 00 00 00 00       	mov    $0x0,%esi
  803579:	bf 06 00 00 00       	mov    $0x6,%edi
  80357e:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
}
  80358a:	c9                   	leaveq 
  80358b:	c3                   	retq   

000000000080358c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80358c:	55                   	push   %rbp
  80358d:	48 89 e5             	mov    %rsp,%rbp
  803590:	48 83 ec 30          	sub    $0x30,%rsp
  803594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803598:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80359c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a4:	8b 50 0c             	mov    0xc(%rax),%edx
  8035a7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035ae:	00 00 00 
  8035b1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035b3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035ba:	00 00 00 
  8035bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035c1:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8035c5:	be 00 00 00 00       	mov    $0x0,%esi
  8035ca:	bf 03 00 00 00       	mov    $0x3,%edi
  8035cf:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
  8035db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e2:	79 05                	jns    8035e9 <devfile_read+0x5d>
		return r;
  8035e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e7:	eb 26                	jmp    80360f <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8035e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ec:	48 63 d0             	movslq %eax,%rdx
  8035ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8035fa:	00 00 00 
  8035fd:	48 89 c7             	mov    %rax,%rdi
  803600:	48 b8 32 20 80 00 00 	movabs $0x802032,%rax
  803607:	00 00 00 
  80360a:	ff d0                	callq  *%rax

	return r;
  80360c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80360f:	c9                   	leaveq 
  803610:	c3                   	retq   

0000000000803611 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803611:	55                   	push   %rbp
  803612:	48 89 e5             	mov    %rsp,%rbp
  803615:	48 83 ec 30          	sub    $0x30,%rsp
  803619:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80361d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803621:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  803625:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80362c:	00 
  80362d:	76 08                	jbe    803637 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80362f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803636:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363b:	8b 50 0c             	mov    0xc(%rax),%edx
  80363e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803645:	00 00 00 
  803648:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80364a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803651:	00 00 00 
  803654:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803658:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80365c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803660:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803664:	48 89 c6             	mov    %rax,%rsi
  803667:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80366e:	00 00 00 
  803671:	48 b8 32 20 80 00 00 	movabs $0x802032,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80367d:	be 00 00 00 00       	mov    $0x0,%esi
  803682:	bf 04 00 00 00       	mov    $0x4,%edi
  803687:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
  803693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369a:	79 05                	jns    8036a1 <devfile_write+0x90>
		return r;
  80369c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369f:	eb 03                	jmp    8036a4 <devfile_write+0x93>

	return r;
  8036a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8036a4:	c9                   	leaveq 
  8036a5:	c3                   	retq   

00000000008036a6 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8036a6:	55                   	push   %rbp
  8036a7:	48 89 e5             	mov    %rsp,%rbp
  8036aa:	48 83 ec 20          	sub    $0x20,%rsp
  8036ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8036bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036c4:	00 00 00 
  8036c7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036c9:	be 00 00 00 00       	mov    $0x0,%esi
  8036ce:	bf 05 00 00 00       	mov    $0x5,%edi
  8036d3:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
  8036df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e6:	79 05                	jns    8036ed <devfile_stat+0x47>
		return r;
  8036e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036eb:	eb 56                	jmp    803743 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8036f8:	00 00 00 
  8036fb:	48 89 c7             	mov    %rax,%rdi
  8036fe:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80370a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803711:	00 00 00 
  803714:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80371a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803724:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80372b:	00 00 00 
  80372e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803734:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803738:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80373e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803743:	c9                   	leaveq 
  803744:	c3                   	retq   

0000000000803745 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 10          	sub    $0x10,%rsp
  80374d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803751:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	8b 50 0c             	mov    0xc(%rax),%edx
  80375b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803762:	00 00 00 
  803765:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803767:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80376e:	00 00 00 
  803771:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803774:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803777:	be 00 00 00 00       	mov    $0x0,%esi
  80377c:	bf 02 00 00 00       	mov    $0x2,%edi
  803781:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
}
  80378d:	c9                   	leaveq 
  80378e:	c3                   	retq   

000000000080378f <remove>:

// Delete a file
int
remove(const char *path)
{
  80378f:	55                   	push   %rbp
  803790:	48 89 e5             	mov    %rsp,%rbp
  803793:	48 83 ec 10          	sub    $0x10,%rsp
  803797:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80379b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379f:	48 89 c7             	mov    %rax,%rdi
  8037a2:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
  8037ae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8037b3:	7e 07                	jle    8037bc <remove+0x2d>
		return -E_BAD_PATH;
  8037b5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8037ba:	eb 33                	jmp    8037ef <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8037bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c0:	48 89 c6             	mov    %rax,%rsi
  8037c3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8037ca:	00 00 00 
  8037cd:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8037d9:	be 00 00 00 00       	mov    $0x0,%esi
  8037de:	bf 07 00 00 00       	mov    $0x7,%edi
  8037e3:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  8037ea:	00 00 00 
  8037ed:	ff d0                	callq  *%rax
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037f5:	be 00 00 00 00       	mov    $0x0,%esi
  8037fa:	bf 08 00 00 00       	mov    $0x8,%edi
  8037ff:	48 b8 f4 33 80 00 00 	movabs $0x8033f4,%rax
  803806:	00 00 00 
  803809:	ff d0                	callq  *%rax
}
  80380b:	5d                   	pop    %rbp
  80380c:	c3                   	retq   

000000000080380d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80380d:	55                   	push   %rbp
  80380e:	48 89 e5             	mov    %rsp,%rbp
  803811:	53                   	push   %rbx
  803812:	48 83 ec 38          	sub    $0x38,%rsp
  803816:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80381a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80381e:	48 89 c7             	mov    %rax,%rdi
  803821:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
  80382d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803830:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803834:	0f 88 bf 01 00 00    	js     8039f9 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80383a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383e:	ba 07 04 00 00       	mov    $0x407,%edx
  803843:	48 89 c6             	mov    %rax,%rsi
  803846:	bf 00 00 00 00       	mov    $0x0,%edi
  80384b:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80385a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80385e:	0f 88 95 01 00 00    	js     8039f9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803864:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803868:	48 89 c7             	mov    %rax,%rdi
  80386b:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
  803877:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80387e:	0f 88 5d 01 00 00    	js     8039e1 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803884:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803888:	ba 07 04 00 00       	mov    $0x407,%edx
  80388d:	48 89 c6             	mov    %rax,%rsi
  803890:	bf 00 00 00 00       	mov    $0x0,%edi
  803895:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a8:	0f 88 33 01 00 00    	js     8039e1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b2:	48 89 c7             	mov    %rax,%rdi
  8038b5:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  8038bc:	00 00 00 
  8038bf:	ff d0                	callq  *%rax
  8038c1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038c9:	ba 07 04 00 00       	mov    $0x407,%edx
  8038ce:	48 89 c6             	mov    %rax,%rsi
  8038d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d6:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  8038dd:	00 00 00 
  8038e0:	ff d0                	callq  *%rax
  8038e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038e9:	79 05                	jns    8038f0 <pipe+0xe3>
		goto err2;
  8038eb:	e9 d9 00 00 00       	jmpq   8039c9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f4:	48 89 c7             	mov    %rax,%rdi
  8038f7:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
  803903:	48 89 c2             	mov    %rax,%rdx
  803906:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803910:	48 89 d1             	mov    %rdx,%rcx
  803913:	ba 00 00 00 00       	mov    $0x0,%edx
  803918:	48 89 c6             	mov    %rax,%rsi
  80391b:	bf 00 00 00 00       	mov    $0x0,%edi
  803920:	48 b8 8d 26 80 00 00 	movabs $0x80268d,%rax
  803927:	00 00 00 
  80392a:	ff d0                	callq  *%rax
  80392c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80392f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803933:	79 1b                	jns    803950 <pipe+0x143>
		goto err3;
  803935:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803936:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393a:	48 89 c6             	mov    %rax,%rsi
  80393d:	bf 00 00 00 00       	mov    $0x0,%edi
  803942:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
  80394e:	eb 79                	jmp    8039c9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803954:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80395b:	00 00 00 
  80395e:	8b 12                	mov    (%rdx),%edx
  803960:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803966:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80396d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803971:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803978:	00 00 00 
  80397b:	8b 12                	mov    (%rdx),%edx
  80397d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80397f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803983:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80398a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398e:	48 89 c7             	mov    %rax,%rdi
  803991:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
  80399d:	89 c2                	mov    %eax,%edx
  80399f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039a3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8039a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039a9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8039ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b1:	48 89 c7             	mov    %rax,%rdi
  8039b4:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
  8039c0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8039c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c7:	eb 33                	jmp    8039fc <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8039c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cd:	48 89 c6             	mov    %rax,%rsi
  8039d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d5:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8039dc:	00 00 00 
  8039df:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8039e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e5:	48 89 c6             	mov    %rax,%rsi
  8039e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ed:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8039f4:	00 00 00 
  8039f7:	ff d0                	callq  *%rax
    err:
	return r;
  8039f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039fc:	48 83 c4 38          	add    $0x38,%rsp
  803a00:	5b                   	pop    %rbx
  803a01:	5d                   	pop    %rbp
  803a02:	c3                   	retq   

0000000000803a03 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803a03:	55                   	push   %rbp
  803a04:	48 89 e5             	mov    %rsp,%rbp
  803a07:	53                   	push   %rbx
  803a08:	48 83 ec 28          	sub    $0x28,%rsp
  803a0c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803a14:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a1b:	00 00 00 
  803a1e:	48 8b 00             	mov    (%rax),%rax
  803a21:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a27:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2e:	48 89 c7             	mov    %rax,%rdi
  803a31:	48 b8 89 40 80 00 00 	movabs $0x804089,%rax
  803a38:	00 00 00 
  803a3b:	ff d0                	callq  *%rax
  803a3d:	89 c3                	mov    %eax,%ebx
  803a3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a43:	48 89 c7             	mov    %rax,%rdi
  803a46:	48 b8 89 40 80 00 00 	movabs $0x804089,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
  803a52:	39 c3                	cmp    %eax,%ebx
  803a54:	0f 94 c0             	sete   %al
  803a57:	0f b6 c0             	movzbl %al,%eax
  803a5a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a5d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a64:	00 00 00 
  803a67:	48 8b 00             	mov    (%rax),%rax
  803a6a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a70:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a76:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a79:	75 05                	jne    803a80 <_pipeisclosed+0x7d>
			return ret;
  803a7b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a7e:	eb 4f                	jmp    803acf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a83:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a86:	74 42                	je     803aca <_pipeisclosed+0xc7>
  803a88:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a8c:	75 3c                	jne    803aca <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a8e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a95:	00 00 00 
  803a98:	48 8b 00             	mov    (%rax),%rax
  803a9b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803aa1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803aa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aa7:	89 c6                	mov    %eax,%esi
  803aa9:	48 bf 1b 4b 80 00 00 	movabs $0x804b1b,%rdi
  803ab0:	00 00 00 
  803ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab8:	49 b8 66 0f 80 00 00 	movabs $0x800f66,%r8
  803abf:	00 00 00 
  803ac2:	41 ff d0             	callq  *%r8
	}
  803ac5:	e9 4a ff ff ff       	jmpq   803a14 <_pipeisclosed+0x11>
  803aca:	e9 45 ff ff ff       	jmpq   803a14 <_pipeisclosed+0x11>
}
  803acf:	48 83 c4 28          	add    $0x28,%rsp
  803ad3:	5b                   	pop    %rbx
  803ad4:	5d                   	pop    %rbp
  803ad5:	c3                   	retq   

0000000000803ad6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ad6:	55                   	push   %rbp
  803ad7:	48 89 e5             	mov    %rsp,%rbp
  803ada:	48 83 ec 30          	sub    $0x30,%rsp
  803ade:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ae1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ae5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ae8:	48 89 d6             	mov    %rdx,%rsi
  803aeb:	89 c7                	mov    %eax,%edi
  803aed:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
  803af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b00:	79 05                	jns    803b07 <pipeisclosed+0x31>
		return r;
  803b02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b05:	eb 31                	jmp    803b38 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803b07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0b:	48 89 c7             	mov    %rax,%rdi
  803b0e:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803b15:	00 00 00 
  803b18:	ff d0                	callq  *%rax
  803b1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803b1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b26:	48 89 d6             	mov    %rdx,%rsi
  803b29:	48 89 c7             	mov    %rax,%rdi
  803b2c:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
}
  803b38:	c9                   	leaveq 
  803b39:	c3                   	retq   

0000000000803b3a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b3a:	55                   	push   %rbp
  803b3b:	48 89 e5             	mov    %rsp,%rbp
  803b3e:	48 83 ec 40          	sub    $0x40,%rsp
  803b42:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b46:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b4a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b52:	48 89 c7             	mov    %rax,%rdi
  803b55:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
  803b61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b65:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b6d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b74:	00 
  803b75:	e9 92 00 00 00       	jmpq   803c0c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b7a:	eb 41                	jmp    803bbd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b7c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b81:	74 09                	je     803b8c <devpipe_read+0x52>
				return i;
  803b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b87:	e9 92 00 00 00       	jmpq   803c1e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b94:	48 89 d6             	mov    %rdx,%rsi
  803b97:	48 89 c7             	mov    %rax,%rdi
  803b9a:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	74 07                	je     803bb1 <devpipe_read+0x77>
				return 0;
  803baa:	b8 00 00 00 00       	mov    $0x0,%eax
  803baf:	eb 6d                	jmp    803c1e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803bb1:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803bbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc1:	8b 10                	mov    (%rax),%edx
  803bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc7:	8b 40 04             	mov    0x4(%rax),%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	74 ae                	je     803b7c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bd6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bde:	8b 00                	mov    (%rax),%eax
  803be0:	99                   	cltd   
  803be1:	c1 ea 1b             	shr    $0x1b,%edx
  803be4:	01 d0                	add    %edx,%eax
  803be6:	83 e0 1f             	and    $0x1f,%eax
  803be9:	29 d0                	sub    %edx,%eax
  803beb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bef:	48 98                	cltq   
  803bf1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bf6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803bf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfc:	8b 00                	mov    (%rax),%eax
  803bfe:	8d 50 01             	lea    0x1(%rax),%edx
  803c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c05:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c07:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c10:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c14:	0f 82 60 ff ff ff    	jb     803b7a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c1e:	c9                   	leaveq 
  803c1f:	c3                   	retq   

0000000000803c20 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c20:	55                   	push   %rbp
  803c21:	48 89 e5             	mov    %rsp,%rbp
  803c24:	48 83 ec 40          	sub    $0x40,%rsp
  803c28:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c2c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c30:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c38:	48 89 c7             	mov    %rax,%rdi
  803c3b:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c53:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c5a:	00 
  803c5b:	e9 8e 00 00 00       	jmpq   803cee <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c60:	eb 31                	jmp    803c93 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c6a:	48 89 d6             	mov    %rdx,%rsi
  803c6d:	48 89 c7             	mov    %rax,%rdi
  803c70:	48 b8 03 3a 80 00 00 	movabs $0x803a03,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	85 c0                	test   %eax,%eax
  803c7e:	74 07                	je     803c87 <devpipe_write+0x67>
				return 0;
  803c80:	b8 00 00 00 00       	mov    $0x0,%eax
  803c85:	eb 79                	jmp    803d00 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c87:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803c8e:	00 00 00 
  803c91:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c97:	8b 40 04             	mov    0x4(%rax),%eax
  803c9a:	48 63 d0             	movslq %eax,%rdx
  803c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca1:	8b 00                	mov    (%rax),%eax
  803ca3:	48 98                	cltq   
  803ca5:	48 83 c0 20          	add    $0x20,%rax
  803ca9:	48 39 c2             	cmp    %rax,%rdx
  803cac:	73 b4                	jae    803c62 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb2:	8b 40 04             	mov    0x4(%rax),%eax
  803cb5:	99                   	cltd   
  803cb6:	c1 ea 1b             	shr    $0x1b,%edx
  803cb9:	01 d0                	add    %edx,%eax
  803cbb:	83 e0 1f             	and    $0x1f,%eax
  803cbe:	29 d0                	sub    %edx,%eax
  803cc0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803cc4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803cc8:	48 01 ca             	add    %rcx,%rdx
  803ccb:	0f b6 0a             	movzbl (%rdx),%ecx
  803cce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cd2:	48 98                	cltq   
  803cd4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803cd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cdc:	8b 40 04             	mov    0x4(%rax),%eax
  803cdf:	8d 50 01             	lea    0x1(%rax),%edx
  803ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ce9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cf6:	0f 82 64 ff ff ff    	jb     803c60 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d00:	c9                   	leaveq 
  803d01:	c3                   	retq   

0000000000803d02 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803d02:	55                   	push   %rbp
  803d03:	48 89 e5             	mov    %rsp,%rbp
  803d06:	48 83 ec 20          	sub    $0x20,%rsp
  803d0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803d12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d16:	48 89 c7             	mov    %rax,%rdi
  803d19:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803d20:	00 00 00 
  803d23:	ff d0                	callq  *%rax
  803d25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803d29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2d:	48 be 2e 4b 80 00 00 	movabs $0x804b2e,%rsi
  803d34:	00 00 00 
  803d37:	48 89 c7             	mov    %rax,%rdi
  803d3a:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  803d41:	00 00 00 
  803d44:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d4a:	8b 50 04             	mov    0x4(%rax),%edx
  803d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d51:	8b 00                	mov    (%rax),%eax
  803d53:	29 c2                	sub    %eax,%edx
  803d55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d59:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d63:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d6a:	00 00 00 
	stat->st_dev = &devpipe;
  803d6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d71:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803d78:	00 00 00 
  803d7b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   

0000000000803d89 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d89:	55                   	push   %rbp
  803d8a:	48 89 e5             	mov    %rsp,%rbp
  803d8d:	48 83 ec 10          	sub    $0x10,%rsp
  803d91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d99:	48 89 c6             	mov    %rax,%rsi
  803d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  803da1:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db1:	48 89 c7             	mov    %rax,%rdi
  803db4:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
  803dc0:	48 89 c6             	mov    %rax,%rsi
  803dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc8:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
}
  803dd4:	c9                   	leaveq 
  803dd5:	c3                   	retq   

0000000000803dd6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803dd6:	55                   	push   %rbp
  803dd7:	48 89 e5             	mov    %rsp,%rbp
  803dda:	48 83 ec 20          	sub    $0x20,%rsp
  803dde:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803de1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803de4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803de7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803deb:	be 01 00 00 00       	mov    $0x1,%esi
  803df0:	48 89 c7             	mov    %rax,%rdi
  803df3:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  803dfa:	00 00 00 
  803dfd:	ff d0                	callq  *%rax
}
  803dff:	c9                   	leaveq 
  803e00:	c3                   	retq   

0000000000803e01 <getchar>:

int
getchar(void)
{
  803e01:	55                   	push   %rbp
  803e02:	48 89 e5             	mov    %rsp,%rbp
  803e05:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e09:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e0d:	ba 01 00 00 00       	mov    $0x1,%edx
  803e12:	48 89 c6             	mov    %rax,%rsi
  803e15:	bf 00 00 00 00       	mov    $0x0,%edi
  803e1a:	48 b8 a5 2f 80 00 00 	movabs $0x802fa5,%rax
  803e21:	00 00 00 
  803e24:	ff d0                	callq  *%rax
  803e26:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e2d:	79 05                	jns    803e34 <getchar+0x33>
		return r;
  803e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e32:	eb 14                	jmp    803e48 <getchar+0x47>
	if (r < 1)
  803e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e38:	7f 07                	jg     803e41 <getchar+0x40>
		return -E_EOF;
  803e3a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e3f:	eb 07                	jmp    803e48 <getchar+0x47>
	return c;
  803e41:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e45:	0f b6 c0             	movzbl %al,%eax
}
  803e48:	c9                   	leaveq 
  803e49:	c3                   	retq   

0000000000803e4a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e4a:	55                   	push   %rbp
  803e4b:	48 89 e5             	mov    %rsp,%rbp
  803e4e:	48 83 ec 20          	sub    $0x20,%rsp
  803e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e5c:	48 89 d6             	mov    %rdx,%rsi
  803e5f:	89 c7                	mov    %eax,%edi
  803e61:	48 b8 73 2b 80 00 00 	movabs $0x802b73,%rax
  803e68:	00 00 00 
  803e6b:	ff d0                	callq  *%rax
  803e6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e74:	79 05                	jns    803e7b <iscons+0x31>
		return r;
  803e76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e79:	eb 1a                	jmp    803e95 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7f:	8b 10                	mov    (%rax),%edx
  803e81:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803e88:	00 00 00 
  803e8b:	8b 00                	mov    (%rax),%eax
  803e8d:	39 c2                	cmp    %eax,%edx
  803e8f:	0f 94 c0             	sete   %al
  803e92:	0f b6 c0             	movzbl %al,%eax
}
  803e95:	c9                   	leaveq 
  803e96:	c3                   	retq   

0000000000803e97 <opencons>:

int
opencons(void)
{
  803e97:	55                   	push   %rbp
  803e98:	48 89 e5             	mov    %rsp,%rbp
  803e9b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e9f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ea3:	48 89 c7             	mov    %rax,%rdi
  803ea6:	48 b8 db 2a 80 00 00 	movabs $0x802adb,%rax
  803ead:	00 00 00 
  803eb0:	ff d0                	callq  *%rax
  803eb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb9:	79 05                	jns    803ec0 <opencons+0x29>
		return r;
  803ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebe:	eb 5b                	jmp    803f1b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ec9:	48 89 c6             	mov    %rax,%rsi
  803ecc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed1:	48 b8 3d 26 80 00 00 	movabs $0x80263d,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
  803edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee4:	79 05                	jns    803eeb <opencons+0x54>
		return r;
  803ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee9:	eb 30                	jmp    803f1b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eef:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ef6:	00 00 00 
  803ef9:	8b 12                	mov    (%rdx),%edx
  803efb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803efd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f01:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0c:	48 89 c7             	mov    %rax,%rdi
  803f0f:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  803f16:	00 00 00 
  803f19:	ff d0                	callq  *%rax
}
  803f1b:	c9                   	leaveq 
  803f1c:	c3                   	retq   

0000000000803f1d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f1d:	55                   	push   %rbp
  803f1e:	48 89 e5             	mov    %rsp,%rbp
  803f21:	48 83 ec 30          	sub    $0x30,%rsp
  803f25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f2d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f31:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f36:	75 07                	jne    803f3f <devcons_read+0x22>
		return 0;
  803f38:	b8 00 00 00 00       	mov    $0x0,%eax
  803f3d:	eb 4b                	jmp    803f8a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f3f:	eb 0c                	jmp    803f4d <devcons_read+0x30>
		sys_yield();
  803f41:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803f48:	00 00 00 
  803f4b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f4d:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
  803f59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f60:	74 df                	je     803f41 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f66:	79 05                	jns    803f6d <devcons_read+0x50>
		return c;
  803f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6b:	eb 1d                	jmp    803f8a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f6d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f71:	75 07                	jne    803f7a <devcons_read+0x5d>
		return 0;
  803f73:	b8 00 00 00 00       	mov    $0x0,%eax
  803f78:	eb 10                	jmp    803f8a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7d:	89 c2                	mov    %eax,%edx
  803f7f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f83:	88 10                	mov    %dl,(%rax)
	return 1;
  803f85:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f8a:	c9                   	leaveq 
  803f8b:	c3                   	retq   

0000000000803f8c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f8c:	55                   	push   %rbp
  803f8d:	48 89 e5             	mov    %rsp,%rbp
  803f90:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f97:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f9e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fa5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fb3:	eb 76                	jmp    80402b <devcons_write+0x9f>
		m = n - tot;
  803fb5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803fbc:	89 c2                	mov    %eax,%edx
  803fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc1:	29 c2                	sub    %eax,%edx
  803fc3:	89 d0                	mov    %edx,%eax
  803fc5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803fc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fcb:	83 f8 7f             	cmp    $0x7f,%eax
  803fce:	76 07                	jbe    803fd7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fd0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fda:	48 63 d0             	movslq %eax,%rdx
  803fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe0:	48 63 c8             	movslq %eax,%rcx
  803fe3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fea:	48 01 c1             	add    %rax,%rcx
  803fed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ff4:	48 89 ce             	mov    %rcx,%rsi
  803ff7:	48 89 c7             	mov    %rax,%rdi
  803ffa:	48 b8 32 20 80 00 00 	movabs $0x802032,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804006:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804009:	48 63 d0             	movslq %eax,%rdx
  80400c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804013:	48 89 d6             	mov    %rdx,%rsi
  804016:	48 89 c7             	mov    %rax,%rdi
  804019:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804025:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804028:	01 45 fc             	add    %eax,-0x4(%rbp)
  80402b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402e:	48 98                	cltq   
  804030:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804037:	0f 82 78 ff ff ff    	jb     803fb5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80403d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804040:	c9                   	leaveq 
  804041:	c3                   	retq   

0000000000804042 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804042:	55                   	push   %rbp
  804043:	48 89 e5             	mov    %rsp,%rbp
  804046:	48 83 ec 08          	sub    $0x8,%rsp
  80404a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80404e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804053:	c9                   	leaveq 
  804054:	c3                   	retq   

0000000000804055 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804055:	55                   	push   %rbp
  804056:	48 89 e5             	mov    %rsp,%rbp
  804059:	48 83 ec 10          	sub    $0x10,%rsp
  80405d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804061:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804069:	48 be 3a 4b 80 00 00 	movabs $0x804b3a,%rsi
  804070:	00 00 00 
  804073:	48 89 c7             	mov    %rax,%rdi
  804076:	48 b8 0e 1d 80 00 00 	movabs $0x801d0e,%rax
  80407d:	00 00 00 
  804080:	ff d0                	callq  *%rax
	return 0;
  804082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 18          	sub    $0x18,%rsp
  804091:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804099:	48 c1 e8 15          	shr    $0x15,%rax
  80409d:	48 89 c2             	mov    %rax,%rdx
  8040a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040a7:	01 00 00 
  8040aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ae:	83 e0 01             	and    $0x1,%eax
  8040b1:	48 85 c0             	test   %rax,%rax
  8040b4:	75 07                	jne    8040bd <pageref+0x34>
		return 0;
  8040b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040bb:	eb 53                	jmp    804110 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040c1:	48 c1 e8 0c          	shr    $0xc,%rax
  8040c5:	48 89 c2             	mov    %rax,%rdx
  8040c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040cf:	01 00 00 
  8040d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040de:	83 e0 01             	and    $0x1,%eax
  8040e1:	48 85 c0             	test   %rax,%rax
  8040e4:	75 07                	jne    8040ed <pageref+0x64>
		return 0;
  8040e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040eb:	eb 23                	jmp    804110 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8040f5:	48 89 c2             	mov    %rax,%rdx
  8040f8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040ff:	00 00 00 
  804102:	48 c1 e2 04          	shl    $0x4,%rdx
  804106:	48 01 d0             	add    %rdx,%rax
  804109:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80410d:	0f b7 c0             	movzwl %ax,%eax
}
  804110:	c9                   	leaveq 
  804111:	c3                   	retq   
