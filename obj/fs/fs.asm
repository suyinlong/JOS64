
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 55 30 00 00       	callq  803096 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 40 66 80 00 00 	movabs $0x806640,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 57 66 80 00 00 	movabs $0x806657,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf 67 66 80 00 00 	movabs $0x806667,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 70 66 80 00 00 	movabs $0x806670,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba 7d 66 80 00 00 	movabs $0x80667d,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf 67 66 80 00 00 	movabs $0x806667,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 63                	jmp    800312 <ide_read+0x179>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 50                	jmp    80031e <ide_read+0x185>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  8002f9:	89 c8                	mov    %ecx,%eax
  8002fb:	48 89 fe             	mov    %rdi,%rsi
  8002fe:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800302:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800305:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030a:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800311:	00 
  800312:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800317:	75 96                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 83 ec 70          	sub    $0x70,%rsp
  800328:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80032f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800333:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033a:	00 
  80033b:	76 35                	jbe    800372 <ide_write+0x52>
  80033d:	48 b9 70 66 80 00 00 	movabs $0x806670,%rcx
  800344:	00 00 00 
  800347:	48 ba 7d 66 80 00 00 	movabs $0x80667d,%rdx
  80034e:	00 00 00 
  800351:	be 5c 00 00 00       	mov    $0x5c,%esi
  800356:	48 bf 67 66 80 00 00 	movabs $0x806667,%rdi
  80035d:	00 00 00 
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80036c:	00 00 00 
  80036f:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800372:	bf 00 00 00 00       	mov    $0x0,%edi
  800377:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037e:	00 00 00 
  800381:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800383:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800387:	0f b6 c0             	movzbl %al,%eax
  80038a:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800391:	88 45 f7             	mov    %al,-0x9(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800394:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800398:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039b:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80039f:	0f b6 c0             	movzbl %al,%eax
  8003a2:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003a9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ac:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b3:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b7:	c1 e8 08             	shr    $0x8,%eax
  8003ba:	0f b6 c0             	movzbl %al,%eax
  8003bd:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c4:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c7:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003ce:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003cf:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d2:	c1 e8 10             	shr    $0x10,%eax
  8003d5:	0f b6 c0             	movzbl %al,%eax
  8003d8:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003df:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e2:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003e9:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003ea:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f1:	00 00 00 
  8003f4:	8b 00                	mov    (%rax),%eax
  8003f6:	83 e0 01             	and    $0x1,%eax
  8003f9:	c1 e0 04             	shl    $0x4,%eax
  8003fc:	89 c2                	mov    %eax,%edx
  8003fe:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800401:	c1 e8 18             	shr    $0x18,%eax
  800404:	83 e0 0f             	and    $0xf,%eax
  800407:	09 d0                	or     %edx,%eax
  800409:	83 c8 e0             	or     $0xffffffe0,%eax
  80040c:	0f b6 c0             	movzbl %al,%eax
  80040f:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800416:	88 45 d7             	mov    %al,-0x29(%rbp)
  800419:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800420:	ee                   	out    %al,(%dx)
  800421:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800428:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042c:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800430:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800433:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800434:	eb 5d                	jmp    800493 <ide_write+0x173>
		if ((r = ide_wait_ready(1)) < 0)
  800436:	bf 01 00 00 00       	mov    $0x1,%edi
  80043b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800442:	00 00 00 
  800445:	ff d0                	callq  *%rax
  800447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044e:	79 05                	jns    800455 <ide_write+0x135>
			return r;
  800450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800453:	eb 4a                	jmp    80049f <ide_write+0x17f>
  800455:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800460:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800464:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%rbp)
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  80046b:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800472:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800475:	48 89 ce             	mov    %rcx,%rsi
  800478:	89 c1                	mov    %eax,%ecx
  80047a:	fc                   	cld    
  80047b:	f2 6f                	repnz outsl %ds:(%rsi),(%dx)
  80047d:	89 c8                	mov    %ecx,%eax
  80047f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800483:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800486:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800492:	00 
  800493:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800498:	75 9c                	jne    800436 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80049a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80049f:	c9                   	leaveq 
  8004a0:	c3                   	retq   

00000000008004a1 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a1:	55                   	push   %rbp
  8004a2:	48 89 e5             	mov    %rsp,%rbp
  8004a5:	48 83 ec 10          	sub    $0x10,%rsp
  8004a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004ad:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b2:	74 2a                	je     8004de <diskaddr+0x3d>
  8004b4:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004bb:	00 00 00 
  8004be:	48 8b 00             	mov    (%rax),%rax
  8004c1:	48 85 c0             	test   %rax,%rax
  8004c4:	74 4a                	je     800510 <diskaddr+0x6f>
  8004c6:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8004cd:	00 00 00 
  8004d0:	48 8b 00             	mov    (%rax),%rax
  8004d3:	8b 40 04             	mov    0x4(%rax),%eax
  8004d6:	89 c0                	mov    %eax,%eax
  8004d8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004dc:	77 32                	ja     800510 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e2:	48 89 c1             	mov    %rax,%rcx
  8004e5:	48 ba 98 66 80 00 00 	movabs $0x806698,%rdx
  8004ec:	00 00 00 
  8004ef:	be 09 00 00 00       	mov    $0x9,%esi
  8004f4:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  8004fb:	00 00 00 
  8004fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800503:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80050a:	00 00 00 
  80050d:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800514:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80051e:	c9                   	leaveq 
  80051f:	c3                   	retq   

0000000000800520 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800520:	55                   	push   %rbp
  800521:	48 89 e5             	mov    %rsp,%rbp
  800524:	48 83 ec 08          	sub    $0x8,%rsp
  800528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800530:	48 c1 e8 27          	shr    $0x27,%rax
  800534:	48 89 c2             	mov    %rax,%rdx
  800537:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80053e:	01 00 00 
  800541:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800545:	83 e0 01             	and    $0x1,%eax
  800548:	48 85 c0             	test   %rax,%rax
  80054b:	74 6a                	je     8005b7 <va_is_mapped+0x97>
  80054d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800551:	48 c1 e8 1e          	shr    $0x1e,%rax
  800555:	48 89 c2             	mov    %rax,%rdx
  800558:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80055f:	01 00 00 
  800562:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800566:	83 e0 01             	and    $0x1,%eax
  800569:	48 85 c0             	test   %rax,%rax
  80056c:	74 49                	je     8005b7 <va_is_mapped+0x97>
  80056e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800572:	48 c1 e8 15          	shr    $0x15,%rax
  800576:	48 89 c2             	mov    %rax,%rdx
  800579:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800580:	01 00 00 
  800583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800587:	83 e0 01             	and    $0x1,%eax
  80058a:	48 85 c0             	test   %rax,%rax
  80058d:	74 28                	je     8005b7 <va_is_mapped+0x97>
  80058f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800593:	48 c1 e8 0c          	shr    $0xc,%rax
  800597:	48 89 c2             	mov    %rax,%rdx
  80059a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a1:	01 00 00 
  8005a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005a8:	83 e0 01             	and    $0x1,%eax
  8005ab:	48 85 c0             	test   %rax,%rax
  8005ae:	74 07                	je     8005b7 <va_is_mapped+0x97>
  8005b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b5:	eb 05                	jmp    8005bc <va_is_mapped+0x9c>
  8005b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bc:	83 e0 01             	and    $0x1,%eax
}
  8005bf:	c9                   	leaveq 
  8005c0:	c3                   	retq   

00000000008005c1 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c1:	55                   	push   %rbp
  8005c2:	48 89 e5             	mov    %rsp,%rbp
  8005c5:	48 83 ec 08          	sub    $0x8,%rsp
  8005c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d1:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d5:	48 89 c2             	mov    %rax,%rdx
  8005d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005df:	01 00 00 
  8005e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e6:	83 e0 40             	and    $0x40,%eax
  8005e9:	48 85 c0             	test   %rax,%rax
  8005ec:	0f 95 c0             	setne  %al
}
  8005ef:	c9                   	leaveq 
  8005f0:	c3                   	retq   

00000000008005f1 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f1:	55                   	push   %rbp
  8005f2:	48 89 e5             	mov    %rsp,%rbp
  8005f5:	48 83 ec 30          	sub    $0x30,%rsp
  8005f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800601:	48 8b 00             	mov    (%rax),%rax
  800604:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060c:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800612:	48 c1 e8 0c          	shr    $0xc,%rax
  800616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061a:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800621:	0f 
  800622:	76 0b                	jbe    80062f <bc_pgfault+0x3e>
  800624:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800629:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062d:	76 4b                	jbe    80067a <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80062f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800633:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063b:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800642:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800646:	49 89 c9             	mov    %rcx,%r9
  800649:	49 89 d0             	mov    %rdx,%r8
  80064c:	48 89 c1             	mov    %rax,%rcx
  80064f:	48 ba c8 66 80 00 00 	movabs $0x8066c8,%rdx
  800656:	00 00 00 
  800659:	be 28 00 00 00       	mov    $0x28,%esi
  80065e:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800665:	00 00 00 
  800668:	b8 00 00 00 00       	mov    $0x0,%eax
  80066d:	49 ba 49 31 80 00 00 	movabs $0x803149,%r10
  800674:	00 00 00 
  800677:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067a:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800681:	00 00 00 
  800684:	48 8b 00             	mov    (%rax),%rax
  800687:	48 85 c0             	test   %rax,%rax
  80068a:	74 4a                	je     8006d6 <bc_pgfault+0xe5>
  80068c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800693:	00 00 00 
  800696:	48 8b 00             	mov    (%rax),%rax
  800699:	8b 40 04             	mov    0x4(%rax),%eax
  80069c:	89 c0                	mov    %eax,%eax
  80069e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a2:	77 32                	ja     8006d6 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a8:	48 89 c1             	mov    %rax,%rcx
  8006ab:	48 ba f8 66 80 00 00 	movabs $0x8066f8,%rdx
  8006b2:	00 00 00 
  8006b5:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006ba:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  8006c1:	00 00 00 
  8006c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c9:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8006d0:	00 00 00 
  8006d3:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8006d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if ((r = sys_page_alloc(0, addr, PTE_P | PTE_U | PTE_W)) < 0)
  8006ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f0:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f5:	48 89 c6             	mov    %rax,%rsi
  8006f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8006fd:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  800704:	00 00 00 
  800707:	ff d0                	callq  *%rax
  800709:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80070c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800710:	79 30                	jns    800742 <bc_pgfault+0x151>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  800712:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800715:	89 c1                	mov    %eax,%ecx
  800717:	48 ba 20 67 80 00 00 	movabs $0x806720,%rdx
  80071e:	00 00 00 
  800721:	be 35 00 00 00       	mov    $0x35,%esi
  800726:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  80072d:	00 00 00 
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
  800735:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80073c:	00 00 00 
  80073f:	41 ff d0             	callq  *%r8

	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800746:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80074d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800751:	ba 08 00 00 00       	mov    $0x8,%edx
  800756:	48 89 c6             	mov    %rax,%rsi
  800759:	89 cf                	mov    %ecx,%edi
  80075b:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  800762:	00 00 00 
  800765:	ff d0                	callq  *%rax
  800767:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80076a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80076e:	79 30                	jns    8007a0 <bc_pgfault+0x1af>
		panic("in bc_pgfault, ide_read: %e", r);
  800770:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800773:	89 c1                	mov    %eax,%ecx
  800775:	48 ba 42 67 80 00 00 	movabs $0x806742,%rdx
  80077c:	00 00 00 
  80077f:	be 38 00 00 00       	mov    $0x38,%esi
  800784:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  80078b:	00 00 00 
  80078e:	b8 00 00 00 00       	mov    $0x0,%eax
  800793:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80079a:	00 00 00 
  80079d:	41 ff d0             	callq  *%r8

	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8007a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8007a8:	48 89 c2             	mov    %rax,%rdx
  8007ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007b2:	01 00 00 
  8007b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8007be:	89 c1                	mov    %eax,%ecx
  8007c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c8:	41 89 c8             	mov    %ecx,%r8d
  8007cb:	48 89 d1             	mov    %rdx,%rcx
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	48 89 c6             	mov    %rax,%rsi
  8007d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8007db:	48 b8 a9 4a 80 00 00 	movabs $0x804aa9,%rax
  8007e2:	00 00 00 
  8007e5:	ff d0                	callq  *%rax
  8007e7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ee:	79 30                	jns    800820 <bc_pgfault+0x22f>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007f0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f3:	89 c1                	mov    %eax,%ecx
  8007f5:	48 ba 60 67 80 00 00 	movabs $0x806760,%rdx
  8007fc:	00 00 00 
  8007ff:	be 3b 00 00 00       	mov    $0x3b,%esi
  800804:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  80080b:	00 00 00 
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80081a:	00 00 00 
  80081d:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800820:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800827:	00 00 00 
  80082a:	48 8b 00             	mov    (%rax),%rax
  80082d:	48 85 c0             	test   %rax,%rax
  800830:	74 48                	je     80087a <bc_pgfault+0x289>
  800832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800836:	89 c7                	mov    %eax,%edi
  800838:	48 b8 7f 0d 80 00 00 	movabs $0x800d7f,%rax
  80083f:	00 00 00 
  800842:	ff d0                	callq  *%rax
  800844:	84 c0                	test   %al,%al
  800846:	74 32                	je     80087a <bc_pgfault+0x289>
		panic("reading free block %08x\n", blockno);
  800848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80084c:	48 89 c1             	mov    %rax,%rcx
  80084f:	48 ba 80 67 80 00 00 	movabs $0x806780,%rdx
  800856:	00 00 00 
  800859:	be 41 00 00 00       	mov    $0x41,%esi
  80085e:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800865:	00 00 00 
  800868:	b8 00 00 00 00       	mov    $0x0,%eax
  80086d:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800874:	00 00 00 
  800877:	41 ff d0             	callq  *%r8
}
  80087a:	c9                   	leaveq 
  80087b:	c3                   	retq   

000000000080087c <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80087c:	55                   	push   %rbp
  80087d:	48 89 e5             	mov    %rsp,%rbp
  800880:	48 83 ec 30          	sub    $0x30,%rsp
  800884:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088c:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800892:	48 c1 e8 0c          	shr    $0xc,%rax
  800896:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80089a:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  8008a1:	0f 
  8008a2:	76 0b                	jbe    8008af <flush_block+0x33>
  8008a4:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  8008a9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8008ad:	76 32                	jbe    8008e1 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  8008af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b3:	48 89 c1             	mov    %rax,%rcx
  8008b6:	48 ba 99 67 80 00 00 	movabs $0x806799,%rdx
  8008bd:	00 00 00 
  8008c0:	be 51 00 00 00       	mov    $0x51,%esi
  8008c5:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  8008cc:	00 00 00 
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d4:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8008db:	00 00 00 
  8008de:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.
	int r;
	addr = ROUNDDOWN(addr, PGSIZE);
  8008e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8008e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ed:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8008f3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  8008f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008fb:	48 89 c7             	mov    %rax,%rdi
  8008fe:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  800905:	00 00 00 
  800908:	ff d0                	callq  *%rax
  80090a:	83 f0 01             	xor    $0x1,%eax
  80090d:	84 c0                	test   %al,%al
  80090f:	75 1a                	jne    80092b <flush_block+0xaf>
  800911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800915:	48 89 c7             	mov    %rax,%rdi
  800918:	48 b8 c1 05 80 00 00 	movabs $0x8005c1,%rax
  80091f:	00 00 00 
  800922:	ff d0                	callq  *%rax
  800924:	83 f0 01             	xor    $0x1,%eax
  800927:	84 c0                	test   %al,%al
  800929:	74 05                	je     800930 <flush_block+0xb4>
		return;
  80092b:	e9 c1 00 00 00       	jmpq   8009f1 <flush_block+0x175>

	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800934:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	ba 08 00 00 00       	mov    $0x8,%edx
  800944:	48 89 c6             	mov    %rax,%rsi
  800947:	89 cf                	mov    %ecx,%edi
  800949:	48 b8 20 03 80 00 00 	movabs $0x800320,%rax
  800950:	00 00 00 
  800953:	ff d0                	callq  *%rax
  800955:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800958:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80095c:	79 30                	jns    80098e <flush_block+0x112>
		panic("in flush_block, ide_write: %e", r);
  80095e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800961:	89 c1                	mov    %eax,%ecx
  800963:	48 ba b4 67 80 00 00 	movabs $0x8067b4,%rdx
  80096a:	00 00 00 
  80096d:	be 5b 00 00 00       	mov    $0x5b,%esi
  800972:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800979:	00 00 00 
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800988:	00 00 00 
  80098b:	41 ff d0             	callq  *%r8

	//if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
	if ((r = sys_page_map(0, addr, 0, addr, PTE_USER)) < 0)
  80098e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800996:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  80099c:	48 89 d1             	mov    %rdx,%rcx
  80099f:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a4:	48 89 c6             	mov    %rax,%rsi
  8009a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8009ac:	48 b8 a9 4a 80 00 00 	movabs $0x804aa9,%rax
  8009b3:	00 00 00 
  8009b6:	ff d0                	callq  *%rax
  8009b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8009bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8009bf:	79 30                	jns    8009f1 <flush_block+0x175>
		panic("in flush_block, sys_page_map: %e", r);
  8009c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009c4:	89 c1                	mov    %eax,%ecx
  8009c6:	48 ba d8 67 80 00 00 	movabs $0x8067d8,%rdx
  8009cd:	00 00 00 
  8009d0:	be 5f 00 00 00       	mov    $0x5f,%esi
  8009d5:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  8009dc:	00 00 00 
  8009df:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e4:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8009eb:	00 00 00 
  8009ee:	41 ff d0             	callq  *%r8
	//panic("flush_block not implemented");
}
  8009f1:	c9                   	leaveq 
  8009f2:	c3                   	retq   

00000000008009f3 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009f3:	55                   	push   %rbp
  8009f4:	48 89 e5             	mov    %rsp,%rbp
  8009f7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009fe:	bf 01 00 00 00       	mov    $0x1,%edi
  800a03:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a0a:	00 00 00 
  800a0d:	ff d0                	callq  *%rax
  800a0f:	48 89 c1             	mov    %rax,%rcx
  800a12:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800a19:	ba 08 01 00 00       	mov    $0x108,%edx
  800a1e:	48 89 ce             	mov    %rcx,%rsi
  800a21:	48 89 c7             	mov    %rax,%rdi
  800a24:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  800a2b:	00 00 00 
  800a2e:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800a30:	bf 01 00 00 00       	mov    $0x1,%edi
  800a35:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a3c:	00 00 00 
  800a3f:	ff d0                	callq  *%rax
  800a41:	48 be f9 67 80 00 00 	movabs $0x8067f9,%rsi
  800a48:	00 00 00 
  800a4b:	48 89 c7             	mov    %rax,%rdi
  800a4e:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  800a55:	00 00 00 
  800a58:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5f:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 c7             	mov    %rax,%rdi
  800a6e:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800a75:	00 00 00 
  800a78:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a7a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a7f:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800a86:	00 00 00 
  800a89:	ff d0                	callq  *%rax
  800a8b:	48 89 c7             	mov    %rax,%rdi
  800a8e:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  800a95:	00 00 00 
  800a98:	ff d0                	callq  *%rax
  800a9a:	83 f0 01             	xor    $0x1,%eax
  800a9d:	84 c0                	test   %al,%al
  800a9f:	74 35                	je     800ad6 <check_bc+0xe3>
  800aa1:	48 b9 00 68 80 00 00 	movabs $0x806800,%rcx
  800aa8:	00 00 00 
  800aab:	48 ba 1a 68 80 00 00 	movabs $0x80681a,%rdx
  800ab2:	00 00 00 
  800ab5:	be 70 00 00 00       	mov    $0x70,%esi
  800aba:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800ac1:	00 00 00 
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac9:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800ad0:	00 00 00 
  800ad3:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800ad6:	bf 01 00 00 00       	mov    $0x1,%edi
  800adb:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800ae2:	00 00 00 
  800ae5:	ff d0                	callq  *%rax
  800ae7:	48 89 c7             	mov    %rax,%rdi
  800aea:	48 b8 c1 05 80 00 00 	movabs $0x8005c1,%rax
  800af1:	00 00 00 
  800af4:	ff d0                	callq  *%rax
  800af6:	84 c0                	test   %al,%al
  800af8:	74 35                	je     800b2f <check_bc+0x13c>
  800afa:	48 b9 2f 68 80 00 00 	movabs $0x80682f,%rcx
  800b01:	00 00 00 
  800b04:	48 ba 1a 68 80 00 00 	movabs $0x80681a,%rdx
  800b0b:	00 00 00 
  800b0e:	be 71 00 00 00       	mov    $0x71,%esi
  800b13:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800b1a:	00 00 00 
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800b29:	00 00 00 
  800b2c:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800b3b:	00 00 00 
  800b3e:	ff d0                	callq  *%rax
  800b40:	48 89 c6             	mov    %rax,%rsi
  800b43:	bf 00 00 00 00       	mov    $0x0,%edi
  800b48:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b54:	bf 01 00 00 00       	mov    $0x1,%edi
  800b59:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800b60:	00 00 00 
  800b63:	ff d0                	callq  *%rax
  800b65:	48 89 c7             	mov    %rax,%rdi
  800b68:	48 b8 20 05 80 00 00 	movabs $0x800520,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	callq  *%rax
  800b74:	84 c0                	test   %al,%al
  800b76:	74 35                	je     800bad <check_bc+0x1ba>
  800b78:	48 b9 49 68 80 00 00 	movabs $0x806849,%rcx
  800b7f:	00 00 00 
  800b82:	48 ba 1a 68 80 00 00 	movabs $0x80681a,%rdx
  800b89:	00 00 00 
  800b8c:	be 75 00 00 00       	mov    $0x75,%esi
  800b91:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800b98:	00 00 00 
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba0:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800ba7:	00 00 00 
  800baa:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800bad:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb2:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800bb9:	00 00 00 
  800bbc:	ff d0                	callq  *%rax
  800bbe:	48 be f9 67 80 00 00 	movabs $0x8067f9,%rsi
  800bc5:	00 00 00 
  800bc8:	48 89 c7             	mov    %rax,%rdi
  800bcb:	48 b8 8c 42 80 00 00 	movabs $0x80428c,%rax
  800bd2:	00 00 00 
  800bd5:	ff d0                	callq  *%rax
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	74 35                	je     800c10 <check_bc+0x21d>
  800bdb:	48 b9 68 68 80 00 00 	movabs $0x806868,%rcx
  800be2:	00 00 00 
  800be5:	48 ba 1a 68 80 00 00 	movabs $0x80681a,%rdx
  800bec:	00 00 00 
  800bef:	be 78 00 00 00       	mov    $0x78,%esi
  800bf4:	48 bf ba 66 80 00 00 	movabs $0x8066ba,%rdi
  800bfb:	00 00 00 
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800c0a:	00 00 00 
  800c0d:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800c10:	bf 01 00 00 00       	mov    $0x1,%edi
  800c15:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800c1c:	00 00 00 
  800c1f:	ff d0                	callq  *%rax
  800c21:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800c28:	ba 08 01 00 00       	mov    $0x108,%edx
  800c2d:	48 89 ce             	mov    %rcx,%rsi
  800c30:	48 89 c7             	mov    %rax,%rdi
  800c33:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  800c3a:	00 00 00 
  800c3d:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800c3f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c44:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800c4b:	00 00 00 
  800c4e:	ff d0                	callq  *%rax
  800c50:	48 89 c7             	mov    %rax,%rdi
  800c53:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800c5a:	00 00 00 
  800c5d:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c5f:	48 bf 8c 68 80 00 00 	movabs $0x80688c,%rdi
  800c66:	00 00 00 
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6e:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  800c75:	00 00 00 
  800c78:	ff d2                	callq  *%rdx
}
  800c7a:	c9                   	leaveq 
  800c7b:	c3                   	retq   

0000000000800c7c <bc_init>:

void
bc_init(void)
{
  800c7c:	55                   	push   %rbp
  800c7d:	48 89 e5             	mov    %rsp,%rbp
  800c80:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c87:	48 bf f1 05 80 00 00 	movabs $0x8005f1,%rdi
  800c8e:	00 00 00 
  800c91:	48 b8 c6 4c 80 00 00 	movabs $0x804cc6,%rax
  800c98:	00 00 00 
  800c9b:	ff d0                	callq  *%rax
	check_bc();
  800c9d:	48 b8 f3 09 80 00 00 	movabs $0x8009f3,%rax
  800ca4:	00 00 00 
  800ca7:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800ca9:	bf 01 00 00 00       	mov    $0x1,%edi
  800cae:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800cb5:	00 00 00 
  800cb8:	ff d0                	callq  *%rax
  800cba:	48 89 c1             	mov    %rax,%rcx
  800cbd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cc4:	ba 08 01 00 00       	mov    $0x108,%edx
  800cc9:	48 89 ce             	mov    %rcx,%rsi
  800ccc:	48 89 c7             	mov    %rax,%rdi
  800ccf:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  800cd6:	00 00 00 
  800cd9:	ff d0                	callq  *%rax
}
  800cdb:	c9                   	leaveq 
  800cdc:	c3                   	retq   

0000000000800cdd <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800cdd:	55                   	push   %rbp
  800cde:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800ce1:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800ce8:	00 00 00 
  800ceb:	48 8b 00             	mov    (%rax),%rax
  800cee:	8b 00                	mov    (%rax),%eax
  800cf0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800cf5:	74 2a                	je     800d21 <check_super+0x44>
		panic("bad file system magic number");
  800cf7:	48 ba a1 68 80 00 00 	movabs $0x8068a1,%rdx
  800cfe:	00 00 00 
  800d01:	be 0e 00 00 00       	mov    $0xe,%esi
  800d06:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  800d0d:	00 00 00 
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
  800d15:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  800d1c:	00 00 00 
  800d1f:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800d21:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d28:	00 00 00 
  800d2b:	48 8b 00             	mov    (%rax),%rax
  800d2e:	8b 40 04             	mov    0x4(%rax),%eax
  800d31:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800d36:	76 2a                	jbe    800d62 <check_super+0x85>
		panic("file system is too large");
  800d38:	48 ba c6 68 80 00 00 	movabs $0x8068c6,%rdx
  800d3f:	00 00 00 
  800d42:	be 11 00 00 00       	mov    $0x11,%esi
  800d47:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  800d4e:	00 00 00 
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  800d5d:	00 00 00 
  800d60:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d62:	48 bf df 68 80 00 00 	movabs $0x8068df,%rdi
  800d69:	00 00 00 
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  800d78:	00 00 00 
  800d7b:	ff d2                	callq  *%rdx
}
  800d7d:	5d                   	pop    %rbp
  800d7e:	c3                   	retq   

0000000000800d7f <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d7f:	55                   	push   %rbp
  800d80:	48 89 e5             	mov    %rsp,%rbp
  800d83:	48 83 ec 04          	sub    $0x4,%rsp
  800d87:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d8a:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800d91:	00 00 00 
  800d94:	48 8b 00             	mov    (%rax),%rax
  800d97:	48 85 c0             	test   %rax,%rax
  800d9a:	74 15                	je     800db1 <block_is_free+0x32>
  800d9c:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800da3:	00 00 00 
  800da6:	48 8b 00             	mov    (%rax),%rax
  800da9:	8b 40 04             	mov    0x4(%rax),%eax
  800dac:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800daf:	77 07                	ja     800db8 <block_is_free+0x39>
		return 0;
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
  800db6:	eb 41                	jmp    800df9 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800db8:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800dbf:	00 00 00 
  800dc2:	48 8b 00             	mov    (%rax),%rax
  800dc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800dc8:	c1 ea 05             	shr    $0x5,%edx
  800dcb:	89 d2                	mov    %edx,%edx
  800dcd:	48 c1 e2 02          	shl    $0x2,%rdx
  800dd1:	48 01 d0             	add    %rdx,%rax
  800dd4:	8b 10                	mov    (%rax),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dd9:	83 e0 1f             	and    $0x1f,%eax
  800ddc:	be 01 00 00 00       	mov    $0x1,%esi
  800de1:	89 c1                	mov    %eax,%ecx
  800de3:	d3 e6                	shl    %cl,%esi
  800de5:	89 f0                	mov    %esi,%eax
  800de7:	21 d0                	and    %edx,%eax
  800de9:	85 c0                	test   %eax,%eax
  800deb:	74 07                	je     800df4 <block_is_free+0x75>
		return 1;
  800ded:	b8 01 00 00 00       	mov    $0x1,%eax
  800df2:	eb 05                	jmp    800df9 <block_is_free+0x7a>
	return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df9:	c9                   	leaveq 
  800dfa:	c3                   	retq   

0000000000800dfb <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 83 ec 10          	sub    $0x10,%rsp
  800e03:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e0a:	75 2a                	jne    800e36 <free_block+0x3b>
		panic("attempt to free zero block");
  800e0c:	48 ba f3 68 80 00 00 	movabs $0x8068f3,%rdx
  800e13:	00 00 00 
  800e16:	be 2c 00 00 00       	mov    $0x2c,%esi
  800e1b:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  800e22:	00 00 00 
  800e25:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2a:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  800e31:	00 00 00 
  800e34:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800e36:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800e3d:	00 00 00 
  800e40:	48 8b 10             	mov    (%rax),%rdx
  800e43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e46:	c1 e8 05             	shr    $0x5,%eax
  800e49:	89 c1                	mov    %eax,%ecx
  800e4b:	48 c1 e1 02          	shl    $0x2,%rcx
  800e4f:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e53:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800e5a:	00 00 00 
  800e5d:	48 8b 12             	mov    (%rdx),%rdx
  800e60:	89 c0                	mov    %eax,%eax
  800e62:	48 c1 e0 02          	shl    $0x2,%rax
  800e66:	48 01 d0             	add    %rdx,%rax
  800e69:	8b 10                	mov    (%rax),%edx
  800e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e6e:	83 e0 1f             	and    $0x1f,%eax
  800e71:	bf 01 00 00 00       	mov    $0x1,%edi
  800e76:	89 c1                	mov    %eax,%ecx
  800e78:	d3 e7                	shl    %cl,%edi
  800e7a:	89 f8                	mov    %edi,%eax
  800e7c:	09 d0                	or     %edx,%eax
  800e7e:	89 06                	mov    %eax,(%rsi)
}
  800e80:	c9                   	leaveq 
  800e81:	c3                   	retq   

0000000000800e82 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800e82:	55                   	push   %rbp
  800e83:	48 89 e5             	mov    %rsp,%rbp
  800e86:	48 83 ec 10          	sub    $0x10,%rsp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e91:	e9 8b 00 00 00       	jmpq   800f21 <alloc_block+0x9f>
		if (block_is_free(blockno)) {
  800e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e99:	89 c7                	mov    %eax,%edi
  800e9b:	48 b8 7f 0d 80 00 00 	movabs $0x800d7f,%rax
  800ea2:	00 00 00 
  800ea5:	ff d0                	callq  *%rax
  800ea7:	84 c0                	test   %al,%al
  800ea9:	74 72                	je     800f1d <alloc_block+0x9b>
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  800eab:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  800eb2:	00 00 00 
  800eb5:	48 8b 10             	mov    (%rax),%rdx
  800eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ebb:	c1 e8 05             	shr    $0x5,%eax
  800ebe:	89 c1                	mov    %eax,%ecx
  800ec0:	48 c1 e1 02          	shl    $0x2,%rcx
  800ec4:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800ec8:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  800ecf:	00 00 00 
  800ed2:	48 8b 12             	mov    (%rdx),%rdx
  800ed5:	89 c0                	mov    %eax,%eax
  800ed7:	48 c1 e0 02          	shl    $0x2,%rax
  800edb:	48 01 d0             	add    %rdx,%rax
  800ede:	8b 10                	mov    (%rax),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ee3:	83 e0 1f             	and    $0x1f,%eax
  800ee6:	bf 01 00 00 00       	mov    $0x1,%edi
  800eeb:	89 c1                	mov    %eax,%ecx
  800eed:	d3 e7                	shl    %cl,%edi
  800eef:	89 f8                	mov    %edi,%eax
  800ef1:	f7 d0                	not    %eax
  800ef3:	21 d0                	and    %edx,%eax
  800ef5:	89 06                	mov    %eax,(%rsi)
			flush_block(diskaddr(blockno));
  800ef7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800efa:	48 89 c7             	mov    %rax,%rdi
  800efd:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
  800f09:	48 89 c7             	mov    %rax,%rdi
  800f0c:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800f13:	00 00 00 
  800f16:	ff d0                	callq  *%rax
			return blockno;
  800f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1b:	eb 22                	jmp    800f3f <alloc_block+0xbd>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800f1d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f21:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800f28:	00 00 00 
  800f2b:	48 8b 00             	mov    (%rax),%rax
  800f2e:	8b 40 04             	mov    0x4(%rax),%eax
  800f31:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800f34:	0f 87 5c ff ff ff    	ja     800e96 <alloc_block+0x14>
			flush_block(diskaddr(blockno));
			return blockno;
		}
	}
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
  800f3a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f3f:	c9                   	leaveq 
  800f40:	c3                   	retq   

