
obj/user/tst_nextfit:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 d3 28 00 00       	call   80292e <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 60 3d 80 00       	push   $0x803d60
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 7c 3d 80 00       	push   $0x803d7c
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 b4 1e 00 00       	call   801f7b <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 8f 3d 80 00       	push   $0x803d8f
  8000ee:	68 a6 3d 80 00       	push   $0x803da6
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 7c 3d 80 00       	push   $0x803d7c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 25 28 00 00       	call   80292e <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 60 3d 80 00       	push   $0x803d60
  80015f:	6a 32                	push   $0x32
  800161:	68 7c 3d 80 00       	push   $0x803d7c
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 bc 3d 80 00       	push   $0x803dbc
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 7c 3d 80 00       	push   $0x803d7c
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 0c 3e 80 00       	push   $0x803e0c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 16 22 00 00       	call   802419 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 ae 22 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 56 1d 00 00       	call   801f7b <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 5c 3e 80 00       	push   $0x803e5c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 7c 3d 80 00       	push   $0x803d7c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 f8 21 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 9a 3e 80 00       	push   $0x803e9a
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 7c 3d 80 00       	push   $0x803d7c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 21 21 00 00       	call   802419 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 b7 3e 80 00       	push   $0x803eb7
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 7c 3d 80 00       	push   $0x803d7c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 ee 20 00 00       	call   802419 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 86 21 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 cf 1c 00 00       	call   802014 <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 bd 1c 00 00       	call   802014 <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 ab 1c 00 00       	call   802014 <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 99 1c 00 00       	call   802014 <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 87 1c 00 00       	call   802014 <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 75 1c 00 00       	call   802014 <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 63 1c 00 00       	call   802014 <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 51 1c 00 00       	call   802014 <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 3f 1c 00 00       	call   802014 <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 2d 1c 00 00       	call   802014 <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 ca 20 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 c8 3e 80 00       	push   $0x803ec8
  80041b:	6a 70                	push   $0x70
  80041d:	68 7c 3d 80 00       	push   $0x803d7c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 ed 1f 00 00       	call   802419 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 04 3f 80 00       	push   $0x803f04
  80043d:	6a 71                	push   $0x71
  80043f:	68 7c 3d 80 00       	push   $0x803d7c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 cb 1f 00 00       	call   802419 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 63 20 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 13 1b 00 00       	call   801f7b <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 44 3f 80 00       	push   $0x803f44
  800480:	6a 79                	push   $0x79
  800482:	68 7c 3d 80 00       	push   $0x803d7c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 28 20 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 9a 3e 80 00       	push   $0x803e9a
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 7c 3d 80 00       	push   $0x803d7c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 57 1f 00 00       	call   802419 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 b7 3e 80 00       	push   $0x803eb7
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 7c 3d 80 00       	push   $0x803d7c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 35 1f 00 00       	call   802419 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 cd 1f 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 80 1a 00 00       	call   801f7b <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 44 3f 80 00       	push   $0x803f44
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 7c 3d 80 00       	push   $0x803d7c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 92 1f 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 9a 3e 80 00       	push   $0x803e9a
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 7c 3d 80 00       	push   $0x803d7c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 bb 1e 00 00       	call   802419 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 b7 3e 80 00       	push   $0x803eb7
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 7c 3d 80 00       	push   $0x803d7c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 96 1e 00 00       	call   802419 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 2e 1f 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 da 19 00 00       	call   801f7b <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 44 3f 80 00       	push   $0x803f44
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 7c 3d 80 00       	push   $0x803d7c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 ec 1e 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 9a 3e 80 00       	push   $0x803e9a
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 7c 3d 80 00       	push   $0x803d7c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 11 1e 00 00       	call   802419 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 b7 3e 80 00       	push   $0x803eb7
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 7c 3d 80 00       	push   $0x803d7c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 ec 1d 00 00       	call   802419 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 84 1e 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 37 19 00 00       	call   801f7b <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 44 3f 80 00       	push   $0x803f44
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 7c 3d 80 00       	push   $0x803d7c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 49 1e 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 9a 3e 80 00       	push   $0x803e9a
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 7c 3d 80 00       	push   $0x803d7c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 75 1d 00 00       	call   802419 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 b7 3e 80 00       	push   $0x803eb7
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 7c 3d 80 00       	push   $0x803d7c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 50 1d 00 00       	call   802419 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 e8 1d 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 31 19 00 00       	call   802014 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 ce 1d 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 c8 3e 80 00       	push   $0x803ec8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 7c 3d 80 00       	push   $0x803d7c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 f8 1c 00 00       	call   802419 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 04 3f 80 00       	push   $0x803f04
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 7c 3d 80 00       	push   $0x803d7c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 d3 1c 00 00       	call   802419 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 6b 1d 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 1e 18 00 00       	call   801f7b <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 44 3f 80 00       	push   $0x803f44
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 7c 3d 80 00       	push   $0x803d7c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 30 1d 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 9a 3e 80 00       	push   $0x803e9a
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 7c 3d 80 00       	push   $0x803d7c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 59 1c 00 00       	call   802419 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 b7 3e 80 00       	push   $0x803eb7
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 7c 3d 80 00       	push   $0x803d7c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 34 1c 00 00       	call   802419 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 cc 1c 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 70 17 00 00       	call   801f7b <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 44 3f 80 00       	push   $0x803f44
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 7c 3d 80 00       	push   $0x803d7c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 82 1c 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 9a 3e 80 00       	push   $0x803e9a
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 7c 3d 80 00       	push   $0x803d7c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 9f 1b 00 00       	call   802419 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 b7 3e 80 00       	push   $0x803eb7
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 7c 3d 80 00       	push   $0x803d7c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 7a 1b 00 00       	call   802419 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 12 1c 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 c2 16 00 00       	call   801f7b <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 44 3f 80 00       	push   $0x803f44
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 7c 3d 80 00       	push   $0x803d7c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 d4 1b 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 9a 3e 80 00       	push   $0x803e9a
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 7c 3d 80 00       	push   $0x803d7c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 fd 1a 00 00       	call   802419 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 b7 3e 80 00       	push   $0x803eb7
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 7c 3d 80 00       	push   $0x803d7c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 64 3f 80 00       	push   $0x803f64
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 c8 1a 00 00       	call   802419 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 60 1b 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 05 16 00 00       	call   801f7b <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 44 3f 80 00       	push   $0x803f44
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 7c 3d 80 00       	push   $0x803d7c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 17 1b 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 9a 3e 80 00       	push   $0x803e9a
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 7c 3d 80 00       	push   $0x803d7c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 35 1a 00 00       	call   802419 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 b7 3e 80 00       	push   $0x803eb7
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 7c 3d 80 00       	push   $0x803d7c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 10 1a 00 00       	call   802419 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 a8 1a 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 f1 15 00 00       	call   802014 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 8e 1a 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 c8 3e 80 00       	push   $0x803ec8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 7c 3d 80 00       	push   $0x803d7c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 b8 19 00 00       	call   802419 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 04 3f 80 00       	push   $0x803f04
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 7c 3d 80 00       	push   $0x803d7c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 93 19 00 00       	call   802419 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 2b 1a 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 d8 14 00 00       	call   801f7b <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 44 3f 80 00       	push   $0x803f44
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 7c 3d 80 00       	push   $0x803d7c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 ea 19 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 9a 3e 80 00       	push   $0x803e9a
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 7c 3d 80 00       	push   $0x803d7c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 13 19 00 00       	call   802419 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 b7 3e 80 00       	push   $0x803eb7
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 7c 3d 80 00       	push   $0x803d7c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 a0 3f 80 00       	push   $0x803fa0
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 de 18 00 00       	call   802419 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 76 19 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 21 14 00 00       	call   801f7b <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 44 3f 80 00       	push   $0x803f44
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 7c 3d 80 00       	push   $0x803d7c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 36 19 00 00       	call   8024b9 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 9a 3e 80 00       	push   $0x803e9a
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 7c 3d 80 00       	push   $0x803d7c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 75 18 00 00       	call   802419 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 b7 3e 80 00       	push   $0x803eb7
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 7c 3d 80 00       	push   $0x803d7c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 d8 3f 80 00       	push   $0x803fd8
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 14 40 80 00       	push   $0x804014
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 02 1b 00 00       	call   8026f9 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 a4 18 00 00       	call   802506 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 68 40 80 00       	push   $0x804068
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 90 40 80 00       	push   $0x804090
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 b8 40 80 00       	push   $0x8040b8
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 10 41 80 00       	push   $0x804110
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 68 40 80 00       	push   $0x804068
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 24 18 00 00       	call   802520 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 b1 19 00 00       	call   8026c5 <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 06 1a 00 00       	call   80272b <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 24 41 80 00       	push   $0x804124
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 29 41 80 00       	push   $0x804129
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 45 41 80 00       	push   $0x804145
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 48 41 80 00       	push   $0x804148
  800db7:	6a 26                	push   $0x26
  800db9:	68 94 41 80 00       	push   $0x804194
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 a0 41 80 00       	push   $0x8041a0
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 94 41 80 00       	push   $0x804194
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 f4 41 80 00       	push   $0x8041f4
  800ef9:	6a 44                	push   $0x44
  800efb:	68 94 41 80 00       	push   $0x804194
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 05 14 00 00       	call   802358 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 8e 13 00 00       	call   802358 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 f2 14 00 00       	call   802506 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 ec 14 00 00       	call   802520 <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 62 2a 00 00       	call   803ae0 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 22 2b 00 00       	call   803bf0 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 54 44 80 00       	add    $0x804454,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 65 44 80 00       	push   $0x804465
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 6e 44 80 00       	push   $0x80446e
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be 71 44 80 00       	mov    $0x804471,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 d0 45 80 00       	push   $0x8045d0
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801d9d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801da4:	00 00 00 
  801da7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dae:	00 00 00 
  801db1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801db8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801dbb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801dc2:	00 00 00 
  801dc5:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dcc:	00 00 00 
  801dcf:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801dd6:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801dd9:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	c1 e8 0c             	shr    $0xc,%eax
  801de6:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801deb:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dfa:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dff:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801e04:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801e0b:	a1 20 51 80 00       	mov    0x805120,%eax
  801e10:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801e14:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801e17:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801e1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	48                   	dec    %eax
  801e27:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e32:	f7 75 e4             	divl   -0x1c(%ebp)
  801e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e38:	29 d0                	sub    %edx,%eax
  801e3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801e3d:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e4c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e51:	83 ec 04             	sub    $0x4,%esp
  801e54:	6a 07                	push   $0x7
  801e56:	ff 75 e8             	pushl  -0x18(%ebp)
  801e59:	50                   	push   %eax
  801e5a:	e8 3d 06 00 00       	call   80249c <sys_allocate_chunk>
  801e5f:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e62:	a1 20 51 80 00       	mov    0x805120,%eax
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	50                   	push   %eax
  801e6b:	e8 b2 0c 00 00       	call   802b22 <initialize_MemBlocksList>
  801e70:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801e73:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801e78:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801e7b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e7f:	0f 84 f3 00 00 00    	je     801f78 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801e85:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e89:	75 14                	jne    801e9f <initialize_dyn_block_system+0x108>
  801e8b:	83 ec 04             	sub    $0x4,%esp
  801e8e:	68 f5 45 80 00       	push   $0x8045f5
  801e93:	6a 36                	push   $0x36
  801e95:	68 13 46 80 00       	push   $0x804613
  801e9a:	e8 89 ee ff ff       	call   800d28 <_panic>
  801e9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ea2:	8b 00                	mov    (%eax),%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	74 10                	je     801eb8 <initialize_dyn_block_system+0x121>
  801ea8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801eab:	8b 00                	mov    (%eax),%eax
  801ead:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801eb0:	8b 52 04             	mov    0x4(%edx),%edx
  801eb3:	89 50 04             	mov    %edx,0x4(%eax)
  801eb6:	eb 0b                	jmp    801ec3 <initialize_dyn_block_system+0x12c>
  801eb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebb:	8b 40 04             	mov    0x4(%eax),%eax
  801ebe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ec3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec6:	8b 40 04             	mov    0x4(%eax),%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	74 0f                	je     801edc <initialize_dyn_block_system+0x145>
  801ecd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ed0:	8b 40 04             	mov    0x4(%eax),%eax
  801ed3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ed6:	8b 12                	mov    (%edx),%edx
  801ed8:	89 10                	mov    %edx,(%eax)
  801eda:	eb 0a                	jmp    801ee6 <initialize_dyn_block_system+0x14f>
  801edc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801edf:	8b 00                	mov    (%eax),%eax
  801ee1:	a3 48 51 80 00       	mov    %eax,0x805148
  801ee6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ef9:	a1 54 51 80 00       	mov    0x805154,%eax
  801efe:	48                   	dec    %eax
  801eff:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801f04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f07:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801f0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f11:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801f18:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f1c:	75 14                	jne    801f32 <initialize_dyn_block_system+0x19b>
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 20 46 80 00       	push   $0x804620
  801f26:	6a 3e                	push   $0x3e
  801f28:	68 13 46 80 00       	push   $0x804613
  801f2d:	e8 f6 ed ff ff       	call   800d28 <_panic>
  801f32:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801f38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f3b:	89 10                	mov    %edx,(%eax)
  801f3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f40:	8b 00                	mov    (%eax),%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	74 0d                	je     801f53 <initialize_dyn_block_system+0x1bc>
  801f46:	a1 38 51 80 00       	mov    0x805138,%eax
  801f4b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f4e:	89 50 04             	mov    %edx,0x4(%eax)
  801f51:	eb 08                	jmp    801f5b <initialize_dyn_block_system+0x1c4>
  801f53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801f5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f5e:	a3 38 51 80 00       	mov    %eax,0x805138
  801f63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6d:	a1 44 51 80 00       	mov    0x805144,%eax
  801f72:	40                   	inc    %eax
  801f73:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801f78:	90                   	nop
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801f81:	e8 e0 fd ff ff       	call   801d66 <InitializeUHeap>
		if (size == 0) return NULL ;
  801f86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f8a:	75 07                	jne    801f93 <malloc+0x18>
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	eb 7f                	jmp    802012 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f93:	e8 d2 08 00 00       	call   80286a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	74 71                	je     80200d <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801f9c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	01 d0                	add    %edx,%eax
  801fab:	48                   	dec    %eax
  801fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb7:	f7 75 f4             	divl   -0xc(%ebp)
  801fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbd:	29 d0                	sub    %edx,%eax
  801fbf:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801fc2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801fc9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801fd0:	76 07                	jbe    801fd9 <malloc+0x5e>
					return NULL ;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	eb 39                	jmp    802012 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	e8 e6 0d 00 00       	call   802dca <alloc_block_FF>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fee:	74 16                	je     802006 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	ff 75 ec             	pushl  -0x14(%ebp)
  801ff6:	e8 37 0c 00 00       	call   802c32 <insert_sorted_allocList>
  801ffb:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802001:	8b 40 08             	mov    0x8(%eax),%eax
  802004:	eb 0c                	jmp    802012 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	eb 05                	jmp    802012 <malloc+0x97>
				}
		}
	return 0;
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  802020:	83 ec 08             	sub    $0x8,%esp
  802023:	ff 75 f4             	pushl  -0xc(%ebp)
  802026:	68 40 50 80 00       	push   $0x805040
  80202b:	e8 cf 0b 00 00       	call   802bff <find_block>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  802048:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204c:	0f 84 a1 00 00 00    	je     8020f3 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  802052:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802056:	75 17                	jne    80206f <free+0x5b>
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	68 f5 45 80 00       	push   $0x8045f5
  802060:	68 80 00 00 00       	push   $0x80
  802065:	68 13 46 80 00       	push   $0x804613
  80206a:	e8 b9 ec ff ff       	call   800d28 <_panic>
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	74 10                	je     802088 <free+0x74>
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802080:	8b 52 04             	mov    0x4(%edx),%edx
  802083:	89 50 04             	mov    %edx,0x4(%eax)
  802086:	eb 0b                	jmp    802093 <free+0x7f>
  802088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208b:	8b 40 04             	mov    0x4(%eax),%eax
  80208e:	a3 44 50 80 00       	mov    %eax,0x805044
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	8b 40 04             	mov    0x4(%eax),%eax
  802099:	85 c0                	test   %eax,%eax
  80209b:	74 0f                	je     8020ac <free+0x98>
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	8b 40 04             	mov    0x4(%eax),%eax
  8020a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a6:	8b 12                	mov    (%edx),%edx
  8020a8:	89 10                	mov    %edx,(%eax)
  8020aa:	eb 0a                	jmp    8020b6 <free+0xa2>
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ce:	48                   	dec    %eax
  8020cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020da:	e8 29 12 00 00       	call   803308 <insert_sorted_with_merge_freeList>
  8020df:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8020e2:	83 ec 08             	sub    $0x8,%esp
  8020e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8020e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8020eb:	e8 74 03 00 00       	call   802464 <sys_free_user_mem>
  8020f0:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8020f3:	90                   	nop
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 38             	sub    $0x38,%esp
  8020fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ff:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802102:	e8 5f fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  802107:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80210b:	75 0a                	jne    802117 <smalloc+0x21>
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	e9 b2 00 00 00       	jmp    8021c9 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802117:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80211e:	76 0a                	jbe    80212a <smalloc+0x34>
		return NULL;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	e9 9f 00 00 00       	jmp    8021c9 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80212a:	e8 3b 07 00 00       	call   80286a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80212f:	85 c0                	test   %eax,%eax
  802131:	0f 84 8d 00 00 00    	je     8021c4 <smalloc+0xce>
	struct MemBlock *b = NULL;
  802137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80213e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802145:	8b 55 0c             	mov    0xc(%ebp),%edx
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	48                   	dec    %eax
  80214e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
  802159:	f7 75 f0             	divl   -0x10(%ebp)
  80215c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215f:	29 d0                	sub    %edx,%eax
  802161:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	ff 75 e8             	pushl  -0x18(%ebp)
  80216a:	e8 5b 0c 00 00       	call   802dca <alloc_block_FF>
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  802175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802179:	75 07                	jne    802182 <smalloc+0x8c>
			return NULL;
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	eb 47                	jmp    8021c9 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  802182:	83 ec 0c             	sub    $0xc,%esp
  802185:	ff 75 f4             	pushl  -0xc(%ebp)
  802188:	e8 a5 0a 00 00       	call   802c32 <insert_sorted_allocList>
  80218d:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	89 c2                	mov    %eax,%edx
  802198:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80219c:	52                   	push   %edx
  80219d:	50                   	push   %eax
  80219e:	ff 75 0c             	pushl  0xc(%ebp)
  8021a1:	ff 75 08             	pushl  0x8(%ebp)
  8021a4:	e8 46 04 00 00       	call   8025ef <sys_createSharedObject>
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8021af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021b3:	78 08                	js     8021bd <smalloc+0xc7>
		return (void *)b->sva;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	eb 0c                	jmp    8021c9 <smalloc+0xd3>
		}else{
		return NULL;
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	eb 05                	jmp    8021c9 <smalloc+0xd3>
			}

	}return NULL;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021d1:	e8 90 fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8021d6:	e8 8f 06 00 00       	call   80286a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	0f 84 ad 00 00 00    	je     802290 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	ff 75 08             	pushl  0x8(%ebp)
  8021ec:	e8 28 04 00 00       	call   802619 <sys_getSizeOfSharedObject>
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	79 0a                	jns    802207 <sget+0x3c>
    {
    	return NULL;
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	e9 8e 00 00 00       	jmp    802295 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802207:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80220e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	01 d0                	add    %edx,%eax
  80221d:	48                   	dec    %eax
  80221e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802224:	ba 00 00 00 00       	mov    $0x0,%edx
  802229:	f7 75 ec             	divl   -0x14(%ebp)
  80222c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222f:	29 d0                	sub    %edx,%eax
  802231:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80223a:	e8 8b 0b 00 00       	call   802dca <alloc_block_FF>
  80223f:	83 c4 10             	add    $0x10,%esp
  802242:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802245:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802249:	75 07                	jne    802252 <sget+0x87>
				return NULL;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	eb 43                	jmp    802295 <sget+0xca>
			}
			insert_sorted_allocList(b);
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	ff 75 f0             	pushl  -0x10(%ebp)
  802258:	e8 d5 09 00 00       	call   802c32 <insert_sorted_allocList>
  80225d:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  802260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802263:	8b 40 08             	mov    0x8(%eax),%eax
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	50                   	push   %eax
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	ff 75 08             	pushl  0x8(%ebp)
  802270:	e8 c1 03 00 00       	call   802636 <sys_getSharedObject>
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80227b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80227f:	78 08                	js     802289 <sget+0xbe>
			return (void *)b->sva;
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 40 08             	mov    0x8(%eax),%eax
  802287:	eb 0c                	jmp    802295 <sget+0xca>
			}else{
			return NULL;
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
  80228e:	eb 05                	jmp    802295 <sget+0xca>
			}
    }}return NULL;
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80229d:	e8 c4 fa ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	68 44 46 80 00       	push   $0x804644
  8022aa:	68 03 01 00 00       	push   $0x103
  8022af:	68 13 46 80 00       	push   $0x804613
  8022b4:	e8 6f ea ff ff       	call   800d28 <_panic>