0000000000800f41 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f41:	55                   	push   %rbp
  800f42:	48 89 e5             	mov    %rsp,%rbp
  800f45:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f50:	eb 51                	jmp    800fa3 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f55:	83 c0 02             	add    $0x2,%eax
  800f58:	89 c7                	mov    %eax,%edi
  800f5a:	48 b8 7f 0d 80 00 00 	movabs $0x800d7f,%rax
  800f61:	00 00 00 
  800f64:	ff d0                	callq  *%rax
  800f66:	84 c0                	test   %al,%al
  800f68:	74 35                	je     800f9f <check_bitmap+0x5e>
  800f6a:	48 b9 0e 69 80 00 00 	movabs $0x80690e,%rcx
  800f71:	00 00 00 
  800f74:	48 ba 22 69 80 00 00 	movabs $0x806922,%rdx
  800f7b:	00 00 00 
  800f7e:	be 57 00 00 00       	mov    $0x57,%esi
  800f83:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  800f8a:	00 00 00 
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f92:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  800f99:	00 00 00 
  800f9c:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f9f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa6:	c1 e0 0f             	shl    $0xf,%eax
  800fa9:	89 c2                	mov    %eax,%edx
  800fab:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  800fb2:	00 00 00 
  800fb5:	48 8b 00             	mov    (%rax),%rax
  800fb8:	8b 40 04             	mov    0x4(%rax),%eax
  800fbb:	39 c2                	cmp    %eax,%edx
  800fbd:	72 93                	jb     800f52 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800fbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc4:	48 b8 7f 0d 80 00 00 	movabs $0x800d7f,%rax
  800fcb:	00 00 00 
  800fce:	ff d0                	callq  *%rax
  800fd0:	84 c0                	test   %al,%al
  800fd2:	74 35                	je     801009 <check_bitmap+0xc8>
  800fd4:	48 b9 37 69 80 00 00 	movabs $0x806937,%rcx
  800fdb:	00 00 00 
  800fde:	48 ba 22 69 80 00 00 	movabs $0x806922,%rdx
  800fe5:	00 00 00 
  800fe8:	be 5a 00 00 00       	mov    $0x5a,%esi
  800fed:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  800ff4:	00 00 00 
  800ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffc:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  801003:	00 00 00 
  801006:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  801009:	bf 01 00 00 00       	mov    $0x1,%edi
  80100e:	48 b8 7f 0d 80 00 00 	movabs $0x800d7f,%rax
  801015:	00 00 00 
  801018:	ff d0                	callq  *%rax
  80101a:	84 c0                	test   %al,%al
  80101c:	74 35                	je     801053 <check_bitmap+0x112>
  80101e:	48 b9 49 69 80 00 00 	movabs $0x806949,%rcx
  801025:	00 00 00 
  801028:	48 ba 22 69 80 00 00 	movabs $0x806922,%rdx
  80102f:	00 00 00 
  801032:	be 5b 00 00 00       	mov    $0x5b,%esi
  801037:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  80103e:	00 00 00 
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80104d:	00 00 00 
  801050:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801053:	48 bf 5b 69 80 00 00 	movabs $0x80695b,%rdi
  80105a:	00 00 00 
  80105d:	b8 00 00 00 00       	mov    $0x0,%eax
  801062:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  801069:	00 00 00 
  80106c:	ff d2                	callq  *%rdx
}
  80106e:	c9                   	leaveq 
  80106f:	c3                   	retq   

0000000000801070 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  801070:	55                   	push   %rbp
  801071:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  801074:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  80107b:	00 00 00 
  80107e:	ff d0                	callq  *%rax
  801080:	84 c0                	test   %al,%al
  801082:	74 13                	je     801097 <fs_init+0x27>
		ide_set_disk(1);
  801084:	bf 01 00 00 00       	mov    $0x1,%edi
  801089:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  801090:	00 00 00 
  801093:	ff d0                	callq  *%rax
  801095:	eb 11                	jmp    8010a8 <fs_init+0x38>
	else
		ide_set_disk(0);
  801097:	bf 00 00 00 00       	mov    $0x0,%edi
  80109c:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax

	bc_init();
  8010a8:	48 b8 7c 0c 80 00 00 	movabs $0x800c7c,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010b4:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b9:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  8010c0:	00 00 00 
  8010c3:	ff d0                	callq  *%rax
  8010c5:	48 ba 10 20 81 00 00 	movabs $0x812010,%rdx
  8010cc:	00 00 00 
  8010cf:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  8010d2:	48 b8 dd 0c 80 00 00 	movabs $0x800cdd,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8010de:	bf 02 00 00 00       	mov    $0x2,%edi
  8010e3:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  8010ea:	00 00 00 
  8010ed:	ff d0                	callq  *%rax
  8010ef:	48 ba 08 20 81 00 00 	movabs $0x812008,%rdx
  8010f6:	00 00 00 
  8010f9:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  8010fc:	48 b8 41 0f 80 00 00 	movabs $0x800f41,%rax
  801103:	00 00 00 
  801106:	ff d0                	callq  *%rax
}
  801108:	5d                   	pop    %rbp
  801109:	c3                   	retq   

000000000080110a <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 83 ec 20          	sub    $0x20,%rsp
  801112:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801116:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801119:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80111d:	89 c8                	mov    %ecx,%eax
  80111f:	88 45 f0             	mov    %al,-0x10(%rbp)
	// LAB 5: Your code here.
	if (filebno >= NDIRECT + NINDIRECT)
  801122:	81 7d f4 09 04 00 00 	cmpl   $0x409,-0xc(%rbp)
  801129:	76 0a                	jbe    801135 <file_block_walk+0x2b>
		return -E_INVAL;
  80112b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801130:	e9 eb 00 00 00       	jmpq   801220 <file_block_walk+0x116>

	if (filebno < NDIRECT) {
  801135:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  801139:	77 2b                	ja     801166 <file_block_walk+0x5c>
		*ppdiskbno = &f->f_direct[filebno];
  80113b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113e:	48 83 c0 20          	add    $0x20,%rax
  801142:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801149:	00 
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114e:	48 01 d0             	add    %rdx,%rax
  801151:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
  801161:	e9 ba 00 00 00       	jmpq   801220 <file_block_walk+0x116>
	}

	if (f->f_indirect == 0) {
  801166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116a:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801170:	85 c0                	test   %eax,%eax
  801172:	75 76                	jne    8011ea <file_block_walk+0xe0>
		if (alloc == 0)
  801174:	0f b6 45 f0          	movzbl -0x10(%rbp),%eax
  801178:	83 f0 01             	xor    $0x1,%eax
  80117b:	84 c0                	test   %al,%al
  80117d:	74 0a                	je     801189 <file_block_walk+0x7f>
			return -E_NOT_FOUND;
  80117f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801184:	e9 97 00 00 00       	jmpq   801220 <file_block_walk+0x116>
		if ((f->f_indirect = alloc_block()) == 0)
  801189:	48 b8 82 0e 80 00 00 	movabs $0x800e82,%rax
  801190:	00 00 00 
  801193:	ff d0                	callq  *%rax
  801195:	89 c2                	mov    %eax,%edx
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
  8011a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a5:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	75 07                	jne    8011b6 <file_block_walk+0xac>
			return -E_NO_DISK;
  8011af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011b4:	eb 6a                	jmp    801220 <file_block_walk+0x116>
		memset(diskaddr(f->f_indirect), 0, BLKSIZE);
  8011b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ba:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011c0:	89 c0                	mov    %eax,%eax
  8011c2:	48 89 c7             	mov    %rax,%rdi
  8011c5:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  8011cc:	00 00 00 
  8011cf:	ff d0                	callq  *%rax
  8011d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011d6:	be 00 00 00 00       	mov    $0x0,%esi
  8011db:	48 89 c7             	mov    %rax,%rdi
  8011de:	48 b8 c3 43 80 00 00 	movabs $0x8043c3,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax
	}

	// note: diskaddr is 32-bit and our JOS is 64-bit, be careful about the pointers
	*ppdiskbno = &((uint32_t *)(diskaddr(f->f_indirect)))[filebno - NDIRECT];
  8011ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ee:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011f4:	89 c0                	mov    %eax,%eax
  8011f6:	48 89 c7             	mov    %rax,%rdi
  8011f9:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801200:	00 00 00 
  801203:	ff d0                	callq  *%rax
  801205:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801208:	83 ea 0a             	sub    $0xa,%edx
  80120b:	89 d2                	mov    %edx,%edx
  80120d:	48 c1 e2 02          	shl    $0x2,%rdx
  801211:	48 01 c2             	add    %rax,%rdx
  801214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801218:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_block_walk not implemented");
}
  801220:	c9                   	leaveq 
  801221:	c3                   	retq   

0000000000801222 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801222:	55                   	push   %rbp
  801223:	48 89 e5             	mov    %rsp,%rbp
  801226:	53                   	push   %rbx
  801227:	48 83 ec 38          	sub    $0x38,%rsp
  80122b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80122f:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  801232:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// LAB 5: Your code here.
	int r;
	uint32_t *pdiskbno;

	if ((r = file_block_walk(f, filebno, &pdiskbno, 1)) < 0)
  801236:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80123a:	8b 75 d4             	mov    -0x2c(%rbp),%esi
  80123d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801241:	b9 01 00 00 00       	mov    $0x1,%ecx
  801246:	48 89 c7             	mov    %rax,%rdi
  801249:	48 b8 0a 11 80 00 00 	movabs $0x80110a,%rax
  801250:	00 00 00 
  801253:	ff d0                	callq  *%rax
  801255:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801258:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80125c:	79 05                	jns    801263 <file_get_block+0x41>
		return r;
  80125e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801261:	eb 4c                	jmp    8012af <file_get_block+0x8d>

	if (*pdiskbno == 0)
  801263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801267:	8b 00                	mov    (%rax),%eax
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 1f                	jne    80128c <file_get_block+0x6a>
		if ((*pdiskbno = alloc_block()) == 0)
  80126d:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
  801271:	48 b8 82 0e 80 00 00 	movabs $0x800e82,%rax
  801278:	00 00 00 
  80127b:	ff d0                	callq  *%rax
  80127d:	89 03                	mov    %eax,(%rbx)
  80127f:	8b 03                	mov    (%rbx),%eax
  801281:	85 c0                	test   %eax,%eax
  801283:	75 07                	jne    80128c <file_get_block+0x6a>
			return -E_NO_DISK;
  801285:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80128a:	eb 23                	jmp    8012af <file_get_block+0x8d>

	*blk = diskaddr(*pdiskbno);
  80128c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801290:	8b 00                	mov    (%rax),%eax
  801292:	89 c0                	mov    %eax,%eax
  801294:	48 89 c7             	mov    %rax,%rdi
  801297:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  80129e:	00 00 00 
  8012a1:	ff d0                	callq  *%rax
  8012a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012a7:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  8012aa:	b8 00 00 00 00       	mov    $0x0,%eax
	//panic("file_get_block not implemented");
}
  8012af:	48 83 c4 38          	add    $0x38,%rsp
  8012b3:	5b                   	pop    %rbx
  8012b4:	5d                   	pop    %rbp
  8012b5:	c3                   	retq   

00000000008012b6 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8012b6:	55                   	push   %rbp
  8012b7:	48 89 e5             	mov    %rsp,%rbp
  8012ba:	48 83 ec 40          	sub    $0x40,%rsp
  8012be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8012c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8012c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8012ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ce:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012d4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 35                	je     801312 <dir_lookup+0x5c>
  8012dd:	48 b9 6b 69 80 00 00 	movabs $0x80696b,%rcx
  8012e4:	00 00 00 
  8012e7:	48 ba 22 69 80 00 00 	movabs $0x806922,%rdx
  8012ee:	00 00 00 
  8012f1:	be d1 00 00 00       	mov    $0xd1,%esi
  8012f6:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  8012fd:	00 00 00 
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80130c:	00 00 00 
  80130f:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801316:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80131c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801322:	85 c0                	test   %eax,%eax
  801324:	0f 48 c2             	cmovs  %edx,%eax
  801327:	c1 f8 0c             	sar    $0xc,%eax
  80132a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801334:	e9 93 00 00 00       	jmpq   8013cc <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801339:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80133d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801344:	89 ce                	mov    %ecx,%esi
  801346:	48 89 c7             	mov    %rax,%rdi
  801349:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
  801355:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801358:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80135c:	79 05                	jns    801363 <dir_lookup+0xad>
			return r;
  80135e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801361:	eb 7a                	jmp    8013dd <dir_lookup+0x127>
		f = (struct File*) blk;
  801363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801367:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80136b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801372:	eb 4e                	jmp    8013c2 <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  801374:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801377:	48 c1 e0 08          	shl    $0x8,%rax
  80137b:	48 89 c2             	mov    %rax,%rdx
  80137e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801382:	48 01 d0             	add    %rdx,%rax
  801385:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801389:	48 89 d6             	mov    %rdx,%rsi
  80138c:	48 89 c7             	mov    %rax,%rdi
  80138f:	48 b8 8c 42 80 00 00 	movabs $0x80428c,%rax
  801396:	00 00 00 
  801399:	ff d0                	callq  *%rax
  80139b:	85 c0                	test   %eax,%eax
  80139d:	75 1f                	jne    8013be <dir_lookup+0x108>
				*file = &f[j];
  80139f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013a2:	48 c1 e0 08          	shl    $0x8,%rax
  8013a6:	48 89 c2             	mov    %rax,%rdx
  8013a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ad:	48 01 c2             	add    %rax,%rdx
  8013b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013b4:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 1f                	jmp    8013dd <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8013be:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8013c2:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8013c6:	76 ac                	jbe    801374 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8013c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013cf:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8013d2:	0f 82 61 ff ff ff    	jb     801339 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  8013d8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 30          	sub    $0x30,%rsp
  8013e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8013ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f3:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013f9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	74 35                	je     801437 <dir_alloc_file+0x58>
  801402:	48 b9 6b 69 80 00 00 	movabs $0x80696b,%rcx
  801409:	00 00 00 
  80140c:	48 ba 22 69 80 00 00 	movabs $0x806922,%rdx
  801413:	00 00 00 
  801416:	be ea 00 00 00       	mov    $0xea,%esi
  80141b:	48 bf be 68 80 00 00 	movabs $0x8068be,%rdi
  801422:	00 00 00 
  801425:	b8 00 00 00 00       	mov    $0x0,%eax
  80142a:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  801431:	00 00 00 
  801434:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801441:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801447:	85 c0                	test   %eax,%eax
  801449:	0f 48 c2             	cmovs  %edx,%eax
  80144c:	c1 f8 0c             	sar    $0xc,%eax
  80144f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801459:	e9 83 00 00 00       	jmpq   8014e1 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80145e:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801462:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	89 ce                	mov    %ecx,%esi
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  801475:	00 00 00 
  801478:	ff d0                	callq  *%rax
  80147a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80147d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801481:	79 08                	jns    80148b <dir_alloc_file+0xac>
			return r;
  801483:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801486:	e9 be 00 00 00       	jmpq   801549 <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  80148b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801493:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80149a:	eb 3b                	jmp    8014d7 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  80149c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80149f:	48 c1 e0 08          	shl    $0x8,%rax
  8014a3:	48 89 c2             	mov    %rax,%rdx
  8014a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014aa:	48 01 d0             	add    %rdx,%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	84 c0                	test   %al,%al
  8014b2:	75 1f                	jne    8014d3 <dir_alloc_file+0xf4>
				*file = &f[j];
  8014b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b7:	48 c1 e0 08          	shl    $0x8,%rax
  8014bb:	48 89 c2             	mov    %rax,%rdx
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	48 01 c2             	add    %rax,%rdx
  8014c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c9:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d1:	eb 76                	jmp    801549 <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014d3:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014d7:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8014db:	76 bf                	jbe    80149c <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8014dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8014e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8014e7:	0f 82 71 ff ff ff    	jb     80145e <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014f7:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8014fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801501:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801507:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80150b:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	89 ce                	mov    %ecx,%esi
  801514:	48 89 c7             	mov    %rax,%rdi
  801517:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  80151e:	00 00 00 
  801521:	ff d0                	callq  *%rax
  801523:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801526:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80152a:	79 05                	jns    801531 <dir_alloc_file+0x152>
		return r;
  80152c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80152f:	eb 18                	jmp    801549 <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801535:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801539:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801541:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	48 83 ec 08          	sub    $0x8,%rsp
  801553:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801557:	eb 05                	jmp    80155e <skip_slash+0x13>
		p++;
  801559:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80155e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801562:	0f b6 00             	movzbl (%rax),%eax
  801565:	3c 2f                	cmp    $0x2f,%al
  801567:	74 f0                	je     801559 <skip_slash+0xe>
		p++;
	return p;
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80156d:	c9                   	leaveq 
  80156e:	c3                   	retq   

000000000080156f <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  80156f:	55                   	push   %rbp
  801570:	48 89 e5             	mov    %rsp,%rbp
  801573:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80157a:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  801581:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801588:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  80158f:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801596:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80159d:	48 89 c7             	mov    %rax,%rdi
  8015a0:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  8015a7:	00 00 00 
  8015aa:	ff d0                	callq  *%rax
  8015ac:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8015b3:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  8015ba:	00 00 00 
  8015bd:	48 8b 00             	mov    (%rax),%rax
  8015c0:	48 83 c0 08          	add    $0x8,%rax
  8015c4:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8015cb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015d2:	00 
	name[0] = 0;
  8015d3:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8015da:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8015e1:	00 
  8015e2:	74 0e                	je     8015f2 <walk_path+0x83>
		*pdir = 0;
  8015e4:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8015eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  8015f2:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8015f9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801600:	e9 73 01 00 00       	jmpq   801778 <walk_path+0x209>
		dir = f;
  801605:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80160c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801610:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801617:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  80161b:	eb 08                	jmp    801625 <walk_path+0xb6>
			path++;
  80161d:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801624:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801625:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 2f                	cmp    $0x2f,%al
  801631:	74 0e                	je     801641 <walk_path+0xd2>
  801633:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	84 c0                	test   %al,%al
  80163f:	75 dc                	jne    80161d <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  801641:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164c:	48 29 c2             	sub    %rax,%rdx
  80164f:	48 89 d0             	mov    %rdx,%rax
  801652:	48 83 f8 7f          	cmp    $0x7f,%rax
  801656:	7e 0a                	jle    801662 <walk_path+0xf3>
			return -E_BAD_PATH;
  801658:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80165d:	e9 56 01 00 00       	jmpq   8017b8 <walk_path+0x249>
		memmove(name, p, path - p);
  801662:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166d:	48 29 c2             	sub    %rax,%rdx
  801670:	48 89 d0             	mov    %rdx,%rax
  801673:	48 89 c2             	mov    %rax,%rdx
  801676:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80167a:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  801681:	48 89 ce             	mov    %rcx,%rsi
  801684:	48 89 c7             	mov    %rax,%rdi
  801687:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  80168e:	00 00 00 
  801691:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  801693:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80169a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169e:	48 29 c2             	sub    %rax,%rdx
  8016a1:	48 89 d0             	mov    %rdx,%rax
  8016a4:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8016ab:	00 
		path = skip_slash(path);
  8016ac:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016b3:	48 89 c7             	mov    %rax,%rdi
  8016b6:	48 b8 4b 15 80 00 00 	movabs $0x80154b,%rax
  8016bd:	00 00 00 
  8016c0:	ff d0                	callq  *%rax
  8016c2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8016c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cd:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8016d3:	83 f8 01             	cmp    $0x1,%eax
  8016d6:	74 0a                	je     8016e2 <walk_path+0x173>
			return -E_NOT_FOUND;
  8016d8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8016dd:	e9 d6 00 00 00       	jmpq   8017b8 <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8016e2:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8016e9:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  8016f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f4:	48 89 ce             	mov    %rcx,%rsi
  8016f7:	48 89 c7             	mov    %rax,%rdi
  8016fa:	48 b8 b6 12 80 00 00 	movabs $0x8012b6,%rax
  801701:	00 00 00 
  801704:	ff d0                	callq  *%rax
  801706:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801709:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80170d:	79 69                	jns    801778 <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  80170f:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801713:	75 5e                	jne    801773 <walk_path+0x204>
  801715:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	84 c0                	test   %al,%al
  801721:	75 50                	jne    801773 <walk_path+0x204>
				if (pdir)
  801723:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80172a:	00 
  80172b:	74 0e                	je     80173b <walk_path+0x1cc>
					*pdir = dir;
  80172d:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801734:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801738:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  80173b:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801742:	00 
  801743:	74 20                	je     801765 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801745:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80174c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801753:	48 89 d6             	mov    %rdx,%rsi
  801756:	48 89 c7             	mov    %rax,%rdi
  801759:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  801760:	00 00 00 
  801763:	ff d0                	callq  *%rax
				*pf = 0;
  801765:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80176c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  801773:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801776:	eb 40                	jmp    8017b8 <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801778:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	84 c0                	test   %al,%al
  801784:	0f 85 7b fe ff ff    	jne    801605 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  80178a:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801791:	00 
  801792:	74 0e                	je     8017a2 <walk_path+0x233>
		*pdir = dir;
  801794:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80179b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80179f:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8017a2:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8017a9:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8017b0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b8:	c9                   	leaveq 
  8017b9:	c3                   	retq   

00000000008017ba <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8017ba:	55                   	push   %rbp
  8017bb:	48 89 e5             	mov    %rsp,%rbp
  8017be:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8017c5:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8017cc:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8017d3:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8017da:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8017e1:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8017e8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8017ef:	48 89 c7             	mov    %rax,%rdi
  8017f2:	48 b8 6f 15 80 00 00 	movabs $0x80156f,%rax
  8017f9:	00 00 00 
  8017fc:	ff d0                	callq  *%rax
  8017fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801805:	75 0a                	jne    801811 <file_create+0x57>
		return -E_FILE_EXISTS;
  801807:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80180c:	e9 91 00 00 00       	jmpq   8018a2 <file_create+0xe8>
	if (r != -E_NOT_FOUND || dir == 0)
  801811:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801815:	75 0c                	jne    801823 <file_create+0x69>
  801817:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80181e:	48 85 c0             	test   %rax,%rax
  801821:	75 05                	jne    801828 <file_create+0x6e>
		return r;
  801823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801826:	eb 7a                	jmp    8018a2 <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801828:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80182f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801836:	48 89 d6             	mov    %rdx,%rsi
  801839:	48 89 c7             	mov    %rax,%rdi
  80183c:	48 b8 df 13 80 00 00 	movabs $0x8013df,%rax
  801843:	00 00 00 
  801846:	ff d0                	callq  *%rax
  801848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80184b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80184f:	79 05                	jns    801856 <file_create+0x9c>
		return r;
  801851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801854:	eb 4c                	jmp    8018a2 <file_create+0xe8>
	strcpy(f->f_name, name);
  801856:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80185d:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801864:	48 89 d6             	mov    %rdx,%rsi
  801867:	48 89 c7             	mov    %rax,%rdi
  80186a:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  801871:	00 00 00 
  801874:	ff d0                	callq  *%rax
	*pf = f;
  801876:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80187d:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801884:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801887:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80188e:	48 89 c7             	mov    %rax,%rdi
  801891:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  801898:	00 00 00 
  80189b:	ff d0                	callq  *%rax
	return 0;
  80189d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a2:	c9                   	leaveq 
  8018a3:	c3                   	retq   

00000000008018a4 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8018a4:	55                   	push   %rbp
  8018a5:	48 89 e5             	mov    %rsp,%rbp
  8018a8:	48 83 ec 10          	sub    $0x10,%rsp
  8018ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8018b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c1:	be 00 00 00 00       	mov    $0x0,%esi
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 b8 6f 15 80 00 00 	movabs $0x80156f,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 60          	sub    $0x60,%rsp
  8018df:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8018e3:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8018e7:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8018eb:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8018ee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018f2:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018f8:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8018fb:	7f 0a                	jg     801907 <file_read+0x30>
		return 0;
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801902:	e9 24 01 00 00       	jmpq   801a2b <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  801907:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80190b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80190f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801913:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801919:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  80191c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80191f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801922:	48 63 d0             	movslq %eax,%rdx
  801925:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801929:	48 39 c2             	cmp    %rax,%rdx
  80192c:	48 0f 46 c2          	cmovbe %rdx,%rax
  801930:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801934:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193a:	e9 cd 00 00 00       	jmpq   801a0c <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  80193f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801942:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801948:	85 c0                	test   %eax,%eax
  80194a:	0f 48 c2             	cmovs  %edx,%eax
  80194d:	c1 f8 0c             	sar    $0xc,%eax
  801950:	89 c1                	mov    %eax,%ecx
  801952:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801956:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80195a:	89 ce                	mov    %ecx,%esi
  80195c:	48 89 c7             	mov    %rax,%rdi
  80195f:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
  80196b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80196e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801972:	79 08                	jns    80197c <file_read+0xa5>
			return r;
  801974:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801977:	e9 af 00 00 00       	jmpq   801a2b <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80197c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197f:	99                   	cltd   
  801980:	c1 ea 14             	shr    $0x14,%edx
  801983:	01 d0                	add    %edx,%eax
  801985:	25 ff 0f 00 00       	and    $0xfff,%eax
  80198a:	29 d0                	sub    %edx,%eax
  80198c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801991:	29 c2                	sub    %eax,%edx
  801993:	89 d0                	mov    %edx,%eax
  801995:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801998:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80199b:	48 63 d0             	movslq %eax,%rdx
  80199e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019a2:	48 01 c2             	add    %rax,%rdx
  8019a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a8:	48 98                	cltq   
  8019aa:	48 29 c2             	sub    %rax,%rdx
  8019ad:	48 89 d0             	mov    %rdx,%rax
  8019b0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8019b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019b7:	48 63 d0             	movslq %eax,%rdx
  8019ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019be:	48 39 c2             	cmp    %rax,%rdx
  8019c1:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019c5:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  8019c8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019cb:	48 63 c8             	movslq %eax,%rcx
  8019ce:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8019d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d5:	99                   	cltd   
  8019d6:	c1 ea 14             	shr    $0x14,%edx
  8019d9:	01 d0                	add    %edx,%eax
  8019db:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019e0:	29 d0                	sub    %edx,%eax
  8019e2:	48 98                	cltq   
  8019e4:	48 01 c6             	add    %rax,%rsi
  8019e7:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019eb:	48 89 ca             	mov    %rcx,%rdx
  8019ee:	48 89 c7             	mov    %rax,%rdi
  8019f1:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  8019f8:	00 00 00 
  8019fb:	ff d0                	callq  *%rax
		pos += bn;
  8019fd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a00:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801a03:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a06:	48 98                	cltq   
  801a08:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0f:	48 98                	cltq   
  801a11:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801a14:	48 63 ca             	movslq %edx,%rcx
  801a17:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801a1b:	48 01 ca             	add    %rcx,%rdx
  801a1e:	48 39 d0             	cmp    %rdx,%rax
  801a21:	0f 82 18 ff ff ff    	jb     80193f <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801a27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 50          	sub    $0x50,%rsp
  801a35:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801a39:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801a3d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801a41:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801a44:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a47:	48 63 d0             	movslq %eax,%rdx
  801a4a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a4e:	48 01 c2             	add    %rax,%rdx
  801a51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a55:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a5b:	48 98                	cltq   
  801a5d:	48 39 c2             	cmp    %rax,%rdx
  801a60:	76 33                	jbe    801a95 <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801a62:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a66:	89 c2                	mov    %eax,%edx
  801a68:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a6b:	01 d0                	add    %edx,%eax
  801a6d:	89 c2                	mov    %eax,%edx
  801a6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a73:	89 d6                	mov    %edx,%esi
  801a75:	48 89 c7             	mov    %rax,%rdi
  801a78:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
  801a84:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a87:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801a8b:	79 08                	jns    801a95 <file_write+0x68>
			return r;
  801a8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a90:	e9 f8 00 00 00       	jmpq   801b8d <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801a95:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a9b:	e9 ce 00 00 00       	jmpq   801b6e <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa3:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	0f 48 c2             	cmovs  %edx,%eax
  801aae:	c1 f8 0c             	sar    $0xc,%eax
  801ab1:	89 c1                	mov    %eax,%ecx
  801ab3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ab7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801abb:	89 ce                	mov    %ecx,%esi
  801abd:	48 89 c7             	mov    %rax,%rdi
  801ac0:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  801ac7:	00 00 00 
  801aca:	ff d0                	callq  *%rax
  801acc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801acf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ad3:	79 08                	jns    801add <file_write+0xb0>
			return r;
  801ad5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad8:	e9 b0 00 00 00       	jmpq   801b8d <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae0:	99                   	cltd   
  801ae1:	c1 ea 14             	shr    $0x14,%edx
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	25 ff 0f 00 00       	and    $0xfff,%eax
  801aeb:	29 d0                	sub    %edx,%eax
  801aed:	ba 00 10 00 00       	mov    $0x1000,%edx
  801af2:	29 c2                	sub    %eax,%edx
  801af4:	89 d0                	mov    %edx,%eax
  801af6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801af9:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801afc:	48 63 d0             	movslq %eax,%rdx
  801aff:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b03:	48 01 c2             	add    %rax,%rdx
  801b06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b09:	48 98                	cltq   
  801b0b:	48 29 c2             	sub    %rax,%rdx
  801b0e:	48 89 d0             	mov    %rdx,%rax
  801b11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b15:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b18:	48 63 d0             	movslq %eax,%rdx
  801b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b1f:	48 39 c2             	cmp    %rax,%rdx
  801b22:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b26:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801b29:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b2c:	48 63 c8             	movslq %eax,%rcx
  801b2f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b36:	99                   	cltd   
  801b37:	c1 ea 14             	shr    $0x14,%edx
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b41:	29 d0                	sub    %edx,%eax
  801b43:	48 98                	cltq   
  801b45:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801b49:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b4d:	48 89 ca             	mov    %rcx,%rdx
  801b50:	48 89 c6             	mov    %rax,%rsi
  801b53:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
		pos += bn;
  801b5f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b62:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b65:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b68:	48 98                	cltq   
  801b6a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b71:	48 98                	cltq   
  801b73:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801b76:	48 63 ca             	movslq %edx,%rcx
  801b79:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b7d:	48 01 ca             	add    %rcx,%rdx
  801b80:	48 39 d0             	cmp    %rdx,%rax
  801b83:	0f 82 17 ff ff ff    	jb     801aa0 <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b89:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801b8d:	c9                   	leaveq 
  801b8e:	c3                   	retq   

0000000000801b8f <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	48 83 ec 20          	sub    $0x20,%rsp
  801b97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b9b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801b9e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ba2:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bae:	48 89 c7             	mov    %rax,%rdi
  801bb1:	48 b8 0a 11 80 00 00 	movabs $0x80110a,%rax
  801bb8:	00 00 00 
  801bbb:	ff d0                	callq  *%rax
  801bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc4:	79 05                	jns    801bcb <file_free_block+0x3c>
		return r;
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	eb 2d                	jmp    801bf8 <file_free_block+0x69>
	if (*ptr) {
  801bcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bcf:	8b 00                	mov    (%rax),%eax
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	74 1e                	je     801bf3 <file_free_block+0x64>
		free_block(*ptr);
  801bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd9:	8b 00                	mov    (%rax),%eax
  801bdb:	89 c7                	mov    %eax,%edi
  801bdd:	48 b8 fb 0d 80 00 00 	movabs $0x800dfb,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
		*ptr = 0;
  801be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bed:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf8:	c9                   	leaveq 
  801bf9:	c3                   	retq   

0000000000801bfa <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	48 83 ec 20          	sub    $0x20,%rsp
  801c02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c06:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801c13:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c18:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	0f 48 c2             	cmovs  %edx,%eax
  801c23:	c1 f8 0c             	sar    $0xc,%eax
  801c26:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801c29:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c2c:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c31:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c37:	85 c0                	test   %eax,%eax
  801c39:	0f 48 c2             	cmovs  %edx,%eax
  801c3c:	c1 f8 0c             	sar    $0xc,%eax
  801c3f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c42:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c48:	eb 45                	jmp    801c8f <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801c4a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	48 89 c7             	mov    %rax,%rdi
  801c56:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	callq  *%rax
  801c62:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c65:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c69:	79 20                	jns    801c8b <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801c6b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c6e:	89 c6                	mov    %eax,%esi
  801c70:	48 bf 88 69 80 00 00 	movabs $0x806988,%rdi
  801c77:	00 00 00 
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  801c86:	00 00 00 
  801c89:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c8b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801c95:	72 b3                	jb     801c4a <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801c97:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801c9b:	77 34                	ja     801cd1 <file_truncate_blocks+0xd7>
  801c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca1:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	74 26                	je     801cd1 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801caf:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801cb5:	89 c7                	mov    %eax,%edi
  801cb7:	48 b8 fb 0d 80 00 00 	movabs $0x800dfb,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc7:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801cce:	00 00 00 
	}
}
  801cd1:	c9                   	leaveq 
  801cd2:	c3                   	retq   

0000000000801cd3 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801cd3:	55                   	push   %rbp
  801cd4:	48 89 e5             	mov    %rsp,%rbp
  801cd7:	48 83 ec 10          	sub    $0x10,%rsp
  801cdb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cdf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801ce2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce6:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801cec:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801cef:	7e 18                	jle    801d09 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801cf1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cf4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf8:	89 d6                	mov    %edx,%esi
  801cfa:	48 89 c7             	mov    %rax,%rdi
  801cfd:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  801d04:	00 00 00 
  801d07:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d10:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801d16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1a:	48 89 c7             	mov    %rax,%rdi
  801d1d:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801d24:	00 00 00 
  801d27:	ff d0                	callq  *%rax
	return 0;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2e:	c9                   	leaveq 
  801d2f:	c3                   	retq   

0000000000801d30 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801d30:	55                   	push   %rbp
  801d31:	48 89 e5             	mov    %rsp,%rbp
  801d34:	48 83 ec 20          	sub    $0x20,%rsp
  801d38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d43:	eb 62                	jmp    801da7 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d45:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d50:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d55:	48 89 c7             	mov    %rax,%rdi
  801d58:	48 b8 0a 11 80 00 00 	movabs $0x80110a,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	callq  *%rax
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 13                	js     801d7b <file_flush+0x4b>
			pdiskbno == NULL || *pdiskbno == 0)
  801d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d6c:	48 85 c0             	test   %rax,%rax
  801d6f:	74 0a                	je     801d7b <file_flush+0x4b>
			pdiskbno == NULL || *pdiskbno == 0)
  801d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d75:	8b 00                	mov    (%rax),%eax
  801d77:	85 c0                	test   %eax,%eax
  801d79:	75 02                	jne    801d7d <file_flush+0x4d>
			continue;
  801d7b:	eb 26                	jmp    801da3 <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d81:	8b 00                	mov    (%rax),%eax
  801d83:	89 c0                	mov    %eax,%eax
  801d85:	48 89 c7             	mov    %rax,%rdi
  801d88:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
  801d94:	48 89 c7             	mov    %rax,%rdi
  801d97:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801d9e:	00 00 00 
  801da1:	ff d0                	callq  *%rax
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801da3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dab:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801db1:	05 ff 0f 00 00       	add    $0xfff,%eax
  801db6:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 48 c2             	cmovs  %edx,%eax
  801dc1:	c1 f8 0c             	sar    $0xc,%eax
  801dc4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801dc7:	0f 8f 78 ff ff ff    	jg     801d45 <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
			pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd1:	48 89 c7             	mov    %rax,%rdi
  801dd4:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801ddb:	00 00 00 
  801dde:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de4:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801dea:	85 c0                	test   %eax,%eax
  801dec:	74 2a                	je     801e18 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df2:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801df8:	89 c0                	mov    %eax,%eax
  801dfa:	48 89 c7             	mov    %rax,%rdi
  801dfd:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	callq  *%rax
  801e09:	48 89 c7             	mov    %rax,%rdi
  801e0c:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	callq  *%rax
}
  801e18:	c9                   	leaveq 
  801e19:	c3                   	retq   

0000000000801e1a <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
  801e1e:	48 83 ec 20          	sub    $0x20,%rsp
  801e22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801e26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e33:	be 00 00 00 00       	mov    $0x0,%esi
  801e38:	48 89 c7             	mov    %rax,%rdi
  801e3b:	48 b8 6f 15 80 00 00 	movabs $0x80156f,%rax
  801e42:	00 00 00 
  801e45:	ff d0                	callq  *%rax
  801e47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4e:	79 05                	jns    801e55 <file_remove+0x3b>
		return r;
  801e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e53:	eb 45                	jmp    801e9a <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
  801e5e:	48 89 c7             	mov    %rax,%rdi
  801e61:	48 b8 fa 1b 80 00 00 	movabs $0x801bfa,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e71:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e78:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801e7f:	00 00 00 
	flush_block(f);
  801e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e86:	48 89 c7             	mov    %rax,%rdi
  801e89:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801e90:	00 00 00 
  801e93:	ff d0                	callq  *%rax

	return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801ea4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801eab:	eb 27                	jmp    801ed4 <fs_sync+0x38>
		flush_block(diskaddr(i));
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	48 98                	cltq   
  801eb2:	48 89 c7             	mov    %rax,%rdi
  801eb5:	48 b8 a1 04 80 00 00 	movabs $0x8004a1,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	48 89 c7             	mov    %rax,%rdi
  801ec4:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801ed0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ed4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ed7:	48 b8 10 20 81 00 00 	movabs $0x812010,%rax
  801ede:	00 00 00 
  801ee1:	48 8b 00             	mov    (%rax),%rax
  801ee4:	8b 40 04             	mov    0x4(%rax),%eax
  801ee7:	39 c2                	cmp    %eax,%edx
  801ee9:	72 c2                	jb     801ead <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801eeb:	c9                   	leaveq 
  801eec:	c3                   	retq   

0000000000801eed <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801eed:	55                   	push   %rbp
  801eee:	48 89 e5             	mov    %rsp,%rbp
  801ef1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801ef5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801efa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f05:	eb 4b                	jmp    801f52 <serve_init+0x65>
		opentab[i].o_fileid = i;
  801f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0a:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801f11:	00 00 00 
  801f14:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f17:	48 63 c9             	movslq %ecx,%rcx
  801f1a:	48 c1 e1 05          	shl    $0x5,%rcx
  801f1e:	48 01 ca             	add    %rcx,%rdx
  801f21:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f27:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801f2e:	00 00 00 
  801f31:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f34:	48 63 c9             	movslq %ecx,%rcx
  801f37:	48 c1 e1 05          	shl    $0x5,%rcx
  801f3b:	48 01 ca             	add    %rcx,%rdx
  801f3e:	48 83 c2 10          	add    $0x10,%rdx
  801f42:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801f46:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801f4d:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801f4e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f52:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f59:	7e ac                	jle    801f07 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f5b:	c9                   	leaveq 
  801f5c:	c3                   	retq   

0000000000801f5d <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f5d:	55                   	push   %rbp
  801f5e:	48 89 e5             	mov    %rsp,%rbp
  801f61:	48 83 ec 20          	sub    $0x20,%rsp
  801f65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f70:	e9 24 01 00 00       	jmpq   802099 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  801f75:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801f7c:	00 00 00 
  801f7f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f82:	48 63 d2             	movslq %edx,%rdx
  801f85:	48 c1 e2 05          	shl    $0x5,%rdx
  801f89:	48 01 d0             	add    %rdx,%rax
  801f8c:	48 83 c0 10          	add    $0x10,%rax
  801f90:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f94:	48 89 c7             	mov    %rax,%rdi
  801f97:	48 b8 1e 5d 80 00 00 	movabs $0x805d1e,%rax
  801f9e:	00 00 00 
  801fa1:	ff d0                	callq  *%rax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	74 0a                	je     801fb1 <openfile_alloc+0x54>
  801fa7:	83 f8 01             	cmp    $0x1,%eax
  801faa:	74 4e                	je     801ffa <openfile_alloc+0x9d>
  801fac:	e9 e4 00 00 00       	jmpq   802095 <openfile_alloc+0x138>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801fb1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801fb8:	00 00 00 
  801fbb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fbe:	48 63 d2             	movslq %edx,%rdx
  801fc1:	48 c1 e2 05          	shl    $0x5,%rdx
  801fc5:	48 01 d0             	add    %rdx,%rax
  801fc8:	48 83 c0 10          	add    $0x10,%rax
  801fcc:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fd0:	ba 07 00 00 00       	mov    $0x7,%edx
  801fd5:	48 89 c6             	mov    %rax,%rsi
  801fd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdd:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801fec:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ff0:	79 08                	jns    801ffa <openfile_alloc+0x9d>
				return r;
  801ff2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ff5:	e9 b1 00 00 00       	jmpq   8020ab <openfile_alloc+0x14e>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801ffa:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802001:	00 00 00 
  802004:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802007:	48 63 d2             	movslq %edx,%rdx
  80200a:	48 c1 e2 05          	shl    $0x5,%rdx
  80200e:	48 01 d0             	add    %rdx,%rax
  802011:	8b 00                	mov    (%rax),%eax
  802013:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802019:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802020:	00 00 00 
  802023:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802026:	48 63 c9             	movslq %ecx,%rcx
  802029:	48 c1 e1 05          	shl    $0x5,%rcx
  80202d:	48 01 c8             	add    %rcx,%rax
  802030:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802035:	48 98                	cltq   
  802037:	48 c1 e0 05          	shl    $0x5,%rax
  80203b:	48 89 c2             	mov    %rax,%rdx
  80203e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802045:	00 00 00 
  802048:	48 01 c2             	add    %rax,%rdx
  80204b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204f:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802052:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802059:	00 00 00 
  80205c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80205f:	48 63 d2             	movslq %edx,%rdx
  802062:	48 c1 e2 05          	shl    $0x5,%rdx
  802066:	48 01 d0             	add    %rdx,%rax
  802069:	48 83 c0 10          	add    $0x10,%rax
  80206d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802071:	ba 00 10 00 00       	mov    $0x1000,%edx
  802076:	be 00 00 00 00       	mov    $0x0,%esi
  80207b:	48 89 c7             	mov    %rax,%rdi
  80207e:	48 b8 c3 43 80 00 00 	movabs $0x8043c3,%rax
  802085:	00 00 00 
  802088:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  80208a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208e:	48 8b 00             	mov    (%rax),%rax
  802091:	8b 00                	mov    (%rax),%eax
  802093:	eb 16                	jmp    8020ab <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802095:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802099:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8020a0:	0f 8e cf fe ff ff    	jle    801f75 <openfile_alloc+0x18>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8020a6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020ab:	c9                   	leaveq 
  8020ac:	c3                   	retq   

00000000008020ad <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8020ad:	55                   	push   %rbp
  8020ae:	48 89 e5             	mov    %rsp,%rbp
  8020b1:	48 83 ec 20          	sub    $0x20,%rsp
  8020b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8020bb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8020bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020c7:	89 c0                	mov    %eax,%eax
  8020c9:	48 c1 e0 05          	shl    $0x5,%rax
  8020cd:	48 89 c2             	mov    %rax,%rdx
  8020d0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020d7:	00 00 00 
  8020da:	48 01 d0             	add    %rdx,%rax
  8020dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8020e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020e9:	48 89 c7             	mov    %rax,%rdi
  8020ec:	48 b8 1e 5d 80 00 00 	movabs $0x805d1e,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax
  8020f8:	83 f8 01             	cmp    $0x1,%eax
  8020fb:	74 0b                	je     802108 <openfile_lookup+0x5b>
  8020fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802101:	8b 00                	mov    (%rax),%eax
  802103:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802106:	74 07                	je     80210f <openfile_lookup+0x62>
		return -E_INVAL;
  802108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80210d:	eb 10                	jmp    80211f <openfile_lookup+0x72>
	*po = o;
  80210f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802113:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802117:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211f:	c9                   	leaveq 
  802120:	c3                   	retq   

0000000000802121 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  802121:	55                   	push   %rbp
  802122:	48 89 e5             	mov    %rsp,%rbp
  802125:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  80212c:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  802132:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802139:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  802140:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802147:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80214e:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802155:	ba 00 04 00 00       	mov    $0x400,%edx
  80215a:	48 89 ce             	mov    %rcx,%rsi
  80215d:	48 89 c7             	mov    %rax,%rdi
  802160:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  80216c:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  802170:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802177:	48 89 c7             	mov    %rax,%rdi
  80217a:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
  802186:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218d:	79 08                	jns    802197 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  80218f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802192:	e9 7c 01 00 00       	jmpq   802313 <serve_open+0x1f2>
	}
	fileid = r;
  802197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  80219d:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8021a4:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8021aa:	25 00 01 00 00       	and    $0x100,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	74 4f                	je     802202 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  8021b3:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8021ba:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8021c1:	48 89 d6             	mov    %rdx,%rsi
  8021c4:	48 89 c7             	mov    %rax,%rdi
  8021c7:	48 b8 ba 17 80 00 00 	movabs $0x8017ba,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	callq  *%rax
  8021d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021da:	79 57                	jns    802233 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8021dc:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8021e3:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8021e9:	25 00 04 00 00       	and    $0x400,%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	75 08                	jne    8021fa <serve_open+0xd9>
  8021f2:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8021f6:	75 02                	jne    8021fa <serve_open+0xd9>
				goto try_open;
  8021f8:	eb 08                	jmp    802202 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8021fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fd:	e9 11 01 00 00       	jmpq   802313 <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  802202:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802209:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802210:	48 89 d6             	mov    %rdx,%rsi
  802213:	48 89 c7             	mov    %rax,%rdi
  802216:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802225:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802229:	79 08                	jns    802233 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  80222b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222e:	e9 e0 00 00 00       	jmpq   802313 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  802233:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80223a:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802240:	25 00 02 00 00       	and    $0x200,%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 2c                	je     802275 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802249:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  802250:	be 00 00 00 00       	mov    $0x0,%esi
  802255:	48 89 c7             	mov    %rax,%rdi
  802258:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
  802264:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802267:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226b:	79 08                	jns    802275 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  80226d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802270:	e9 9e 00 00 00       	jmpq   802313 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802275:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80227c:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802283:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802287:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80228e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802292:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802299:	8b 12                	mov    (%rdx),%edx
  80229b:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80229e:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022a9:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8022b0:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8022b6:	83 e2 03             	and    $0x3,%edx
  8022b9:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8022bc:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022c3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022c7:	48 ba c0 10 81 00 00 	movabs $0x8110c0,%rdx
  8022ce:	00 00 00 
  8022d1:	8b 12                	mov    (%rdx),%edx
  8022d3:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  8022d5:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022dc:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8022e3:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8022e9:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8022ec:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022f3:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8022f7:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8022fe:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802301:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802308:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802313:	c9                   	leaveq 
  802314:	c3                   	retq   

0000000000802315 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  802315:	55                   	push   %rbp
  802316:	48 89 e5             	mov    %rsp,%rbp
  802319:	48 83 ec 20          	sub    $0x20,%rsp
  80231d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802320:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802324:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802328:	8b 00                	mov    (%rax),%eax
  80232a:	89 c1                	mov    %eax,%ecx
  80232c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802330:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802333:	89 ce                	mov    %ecx,%esi
  802335:	89 c7                	mov    %eax,%edi
  802337:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  80233e:	00 00 00 
  802341:	ff d0                	callq  *%rax
  802343:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802346:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234a:	79 05                	jns    802351 <serve_set_size+0x3c>
		return r;
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	eb 20                	jmp    802371 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802355:	8b 50 04             	mov    0x4(%rax),%edx
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802360:	89 d6                	mov    %edx,%esi
  802362:	48 89 c7             	mov    %rax,%rdi
  802365:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  80236c:	00 00 00 
  80236f:	ff d0                	callq  *%rax
}
  802371:	c9                   	leaveq 
  802372:	c3                   	retq   

0000000000802373 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  802373:	55                   	push   %rbp
  802374:	48 89 e5             	mov    %rsp,%rbp
  802377:	48 83 ec 40          	sub    $0x40,%rsp
  80237b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80237e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  802382:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802386:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  80238a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80238e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//
	// LAB 5: Your code here
	struct OpenFile *o;
	int r, size;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802396:	8b 00                	mov    (%rax),%eax
  802398:	89 c1                	mov    %eax,%ecx
  80239a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80239e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8023a1:	89 ce                	mov    %ecx,%esi
  8023a3:	89 c7                	mov    %eax,%edi
  8023a5:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  8023ac:	00 00 00 
  8023af:	ff d0                	callq  *%rax
  8023b1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8023b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023b8:	79 05                	jns    8023bf <serve_read+0x4c>
		return r;
  8023ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8023bd:	eb 73                	jmp    802432 <serve_read+0xbf>

	size = req->req_n;
  8023bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (size > PGSIZE)
  8023ca:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8023d1:	7e 07                	jle    8023da <serve_read+0x67>
		size = PGSIZE;
  8023d3:	c7 45 fc 00 10 00 00 	movl   $0x1000,-0x4(%rbp)

	if ((r = file_read(o->o_file, ret->ret_buf, size, o->o_fd->fd_offset)) < 0)
  8023da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023de:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023e2:	8b 48 04             	mov    0x4(%rax),%ecx
  8023e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e8:	48 63 d0             	movslq %eax,%rdx
  8023eb:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  8023ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023f7:	48 89 c7             	mov    %rax,%rdi
  8023fa:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  802401:	00 00 00 
  802404:	ff d0                	callq  *%rax
  802406:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802409:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80240d:	79 05                	jns    802414 <serve_read+0xa1>
		return r;
  80240f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802412:	eb 1e                	jmp    802432 <serve_read+0xbf>

	o->o_fd->fd_offset += r;
  802414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802418:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802420:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802424:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802427:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80242a:	01 ca                	add    %ecx,%edx
  80242c:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  80242f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	//panic("serve_read not implemented");
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 20          	sub    $0x20,%rsp
  80243c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80243f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)

	// LAB 5: Your code here.
	struct OpenFile *o;
	int r, size;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802443:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802447:	8b 00                	mov    (%rax),%eax
  802449:	89 c1                	mov    %eax,%ecx
  80244b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80244f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802452:	89 ce                	mov    %ecx,%esi
  802454:	89 c7                	mov    %eax,%edi
  802456:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax
  802462:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802465:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802469:	79 08                	jns    802473 <serve_write+0x3f>
		return r;
  80246b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80246e:	e9 b7 00 00 00       	jmpq   80252a <serve_write+0xf6>

	size = req->req_n;
  802473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802477:	48 8b 40 08          	mov    0x8(%rax),%rax
  80247b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (size > PGSIZE)
  80247e:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802485:	7e 07                	jle    80248e <serve_write+0x5a>
		size = PGSIZE;
  802487:	c7 45 fc 00 10 00 00 	movl   $0x1000,-0x4(%rbp)

	if (o->o_file->f_size < o->o_fd->fd_offset + size)
  80248e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802492:	48 8b 40 08          	mov    0x8(%rax),%rax
  802496:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80249c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a4:	8b 48 04             	mov    0x4(%rax),%ecx
  8024a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024aa:	01 c8                	add    %ecx,%eax
  8024ac:	39 c2                	cmp    %eax,%edx
  8024ae:	7d 1e                	jge    8024ce <serve_write+0x9a>
		o->o_file->f_size = o->o_fd->fd_offset + size;
  8024b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024bc:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8024c0:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8024c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024c6:	01 ca                	add    %ecx,%edx
  8024c8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)

	if ((r = file_write(o->o_file, req->req_buf, size, o->o_fd->fd_offset)) < 0)
  8024ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d6:	8b 48 04             	mov    0x4(%rax),%ecx
  8024d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024dc:	48 63 d0             	movslq %eax,%rdx
  8024df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e3:	48 8d 70 10          	lea    0x10(%rax),%rsi
  8024e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024ef:	48 89 c7             	mov    %rax,%rdi
  8024f2:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8024f9:	00 00 00 
  8024fc:	ff d0                	callq  *%rax
  8024fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802501:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802505:	79 05                	jns    80250c <serve_write+0xd8>
		return r;
  802507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80250a:	eb 1e                	jmp    80252a <serve_write+0xf6>

	o->o_fd->fd_offset += r;
  80250c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802510:	48 8b 40 18          	mov    0x18(%rax),%rax
  802514:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802518:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  80251c:	8b 4a 04             	mov    0x4(%rdx),%ecx
  80251f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802522:	01 ca                	add    %ecx,%edx
  802524:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  802527:	8b 45 f8             	mov    -0x8(%rbp),%eax
	//panic("serve_write not implemented");
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  80252c:	55                   	push   %rbp
  80252d:	48 89 e5             	mov    %rsp,%rbp
  802530:	48 83 ec 30          	sub    $0x30,%rsp
  802534:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802537:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  80253b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  802543:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802547:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254f:	8b 00                	mov    (%rax),%eax
  802551:	89 c1                	mov    %eax,%ecx
  802553:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802557:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80255a:	89 ce                	mov    %ecx,%esi
  80255c:	89 c7                	mov    %eax,%edi
  80255e:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  802565:	00 00 00 
  802568:	ff d0                	callq  *%rax
  80256a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80256d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802571:	79 05                	jns    802578 <serve_stat+0x4c>
		return r;
  802573:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802576:	eb 5f                	jmp    8025d7 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  802578:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80257c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802580:	48 89 c2             	mov    %rax,%rdx
  802583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802587:	48 89 d6             	mov    %rdx,%rsi
  80258a:	48 89 c7             	mov    %rax,%rdi
  80258d:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  802594:	00 00 00 
  802597:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  802599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259d:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025a1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8025a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ab:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8025b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025b9:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8025bf:	83 f8 01             	cmp    $0x1,%eax
  8025c2:	0f 94 c0             	sete   %al
  8025c5:	0f b6 d0             	movzbl %al,%edx
  8025c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   

00000000008025d9 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8025d9:	55                   	push   %rbp
  8025da:	48 89 e5             	mov    %rsp,%rbp
  8025dd:	48 83 ec 20          	sub    $0x20,%rsp
  8025e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ec:	8b 00                	mov    (%rax),%eax
  8025ee:	89 c1                	mov    %eax,%ecx
  8025f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f7:	89 ce                	mov    %ecx,%esi
  8025f9:	89 c7                	mov    %eax,%edi
  8025fb:	48 b8 ad 20 80 00 00 	movabs $0x8020ad,%rax
  802602:	00 00 00 
  802605:	ff d0                	callq  *%rax
  802607:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260e:	79 05                	jns    802615 <serve_flush+0x3c>
		return r;
  802610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802613:	eb 1c                	jmp    802631 <serve_flush+0x58>
	file_flush(o->o_file);
  802615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802619:	48 8b 40 08          	mov    0x8(%rax),%rax
  80261d:	48 89 c7             	mov    %rax,%rdi
  802620:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
	return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802631:	c9                   	leaveq 
  802632:	c3                   	retq   

0000000000802633 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  802633:	55                   	push   %rbp
  802634:	48 89 e5             	mov    %rsp,%rbp
  802637:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  80263e:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  802644:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80264b:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802652:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802659:	ba 00 04 00 00       	mov    $0x400,%edx
  80265e:	48 89 ce             	mov    %rcx,%rsi
  802661:	48 89 c7             	mov    %rax,%rdi
  802664:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  80266b:	00 00 00 
  80266e:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802670:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802674:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  80267b:	48 89 c7             	mov    %rax,%rdi
  80267e:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
}
  80268a:	c9                   	leaveq 
  80268b:	c3                   	retq   

000000000080268c <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  80268c:	55                   	push   %rbp
  80268d:	48 89 e5             	mov    %rsp,%rbp
  802690:	48 83 ec 10          	sub    $0x10,%rsp
  802694:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802697:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  80269b:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	callq  *%rax
	return 0;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8026b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8026bd:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8026c4:	00 00 00 
  8026c7:	48 8b 08             	mov    (%rax),%rcx
  8026ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ce:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8026d2:	48 89 ce             	mov    %rcx,%rsi
  8026d5:	48 89 c7             	mov    %rax,%rdi
  8026d8:	48 b8 bb 4d 80 00 00 	movabs $0x804dbb,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
  8026e4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8026e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026ea:	83 e0 01             	and    $0x1,%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	75 23                	jne    802714 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  8026f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026f4:	89 c6                	mov    %eax,%esi
  8026f6:	48 bf a8 69 80 00 00 	movabs $0x8069a8,%rdi
  8026fd:	00 00 00 
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  80270c:	00 00 00 
  80270f:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  802711:	90                   	nop
			cprintf("Invalid request code %d from %08x\n", req, whom);
			r = -E_INVAL;
		}
		ipc_send(whom, r, pg, perm);
		sys_page_unmap(0, fsreq);
	}
  802712:	eb a2                	jmp    8026b6 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  802714:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80271b:	00 
		if (req == FSREQ_OPEN) {
  80271c:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  802720:	75 2b                	jne    80274d <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  802722:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802729:	00 00 00 
  80272c:	48 8b 30             	mov    (%rax),%rsi
  80272f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802732:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  802736:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80273a:	89 c7                	mov    %eax,%edi
  80273c:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  802743:	00 00 00 
  802746:	ff d0                	callq  *%rax
  802748:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274b:	eb 73                	jmp    8027c0 <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  80274d:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  802751:	77 43                	ja     802796 <serve+0xe8>
  802753:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  80275a:	00 00 00 
  80275d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802760:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802764:	48 85 c0             	test   %rax,%rax
  802767:	74 2d                	je     802796 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  802769:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802770:	00 00 00 
  802773:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802776:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277a:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  802781:	00 00 00 
  802784:	48 8b 0a             	mov    (%rdx),%rcx
  802787:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80278a:	48 89 ce             	mov    %rcx,%rsi
  80278d:	89 d7                	mov    %edx,%edi
  80278f:	ff d0                	callq  *%rax
  802791:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802794:	eb 2a                	jmp    8027c0 <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802796:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802799:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80279c:	89 c6                	mov    %eax,%esi
  80279e:	48 bf d8 69 80 00 00 	movabs $0x8069d8,%rdi
  8027a5:	00 00 00 
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ad:	48 b9 82 33 80 00 00 	movabs $0x803382,%rcx
  8027b4:	00 00 00 
  8027b7:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  8027b9:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  8027c0:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8027c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027c7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	48 b8 84 4e 80 00 00 	movabs $0x804e84,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
		sys_page_unmap(0, fsreq);
  8027db:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8027e2:	00 00 00 
  8027e5:	48 8b 00             	mov    (%rax),%rax
  8027e8:	48 89 c6             	mov    %rax,%rsi
  8027eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f0:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
	}
  8027fc:	e9 b5 fe ff ff       	jmpq   8026b6 <serve+0x8>

0000000000802801 <umain>:
}

void
umain(int argc, char **argv)
{
  802801:	55                   	push   %rbp
  802802:	48 89 e5             	mov    %rsp,%rbp
  802805:	48 83 ec 20          	sub    $0x20,%rsp
  802809:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80280c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  802810:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  802817:	00 00 00 
  80281a:	48 b9 fb 69 80 00 00 	movabs $0x8069fb,%rcx
  802821:	00 00 00 
  802824:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  802827:	48 bf fe 69 80 00 00 	movabs $0x8069fe,%rdi
  80282e:	00 00 00 
  802831:	b8 00 00 00 00       	mov    $0x0,%eax
  802836:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  80283d:	00 00 00 
  802840:	ff d2                	callq  *%rdx
  802842:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802849:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80284f:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802853:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802856:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802858:	48 bf 0d 6a 80 00 00 	movabs $0x806a0d,%rdi
  80285f:	00 00 00 
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  80286e:	00 00 00 
  802871:	ff d2                	callq  *%rdx

	serve_init();
  802873:	48 b8 ed 1e 80 00 00 	movabs $0x801eed,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
	fs_init();
  80287f:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
	fs_test();
  80288b:	48 b8 a5 28 80 00 00 	movabs $0x8028a5,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
	serve();
  802897:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
}
  8028a3:	c9                   	leaveq 
  8028a4:	c3                   	retq   