008022b9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	68 6c 46 80 00       	push   $0x80466c
  8022c7:	68 17 01 00 00       	push   $0x117
  8022cc:	68 13 46 80 00       	push   $0x804613
  8022d1:	e8 52 ea ff ff       	call   800d28 <_panic>

008022d6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	68 90 46 80 00       	push   $0x804690
  8022e4:	68 22 01 00 00       	push   $0x122
  8022e9:	68 13 46 80 00       	push   $0x804613
  8022ee:	e8 35 ea ff ff       	call   800d28 <_panic>

008022f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	68 90 46 80 00       	push   $0x804690
  802301:	68 27 01 00 00       	push   $0x127
  802306:	68 13 46 80 00       	push   $0x804613
  80230b:	e8 18 ea ff ff       	call   800d28 <_panic>

00802310 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	68 90 46 80 00       	push   $0x804690
  80231e:	68 2c 01 00 00       	push   $0x12c
  802323:	68 13 46 80 00       	push   $0x804613
  802328:	e8 fb e9 ff ff       	call   800d28 <_panic>

0080232d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	57                   	push   %edi
  802331:	56                   	push   %esi
  802332:	53                   	push   %ebx
  802333:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802342:	8b 7d 18             	mov    0x18(%ebp),%edi
  802345:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802348:	cd 30                	int    $0x30
  80234a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802350:	83 c4 10             	add    $0x10,%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5f                   	pop    %edi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	8b 45 10             	mov    0x10(%ebp),%eax
  802361:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802364:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	52                   	push   %edx
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	50                   	push   %eax
  802374:	6a 00                	push   $0x0
  802376:	e8 b2 ff ff ff       	call   80232d <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	90                   	nop
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_cgetc>:

int
sys_cgetc(void)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 01                	push   $0x1
  802390:	e8 98 ff ff ff       	call   80232d <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80239d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	52                   	push   %edx
  8023aa:	50                   	push   %eax
  8023ab:	6a 05                	push   $0x5
  8023ad:	e8 7b ff ff ff       	call   80232d <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	56                   	push   %esi
  8023bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8023bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
  8023cd:	51                   	push   %ecx
  8023ce:	52                   	push   %edx
  8023cf:	50                   	push   %eax
  8023d0:	6a 06                	push   $0x6
  8023d2:	e8 56 ff ff ff       	call   80232d <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023dd:	5b                   	pop    %ebx
  8023de:	5e                   	pop    %esi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    

008023e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8023e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	52                   	push   %edx
  8023f1:	50                   	push   %eax
  8023f2:	6a 07                	push   $0x7
  8023f4:	e8 34 ff ff ff       	call   80232d <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	ff 75 0c             	pushl  0xc(%ebp)
  80240a:	ff 75 08             	pushl  0x8(%ebp)
  80240d:	6a 08                	push   $0x8
  80240f:	e8 19 ff ff ff       	call   80232d <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 09                	push   $0x9
  802428:	e8 00 ff ff ff       	call   80232d <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 0a                	push   $0xa
  802441:	e8 e7 fe ff ff       	call   80232d <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 0b                	push   $0xb
  80245a:	e8 ce fe ff ff       	call   80232d <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	ff 75 0c             	pushl  0xc(%ebp)
  802470:	ff 75 08             	pushl  0x8(%ebp)
  802473:	6a 0f                	push   $0xf
  802475:	e8 b3 fe ff ff       	call   80232d <syscall>
  80247a:	83 c4 18             	add    $0x18,%esp
	return;
  80247d:	90                   	nop
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	ff 75 0c             	pushl  0xc(%ebp)
  80248c:	ff 75 08             	pushl  0x8(%ebp)
  80248f:	6a 10                	push   $0x10
  802491:	e8 97 fe ff ff       	call   80232d <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
	return ;
  802499:	90                   	nop
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	ff 75 10             	pushl  0x10(%ebp)
  8024a6:	ff 75 0c             	pushl  0xc(%ebp)
  8024a9:	ff 75 08             	pushl  0x8(%ebp)
  8024ac:	6a 11                	push   $0x11
  8024ae:	e8 7a fe ff ff       	call   80232d <syscall>
  8024b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b6:	90                   	nop
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 0c                	push   $0xc
  8024c8:	e8 60 fe ff ff       	call   80232d <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	ff 75 08             	pushl  0x8(%ebp)
  8024e0:	6a 0d                	push   $0xd
  8024e2:	e8 46 fe ff ff       	call   80232d <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 0e                	push   $0xe
  8024fb:	e8 2d fe ff ff       	call   80232d <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	90                   	nop
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 13                	push   $0x13
  802515:	e8 13 fe ff ff       	call   80232d <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
}
  80251d:	90                   	nop
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 14                	push   $0x14
  80252f:	e8 f9 fd ff ff       	call   80232d <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	90                   	nop
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_cputc>:


void
sys_cputc(const char c)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802546:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	50                   	push   %eax
  802553:	6a 15                	push   $0x15
  802555:	e8 d3 fd ff ff       	call   80232d <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
}
  80255d:	90                   	nop
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 16                	push   $0x16
  80256f:	e8 b9 fd ff ff       	call   80232d <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
}
  802577:	90                   	nop
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	ff 75 0c             	pushl  0xc(%ebp)
  802589:	50                   	push   %eax
  80258a:	6a 17                	push   $0x17
  80258c:	e8 9c fd ff ff       	call   80232d <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	52                   	push   %edx
  8025a6:	50                   	push   %eax
  8025a7:	6a 1a                	push   $0x1a
  8025a9:	e8 7f fd ff ff       	call   80232d <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	52                   	push   %edx
  8025c3:	50                   	push   %eax
  8025c4:	6a 18                	push   $0x18
  8025c6:	e8 62 fd ff ff       	call   80232d <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	90                   	nop
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	52                   	push   %edx
  8025e1:	50                   	push   %eax
  8025e2:	6a 19                	push   $0x19
  8025e4:	e8 44 fd ff ff       	call   80232d <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
}
  8025ec:	90                   	nop
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8025fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	6a 00                	push   $0x0
  802607:	51                   	push   %ecx
  802608:	52                   	push   %edx
  802609:	ff 75 0c             	pushl  0xc(%ebp)
  80260c:	50                   	push   %eax
  80260d:	6a 1b                	push   $0x1b
  80260f:	e8 19 fd ff ff       	call   80232d <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80261c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	52                   	push   %edx
  802629:	50                   	push   %eax
  80262a:	6a 1c                	push   $0x1c
  80262c:	e8 fc fc ff ff       	call   80232d <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802639:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80263c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	51                   	push   %ecx
  802647:	52                   	push   %edx
  802648:	50                   	push   %eax
  802649:	6a 1d                	push   $0x1d
  80264b:	e8 dd fc ff ff       	call   80232d <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	52                   	push   %edx
  802665:	50                   	push   %eax
  802666:	6a 1e                	push   $0x1e
  802668:	e8 c0 fc ff ff       	call   80232d <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 1f                	push   $0x1f
  802681:	e8 a7 fc ff ff       	call   80232d <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	6a 00                	push   $0x0
  802693:	ff 75 14             	pushl  0x14(%ebp)
  802696:	ff 75 10             	pushl  0x10(%ebp)
  802699:	ff 75 0c             	pushl  0xc(%ebp)
  80269c:	50                   	push   %eax
  80269d:	6a 20                	push   $0x20
  80269f:	e8 89 fc ff ff       	call   80232d <syscall>
  8026a4:	83 c4 18             	add    $0x18,%esp
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	50                   	push   %eax
  8026b8:	6a 21                	push   $0x21
  8026ba:	e8 6e fc ff ff       	call   80232d <syscall>
  8026bf:	83 c4 18             	add    $0x18,%esp
}
  8026c2:	90                   	nop
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	50                   	push   %eax
  8026d4:	6a 22                	push   $0x22
  8026d6:	e8 52 fc ff ff       	call   80232d <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 02                	push   $0x2
  8026ef:	e8 39 fc ff ff       	call   80232d <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 03                	push   $0x3
  802708:	e8 20 fc ff ff       	call   80232d <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 04                	push   $0x4
  802721:	e8 07 fc ff ff       	call   80232d <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <sys_exit_env>:


void sys_exit_env(void)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 23                	push   $0x23
  80273a:	e8 ee fb ff ff       	call   80232d <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
}
  802742:	90                   	nop
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80274b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80274e:	8d 50 04             	lea    0x4(%eax),%edx
  802751:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	52                   	push   %edx
  80275b:	50                   	push   %eax
  80275c:	6a 24                	push   $0x24
  80275e:	e8 ca fb ff ff       	call   80232d <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
	return result;
  802766:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802769:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80276c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80276f:	89 01                	mov    %eax,(%ecx)
  802771:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	c9                   	leave  
  802778:	c2 04 00             	ret    $0x4

0080277b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	ff 75 10             	pushl  0x10(%ebp)
  802785:	ff 75 0c             	pushl  0xc(%ebp)
  802788:	ff 75 08             	pushl  0x8(%ebp)
  80278b:	6a 12                	push   $0x12
  80278d:	e8 9b fb ff ff       	call   80232d <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
	return ;
  802795:	90                   	nop
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <sys_rcr2>:
uint32 sys_rcr2()
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 25                	push   $0x25
  8027a7:	e8 81 fb ff ff       	call   80232d <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 04             	sub    $0x4,%esp
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	50                   	push   %eax
  8027ca:	6a 26                	push   $0x26
  8027cc:	e8 5c fb ff ff       	call   80232d <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d4:	90                   	nop
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <rsttst>:
void rsttst()
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 28                	push   $0x28
  8027e6:	e8 42 fb ff ff       	call   80232d <syscall>
  8027eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ee:	90                   	nop
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8027fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027fd:	8b 55 18             	mov    0x18(%ebp),%edx
  802800:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802804:	52                   	push   %edx
  802805:	50                   	push   %eax
  802806:	ff 75 10             	pushl  0x10(%ebp)
  802809:	ff 75 0c             	pushl  0xc(%ebp)
  80280c:	ff 75 08             	pushl  0x8(%ebp)
  80280f:	6a 27                	push   $0x27
  802811:	e8 17 fb ff ff       	call   80232d <syscall>
  802816:	83 c4 18             	add    $0x18,%esp
	return ;
  802819:	90                   	nop
}
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    

0080281c <chktst>:
void chktst(uint32 n)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	6a 29                	push   $0x29
  80282c:	e8 fc fa ff ff       	call   80232d <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return ;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <inctst>:

void inctst()
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 2a                	push   $0x2a
  802846:	e8 e2 fa ff ff       	call   80232d <syscall>
  80284b:	83 c4 18             	add    $0x18,%esp
	return ;
  80284e:	90                   	nop
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <gettst>:
uint32 gettst()
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 2b                	push   $0x2b
  802860:	e8 c8 fa ff ff       	call   80232d <syscall>
  802865:	83 c4 18             	add    $0x18,%esp
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 2c                	push   $0x2c
  80287c:	e8 ac fa ff ff       	call   80232d <syscall>
  802881:	83 c4 18             	add    $0x18,%esp
  802884:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802887:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80288b:	75 07                	jne    802894 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80288d:	b8 01 00 00 00       	mov    $0x1,%eax
  802892:	eb 05                	jmp    802899 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    