00000000008028a5 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8028a5:	55                   	push   %rbp
  8028a6:	48 89 e5             	mov    %rsp,%rbp
  8028a9:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8028ad:	ba 07 00 00 00       	mov    $0x7,%edx
  8028b2:	be 00 10 00 00       	mov    $0x1000,%esi
  8028b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bc:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
  8028c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cf:	79 30                	jns    802901 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  8028d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d4:	89 c1                	mov    %eax,%ecx
  8028d6:	48 ba 46 6a 80 00 00 	movabs $0x806a46,%rdx
  8028dd:	00 00 00 
  8028e0:	be 13 00 00 00       	mov    $0x13,%esi
  8028e5:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  8028ec:	00 00 00 
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8028fb:	00 00 00 
  8028fe:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802901:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802908:	00 
	memmove(bits, bitmap, PGSIZE);
  802909:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  802910:	00 00 00 
  802913:	48 8b 08             	mov    (%rax),%rcx
  802916:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80291f:	48 89 ce             	mov    %rcx,%rsi
  802922:	48 89 c7             	mov    %rax,%rdi
  802925:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802931:	48 b8 82 0e 80 00 00 	movabs $0x800e82,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
  80293d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802940:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802944:	79 30                	jns    802976 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802946:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802949:	89 c1                	mov    %eax,%ecx
  80294b:	48 ba 63 6a 80 00 00 	movabs $0x806a63,%rdx
  802952:	00 00 00 
  802955:	be 18 00 00 00       	mov    $0x18,%esi
  80295a:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802961:	00 00 00 
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
  802969:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802970:	00 00 00 
  802973:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802979:	8d 50 1f             	lea    0x1f(%rax),%edx
  80297c:	85 c0                	test   %eax,%eax
  80297e:	0f 48 c2             	cmovs  %edx,%eax
  802981:	c1 f8 05             	sar    $0x5,%eax
  802984:	48 98                	cltq   
  802986:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80298d:	00 
  80298e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802992:	48 01 d0             	add    %rdx,%rax
  802995:	8b 30                	mov    (%rax),%esi
  802997:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299a:	99                   	cltd   
  80299b:	c1 ea 1b             	shr    $0x1b,%edx
  80299e:	01 d0                	add    %edx,%eax
  8029a0:	83 e0 1f             	and    $0x1f,%eax
  8029a3:	29 d0                	sub    %edx,%eax
  8029a5:	ba 01 00 00 00       	mov    $0x1,%edx
  8029aa:	89 c1                	mov    %eax,%ecx
  8029ac:	d3 e2                	shl    %cl,%edx
  8029ae:	89 d0                	mov    %edx,%eax
  8029b0:	21 f0                	and    %esi,%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	75 35                	jne    8029eb <fs_test+0x146>
  8029b6:	48 b9 73 6a 80 00 00 	movabs $0x806a73,%rcx
  8029bd:	00 00 00 
  8029c0:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  8029c7:	00 00 00 
  8029ca:	be 1a 00 00 00       	mov    $0x1a,%esi
  8029cf:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  8029d6:	00 00 00 
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  8029e5:	00 00 00 
  8029e8:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8029eb:	48 b8 08 20 81 00 00 	movabs $0x812008,%rax
  8029f2:	00 00 00 
  8029f5:	48 8b 10             	mov    (%rax),%rdx
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fb:	8d 48 1f             	lea    0x1f(%rax),%ecx
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	0f 48 c1             	cmovs  %ecx,%eax
  802a03:	c1 f8 05             	sar    $0x5,%eax
  802a06:	48 98                	cltq   
  802a08:	48 c1 e0 02          	shl    $0x2,%rax
  802a0c:	48 01 d0             	add    %rdx,%rax
  802a0f:	8b 30                	mov    (%rax),%esi
  802a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a14:	99                   	cltd   
  802a15:	c1 ea 1b             	shr    $0x1b,%edx
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	83 e0 1f             	and    $0x1f,%eax
  802a1d:	29 d0                	sub    %edx,%eax
  802a1f:	ba 01 00 00 00       	mov    $0x1,%edx
  802a24:	89 c1                	mov    %eax,%ecx
  802a26:	d3 e2                	shl    %cl,%edx
  802a28:	89 d0                	mov    %edx,%eax
  802a2a:	21 f0                	and    %esi,%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 35                	je     802a65 <fs_test+0x1c0>
  802a30:	48 b9 a8 6a 80 00 00 	movabs $0x806aa8,%rcx
  802a37:	00 00 00 
  802a3a:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802a41:	00 00 00 
  802a44:	be 1c 00 00 00       	mov    $0x1c,%esi
  802a49:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802a50:	00 00 00 
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
  802a58:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802a5f:	00 00 00 
  802a62:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802a65:	48 bf c8 6a 80 00 00 	movabs $0x806ac8,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  802a7b:	00 00 00 
  802a7e:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802a80:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a84:	48 89 c6             	mov    %rax,%rsi
  802a87:	48 bf dd 6a 80 00 00 	movabs $0x806add,%rdi
  802a8e:	00 00 00 
  802a91:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  802a98:	00 00 00 
  802a9b:	ff d0                	callq  *%rax
  802a9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa4:	79 36                	jns    802adc <fs_test+0x237>
  802aa6:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802aaa:	74 30                	je     802adc <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aaf:	89 c1                	mov    %eax,%ecx
  802ab1:	48 ba e8 6a 80 00 00 	movabs $0x806ae8,%rdx
  802ab8:	00 00 00 
  802abb:	be 20 00 00 00       	mov    $0x20,%esi
  802ac0:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802ac7:	00 00 00 
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
  802acf:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802ad6:	00 00 00 
  802ad9:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802adc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae0:	75 2a                	jne    802b0c <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802ae2:	48 ba 08 6b 80 00 00 	movabs $0x806b08,%rdx
  802ae9:	00 00 00 
  802aec:	be 22 00 00 00       	mov    $0x22,%esi
  802af1:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802af8:	00 00 00 
  802afb:	b8 00 00 00 00       	mov    $0x0,%eax
  802b00:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  802b07:	00 00 00 
  802b0a:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802b0c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b10:	48 89 c6             	mov    %rax,%rsi
  802b13:	48 bf 28 6b 80 00 00 	movabs $0x806b28,%rdi
  802b1a:	00 00 00 
  802b1d:	48 b8 a4 18 80 00 00 	movabs $0x8018a4,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	callq  *%rax
  802b29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b30:	79 30                	jns    802b62 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b35:	89 c1                	mov    %eax,%ecx
  802b37:	48 ba 31 6b 80 00 00 	movabs $0x806b31,%rdx
  802b3e:	00 00 00 
  802b41:	be 24 00 00 00       	mov    $0x24,%esi
  802b46:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802b4d:	00 00 00 
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802b5c:	00 00 00 
  802b5f:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802b62:	48 bf 48 6b 80 00 00 	movabs $0x806b48,%rdi
  802b69:	00 00 00 
  802b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b71:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  802b78:	00 00 00 
  802b7b:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b81:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802b85:	be 00 00 00 00       	mov    $0x0,%esi
  802b8a:	48 89 c7             	mov    %rax,%rdi
  802b8d:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  802b94:	00 00 00 
  802b97:	ff d0                	callq  *%rax
  802b99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba0:	79 30                	jns    802bd2 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba5:	89 c1                	mov    %eax,%ecx
  802ba7:	48 ba 5b 6b 80 00 00 	movabs $0x806b5b,%rdx
  802bae:	00 00 00 
  802bb1:	be 28 00 00 00       	mov    $0x28,%esi
  802bb6:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802bbd:	00 00 00 
  802bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc5:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802bcc:	00 00 00 
  802bcf:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802bd2:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802bd9:	00 00 00 
  802bdc:	48 8b 10             	mov    (%rax),%rdx
  802bdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be3:	48 89 d6             	mov    %rdx,%rsi
  802be6:	48 89 c7             	mov    %rax,%rdi
  802be9:	48 b8 8c 42 80 00 00 	movabs $0x80428c,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 2a                	je     802c23 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802bf9:	48 ba 70 6b 80 00 00 	movabs $0x806b70,%rdx
  802c00:	00 00 00 
  802c03:	be 2a 00 00 00       	mov    $0x2a,%esi
  802c08:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802c0f:	00 00 00 
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
  802c17:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  802c1e:	00 00 00 
  802c21:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802c23:	48 bf 93 6b 80 00 00 	movabs $0x806b93,%rdi
  802c2a:	00 00 00 
  802c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c32:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  802c39:	00 00 00 
  802c3c:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802c3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c46:	0f b6 12             	movzbl (%rdx),%edx
  802c49:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802c4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c4f:	48 c1 e8 0c          	shr    $0xc,%rax
  802c53:	48 89 c2             	mov    %rax,%rdx
  802c56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c5d:	01 00 00 
  802c60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c64:	83 e0 40             	and    $0x40,%eax
  802c67:	48 85 c0             	test   %rax,%rax
  802c6a:	75 35                	jne    802ca1 <fs_test+0x3fc>
  802c6c:	48 b9 ab 6b 80 00 00 	movabs $0x806bab,%rcx
  802c73:	00 00 00 
  802c76:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802c7d:	00 00 00 
  802c80:	be 2e 00 00 00       	mov    $0x2e,%esi
  802c85:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802c8c:	00 00 00 
  802c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c94:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802c9b:	00 00 00 
  802c9e:	41 ff d0             	callq  *%r8
	file_flush(f);
  802ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca5:	48 89 c7             	mov    %rax,%rdi
  802ca8:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802cb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb8:	48 c1 e8 0c          	shr    $0xc,%rax
  802cbc:	48 89 c2             	mov    %rax,%rdx
  802cbf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cc6:	01 00 00 
  802cc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ccd:	83 e0 40             	and    $0x40,%eax
  802cd0:	48 85 c0             	test   %rax,%rax
  802cd3:	74 35                	je     802d0a <fs_test+0x465>
  802cd5:	48 b9 c6 6b 80 00 00 	movabs $0x806bc6,%rcx
  802cdc:	00 00 00 
  802cdf:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802ce6:	00 00 00 
  802ce9:	be 30 00 00 00       	mov    $0x30,%esi
  802cee:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802cf5:	00 00 00 
  802cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfd:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802d04:	00 00 00 
  802d07:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802d0a:	48 bf e2 6b 80 00 00 	movabs $0x806be2,%rdi
  802d11:	00 00 00 
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  802d20:	00 00 00 
  802d23:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802d25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d29:	be 00 00 00 00       	mov    $0x0,%esi
  802d2e:	48 89 c7             	mov    %rax,%rdi
  802d31:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
  802d3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d44:	79 30                	jns    802d76 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802d46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d49:	89 c1                	mov    %eax,%ecx
  802d4b:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  802d52:	00 00 00 
  802d55:	be 34 00 00 00       	mov    $0x34,%esi
  802d5a:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802d61:	00 00 00 
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802d70:	00 00 00 
  802d73:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7a:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 35                	je     802db9 <fs_test+0x514>
  802d84:	48 b9 08 6c 80 00 00 	movabs $0x806c08,%rcx
  802d8b:	00 00 00 
  802d8e:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802d95:	00 00 00 
  802d98:	be 35 00 00 00       	mov    $0x35,%esi
  802d9d:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802da4:	00 00 00 
  802da7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dac:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802db3:	00 00 00 
  802db6:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbd:	48 c1 e8 0c          	shr    $0xc,%rax
  802dc1:	48 89 c2             	mov    %rax,%rdx
  802dc4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dcb:	01 00 00 
  802dce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dd2:	83 e0 40             	and    $0x40,%eax
  802dd5:	48 85 c0             	test   %rax,%rax
  802dd8:	74 35                	je     802e0f <fs_test+0x56a>
  802dda:	48 b9 1c 6c 80 00 00 	movabs $0x806c1c,%rcx
  802de1:	00 00 00 
  802de4:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802deb:	00 00 00 
  802dee:	be 36 00 00 00       	mov    $0x36,%esi
  802df3:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802dfa:	00 00 00 
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802e09:	00 00 00 
  802e0c:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e0f:	48 bf 36 6c 80 00 00 	movabs $0x806c36,%rdi
  802e16:	00 00 00 
  802e19:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1e:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  802e25:	00 00 00 
  802e28:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802e2a:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802e31:	00 00 00 
  802e34:	48 8b 00             	mov    (%rax),%rax
  802e37:	48 89 c7             	mov    %rax,%rdi
  802e3a:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
  802e46:	89 c2                	mov    %eax,%edx
  802e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4c:	89 d6                	mov    %edx,%esi
  802e4e:	48 89 c7             	mov    %rax,%rdi
  802e51:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e64:	79 30                	jns    802e96 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e69:	89 c1                	mov    %eax,%ecx
  802e6b:	48 ba 4d 6c 80 00 00 	movabs $0x806c4d,%rdx
  802e72:	00 00 00 
  802e75:	be 3a 00 00 00       	mov    $0x3a,%esi
  802e7a:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802e81:	00 00 00 
  802e84:	b8 00 00 00 00       	mov    $0x0,%eax
  802e89:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802e90:	00 00 00 
  802e93:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9a:	48 c1 e8 0c          	shr    $0xc,%rax
  802e9e:	48 89 c2             	mov    %rax,%rdx
  802ea1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ea8:	01 00 00 
  802eab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eaf:	83 e0 40             	and    $0x40,%eax
  802eb2:	48 85 c0             	test   %rax,%rax
  802eb5:	74 35                	je     802eec <fs_test+0x647>
  802eb7:	48 b9 1c 6c 80 00 00 	movabs $0x806c1c,%rcx
  802ebe:	00 00 00 
  802ec1:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802ec8:	00 00 00 
  802ecb:	be 3b 00 00 00       	mov    $0x3b,%esi
  802ed0:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802ed7:	00 00 00 
  802eda:	b8 00 00 00 00       	mov    $0x0,%eax
  802edf:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802ee6:	00 00 00 
  802ee9:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef0:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802ef4:	be 00 00 00 00       	mov    $0x0,%esi
  802ef9:	48 89 c7             	mov    %rax,%rdi
  802efc:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
  802f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0f:	79 30                	jns    802f41 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f14:	89 c1                	mov    %eax,%ecx
  802f16:	48 ba 61 6c 80 00 00 	movabs $0x806c61,%rdx
  802f1d:	00 00 00 
  802f20:	be 3d 00 00 00       	mov    $0x3d,%esi
  802f25:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802f2c:	00 00 00 
  802f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f34:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802f3b:	00 00 00 
  802f3e:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802f41:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802f48:	00 00 00 
  802f4b:	48 8b 10             	mov    (%rax),%rdx
  802f4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f52:	48 89 d6             	mov    %rdx,%rsi
  802f55:	48 89 c7             	mov    %rax,%rdi
  802f58:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  802f5f:	00 00 00 
  802f62:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802f64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f68:	48 c1 e8 0c          	shr    $0xc,%rax
  802f6c:	48 89 c2             	mov    %rax,%rdx
  802f6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f76:	01 00 00 
  802f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f7d:	83 e0 40             	and    $0x40,%eax
  802f80:	48 85 c0             	test   %rax,%rax
  802f83:	75 35                	jne    802fba <fs_test+0x715>
  802f85:	48 b9 ab 6b 80 00 00 	movabs $0x806bab,%rcx
  802f8c:	00 00 00 
  802f8f:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802f96:	00 00 00 
  802f99:	be 3f 00 00 00       	mov    $0x3f,%esi
  802f9e:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  802fa5:	00 00 00 
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fad:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  802fb4:	00 00 00 
  802fb7:	41 ff d0             	callq  *%r8
	file_flush(f);
  802fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fbe:	48 89 c7             	mov    %rax,%rdi
  802fc1:	48 b8 30 1d 80 00 00 	movabs $0x801d30,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802fcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd1:	48 c1 e8 0c          	shr    $0xc,%rax
  802fd5:	48 89 c2             	mov    %rax,%rdx
  802fd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fdf:	01 00 00 
  802fe2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fe6:	83 e0 40             	and    $0x40,%eax
  802fe9:	48 85 c0             	test   %rax,%rax
  802fec:	74 35                	je     803023 <fs_test+0x77e>
  802fee:	48 b9 c6 6b 80 00 00 	movabs $0x806bc6,%rcx
  802ff5:	00 00 00 
  802ff8:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  802fff:	00 00 00 
  803002:	be 41 00 00 00       	mov    $0x41,%esi
  803007:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  80300e:	00 00 00 
  803011:	b8 00 00 00 00       	mov    $0x0,%eax
  803016:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  80301d:	00 00 00 
  803020:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803027:	48 c1 e8 0c          	shr    $0xc,%rax
  80302b:	48 89 c2             	mov    %rax,%rdx
  80302e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803035:	01 00 00 
  803038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80303c:	83 e0 40             	and    $0x40,%eax
  80303f:	48 85 c0             	test   %rax,%rax
  803042:	74 35                	je     803079 <fs_test+0x7d4>
  803044:	48 b9 1c 6c 80 00 00 	movabs $0x806c1c,%rcx
  80304b:	00 00 00 
  80304e:	48 ba 8e 6a 80 00 00 	movabs $0x806a8e,%rdx
  803055:	00 00 00 
  803058:	be 42 00 00 00       	mov    $0x42,%esi
  80305d:	48 bf 59 6a 80 00 00 	movabs $0x806a59,%rdi
  803064:	00 00 00 
  803067:	b8 00 00 00 00       	mov    $0x0,%eax
  80306c:	49 b8 49 31 80 00 00 	movabs $0x803149,%r8
  803073:	00 00 00 
  803076:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  803079:	48 bf 76 6c 80 00 00 	movabs $0x806c76,%rdi
  803080:	00 00 00 
  803083:	b8 00 00 00 00       	mov    $0x0,%eax
  803088:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  80308f:	00 00 00 
  803092:	ff d2                	callq  *%rdx
}
  803094:	c9                   	leaveq 
  803095:	c3                   	retq   

0000000000803096 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803096:	55                   	push   %rbp
  803097:	48 89 e5             	mov    %rsp,%rbp
  80309a:	48 83 ec 10          	sub    $0x10,%rsp
  80309e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8030a5:	48 b8 dd 49 80 00 00 	movabs $0x8049dd,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
  8030b1:	48 98                	cltq   
  8030b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030b8:	48 89 c2             	mov    %rax,%rdx
  8030bb:	48 89 d0             	mov    %rdx,%rax
  8030be:	48 c1 e0 03          	shl    $0x3,%rax
  8030c2:	48 01 d0             	add    %rdx,%rax
  8030c5:	48 c1 e0 05          	shl    $0x5,%rax
  8030c9:	48 89 c2             	mov    %rax,%rdx
  8030cc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8030d3:	00 00 00 
  8030d6:	48 01 c2             	add    %rax,%rdx
  8030d9:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  8030e0:	00 00 00 
  8030e3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8030e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ea:	7e 14                	jle    803100 <libmain+0x6a>
		binaryname = argv[0];
  8030ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f0:	48 8b 10             	mov    (%rax),%rdx
  8030f3:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8030fa:	00 00 00 
  8030fd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  803100:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803107:	48 89 d6             	mov    %rdx,%rsi
  80310a:	89 c7                	mov    %eax,%edi
  80310c:	48 b8 01 28 80 00 00 	movabs $0x802801,%rax
  803113:	00 00 00 
  803116:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  803118:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
}
  803124:	c9                   	leaveq 
  803125:	c3                   	retq   

0000000000803126 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  803126:	55                   	push   %rbp
  803127:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80312a:	48 b8 df 52 80 00 00 	movabs $0x8052df,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  803136:	bf 00 00 00 00       	mov    $0x0,%edi
  80313b:	48 b8 99 49 80 00 00 	movabs $0x804999,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	5d                   	pop    %rbp
  803148:	c3                   	retq   

0000000000803149 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	53                   	push   %rbx
  80314e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803155:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80315c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803162:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803169:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803170:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803177:	84 c0                	test   %al,%al
  803179:	74 23                	je     80319e <_panic+0x55>
  80317b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803182:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803186:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80318a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80318e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803192:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803196:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80319a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80319e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8031a5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8031ac:	00 00 00 
  8031af:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8031b6:	00 00 00 
  8031b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031bd:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8031c4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8031cb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8031d2:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  8031d9:	00 00 00 
  8031dc:	48 8b 18             	mov    (%rax),%rbx
  8031df:	48 b8 dd 49 80 00 00 	movabs $0x8049dd,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
  8031eb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8031f1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8031f8:	41 89 c8             	mov    %ecx,%r8d
  8031fb:	48 89 d1             	mov    %rdx,%rcx
  8031fe:	48 89 da             	mov    %rbx,%rdx
  803201:	89 c6                	mov    %eax,%esi
  803203:	48 bf 98 6c 80 00 00 	movabs $0x806c98,%rdi
  80320a:	00 00 00 
  80320d:	b8 00 00 00 00       	mov    $0x0,%eax
  803212:	49 b9 82 33 80 00 00 	movabs $0x803382,%r9
  803219:	00 00 00 
  80321c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80321f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803226:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80322d:	48 89 d6             	mov    %rdx,%rsi
  803230:	48 89 c7             	mov    %rax,%rdi
  803233:	48 b8 d6 32 80 00 00 	movabs $0x8032d6,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
	cprintf("\n");
  80323f:	48 bf bb 6c 80 00 00 	movabs $0x806cbb,%rdi
  803246:	00 00 00 
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
  80324e:	48 ba 82 33 80 00 00 	movabs $0x803382,%rdx
  803255:	00 00 00 
  803258:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80325a:	cc                   	int3   
  80325b:	eb fd                	jmp    80325a <_panic+0x111>

000000000080325d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80325d:	55                   	push   %rbp
  80325e:	48 89 e5             	mov    %rsp,%rbp
  803261:	48 83 ec 10          	sub    $0x10,%rsp
  803265:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803268:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80326c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803270:	8b 00                	mov    (%rax),%eax
  803272:	8d 48 01             	lea    0x1(%rax),%ecx
  803275:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803279:	89 0a                	mov    %ecx,(%rdx)
  80327b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80327e:	89 d1                	mov    %edx,%ecx
  803280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803284:	48 98                	cltq   
  803286:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80328a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328e:	8b 00                	mov    (%rax),%eax
  803290:	3d ff 00 00 00       	cmp    $0xff,%eax
  803295:	75 2c                	jne    8032c3 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  803297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329b:	8b 00                	mov    (%rax),%eax
  80329d:	48 98                	cltq   
  80329f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032a3:	48 83 c2 08          	add    $0x8,%rdx
  8032a7:	48 89 c6             	mov    %rax,%rsi
  8032aa:	48 89 d7             	mov    %rdx,%rdi
  8032ad:	48 b8 11 49 80 00 00 	movabs $0x804911,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
		b->idx = 0;
  8032b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8032c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c7:	8b 40 04             	mov    0x4(%rax),%eax
  8032ca:	8d 50 01             	lea    0x1(%rax),%edx
  8032cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8032d4:	c9                   	leaveq 
  8032d5:	c3                   	retq   

00000000008032d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8032d6:	55                   	push   %rbp
  8032d7:	48 89 e5             	mov    %rsp,%rbp
  8032da:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8032e1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8032e8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8032ef:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8032f6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8032fd:	48 8b 0a             	mov    (%rdx),%rcx
  803300:	48 89 08             	mov    %rcx,(%rax)
  803303:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803307:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80330b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80330f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  803313:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80331a:	00 00 00 
	b.cnt = 0;
  80331d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803324:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  803327:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80332e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803335:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80333c:	48 89 c6             	mov    %rax,%rsi
  80333f:	48 bf 5d 32 80 00 00 	movabs $0x80325d,%rdi
  803346:	00 00 00 
  803349:	48 b8 35 37 80 00 00 	movabs $0x803735,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  803355:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80335b:	48 98                	cltq   
  80335d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803364:	48 83 c2 08          	add    $0x8,%rdx
  803368:	48 89 c6             	mov    %rax,%rsi
  80336b:	48 89 d7             	mov    %rdx,%rdi
  80336e:	48 b8 11 49 80 00 00 	movabs $0x804911,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80337a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803380:	c9                   	leaveq 
  803381:	c3                   	retq   

0000000000803382 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  803382:	55                   	push   %rbp
  803383:	48 89 e5             	mov    %rsp,%rbp
  803386:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80338d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803394:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80339b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033a2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033a9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033b0:	84 c0                	test   %al,%al
  8033b2:	74 20                	je     8033d4 <cprintf+0x52>
  8033b4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033b8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033bc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033c0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033c4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033c8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033cc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033d0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033d4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8033db:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8033e2:	00 00 00 
  8033e5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033ec:	00 00 00 
  8033ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033f3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033fa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803401:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803408:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80340f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803416:	48 8b 0a             	mov    (%rdx),%rcx
  803419:	48 89 08             	mov    %rcx,(%rax)
  80341c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803420:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803424:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803428:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80342c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803433:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80343a:	48 89 d6             	mov    %rdx,%rsi
  80343d:	48 89 c7             	mov    %rax,%rdi
  803440:	48 b8 d6 32 80 00 00 	movabs $0x8032d6,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
  80344c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  803452:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803458:	c9                   	leaveq 
  803459:	c3                   	retq   

000000000080345a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80345a:	55                   	push   %rbp
  80345b:	48 89 e5             	mov    %rsp,%rbp
  80345e:	53                   	push   %rbx
  80345f:	48 83 ec 38          	sub    $0x38,%rsp
  803463:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803467:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80346b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80346f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803472:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803476:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80347a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80347d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803481:	77 3b                	ja     8034be <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  803483:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803486:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80348a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80348d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803491:	ba 00 00 00 00       	mov    $0x0,%edx
  803496:	48 f7 f3             	div    %rbx
  803499:	48 89 c2             	mov    %rax,%rdx
  80349c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80349f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8034a2:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8034a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034aa:	41 89 f9             	mov    %edi,%r9d
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
  8034bc:	eb 1e                	jmp    8034dc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034be:	eb 12                	jmp    8034d2 <printnum+0x78>
			putch(padc, putdat);
  8034c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034c4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8034c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cb:	48 89 ce             	mov    %rcx,%rsi
  8034ce:	89 d7                	mov    %edx,%edi
  8034d0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034d2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8034d6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8034da:	7f e4                	jg     8034c0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8034dc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8034df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e8:	48 f7 f1             	div    %rcx
  8034eb:	48 89 d0             	mov    %rdx,%rax
  8034ee:	48 ba 88 6e 80 00 00 	movabs $0x806e88,%rdx
  8034f5:	00 00 00 
  8034f8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8034fc:	0f be d0             	movsbl %al,%edx
  8034ff:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803507:	48 89 ce             	mov    %rcx,%rsi
  80350a:	89 d7                	mov    %edx,%edi
  80350c:	ff d0                	callq  *%rax
}
  80350e:	48 83 c4 38          	add    $0x38,%rsp
  803512:	5b                   	pop    %rbx
  803513:	5d                   	pop    %rbp
  803514:	c3                   	retq   

0000000000803515 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 1c          	sub    $0x1c,%rsp
  80351d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803521:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  803524:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803528:	7e 52                	jle    80357c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80352a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352e:	8b 00                	mov    (%rax),%eax
  803530:	83 f8 30             	cmp    $0x30,%eax
  803533:	73 24                	jae    803559 <getuint+0x44>
  803535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803539:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80353d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803541:	8b 00                	mov    (%rax),%eax
  803543:	89 c0                	mov    %eax,%eax
  803545:	48 01 d0             	add    %rdx,%rax
  803548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80354c:	8b 12                	mov    (%rdx),%edx
  80354e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803555:	89 0a                	mov    %ecx,(%rdx)
  803557:	eb 17                	jmp    803570 <getuint+0x5b>
  803559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803561:	48 89 d0             	mov    %rdx,%rax
  803564:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803568:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80356c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803570:	48 8b 00             	mov    (%rax),%rax
  803573:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803577:	e9 a3 00 00 00       	jmpq   80361f <getuint+0x10a>
	else if (lflag)
  80357c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803580:	74 4f                	je     8035d1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803586:	8b 00                	mov    (%rax),%eax
  803588:	83 f8 30             	cmp    $0x30,%eax
  80358b:	73 24                	jae    8035b1 <getuint+0x9c>
  80358d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803591:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803599:	8b 00                	mov    (%rax),%eax
  80359b:	89 c0                	mov    %eax,%eax
  80359d:	48 01 d0             	add    %rdx,%rax
  8035a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035a4:	8b 12                	mov    (%rdx),%edx
  8035a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035ad:	89 0a                	mov    %ecx,(%rdx)
  8035af:	eb 17                	jmp    8035c8 <getuint+0xb3>
  8035b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8035b9:	48 89 d0             	mov    %rdx,%rax
  8035bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8035c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035c8:	48 8b 00             	mov    (%rax),%rax
  8035cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8035cf:	eb 4e                	jmp    80361f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8035d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d5:	8b 00                	mov    (%rax),%eax
  8035d7:	83 f8 30             	cmp    $0x30,%eax
  8035da:	73 24                	jae    803600 <getuint+0xeb>
  8035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e8:	8b 00                	mov    (%rax),%eax
  8035ea:	89 c0                	mov    %eax,%eax
  8035ec:	48 01 d0             	add    %rdx,%rax
  8035ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035f3:	8b 12                	mov    (%rdx),%edx
  8035f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035fc:	89 0a                	mov    %ecx,(%rdx)
  8035fe:	eb 17                	jmp    803617 <getuint+0x102>
  803600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803604:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803608:	48 89 d0             	mov    %rdx,%rax
  80360b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80360f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803613:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803617:	8b 00                	mov    (%rax),%eax
  803619:	89 c0                	mov    %eax,%eax
  80361b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80361f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803623:	c9                   	leaveq 
  803624:	c3                   	retq   

0000000000803625 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803625:	55                   	push   %rbp
  803626:	48 89 e5             	mov    %rsp,%rbp
  803629:	48 83 ec 1c          	sub    $0x1c,%rsp
  80362d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803631:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803634:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803638:	7e 52                	jle    80368c <getint+0x67>
		x=va_arg(*ap, long long);
  80363a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363e:	8b 00                	mov    (%rax),%eax
  803640:	83 f8 30             	cmp    $0x30,%eax
  803643:	73 24                	jae    803669 <getint+0x44>
  803645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803649:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80364d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803651:	8b 00                	mov    (%rax),%eax
  803653:	89 c0                	mov    %eax,%eax
  803655:	48 01 d0             	add    %rdx,%rax
  803658:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80365c:	8b 12                	mov    (%rdx),%edx
  80365e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803661:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803665:	89 0a                	mov    %ecx,(%rdx)
  803667:	eb 17                	jmp    803680 <getint+0x5b>
  803669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803671:	48 89 d0             	mov    %rdx,%rax
  803674:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803678:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80367c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803680:	48 8b 00             	mov    (%rax),%rax
  803683:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803687:	e9 a3 00 00 00       	jmpq   80372f <getint+0x10a>
	else if (lflag)
  80368c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803690:	74 4f                	je     8036e1 <getint+0xbc>
		x=va_arg(*ap, long);
  803692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803696:	8b 00                	mov    (%rax),%eax
  803698:	83 f8 30             	cmp    $0x30,%eax
  80369b:	73 24                	jae    8036c1 <getint+0x9c>
  80369d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a9:	8b 00                	mov    (%rax),%eax
  8036ab:	89 c0                	mov    %eax,%eax
  8036ad:	48 01 d0             	add    %rdx,%rax
  8036b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036b4:	8b 12                	mov    (%rdx),%edx
  8036b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036bd:	89 0a                	mov    %ecx,(%rdx)
  8036bf:	eb 17                	jmp    8036d8 <getint+0xb3>
  8036c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036c9:	48 89 d0             	mov    %rdx,%rax
  8036cc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8036d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036d8:	48 8b 00             	mov    (%rax),%rax
  8036db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036df:	eb 4e                	jmp    80372f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8036e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e5:	8b 00                	mov    (%rax),%eax
  8036e7:	83 f8 30             	cmp    $0x30,%eax
  8036ea:	73 24                	jae    803710 <getint+0xeb>
  8036ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f8:	8b 00                	mov    (%rax),%eax
  8036fa:	89 c0                	mov    %eax,%eax
  8036fc:	48 01 d0             	add    %rdx,%rax
  8036ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803703:	8b 12                	mov    (%rdx),%edx
  803705:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80370c:	89 0a                	mov    %ecx,(%rdx)
  80370e:	eb 17                	jmp    803727 <getint+0x102>
  803710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803714:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803718:	48 89 d0             	mov    %rdx,%rax
  80371b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80371f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803723:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803727:	8b 00                	mov    (%rax),%eax
  803729:	48 98                	cltq   
  80372b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80372f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803733:	c9                   	leaveq 
  803734:	c3                   	retq   

0000000000803735 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803735:	55                   	push   %rbp
  803736:	48 89 e5             	mov    %rsp,%rbp
  803739:	41 54                	push   %r12
  80373b:	53                   	push   %rbx
  80373c:	48 83 ec 60          	sub    $0x60,%rsp
  803740:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803744:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803748:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80374c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803750:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803754:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803758:	48 8b 0a             	mov    (%rdx),%rcx
  80375b:	48 89 08             	mov    %rcx,(%rax)
  80375e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803762:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803766:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80376a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80376e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803772:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803776:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80377a:	0f b6 00             	movzbl (%rax),%eax
  80377d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  803780:	eb 29                	jmp    8037ab <vprintfmt+0x76>
			if (ch == '\0')
  803782:	85 db                	test   %ebx,%ebx
  803784:	0f 84 ad 06 00 00    	je     803e37 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80378a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80378e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803792:	48 89 d6             	mov    %rdx,%rsi
  803795:	89 df                	mov    %ebx,%edi
  803797:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  803799:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80379d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8037a5:	0f b6 00             	movzbl (%rax),%eax
  8037a8:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8037ab:	83 fb 25             	cmp    $0x25,%ebx
  8037ae:	74 05                	je     8037b5 <vprintfmt+0x80>
  8037b0:	83 fb 1b             	cmp    $0x1b,%ebx
  8037b3:	75 cd                	jne    803782 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8037b5:	83 fb 1b             	cmp    $0x1b,%ebx
  8037b8:	0f 85 ae 01 00 00    	jne    80396c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8037be:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8037c5:	00 00 00 
  8037c8:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8037ce:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8037d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8037d6:	48 89 d6             	mov    %rdx,%rsi
  8037d9:	89 df                	mov    %ebx,%edi
  8037db:	ff d0                	callq  *%rax
			putch('[', putdat);
  8037dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8037e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8037e5:	48 89 d6             	mov    %rdx,%rsi
  8037e8:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8037ed:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8037ef:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8037f5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8037fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8037fe:	0f b6 00             	movzbl (%rax),%eax
  803801:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  803804:	eb 32                	jmp    803838 <vprintfmt+0x103>
					putch(ch, putdat);
  803806:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80380a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80380e:	48 89 d6             	mov    %rdx,%rsi
  803811:	89 df                	mov    %ebx,%edi
  803813:	ff d0                	callq  *%rax
					esc_color *= 10;
  803815:	44 89 e0             	mov    %r12d,%eax
  803818:	c1 e0 02             	shl    $0x2,%eax
  80381b:	44 01 e0             	add    %r12d,%eax
  80381e:	01 c0                	add    %eax,%eax
  803820:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  803823:	8d 43 d0             	lea    -0x30(%rbx),%eax
  803826:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  803829:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80382e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803832:	0f b6 00             	movzbl (%rax),%eax
  803835:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  803838:	83 fb 3b             	cmp    $0x3b,%ebx
  80383b:	74 05                	je     803842 <vprintfmt+0x10d>
  80383d:	83 fb 6d             	cmp    $0x6d,%ebx
  803840:	75 c4                	jne    803806 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  803842:	45 85 e4             	test   %r12d,%r12d
  803845:	75 15                	jne    80385c <vprintfmt+0x127>
					color_flag = 0x07;
  803847:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  80384e:	00 00 00 
  803851:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  803857:	e9 dc 00 00 00       	jmpq   803938 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80385c:	41 83 fc 1d          	cmp    $0x1d,%r12d
  803860:	7e 69                	jle    8038cb <vprintfmt+0x196>
  803862:	41 83 fc 25          	cmp    $0x25,%r12d
  803866:	7f 63                	jg     8038cb <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  803868:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  80386f:	00 00 00 
  803872:	8b 00                	mov    (%rax),%eax
  803874:	25 f8 00 00 00       	and    $0xf8,%eax
  803879:	89 c2                	mov    %eax,%edx
  80387b:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  803882:	00 00 00 
  803885:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  803887:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80388b:	44 89 e0             	mov    %r12d,%eax
  80388e:	83 e0 04             	and    $0x4,%eax
  803891:	c1 f8 02             	sar    $0x2,%eax
  803894:	89 c2                	mov    %eax,%edx
  803896:	44 89 e0             	mov    %r12d,%eax
  803899:	83 e0 02             	and    $0x2,%eax
  80389c:	09 c2                	or     %eax,%edx
  80389e:	44 89 e0             	mov    %r12d,%eax
  8038a1:	83 e0 01             	and    $0x1,%eax
  8038a4:	c1 e0 02             	shl    $0x2,%eax
  8038a7:	09 c2                	or     %eax,%edx
  8038a9:	41 89 d4             	mov    %edx,%r12d
  8038ac:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  8038b3:	00 00 00 
  8038b6:	8b 00                	mov    (%rax),%eax
  8038b8:	44 89 e2             	mov    %r12d,%edx
  8038bb:	09 c2                	or     %eax,%edx
  8038bd:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  8038c4:	00 00 00 
  8038c7:	89 10                	mov    %edx,(%rax)
  8038c9:	eb 6d                	jmp    803938 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8038cb:	41 83 fc 27          	cmp    $0x27,%r12d
  8038cf:	7e 67                	jle    803938 <vprintfmt+0x203>
  8038d1:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8038d5:	7f 61                	jg     803938 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8038d7:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  8038de:	00 00 00 
  8038e1:	8b 00                	mov    (%rax),%eax
  8038e3:	25 8f 00 00 00       	and    $0x8f,%eax
  8038e8:	89 c2                	mov    %eax,%edx
  8038ea:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  8038f1:	00 00 00 
  8038f4:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8038f6:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8038fa:	44 89 e0             	mov    %r12d,%eax
  8038fd:	83 e0 04             	and    $0x4,%eax
  803900:	c1 f8 02             	sar    $0x2,%eax
  803903:	89 c2                	mov    %eax,%edx
  803905:	44 89 e0             	mov    %r12d,%eax
  803908:	83 e0 02             	and    $0x2,%eax
  80390b:	09 c2                	or     %eax,%edx
  80390d:	44 89 e0             	mov    %r12d,%eax
  803910:	83 e0 01             	and    $0x1,%eax
  803913:	c1 e0 06             	shl    $0x6,%eax
  803916:	09 c2                	or     %eax,%edx
  803918:	41 89 d4             	mov    %edx,%r12d
  80391b:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  803922:	00 00 00 
  803925:	8b 00                	mov    (%rax),%eax
  803927:	44 89 e2             	mov    %r12d,%edx
  80392a:	09 c2                	or     %eax,%edx
  80392c:	48 b8 98 10 81 00 00 	movabs $0x811098,%rax
  803933:	00 00 00 
  803936:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  803938:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80393c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803940:	48 89 d6             	mov    %rdx,%rsi
  803943:	89 df                	mov    %ebx,%edi
  803945:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  803947:	83 fb 6d             	cmp    $0x6d,%ebx
  80394a:	75 1b                	jne    803967 <vprintfmt+0x232>
					fmt ++;
  80394c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  803951:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  803952:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803959:	00 00 00 
  80395c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  803962:	e9 cb 04 00 00       	jmpq   803e32 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  803967:	e9 83 fe ff ff       	jmpq   8037ef <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80396c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803970:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803977:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80397e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803985:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80398c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803990:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803994:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803998:	0f b6 00             	movzbl (%rax),%eax
  80399b:	0f b6 d8             	movzbl %al,%ebx
  80399e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8039a1:	83 f8 55             	cmp    $0x55,%eax
  8039a4:	0f 87 5a 04 00 00    	ja     803e04 <vprintfmt+0x6cf>
  8039aa:	89 c0                	mov    %eax,%eax
  8039ac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8039b3:	00 
  8039b4:	48 b8 b0 6e 80 00 00 	movabs $0x806eb0,%rax
  8039bb:	00 00 00 
  8039be:	48 01 d0             	add    %rdx,%rax
  8039c1:	48 8b 00             	mov    (%rax),%rax
  8039c4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8039c6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8039ca:	eb c0                	jmp    80398c <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8039cc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8039d0:	eb ba                	jmp    80398c <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8039d2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8039d9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	c1 e0 02             	shl    $0x2,%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	01 c0                	add    %eax,%eax
  8039e5:	01 d8                	add    %ebx,%eax
  8039e7:	83 e8 30             	sub    $0x30,%eax
  8039ea:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8039ed:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8039f1:	0f b6 00             	movzbl (%rax),%eax
  8039f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8039f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8039fa:	7e 0c                	jle    803a08 <vprintfmt+0x2d3>
  8039fc:	83 fb 39             	cmp    $0x39,%ebx
  8039ff:	7f 07                	jg     803a08 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803a01:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803a06:	eb d1                	jmp    8039d9 <vprintfmt+0x2a4>
			goto process_precision;
  803a08:	eb 58                	jmp    803a62 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  803a0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a0d:	83 f8 30             	cmp    $0x30,%eax
  803a10:	73 17                	jae    803a29 <vprintfmt+0x2f4>
  803a12:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a19:	89 c0                	mov    %eax,%eax
  803a1b:	48 01 d0             	add    %rdx,%rax
  803a1e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a21:	83 c2 08             	add    $0x8,%edx
  803a24:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803a27:	eb 0f                	jmp    803a38 <vprintfmt+0x303>
  803a29:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803a2d:	48 89 d0             	mov    %rdx,%rax
  803a30:	48 83 c2 08          	add    $0x8,%rdx
  803a34:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a38:	8b 00                	mov    (%rax),%eax
  803a3a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803a3d:	eb 23                	jmp    803a62 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  803a3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a43:	79 0c                	jns    803a51 <vprintfmt+0x31c>
				width = 0;
  803a45:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803a4c:	e9 3b ff ff ff       	jmpq   80398c <vprintfmt+0x257>
  803a51:	e9 36 ff ff ff       	jmpq   80398c <vprintfmt+0x257>

		case '#':
			altflag = 1;
  803a56:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803a5d:	e9 2a ff ff ff       	jmpq   80398c <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  803a62:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a66:	79 12                	jns    803a7a <vprintfmt+0x345>
				width = precision, precision = -1;
  803a68:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a6b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803a6e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803a75:	e9 12 ff ff ff       	jmpq   80398c <vprintfmt+0x257>
  803a7a:	e9 0d ff ff ff       	jmpq   80398c <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  803a7f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803a83:	e9 04 ff ff ff       	jmpq   80398c <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803a88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a8b:	83 f8 30             	cmp    $0x30,%eax
  803a8e:	73 17                	jae    803aa7 <vprintfmt+0x372>
  803a90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803a94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a97:	89 c0                	mov    %eax,%eax
  803a99:	48 01 d0             	add    %rdx,%rax
  803a9c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a9f:	83 c2 08             	add    $0x8,%edx
  803aa2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803aa5:	eb 0f                	jmp    803ab6 <vprintfmt+0x381>
  803aa7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803aab:	48 89 d0             	mov    %rdx,%rax
  803aae:	48 83 c2 08          	add    $0x8,%rdx
  803ab2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803ab6:	8b 10                	mov    (%rax),%edx
  803ab8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803abc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ac0:	48 89 ce             	mov    %rcx,%rsi
  803ac3:	89 d7                	mov    %edx,%edi
  803ac5:	ff d0                	callq  *%rax
			break;
  803ac7:	e9 66 03 00 00       	jmpq   803e32 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  803acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803acf:	83 f8 30             	cmp    $0x30,%eax
  803ad2:	73 17                	jae    803aeb <vprintfmt+0x3b6>
  803ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803adb:	89 c0                	mov    %eax,%eax
  803add:	48 01 d0             	add    %rdx,%rax
  803ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803ae3:	83 c2 08             	add    $0x8,%edx
  803ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803ae9:	eb 0f                	jmp    803afa <vprintfmt+0x3c5>
  803aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803aef:	48 89 d0             	mov    %rdx,%rax
  803af2:	48 83 c2 08          	add    $0x8,%rdx
  803af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803afa:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803afc:	85 db                	test   %ebx,%ebx
  803afe:	79 02                	jns    803b02 <vprintfmt+0x3cd>
				err = -err;
  803b00:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803b02:	83 fb 10             	cmp    $0x10,%ebx
  803b05:	7f 16                	jg     803b1d <vprintfmt+0x3e8>
  803b07:	48 b8 00 6e 80 00 00 	movabs $0x806e00,%rax
  803b0e:	00 00 00 
  803b11:	48 63 d3             	movslq %ebx,%rdx
  803b14:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803b18:	4d 85 e4             	test   %r12,%r12
  803b1b:	75 2e                	jne    803b4b <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  803b1d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803b21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b25:	89 d9                	mov    %ebx,%ecx
  803b27:	48 ba 99 6e 80 00 00 	movabs $0x806e99,%rdx
  803b2e:	00 00 00 
  803b31:	48 89 c7             	mov    %rax,%rdi
  803b34:	b8 00 00 00 00       	mov    $0x0,%eax
  803b39:	49 b8 40 3e 80 00 00 	movabs $0x803e40,%r8
  803b40:	00 00 00 
  803b43:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803b46:	e9 e7 02 00 00       	jmpq   803e32 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803b4b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803b4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b53:	4c 89 e1             	mov    %r12,%rcx
  803b56:	48 ba a2 6e 80 00 00 	movabs $0x806ea2,%rdx
  803b5d:	00 00 00 
  803b60:	48 89 c7             	mov    %rax,%rdi
  803b63:	b8 00 00 00 00       	mov    $0x0,%eax
  803b68:	49 b8 40 3e 80 00 00 	movabs $0x803e40,%r8
  803b6f:	00 00 00 
  803b72:	41 ff d0             	callq  *%r8
			break;
  803b75:	e9 b8 02 00 00       	jmpq   803e32 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803b7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b7d:	83 f8 30             	cmp    $0x30,%eax
  803b80:	73 17                	jae    803b99 <vprintfmt+0x464>
  803b82:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b89:	89 c0                	mov    %eax,%eax
  803b8b:	48 01 d0             	add    %rdx,%rax
  803b8e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b91:	83 c2 08             	add    $0x8,%edx
  803b94:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803b97:	eb 0f                	jmp    803ba8 <vprintfmt+0x473>
  803b99:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b9d:	48 89 d0             	mov    %rdx,%rax
  803ba0:	48 83 c2 08          	add    $0x8,%rdx
  803ba4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803ba8:	4c 8b 20             	mov    (%rax),%r12
  803bab:	4d 85 e4             	test   %r12,%r12
  803bae:	75 0a                	jne    803bba <vprintfmt+0x485>
				p = "(null)";
  803bb0:	49 bc a5 6e 80 00 00 	movabs $0x806ea5,%r12
  803bb7:	00 00 00 
			if (width > 0 && padc != '-')
  803bba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803bbe:	7e 3f                	jle    803bff <vprintfmt+0x4ca>
  803bc0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803bc4:	74 39                	je     803bff <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  803bc6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803bc9:	48 98                	cltq   
  803bcb:	48 89 c6             	mov    %rax,%rsi
  803bce:	4c 89 e7             	mov    %r12,%rdi
  803bd1:	48 b8 ec 40 80 00 00 	movabs $0x8040ec,%rax
  803bd8:	00 00 00 
  803bdb:	ff d0                	callq  *%rax
  803bdd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803be0:	eb 17                	jmp    803bf9 <vprintfmt+0x4c4>
					putch(padc, putdat);
  803be2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803be6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803bea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bee:	48 89 ce             	mov    %rcx,%rsi
  803bf1:	89 d7                	mov    %edx,%edi
  803bf3:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803bf5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803bf9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803bfd:	7f e3                	jg     803be2 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803bff:	eb 37                	jmp    803c38 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  803c01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803c05:	74 1e                	je     803c25 <vprintfmt+0x4f0>
  803c07:	83 fb 1f             	cmp    $0x1f,%ebx
  803c0a:	7e 05                	jle    803c11 <vprintfmt+0x4dc>
  803c0c:	83 fb 7e             	cmp    $0x7e,%ebx
  803c0f:	7e 14                	jle    803c25 <vprintfmt+0x4f0>
					putch('?', putdat);
  803c11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c19:	48 89 d6             	mov    %rdx,%rsi
  803c1c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803c21:	ff d0                	callq  *%rax
  803c23:	eb 0f                	jmp    803c34 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  803c25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c2d:	48 89 d6             	mov    %rdx,%rsi
  803c30:	89 df                	mov    %ebx,%edi
  803c32:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803c34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803c38:	4c 89 e0             	mov    %r12,%rax
  803c3b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803c3f:	0f b6 00             	movzbl (%rax),%eax
  803c42:	0f be d8             	movsbl %al,%ebx
  803c45:	85 db                	test   %ebx,%ebx
  803c47:	74 10                	je     803c59 <vprintfmt+0x524>
  803c49:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803c4d:	78 b2                	js     803c01 <vprintfmt+0x4cc>
  803c4f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803c53:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803c57:	79 a8                	jns    803c01 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803c59:	eb 16                	jmp    803c71 <vprintfmt+0x53c>
				putch(' ', putdat);
  803c5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c63:	48 89 d6             	mov    %rdx,%rsi
  803c66:	bf 20 00 00 00       	mov    $0x20,%edi
  803c6b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803c6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803c71:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c75:	7f e4                	jg     803c5b <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  803c77:	e9 b6 01 00 00       	jmpq   803e32 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803c7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c80:	be 03 00 00 00       	mov    $0x3,%esi
  803c85:	48 89 c7             	mov    %rax,%rdi
  803c88:	48 b8 25 36 80 00 00 	movabs $0x803625,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c9c:	48 85 c0             	test   %rax,%rax
  803c9f:	79 1d                	jns    803cbe <vprintfmt+0x589>
				putch('-', putdat);
  803ca1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ca5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ca9:	48 89 d6             	mov    %rdx,%rsi
  803cac:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803cb1:	ff d0                	callq  *%rax
				num = -(long long) num;
  803cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb7:	48 f7 d8             	neg    %rax
  803cba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803cbe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803cc5:	e9 fb 00 00 00       	jmpq   803dc5 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803cca:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803cce:	be 03 00 00 00       	mov    $0x3,%esi
  803cd3:	48 89 c7             	mov    %rax,%rdi
  803cd6:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  803cdd:	00 00 00 
  803ce0:	ff d0                	callq  *%rax
  803ce2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803ce6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ced:	e9 d3 00 00 00       	jmpq   803dc5 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  803cf2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803cf6:	be 03 00 00 00       	mov    $0x3,%esi
  803cfb:	48 89 c7             	mov    %rax,%rdi
  803cfe:	48 b8 25 36 80 00 00 	movabs $0x803625,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d12:	48 85 c0             	test   %rax,%rax
  803d15:	79 1d                	jns    803d34 <vprintfmt+0x5ff>
				putch('-', putdat);
  803d17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d1f:	48 89 d6             	mov    %rdx,%rsi
  803d22:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803d27:	ff d0                	callq  *%rax
				num = -(long long) num;
  803d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d2d:	48 f7 d8             	neg    %rax
  803d30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  803d34:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803d3b:	e9 85 00 00 00       	jmpq   803dc5 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  803d40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d48:	48 89 d6             	mov    %rdx,%rsi
  803d4b:	bf 30 00 00 00       	mov    $0x30,%edi
  803d50:	ff d0                	callq  *%rax
			putch('x', putdat);
  803d52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803d56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d5a:	48 89 d6             	mov    %rdx,%rsi
  803d5d:	bf 78 00 00 00       	mov    $0x78,%edi
  803d62:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803d64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d67:	83 f8 30             	cmp    $0x30,%eax
  803d6a:	73 17                	jae    803d83 <vprintfmt+0x64e>
  803d6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d73:	89 c0                	mov    %eax,%eax
  803d75:	48 01 d0             	add    %rdx,%rax
  803d78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803d7b:	83 c2 08             	add    $0x8,%edx
  803d7e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803d81:	eb 0f                	jmp    803d92 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  803d83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803d87:	48 89 d0             	mov    %rdx,%rax
  803d8a:	48 83 c2 08          	add    $0x8,%rdx
  803d8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803d92:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803d95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803d99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803da0:	eb 23                	jmp    803dc5 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803da2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803da6:	be 03 00 00 00       	mov    $0x3,%esi
  803dab:	48 89 c7             	mov    %rax,%rdi
  803dae:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
  803dba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803dbe:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803dc5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803dca:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803dcd:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803dd0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dd4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803dd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ddc:	45 89 c1             	mov    %r8d,%r9d
  803ddf:	41 89 f8             	mov    %edi,%r8d
  803de2:	48 89 c7             	mov    %rax,%rdi
  803de5:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
			break;
  803df1:	eb 3f                	jmp    803e32 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  803df3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803df7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803dfb:	48 89 d6             	mov    %rdx,%rsi
  803dfe:	89 df                	mov    %ebx,%edi
  803e00:	ff d0                	callq  *%rax
			break;
  803e02:	eb 2e                	jmp    803e32 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e0c:	48 89 d6             	mov    %rdx,%rsi
  803e0f:	bf 25 00 00 00       	mov    $0x25,%edi
  803e14:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803e16:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803e1b:	eb 05                	jmp    803e22 <vprintfmt+0x6ed>
  803e1d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803e22:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803e26:	48 83 e8 01          	sub    $0x1,%rax
  803e2a:	0f b6 00             	movzbl (%rax),%eax
  803e2d:	3c 25                	cmp    $0x25,%al
  803e2f:	75 ec                	jne    803e1d <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  803e31:	90                   	nop
		}
	}
  803e32:	e9 37 f9 ff ff       	jmpq   80376e <vprintfmt+0x39>
    va_end(aq);
}
  803e37:	48 83 c4 60          	add    $0x60,%rsp
  803e3b:	5b                   	pop    %rbx
  803e3c:	41 5c                	pop    %r12
  803e3e:	5d                   	pop    %rbp
  803e3f:	c3                   	retq   

0000000000803e40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803e40:	55                   	push   %rbp
  803e41:	48 89 e5             	mov    %rsp,%rbp
  803e44:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803e4b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803e52:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803e59:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803e60:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803e67:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803e6e:	84 c0                	test   %al,%al
  803e70:	74 20                	je     803e92 <printfmt+0x52>
  803e72:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803e76:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803e7a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803e7e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803e82:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803e86:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803e8a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803e8e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803e92:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803e99:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803ea0:	00 00 00 
  803ea3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803eaa:	00 00 00 
  803ead:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803eb1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803eb8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803ebf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803ec6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803ecd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ed4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803edb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803ee2:	48 89 c7             	mov    %rax,%rdi
  803ee5:	48 b8 35 37 80 00 00 	movabs $0x803735,%rax
  803eec:	00 00 00 
  803eef:	ff d0                	callq  *%rax
	va_end(ap);
}
  803ef1:	c9                   	leaveq 
  803ef2:	c3                   	retq   

0000000000803ef3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803ef3:	55                   	push   %rbp
  803ef4:	48 89 e5             	mov    %rsp,%rbp
  803ef7:	48 83 ec 10          	sub    $0x10,%rsp
  803efb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803efe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f06:	8b 40 10             	mov    0x10(%rax),%eax
  803f09:	8d 50 01             	lea    0x1(%rax),%edx
  803f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f10:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f17:	48 8b 10             	mov    (%rax),%rdx
  803f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803f22:	48 39 c2             	cmp    %rax,%rdx
  803f25:	73 17                	jae    803f3e <sprintputch+0x4b>
		*b->buf++ = ch;
  803f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f2b:	48 8b 00             	mov    (%rax),%rax
  803f2e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803f32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f36:	48 89 0a             	mov    %rcx,(%rdx)
  803f39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f3c:	88 10                	mov    %dl,(%rax)
}
  803f3e:	c9                   	leaveq 
  803f3f:	c3                   	retq   

0000000000803f40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803f40:	55                   	push   %rbp
  803f41:	48 89 e5             	mov    %rsp,%rbp
  803f44:	48 83 ec 50          	sub    $0x50,%rsp
  803f48:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803f4c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803f4f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803f53:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803f57:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803f5b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803f5f:	48 8b 0a             	mov    (%rdx),%rcx
  803f62:	48 89 08             	mov    %rcx,(%rax)
  803f65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803f69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803f6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803f71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803f75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f79:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803f7d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803f80:	48 98                	cltq   
  803f82:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803f86:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f8a:	48 01 d0             	add    %rdx,%rax
  803f8d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803f91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803f98:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803f9d:	74 06                	je     803fa5 <vsnprintf+0x65>
  803f9f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803fa3:	7f 07                	jg     803fac <vsnprintf+0x6c>
		return -E_INVAL;
  803fa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803faa:	eb 2f                	jmp    803fdb <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803fac:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803fb0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803fb4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fb8:	48 89 c6             	mov    %rax,%rsi
  803fbb:	48 bf f3 3e 80 00 00 	movabs $0x803ef3,%rdi
  803fc2:	00 00 00 
  803fc5:	48 b8 35 37 80 00 00 	movabs $0x803735,%rax
  803fcc:	00 00 00 
  803fcf:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803fd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803fd8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803fdb:	c9                   	leaveq 
  803fdc:	c3                   	retq   

0000000000803fdd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803fdd:	55                   	push   %rbp
  803fde:	48 89 e5             	mov    %rsp,%rbp
  803fe1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803fe8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803fef:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803ff5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803ffc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804003:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80400a:	84 c0                	test   %al,%al
  80400c:	74 20                	je     80402e <snprintf+0x51>
  80400e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804012:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804016:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80401a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80401e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804022:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804026:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80402a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80402e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  804035:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80403c:	00 00 00 
  80403f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804046:	00 00 00 
  804049:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80404d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804054:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80405b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  804062:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804069:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804070:	48 8b 0a             	mov    (%rdx),%rcx
  804073:	48 89 08             	mov    %rcx,(%rax)
  804076:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80407a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80407e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  804082:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804086:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80408d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  804094:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80409a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8040a1:	48 89 c7             	mov    %rax,%rdi
  8040a4:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  8040ab:	00 00 00 
  8040ae:	ff d0                	callq  *%rax
  8040b0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8040b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8040bc:	c9                   	leaveq 
  8040bd:	c3                   	retq   

00000000008040be <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8040be:	55                   	push   %rbp
  8040bf:	48 89 e5             	mov    %rsp,%rbp
  8040c2:	48 83 ec 18          	sub    $0x18,%rsp
  8040c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8040ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040d1:	eb 09                	jmp    8040dc <strlen+0x1e>
		n++;
  8040d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8040d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8040dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e0:	0f b6 00             	movzbl (%rax),%eax
  8040e3:	84 c0                	test   %al,%al
  8040e5:	75 ec                	jne    8040d3 <strlen+0x15>
		n++;
	return n;
  8040e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040ea:	c9                   	leaveq 
  8040eb:	c3                   	retq   

00000000008040ec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8040ec:	55                   	push   %rbp
  8040ed:	48 89 e5             	mov    %rsp,%rbp
  8040f0:	48 83 ec 20          	sub    $0x20,%rsp
  8040f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8040fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804103:	eb 0e                	jmp    804113 <strnlen+0x27>
		n++;
  804105:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  804109:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80410e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  804113:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804118:	74 0b                	je     804125 <strnlen+0x39>
  80411a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80411e:	0f b6 00             	movzbl (%rax),%eax
  804121:	84 c0                	test   %al,%al
  804123:	75 e0                	jne    804105 <strnlen+0x19>
		n++;
	return n;
  804125:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804128:	c9                   	leaveq 
  804129:	c3                   	retq   

000000000080412a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80412a:	55                   	push   %rbp
  80412b:	48 89 e5             	mov    %rsp,%rbp
  80412e:	48 83 ec 20          	sub    $0x20,%rsp
  804132:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804136:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80413a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80413e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  804142:	90                   	nop
  804143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804147:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80414b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80414f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804153:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804157:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80415b:	0f b6 12             	movzbl (%rdx),%edx
  80415e:	88 10                	mov    %dl,(%rax)
  804160:	0f b6 00             	movzbl (%rax),%eax
  804163:	84 c0                	test   %al,%al
  804165:	75 dc                	jne    804143 <strcpy+0x19>
		/* do nothing */;
	return ret;
  804167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80416b:	c9                   	leaveq 
  80416c:	c3                   	retq   

000000000080416d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80416d:	55                   	push   %rbp
  80416e:	48 89 e5             	mov    %rsp,%rbp
  804171:	48 83 ec 20          	sub    $0x20,%rsp
  804175:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804179:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80417d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804181:	48 89 c7             	mov    %rax,%rdi
  804184:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  80418b:	00 00 00 
  80418e:	ff d0                	callq  *%rax
  804190:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  804193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804196:	48 63 d0             	movslq %eax,%rdx
  804199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419d:	48 01 c2             	add    %rax,%rdx
  8041a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a4:	48 89 c6             	mov    %rax,%rsi
  8041a7:	48 89 d7             	mov    %rdx,%rdi
  8041aa:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
	return dst;
  8041b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8041ba:	c9                   	leaveq 
  8041bb:	c3                   	retq   

00000000008041bc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8041bc:	55                   	push   %rbp
  8041bd:	48 89 e5             	mov    %rsp,%rbp
  8041c0:	48 83 ec 28          	sub    $0x28,%rsp
  8041c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8041d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8041d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041df:	00 
  8041e0:	eb 2a                	jmp    80420c <strncpy+0x50>
		*dst++ = *src;
  8041e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8041ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8041ee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041f2:	0f b6 12             	movzbl (%rdx),%edx
  8041f5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8041f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041fb:	0f b6 00             	movzbl (%rax),%eax
  8041fe:	84 c0                	test   %al,%al
  804200:	74 05                	je     804207 <strncpy+0x4b>
			src++;
  804202:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  804207:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80420c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804210:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804214:	72 cc                	jb     8041e2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80421a:	c9                   	leaveq 
  80421b:	c3                   	retq   

000000000080421c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80421c:	55                   	push   %rbp
  80421d:	48 89 e5             	mov    %rsp,%rbp
  804220:	48 83 ec 28          	sub    $0x28,%rsp
  804224:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804228:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80422c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  804230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804234:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804238:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80423d:	74 3d                	je     80427c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80423f:	eb 1d                	jmp    80425e <strlcpy+0x42>
			*dst++ = *src++;
  804241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804245:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804249:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80424d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804251:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804255:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804259:	0f b6 12             	movzbl (%rdx),%edx
  80425c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80425e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804263:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804268:	74 0b                	je     804275 <strlcpy+0x59>
  80426a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80426e:	0f b6 00             	movzbl (%rax),%eax
  804271:	84 c0                	test   %al,%al
  804273:	75 cc                	jne    804241 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804279:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80427c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804284:	48 29 c2             	sub    %rax,%rdx
  804287:	48 89 d0             	mov    %rdx,%rax
}
  80428a:	c9                   	leaveq 
  80428b:	c3                   	retq   

000000000080428c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80428c:	55                   	push   %rbp
  80428d:	48 89 e5             	mov    %rsp,%rbp
  804290:	48 83 ec 10          	sub    $0x10,%rsp
  804294:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804298:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80429c:	eb 0a                	jmp    8042a8 <strcmp+0x1c>
		p++, q++;
  80429e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8042a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ac:	0f b6 00             	movzbl (%rax),%eax
  8042af:	84 c0                	test   %al,%al
  8042b1:	74 12                	je     8042c5 <strcmp+0x39>
  8042b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b7:	0f b6 10             	movzbl (%rax),%edx
  8042ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042be:	0f b6 00             	movzbl (%rax),%eax
  8042c1:	38 c2                	cmp    %al,%dl
  8042c3:	74 d9                	je     80429e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8042c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c9:	0f b6 00             	movzbl (%rax),%eax
  8042cc:	0f b6 d0             	movzbl %al,%edx
  8042cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d3:	0f b6 00             	movzbl (%rax),%eax
  8042d6:	0f b6 c0             	movzbl %al,%eax
  8042d9:	29 c2                	sub    %eax,%edx
  8042db:	89 d0                	mov    %edx,%eax
}
  8042dd:	c9                   	leaveq 
  8042de:	c3                   	retq   

00000000008042df <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8042df:	55                   	push   %rbp
  8042e0:	48 89 e5             	mov    %rsp,%rbp
  8042e3:	48 83 ec 18          	sub    $0x18,%rsp
  8042e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8042f3:	eb 0f                	jmp    804304 <strncmp+0x25>
		n--, p++, q++;
  8042f5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8042fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042ff:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  804304:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804309:	74 1d                	je     804328 <strncmp+0x49>
  80430b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80430f:	0f b6 00             	movzbl (%rax),%eax
  804312:	84 c0                	test   %al,%al
  804314:	74 12                	je     804328 <strncmp+0x49>
  804316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80431a:	0f b6 10             	movzbl (%rax),%edx
  80431d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804321:	0f b6 00             	movzbl (%rax),%eax
  804324:	38 c2                	cmp    %al,%dl
  804326:	74 cd                	je     8042f5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804328:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80432d:	75 07                	jne    804336 <strncmp+0x57>
		return 0;
  80432f:	b8 00 00 00 00       	mov    $0x0,%eax
  804334:	eb 18                	jmp    80434e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80433a:	0f b6 00             	movzbl (%rax),%eax
  80433d:	0f b6 d0             	movzbl %al,%edx
  804340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804344:	0f b6 00             	movzbl (%rax),%eax
  804347:	0f b6 c0             	movzbl %al,%eax
  80434a:	29 c2                	sub    %eax,%edx
  80434c:	89 d0                	mov    %edx,%eax
}
  80434e:	c9                   	leaveq 
  80434f:	c3                   	retq   

0000000000804350 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  804350:	55                   	push   %rbp
  804351:	48 89 e5             	mov    %rsp,%rbp
  804354:	48 83 ec 0c          	sub    $0xc,%rsp
  804358:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80435c:	89 f0                	mov    %esi,%eax
  80435e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804361:	eb 17                	jmp    80437a <strchr+0x2a>
		if (*s == c)
  804363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804367:	0f b6 00             	movzbl (%rax),%eax
  80436a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80436d:	75 06                	jne    804375 <strchr+0x25>
			return (char *) s;
  80436f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804373:	eb 15                	jmp    80438a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804375:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80437a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80437e:	0f b6 00             	movzbl (%rax),%eax
  804381:	84 c0                	test   %al,%al
  804383:	75 de                	jne    804363 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804385:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80438a:	c9                   	leaveq 
  80438b:	c3                   	retq   

000000000080438c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80438c:	55                   	push   %rbp
  80438d:	48 89 e5             	mov    %rsp,%rbp
  804390:	48 83 ec 0c          	sub    $0xc,%rsp
  804394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804398:	89 f0                	mov    %esi,%eax
  80439a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80439d:	eb 13                	jmp    8043b2 <strfind+0x26>
		if (*s == c)
  80439f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a3:	0f b6 00             	movzbl (%rax),%eax
  8043a6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8043a9:	75 02                	jne    8043ad <strfind+0x21>
			break;
  8043ab:	eb 10                	jmp    8043bd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8043ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b6:	0f b6 00             	movzbl (%rax),%eax
  8043b9:	84 c0                	test   %al,%al
  8043bb:	75 e2                	jne    80439f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8043bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043c1:	c9                   	leaveq 
  8043c2:	c3                   	retq   