0080289b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 2c                	push   $0x2c
  8028ad:	e8 7b fa ff ff       	call   80232d <syscall>
  8028b2:	83 c4 18             	add    $0x18,%esp
  8028b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028b8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028bc:	75 07                	jne    8028c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	eb 05                	jmp    8028ca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ca:	c9                   	leave  
  8028cb:	c3                   	ret    

008028cc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 2c                	push   $0x2c
  8028de:	e8 4a fa ff ff       	call   80232d <syscall>
  8028e3:	83 c4 18             	add    $0x18,%esp
  8028e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028e9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028ed:	75 07                	jne    8028f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f4:	eb 05                	jmp    8028fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 2c                	push   $0x2c
  80290f:	e8 19 fa ff ff       	call   80232d <syscall>
  802914:	83 c4 18             	add    $0x18,%esp
  802917:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80291a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80291e:	75 07                	jne    802927 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802920:	b8 01 00 00 00       	mov    $0x1,%eax
  802925:	eb 05                	jmp    80292c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	ff 75 08             	pushl  0x8(%ebp)
  80293c:	6a 2d                	push   $0x2d
  80293e:	e8 ea f9 ff ff       	call   80232d <syscall>
  802943:	83 c4 18             	add    $0x18,%esp
	return ;
  802946:	90                   	nop
}
  802947:	c9                   	leave  
  802948:	c3                   	ret    

00802949 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80294d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802953:	8b 55 0c             	mov    0xc(%ebp),%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	6a 00                	push   $0x0
  80295b:	53                   	push   %ebx
  80295c:	51                   	push   %ecx
  80295d:	52                   	push   %edx
  80295e:	50                   	push   %eax
  80295f:	6a 2e                	push   $0x2e
  802961:	e8 c7 f9 ff ff       	call   80232d <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802971:	8b 55 0c             	mov    0xc(%ebp),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	52                   	push   %edx
  80297e:	50                   	push   %eax
  80297f:	6a 2f                	push   $0x2f
  802981:	e8 a7 f9 ff ff       	call   80232d <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802991:	83 ec 0c             	sub    $0xc,%esp
  802994:	68 a0 46 80 00       	push   $0x8046a0
  802999:	e8 3e e6 ff ff       	call   800fdc <cprintf>
  80299e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	68 cc 46 80 00       	push   $0x8046cc
  8029b0:	e8 27 e6 ff ff       	call   800fdc <cprintf>
  8029b5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029b8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	eb 56                	jmp    802a1c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ca:	74 1c                	je     8029e8 <print_mem_block_lists+0x5d>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	01 c8                	add    %ecx,%eax
  8029e0:	39 c2                	cmp    %eax,%edx
  8029e2:	73 04                	jae    8029e8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8029e4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	01 c2                	add    %eax,%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 08             	mov    0x8(%eax),%eax
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	52                   	push   %edx
  802a00:	50                   	push   %eax
  802a01:	68 e1 46 80 00       	push   $0x8046e1
  802a06:	e8 d1 e5 ff ff       	call   800fdc <cprintf>
  802a0b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a14:	a1 40 51 80 00       	mov    0x805140,%eax
  802a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	74 07                	je     802a29 <print_mem_block_lists+0x9e>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	eb 05                	jmp    802a2e <print_mem_block_lists+0xa3>
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802a33:	a1 40 51 80 00       	mov    0x805140,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	75 8a                	jne    8029c6 <print_mem_block_lists+0x3b>
  802a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a40:	75 84                	jne    8029c6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a42:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a46:	75 10                	jne    802a58 <print_mem_block_lists+0xcd>
  802a48:	83 ec 0c             	sub    $0xc,%esp
  802a4b:	68 f0 46 80 00       	push   $0x8046f0
  802a50:	e8 87 e5 ff ff       	call   800fdc <cprintf>
  802a55:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a5f:	83 ec 0c             	sub    $0xc,%esp
  802a62:	68 14 47 80 00       	push   $0x804714
  802a67:	e8 70 e5 ff ff       	call   800fdc <cprintf>
  802a6c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a73:	a1 40 50 80 00       	mov    0x805040,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7b:	eb 56                	jmp    802ad3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a81:	74 1c                	je     802a9f <print_mem_block_lists+0x114>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 48 08             	mov    0x8(%eax),%ecx
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	01 c8                	add    %ecx,%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	73 04                	jae    802a9f <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 50 08             	mov    0x8(%eax),%edx
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	01 c2                	add    %eax,%edx
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 08             	mov    0x8(%eax),%eax
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	52                   	push   %edx
  802ab7:	50                   	push   %eax
  802ab8:	68 e1 46 80 00       	push   $0x8046e1
  802abd:	e8 1a e5 ff ff       	call   800fdc <cprintf>
  802ac2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802acb:	a1 48 50 80 00       	mov    0x805048,%eax
  802ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	74 07                	je     802ae0 <print_mem_block_lists+0x155>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	eb 05                	jmp    802ae5 <print_mem_block_lists+0x15a>
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae5:	a3 48 50 80 00       	mov    %eax,0x805048
  802aea:	a1 48 50 80 00       	mov    0x805048,%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	75 8a                	jne    802a7d <print_mem_block_lists+0xf2>
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	75 84                	jne    802a7d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802af9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802afd:	75 10                	jne    802b0f <print_mem_block_lists+0x184>
  802aff:	83 ec 0c             	sub    $0xc,%esp
  802b02:	68 2c 47 80 00       	push   $0x80472c
  802b07:	e8 d0 e4 ff ff       	call   800fdc <cprintf>
  802b0c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b0f:	83 ec 0c             	sub    $0xc,%esp
  802b12:	68 a0 46 80 00       	push   $0x8046a0
  802b17:	e8 c0 e4 ff ff       	call   800fdc <cprintf>
  802b1c:	83 c4 10             	add    $0x10,%esp

}
  802b1f:	90                   	nop
  802b20:	c9                   	leave  
  802b21:	c3                   	ret    

00802b22 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
  802b25:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802b28:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b2f:	00 00 00 
  802b32:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b39:	00 00 00 
  802b3c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b43:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b4d:	e9 9e 00 00 00       	jmp    802bf0 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802b52:	a1 50 50 80 00       	mov    0x805050,%eax
  802b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5a:	c1 e2 04             	shl    $0x4,%edx
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	75 14                	jne    802b77 <initialize_MemBlocksList+0x55>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 54 47 80 00       	push   $0x804754
  802b6b:	6a 3d                	push   $0x3d
  802b6d:	68 77 47 80 00       	push   $0x804777
  802b72:	e8 b1 e1 ff ff       	call   800d28 <_panic>
  802b77:	a1 50 50 80 00       	mov    0x805050,%eax
  802b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7f:	c1 e2 04             	shl    $0x4,%edx
  802b82:	01 d0                	add    %edx,%eax
  802b84:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b8a:	89 10                	mov    %edx,(%eax)
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 18                	je     802baa <initialize_MemBlocksList+0x88>
  802b92:	a1 48 51 80 00       	mov    0x805148,%eax
  802b97:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b9d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802ba0:	c1 e1 04             	shl    $0x4,%ecx
  802ba3:	01 ca                	add    %ecx,%edx
  802ba5:	89 50 04             	mov    %edx,0x4(%eax)
  802ba8:	eb 12                	jmp    802bbc <initialize_MemBlocksList+0x9a>
  802baa:	a1 50 50 80 00       	mov    0x805050,%eax
  802baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb2:	c1 e2 04             	shl    $0x4,%edx
  802bb5:	01 d0                	add    %edx,%eax
  802bb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bbc:	a1 50 50 80 00       	mov    0x805050,%eax
  802bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc4:	c1 e2 04             	shl    $0x4,%edx
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bce:	a1 50 50 80 00       	mov    0x805050,%eax
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	c1 e2 04             	shl    $0x4,%edx
  802bd9:	01 d0                	add    %edx,%eax
  802bdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be2:	a1 54 51 80 00       	mov    0x805154,%eax
  802be7:	40                   	inc    %eax
  802be8:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802bed:	ff 45 f4             	incl   -0xc(%ebp)
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf6:	0f 82 56 ff ff ff    	jb     802b52 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802bfc:	90                   	nop
  802bfd:	c9                   	leave  
  802bfe:	c3                   	ret    