00000000008043c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8043c3:	55                   	push   %rbp
  8043c4:	48 89 e5             	mov    %rsp,%rbp
  8043c7:	48 83 ec 18          	sub    $0x18,%rsp
  8043cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8043d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8043d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043db:	75 06                	jne    8043e3 <memset+0x20>
		return v;
  8043dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e1:	eb 69                	jmp    80444c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8043e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e7:	83 e0 03             	and    $0x3,%eax
  8043ea:	48 85 c0             	test   %rax,%rax
  8043ed:	75 48                	jne    804437 <memset+0x74>
  8043ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f3:	83 e0 03             	and    $0x3,%eax
  8043f6:	48 85 c0             	test   %rax,%rax
  8043f9:	75 3c                	jne    804437 <memset+0x74>
		c &= 0xFF;
  8043fb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  804402:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804405:	c1 e0 18             	shl    $0x18,%eax
  804408:	89 c2                	mov    %eax,%edx
  80440a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80440d:	c1 e0 10             	shl    $0x10,%eax
  804410:	09 c2                	or     %eax,%edx
  804412:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804415:	c1 e0 08             	shl    $0x8,%eax
  804418:	09 d0                	or     %edx,%eax
  80441a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80441d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804421:	48 c1 e8 02          	shr    $0x2,%rax
  804425:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804428:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80442c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80442f:	48 89 d7             	mov    %rdx,%rdi
  804432:	fc                   	cld    
  804433:	f3 ab                	rep stos %eax,%es:(%rdi)
  804435:	eb 11                	jmp    804448 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804437:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80443b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80443e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804442:	48 89 d7             	mov    %rdx,%rdi
  804445:	fc                   	cld    
  804446:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  804448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80444c:	c9                   	leaveq 
  80444d:	c3                   	retq   

000000000080444e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80444e:	55                   	push   %rbp
  80444f:	48 89 e5             	mov    %rsp,%rbp
  804452:	48 83 ec 28          	sub    $0x28,%rsp
  804456:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80445a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80445e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  804462:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804466:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80446a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80446e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  804472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804476:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80447a:	0f 83 88 00 00 00    	jae    804508 <memmove+0xba>
  804480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804484:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804488:	48 01 d0             	add    %rdx,%rax
  80448b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80448f:	76 77                	jbe    804508 <memmove+0xba>
		s += n;
  804491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804495:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80449d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8044a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a5:	83 e0 03             	and    $0x3,%eax
  8044a8:	48 85 c0             	test   %rax,%rax
  8044ab:	75 3b                	jne    8044e8 <memmove+0x9a>
  8044ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b1:	83 e0 03             	and    $0x3,%eax
  8044b4:	48 85 c0             	test   %rax,%rax
  8044b7:	75 2f                	jne    8044e8 <memmove+0x9a>
  8044b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044bd:	83 e0 03             	and    $0x3,%eax
  8044c0:	48 85 c0             	test   %rax,%rax
  8044c3:	75 23                	jne    8044e8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8044c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c9:	48 83 e8 04          	sub    $0x4,%rax
  8044cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8044d1:	48 83 ea 04          	sub    $0x4,%rdx
  8044d5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8044d9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8044dd:	48 89 c7             	mov    %rax,%rdi
  8044e0:	48 89 d6             	mov    %rdx,%rsi
  8044e3:	fd                   	std    
  8044e4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8044e6:	eb 1d                	jmp    804505 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8044e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8044f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8044f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044fc:	48 89 d7             	mov    %rdx,%rdi
  8044ff:	48 89 c1             	mov    %rax,%rcx
  804502:	fd                   	std    
  804503:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804505:	fc                   	cld    
  804506:	eb 57                	jmp    80455f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450c:	83 e0 03             	and    $0x3,%eax
  80450f:	48 85 c0             	test   %rax,%rax
  804512:	75 36                	jne    80454a <memmove+0xfc>
  804514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804518:	83 e0 03             	and    $0x3,%eax
  80451b:	48 85 c0             	test   %rax,%rax
  80451e:	75 2a                	jne    80454a <memmove+0xfc>
  804520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804524:	83 e0 03             	and    $0x3,%eax
  804527:	48 85 c0             	test   %rax,%rax
  80452a:	75 1e                	jne    80454a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80452c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804530:	48 c1 e8 02          	shr    $0x2,%rax
  804534:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80453b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80453f:	48 89 c7             	mov    %rax,%rdi
  804542:	48 89 d6             	mov    %rdx,%rsi
  804545:	fc                   	cld    
  804546:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804548:	eb 15                	jmp    80455f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80454a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804552:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804556:	48 89 c7             	mov    %rax,%rdi
  804559:	48 89 d6             	mov    %rdx,%rsi
  80455c:	fc                   	cld    
  80455d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80455f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804563:	c9                   	leaveq 
  804564:	c3                   	retq   

0000000000804565 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804565:	55                   	push   %rbp
  804566:	48 89 e5             	mov    %rsp,%rbp
  804569:	48 83 ec 18          	sub    $0x18,%rsp
  80456d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804571:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804575:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804579:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80457d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804585:	48 89 ce             	mov    %rcx,%rsi
  804588:	48 89 c7             	mov    %rax,%rdi
  80458b:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
}
  804597:	c9                   	leaveq 
  804598:	c3                   	retq   

0000000000804599 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804599:	55                   	push   %rbp
  80459a:	48 89 e5             	mov    %rsp,%rbp
  80459d:	48 83 ec 28          	sub    $0x28,%rsp
  8045a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8045ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8045b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8045bd:	eb 36                	jmp    8045f5 <memcmp+0x5c>
		if (*s1 != *s2)
  8045bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045c3:	0f b6 10             	movzbl (%rax),%edx
  8045c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ca:	0f b6 00             	movzbl (%rax),%eax
  8045cd:	38 c2                	cmp    %al,%dl
  8045cf:	74 1a                	je     8045eb <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8045d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d5:	0f b6 00             	movzbl (%rax),%eax
  8045d8:	0f b6 d0             	movzbl %al,%edx
  8045db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045df:	0f b6 00             	movzbl (%rax),%eax
  8045e2:	0f b6 c0             	movzbl %al,%eax
  8045e5:	29 c2                	sub    %eax,%edx
  8045e7:	89 d0                	mov    %edx,%eax
  8045e9:	eb 20                	jmp    80460b <memcmp+0x72>
		s1++, s2++;
  8045eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8045f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8045fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804601:	48 85 c0             	test   %rax,%rax
  804604:	75 b9                	jne    8045bf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80460b:	c9                   	leaveq 
  80460c:	c3                   	retq   

000000000080460d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80460d:	55                   	push   %rbp
  80460e:	48 89 e5             	mov    %rsp,%rbp
  804611:	48 83 ec 28          	sub    $0x28,%rsp
  804615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804619:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80461c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  804620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804628:	48 01 d0             	add    %rdx,%rax
  80462b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80462f:	eb 15                	jmp    804646 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  804631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804635:	0f b6 10             	movzbl (%rax),%edx
  804638:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80463b:	38 c2                	cmp    %al,%dl
  80463d:	75 02                	jne    804641 <memfind+0x34>
			break;
  80463f:	eb 0f                	jmp    804650 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804641:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80464a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80464e:	72 e1                	jb     804631 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  804650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804654:	c9                   	leaveq 
  804655:	c3                   	retq   

0000000000804656 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804656:	55                   	push   %rbp
  804657:	48 89 e5             	mov    %rsp,%rbp
  80465a:	48 83 ec 34          	sub    $0x34,%rsp
  80465e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804662:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804666:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804670:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804677:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804678:	eb 05                	jmp    80467f <strtol+0x29>
		s++;
  80467a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80467f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804683:	0f b6 00             	movzbl (%rax),%eax
  804686:	3c 20                	cmp    $0x20,%al
  804688:	74 f0                	je     80467a <strtol+0x24>
  80468a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80468e:	0f b6 00             	movzbl (%rax),%eax
  804691:	3c 09                	cmp    $0x9,%al
  804693:	74 e5                	je     80467a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  804695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804699:	0f b6 00             	movzbl (%rax),%eax
  80469c:	3c 2b                	cmp    $0x2b,%al
  80469e:	75 07                	jne    8046a7 <strtol+0x51>
		s++;
  8046a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8046a5:	eb 17                	jmp    8046be <strtol+0x68>
	else if (*s == '-')
  8046a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ab:	0f b6 00             	movzbl (%rax),%eax
  8046ae:	3c 2d                	cmp    $0x2d,%al
  8046b0:	75 0c                	jne    8046be <strtol+0x68>
		s++, neg = 1;
  8046b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8046b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8046be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8046c2:	74 06                	je     8046ca <strtol+0x74>
  8046c4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8046c8:	75 28                	jne    8046f2 <strtol+0x9c>
  8046ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046ce:	0f b6 00             	movzbl (%rax),%eax
  8046d1:	3c 30                	cmp    $0x30,%al
  8046d3:	75 1d                	jne    8046f2 <strtol+0x9c>
  8046d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d9:	48 83 c0 01          	add    $0x1,%rax
  8046dd:	0f b6 00             	movzbl (%rax),%eax
  8046e0:	3c 78                	cmp    $0x78,%al
  8046e2:	75 0e                	jne    8046f2 <strtol+0x9c>
		s += 2, base = 16;
  8046e4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8046e9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8046f0:	eb 2c                	jmp    80471e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8046f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8046f6:	75 19                	jne    804711 <strtol+0xbb>
  8046f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046fc:	0f b6 00             	movzbl (%rax),%eax
  8046ff:	3c 30                	cmp    $0x30,%al
  804701:	75 0e                	jne    804711 <strtol+0xbb>
		s++, base = 8;
  804703:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804708:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80470f:	eb 0d                	jmp    80471e <strtol+0xc8>
	else if (base == 0)
  804711:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804715:	75 07                	jne    80471e <strtol+0xc8>
		base = 10;
  804717:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80471e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804722:	0f b6 00             	movzbl (%rax),%eax
  804725:	3c 2f                	cmp    $0x2f,%al
  804727:	7e 1d                	jle    804746 <strtol+0xf0>
  804729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472d:	0f b6 00             	movzbl (%rax),%eax
  804730:	3c 39                	cmp    $0x39,%al
  804732:	7f 12                	jg     804746 <strtol+0xf0>
			dig = *s - '0';
  804734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804738:	0f b6 00             	movzbl (%rax),%eax
  80473b:	0f be c0             	movsbl %al,%eax
  80473e:	83 e8 30             	sub    $0x30,%eax
  804741:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804744:	eb 4e                	jmp    804794 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80474a:	0f b6 00             	movzbl (%rax),%eax
  80474d:	3c 60                	cmp    $0x60,%al
  80474f:	7e 1d                	jle    80476e <strtol+0x118>
  804751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804755:	0f b6 00             	movzbl (%rax),%eax
  804758:	3c 7a                	cmp    $0x7a,%al
  80475a:	7f 12                	jg     80476e <strtol+0x118>
			dig = *s - 'a' + 10;
  80475c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804760:	0f b6 00             	movzbl (%rax),%eax
  804763:	0f be c0             	movsbl %al,%eax
  804766:	83 e8 57             	sub    $0x57,%eax
  804769:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80476c:	eb 26                	jmp    804794 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80476e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804772:	0f b6 00             	movzbl (%rax),%eax
  804775:	3c 40                	cmp    $0x40,%al
  804777:	7e 48                	jle    8047c1 <strtol+0x16b>
  804779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80477d:	0f b6 00             	movzbl (%rax),%eax
  804780:	3c 5a                	cmp    $0x5a,%al
  804782:	7f 3d                	jg     8047c1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  804784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804788:	0f b6 00             	movzbl (%rax),%eax
  80478b:	0f be c0             	movsbl %al,%eax
  80478e:	83 e8 37             	sub    $0x37,%eax
  804791:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804794:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804797:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80479a:	7c 02                	jl     80479e <strtol+0x148>
			break;
  80479c:	eb 23                	jmp    8047c1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80479e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8047a3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8047a6:	48 98                	cltq   
  8047a8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8047ad:	48 89 c2             	mov    %rax,%rdx
  8047b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047b3:	48 98                	cltq   
  8047b5:	48 01 d0             	add    %rdx,%rax
  8047b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8047bc:	e9 5d ff ff ff       	jmpq   80471e <strtol+0xc8>

	if (endptr)
  8047c1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8047c6:	74 0b                	je     8047d3 <strtol+0x17d>
		*endptr = (char *) s;
  8047c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8047d0:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8047d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d7:	74 09                	je     8047e2 <strtol+0x18c>
  8047d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047dd:	48 f7 d8             	neg    %rax
  8047e0:	eb 04                	jmp    8047e6 <strtol+0x190>
  8047e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8047e6:	c9                   	leaveq 
  8047e7:	c3                   	retq   

00000000008047e8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8047e8:	55                   	push   %rbp
  8047e9:	48 89 e5             	mov    %rsp,%rbp
  8047ec:	48 83 ec 30          	sub    $0x30,%rsp
  8047f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8047f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804800:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804804:	0f b6 00             	movzbl (%rax),%eax
  804807:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80480a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80480e:	75 06                	jne    804816 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  804810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804814:	eb 6b                	jmp    804881 <strstr+0x99>

    len = strlen(str);
  804816:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80481a:	48 89 c7             	mov    %rax,%rdi
  80481d:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  804824:	00 00 00 
  804827:	ff d0                	callq  *%rax
  804829:	48 98                	cltq   
  80482b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80482f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804833:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804837:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80483b:	0f b6 00             	movzbl (%rax),%eax
  80483e:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  804841:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804845:	75 07                	jne    80484e <strstr+0x66>
                return (char *) 0;
  804847:	b8 00 00 00 00       	mov    $0x0,%eax
  80484c:	eb 33                	jmp    804881 <strstr+0x99>
        } while (sc != c);
  80484e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804852:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804855:	75 d8                	jne    80482f <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  804857:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80485b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80485f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804863:	48 89 ce             	mov    %rcx,%rsi
  804866:	48 89 c7             	mov    %rax,%rdi
  804869:	48 b8 df 42 80 00 00 	movabs $0x8042df,%rax
  804870:	00 00 00 
  804873:	ff d0                	callq  *%rax
  804875:	85 c0                	test   %eax,%eax
  804877:	75 b6                	jne    80482f <strstr+0x47>

    return (char *) (in - 1);
  804879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80487d:	48 83 e8 01          	sub    $0x1,%rax
}
  804881:	c9                   	leaveq 
  804882:	c3                   	retq   

0000000000804883 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804883:	55                   	push   %rbp
  804884:	48 89 e5             	mov    %rsp,%rbp
  804887:	53                   	push   %rbx
  804888:	48 83 ec 48          	sub    $0x48,%rsp
  80488c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80488f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804892:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804896:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80489a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80489e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8048a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8048a5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8048a9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8048ad:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8048b1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8048b5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8048b9:	4c 89 c3             	mov    %r8,%rbx
  8048bc:	cd 30                	int    $0x30
  8048be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8048c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8048c6:	74 3e                	je     804906 <syscall+0x83>
  8048c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048cd:	7e 37                	jle    804906 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8048cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8048d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8048d6:	49 89 d0             	mov    %rdx,%r8
  8048d9:	89 c1                	mov    %eax,%ecx
  8048db:	48 ba 60 71 80 00 00 	movabs $0x807160,%rdx
  8048e2:	00 00 00 
  8048e5:	be 23 00 00 00       	mov    $0x23,%esi
  8048ea:	48 bf 7d 71 80 00 00 	movabs $0x80717d,%rdi
  8048f1:	00 00 00 
  8048f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f9:	49 b9 49 31 80 00 00 	movabs $0x803149,%r9
  804900:	00 00 00 
  804903:	41 ff d1             	callq  *%r9

	return ret;
  804906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80490a:	48 83 c4 48          	add    $0x48,%rsp
  80490e:	5b                   	pop    %rbx
  80490f:	5d                   	pop    %rbp
  804910:	c3                   	retq   

0000000000804911 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804911:	55                   	push   %rbp
  804912:	48 89 e5             	mov    %rsp,%rbp
  804915:	48 83 ec 20          	sub    $0x20,%rsp
  804919:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80491d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804921:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804925:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804929:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804930:	00 
  804931:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804937:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80493d:	48 89 d1             	mov    %rdx,%rcx
  804940:	48 89 c2             	mov    %rax,%rdx
  804943:	be 00 00 00 00       	mov    $0x0,%esi
  804948:	bf 00 00 00 00       	mov    $0x0,%edi
  80494d:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804954:	00 00 00 
  804957:	ff d0                	callq  *%rax
}
  804959:	c9                   	leaveq 
  80495a:	c3                   	retq   

000000000080495b <sys_cgetc>:

int
sys_cgetc(void)
{
  80495b:	55                   	push   %rbp
  80495c:	48 89 e5             	mov    %rsp,%rbp
  80495f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804963:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80496a:	00 
  80496b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804971:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804977:	b9 00 00 00 00       	mov    $0x0,%ecx
  80497c:	ba 00 00 00 00       	mov    $0x0,%edx
  804981:	be 00 00 00 00       	mov    $0x0,%esi
  804986:	bf 01 00 00 00       	mov    $0x1,%edi
  80498b:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804992:	00 00 00 
  804995:	ff d0                	callq  *%rax
}
  804997:	c9                   	leaveq 
  804998:	c3                   	retq   

0000000000804999 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804999:	55                   	push   %rbp
  80499a:	48 89 e5             	mov    %rsp,%rbp
  80499d:	48 83 ec 10          	sub    $0x10,%rsp
  8049a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8049a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a7:	48 98                	cltq   
  8049a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049b0:	00 
  8049b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8049c2:	48 89 c2             	mov    %rax,%rdx
  8049c5:	be 01 00 00 00       	mov    $0x1,%esi
  8049ca:	bf 03 00 00 00       	mov    $0x3,%edi
  8049cf:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  8049d6:	00 00 00 
  8049d9:	ff d0                	callq  *%rax
}
  8049db:	c9                   	leaveq 
  8049dc:	c3                   	retq   

00000000008049dd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8049dd:	55                   	push   %rbp
  8049de:	48 89 e5             	mov    %rsp,%rbp
  8049e1:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8049e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8049ec:	00 
  8049ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8049fe:	ba 00 00 00 00       	mov    $0x0,%edx
  804a03:	be 00 00 00 00       	mov    $0x0,%esi
  804a08:	bf 02 00 00 00       	mov    $0x2,%edi
  804a0d:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804a14:	00 00 00 
  804a17:	ff d0                	callq  *%rax
}
  804a19:	c9                   	leaveq 
  804a1a:	c3                   	retq   

0000000000804a1b <sys_yield>:

void
sys_yield(void)
{
  804a1b:	55                   	push   %rbp
  804a1c:	48 89 e5             	mov    %rsp,%rbp
  804a1f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804a23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a2a:	00 
  804a2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a37:	b9 00 00 00 00       	mov    $0x0,%ecx
  804a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  804a41:	be 00 00 00 00       	mov    $0x0,%esi
  804a46:	bf 0b 00 00 00       	mov    $0xb,%edi
  804a4b:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804a52:	00 00 00 
  804a55:	ff d0                	callq  *%rax
}
  804a57:	c9                   	leaveq 
  804a58:	c3                   	retq   

0000000000804a59 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804a59:	55                   	push   %rbp
  804a5a:	48 89 e5             	mov    %rsp,%rbp
  804a5d:	48 83 ec 20          	sub    $0x20,%rsp
  804a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a68:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804a6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a6e:	48 63 c8             	movslq %eax,%rcx
  804a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a78:	48 98                	cltq   
  804a7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804a81:	00 
  804a82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a88:	49 89 c8             	mov    %rcx,%r8
  804a8b:	48 89 d1             	mov    %rdx,%rcx
  804a8e:	48 89 c2             	mov    %rax,%rdx
  804a91:	be 01 00 00 00       	mov    $0x1,%esi
  804a96:	bf 04 00 00 00       	mov    $0x4,%edi
  804a9b:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804aa2:	00 00 00 
  804aa5:	ff d0                	callq  *%rax
}
  804aa7:	c9                   	leaveq 
  804aa8:	c3                   	retq   

0000000000804aa9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804aa9:	55                   	push   %rbp
  804aaa:	48 89 e5             	mov    %rsp,%rbp
  804aad:	48 83 ec 30          	sub    $0x30,%rsp
  804ab1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ab4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ab8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804abb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804abf:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804ac3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ac6:	48 63 c8             	movslq %eax,%rcx
  804ac9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804acd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ad0:	48 63 f0             	movslq %eax,%rsi
  804ad3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ada:	48 98                	cltq   
  804adc:	48 89 0c 24          	mov    %rcx,(%rsp)
  804ae0:	49 89 f9             	mov    %rdi,%r9
  804ae3:	49 89 f0             	mov    %rsi,%r8
  804ae6:	48 89 d1             	mov    %rdx,%rcx
  804ae9:	48 89 c2             	mov    %rax,%rdx
  804aec:	be 01 00 00 00       	mov    $0x1,%esi
  804af1:	bf 05 00 00 00       	mov    $0x5,%edi
  804af6:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804afd:	00 00 00 
  804b00:	ff d0                	callq  *%rax
}
  804b02:	c9                   	leaveq 
  804b03:	c3                   	retq   

0000000000804b04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804b04:	55                   	push   %rbp
  804b05:	48 89 e5             	mov    %rsp,%rbp
  804b08:	48 83 ec 20          	sub    $0x20,%rsp
  804b0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b1a:	48 98                	cltq   
  804b1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b23:	00 
  804b24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b30:	48 89 d1             	mov    %rdx,%rcx
  804b33:	48 89 c2             	mov    %rax,%rdx
  804b36:	be 01 00 00 00       	mov    $0x1,%esi
  804b3b:	bf 06 00 00 00       	mov    $0x6,%edi
  804b40:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804b47:	00 00 00 
  804b4a:	ff d0                	callq  *%rax
}
  804b4c:	c9                   	leaveq 
  804b4d:	c3                   	retq   

0000000000804b4e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804b4e:	55                   	push   %rbp
  804b4f:	48 89 e5             	mov    %rsp,%rbp
  804b52:	48 83 ec 10          	sub    $0x10,%rsp
  804b56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b59:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804b5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b5f:	48 63 d0             	movslq %eax,%rdx
  804b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b65:	48 98                	cltq   
  804b67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b6e:	00 
  804b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b7b:	48 89 d1             	mov    %rdx,%rcx
  804b7e:	48 89 c2             	mov    %rax,%rdx
  804b81:	be 01 00 00 00       	mov    $0x1,%esi
  804b86:	bf 08 00 00 00       	mov    $0x8,%edi
  804b8b:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804b92:	00 00 00 
  804b95:	ff d0                	callq  *%rax
}
  804b97:	c9                   	leaveq 
  804b98:	c3                   	retq   

0000000000804b99 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804b99:	55                   	push   %rbp
  804b9a:	48 89 e5             	mov    %rsp,%rbp
  804b9d:	48 83 ec 20          	sub    $0x20,%rsp
  804ba1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ba4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804ba8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804baf:	48 98                	cltq   
  804bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804bb8:	00 
  804bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804bc5:	48 89 d1             	mov    %rdx,%rcx
  804bc8:	48 89 c2             	mov    %rax,%rdx
  804bcb:	be 01 00 00 00       	mov    $0x1,%esi
  804bd0:	bf 09 00 00 00       	mov    $0x9,%edi
  804bd5:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804bdc:	00 00 00 
  804bdf:	ff d0                	callq  *%rax
}
  804be1:	c9                   	leaveq 
  804be2:	c3                   	retq   

0000000000804be3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804be3:	55                   	push   %rbp
  804be4:	48 89 e5             	mov    %rsp,%rbp
  804be7:	48 83 ec 20          	sub    $0x20,%rsp
  804beb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804bee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bf9:	48 98                	cltq   
  804bfb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c02:	00 
  804c03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c0f:	48 89 d1             	mov    %rdx,%rcx
  804c12:	48 89 c2             	mov    %rax,%rdx
  804c15:	be 01 00 00 00       	mov    $0x1,%esi
  804c1a:	bf 0a 00 00 00       	mov    $0xa,%edi
  804c1f:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804c26:	00 00 00 
  804c29:	ff d0                	callq  *%rax
}
  804c2b:	c9                   	leaveq 
  804c2c:	c3                   	retq   

0000000000804c2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804c2d:	55                   	push   %rbp
  804c2e:	48 89 e5             	mov    %rsp,%rbp
  804c31:	48 83 ec 20          	sub    $0x20,%rsp
  804c35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c3c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804c40:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804c43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c46:	48 63 f0             	movslq %eax,%rsi
  804c49:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c50:	48 98                	cltq   
  804c52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c5d:	00 
  804c5e:	49 89 f1             	mov    %rsi,%r9
  804c61:	49 89 c8             	mov    %rcx,%r8
  804c64:	48 89 d1             	mov    %rdx,%rcx
  804c67:	48 89 c2             	mov    %rax,%rdx
  804c6a:	be 00 00 00 00       	mov    $0x0,%esi
  804c6f:	bf 0c 00 00 00       	mov    $0xc,%edi
  804c74:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804c7b:	00 00 00 
  804c7e:	ff d0                	callq  *%rax
}
  804c80:	c9                   	leaveq 
  804c81:	c3                   	retq   

0000000000804c82 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804c82:	55                   	push   %rbp
  804c83:	48 89 e5             	mov    %rsp,%rbp
  804c86:	48 83 ec 10          	sub    $0x10,%rsp
  804c8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c99:	00 
  804c9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ca0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  804cab:	48 89 c2             	mov    %rax,%rdx
  804cae:	be 01 00 00 00       	mov    $0x1,%esi
  804cb3:	bf 0d 00 00 00       	mov    $0xd,%edi
  804cb8:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  804cbf:	00 00 00 
  804cc2:	ff d0                	callq  *%rax
}
  804cc4:	c9                   	leaveq 
  804cc5:	c3                   	retq   

0000000000804cc6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804cc6:	55                   	push   %rbp
  804cc7:	48 89 e5             	mov    %rsp,%rbp
  804cca:	48 83 ec 10          	sub    $0x10,%rsp
  804cce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804cd2:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804cd9:	00 00 00 
  804cdc:	48 8b 00             	mov    (%rax),%rax
  804cdf:	48 85 c0             	test   %rax,%rax
  804ce2:	75 3a                	jne    804d1e <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  804ce4:	ba 07 00 00 00       	mov    $0x7,%edx
  804ce9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804cee:	bf 00 00 00 00       	mov    $0x0,%edi
  804cf3:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  804cfa:	00 00 00 
  804cfd:	ff d0                	callq  *%rax
  804cff:	85 c0                	test   %eax,%eax
  804d01:	75 1b                	jne    804d1e <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804d03:	48 be 31 4d 80 00 00 	movabs $0x804d31,%rsi
  804d0a:	00 00 00 
  804d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  804d12:	48 b8 e3 4b 80 00 00 	movabs $0x804be3,%rax
  804d19:	00 00 00 
  804d1c:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804d1e:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  804d25:	00 00 00 
  804d28:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804d2c:	48 89 10             	mov    %rdx,(%rax)
}
  804d2f:	c9                   	leaveq 
  804d30:	c3                   	retq   

0000000000804d31 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804d31:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804d34:	48 a1 20 20 81 00 00 	movabs 0x812020,%rax
  804d3b:	00 00 00 
	call *%rax
  804d3e:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  804d40:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  804d43:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804d4a:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  804d4b:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804d52:	00 
	pushq %rbx		// push utf_rip into new stack
  804d53:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  804d54:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  804d5b:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  804d5e:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  804d62:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  804d66:	4c 8b 3c 24          	mov    (%rsp),%r15
  804d6a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804d6f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804d74:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804d79:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804d7e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804d83:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804d88:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804d8d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804d92:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804d97:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804d9c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804da1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804da6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804dab:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804db0:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  804db4:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  804db8:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  804db9:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804dba:	c3                   	retq   

0000000000804dbb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804dbb:	55                   	push   %rbp
  804dbc:	48 89 e5             	mov    %rsp,%rbp
  804dbf:	48 83 ec 30          	sub    $0x30,%rsp
  804dc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804dc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804dcb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804dcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804dd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804dd7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804ddc:	75 0e                	jne    804dec <ipc_recv+0x31>
		page = (void *)KERNBASE;
  804dde:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804de5:	00 00 00 
  804de8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  804dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804df0:	48 89 c7             	mov    %rax,%rdi
  804df3:	48 b8 82 4c 80 00 00 	movabs $0x804c82,%rax
  804dfa:	00 00 00 
  804dfd:	ff d0                	callq  *%rax
  804dff:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804e06:	79 27                	jns    804e2f <ipc_recv+0x74>
		if (from_env_store != NULL)
  804e08:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e0d:	74 0a                	je     804e19 <ipc_recv+0x5e>
			*from_env_store = 0;
  804e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e13:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  804e19:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e1e:	74 0a                	je     804e2a <ipc_recv+0x6f>
			*perm_store = 0;
  804e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e24:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804e2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804e2d:	eb 53                	jmp    804e82 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  804e2f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e34:	74 19                	je     804e4f <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  804e36:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804e3d:	00 00 00 
  804e40:	48 8b 00             	mov    (%rax),%rax
  804e43:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e4d:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  804e4f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e54:	74 19                	je     804e6f <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  804e56:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804e5d:	00 00 00 
  804e60:	48 8b 00             	mov    (%rax),%rax
  804e63:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804e69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e6d:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  804e6f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  804e76:	00 00 00 
  804e79:	48 8b 00             	mov    (%rax),%rax
  804e7c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  804e82:	c9                   	leaveq 
  804e83:	c3                   	retq   

0000000000804e84 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e84:	55                   	push   %rbp
  804e85:	48 89 e5             	mov    %rsp,%rbp
  804e88:	48 83 ec 30          	sub    $0x30,%rsp
  804e8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804e8f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804e92:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804e96:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804e99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804ea1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804ea6:	75 10                	jne    804eb8 <ipc_send+0x34>
		page = (void *)KERNBASE;
  804ea8:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804eaf:	00 00 00 
  804eb2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804eb6:	eb 0e                	jmp    804ec6 <ipc_send+0x42>
  804eb8:	eb 0c                	jmp    804ec6 <ipc_send+0x42>
		sys_yield();
  804eba:	48 b8 1b 4a 80 00 00 	movabs $0x804a1b,%rax
  804ec1:	00 00 00 
  804ec4:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804ec6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804ec9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804ecc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804ed0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ed3:	89 c7                	mov    %eax,%edi
  804ed5:	48 b8 2d 4c 80 00 00 	movabs $0x804c2d,%rax
  804edc:	00 00 00 
  804edf:	ff d0                	callq  *%rax
  804ee1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804ee4:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  804ee8:	74 d0                	je     804eba <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  804eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804eee:	74 2a                	je     804f1a <ipc_send+0x96>
		panic("error on ipc send procedure");
  804ef0:	48 ba 8b 71 80 00 00 	movabs $0x80718b,%rdx
  804ef7:	00 00 00 
  804efa:	be 49 00 00 00       	mov    $0x49,%esi
  804eff:	48 bf a7 71 80 00 00 	movabs $0x8071a7,%rdi
  804f06:	00 00 00 
  804f09:	b8 00 00 00 00       	mov    $0x0,%eax
  804f0e:	48 b9 49 31 80 00 00 	movabs $0x803149,%rcx
  804f15:	00 00 00 
  804f18:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  804f1a:	c9                   	leaveq 
  804f1b:	c3                   	retq   

0000000000804f1c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804f1c:	55                   	push   %rbp
  804f1d:	48 89 e5             	mov    %rsp,%rbp
  804f20:	48 83 ec 14          	sub    $0x14,%rsp
  804f24:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804f27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f2e:	eb 5e                	jmp    804f8e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804f30:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804f37:	00 00 00 
  804f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f3d:	48 63 d0             	movslq %eax,%rdx
  804f40:	48 89 d0             	mov    %rdx,%rax
  804f43:	48 c1 e0 03          	shl    $0x3,%rax
  804f47:	48 01 d0             	add    %rdx,%rax
  804f4a:	48 c1 e0 05          	shl    $0x5,%rax
  804f4e:	48 01 c8             	add    %rcx,%rax
  804f51:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804f57:	8b 00                	mov    (%rax),%eax
  804f59:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804f5c:	75 2c                	jne    804f8a <ipc_find_env+0x6e>
			return envs[i].env_id;
  804f5e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804f65:	00 00 00 
  804f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f6b:	48 63 d0             	movslq %eax,%rdx
  804f6e:	48 89 d0             	mov    %rdx,%rax
  804f71:	48 c1 e0 03          	shl    $0x3,%rax
  804f75:	48 01 d0             	add    %rdx,%rax
  804f78:	48 c1 e0 05          	shl    $0x5,%rax
  804f7c:	48 01 c8             	add    %rcx,%rax
  804f7f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804f85:	8b 40 08             	mov    0x8(%rax),%eax
  804f88:	eb 12                	jmp    804f9c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804f8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f8e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804f95:	7e 99                	jle    804f30 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f9c:	c9                   	leaveq 
  804f9d:	c3                   	retq   

0000000000804f9e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804f9e:	55                   	push   %rbp
  804f9f:	48 89 e5             	mov    %rsp,%rbp
  804fa2:	48 83 ec 08          	sub    $0x8,%rsp
  804fa6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804faa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804fae:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804fb5:	ff ff ff 
  804fb8:	48 01 d0             	add    %rdx,%rax
  804fbb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804fbf:	c9                   	leaveq 
  804fc0:	c3                   	retq   

0000000000804fc1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804fc1:	55                   	push   %rbp
  804fc2:	48 89 e5             	mov    %rsp,%rbp
  804fc5:	48 83 ec 08          	sub    $0x8,%rsp
  804fc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fd1:	48 89 c7             	mov    %rax,%rdi
  804fd4:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  804fdb:	00 00 00 
  804fde:	ff d0                	callq  *%rax
  804fe0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804fe6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804fea:	c9                   	leaveq 
  804feb:	c3                   	retq   

0000000000804fec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804fec:	55                   	push   %rbp
  804fed:	48 89 e5             	mov    %rsp,%rbp
  804ff0:	48 83 ec 18          	sub    $0x18,%rsp
  804ff4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804fff:	eb 6b                	jmp    80506c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  805001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805004:	48 98                	cltq   
  805006:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80500c:	48 c1 e0 0c          	shl    $0xc,%rax
  805010:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  805014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805018:	48 c1 e8 15          	shr    $0x15,%rax
  80501c:	48 89 c2             	mov    %rax,%rdx
  80501f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805026:	01 00 00 
  805029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80502d:	83 e0 01             	and    $0x1,%eax
  805030:	48 85 c0             	test   %rax,%rax
  805033:	74 21                	je     805056 <fd_alloc+0x6a>
  805035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805039:	48 c1 e8 0c          	shr    $0xc,%rax
  80503d:	48 89 c2             	mov    %rax,%rdx
  805040:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805047:	01 00 00 
  80504a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80504e:	83 e0 01             	and    $0x1,%eax
  805051:	48 85 c0             	test   %rax,%rax
  805054:	75 12                	jne    805068 <fd_alloc+0x7c>
			*fd_store = fd;
  805056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80505a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80505e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805061:	b8 00 00 00 00       	mov    $0x0,%eax
  805066:	eb 1a                	jmp    805082 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805068:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80506c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805070:	7e 8f                	jle    805001 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  805072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805076:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80507d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  805082:	c9                   	leaveq 
  805083:	c3                   	retq   

0000000000805084 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  805084:	55                   	push   %rbp
  805085:	48 89 e5             	mov    %rsp,%rbp
  805088:	48 83 ec 20          	sub    $0x20,%rsp
  80508c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80508f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805093:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805097:	78 06                	js     80509f <fd_lookup+0x1b>
  805099:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80509d:	7e 07                	jle    8050a6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80509f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8050a4:	eb 6c                	jmp    805112 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8050a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8050a9:	48 98                	cltq   
  8050ab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8050b1:	48 c1 e0 0c          	shl    $0xc,%rax
  8050b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8050b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050bd:	48 c1 e8 15          	shr    $0x15,%rax
  8050c1:	48 89 c2             	mov    %rax,%rdx
  8050c4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8050cb:	01 00 00 
  8050ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050d2:	83 e0 01             	and    $0x1,%eax
  8050d5:	48 85 c0             	test   %rax,%rax
  8050d8:	74 21                	je     8050fb <fd_lookup+0x77>
  8050da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050de:	48 c1 e8 0c          	shr    $0xc,%rax
  8050e2:	48 89 c2             	mov    %rax,%rdx
  8050e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8050ec:	01 00 00 
  8050ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050f3:	83 e0 01             	and    $0x1,%eax
  8050f6:	48 85 c0             	test   %rax,%rax
  8050f9:	75 07                	jne    805102 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8050fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805100:	eb 10                	jmp    805112 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805106:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80510a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80510d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805112:	c9                   	leaveq 
  805113:	c3                   	retq   

0000000000805114 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805114:	55                   	push   %rbp
  805115:	48 89 e5             	mov    %rsp,%rbp
  805118:	48 83 ec 30          	sub    $0x30,%rsp
  80511c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805120:	89 f0                	mov    %esi,%eax
  805122:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805125:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805129:	48 89 c7             	mov    %rax,%rdi
  80512c:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  805133:	00 00 00 
  805136:	ff d0                	callq  *%rax
  805138:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80513c:	48 89 d6             	mov    %rdx,%rsi
  80513f:	89 c7                	mov    %eax,%edi
  805141:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  805148:	00 00 00 
  80514b:	ff d0                	callq  *%rax
  80514d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805154:	78 0a                	js     805160 <fd_close+0x4c>
	    || fd != fd2)
  805156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80515a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80515e:	74 12                	je     805172 <fd_close+0x5e>
		return (must_exist ? r : 0);
  805160:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805164:	74 05                	je     80516b <fd_close+0x57>
  805166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805169:	eb 05                	jmp    805170 <fd_close+0x5c>
  80516b:	b8 00 00 00 00       	mov    $0x0,%eax
  805170:	eb 69                	jmp    8051db <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  805172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805176:	8b 00                	mov    (%rax),%eax
  805178:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80517c:	48 89 d6             	mov    %rdx,%rsi
  80517f:	89 c7                	mov    %eax,%edi
  805181:	48 b8 dd 51 80 00 00 	movabs $0x8051dd,%rax
  805188:	00 00 00 
  80518b:	ff d0                	callq  *%rax
  80518d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805194:	78 2a                	js     8051c0 <fd_close+0xac>
		if (dev->dev_close)
  805196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80519a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80519e:	48 85 c0             	test   %rax,%rax
  8051a1:	74 16                	je     8051b9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8051a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051a7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8051ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8051af:	48 89 d7             	mov    %rdx,%rdi
  8051b2:	ff d0                	callq  *%rax
  8051b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051b7:	eb 07                	jmp    8051c0 <fd_close+0xac>
		else
			r = 0;
  8051b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8051c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051c4:	48 89 c6             	mov    %rax,%rsi
  8051c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8051cc:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  8051d3:	00 00 00 
  8051d6:	ff d0                	callq  *%rax
	return r;
  8051d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8051db:	c9                   	leaveq 
  8051dc:	c3                   	retq   

00000000008051dd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8051dd:	55                   	push   %rbp
  8051de:	48 89 e5             	mov    %rsp,%rbp
  8051e1:	48 83 ec 20          	sub    $0x20,%rsp
  8051e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8051e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8051ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8051f3:	eb 41                	jmp    805236 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8051f5:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8051fc:	00 00 00 
  8051ff:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805202:	48 63 d2             	movslq %edx,%rdx
  805205:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805209:	8b 00                	mov    (%rax),%eax
  80520b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80520e:	75 22                	jne    805232 <dev_lookup+0x55>
			*dev = devtab[i];
  805210:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805217:	00 00 00 
  80521a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80521d:	48 63 d2             	movslq %edx,%rdx
  805220:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805224:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805228:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80522b:	b8 00 00 00 00       	mov    $0x0,%eax
  805230:	eb 60                	jmp    805292 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  805232:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805236:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  80523d:	00 00 00 
  805240:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805243:	48 63 d2             	movslq %edx,%rdx
  805246:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80524a:	48 85 c0             	test   %rax,%rax
  80524d:	75 a6                	jne    8051f5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80524f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805256:	00 00 00 
  805259:	48 8b 00             	mov    (%rax),%rax
  80525c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805262:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805265:	89 c6                	mov    %eax,%esi
  805267:	48 bf b8 71 80 00 00 	movabs $0x8071b8,%rdi
  80526e:	00 00 00 
  805271:	b8 00 00 00 00       	mov    $0x0,%eax
  805276:	48 b9 82 33 80 00 00 	movabs $0x803382,%rcx
  80527d:	00 00 00 
  805280:	ff d1                	callq  *%rcx
	*dev = 0;
  805282:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805286:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80528d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805292:	c9                   	leaveq 
  805293:	c3                   	retq   

0000000000805294 <close>:

int
close(int fdnum)
{
  805294:	55                   	push   %rbp
  805295:	48 89 e5             	mov    %rsp,%rbp
  805298:	48 83 ec 20          	sub    $0x20,%rsp
  80529c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80529f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8052a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8052a6:	48 89 d6             	mov    %rdx,%rsi
  8052a9:	89 c7                	mov    %eax,%edi
  8052ab:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  8052b2:	00 00 00 
  8052b5:	ff d0                	callq  *%rax
  8052b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052be:	79 05                	jns    8052c5 <close+0x31>
		return r;
  8052c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052c3:	eb 18                	jmp    8052dd <close+0x49>
	else
		return fd_close(fd, 1);
  8052c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052c9:	be 01 00 00 00       	mov    $0x1,%esi
  8052ce:	48 89 c7             	mov    %rax,%rdi
  8052d1:	48 b8 14 51 80 00 00 	movabs $0x805114,%rax
  8052d8:	00 00 00 
  8052db:	ff d0                	callq  *%rax
}
  8052dd:	c9                   	leaveq 
  8052de:	c3                   	retq   

00000000008052df <close_all>:

void
close_all(void)
{
  8052df:	55                   	push   %rbp
  8052e0:	48 89 e5             	mov    %rsp,%rbp
  8052e3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8052e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8052ee:	eb 15                	jmp    805305 <close_all+0x26>
		close(i);
  8052f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052f3:	89 c7                	mov    %eax,%edi
  8052f5:	48 b8 94 52 80 00 00 	movabs $0x805294,%rax
  8052fc:	00 00 00 
  8052ff:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  805301:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805305:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805309:	7e e5                	jle    8052f0 <close_all+0x11>
		close(i);
}
  80530b:	c9                   	leaveq 
  80530c:	c3                   	retq   

000000000080530d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80530d:	55                   	push   %rbp
  80530e:	48 89 e5             	mov    %rsp,%rbp
  805311:	48 83 ec 40          	sub    $0x40,%rsp
  805315:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805318:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80531b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80531f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805322:	48 89 d6             	mov    %rdx,%rsi
  805325:	89 c7                	mov    %eax,%edi
  805327:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  80532e:	00 00 00 
  805331:	ff d0                	callq  *%rax
  805333:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805336:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80533a:	79 08                	jns    805344 <dup+0x37>
		return r;
  80533c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80533f:	e9 70 01 00 00       	jmpq   8054b4 <dup+0x1a7>
	close(newfdnum);
  805344:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805347:	89 c7                	mov    %eax,%edi
  805349:	48 b8 94 52 80 00 00 	movabs $0x805294,%rax
  805350:	00 00 00 
  805353:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805355:	8b 45 c8             	mov    -0x38(%rbp),%eax
  805358:	48 98                	cltq   
  80535a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805360:	48 c1 e0 0c          	shl    $0xc,%rax
  805364:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  805368:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80536c:	48 89 c7             	mov    %rax,%rdi
  80536f:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  805376:	00 00 00 
  805379:	ff d0                	callq  *%rax
  80537b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80537f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805383:	48 89 c7             	mov    %rax,%rdi
  805386:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  80538d:	00 00 00 
  805390:	ff d0                	callq  *%rax
  805392:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80539a:	48 c1 e8 15          	shr    $0x15,%rax
  80539e:	48 89 c2             	mov    %rax,%rdx
  8053a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8053a8:	01 00 00 
  8053ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053af:	83 e0 01             	and    $0x1,%eax
  8053b2:	48 85 c0             	test   %rax,%rax
  8053b5:	74 73                	je     80542a <dup+0x11d>
  8053b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8053bf:	48 89 c2             	mov    %rax,%rdx
  8053c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053c9:	01 00 00 
  8053cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053d0:	83 e0 01             	and    $0x1,%eax
  8053d3:	48 85 c0             	test   %rax,%rax
  8053d6:	74 52                	je     80542a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8053d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8053e0:	48 89 c2             	mov    %rax,%rdx
  8053e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053ea:	01 00 00 
  8053ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8053f6:	89 c1                	mov    %eax,%ecx
  8053f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805400:	41 89 c8             	mov    %ecx,%r8d
  805403:	48 89 d1             	mov    %rdx,%rcx
  805406:	ba 00 00 00 00       	mov    $0x0,%edx
  80540b:	48 89 c6             	mov    %rax,%rsi
  80540e:	bf 00 00 00 00       	mov    $0x0,%edi
  805413:	48 b8 a9 4a 80 00 00 	movabs $0x804aa9,%rax
  80541a:	00 00 00 
  80541d:	ff d0                	callq  *%rax
  80541f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805426:	79 02                	jns    80542a <dup+0x11d>
			goto err;
  805428:	eb 57                	jmp    805481 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80542a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80542e:	48 c1 e8 0c          	shr    $0xc,%rax
  805432:	48 89 c2             	mov    %rax,%rdx
  805435:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80543c:	01 00 00 
  80543f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805443:	25 07 0e 00 00       	and    $0xe07,%eax
  805448:	89 c1                	mov    %eax,%ecx
  80544a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80544e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805452:	41 89 c8             	mov    %ecx,%r8d
  805455:	48 89 d1             	mov    %rdx,%rcx
  805458:	ba 00 00 00 00       	mov    $0x0,%edx
  80545d:	48 89 c6             	mov    %rax,%rsi
  805460:	bf 00 00 00 00       	mov    $0x0,%edi
  805465:	48 b8 a9 4a 80 00 00 	movabs $0x804aa9,%rax
  80546c:	00 00 00 
  80546f:	ff d0                	callq  *%rax
  805471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805478:	79 02                	jns    80547c <dup+0x16f>
		goto err;
  80547a:	eb 05                	jmp    805481 <dup+0x174>

	return newfdnum;
  80547c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80547f:	eb 33                	jmp    8054b4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  805481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805485:	48 89 c6             	mov    %rax,%rsi
  805488:	bf 00 00 00 00       	mov    $0x0,%edi
  80548d:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  805494:	00 00 00 
  805497:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805499:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80549d:	48 89 c6             	mov    %rax,%rsi
  8054a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8054a5:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  8054ac:	00 00 00 
  8054af:	ff d0                	callq  *%rax
	return r;
  8054b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8054b4:	c9                   	leaveq 
  8054b5:	c3                   	retq   

00000000008054b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8054b6:	55                   	push   %rbp
  8054b7:	48 89 e5             	mov    %rsp,%rbp
  8054ba:	48 83 ec 40          	sub    $0x40,%rsp
  8054be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8054c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8054c5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8054c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8054cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8054d0:	48 89 d6             	mov    %rdx,%rsi
  8054d3:	89 c7                	mov    %eax,%edi
  8054d5:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  8054dc:	00 00 00 
  8054df:	ff d0                	callq  *%rax
  8054e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054e8:	78 24                	js     80550e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8054ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8054ee:	8b 00                	mov    (%rax),%eax
  8054f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8054f4:	48 89 d6             	mov    %rdx,%rsi
  8054f7:	89 c7                	mov    %eax,%edi
  8054f9:	48 b8 dd 51 80 00 00 	movabs $0x8051dd,%rax
  805500:	00 00 00 
  805503:	ff d0                	callq  *%rax
  805505:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805508:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80550c:	79 05                	jns    805513 <read+0x5d>
		return r;
  80550e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805511:	eb 76                	jmp    805589 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805517:	8b 40 08             	mov    0x8(%rax),%eax
  80551a:	83 e0 03             	and    $0x3,%eax
  80551d:	83 f8 01             	cmp    $0x1,%eax
  805520:	75 3a                	jne    80555c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805522:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805529:	00 00 00 
  80552c:	48 8b 00             	mov    (%rax),%rax
  80552f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805535:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805538:	89 c6                	mov    %eax,%esi
  80553a:	48 bf d7 71 80 00 00 	movabs $0x8071d7,%rdi
  805541:	00 00 00 
  805544:	b8 00 00 00 00       	mov    $0x0,%eax
  805549:	48 b9 82 33 80 00 00 	movabs $0x803382,%rcx
  805550:	00 00 00 
  805553:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80555a:	eb 2d                	jmp    805589 <read+0xd3>
	}
	if (!dev->dev_read)
  80555c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805560:	48 8b 40 10          	mov    0x10(%rax),%rax
  805564:	48 85 c0             	test   %rax,%rax
  805567:	75 07                	jne    805570 <read+0xba>
		return -E_NOT_SUPP;
  805569:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80556e:	eb 19                	jmp    805589 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805570:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805574:	48 8b 40 10          	mov    0x10(%rax),%rax
  805578:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80557c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805580:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805584:	48 89 cf             	mov    %rcx,%rdi
  805587:	ff d0                	callq  *%rax
}
  805589:	c9                   	leaveq 
  80558a:	c3                   	retq   

000000000080558b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80558b:	55                   	push   %rbp
  80558c:	48 89 e5             	mov    %rsp,%rbp
  80558f:	48 83 ec 30          	sub    $0x30,%rsp
  805593:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805596:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80559a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80559e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8055a5:	eb 49                	jmp    8055f0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8055a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055aa:	48 98                	cltq   
  8055ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8055b0:	48 29 c2             	sub    %rax,%rdx
  8055b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055b6:	48 63 c8             	movslq %eax,%rcx
  8055b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8055bd:	48 01 c1             	add    %rax,%rcx
  8055c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055c3:	48 89 ce             	mov    %rcx,%rsi
  8055c6:	89 c7                	mov    %eax,%edi
  8055c8:	48 b8 b6 54 80 00 00 	movabs $0x8054b6,%rax
  8055cf:	00 00 00 
  8055d2:	ff d0                	callq  *%rax
  8055d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8055d7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8055db:	79 05                	jns    8055e2 <readn+0x57>
			return m;
  8055dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8055e0:	eb 1c                	jmp    8055fe <readn+0x73>
		if (m == 0)
  8055e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8055e6:	75 02                	jne    8055ea <readn+0x5f>
			break;
  8055e8:	eb 11                	jmp    8055fb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8055ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8055ed:	01 45 fc             	add    %eax,-0x4(%rbp)
  8055f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055f3:	48 98                	cltq   
  8055f5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8055f9:	72 ac                	jb     8055a7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8055fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8055fe:	c9                   	leaveq 
  8055ff:	c3                   	retq   

0000000000805600 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805600:	55                   	push   %rbp
  805601:	48 89 e5             	mov    %rsp,%rbp
  805604:	48 83 ec 40          	sub    $0x40,%rsp
  805608:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80560b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80560f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805613:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805617:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80561a:	48 89 d6             	mov    %rdx,%rsi
  80561d:	89 c7                	mov    %eax,%edi
  80561f:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  805626:	00 00 00 
  805629:	ff d0                	callq  *%rax
  80562b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80562e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805632:	78 24                	js     805658 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805638:	8b 00                	mov    (%rax),%eax
  80563a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80563e:	48 89 d6             	mov    %rdx,%rsi
  805641:	89 c7                	mov    %eax,%edi
  805643:	48 b8 dd 51 80 00 00 	movabs $0x8051dd,%rax
  80564a:	00 00 00 
  80564d:	ff d0                	callq  *%rax
  80564f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805656:	79 05                	jns    80565d <write+0x5d>
		return r;
  805658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80565b:	eb 75                	jmp    8056d2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80565d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805661:	8b 40 08             	mov    0x8(%rax),%eax
  805664:	83 e0 03             	and    $0x3,%eax
  805667:	85 c0                	test   %eax,%eax
  805669:	75 3a                	jne    8056a5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80566b:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805672:	00 00 00 
  805675:	48 8b 00             	mov    (%rax),%rax
  805678:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80567e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805681:	89 c6                	mov    %eax,%esi
  805683:	48 bf f3 71 80 00 00 	movabs $0x8071f3,%rdi
  80568a:	00 00 00 
  80568d:	b8 00 00 00 00       	mov    $0x0,%eax
  805692:	48 b9 82 33 80 00 00 	movabs $0x803382,%rcx
  805699:	00 00 00 
  80569c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80569e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8056a3:	eb 2d                	jmp    8056d2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8056a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056a9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8056ad:	48 85 c0             	test   %rax,%rax
  8056b0:	75 07                	jne    8056b9 <write+0xb9>
		return -E_NOT_SUPP;
  8056b2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8056b7:	eb 19                	jmp    8056d2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8056b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056bd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8056c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8056c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8056c9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8056cd:	48 89 cf             	mov    %rcx,%rdi
  8056d0:	ff d0                	callq  *%rax
}
  8056d2:	c9                   	leaveq 
  8056d3:	c3                   	retq   

00000000008056d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8056d4:	55                   	push   %rbp
  8056d5:	48 89 e5             	mov    %rsp,%rbp
  8056d8:	48 83 ec 18          	sub    $0x18,%rsp
  8056dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8056df:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8056e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8056e9:	48 89 d6             	mov    %rdx,%rsi
  8056ec:	89 c7                	mov    %eax,%edi
  8056ee:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  8056f5:	00 00 00 
  8056f8:	ff d0                	callq  *%rax
  8056fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805701:	79 05                	jns    805708 <seek+0x34>
		return r;
  805703:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805706:	eb 0f                	jmp    805717 <seek+0x43>
	fd->fd_offset = offset;
  805708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80570c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80570f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805717:	c9                   	leaveq 
  805718:	c3                   	retq   

0000000000805719 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805719:	55                   	push   %rbp
  80571a:	48 89 e5             	mov    %rsp,%rbp
  80571d:	48 83 ec 30          	sub    $0x30,%rsp
  805721:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805724:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805727:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80572b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80572e:	48 89 d6             	mov    %rdx,%rsi
  805731:	89 c7                	mov    %eax,%edi
  805733:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  80573a:	00 00 00 
  80573d:	ff d0                	callq  *%rax
  80573f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805746:	78 24                	js     80576c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80574c:	8b 00                	mov    (%rax),%eax
  80574e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805752:	48 89 d6             	mov    %rdx,%rsi
  805755:	89 c7                	mov    %eax,%edi
  805757:	48 b8 dd 51 80 00 00 	movabs $0x8051dd,%rax
  80575e:	00 00 00 
  805761:	ff d0                	callq  *%rax
  805763:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805766:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80576a:	79 05                	jns    805771 <ftruncate+0x58>
		return r;
  80576c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80576f:	eb 72                	jmp    8057e3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805775:	8b 40 08             	mov    0x8(%rax),%eax
  805778:	83 e0 03             	and    $0x3,%eax
  80577b:	85 c0                	test   %eax,%eax
  80577d:	75 3a                	jne    8057b9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80577f:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805786:	00 00 00 
  805789:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80578c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805792:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805795:	89 c6                	mov    %eax,%esi
  805797:	48 bf 10 72 80 00 00 	movabs $0x807210,%rdi
  80579e:	00 00 00 
  8057a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8057a6:	48 b9 82 33 80 00 00 	movabs $0x803382,%rcx
  8057ad:	00 00 00 
  8057b0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8057b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8057b7:	eb 2a                	jmp    8057e3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8057b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057bd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8057c1:	48 85 c0             	test   %rax,%rax
  8057c4:	75 07                	jne    8057cd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8057c6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8057cb:	eb 16                	jmp    8057e3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8057cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057d1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8057d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8057d9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8057dc:	89 ce                	mov    %ecx,%esi
  8057de:	48 89 d7             	mov    %rdx,%rdi
  8057e1:	ff d0                	callq  *%rax
}
  8057e3:	c9                   	leaveq 
  8057e4:	c3                   	retq   

00000000008057e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8057e5:	55                   	push   %rbp
  8057e6:	48 89 e5             	mov    %rsp,%rbp
  8057e9:	48 83 ec 30          	sub    $0x30,%rsp
  8057ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8057f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8057f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8057f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8057fb:	48 89 d6             	mov    %rdx,%rsi
  8057fe:	89 c7                	mov    %eax,%edi
  805800:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  805807:	00 00 00 
  80580a:	ff d0                	callq  *%rax
  80580c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80580f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805813:	78 24                	js     805839 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805819:	8b 00                	mov    (%rax),%eax
  80581b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80581f:	48 89 d6             	mov    %rdx,%rsi
  805822:	89 c7                	mov    %eax,%edi
  805824:	48 b8 dd 51 80 00 00 	movabs $0x8051dd,%rax
  80582b:	00 00 00 
  80582e:	ff d0                	callq  *%rax
  805830:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805833:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805837:	79 05                	jns    80583e <fstat+0x59>
		return r;
  805839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80583c:	eb 5e                	jmp    80589c <fstat+0xb7>
	if (!dev->dev_stat)
  80583e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805842:	48 8b 40 28          	mov    0x28(%rax),%rax
  805846:	48 85 c0             	test   %rax,%rax
  805849:	75 07                	jne    805852 <fstat+0x6d>
		return -E_NOT_SUPP;
  80584b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805850:	eb 4a                	jmp    80589c <fstat+0xb7>
	stat->st_name[0] = 0;
  805852:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805856:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805859:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80585d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805864:	00 00 00 
	stat->st_isdir = 0;
  805867:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80586b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805872:	00 00 00 
	stat->st_dev = dev;
  805875:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805879:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80587d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805888:	48 8b 40 28          	mov    0x28(%rax),%rax
  80588c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805890:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805894:	48 89 ce             	mov    %rcx,%rsi
  805897:	48 89 d7             	mov    %rdx,%rdi
  80589a:	ff d0                	callq  *%rax
}
  80589c:	c9                   	leaveq 
  80589d:	c3                   	retq   

000000000080589e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80589e:	55                   	push   %rbp
  80589f:	48 89 e5             	mov    %rsp,%rbp
  8058a2:	48 83 ec 20          	sub    $0x20,%rsp
  8058a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8058aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8058ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058b2:	be 00 00 00 00       	mov    $0x0,%esi
  8058b7:	48 89 c7             	mov    %rax,%rdi
  8058ba:	48 b8 8c 59 80 00 00 	movabs $0x80598c,%rax
  8058c1:	00 00 00 
  8058c4:	ff d0                	callq  *%rax
  8058c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058cd:	79 05                	jns    8058d4 <stat+0x36>
		return fd;
  8058cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058d2:	eb 2f                	jmp    805903 <stat+0x65>
	r = fstat(fd, stat);
  8058d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8058d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058db:	48 89 d6             	mov    %rdx,%rsi
  8058de:	89 c7                	mov    %eax,%edi
  8058e0:	48 b8 e5 57 80 00 00 	movabs $0x8057e5,%rax
  8058e7:	00 00 00 
  8058ea:	ff d0                	callq  *%rax
  8058ec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8058ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058f2:	89 c7                	mov    %eax,%edi
  8058f4:	48 b8 94 52 80 00 00 	movabs $0x805294,%rax
  8058fb:	00 00 00 
  8058fe:	ff d0                	callq  *%rax
	return r;
  805900:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805903:	c9                   	leaveq 
  805904:	c3                   	retq   

0000000000805905 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805905:	55                   	push   %rbp
  805906:	48 89 e5             	mov    %rsp,%rbp
  805909:	48 83 ec 10          	sub    $0x10,%rsp
  80590d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805910:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805914:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  80591b:	00 00 00 
  80591e:	8b 00                	mov    (%rax),%eax
  805920:	85 c0                	test   %eax,%eax
  805922:	75 1d                	jne    805941 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805924:	bf 01 00 00 00       	mov    $0x1,%edi
  805929:	48 b8 1c 4f 80 00 00 	movabs $0x804f1c,%rax
  805930:	00 00 00 
  805933:	ff d0                	callq  *%rax
  805935:	48 ba 04 20 81 00 00 	movabs $0x812004,%rdx
  80593c:	00 00 00 
  80593f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805941:	48 b8 04 20 81 00 00 	movabs $0x812004,%rax
  805948:	00 00 00 
  80594b:	8b 00                	mov    (%rax),%eax
  80594d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805950:	b9 07 00 00 00       	mov    $0x7,%ecx
  805955:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  80595c:	00 00 00 
  80595f:	89 c7                	mov    %eax,%edi
  805961:	48 b8 84 4e 80 00 00 	movabs $0x804e84,%rax
  805968:	00 00 00 
  80596b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80596d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805971:	ba 00 00 00 00       	mov    $0x0,%edx
  805976:	48 89 c6             	mov    %rax,%rsi
  805979:	bf 00 00 00 00       	mov    $0x0,%edi
  80597e:	48 b8 bb 4d 80 00 00 	movabs $0x804dbb,%rax
  805985:	00 00 00 
  805988:	ff d0                	callq  *%rax
}
  80598a:	c9                   	leaveq 
  80598b:	c3                   	retq   

000000000080598c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80598c:	55                   	push   %rbp
  80598d:	48 89 e5             	mov    %rsp,%rbp
  805990:	48 83 ec 20          	sub    $0x20,%rsp
  805994:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805998:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80599b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80599f:	48 89 c7             	mov    %rax,%rdi
  8059a2:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  8059a9:	00 00 00 
  8059ac:	ff d0                	callq  *%rax
  8059ae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8059b3:	7e 0a                	jle    8059bf <open+0x33>
		return -E_BAD_PATH;
  8059b5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8059ba:	e9 a5 00 00 00       	jmpq   805a64 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8059bf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8059c3:	48 89 c7             	mov    %rax,%rdi
  8059c6:	48 b8 ec 4f 80 00 00 	movabs $0x804fec,%rax
  8059cd:	00 00 00 
  8059d0:	ff d0                	callq  *%rax
  8059d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059d9:	79 08                	jns    8059e3 <open+0x57>
		return r;
  8059db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059de:	e9 81 00 00 00       	jmpq   805a64 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8059e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059e7:	48 89 c6             	mov    %rax,%rsi
  8059ea:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  8059f1:	00 00 00 
  8059f4:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  8059fb:	00 00 00 
  8059fe:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  805a00:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a07:	00 00 00 
  805a0a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805a0d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  805a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a17:	48 89 c6             	mov    %rax,%rsi
  805a1a:	bf 01 00 00 00       	mov    $0x1,%edi
  805a1f:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805a26:	00 00 00 
  805a29:	ff d0                	callq  *%rax
  805a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a32:	79 1d                	jns    805a51 <open+0xc5>
		fd_close(fd, 0);
  805a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a38:	be 00 00 00 00       	mov    $0x0,%esi
  805a3d:	48 89 c7             	mov    %rax,%rdi
  805a40:	48 b8 14 51 80 00 00 	movabs $0x805114,%rax
  805a47:	00 00 00 
  805a4a:	ff d0                	callq  *%rax
		return r;
  805a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a4f:	eb 13                	jmp    805a64 <open+0xd8>
	}

	return fd2num(fd);
  805a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a55:	48 89 c7             	mov    %rax,%rdi
  805a58:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  805a5f:	00 00 00 
  805a62:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  805a64:	c9                   	leaveq 
  805a65:	c3                   	retq   

0000000000805a66 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805a66:	55                   	push   %rbp
  805a67:	48 89 e5             	mov    %rsp,%rbp
  805a6a:	48 83 ec 10          	sub    $0x10,%rsp
  805a6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a76:	8b 50 0c             	mov    0xc(%rax),%edx
  805a79:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805a80:	00 00 00 
  805a83:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805a85:	be 00 00 00 00       	mov    $0x0,%esi
  805a8a:	bf 06 00 00 00       	mov    $0x6,%edi
  805a8f:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805a96:	00 00 00 
  805a99:	ff d0                	callq  *%rax
}
  805a9b:	c9                   	leaveq 
  805a9c:	c3                   	retq   