00802bff <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
  802c02:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802c0d:	eb 18                	jmp    802c27 <find_block+0x28>

		if(tmp->sva == va){
  802c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c12:	8b 40 08             	mov    0x8(%eax),%eax
  802c15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c18:	75 05                	jne    802c1f <find_block+0x20>
			return tmp ;
  802c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c1d:	eb 11                	jmp    802c30 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c2b:	75 e2                	jne    802c0f <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802c38:	a1 40 50 80 00       	mov    0x805040,%eax
  802c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802c40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c45:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c4c:	75 65                	jne    802cb3 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c52:	75 14                	jne    802c68 <insert_sorted_allocList+0x36>
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	68 54 47 80 00       	push   $0x804754
  802c5c:	6a 62                	push   $0x62
  802c5e:	68 77 47 80 00       	push   $0x804777
  802c63:	e8 c0 e0 ff ff       	call   800d28 <_panic>
  802c68:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0d                	je     802c89 <insert_sorted_allocList+0x57>
  802c7c:	a1 40 50 80 00       	mov    0x805040,%eax
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	eb 08                	jmp    802c91 <insert_sorted_allocList+0x5f>
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 44 50 80 00       	mov    %eax,0x805044
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	a3 40 50 80 00       	mov    %eax,0x805040
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca8:	40                   	inc    %eax
  802ca9:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802cae:	e9 14 01 00 00       	jmp    802dc7 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	a1 44 50 80 00       	mov    0x805044,%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	39 c2                	cmp    %eax,%edx
  802cc3:	76 65                	jbe    802d2a <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc9:	75 14                	jne    802cdf <insert_sorted_allocList+0xad>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 90 47 80 00       	push   $0x804790
  802cd3:	6a 64                	push   $0x64
  802cd5:	68 77 47 80 00       	push   $0x804777
  802cda:	e8 49 e0 ff ff       	call   800d28 <_panic>
  802cdf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 40 04             	mov    0x4(%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 0c                	je     802d01 <insert_sorted_allocList+0xcf>
  802cf5:	a1 44 50 80 00       	mov    0x805044,%eax
  802cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfd:	89 10                	mov    %edx,(%eax)
  802cff:	eb 08                	jmp    802d09 <insert_sorted_allocList+0xd7>
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	a3 40 50 80 00       	mov    %eax,0x805040
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 44 50 80 00       	mov    %eax,0x805044
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d1f:	40                   	inc    %eax
  802d20:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d25:	e9 9d 00 00 00       	jmp    802dc7 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802d2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802d31:	e9 85 00 00 00       	jmp    802dbb <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 50 08             	mov    0x8(%eax),%edx
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 08             	mov    0x8(%eax),%eax
  802d42:	39 c2                	cmp    %eax,%edx
  802d44:	73 6a                	jae    802db0 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	74 06                	je     802d52 <insert_sorted_allocList+0x120>
  802d4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d50:	75 14                	jne    802d66 <insert_sorted_allocList+0x134>
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	68 b4 47 80 00       	push   $0x8047b4
  802d5a:	6a 6b                	push   $0x6b
  802d5c:	68 77 47 80 00       	push   $0x804777
  802d61:	e8 c2 df ff ff       	call   800d28 <_panic>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 50 04             	mov    0x4(%eax),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <insert_sorted_allocList+0x15f>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8d:	89 10                	mov    %edx,(%eax)
  802d8f:	eb 08                	jmp    802d99 <insert_sorted_allocList+0x167>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 40 50 80 00       	mov    %eax,0x805040
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802da7:	40                   	inc    %eax
  802da8:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802dad:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802dae:	eb 17                	jmp    802dc7 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802db8:	ff 45 f0             	incl   -0x10(%ebp)
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dc1:	0f 8c 6f ff ff ff    	jl     802d36 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802dc7:	90                   	nop
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
  802dcd:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802dd0:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802dd8:	e9 7c 01 00 00       	jmp    802f59 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 0c             	mov    0xc(%eax),%eax
  802de3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de6:	0f 86 cf 00 00 00    	jbe    802ebb <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802dec:	a1 48 51 80 00       	mov    0x805148,%eax
  802df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802e00:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 50 08             	mov    0x8(%eax),%edx
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 40 0c             	mov    0xc(%eax),%eax
  802e15:	2b 45 08             	sub    0x8(%ebp),%eax
  802e18:	89 c2                	mov    %eax,%edx
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 50 08             	mov    0x8(%eax),%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	01 c2                	add    %eax,%edx
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802e31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e35:	75 17                	jne    802e4e <alloc_block_FF+0x84>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 e9 47 80 00       	push   $0x8047e9
  802e3f:	68 83 00 00 00       	push   $0x83
  802e44:	68 77 47 80 00       	push   $0x804777
  802e49:	e8 da de ff ff       	call   800d28 <_panic>
  802e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 10                	je     802e67 <alloc_block_FF+0x9d>
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e5f:	8b 52 04             	mov    0x4(%edx),%edx
  802e62:	89 50 04             	mov    %edx,0x4(%eax)
  802e65:	eb 0b                	jmp    802e72 <alloc_block_FF+0xa8>
  802e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 0f                	je     802e8b <alloc_block_FF+0xc1>
  802e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e85:	8b 12                	mov    (%edx),%edx
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	eb 0a                	jmp    802e95 <alloc_block_FF+0xcb>
  802e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	a3 48 51 80 00       	mov    %eax,0x805148
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea8:	a1 54 51 80 00       	mov    0x805154,%eax
  802ead:	48                   	dec    %eax
  802eae:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	e9 ad 00 00 00       	jmp    802f68 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec4:	0f 85 87 00 00 00    	jne    802f51 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ece:	75 17                	jne    802ee7 <alloc_block_FF+0x11d>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 e9 47 80 00       	push   $0x8047e9
  802ed8:	68 87 00 00 00       	push   $0x87
  802edd:	68 77 47 80 00       	push   $0x804777
  802ee2:	e8 41 de ff ff       	call   800d28 <_panic>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 10                	je     802f00 <alloc_block_FF+0x136>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	8b 52 04             	mov    0x4(%edx),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 0b                	jmp    802f0b <alloc_block_FF+0x141>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 04             	mov    0x4(%eax),%eax
  802f06:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 0f                	je     802f24 <alloc_block_FF+0x15a>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1e:	8b 12                	mov    (%edx),%edx
  802f20:	89 10                	mov    %edx,(%eax)
  802f22:	eb 0a                	jmp    802f2e <alloc_block_FF+0x164>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 44 51 80 00       	mov    0x805144,%eax
  802f46:	48                   	dec    %eax
  802f47:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	eb 17                	jmp    802f68 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802f59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5d:	0f 85 7a fe ff ff    	jne    802ddd <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802f63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f68:	c9                   	leave  
  802f69:	c3                   	ret    

00802f6a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f6a:	55                   	push   %ebp
  802f6b:	89 e5                	mov    %esp,%ebp
  802f6d:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802f70:	a1 38 51 80 00       	mov    0x805138,%eax
  802f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802f7f:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802f86:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8e:	e9 d0 00 00 00       	jmp    803063 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 40 0c             	mov    0xc(%eax),%eax
  802f99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f9c:	0f 82 b8 00 00 00    	jb     80305a <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa8:	2b 45 08             	sub    0x8(%ebp),%eax
  802fab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802fb4:	0f 83 a1 00 00 00    	jae    80305b <alloc_block_BF+0xf1>
				differsize = differance ;
  802fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802fc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fca:	0f 85 8b 00 00 00    	jne    80305b <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	75 17                	jne    802fed <alloc_block_BF+0x83>
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	68 e9 47 80 00       	push   $0x8047e9
  802fde:	68 a0 00 00 00       	push   $0xa0
  802fe3:	68 77 47 80 00       	push   $0x804777
  802fe8:	e8 3b dd ff ff       	call   800d28 <_panic>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 10                	je     803006 <alloc_block_BF+0x9c>
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffe:	8b 52 04             	mov    0x4(%edx),%edx
  803001:	89 50 04             	mov    %edx,0x4(%eax)
  803004:	eb 0b                	jmp    803011 <alloc_block_BF+0xa7>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0f                	je     80302a <alloc_block_BF+0xc0>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803024:	8b 12                	mov    (%edx),%edx
  803026:	89 10                	mov    %edx,(%eax)
  803028:	eb 0a                	jmp    803034 <alloc_block_BF+0xca>
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803047:	a1 44 51 80 00       	mov    0x805144,%eax
  80304c:	48                   	dec    %eax
  80304d:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	e9 0c 01 00 00       	jmp    803166 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80305a:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80305b:	a1 40 51 80 00       	mov    0x805140,%eax
  803060:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803067:	74 07                	je     803070 <alloc_block_BF+0x106>
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	eb 05                	jmp    803075 <alloc_block_BF+0x10b>
  803070:	b8 00 00 00 00       	mov    $0x0,%eax
  803075:	a3 40 51 80 00       	mov    %eax,0x805140
  80307a:	a1 40 51 80 00       	mov    0x805140,%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	0f 85 0c ff ff ff    	jne    802f93 <alloc_block_BF+0x29>
  803087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308b:	0f 85 02 ff ff ff    	jne    802f93 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  803091:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803095:	0f 84 c6 00 00 00    	je     803161 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80309b:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	8b 50 08             	mov    0x8(%eax),%edx
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8030b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c1:	89 c2                	mov    %eax,%edx
  8030c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c6:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8030c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cc:	8b 50 08             	mov    0x8(%eax),%edx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	01 c2                	add    %eax,%edx
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8030da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030de:	75 17                	jne    8030f7 <alloc_block_BF+0x18d>
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	68 e9 47 80 00       	push   $0x8047e9
  8030e8:	68 af 00 00 00       	push   $0xaf
  8030ed:	68 77 47 80 00       	push   $0x804777
  8030f2:	e8 31 dc ff ff       	call   800d28 <_panic>
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 10                	je     803110 <alloc_block_BF+0x1a6>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803108:	8b 52 04             	mov    0x4(%edx),%edx
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	eb 0b                	jmp    80311b <alloc_block_BF+0x1b1>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0f                	je     803134 <alloc_block_BF+0x1ca>
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312e:	8b 12                	mov    (%edx),%edx
  803130:	89 10                	mov    %edx,(%eax)
  803132:	eb 0a                	jmp    80313e <alloc_block_BF+0x1d4>
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	a3 48 51 80 00       	mov    %eax,0x805148
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803151:	a1 54 51 80 00       	mov    0x805154,%eax
  803156:	48                   	dec    %eax
  803157:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	eb 05                	jmp    803166 <alloc_block_BF+0x1fc>
	}

	return NULL;
  803161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803166:	c9                   	leave  
  803167:	c3                   	ret    

00803168 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  803168:	55                   	push   %ebp
  803169:	89 e5                	mov    %esp,%ebp
  80316b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80316e:	a1 38 51 80 00       	mov    0x805138,%eax
  803173:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  803176:	e9 7c 01 00 00       	jmp    8032f7 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 40 0c             	mov    0xc(%eax),%eax
  803181:	3b 45 08             	cmp    0x8(%ebp),%eax
  803184:	0f 86 cf 00 00 00    	jbe    803259 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80318a:	a1 48 51 80 00       	mov    0x805148,%eax
  80318f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  803198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319b:	8b 55 08             	mov    0x8(%ebp),%edx
  80319e:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 50 08             	mov    0x8(%eax),%edx
  8031a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031aa:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8031b6:	89 c2                	mov    %eax,%edx
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 50 08             	mov    0x8(%eax),%edx
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	01 c2                	add    %eax,%edx
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8031cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d3:	75 17                	jne    8031ec <alloc_block_NF+0x84>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 e9 47 80 00       	push   $0x8047e9
  8031dd:	68 c4 00 00 00       	push   $0xc4
  8031e2:	68 77 47 80 00       	push   $0x804777
  8031e7:	e8 3c db ff ff       	call   800d28 <_panic>
  8031ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 10                	je     803205 <alloc_block_NF+0x9d>
  8031f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031fd:	8b 52 04             	mov    0x4(%edx),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 0b                	jmp    803210 <alloc_block_NF+0xa8>
  803205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0f                	je     803229 <alloc_block_NF+0xc1>
  80321a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803223:	8b 12                	mov    (%edx),%edx
  803225:	89 10                	mov    %edx,(%eax)
  803227:	eb 0a                	jmp    803233 <alloc_block_NF+0xcb>
  803229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	a3 48 51 80 00       	mov    %eax,0x805148
  803233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 51 80 00       	mov    0x805154,%eax
  80324b:	48                   	dec    %eax
  80324c:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	e9 ad 00 00 00       	jmp    803306 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 40 0c             	mov    0xc(%eax),%eax
  80325f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803262:	0f 85 87 00 00 00    	jne    8032ef <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326c:	75 17                	jne    803285 <alloc_block_NF+0x11d>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 e9 47 80 00       	push   $0x8047e9
  803276:	68 c8 00 00 00       	push   $0xc8
  80327b:	68 77 47 80 00       	push   $0x804777
  803280:	e8 a3 da ff ff       	call   800d28 <_panic>
  803285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	74 10                	je     80329e <alloc_block_NF+0x136>
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803296:	8b 52 04             	mov    0x4(%edx),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 0b                	jmp    8032a9 <alloc_block_NF+0x141>
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0f                	je     8032c2 <alloc_block_NF+0x15a>
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bc:	8b 12                	mov    (%edx),%edx
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	eb 0a                	jmp    8032cc <alloc_block_NF+0x164>
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	48                   	dec    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	eb 17                	jmp    803306 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8032f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fb:	0f 85 7a fe ff ff    	jne    80317b <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80330e:	a1 38 51 80 00       	mov    0x805138,%eax
  803313:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803316:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80331b:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80331e:	a1 44 51 80 00       	mov    0x805144,%eax
  803323:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803326:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80332a:	75 68                	jne    803394 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80332c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803330:	75 17                	jne    803349 <insert_sorted_with_merge_freeList+0x41>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 54 47 80 00       	push   $0x804754
  80333a:	68 da 00 00 00       	push   $0xda
  80333f:	68 77 47 80 00       	push   $0x804777
  803344:	e8 df d9 ff ff       	call   800d28 <_panic>
  803349:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	89 10                	mov    %edx,(%eax)
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0d                	je     80336a <insert_sorted_with_merge_freeList+0x62>
  80335d:	a1 38 51 80 00       	mov    0x805138,%eax
  803362:	8b 55 08             	mov    0x8(%ebp),%edx
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	eb 08                	jmp    803372 <insert_sorted_with_merge_freeList+0x6a>
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 38 51 80 00       	mov    %eax,0x805138
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 44 51 80 00       	mov    0x805144,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80338f:	e9 49 07 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 50 08             	mov    0x8(%eax),%edx
  80339a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339d:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a0:	01 c2                	add    %eax,%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	8b 40 08             	mov    0x8(%eax),%eax
  8033a8:	39 c2                	cmp    %eax,%edx
  8033aa:	73 77                	jae    803423 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	75 6e                	jne    803423 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8033b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033b9:	74 68                	je     803423 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8033bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bf:	75 17                	jne    8033d8 <insert_sorted_with_merge_freeList+0xd0>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 90 47 80 00       	push   $0x804790
  8033c9:	68 e0 00 00 00       	push   $0xe0
  8033ce:	68 77 47 80 00       	push   $0x804777
  8033d3:	e8 50 d9 ff ff       	call   800d28 <_panic>
  8033d8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	89 50 04             	mov    %edx,0x4(%eax)
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 0c                	je     8033fa <insert_sorted_with_merge_freeList+0xf2>
  8033ee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f6:	89 10                	mov    %edx,(%eax)
  8033f8:	eb 08                	jmp    803402 <insert_sorted_with_merge_freeList+0xfa>
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803413:	a1 44 51 80 00       	mov    0x805144,%eax
  803418:	40                   	inc    %eax
  803419:	a3 44 51 80 00       	mov    %eax,0x805144
  80341e:	e9 ba 06 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 50 0c             	mov    0xc(%eax),%edx
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 40 08             	mov    0x8(%eax),%eax
  80342f:	01 c2                	add    %eax,%edx
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 40 08             	mov    0x8(%eax),%eax
  803437:	39 c2                	cmp    %eax,%edx
  803439:	73 78                	jae    8034b3 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 40 04             	mov    0x4(%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	75 6e                	jne    8034b3 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803449:	74 68                	je     8034b3 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80344b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344f:	75 17                	jne    803468 <insert_sorted_with_merge_freeList+0x160>
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 54 47 80 00       	push   $0x804754
  803459:	68 e6 00 00 00       	push   $0xe6
  80345e:	68 77 47 80 00       	push   $0x804777
  803463:	e8 c0 d8 ff ff       	call   800d28 <_panic>
  803468:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	89 10                	mov    %edx,(%eax)
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 0d                	je     803489 <insert_sorted_with_merge_freeList+0x181>
  80347c:	a1 38 51 80 00       	mov    0x805138,%eax
  803481:	8b 55 08             	mov    0x8(%ebp),%edx
  803484:	89 50 04             	mov    %edx,0x4(%eax)
  803487:	eb 08                	jmp    803491 <insert_sorted_with_merge_freeList+0x189>
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	a3 38 51 80 00       	mov    %eax,0x805138
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a8:	40                   	inc    %eax
  8034a9:	a3 44 51 80 00       	mov    %eax,0x805144
  8034ae:	e9 2a 06 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8034b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8034b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034bb:	e9 ed 05 00 00       	jmp    803aad <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8034c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034cc:	0f 84 a7 00 00 00    	je     803579 <insert_sorted_with_merge_freeList+0x271>
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	8b 40 08             	mov    0x8(%eax),%eax
  8034de:	01 c2                	add    %eax,%edx
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	8b 40 08             	mov    0x8(%eax),%eax
  8034e6:	39 c2                	cmp    %eax,%edx
  8034e8:	0f 83 8b 00 00 00    	jae    803579 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 40 08             	mov    0x8(%eax),%eax
  8034fa:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8034fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ff:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803502:	39 c2                	cmp    %eax,%edx
  803504:	73 73                	jae    803579 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350a:	74 06                	je     803512 <insert_sorted_with_merge_freeList+0x20a>
  80350c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0x221>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 08 48 80 00       	push   $0x804808
  80351a:	68 f0 00 00 00       	push   $0xf0
  80351f:	68 77 47 80 00       	push   $0x804777
  803524:	e8 ff d7 ff ff       	call   800d28 <_panic>
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 10                	mov    (%eax),%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	89 10                	mov    %edx,(%eax)
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 0b                	je     803547 <insert_sorted_with_merge_freeList+0x23f>
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	8b 55 08             	mov    0x8(%ebp),%edx
  803544:	89 50 04             	mov    %edx,0x4(%eax)
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 55 08             	mov    0x8(%ebp),%edx
  80354d:	89 10                	mov    %edx,(%eax)
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803555:	89 50 04             	mov    %edx,0x4(%eax)
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	85 c0                	test   %eax,%eax
  80355f:	75 08                	jne    803569 <insert_sorted_with_merge_freeList+0x261>
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803569:	a1 44 51 80 00       	mov    0x805144,%eax
  80356e:	40                   	inc    %eax
  80356f:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803574:	e9 64 05 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803579:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80357e:	8b 50 0c             	mov    0xc(%eax),%edx
  803581:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803586:	8b 40 08             	mov    0x8(%eax),%eax
  803589:	01 c2                	add    %eax,%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 40 08             	mov    0x8(%eax),%eax
  803591:	39 c2                	cmp    %eax,%edx
  803593:	0f 85 b1 00 00 00    	jne    80364a <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803599:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	0f 84 a4 00 00 00    	je     80364a <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  8035a6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	0f 85 95 00 00 00    	jne    80364a <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  8035b5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035ba:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035c0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8035c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8035c9:	01 ca                	add    %ecx,%edx
  8035cb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8035e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e6:	75 17                	jne    8035ff <insert_sorted_with_merge_freeList+0x2f7>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 54 47 80 00       	push   $0x804754
  8035f0:	68 ff 00 00 00       	push   $0xff
  8035f5:	68 77 47 80 00       	push   $0x804777
  8035fa:	e8 29 d7 ff ff       	call   800d28 <_panic>
  8035ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	74 0d                	je     803620 <insert_sorted_with_merge_freeList+0x318>
  803613:	a1 48 51 80 00       	mov    0x805148,%eax
  803618:	8b 55 08             	mov    0x8(%ebp),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 08                	jmp    803628 <insert_sorted_with_merge_freeList+0x320>
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	a3 48 51 80 00       	mov    %eax,0x805148
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363a:	a1 54 51 80 00       	mov    0x805154,%eax
  80363f:	40                   	inc    %eax
  803640:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803645:	e9 93 04 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	8b 50 08             	mov    0x8(%eax),%edx
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 40 0c             	mov    0xc(%eax),%eax
  803656:	01 c2                	add    %eax,%edx
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	8b 40 08             	mov    0x8(%eax),%eax
  80365e:	39 c2                	cmp    %eax,%edx
  803660:	0f 85 ae 00 00 00    	jne    803714 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	8b 50 0c             	mov    0xc(%eax),%edx
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	8b 40 08             	mov    0x8(%eax),%eax
  803672:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  80367c:	39 c2                	cmp    %eax,%edx
  80367e:	0f 84 90 00 00 00    	je     803714 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	8b 50 0c             	mov    0xc(%eax),%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 40 0c             	mov    0xc(%eax),%eax
  803690:	01 c2                	add    %eax,%edx
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8036ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b0:	75 17                	jne    8036c9 <insert_sorted_with_merge_freeList+0x3c1>
  8036b2:	83 ec 04             	sub    $0x4,%esp
  8036b5:	68 54 47 80 00       	push   $0x804754
  8036ba:	68 0b 01 00 00       	push   $0x10b
  8036bf:	68 77 47 80 00       	push   $0x804777
  8036c4:	e8 5f d6 ff ff       	call   800d28 <_panic>
  8036c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	89 10                	mov    %edx,(%eax)
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	74 0d                	je     8036ea <insert_sorted_with_merge_freeList+0x3e2>
  8036dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8036e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e5:	89 50 04             	mov    %edx,0x4(%eax)
  8036e8:	eb 08                	jmp    8036f2 <insert_sorted_with_merge_freeList+0x3ea>
  8036ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803704:	a1 54 51 80 00       	mov    0x805154,%eax
  803709:	40                   	inc    %eax
  80370a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80370f:	e9 c9 03 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	8b 50 0c             	mov    0xc(%eax),%edx
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 40 08             	mov    0x8(%eax),%eax
  803720:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803725:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803728:	39 c2                	cmp    %eax,%edx
  80372a:	0f 85 bb 00 00 00    	jne    8037eb <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803734:	0f 84 b1 00 00 00    	je     8037eb <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  80373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	0f 85 a3 00 00 00    	jne    8037eb <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803748:	a1 38 51 80 00       	mov    0x805138,%eax
  80374d:	8b 55 08             	mov    0x8(%ebp),%edx
  803750:	8b 52 08             	mov    0x8(%edx),%edx
  803753:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803756:	a1 38 51 80 00       	mov    0x805138,%eax
  80375b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803761:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803764:	8b 55 08             	mov    0x8(%ebp),%edx
  803767:	8b 52 0c             	mov    0xc(%edx),%edx
  80376a:	01 ca                	add    %ecx,%edx
  80376c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803783:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803787:	75 17                	jne    8037a0 <insert_sorted_with_merge_freeList+0x498>
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	68 54 47 80 00       	push   $0x804754
  803791:	68 17 01 00 00       	push   $0x117
  803796:	68 77 47 80 00       	push   $0x804777
  80379b:	e8 88 d5 ff ff       	call   800d28 <_panic>
  8037a0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	89 10                	mov    %edx,(%eax)
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	85 c0                	test   %eax,%eax
  8037b2:	74 0d                	je     8037c1 <insert_sorted_with_merge_freeList+0x4b9>
  8037b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bc:	89 50 04             	mov    %edx,0x4(%eax)
  8037bf:	eb 08                	jmp    8037c9 <insert_sorted_with_merge_freeList+0x4c1>
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	a3 48 51 80 00       	mov    %eax,0x805148
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037db:	a1 54 51 80 00       	mov    0x805154,%eax
  8037e0:	40                   	inc    %eax
  8037e1:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8037e6:	e9 f2 02 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	8b 50 08             	mov    0x8(%eax),%edx
  8037f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f7:	01 c2                	add    %eax,%edx
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	8b 40 08             	mov    0x8(%eax),%eax
  8037ff:	39 c2                	cmp    %eax,%edx
  803801:	0f 85 be 00 00 00    	jne    8038c5 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	8b 40 04             	mov    0x4(%eax),%eax
  80380d:	8b 50 08             	mov    0x8(%eax),%edx
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	8b 40 04             	mov    0x4(%eax),%eax
  803816:	8b 40 0c             	mov    0xc(%eax),%eax
  803819:	01 c2                	add    %eax,%edx
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	8b 40 08             	mov    0x8(%eax),%eax
  803821:	39 c2                	cmp    %eax,%edx
  803823:	0f 84 9c 00 00 00    	je     8038c5 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	8b 50 08             	mov    0x8(%eax),%edx
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 50 0c             	mov    0xc(%eax),%edx
  80383b:	8b 45 08             	mov    0x8(%ebp),%eax
  80383e:	8b 40 0c             	mov    0xc(%eax),%eax
  803841:	01 c2                	add    %eax,%edx
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80385d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803861:	75 17                	jne    80387a <insert_sorted_with_merge_freeList+0x572>
  803863:	83 ec 04             	sub    $0x4,%esp
  803866:	68 54 47 80 00       	push   $0x804754
  80386b:	68 26 01 00 00       	push   $0x126
  803870:	68 77 47 80 00       	push   $0x804777
  803875:	e8 ae d4 ff ff       	call   800d28 <_panic>
  80387a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	89 10                	mov    %edx,(%eax)
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	85 c0                	test   %eax,%eax
  80388c:	74 0d                	je     80389b <insert_sorted_with_merge_freeList+0x593>
  80388e:	a1 48 51 80 00       	mov    0x805148,%eax
  803893:	8b 55 08             	mov    0x8(%ebp),%edx
  803896:	89 50 04             	mov    %edx,0x4(%eax)
  803899:	eb 08                	jmp    8038a3 <insert_sorted_with_merge_freeList+0x59b>
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ba:	40                   	inc    %eax
  8038bb:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8038c0:	e9 18 02 00 00       	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8038c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8038cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ce:	8b 40 08             	mov    0x8(%eax),%eax
  8038d1:	01 c2                	add    %eax,%edx
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	8b 40 08             	mov    0x8(%eax),%eax
  8038d9:	39 c2                	cmp    %eax,%edx
  8038db:	0f 85 c4 01 00 00    	jne    803aa5 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	8b 40 08             	mov    0x8(%eax),%eax
  8038ed:	01 c2                	add    %eax,%edx
  8038ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	8b 40 08             	mov    0x8(%eax),%eax
  8038f7:	39 c2                	cmp    %eax,%edx
  8038f9:	0f 85 a6 01 00 00    	jne    803aa5 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8038ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803903:	0f 84 9c 01 00 00    	je     803aa5 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 50 0c             	mov    0xc(%eax),%edx
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
  803912:	8b 40 0c             	mov    0xc(%eax),%eax
  803915:	01 c2                	add    %eax,%edx
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	8b 40 0c             	mov    0xc(%eax),%eax
  80391f:	01 c2                	add    %eax,%edx
  803921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803924:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80393b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80393f:	75 17                	jne    803958 <insert_sorted_with_merge_freeList+0x650>
  803941:	83 ec 04             	sub    $0x4,%esp
  803944:	68 54 47 80 00       	push   $0x804754
  803949:	68 32 01 00 00       	push   $0x132
  80394e:	68 77 47 80 00       	push   $0x804777
  803953:	e8 d0 d3 ff ff       	call   800d28 <_panic>
  803958:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80395e:	8b 45 08             	mov    0x8(%ebp),%eax
  803961:	89 10                	mov    %edx,(%eax)
  803963:	8b 45 08             	mov    0x8(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	85 c0                	test   %eax,%eax
  80396a:	74 0d                	je     803979 <insert_sorted_with_merge_freeList+0x671>
  80396c:	a1 48 51 80 00       	mov    0x805148,%eax
  803971:	8b 55 08             	mov    0x8(%ebp),%edx
  803974:	89 50 04             	mov    %edx,0x4(%eax)
  803977:	eb 08                	jmp    803981 <insert_sorted_with_merge_freeList+0x679>
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	a3 48 51 80 00       	mov    %eax,0x805148
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803993:	a1 54 51 80 00       	mov    0x805154,%eax
  803998:	40                   	inc    %eax
  803999:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80399e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a1:	8b 00                	mov    (%eax),%eax
  8039a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b9:	8b 00                	mov    (%eax),%eax
  8039bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8039be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039c2:	75 17                	jne    8039db <insert_sorted_with_merge_freeList+0x6d3>
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	68 e9 47 80 00       	push   $0x8047e9
  8039cc:	68 36 01 00 00       	push   $0x136
  8039d1:	68 77 47 80 00       	push   $0x804777
  8039d6:	e8 4d d3 ff ff       	call   800d28 <_panic>
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039de:	8b 00                	mov    (%eax),%eax
  8039e0:	85 c0                	test   %eax,%eax
  8039e2:	74 10                	je     8039f4 <insert_sorted_with_merge_freeList+0x6ec>
  8039e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e7:	8b 00                	mov    (%eax),%eax
  8039e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ec:	8b 52 04             	mov    0x4(%edx),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	eb 0b                	jmp    8039ff <insert_sorted_with_merge_freeList+0x6f7>
  8039f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f7:	8b 40 04             	mov    0x4(%eax),%eax
  8039fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a02:	8b 40 04             	mov    0x4(%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	74 0f                	je     803a18 <insert_sorted_with_merge_freeList+0x710>
  803a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0c:	8b 40 04             	mov    0x4(%eax),%eax
  803a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a12:	8b 12                	mov    (%edx),%edx
  803a14:	89 10                	mov    %edx,(%eax)
  803a16:	eb 0a                	jmp    803a22 <insert_sorted_with_merge_freeList+0x71a>
  803a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	a3 38 51 80 00       	mov    %eax,0x805138
  803a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a35:	a1 44 51 80 00       	mov    0x805144,%eax
  803a3a:	48                   	dec    %eax
  803a3b:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a44:	75 17                	jne    803a5d <insert_sorted_with_merge_freeList+0x755>
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	68 54 47 80 00       	push   $0x804754
  803a4e:	68 37 01 00 00       	push   $0x137
  803a53:	68 77 47 80 00       	push   $0x804777
  803a58:	e8 cb d2 ff ff       	call   800d28 <_panic>
  803a5d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a66:	89 10                	mov    %edx,(%eax)
  803a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	74 0d                	je     803a7e <insert_sorted_with_merge_freeList+0x776>
  803a71:	a1 48 51 80 00       	mov    0x805148,%eax
  803a76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a79:	89 50 04             	mov    %edx,0x4(%eax)
  803a7c:	eb 08                	jmp    803a86 <insert_sorted_with_merge_freeList+0x77e>
  803a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a89:	a3 48 51 80 00       	mov    %eax,0x805148
  803a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a98:	a1 54 51 80 00       	mov    0x805154,%eax
  803a9d:	40                   	inc    %eax
  803a9e:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803aa3:	eb 38                	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803aa5:	a1 40 51 80 00       	mov    0x805140,%eax
  803aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab1:	74 07                	je     803aba <insert_sorted_with_merge_freeList+0x7b2>
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	8b 00                	mov    (%eax),%eax
  803ab8:	eb 05                	jmp    803abf <insert_sorted_with_merge_freeList+0x7b7>
  803aba:	b8 00 00 00 00       	mov    $0x0,%eax
  803abf:	a3 40 51 80 00       	mov    %eax,0x805140
  803ac4:	a1 40 51 80 00       	mov    0x805140,%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	0f 85 ef f9 ff ff    	jne    8034c0 <insert_sorted_with_merge_freeList+0x1b8>
  803ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad5:	0f 85 e5 f9 ff ff    	jne    8034c0 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803adb:	eb 00                	jmp    803add <insert_sorted_with_merge_freeList+0x7d5>
  803add:	90                   	nop
  803ade:	c9                   	leave  
  803adf:	c3                   	ret    

00803ae0 <__udivdi3>:
  803ae0:	55                   	push   %ebp
  803ae1:	57                   	push   %edi
  803ae2:	56                   	push   %esi
  803ae3:	53                   	push   %ebx
  803ae4:	83 ec 1c             	sub    $0x1c,%esp
  803ae7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aeb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803aef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af7:	89 ca                	mov    %ecx,%edx
  803af9:	89 f8                	mov    %edi,%eax
  803afb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aff:	85 f6                	test   %esi,%esi
  803b01:	75 2d                	jne    803b30 <__udivdi3+0x50>
  803b03:	39 cf                	cmp    %ecx,%edi
  803b05:	77 65                	ja     803b6c <__udivdi3+0x8c>
  803b07:	89 fd                	mov    %edi,%ebp
  803b09:	85 ff                	test   %edi,%edi
  803b0b:	75 0b                	jne    803b18 <__udivdi3+0x38>
  803b0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b12:	31 d2                	xor    %edx,%edx
  803b14:	f7 f7                	div    %edi
  803b16:	89 c5                	mov    %eax,%ebp
  803b18:	31 d2                	xor    %edx,%edx
  803b1a:	89 c8                	mov    %ecx,%eax
  803b1c:	f7 f5                	div    %ebp
  803b1e:	89 c1                	mov    %eax,%ecx
  803b20:	89 d8                	mov    %ebx,%eax
  803b22:	f7 f5                	div    %ebp
  803b24:	89 cf                	mov    %ecx,%edi
  803b26:	89 fa                	mov    %edi,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	39 ce                	cmp    %ecx,%esi
  803b32:	77 28                	ja     803b5c <__udivdi3+0x7c>
  803b34:	0f bd fe             	bsr    %esi,%edi
  803b37:	83 f7 1f             	xor    $0x1f,%edi
  803b3a:	75 40                	jne    803b7c <__udivdi3+0x9c>
  803b3c:	39 ce                	cmp    %ecx,%esi
  803b3e:	72 0a                	jb     803b4a <__udivdi3+0x6a>
  803b40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b44:	0f 87 9e 00 00 00    	ja     803be8 <__udivdi3+0x108>
  803b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4f:	89 fa                	mov    %edi,%edx
  803b51:	83 c4 1c             	add    $0x1c,%esp
  803b54:	5b                   	pop    %ebx
  803b55:	5e                   	pop    %esi
  803b56:	5f                   	pop    %edi
  803b57:	5d                   	pop    %ebp
  803b58:	c3                   	ret    
  803b59:	8d 76 00             	lea    0x0(%esi),%esi
  803b5c:	31 ff                	xor    %edi,%edi
  803b5e:	31 c0                	xor    %eax,%eax
  803b60:	89 fa                	mov    %edi,%edx
  803b62:	83 c4 1c             	add    $0x1c,%esp
  803b65:	5b                   	pop    %ebx
  803b66:	5e                   	pop    %esi
  803b67:	5f                   	pop    %edi
  803b68:	5d                   	pop    %ebp
  803b69:	c3                   	ret    
  803b6a:	66 90                	xchg   %ax,%ax
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	f7 f7                	div    %edi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	89 fa                	mov    %edi,%edx
  803b74:	83 c4 1c             	add    $0x1c,%esp
  803b77:	5b                   	pop    %ebx
  803b78:	5e                   	pop    %esi
  803b79:	5f                   	pop    %edi
  803b7a:	5d                   	pop    %ebp
  803b7b:	c3                   	ret    
  803b7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b81:	89 eb                	mov    %ebp,%ebx
  803b83:	29 fb                	sub    %edi,%ebx
  803b85:	89 f9                	mov    %edi,%ecx
  803b87:	d3 e6                	shl    %cl,%esi
  803b89:	89 c5                	mov    %eax,%ebp
  803b8b:	88 d9                	mov    %bl,%cl
  803b8d:	d3 ed                	shr    %cl,%ebp
  803b8f:	89 e9                	mov    %ebp,%ecx
  803b91:	09 f1                	or     %esi,%ecx
  803b93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b97:	89 f9                	mov    %edi,%ecx
  803b99:	d3 e0                	shl    %cl,%eax
  803b9b:	89 c5                	mov    %eax,%ebp
  803b9d:	89 d6                	mov    %edx,%esi
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ee                	shr    %cl,%esi
  803ba3:	89 f9                	mov    %edi,%ecx
  803ba5:	d3 e2                	shl    %cl,%edx
  803ba7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bab:	88 d9                	mov    %bl,%cl
  803bad:	d3 e8                	shr    %cl,%eax
  803baf:	09 c2                	or     %eax,%edx
  803bb1:	89 d0                	mov    %edx,%eax
  803bb3:	89 f2                	mov    %esi,%edx
  803bb5:	f7 74 24 0c          	divl   0xc(%esp)
  803bb9:	89 d6                	mov    %edx,%esi
  803bbb:	89 c3                	mov    %eax,%ebx
  803bbd:	f7 e5                	mul    %ebp
  803bbf:	39 d6                	cmp    %edx,%esi
  803bc1:	72 19                	jb     803bdc <__udivdi3+0xfc>
  803bc3:	74 0b                	je     803bd0 <__udivdi3+0xf0>
  803bc5:	89 d8                	mov    %ebx,%eax
  803bc7:	31 ff                	xor    %edi,%edi
  803bc9:	e9 58 ff ff ff       	jmp    803b26 <__udivdi3+0x46>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd4:	89 f9                	mov    %edi,%ecx
  803bd6:	d3 e2                	shl    %cl,%edx
  803bd8:	39 c2                	cmp    %eax,%edx
  803bda:	73 e9                	jae    803bc5 <__udivdi3+0xe5>
  803bdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bdf:	31 ff                	xor    %edi,%edi
  803be1:	e9 40 ff ff ff       	jmp    803b26 <__udivdi3+0x46>
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	31 c0                	xor    %eax,%eax
  803bea:	e9 37 ff ff ff       	jmp    803b26 <__udivdi3+0x46>
  803bef:	90                   	nop

00803bf0 <__umoddi3>:
  803bf0:	55                   	push   %ebp
  803bf1:	57                   	push   %edi
  803bf2:	56                   	push   %esi
  803bf3:	53                   	push   %ebx
  803bf4:	83 ec 1c             	sub    $0x1c,%esp
  803bf7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bfb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c0f:	89 f3                	mov    %esi,%ebx
  803c11:	89 fa                	mov    %edi,%edx
  803c13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c17:	89 34 24             	mov    %esi,(%esp)
  803c1a:	85 c0                	test   %eax,%eax
  803c1c:	75 1a                	jne    803c38 <__umoddi3+0x48>
  803c1e:	39 f7                	cmp    %esi,%edi
  803c20:	0f 86 a2 00 00 00    	jbe    803cc8 <__umoddi3+0xd8>
  803c26:	89 c8                	mov    %ecx,%eax
  803c28:	89 f2                	mov    %esi,%edx
  803c2a:	f7 f7                	div    %edi
  803c2c:	89 d0                	mov    %edx,%eax
  803c2e:	31 d2                	xor    %edx,%edx
  803c30:	83 c4 1c             	add    $0x1c,%esp
  803c33:	5b                   	pop    %ebx
  803c34:	5e                   	pop    %esi
  803c35:	5f                   	pop    %edi
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    
  803c38:	39 f0                	cmp    %esi,%eax
  803c3a:	0f 87 ac 00 00 00    	ja     803cec <__umoddi3+0xfc>
  803c40:	0f bd e8             	bsr    %eax,%ebp
  803c43:	83 f5 1f             	xor    $0x1f,%ebp
  803c46:	0f 84 ac 00 00 00    	je     803cf8 <__umoddi3+0x108>
  803c4c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c51:	29 ef                	sub    %ebp,%edi
  803c53:	89 fe                	mov    %edi,%esi
  803c55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 e0                	shl    %cl,%eax
  803c5d:	89 d7                	mov    %edx,%edi
  803c5f:	89 f1                	mov    %esi,%ecx
  803c61:	d3 ef                	shr    %cl,%edi
  803c63:	09 c7                	or     %eax,%edi
  803c65:	89 e9                	mov    %ebp,%ecx
  803c67:	d3 e2                	shl    %cl,%edx
  803c69:	89 14 24             	mov    %edx,(%esp)
  803c6c:	89 d8                	mov    %ebx,%eax
  803c6e:	d3 e0                	shl    %cl,%eax
  803c70:	89 c2                	mov    %eax,%edx
  803c72:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c76:	d3 e0                	shl    %cl,%eax
  803c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c80:	89 f1                	mov    %esi,%ecx
  803c82:	d3 e8                	shr    %cl,%eax
  803c84:	09 d0                	or     %edx,%eax
  803c86:	d3 eb                	shr    %cl,%ebx
  803c88:	89 da                	mov    %ebx,%edx
  803c8a:	f7 f7                	div    %edi
  803c8c:	89 d3                	mov    %edx,%ebx
  803c8e:	f7 24 24             	mull   (%esp)
  803c91:	89 c6                	mov    %eax,%esi
  803c93:	89 d1                	mov    %edx,%ecx
  803c95:	39 d3                	cmp    %edx,%ebx
  803c97:	0f 82 87 00 00 00    	jb     803d24 <__umoddi3+0x134>
  803c9d:	0f 84 91 00 00 00    	je     803d34 <__umoddi3+0x144>
  803ca3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ca7:	29 f2                	sub    %esi,%edx
  803ca9:	19 cb                	sbb    %ecx,%ebx
  803cab:	89 d8                	mov    %ebx,%eax
  803cad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cb1:	d3 e0                	shl    %cl,%eax
  803cb3:	89 e9                	mov    %ebp,%ecx
  803cb5:	d3 ea                	shr    %cl,%edx
  803cb7:	09 d0                	or     %edx,%eax
  803cb9:	89 e9                	mov    %ebp,%ecx
  803cbb:	d3 eb                	shr    %cl,%ebx
  803cbd:	89 da                	mov    %ebx,%edx
  803cbf:	83 c4 1c             	add    $0x1c,%esp
  803cc2:	5b                   	pop    %ebx
  803cc3:	5e                   	pop    %esi
  803cc4:	5f                   	pop    %edi
  803cc5:	5d                   	pop    %ebp
  803cc6:	c3                   	ret    
  803cc7:	90                   	nop
  803cc8:	89 fd                	mov    %edi,%ebp
  803cca:	85 ff                	test   %edi,%edi
  803ccc:	75 0b                	jne    803cd9 <__umoddi3+0xe9>
  803cce:	b8 01 00 00 00       	mov    $0x1,%eax
  803cd3:	31 d2                	xor    %edx,%edx
  803cd5:	f7 f7                	div    %edi
  803cd7:	89 c5                	mov    %eax,%ebp
  803cd9:	89 f0                	mov    %esi,%eax
  803cdb:	31 d2                	xor    %edx,%edx
  803cdd:	f7 f5                	div    %ebp
  803cdf:	89 c8                	mov    %ecx,%eax
  803ce1:	f7 f5                	div    %ebp
  803ce3:	89 d0                	mov    %edx,%eax
  803ce5:	e9 44 ff ff ff       	jmp    803c2e <__umoddi3+0x3e>
  803cea:	66 90                	xchg   %ax,%ax
  803cec:	89 c8                	mov    %ecx,%eax
  803cee:	89 f2                	mov    %esi,%edx
  803cf0:	83 c4 1c             	add    $0x1c,%esp
  803cf3:	5b                   	pop    %ebx
  803cf4:	5e                   	pop    %esi
  803cf5:	5f                   	pop    %edi
  803cf6:	5d                   	pop    %ebp
  803cf7:	c3                   	ret    
  803cf8:	3b 04 24             	cmp    (%esp),%eax
  803cfb:	72 06                	jb     803d03 <__umoddi3+0x113>
  803cfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d01:	77 0f                	ja     803d12 <__umoddi3+0x122>
  803d03:	89 f2                	mov    %esi,%edx
  803d05:	29 f9                	sub    %edi,%ecx
  803d07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d0b:	89 14 24             	mov    %edx,(%esp)
  803d0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d16:	8b 14 24             	mov    (%esp),%edx
  803d19:	83 c4 1c             	add    $0x1c,%esp
  803d1c:	5b                   	pop    %ebx
  803d1d:	5e                   	pop    %esi
  803d1e:	5f                   	pop    %edi
  803d1f:	5d                   	pop    %ebp
  803d20:	c3                   	ret    
  803d21:	8d 76 00             	lea    0x0(%esi),%esi
  803d24:	2b 04 24             	sub    (%esp),%eax
  803d27:	19 fa                	sbb    %edi,%edx
  803d29:	89 d1                	mov    %edx,%ecx
  803d2b:	89 c6                	mov    %eax,%esi
  803d2d:	e9 71 ff ff ff       	jmp    803ca3 <__umoddi3+0xb3>
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d38:	72 ea                	jb     803d24 <__umoddi3+0x134>
  803d3a:	89 d9                	mov    %ebx,%ecx
  803d3c:	e9 62 ff ff ff       	jmp    803ca3 <__umoddi3+0xb3>