0000000000805a9d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805a9d:	55                   	push   %rbp
  805a9e:	48 89 e5             	mov    %rsp,%rbp
  805aa1:	48 83 ec 30          	sub    $0x30,%rsp
  805aa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805aa9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805aad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ab5:	8b 50 0c             	mov    0xc(%rax),%edx
  805ab8:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805abf:	00 00 00 
  805ac2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805ac4:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805acb:	00 00 00 
  805ace:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805ad2:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  805ad6:	be 00 00 00 00       	mov    $0x0,%esi
  805adb:	bf 03 00 00 00       	mov    $0x3,%edi
  805ae0:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805ae7:	00 00 00 
  805aea:	ff d0                	callq  *%rax
  805aec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805aef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805af3:	79 05                	jns    805afa <devfile_read+0x5d>
		return r;
  805af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805af8:	eb 26                	jmp    805b20 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  805afa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805afd:	48 63 d0             	movslq %eax,%rdx
  805b00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b04:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805b0b:	00 00 00 
  805b0e:	48 89 c7             	mov    %rax,%rdi
  805b11:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  805b18:	00 00 00 
  805b1b:	ff d0                	callq  *%rax

	return r;
  805b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  805b20:	c9                   	leaveq 
  805b21:	c3                   	retq   

0000000000805b22 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805b22:	55                   	push   %rbp
  805b23:	48 89 e5             	mov    %rsp,%rbp
  805b26:	48 83 ec 30          	sub    $0x30,%rsp
  805b2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b32:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  805b36:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805b3d:	00 
  805b3e:	76 08                	jbe    805b48 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  805b40:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  805b47:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b4c:	8b 50 0c             	mov    0xc(%rax),%edx
  805b4f:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b56:	00 00 00 
  805b59:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  805b5b:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805b62:	00 00 00 
  805b65:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805b69:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  805b6d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805b71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805b75:	48 89 c6             	mov    %rax,%rsi
  805b78:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  805b7f:	00 00 00 
  805b82:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  805b89:	00 00 00 
  805b8c:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  805b8e:	be 00 00 00 00       	mov    $0x0,%esi
  805b93:	bf 04 00 00 00       	mov    $0x4,%edi
  805b98:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805b9f:	00 00 00 
  805ba2:	ff d0                	callq  *%rax
  805ba4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bab:	79 05                	jns    805bb2 <devfile_write+0x90>
		return r;
  805bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bb0:	eb 03                	jmp    805bb5 <devfile_write+0x93>

	return r;
  805bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  805bb5:	c9                   	leaveq 
  805bb6:	c3                   	retq   

0000000000805bb7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805bb7:	55                   	push   %rbp
  805bb8:	48 89 e5             	mov    %rsp,%rbp
  805bbb:	48 83 ec 20          	sub    $0x20,%rsp
  805bbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805bc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bcb:	8b 50 0c             	mov    0xc(%rax),%edx
  805bce:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805bd5:	00 00 00 
  805bd8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805bda:	be 00 00 00 00       	mov    $0x0,%esi
  805bdf:	bf 05 00 00 00       	mov    $0x5,%edi
  805be4:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805beb:	00 00 00 
  805bee:	ff d0                	callq  *%rax
  805bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bf7:	79 05                	jns    805bfe <devfile_stat+0x47>
		return r;
  805bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bfc:	eb 56                	jmp    805c54 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805bfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c02:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  805c09:	00 00 00 
  805c0c:	48 89 c7             	mov    %rax,%rdi
  805c0f:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  805c16:	00 00 00 
  805c19:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805c1b:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c22:	00 00 00 
  805c25:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805c2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c2f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805c35:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c3c:	00 00 00 
  805c3f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805c45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c49:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c54:	c9                   	leaveq 
  805c55:	c3                   	retq   

0000000000805c56 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805c56:	55                   	push   %rbp
  805c57:	48 89 e5             	mov    %rsp,%rbp
  805c5a:	48 83 ec 10          	sub    $0x10,%rsp
  805c5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805c62:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805c69:	8b 50 0c             	mov    0xc(%rax),%edx
  805c6c:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c73:	00 00 00 
  805c76:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805c78:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  805c7f:	00 00 00 
  805c82:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805c85:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805c88:	be 00 00 00 00       	mov    $0x0,%esi
  805c8d:	bf 02 00 00 00       	mov    $0x2,%edi
  805c92:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805c99:	00 00 00 
  805c9c:	ff d0                	callq  *%rax
}
  805c9e:	c9                   	leaveq 
  805c9f:	c3                   	retq   

0000000000805ca0 <remove>:

// Delete a file
int
remove(const char *path)
{
  805ca0:	55                   	push   %rbp
  805ca1:	48 89 e5             	mov    %rsp,%rbp
  805ca4:	48 83 ec 10          	sub    $0x10,%rsp
  805ca8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cb0:	48 89 c7             	mov    %rax,%rdi
  805cb3:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  805cba:	00 00 00 
  805cbd:	ff d0                	callq  *%rax
  805cbf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805cc4:	7e 07                	jle    805ccd <remove+0x2d>
		return -E_BAD_PATH;
  805cc6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805ccb:	eb 33                	jmp    805d00 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805cd1:	48 89 c6             	mov    %rax,%rsi
  805cd4:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  805cdb:	00 00 00 
  805cde:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  805ce5:	00 00 00 
  805ce8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805cea:	be 00 00 00 00       	mov    $0x0,%esi
  805cef:	bf 07 00 00 00       	mov    $0x7,%edi
  805cf4:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805cfb:	00 00 00 
  805cfe:	ff d0                	callq  *%rax
}
  805d00:	c9                   	leaveq 
  805d01:	c3                   	retq   

0000000000805d02 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805d02:	55                   	push   %rbp
  805d03:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805d06:	be 00 00 00 00       	mov    $0x0,%esi
  805d0b:	bf 08 00 00 00       	mov    $0x8,%edi
  805d10:	48 b8 05 59 80 00 00 	movabs $0x805905,%rax
  805d17:	00 00 00 
  805d1a:	ff d0                	callq  *%rax
}
  805d1c:	5d                   	pop    %rbp
  805d1d:	c3                   	retq   

0000000000805d1e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805d1e:	55                   	push   %rbp
  805d1f:	48 89 e5             	mov    %rsp,%rbp
  805d22:	48 83 ec 18          	sub    $0x18,%rsp
  805d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d2e:	48 c1 e8 15          	shr    $0x15,%rax
  805d32:	48 89 c2             	mov    %rax,%rdx
  805d35:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805d3c:	01 00 00 
  805d3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d43:	83 e0 01             	and    $0x1,%eax
  805d46:	48 85 c0             	test   %rax,%rax
  805d49:	75 07                	jne    805d52 <pageref+0x34>
		return 0;
  805d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  805d50:	eb 53                	jmp    805da5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d56:	48 c1 e8 0c          	shr    $0xc,%rax
  805d5a:	48 89 c2             	mov    %rax,%rdx
  805d5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805d64:	01 00 00 
  805d67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d73:	83 e0 01             	and    $0x1,%eax
  805d76:	48 85 c0             	test   %rax,%rax
  805d79:	75 07                	jne    805d82 <pageref+0x64>
		return 0;
  805d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  805d80:	eb 23                	jmp    805da5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d86:	48 c1 e8 0c          	shr    $0xc,%rax
  805d8a:	48 89 c2             	mov    %rax,%rdx
  805d8d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805d94:	00 00 00 
  805d97:	48 c1 e2 04          	shl    $0x4,%rdx
  805d9b:	48 01 d0             	add    %rdx,%rax
  805d9e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805da2:	0f b7 c0             	movzwl %ax,%eax
}
  805da5:	c9                   	leaveq 
  805da6:	c3                   	retq   

0000000000805da7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805da7:	55                   	push   %rbp
  805da8:	48 89 e5             	mov    %rsp,%rbp
  805dab:	53                   	push   %rbx
  805dac:	48 83 ec 38          	sub    $0x38,%rsp
  805db0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805db4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805db8:	48 89 c7             	mov    %rax,%rdi
  805dbb:	48 b8 ec 4f 80 00 00 	movabs $0x804fec,%rax
  805dc2:	00 00 00 
  805dc5:	ff d0                	callq  *%rax
  805dc7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805dca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805dce:	0f 88 bf 01 00 00    	js     805f93 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805dd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805dd8:	ba 07 04 00 00       	mov    $0x407,%edx
  805ddd:	48 89 c6             	mov    %rax,%rsi
  805de0:	bf 00 00 00 00       	mov    $0x0,%edi
  805de5:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  805dec:	00 00 00 
  805def:	ff d0                	callq  *%rax
  805df1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805df4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805df8:	0f 88 95 01 00 00    	js     805f93 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805dfe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805e02:	48 89 c7             	mov    %rax,%rdi
  805e05:	48 b8 ec 4f 80 00 00 	movabs $0x804fec,%rax
  805e0c:	00 00 00 
  805e0f:	ff d0                	callq  *%rax
  805e11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e18:	0f 88 5d 01 00 00    	js     805f7b <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e22:	ba 07 04 00 00       	mov    $0x407,%edx
  805e27:	48 89 c6             	mov    %rax,%rsi
  805e2a:	bf 00 00 00 00       	mov    $0x0,%edi
  805e2f:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  805e36:	00 00 00 
  805e39:	ff d0                	callq  *%rax
  805e3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e42:	0f 88 33 01 00 00    	js     805f7b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805e48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e4c:	48 89 c7             	mov    %rax,%rdi
  805e4f:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  805e56:	00 00 00 
  805e59:	ff d0                	callq  *%rax
  805e5b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e63:	ba 07 04 00 00       	mov    $0x407,%edx
  805e68:	48 89 c6             	mov    %rax,%rsi
  805e6b:	bf 00 00 00 00       	mov    $0x0,%edi
  805e70:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  805e77:	00 00 00 
  805e7a:	ff d0                	callq  *%rax
  805e7c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e83:	79 05                	jns    805e8a <pipe+0xe3>
		goto err2;
  805e85:	e9 d9 00 00 00       	jmpq   805f63 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e8e:	48 89 c7             	mov    %rax,%rdi
  805e91:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  805e98:	00 00 00 
  805e9b:	ff d0                	callq  *%rax
  805e9d:	48 89 c2             	mov    %rax,%rdx
  805ea0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ea4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805eaa:	48 89 d1             	mov    %rdx,%rcx
  805ead:	ba 00 00 00 00       	mov    $0x0,%edx
  805eb2:	48 89 c6             	mov    %rax,%rsi
  805eb5:	bf 00 00 00 00       	mov    $0x0,%edi
  805eba:	48 b8 a9 4a 80 00 00 	movabs $0x804aa9,%rax
  805ec1:	00 00 00 
  805ec4:	ff d0                	callq  *%rax
  805ec6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805ecd:	79 1b                	jns    805eea <pipe+0x143>
		goto err3;
  805ecf:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  805ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ed4:	48 89 c6             	mov    %rax,%rsi
  805ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  805edc:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  805ee3:	00 00 00 
  805ee6:	ff d0                	callq  *%rax
  805ee8:	eb 79                	jmp    805f63 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805eea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805eee:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  805ef5:	00 00 00 
  805ef8:	8b 12                	mov    (%rdx),%edx
  805efa:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805f07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f0b:	48 ba 00 11 81 00 00 	movabs $0x811100,%rdx
  805f12:	00 00 00 
  805f15:	8b 12                	mov    (%rdx),%edx
  805f17:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805f19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f1d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f28:	48 89 c7             	mov    %rax,%rdi
  805f2b:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  805f32:	00 00 00 
  805f35:	ff d0                	callq  *%rax
  805f37:	89 c2                	mov    %eax,%edx
  805f39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f3d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805f3f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f43:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805f47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f4b:	48 89 c7             	mov    %rax,%rdi
  805f4e:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  805f55:	00 00 00 
  805f58:	ff d0                	callq  *%rax
  805f5a:	89 03                	mov    %eax,(%rbx)
	return 0;
  805f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  805f61:	eb 33                	jmp    805f96 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  805f63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f67:	48 89 c6             	mov    %rax,%rsi
  805f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  805f6f:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  805f76:	00 00 00 
  805f79:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  805f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f7f:	48 89 c6             	mov    %rax,%rsi
  805f82:	bf 00 00 00 00       	mov    $0x0,%edi
  805f87:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  805f8e:	00 00 00 
  805f91:	ff d0                	callq  *%rax
    err:
	return r;
  805f93:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805f96:	48 83 c4 38          	add    $0x38,%rsp
  805f9a:	5b                   	pop    %rbx
  805f9b:	5d                   	pop    %rbp
  805f9c:	c3                   	retq   

0000000000805f9d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805f9d:	55                   	push   %rbp
  805f9e:	48 89 e5             	mov    %rsp,%rbp
  805fa1:	53                   	push   %rbx
  805fa2:	48 83 ec 28          	sub    $0x28,%rsp
  805fa6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805faa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805fae:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805fb5:	00 00 00 
  805fb8:	48 8b 00             	mov    (%rax),%rax
  805fbb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805fc1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805fc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fc8:	48 89 c7             	mov    %rax,%rdi
  805fcb:	48 b8 1e 5d 80 00 00 	movabs $0x805d1e,%rax
  805fd2:	00 00 00 
  805fd5:	ff d0                	callq  *%rax
  805fd7:	89 c3                	mov    %eax,%ebx
  805fd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fdd:	48 89 c7             	mov    %rax,%rdi
  805fe0:	48 b8 1e 5d 80 00 00 	movabs $0x805d1e,%rax
  805fe7:	00 00 00 
  805fea:	ff d0                	callq  *%rax
  805fec:	39 c3                	cmp    %eax,%ebx
  805fee:	0f 94 c0             	sete   %al
  805ff1:	0f b6 c0             	movzbl %al,%eax
  805ff4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  805ff7:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  805ffe:	00 00 00 
  806001:	48 8b 00             	mov    (%rax),%rax
  806004:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80600a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80600d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806010:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806013:	75 05                	jne    80601a <_pipeisclosed+0x7d>
			return ret;
  806015:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806018:	eb 4f                	jmp    806069 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80601a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80601d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806020:	74 42                	je     806064 <_pipeisclosed+0xc7>
  806022:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806026:	75 3c                	jne    806064 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806028:	48 b8 18 20 81 00 00 	movabs $0x812018,%rax
  80602f:	00 00 00 
  806032:	48 8b 00             	mov    (%rax),%rax
  806035:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80603b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80603e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806041:	89 c6                	mov    %eax,%esi
  806043:	48 bf 3b 72 80 00 00 	movabs $0x80723b,%rdi
  80604a:	00 00 00 
  80604d:	b8 00 00 00 00       	mov    $0x0,%eax
  806052:	49 b8 82 33 80 00 00 	movabs $0x803382,%r8
  806059:	00 00 00 
  80605c:	41 ff d0             	callq  *%r8
	}
  80605f:	e9 4a ff ff ff       	jmpq   805fae <_pipeisclosed+0x11>
  806064:	e9 45 ff ff ff       	jmpq   805fae <_pipeisclosed+0x11>
}
  806069:	48 83 c4 28          	add    $0x28,%rsp
  80606d:	5b                   	pop    %rbx
  80606e:	5d                   	pop    %rbp
  80606f:	c3                   	retq   

0000000000806070 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806070:	55                   	push   %rbp
  806071:	48 89 e5             	mov    %rsp,%rbp
  806074:	48 83 ec 30          	sub    $0x30,%rsp
  806078:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80607b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80607f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806082:	48 89 d6             	mov    %rdx,%rsi
  806085:	89 c7                	mov    %eax,%edi
  806087:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  80608e:	00 00 00 
  806091:	ff d0                	callq  *%rax
  806093:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806096:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80609a:	79 05                	jns    8060a1 <pipeisclosed+0x31>
		return r;
  80609c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80609f:	eb 31                	jmp    8060d2 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8060a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060a5:	48 89 c7             	mov    %rax,%rdi
  8060a8:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  8060af:	00 00 00 
  8060b2:	ff d0                	callq  *%rax
  8060b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8060b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8060c0:	48 89 d6             	mov    %rdx,%rsi
  8060c3:	48 89 c7             	mov    %rax,%rdi
  8060c6:	48 b8 9d 5f 80 00 00 	movabs $0x805f9d,%rax
  8060cd:	00 00 00 
  8060d0:	ff d0                	callq  *%rax
}
  8060d2:	c9                   	leaveq 
  8060d3:	c3                   	retq   

00000000008060d4 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8060d4:	55                   	push   %rbp
  8060d5:	48 89 e5             	mov    %rsp,%rbp
  8060d8:	48 83 ec 40          	sub    $0x40,%rsp
  8060dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060e4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8060e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060ec:	48 89 c7             	mov    %rax,%rdi
  8060ef:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  8060f6:	00 00 00 
  8060f9:	ff d0                	callq  *%rax
  8060fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8060ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806103:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806107:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80610e:	00 
  80610f:	e9 92 00 00 00       	jmpq   8061a6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806114:	eb 41                	jmp    806157 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806116:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80611b:	74 09                	je     806126 <devpipe_read+0x52>
				return i;
  80611d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806121:	e9 92 00 00 00       	jmpq   8061b8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806126:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80612a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80612e:	48 89 d6             	mov    %rdx,%rsi
  806131:	48 89 c7             	mov    %rax,%rdi
  806134:	48 b8 9d 5f 80 00 00 	movabs $0x805f9d,%rax
  80613b:	00 00 00 
  80613e:	ff d0                	callq  *%rax
  806140:	85 c0                	test   %eax,%eax
  806142:	74 07                	je     80614b <devpipe_read+0x77>
				return 0;
  806144:	b8 00 00 00 00       	mov    $0x0,%eax
  806149:	eb 6d                	jmp    8061b8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80614b:	48 b8 1b 4a 80 00 00 	movabs $0x804a1b,%rax
  806152:	00 00 00 
  806155:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80615b:	8b 10                	mov    (%rax),%edx
  80615d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806161:	8b 40 04             	mov    0x4(%rax),%eax
  806164:	39 c2                	cmp    %eax,%edx
  806166:	74 ae                	je     806116 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80616c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806170:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806178:	8b 00                	mov    (%rax),%eax
  80617a:	99                   	cltd   
  80617b:	c1 ea 1b             	shr    $0x1b,%edx
  80617e:	01 d0                	add    %edx,%eax
  806180:	83 e0 1f             	and    $0x1f,%eax
  806183:	29 d0                	sub    %edx,%eax
  806185:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806189:	48 98                	cltq   
  80618b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806190:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  806192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806196:	8b 00                	mov    (%rax),%eax
  806198:	8d 50 01             	lea    0x1(%rax),%edx
  80619b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80619f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8061a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8061a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061aa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8061ae:	0f 82 60 ff ff ff    	jb     806114 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8061b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8061b8:	c9                   	leaveq 
  8061b9:	c3                   	retq   

00000000008061ba <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8061ba:	55                   	push   %rbp
  8061bb:	48 89 e5             	mov    %rsp,%rbp
  8061be:	48 83 ec 40          	sub    $0x40,%rsp
  8061c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8061c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8061ca:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8061ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061d2:	48 89 c7             	mov    %rax,%rdi
  8061d5:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  8061dc:	00 00 00 
  8061df:	ff d0                	callq  *%rax
  8061e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8061e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8061ed:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8061f4:	00 
  8061f5:	e9 8e 00 00 00       	jmpq   806288 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8061fa:	eb 31                	jmp    80622d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8061fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806200:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806204:	48 89 d6             	mov    %rdx,%rsi
  806207:	48 89 c7             	mov    %rax,%rdi
  80620a:	48 b8 9d 5f 80 00 00 	movabs $0x805f9d,%rax
  806211:	00 00 00 
  806214:	ff d0                	callq  *%rax
  806216:	85 c0                	test   %eax,%eax
  806218:	74 07                	je     806221 <devpipe_write+0x67>
				return 0;
  80621a:	b8 00 00 00 00       	mov    $0x0,%eax
  80621f:	eb 79                	jmp    80629a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806221:	48 b8 1b 4a 80 00 00 	movabs $0x804a1b,%rax
  806228:	00 00 00 
  80622b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80622d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806231:	8b 40 04             	mov    0x4(%rax),%eax
  806234:	48 63 d0             	movslq %eax,%rdx
  806237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80623b:	8b 00                	mov    (%rax),%eax
  80623d:	48 98                	cltq   
  80623f:	48 83 c0 20          	add    $0x20,%rax
  806243:	48 39 c2             	cmp    %rax,%rdx
  806246:	73 b4                	jae    8061fc <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80624c:	8b 40 04             	mov    0x4(%rax),%eax
  80624f:	99                   	cltd   
  806250:	c1 ea 1b             	shr    $0x1b,%edx
  806253:	01 d0                	add    %edx,%eax
  806255:	83 e0 1f             	and    $0x1f,%eax
  806258:	29 d0                	sub    %edx,%eax
  80625a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80625e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806262:	48 01 ca             	add    %rcx,%rdx
  806265:	0f b6 0a             	movzbl (%rdx),%ecx
  806268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80626c:	48 98                	cltq   
  80626e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806276:	8b 40 04             	mov    0x4(%rax),%eax
  806279:	8d 50 01             	lea    0x1(%rax),%edx
  80627c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806280:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806283:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80628c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806290:	0f 82 64 ff ff ff    	jb     8061fa <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80629a:	c9                   	leaveq 
  80629b:	c3                   	retq   

000000000080629c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80629c:	55                   	push   %rbp
  80629d:	48 89 e5             	mov    %rsp,%rbp
  8062a0:	48 83 ec 20          	sub    $0x20,%rsp
  8062a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8062a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8062ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8062b0:	48 89 c7             	mov    %rax,%rdi
  8062b3:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  8062ba:	00 00 00 
  8062bd:	ff d0                	callq  *%rax
  8062bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8062c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8062c7:	48 be 4e 72 80 00 00 	movabs $0x80724e,%rsi
  8062ce:	00 00 00 
  8062d1:	48 89 c7             	mov    %rax,%rdi
  8062d4:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  8062db:	00 00 00 
  8062de:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8062e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062e4:	8b 50 04             	mov    0x4(%rax),%edx
  8062e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062eb:	8b 00                	mov    (%rax),%eax
  8062ed:	29 c2                	sub    %eax,%edx
  8062ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8062f3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8062f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8062fd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806304:	00 00 00 
	stat->st_dev = &devpipe;
  806307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80630b:	48 b9 00 11 81 00 00 	movabs $0x811100,%rcx
  806312:	00 00 00 
  806315:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80631c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806321:	c9                   	leaveq 
  806322:	c3                   	retq   

0000000000806323 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806323:	55                   	push   %rbp
  806324:	48 89 e5             	mov    %rsp,%rbp
  806327:	48 83 ec 10          	sub    $0x10,%rsp
  80632b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80632f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806333:	48 89 c6             	mov    %rax,%rsi
  806336:	bf 00 00 00 00       	mov    $0x0,%edi
  80633b:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  806342:	00 00 00 
  806345:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80634b:	48 89 c7             	mov    %rax,%rdi
  80634e:	48 b8 c1 4f 80 00 00 	movabs $0x804fc1,%rax
  806355:	00 00 00 
  806358:	ff d0                	callq  *%rax
  80635a:	48 89 c6             	mov    %rax,%rsi
  80635d:	bf 00 00 00 00       	mov    $0x0,%edi
  806362:	48 b8 04 4b 80 00 00 	movabs $0x804b04,%rax
  806369:	00 00 00 
  80636c:	ff d0                	callq  *%rax
}
  80636e:	c9                   	leaveq 
  80636f:	c3                   	retq   

0000000000806370 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  806370:	55                   	push   %rbp
  806371:	48 89 e5             	mov    %rsp,%rbp
  806374:	48 83 ec 20          	sub    $0x20,%rsp
  806378:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80637b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80637e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  806381:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806385:	be 01 00 00 00       	mov    $0x1,%esi
  80638a:	48 89 c7             	mov    %rax,%rdi
  80638d:	48 b8 11 49 80 00 00 	movabs $0x804911,%rax
  806394:	00 00 00 
  806397:	ff d0                	callq  *%rax
}
  806399:	c9                   	leaveq 
  80639a:	c3                   	retq   

000000000080639b <getchar>:

int
getchar(void)
{
  80639b:	55                   	push   %rbp
  80639c:	48 89 e5             	mov    %rsp,%rbp
  80639f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8063a3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8063a7:	ba 01 00 00 00       	mov    $0x1,%edx
  8063ac:	48 89 c6             	mov    %rax,%rsi
  8063af:	bf 00 00 00 00       	mov    $0x0,%edi
  8063b4:	48 b8 b6 54 80 00 00 	movabs $0x8054b6,%rax
  8063bb:	00 00 00 
  8063be:	ff d0                	callq  *%rax
  8063c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8063c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063c7:	79 05                	jns    8063ce <getchar+0x33>
		return r;
  8063c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063cc:	eb 14                	jmp    8063e2 <getchar+0x47>
	if (r < 1)
  8063ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8063d2:	7f 07                	jg     8063db <getchar+0x40>
		return -E_EOF;
  8063d4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8063d9:	eb 07                	jmp    8063e2 <getchar+0x47>
	return c;
  8063db:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8063df:	0f b6 c0             	movzbl %al,%eax
}
  8063e2:	c9                   	leaveq 
  8063e3:	c3                   	retq   

00000000008063e4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8063e4:	55                   	push   %rbp
  8063e5:	48 89 e5             	mov    %rsp,%rbp
  8063e8:	48 83 ec 20          	sub    $0x20,%rsp
  8063ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8063ef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8063f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8063f6:	48 89 d6             	mov    %rdx,%rsi
  8063f9:	89 c7                	mov    %eax,%edi
  8063fb:	48 b8 84 50 80 00 00 	movabs $0x805084,%rax
  806402:	00 00 00 
  806405:	ff d0                	callq  *%rax
  806407:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80640a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80640e:	79 05                	jns    806415 <iscons+0x31>
		return r;
  806410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806413:	eb 1a                	jmp    80642f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806419:	8b 10                	mov    (%rax),%edx
  80641b:	48 b8 40 11 81 00 00 	movabs $0x811140,%rax
  806422:	00 00 00 
  806425:	8b 00                	mov    (%rax),%eax
  806427:	39 c2                	cmp    %eax,%edx
  806429:	0f 94 c0             	sete   %al
  80642c:	0f b6 c0             	movzbl %al,%eax
}
  80642f:	c9                   	leaveq 
  806430:	c3                   	retq   

0000000000806431 <opencons>:

int
opencons(void)
{
  806431:	55                   	push   %rbp
  806432:	48 89 e5             	mov    %rsp,%rbp
  806435:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806439:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80643d:	48 89 c7             	mov    %rax,%rdi
  806440:	48 b8 ec 4f 80 00 00 	movabs $0x804fec,%rax
  806447:	00 00 00 
  80644a:	ff d0                	callq  *%rax
  80644c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80644f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806453:	79 05                	jns    80645a <opencons+0x29>
		return r;
  806455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806458:	eb 5b                	jmp    8064b5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80645a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80645e:	ba 07 04 00 00       	mov    $0x407,%edx
  806463:	48 89 c6             	mov    %rax,%rsi
  806466:	bf 00 00 00 00       	mov    $0x0,%edi
  80646b:	48 b8 59 4a 80 00 00 	movabs $0x804a59,%rax
  806472:	00 00 00 
  806475:	ff d0                	callq  *%rax
  806477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80647a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80647e:	79 05                	jns    806485 <opencons+0x54>
		return r;
  806480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806483:	eb 30                	jmp    8064b5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806489:	48 ba 40 11 81 00 00 	movabs $0x811140,%rdx
  806490:	00 00 00 
  806493:	8b 12                	mov    (%rdx),%edx
  806495:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80649b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8064a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064a6:	48 89 c7             	mov    %rax,%rdi
  8064a9:	48 b8 9e 4f 80 00 00 	movabs $0x804f9e,%rax
  8064b0:	00 00 00 
  8064b3:	ff d0                	callq  *%rax
}
  8064b5:	c9                   	leaveq 
  8064b6:	c3                   	retq   

00000000008064b7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8064b7:	55                   	push   %rbp
  8064b8:	48 89 e5             	mov    %rsp,%rbp
  8064bb:	48 83 ec 30          	sub    $0x30,%rsp
  8064bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8064c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8064c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8064cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8064d0:	75 07                	jne    8064d9 <devcons_read+0x22>
		return 0;
  8064d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8064d7:	eb 4b                	jmp    806524 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8064d9:	eb 0c                	jmp    8064e7 <devcons_read+0x30>
		sys_yield();
  8064db:	48 b8 1b 4a 80 00 00 	movabs $0x804a1b,%rax
  8064e2:	00 00 00 
  8064e5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8064e7:	48 b8 5b 49 80 00 00 	movabs $0x80495b,%rax
  8064ee:	00 00 00 
  8064f1:	ff d0                	callq  *%rax
  8064f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8064f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064fa:	74 df                	je     8064db <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8064fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806500:	79 05                	jns    806507 <devcons_read+0x50>
		return c;
  806502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806505:	eb 1d                	jmp    806524 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  806507:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80650b:	75 07                	jne    806514 <devcons_read+0x5d>
		return 0;
  80650d:	b8 00 00 00 00       	mov    $0x0,%eax
  806512:	eb 10                	jmp    806524 <devcons_read+0x6d>
	*(char*)vbuf = c;
  806514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806517:	89 c2                	mov    %eax,%edx
  806519:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80651d:	88 10                	mov    %dl,(%rax)
	return 1;
  80651f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  806524:	c9                   	leaveq 
  806525:	c3                   	retq   

0000000000806526 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806526:	55                   	push   %rbp
  806527:	48 89 e5             	mov    %rsp,%rbp
  80652a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  806531:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806538:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80653f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80654d:	eb 76                	jmp    8065c5 <devcons_write+0x9f>
		m = n - tot;
  80654f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806556:	89 c2                	mov    %eax,%edx
  806558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80655b:	29 c2                	sub    %eax,%edx
  80655d:	89 d0                	mov    %edx,%eax
  80655f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  806562:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806565:	83 f8 7f             	cmp    $0x7f,%eax
  806568:	76 07                	jbe    806571 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80656a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  806571:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806574:	48 63 d0             	movslq %eax,%rdx
  806577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80657a:	48 63 c8             	movslq %eax,%rcx
  80657d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806584:	48 01 c1             	add    %rax,%rcx
  806587:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80658e:	48 89 ce             	mov    %rcx,%rsi
  806591:	48 89 c7             	mov    %rax,%rdi
  806594:	48 b8 4e 44 80 00 00 	movabs $0x80444e,%rax
  80659b:	00 00 00 
  80659e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8065a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8065a3:	48 63 d0             	movslq %eax,%rdx
  8065a6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8065ad:	48 89 d6             	mov    %rdx,%rsi
  8065b0:	48 89 c7             	mov    %rax,%rdi
  8065b3:	48 b8 11 49 80 00 00 	movabs $0x804911,%rax
  8065ba:	00 00 00 
  8065bd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8065bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8065c2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8065c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065c8:	48 98                	cltq   
  8065ca:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8065d1:	0f 82 78 ff ff ff    	jb     80654f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8065d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8065da:	c9                   	leaveq 
  8065db:	c3                   	retq   

00000000008065dc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8065dc:	55                   	push   %rbp
  8065dd:	48 89 e5             	mov    %rsp,%rbp
  8065e0:	48 83 ec 08          	sub    $0x8,%rsp
  8065e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8065e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8065ed:	c9                   	leaveq 
  8065ee:	c3                   	retq   

00000000008065ef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8065ef:	55                   	push   %rbp
  8065f0:	48 89 e5             	mov    %rsp,%rbp
  8065f3:	48 83 ec 10          	sub    $0x10,%rsp
  8065f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8065fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8065ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806603:	48 be 5a 72 80 00 00 	movabs $0x80725a,%rsi
  80660a:	00 00 00 
  80660d:	48 89 c7             	mov    %rax,%rdi
  806610:	48 b8 2a 41 80 00 00 	movabs $0x80412a,%rax
  806617:	00 00 00 
  80661a:	ff d0                	callq  *%rax
	return 0;
  80661c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806621:	c9                   	leaveq 
  806622:	c3                   	retq   
