
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 ac 29 00 00       	call   8029f9 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 20 3e 80 00       	push   $0x803e20
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 3c 3e 80 00       	push   $0x803e3c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 8d 1f 00 00       	call   802046 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 50 3e 80 00       	push   $0x803e50
  8000fc:	68 67 3e 80 00       	push   $0x803e67
  800101:	6a 24                	push   $0x24
  800103:	68 3c 3e 80 00       	push   $0x803e3c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 e2 28 00 00       	call   8029f9 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 20 3e 80 00       	push   $0x803e20
  80016d:	6a 36                	push   $0x36
  80016f:	68 3c 3e 80 00       	push   $0x803e3c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 7c 3e 80 00       	push   $0x803e7c
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 c8 3e 80 00       	push   $0x803ec8
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 3c 3e 80 00       	push   $0x803e3c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 d0 22 00 00       	call   8024e4 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 68 23 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 10 1e 00 00       	call   802046 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 18 3f 80 00       	push   $0x803f18
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 3c 3e 80 00       	push   $0x803e3c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 bf 22 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 56 3f 80 00       	push   $0x803f56
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 3c 3e 80 00       	push   $0x803e3c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 e8 21 00 00       	call   8024e4 <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 73 3f 80 00       	push   $0x803f73
  80031e:	6a 60                	push   $0x60
  800320:	68 3c 3e 80 00       	push   $0x803e3c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 b5 21 00 00       	call   8024e4 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 4d 22 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 96 1d 00 00       	call   8020df <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 84 1d 00 00       	call   8020df <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 72 1d 00 00       	call   8020df <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 60 1d 00 00       	call   8020df <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 4e 1d 00 00       	call   8020df <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 3c 1d 00 00       	call   8020df <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 2a 1d 00 00       	call   8020df <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 18 1d 00 00       	call   8020df <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 06 1d 00 00       	call   8020df <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 f4 1c 00 00       	call   8020df <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 e2 1c 00 00       	call   8020df <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 d0 1c 00 00       	call   8020df <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 be 1c 00 00       	call   8020df <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 ac 1c 00 00       	call   8020df <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 9a 1c 00 00       	call   8020df <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 37 21 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 84 3f 80 00       	push   $0x803f84
  800480:	6a 76                	push   $0x76
  800482:	68 3c 3e 80 00       	push   $0x803e3c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 53 20 00 00       	call   8024e4 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 c0 3f 80 00       	push   $0x803fc0
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 3c 3e 80 00       	push   $0x803e3c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 31 20 00 00       	call   8024e4 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 c9 20 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 7c 1b 00 00       	call   802046 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 00 40 80 00       	push   $0x804000
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 3c 3e 80 00       	push   $0x803e3c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 91 20 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 56 3f 80 00       	push   $0x803f56
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 3c 3e 80 00       	push   $0x803e3c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 bd 1f 00 00       	call   8024e4 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 73 3f 80 00       	push   $0x803f73
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 3c 3e 80 00       	push   $0x803e3c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 20 40 80 00       	push   $0x804020
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 82 1f 00 00       	call   8024e4 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 1a 20 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 ca 1a 00 00       	call   802046 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 00 40 80 00       	push   $0x804000
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 3c 3e 80 00       	push   $0x803e3c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 dc 1f 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 56 3f 80 00       	push   $0x803f56
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 3c 3e 80 00       	push   $0x803e3c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 05 1f 00 00       	call   8024e4 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 73 3f 80 00       	push   $0x803f73
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 3c 3e 80 00       	push   $0x803e3c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 20 40 80 00       	push   $0x804020
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 ca 1e 00 00       	call   8024e4 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 62 1f 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 0d 1a 00 00       	call   802046 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 00 40 80 00       	push   $0x804000
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 3c 3e 80 00       	push   $0x803e3c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 1f 1f 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 56 3f 80 00       	push   $0x803f56
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 3c 3e 80 00       	push   $0x803e3c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 43 1e 00 00       	call   8024e4 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 73 3f 80 00       	push   $0x803f73
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 3c 3e 80 00       	push   $0x803e3c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 20 40 80 00       	push   $0x804020
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 08 1e 00 00       	call   8024e4 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 a0 1e 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 4c 19 00 00       	call   802046 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 00 40 80 00       	push   $0x804000
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 3c 3e 80 00       	push   $0x803e3c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 5e 1e 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 56 3f 80 00       	push   $0x803f56
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 3c 3e 80 00       	push   $0x803e3c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 83 1d 00 00       	call   8024e4 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 73 3f 80 00       	push   $0x803f73
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 3c 3e 80 00       	push   $0x803e3c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 20 40 80 00       	push   $0x804020
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 48 1d 00 00       	call   8024e4 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 e0 1d 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 90 18 00 00       	call   802046 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 00 40 80 00       	push   $0x804000
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 3c 3e 80 00       	push   $0x803e3c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 a2 1d 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 56 3f 80 00       	push   $0x803f56
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 3c 3e 80 00       	push   $0x803e3c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 cb 1c 00 00       	call   8024e4 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 73 3f 80 00       	push   $0x803f73
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 3c 3e 80 00       	push   $0x803e3c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 20 40 80 00       	push   $0x804020
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 90 1c 00 00       	call   8024e4 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 28 1d 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 d9 17 00 00       	call   802046 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 00 40 80 00       	push   $0x804000
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 3c 3e 80 00       	push   $0x803e3c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 eb 1c 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 56 3f 80 00       	push   $0x803f56
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 3c 3e 80 00       	push   $0x803e3c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 15 1c 00 00       	call   8024e4 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 73 3f 80 00       	push   $0x803f73
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 3c 3e 80 00       	push   $0x803e3c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 20 40 80 00       	push   $0x804020
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 da 1b 00 00       	call   8024e4 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 72 1c 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 1b 17 00 00       	call   802046 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 00 40 80 00       	push   $0x804000
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 3c 3e 80 00       	push   $0x803e3c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 2d 1c 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 56 3f 80 00       	push   $0x803f56
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 3c 3e 80 00       	push   $0x803e3c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 4f 1b 00 00       	call   8024e4 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 73 3f 80 00       	push   $0x803f73
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 3c 3e 80 00       	push   $0x803e3c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 20 40 80 00       	push   $0x804020
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 14 1b 00 00       	call   8024e4 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 ac 1b 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 5c 16 00 00       	call   802046 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 00 40 80 00       	push   $0x804000
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 3c 3e 80 00       	push   $0x803e3c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 6e 1b 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 56 3f 80 00       	push   $0x803f56
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 3c 3e 80 00       	push   $0x803e3c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 97 1a 00 00       	call   8024e4 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 73 3f 80 00       	push   $0x803f73
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 3c 3e 80 00       	push   $0x803e3c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 20 40 80 00       	push   $0x804020
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 5c 1a 00 00       	call   8024e4 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 f4 1a 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 a7 15 00 00       	call   802046 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 00 40 80 00       	push   $0x804000
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 3c 3e 80 00       	push   $0x803e3c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 b9 1a 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 56 3f 80 00       	push   $0x803f56
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 3c 3e 80 00       	push   $0x803e3c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 e2 19 00 00       	call   8024e4 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 73 3f 80 00       	push   $0x803f73
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 3c 3e 80 00       	push   $0x803e3c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 20 40 80 00       	push   $0x804020
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 a7 19 00 00       	call   8024e4 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 3f 1a 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 14 00 00       	call   802046 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 00 40 80 00       	push   $0x804000
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 3c 3e 80 00       	push   $0x803e3c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 f9 19 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 56 3f 80 00       	push   $0x803f56
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 3c 3e 80 00       	push   $0x803e3c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 1a 19 00 00       	call   8024e4 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 73 3f 80 00       	push   $0x803f73
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 3c 3e 80 00       	push   $0x803e3c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 20 40 80 00       	push   $0x804020
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 df 18 00 00       	call   8024e4 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 77 19 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 27 14 00 00       	call   802046 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 00 40 80 00       	push   $0x804000
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 3c 3e 80 00       	push   $0x803e3c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 3c 19 00 00       	call   802584 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 56 3f 80 00       	push   $0x803f56
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 3c 3e 80 00       	push   $0x803e3c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 7b 18 00 00       	call   8024e4 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 73 3f 80 00       	push   $0x803f73
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 3c 3e 80 00       	push   $0x803e3c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 20 40 80 00       	push   $0x804020
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 34 40 80 00       	push   $0x804034
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 02 1b 00 00       	call   8027c4 <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 a4 18 00 00       	call   8025d1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 88 40 80 00       	push   $0x804088
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 b0 40 80 00       	push   $0x8040b0
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 d8 40 80 00       	push   $0x8040d8
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 30 41 80 00       	push   $0x804130
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 88 40 80 00       	push   $0x804088
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 24 18 00 00       	call   8025eb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 b1 19 00 00       	call   802790 <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 06 1a 00 00       	call   8027f6 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 44 41 80 00       	push   $0x804144
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 49 41 80 00       	push   $0x804149
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 65 41 80 00       	push   $0x804165
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 68 41 80 00       	push   $0x804168
  800e82:	6a 26                	push   $0x26
  800e84:	68 b4 41 80 00       	push   $0x8041b4
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 c0 41 80 00       	push   $0x8041c0
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 b4 41 80 00       	push   $0x8041b4
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 14 42 80 00       	push   $0x804214
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 b4 41 80 00       	push   $0x8041b4
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 05 14 00 00       	call   802423 <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 8e 13 00 00       	call   802423 <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 f2 14 00 00       	call   8025d1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 ec 14 00 00       	call   8025eb <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 63 2a 00 00       	call   803bac <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 23 2b 00 00       	call   803cbc <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 74 44 80 00       	add    $0x804474,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 85 44 80 00       	push   $0x804485
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 8e 44 80 00       	push   $0x80448e
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 f0 45 80 00       	push   $0x8045f0
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801e68:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e6f:	00 00 00 
  801e72:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e79:	00 00 00 
  801e7c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801e83:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801e86:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e8d:	00 00 00 
  801e90:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e97:	00 00 00 
  801e9a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ea1:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801ea4:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	c1 e8 0c             	shr    $0xc,%eax
  801eb1:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801eb6:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ec5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eca:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801ecf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801ed6:	a1 20 51 80 00       	mov    0x805120,%eax
  801edb:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801edf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801ee2:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801ee9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eef:	01 d0                	add    %edx,%eax
  801ef1:	48                   	dec    %eax
  801ef2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  801efd:	f7 75 e4             	divl   -0x1c(%ebp)
  801f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f03:	29 d0                	sub    %edx,%eax
  801f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801f08:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801f0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f17:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	6a 07                	push   $0x7
  801f21:	ff 75 e8             	pushl  -0x18(%ebp)
  801f24:	50                   	push   %eax
  801f25:	e8 3d 06 00 00       	call   802567 <sys_allocate_chunk>
  801f2a:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f2d:	a1 20 51 80 00       	mov    0x805120,%eax
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	50                   	push   %eax
  801f36:	e8 b2 0c 00 00       	call   802bed <initialize_MemBlocksList>
  801f3b:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801f3e:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801f43:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801f46:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f4a:	0f 84 f3 00 00 00    	je     802043 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801f50:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f54:	75 14                	jne    801f6a <initialize_dyn_block_system+0x108>
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	68 15 46 80 00       	push   $0x804615
  801f5e:	6a 36                	push   $0x36
  801f60:	68 33 46 80 00       	push   $0x804633
  801f65:	e8 89 ee ff ff       	call   800df3 <_panic>
  801f6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f6d:	8b 00                	mov    (%eax),%eax
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	74 10                	je     801f83 <initialize_dyn_block_system+0x121>
  801f73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f76:	8b 00                	mov    (%eax),%eax
  801f78:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f7b:	8b 52 04             	mov    0x4(%edx),%edx
  801f7e:	89 50 04             	mov    %edx,0x4(%eax)
  801f81:	eb 0b                	jmp    801f8e <initialize_dyn_block_system+0x12c>
  801f83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f86:	8b 40 04             	mov    0x4(%eax),%eax
  801f89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f91:	8b 40 04             	mov    0x4(%eax),%eax
  801f94:	85 c0                	test   %eax,%eax
  801f96:	74 0f                	je     801fa7 <initialize_dyn_block_system+0x145>
  801f98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f9b:	8b 40 04             	mov    0x4(%eax),%eax
  801f9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fa1:	8b 12                	mov    (%edx),%edx
  801fa3:	89 10                	mov    %edx,(%eax)
  801fa5:	eb 0a                	jmp    801fb1 <initialize_dyn_block_system+0x14f>
  801fa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	a3 48 51 80 00       	mov    %eax,0x805148
  801fb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc4:	a1 54 51 80 00       	mov    0x805154,%eax
  801fc9:	48                   	dec    %eax
  801fca:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801fcf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fd2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801fd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fdc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801fe3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fe7:	75 14                	jne    801ffd <initialize_dyn_block_system+0x19b>
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 40 46 80 00       	push   $0x804640
  801ff1:	6a 3e                	push   $0x3e
  801ff3:	68 33 46 80 00       	push   $0x804633
  801ff8:	e8 f6 ed ff ff       	call   800df3 <_panic>
  801ffd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802003:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802006:	89 10                	mov    %edx,(%eax)
  802008:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80200b:	8b 00                	mov    (%eax),%eax
  80200d:	85 c0                	test   %eax,%eax
  80200f:	74 0d                	je     80201e <initialize_dyn_block_system+0x1bc>
  802011:	a1 38 51 80 00       	mov    0x805138,%eax
  802016:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802019:	89 50 04             	mov    %edx,0x4(%eax)
  80201c:	eb 08                	jmp    802026 <initialize_dyn_block_system+0x1c4>
  80201e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802021:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802026:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802029:	a3 38 51 80 00       	mov    %eax,0x805138
  80202e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802031:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802038:	a1 44 51 80 00       	mov    0x805144,%eax
  80203d:	40                   	inc    %eax
  80203e:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  802043:	90                   	nop
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80204c:	e8 e0 fd ff ff       	call   801e31 <InitializeUHeap>
		if (size == 0) return NULL ;
  802051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802055:	75 07                	jne    80205e <malloc+0x18>
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	eb 7f                	jmp    8020dd <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80205e:	e8 d2 08 00 00       	call   802935 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802063:	85 c0                	test   %eax,%eax
  802065:	74 71                	je     8020d8 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  802067:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80206e:	8b 55 08             	mov    0x8(%ebp),%edx
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	01 d0                	add    %edx,%eax
  802076:	48                   	dec    %eax
  802077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	ba 00 00 00 00       	mov    $0x0,%edx
  802082:	f7 75 f4             	divl   -0xc(%ebp)
  802085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802088:	29 d0                	sub    %edx,%eax
  80208a:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80208d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  802094:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80209b:	76 07                	jbe    8020a4 <malloc+0x5e>
					return NULL ;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb 39                	jmp    8020dd <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	ff 75 08             	pushl  0x8(%ebp)
  8020aa:	e8 e6 0d 00 00       	call   802e95 <alloc_block_FF>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8020b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020b9:	74 16                	je     8020d1 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	ff 75 ec             	pushl  -0x14(%ebp)
  8020c1:	e8 37 0c 00 00       	call   802cfd <insert_sorted_allocList>
  8020c6:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cc:	8b 40 08             	mov    0x8(%eax),%eax
  8020cf:	eb 0c                	jmp    8020dd <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8020d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d6:	eb 05                	jmp    8020dd <malloc+0x97>
				}
		}
	return 0;
  8020d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8020eb:	83 ec 08             	sub    $0x8,%esp
  8020ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f1:	68 40 50 80 00       	push   $0x805040
  8020f6:	e8 cf 0b 00 00       	call   802cca <find_block>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 40 0c             	mov    0xc(%eax),%eax
  802107:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	8b 40 08             	mov    0x8(%eax),%eax
  802110:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  802113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802117:	0f 84 a1 00 00 00    	je     8021be <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80211d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802121:	75 17                	jne    80213a <free+0x5b>
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	68 15 46 80 00       	push   $0x804615
  80212b:	68 80 00 00 00       	push   $0x80
  802130:	68 33 46 80 00       	push   $0x804633
  802135:	e8 b9 ec ff ff       	call   800df3 <_panic>
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	85 c0                	test   %eax,%eax
  802141:	74 10                	je     802153 <free+0x74>
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80214b:	8b 52 04             	mov    0x4(%edx),%edx
  80214e:	89 50 04             	mov    %edx,0x4(%eax)
  802151:	eb 0b                	jmp    80215e <free+0x7f>
  802153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802156:	8b 40 04             	mov    0x4(%eax),%eax
  802159:	a3 44 50 80 00       	mov    %eax,0x805044
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	8b 40 04             	mov    0x4(%eax),%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	74 0f                	je     802177 <free+0x98>
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	8b 40 04             	mov    0x4(%eax),%eax
  80216e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802171:	8b 12                	mov    (%edx),%edx
  802173:	89 10                	mov    %edx,(%eax)
  802175:	eb 0a                	jmp    802181 <free+0xa2>
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217a:	8b 00                	mov    (%eax),%eax
  80217c:	a3 40 50 80 00       	mov    %eax,0x805040
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802194:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802199:	48                   	dec    %eax
  80219a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  80219f:	83 ec 0c             	sub    $0xc,%esp
  8021a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a5:	e8 29 12 00 00       	call   8033d3 <insert_sorted_with_merge_freeList>
  8021aa:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8021b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8021b6:	e8 74 03 00 00       	call   80252f <sys_free_user_mem>
  8021bb:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8021be:	90                   	nop
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 38             	sub    $0x38,%esp
  8021c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ca:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021cd:	e8 5f fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021d6:	75 0a                	jne    8021e2 <smalloc+0x21>
  8021d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dd:	e9 b2 00 00 00       	jmp    802294 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8021e2:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8021e9:	76 0a                	jbe    8021f5 <smalloc+0x34>
		return NULL;
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	e9 9f 00 00 00       	jmp    802294 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8021f5:	e8 3b 07 00 00       	call   802935 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	0f 84 8d 00 00 00    	je     80228f <smalloc+0xce>
	struct MemBlock *b = NULL;
  802202:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  802209:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802210:	8b 55 0c             	mov    0xc(%ebp),%edx
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	01 d0                	add    %edx,%eax
  802218:	48                   	dec    %eax
  802219:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	ba 00 00 00 00       	mov    $0x0,%edx
  802224:	f7 75 f0             	divl   -0x10(%ebp)
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	29 d0                	sub    %edx,%eax
  80222c:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	ff 75 e8             	pushl  -0x18(%ebp)
  802235:	e8 5b 0c 00 00       	call   802e95 <alloc_block_FF>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  802240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802244:	75 07                	jne    80224d <smalloc+0x8c>
			return NULL;
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
  80224b:	eb 47                	jmp    802294 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	ff 75 f4             	pushl  -0xc(%ebp)
  802253:	e8 a5 0a 00 00       	call   802cfd <insert_sorted_allocList>
  802258:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	89 c2                	mov    %eax,%edx
  802263:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	ff 75 08             	pushl  0x8(%ebp)
  80226f:	e8 46 04 00 00       	call   8026ba <sys_createSharedObject>
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80227a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80227e:	78 08                	js     802288 <smalloc+0xc7>
		return (void *)b->sva;
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 08             	mov    0x8(%eax),%eax
  802286:	eb 0c                	jmp    802294 <smalloc+0xd3>
		}else{
		return NULL;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
  80228d:	eb 05                	jmp    802294 <smalloc+0xd3>
			}

	}return NULL;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80229c:	e8 90 fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8022a1:	e8 8f 06 00 00       	call   802935 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	0f 84 ad 00 00 00    	je     80235b <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8022ae:	83 ec 08             	sub    $0x8,%esp
  8022b1:	ff 75 0c             	pushl  0xc(%ebp)
  8022b4:	ff 75 08             	pushl  0x8(%ebp)
  8022b7:	e8 28 04 00 00       	call   8026e4 <sys_getSizeOfSharedObject>
  8022bc:	83 c4 10             	add    $0x10,%esp
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8022c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c6:	79 0a                	jns    8022d2 <sget+0x3c>
    {
    	return NULL;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cd:	e9 8e 00 00 00       	jmp    802360 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8022d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8022d9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	48                   	dec    %eax
  8022e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f4:	f7 75 ec             	divl   -0x14(%ebp)
  8022f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022fa:	29 d0                	sub    %edx,%eax
  8022fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	ff 75 e4             	pushl  -0x1c(%ebp)
  802305:	e8 8b 0b 00 00       	call   802e95 <alloc_block_FF>
  80230a:	83 c4 10             	add    $0x10,%esp
  80230d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802314:	75 07                	jne    80231d <sget+0x87>
				return NULL;
  802316:	b8 00 00 00 00       	mov    $0x0,%eax
  80231b:	eb 43                	jmp    802360 <sget+0xca>
			}
			insert_sorted_allocList(b);
  80231d:	83 ec 0c             	sub    $0xc,%esp
  802320:	ff 75 f0             	pushl  -0x10(%ebp)
  802323:	e8 d5 09 00 00       	call   802cfd <insert_sorted_allocList>
  802328:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 40 08             	mov    0x8(%eax),%eax
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	50                   	push   %eax
  802335:	ff 75 0c             	pushl  0xc(%ebp)
  802338:	ff 75 08             	pushl  0x8(%ebp)
  80233b:	e8 c1 03 00 00       	call   802701 <sys_getSharedObject>
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802346:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80234a:	78 08                	js     802354 <sget+0xbe>
			return (void *)b->sva;
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	8b 40 08             	mov    0x8(%eax),%eax
  802352:	eb 0c                	jmp    802360 <sget+0xca>
			}else{
			return NULL;
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	eb 05                	jmp    802360 <sget+0xca>
			}
    }}return NULL;
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802368:	e8 c4 fa ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	68 64 46 80 00       	push   $0x804664
  802375:	68 03 01 00 00       	push   $0x103
  80237a:	68 33 46 80 00       	push   $0x804633
  80237f:	e8 6f ea ff ff       	call   800df3 <_panic>

00802384 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	68 8c 46 80 00       	push   $0x80468c
  802392:	68 17 01 00 00       	push   $0x117
  802397:	68 33 46 80 00       	push   $0x804633
  80239c:	e8 52 ea ff ff       	call   800df3 <_panic>

008023a1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	68 b0 46 80 00       	push   $0x8046b0
  8023af:	68 22 01 00 00       	push   $0x122
  8023b4:	68 33 46 80 00       	push   $0x804633
  8023b9:	e8 35 ea ff ff       	call   800df3 <_panic>

008023be <shrink>:

}
void shrink(uint32 newSize)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023c4:	83 ec 04             	sub    $0x4,%esp
  8023c7:	68 b0 46 80 00       	push   $0x8046b0
  8023cc:	68 27 01 00 00       	push   $0x127
  8023d1:	68 33 46 80 00       	push   $0x804633
  8023d6:	e8 18 ea ff ff       	call   800df3 <_panic>

008023db <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023e1:	83 ec 04             	sub    $0x4,%esp
  8023e4:	68 b0 46 80 00       	push   $0x8046b0
  8023e9:	68 2c 01 00 00       	push   $0x12c
  8023ee:	68 33 46 80 00       	push   $0x804633
  8023f3:	e8 fb e9 ff ff       	call   800df3 <_panic>

008023f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	57                   	push   %edi
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 55 0c             	mov    0xc(%ebp),%edx
  802407:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802410:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802413:	cd 30                	int    $0x30
  802415:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	5b                   	pop    %ebx
  80241f:	5e                   	pop    %esi
  802420:	5f                   	pop    %edi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 04             	sub    $0x4,%esp
  802429:	8b 45 10             	mov    0x10(%ebp),%eax
  80242c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80242f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	52                   	push   %edx
  80243b:	ff 75 0c             	pushl  0xc(%ebp)
  80243e:	50                   	push   %eax
  80243f:	6a 00                	push   $0x0
  802441:	e8 b2 ff ff ff       	call   8023f8 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	90                   	nop
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_cgetc>:

int
sys_cgetc(void)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 01                	push   $0x1
  80245b:	e8 98 ff ff ff       	call   8023f8 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	52                   	push   %edx
  802475:	50                   	push   %eax
  802476:	6a 05                	push   $0x5
  802478:	e8 7b ff ff ff       	call   8023f8 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	56                   	push   %esi
  802486:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802487:	8b 75 18             	mov    0x18(%ebp),%esi
  80248a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80248d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802490:	8b 55 0c             	mov    0xc(%ebp),%edx
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	51                   	push   %ecx
  802499:	52                   	push   %edx
  80249a:	50                   	push   %eax
  80249b:	6a 06                	push   $0x6
  80249d:	e8 56 ff ff ff       	call   8023f8 <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
}
  8024a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024a8:	5b                   	pop    %ebx
  8024a9:	5e                   	pop    %esi
  8024aa:	5d                   	pop    %ebp
  8024ab:	c3                   	ret    

008024ac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	52                   	push   %edx
  8024bc:	50                   	push   %eax
  8024bd:	6a 07                	push   $0x7
  8024bf:	e8 34 ff ff ff       	call   8023f8 <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	ff 75 0c             	pushl  0xc(%ebp)
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	6a 08                	push   $0x8
  8024da:	e8 19 ff ff ff       	call   8023f8 <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 09                	push   $0x9
  8024f3:	e8 00 ff ff ff       	call   8023f8 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 0a                	push   $0xa
  80250c:	e8 e7 fe ff ff       	call   8023f8 <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 0b                	push   $0xb
  802525:	e8 ce fe ff ff       	call   8023f8 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	ff 75 0c             	pushl  0xc(%ebp)
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	6a 0f                	push   $0xf
  802540:	e8 b3 fe ff ff       	call   8023f8 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	ff 75 0c             	pushl  0xc(%ebp)
  802557:	ff 75 08             	pushl  0x8(%ebp)
  80255a:	6a 10                	push   $0x10
  80255c:	e8 97 fe ff ff       	call   8023f8 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
	return ;
  802564:	90                   	nop
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	ff 75 10             	pushl  0x10(%ebp)
  802571:	ff 75 0c             	pushl  0xc(%ebp)
  802574:	ff 75 08             	pushl  0x8(%ebp)
  802577:	6a 11                	push   $0x11
  802579:	e8 7a fe ff ff       	call   8023f8 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
	return ;
  802581:	90                   	nop
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 0c                	push   $0xc
  802593:	e8 60 fe ff ff       	call   8023f8 <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	ff 75 08             	pushl  0x8(%ebp)
  8025ab:	6a 0d                	push   $0xd
  8025ad:	e8 46 fe ff ff       	call   8023f8 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 0e                	push   $0xe
  8025c6:	e8 2d fe ff ff       	call   8023f8 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	90                   	nop
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 13                	push   $0x13
  8025e0:	e8 13 fe ff ff       	call   8023f8 <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	90                   	nop
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 14                	push   $0x14
  8025fa:	e8 f9 fd ff ff       	call   8023f8 <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
}
  802602:	90                   	nop
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_cputc>:


void
sys_cputc(const char c)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802611:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	50                   	push   %eax
  80261e:	6a 15                	push   $0x15
  802620:	e8 d3 fd ff ff       	call   8023f8 <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
}
  802628:	90                   	nop
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 16                	push   $0x16
  80263a:	e8 b9 fd ff ff       	call   8023f8 <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
}
  802642:	90                   	nop
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	ff 75 0c             	pushl  0xc(%ebp)
  802654:	50                   	push   %eax
  802655:	6a 17                	push   $0x17
  802657:	e8 9c fd ff ff       	call   8023f8 <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802664:	8b 55 0c             	mov    0xc(%ebp),%edx
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	52                   	push   %edx
  802671:	50                   	push   %eax
  802672:	6a 1a                	push   $0x1a
  802674:	e8 7f fd ff ff       	call   8023f8 <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802681:	8b 55 0c             	mov    0xc(%ebp),%edx
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	52                   	push   %edx
  80268e:	50                   	push   %eax
  80268f:	6a 18                	push   $0x18
  802691:	e8 62 fd ff ff       	call   8023f8 <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
}
  802699:	90                   	nop
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80269f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	52                   	push   %edx
  8026ac:	50                   	push   %eax
  8026ad:	6a 19                	push   $0x19
  8026af:	e8 44 fd ff ff       	call   8023f8 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
}
  8026b7:	90                   	nop
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	51                   	push   %ecx
  8026d3:	52                   	push   %edx
  8026d4:	ff 75 0c             	pushl  0xc(%ebp)
  8026d7:	50                   	push   %eax
  8026d8:	6a 1b                	push   $0x1b
  8026da:	e8 19 fd ff ff       	call   8023f8 <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8026e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	52                   	push   %edx
  8026f4:	50                   	push   %eax
  8026f5:	6a 1c                	push   $0x1c
  8026f7:	e8 fc fc ff ff       	call   8023f8 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802704:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	51                   	push   %ecx
  802712:	52                   	push   %edx
  802713:	50                   	push   %eax
  802714:	6a 1d                	push   $0x1d
  802716:	e8 dd fc ff ff       	call   8023f8 <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802723:	8b 55 0c             	mov    0xc(%ebp),%edx
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	52                   	push   %edx
  802730:	50                   	push   %eax
  802731:	6a 1e                	push   $0x1e
  802733:	e8 c0 fc ff ff       	call   8023f8 <syscall>
  802738:	83 c4 18             	add    $0x18,%esp
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80273d:	55                   	push   %ebp
  80273e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 1f                	push   $0x1f
  80274c:	e8 a7 fc ff ff       	call   8023f8 <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
}
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	6a 00                	push   $0x0
  80275e:	ff 75 14             	pushl  0x14(%ebp)
  802761:	ff 75 10             	pushl  0x10(%ebp)
  802764:	ff 75 0c             	pushl  0xc(%ebp)
  802767:	50                   	push   %eax
  802768:	6a 20                	push   $0x20
  80276a:	e8 89 fc ff ff       	call   8023f8 <syscall>
  80276f:	83 c4 18             	add    $0x18,%esp
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	50                   	push   %eax
  802783:	6a 21                	push   $0x21
  802785:	e8 6e fc ff ff       	call   8023f8 <syscall>
  80278a:	83 c4 18             	add    $0x18,%esp
}
  80278d:	90                   	nop
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	50                   	push   %eax
  80279f:	6a 22                	push   $0x22
  8027a1:	e8 52 fc ff ff       	call   8023f8 <syscall>
  8027a6:	83 c4 18             	add    $0x18,%esp
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 02                	push   $0x2
  8027ba:	e8 39 fc ff ff       	call   8023f8 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 03                	push   $0x3
  8027d3:	e8 20 fc ff ff       	call   8023f8 <syscall>
  8027d8:	83 c4 18             	add    $0x18,%esp
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 04                	push   $0x4
  8027ec:	e8 07 fc ff ff       	call   8023f8 <syscall>
  8027f1:	83 c4 18             	add    $0x18,%esp
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 23                	push   $0x23
  802805:	e8 ee fb ff ff       	call   8023f8 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
}
  80280d:	90                   	nop
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802816:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802819:	8d 50 04             	lea    0x4(%eax),%edx
  80281c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	52                   	push   %edx
  802826:	50                   	push   %eax
  802827:	6a 24                	push   $0x24
  802829:	e8 ca fb ff ff       	call   8023f8 <syscall>
  80282e:	83 c4 18             	add    $0x18,%esp
	return result;
  802831:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802834:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802837:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80283a:	89 01                	mov    %eax,(%ecx)
  80283c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	c9                   	leave  
  802843:	c2 04 00             	ret    $0x4

00802846 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	ff 75 10             	pushl  0x10(%ebp)
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	6a 12                	push   $0x12
  802858:	e8 9b fb ff ff       	call   8023f8 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
	return ;
  802860:	90                   	nop
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <sys_rcr2>:
uint32 sys_rcr2()
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 25                	push   $0x25
  802872:	e8 81 fb ff ff       	call   8023f8 <syscall>
  802877:	83 c4 18             	add    $0x18,%esp
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802888:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	50                   	push   %eax
  802895:	6a 26                	push   $0x26
  802897:	e8 5c fb ff ff       	call   8023f8 <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
	return ;
  80289f:	90                   	nop
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <rsttst>:
void rsttst()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 28                	push   $0x28
  8028b1:	e8 42 fb ff ff       	call   8023f8 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b9:	90                   	nop
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8028cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028cf:	52                   	push   %edx
  8028d0:	50                   	push   %eax
  8028d1:	ff 75 10             	pushl  0x10(%ebp)
  8028d4:	ff 75 0c             	pushl  0xc(%ebp)
  8028d7:	ff 75 08             	pushl  0x8(%ebp)
  8028da:	6a 27                	push   $0x27
  8028dc:	e8 17 fb ff ff       	call   8023f8 <syscall>
  8028e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e4:	90                   	nop
}
  8028e5:	c9                   	leave  
  8028e6:	c3                   	ret    

008028e7 <chktst>:
void chktst(uint32 n)
{
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	ff 75 08             	pushl  0x8(%ebp)
  8028f5:	6a 29                	push   $0x29
  8028f7:	e8 fc fa ff ff       	call   8023f8 <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ff:	90                   	nop
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <inctst>:

void inctst()
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 2a                	push   $0x2a
  802911:	e8 e2 fa ff ff       	call   8023f8 <syscall>
  802916:	83 c4 18             	add    $0x18,%esp
	return ;
  802919:	90                   	nop
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <gettst>:
uint32 gettst()
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 2b                	push   $0x2b
  80292b:	e8 c8 fa ff ff       	call   8023f8 <syscall>
  802930:	83 c4 18             	add    $0x18,%esp
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 2c                	push   $0x2c
  802947:	e8 ac fa ff ff       	call   8023f8 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
  80294f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802952:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802956:	75 07                	jne    80295f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802958:	b8 01 00 00 00       	mov    $0x1,%eax
  80295d:	eb 05                	jmp    802964 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 2c                	push   $0x2c
  802978:	e8 7b fa ff ff       	call   8023f8 <syscall>
  80297d:	83 c4 18             	add    $0x18,%esp
  802980:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802983:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802987:	75 07                	jne    802990 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802989:	b8 01 00 00 00       	mov    $0x1,%eax
  80298e:	eb 05                	jmp    802995 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802990:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 2c                	push   $0x2c
  8029a9:	e8 4a fa ff ff       	call   8023f8 <syscall>
  8029ae:	83 c4 18             	add    $0x18,%esp
  8029b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029b8:	75 07                	jne    8029c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bf:	eb 05                	jmp    8029c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 2c                	push   $0x2c
  8029da:	e8 19 fa ff ff       	call   8023f8 <syscall>
  8029df:	83 c4 18             	add    $0x18,%esp
  8029e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029e9:	75 07                	jne    8029f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f0:	eb 05                	jmp    8029f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	ff 75 08             	pushl  0x8(%ebp)
  802a07:	6a 2d                	push   $0x2d
  802a09:	e8 ea f9 ff ff       	call   8023f8 <syscall>
  802a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a11:	90                   	nop
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	6a 00                	push   $0x0
  802a26:	53                   	push   %ebx
  802a27:	51                   	push   %ecx
  802a28:	52                   	push   %edx
  802a29:	50                   	push   %eax
  802a2a:	6a 2e                	push   $0x2e
  802a2c:	e8 c7 f9 ff ff       	call   8023f8 <syscall>
  802a31:	83 c4 18             	add    $0x18,%esp
}
  802a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	52                   	push   %edx
  802a49:	50                   	push   %eax
  802a4a:	6a 2f                	push   $0x2f
  802a4c:	e8 a7 f9 ff ff       	call   8023f8 <syscall>
  802a51:	83 c4 18             	add    $0x18,%esp
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	68 c0 46 80 00       	push   $0x8046c0
  802a64:	e8 3e e6 ff ff       	call   8010a7 <cprintf>
  802a69:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802a6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802a73:	83 ec 0c             	sub    $0xc,%esp
  802a76:	68 ec 46 80 00       	push   $0x8046ec
  802a7b:	e8 27 e6 ff ff       	call   8010a7 <cprintf>
  802a80:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802a83:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a87:	a1 38 51 80 00       	mov    0x805138,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	eb 56                	jmp    802ae7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a95:	74 1c                	je     802ab3 <print_mem_block_lists+0x5d>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 50 08             	mov    0x8(%eax),%edx
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 48 08             	mov    0x8(%eax),%ecx
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa9:	01 c8                	add    %ecx,%eax
  802aab:	39 c2                	cmp    %eax,%edx
  802aad:	73 04                	jae    802ab3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802aaf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 50 08             	mov    0x8(%eax),%edx
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	01 c2                	add    %eax,%edx
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 08             	mov    0x8(%eax),%eax
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	52                   	push   %edx
  802acb:	50                   	push   %eax
  802acc:	68 01 47 80 00       	push   $0x804701
  802ad1:	e8 d1 e5 ff ff       	call   8010a7 <cprintf>
  802ad6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802adf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aeb:	74 07                	je     802af4 <print_mem_block_lists+0x9e>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	eb 05                	jmp    802af9 <print_mem_block_lists+0xa3>
  802af4:	b8 00 00 00 00       	mov    $0x0,%eax
  802af9:	a3 40 51 80 00       	mov    %eax,0x805140
  802afe:	a1 40 51 80 00       	mov    0x805140,%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	75 8a                	jne    802a91 <print_mem_block_lists+0x3b>
  802b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0b:	75 84                	jne    802a91 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b0d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b11:	75 10                	jne    802b23 <print_mem_block_lists+0xcd>
  802b13:	83 ec 0c             	sub    $0xc,%esp
  802b16:	68 10 47 80 00       	push   $0x804710
  802b1b:	e8 87 e5 ff ff       	call   8010a7 <cprintf>
  802b20:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b2a:	83 ec 0c             	sub    $0xc,%esp
  802b2d:	68 34 47 80 00       	push   $0x804734
  802b32:	e8 70 e5 ff ff       	call   8010a7 <cprintf>
  802b37:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b3a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b3e:	a1 40 50 80 00       	mov    0x805040,%eax
  802b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b46:	eb 56                	jmp    802b9e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4c:	74 1c                	je     802b6a <print_mem_block_lists+0x114>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 50 08             	mov    0x8(%eax),%edx
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 48 08             	mov    0x8(%eax),%ecx
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	01 c8                	add    %ecx,%eax
  802b62:	39 c2                	cmp    %eax,%edx
  802b64:	73 04                	jae    802b6a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802b66:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 50 08             	mov    0x8(%eax),%edx
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	01 c2                	add    %eax,%edx
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	52                   	push   %edx
  802b82:	50                   	push   %eax
  802b83:	68 01 47 80 00       	push   $0x804701
  802b88:	e8 1a e5 ff ff       	call   8010a7 <cprintf>
  802b8d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b96:	a1 48 50 80 00       	mov    0x805048,%eax
  802b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba2:	74 07                	je     802bab <print_mem_block_lists+0x155>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	eb 05                	jmp    802bb0 <print_mem_block_lists+0x15a>
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	a3 48 50 80 00       	mov    %eax,0x805048
  802bb5:	a1 48 50 80 00       	mov    0x805048,%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	75 8a                	jne    802b48 <print_mem_block_lists+0xf2>
  802bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc2:	75 84                	jne    802b48 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802bc4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bc8:	75 10                	jne    802bda <print_mem_block_lists+0x184>
  802bca:	83 ec 0c             	sub    $0xc,%esp
  802bcd:	68 4c 47 80 00       	push   $0x80474c
  802bd2:	e8 d0 e4 ff ff       	call   8010a7 <cprintf>
  802bd7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802bda:	83 ec 0c             	sub    $0xc,%esp
  802bdd:	68 c0 46 80 00       	push   $0x8046c0
  802be2:	e8 c0 e4 ff ff       	call   8010a7 <cprintf>
  802be7:	83 c4 10             	add    $0x10,%esp

}
  802bea:	90                   	nop
  802beb:	c9                   	leave  
  802bec:	c3                   	ret    

00802bed <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802bed:	55                   	push   %ebp
  802bee:	89 e5                	mov    %esp,%ebp
  802bf0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802bf3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802bfa:	00 00 00 
  802bfd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c04:	00 00 00 
  802c07:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802c0e:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802c11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c18:	e9 9e 00 00 00       	jmp    802cbb <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802c1d:	a1 50 50 80 00       	mov    0x805050,%eax
  802c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c25:	c1 e2 04             	shl    $0x4,%edx
  802c28:	01 d0                	add    %edx,%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	75 14                	jne    802c42 <initialize_MemBlocksList+0x55>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 74 47 80 00       	push   $0x804774
  802c36:	6a 3d                	push   $0x3d
  802c38:	68 97 47 80 00       	push   $0x804797
  802c3d:	e8 b1 e1 ff ff       	call   800df3 <_panic>
  802c42:	a1 50 50 80 00       	mov    0x805050,%eax
  802c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4a:	c1 e2 04             	shl    $0x4,%edx
  802c4d:	01 d0                	add    %edx,%eax
  802c4f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c55:	89 10                	mov    %edx,(%eax)
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 18                	je     802c75 <initialize_MemBlocksList+0x88>
  802c5d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c62:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802c68:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802c6b:	c1 e1 04             	shl    $0x4,%ecx
  802c6e:	01 ca                	add    %ecx,%edx
  802c70:	89 50 04             	mov    %edx,0x4(%eax)
  802c73:	eb 12                	jmp    802c87 <initialize_MemBlocksList+0x9a>
  802c75:	a1 50 50 80 00       	mov    0x805050,%eax
  802c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7d:	c1 e2 04             	shl    $0x4,%edx
  802c80:	01 d0                	add    %edx,%eax
  802c82:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c87:	a1 50 50 80 00       	mov    0x805050,%eax
  802c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8f:	c1 e2 04             	shl    $0x4,%edx
  802c92:	01 d0                	add    %edx,%eax
  802c94:	a3 48 51 80 00       	mov    %eax,0x805148
  802c99:	a1 50 50 80 00       	mov    0x805050,%eax
  802c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca1:	c1 e2 04             	shl    $0x4,%edx
  802ca4:	01 d0                	add    %edx,%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 54 51 80 00       	mov    0x805154,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802cb8:	ff 45 f4             	incl   -0xc(%ebp)
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc1:	0f 82 56 ff ff ff    	jb     802c1d <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802cc7:	90                   	nop
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 00                	mov    (%eax),%eax
  802cd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802cd8:	eb 18                	jmp    802cf2 <find_block+0x28>

		if(tmp->sva == va){
  802cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce3:	75 05                	jne    802cea <find_block+0x20>
			return tmp ;
  802ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ce8:	eb 11                	jmp    802cfb <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802cf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802cf6:	75 e2                	jne    802cda <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802cfb:	c9                   	leave  
  802cfc:	c3                   	ret    

00802cfd <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
  802d00:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802d03:	a1 40 50 80 00       	mov    0x805040,%eax
  802d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802d0b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d17:	75 65                	jne    802d7e <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802d19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1d:	75 14                	jne    802d33 <insert_sorted_allocList+0x36>
  802d1f:	83 ec 04             	sub    $0x4,%esp
  802d22:	68 74 47 80 00       	push   $0x804774
  802d27:	6a 62                	push   $0x62
  802d29:	68 97 47 80 00       	push   $0x804797
  802d2e:	e8 c0 e0 ff ff       	call   800df3 <_panic>
  802d33:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	89 10                	mov    %edx,(%eax)
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	74 0d                	je     802d54 <insert_sorted_allocList+0x57>
  802d47:	a1 40 50 80 00       	mov    0x805040,%eax
  802d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4f:	89 50 04             	mov    %edx,0x4(%eax)
  802d52:	eb 08                	jmp    802d5c <insert_sorted_allocList+0x5f>
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	a3 44 50 80 00       	mov    %eax,0x805044
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	a3 40 50 80 00       	mov    %eax,0x805040
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d73:	40                   	inc    %eax
  802d74:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d79:	e9 14 01 00 00       	jmp    802e92 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	a1 44 50 80 00       	mov    0x805044,%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	39 c2                	cmp    %eax,%edx
  802d8e:	76 65                	jbe    802df5 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d94:	75 14                	jne    802daa <insert_sorted_allocList+0xad>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 b0 47 80 00       	push   $0x8047b0
  802d9e:	6a 64                	push   $0x64
  802da0:	68 97 47 80 00       	push   $0x804797
  802da5:	e8 49 e0 ff ff       	call   800df3 <_panic>
  802daa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 0c                	je     802dcc <insert_sorted_allocList+0xcf>
  802dc0:	a1 44 50 80 00       	mov    0x805044,%eax
  802dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	eb 08                	jmp    802dd4 <insert_sorted_allocList+0xd7>
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	a3 40 50 80 00       	mov    %eax,0x805040
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 44 50 80 00       	mov    %eax,0x805044
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dea:	40                   	inc    %eax
  802deb:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802df0:	e9 9d 00 00 00       	jmp    802e92 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802df5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802dfc:	e9 85 00 00 00       	jmp    802e86 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 50 08             	mov    0x8(%eax),%edx
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 08             	mov    0x8(%eax),%eax
  802e0d:	39 c2                	cmp    %eax,%edx
  802e0f:	73 6a                	jae    802e7b <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e15:	74 06                	je     802e1d <insert_sorted_allocList+0x120>
  802e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1b:	75 14                	jne    802e31 <insert_sorted_allocList+0x134>
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	68 d4 47 80 00       	push   $0x8047d4
  802e25:	6a 6b                	push   $0x6b
  802e27:	68 97 47 80 00       	push   $0x804797
  802e2c:	e8 c2 df ff ff       	call   800df3 <_panic>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 50 04             	mov    0x4(%eax),%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	89 50 04             	mov    %edx,0x4(%eax)
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_allocList+0x15f>
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_allocList+0x167>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 40 50 80 00       	mov    %eax,0x805040
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e72:	40                   	inc    %eax
  802e73:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802e78:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802e79:	eb 17                	jmp    802e92 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802e83:	ff 45 f0             	incl   -0x10(%ebp)
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e8c:	0f 8c 6f ff ff ff    	jl     802e01 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802e92:	90                   	nop
  802e93:	c9                   	leave  
  802e94:	c3                   	ret    

00802e95 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e95:	55                   	push   %ebp
  802e96:	89 e5                	mov    %esp,%ebp
  802e98:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802e9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802ea3:	e9 7c 01 00 00       	jmp    803024 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb1:	0f 86 cf 00 00 00    	jbe    802f86 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802eb7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec2:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 50 08             	mov    0x8(%eax),%edx
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee3:	89 c2                	mov    %eax,%edx
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 50 08             	mov    0x8(%eax),%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802efc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f00:	75 17                	jne    802f19 <alloc_block_FF+0x84>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 09 48 80 00       	push   $0x804809
  802f0a:	68 83 00 00 00       	push   $0x83
  802f0f:	68 97 47 80 00       	push   $0x804797
  802f14:	e8 da de ff ff       	call   800df3 <_panic>
  802f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 10                	je     802f32 <alloc_block_FF+0x9d>
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2a:	8b 52 04             	mov    0x4(%edx),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 0b                	jmp    802f3d <alloc_block_FF+0xa8>
  802f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0f                	je     802f56 <alloc_block_FF+0xc1>
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f50:	8b 12                	mov    (%edx),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	eb 0a                	jmp    802f60 <alloc_block_FF+0xcb>
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f73:	a1 54 51 80 00       	mov    0x805154,%eax
  802f78:	48                   	dec    %eax
  802f79:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f81:	e9 ad 00 00 00       	jmp    803033 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8f:	0f 85 87 00 00 00    	jne    80301c <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f99:	75 17                	jne    802fb2 <alloc_block_FF+0x11d>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 09 48 80 00       	push   $0x804809
  802fa3:	68 87 00 00 00       	push   $0x87
  802fa8:	68 97 47 80 00       	push   $0x804797
  802fad:	e8 41 de ff ff       	call   800df3 <_panic>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 10                	je     802fcb <alloc_block_FF+0x136>
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc3:	8b 52 04             	mov    0x4(%edx),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 0b                	jmp    802fd6 <alloc_block_FF+0x141>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0f                	je     802fef <alloc_block_FF+0x15a>
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe9:	8b 12                	mov    (%edx),%edx
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	eb 0a                	jmp    802ff9 <alloc_block_FF+0x164>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300c:	a1 44 51 80 00       	mov    0x805144,%eax
  803011:	48                   	dec    %eax
  803012:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	eb 17                	jmp    803033 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  803024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803028:	0f 85 7a fe ff ff    	jne    802ea8 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80302e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80303b:	a1 38 51 80 00       	mov    0x805138,%eax
  803040:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  803043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80304a:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  803051:	a1 38 51 80 00       	mov    0x805138,%eax
  803056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803059:	e9 d0 00 00 00       	jmp    80312e <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	3b 45 08             	cmp    0x8(%ebp),%eax
  803067:	0f 82 b8 00 00 00    	jb     803125 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 40 0c             	mov    0xc(%eax),%eax
  803073:	2b 45 08             	sub    0x8(%ebp),%eax
  803076:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  803079:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80307f:	0f 83 a1 00 00 00    	jae    803126 <alloc_block_BF+0xf1>
				differsize = differance ;
  803085:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803088:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  803091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803095:	0f 85 8b 00 00 00    	jne    803126 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80309b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309f:	75 17                	jne    8030b8 <alloc_block_BF+0x83>
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 09 48 80 00       	push   $0x804809
  8030a9:	68 a0 00 00 00       	push   $0xa0
  8030ae:	68 97 47 80 00       	push   $0x804797
  8030b3:	e8 3b dd ff ff       	call   800df3 <_panic>
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 10                	je     8030d1 <alloc_block_BF+0x9c>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c9:	8b 52 04             	mov    0x4(%edx),%edx
  8030cc:	89 50 04             	mov    %edx,0x4(%eax)
  8030cf:	eb 0b                	jmp    8030dc <alloc_block_BF+0xa7>
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	8b 40 04             	mov    0x4(%eax),%eax
  8030d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0f                	je     8030f5 <alloc_block_BF+0xc0>
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ef:	8b 12                	mov    (%edx),%edx
  8030f1:	89 10                	mov    %edx,(%eax)
  8030f3:	eb 0a                	jmp    8030ff <alloc_block_BF+0xca>
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803112:	a1 44 51 80 00       	mov    0x805144,%eax
  803117:	48                   	dec    %eax
  803118:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	e9 0c 01 00 00       	jmp    803231 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  803125:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  803126:	a1 40 51 80 00       	mov    0x805140,%eax
  80312b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803132:	74 07                	je     80313b <alloc_block_BF+0x106>
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	eb 05                	jmp    803140 <alloc_block_BF+0x10b>
  80313b:	b8 00 00 00 00       	mov    $0x0,%eax
  803140:	a3 40 51 80 00       	mov    %eax,0x805140
  803145:	a1 40 51 80 00       	mov    0x805140,%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	0f 85 0c ff ff ff    	jne    80305e <alloc_block_BF+0x29>
  803152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803156:	0f 85 02 ff ff ff    	jne    80305e <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80315c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803160:	0f 84 c6 00 00 00    	je     80322c <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  803166:	a1 48 51 80 00       	mov    0x805148,%eax
  80316b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80316e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803171:	8b 55 08             	mov    0x8(%ebp),%edx
  803174:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	2b 45 08             	sub    0x8(%ebp),%eax
  80318c:	89 c2                	mov    %eax,%edx
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803197:	8b 50 08             	mov    0x8(%eax),%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	01 c2                	add    %eax,%edx
  80319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a2:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8031a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a9:	75 17                	jne    8031c2 <alloc_block_BF+0x18d>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 09 48 80 00       	push   $0x804809
  8031b3:	68 af 00 00 00       	push   $0xaf
  8031b8:	68 97 47 80 00       	push   $0x804797
  8031bd:	e8 31 dc ff ff       	call   800df3 <_panic>
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 10                	je     8031db <alloc_block_BF+0x1a6>
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d3:	8b 52 04             	mov    0x4(%edx),%edx
  8031d6:	89 50 04             	mov    %edx,0x4(%eax)
  8031d9:	eb 0b                	jmp    8031e6 <alloc_block_BF+0x1b1>
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	74 0f                	je     8031ff <alloc_block_BF+0x1ca>
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f9:	8b 12                	mov    (%edx),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	eb 0a                	jmp    803209 <alloc_block_BF+0x1d4>
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	a3 48 51 80 00       	mov    %eax,0x805148
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321c:	a1 54 51 80 00       	mov    0x805154,%eax
  803221:	48                   	dec    %eax
  803222:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	eb 05                	jmp    803231 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80322c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803231:	c9                   	leave  
  803232:	c3                   	ret    

00803233 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  803233:	55                   	push   %ebp
  803234:	89 e5                	mov    %esp,%ebp
  803236:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  803239:	a1 38 51 80 00       	mov    0x805138,%eax
  80323e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  803241:	e9 7c 01 00 00       	jmp    8033c2 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 40 0c             	mov    0xc(%eax),%eax
  80324c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324f:	0f 86 cf 00 00 00    	jbe    803324 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  803255:	a1 48 51 80 00       	mov    0x805148,%eax
  80325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	8b 55 08             	mov    0x8(%ebp),%edx
  803269:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 50 08             	mov    0x8(%eax),%edx
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 40 0c             	mov    0xc(%eax),%eax
  80327e:	2b 45 08             	sub    0x8(%ebp),%eax
  803281:	89 c2                	mov    %eax,%edx
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	8b 50 08             	mov    0x8(%eax),%edx
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	01 c2                	add    %eax,%edx
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80329a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329e:	75 17                	jne    8032b7 <alloc_block_NF+0x84>
  8032a0:	83 ec 04             	sub    $0x4,%esp
  8032a3:	68 09 48 80 00       	push   $0x804809
  8032a8:	68 c4 00 00 00       	push   $0xc4
  8032ad:	68 97 47 80 00       	push   $0x804797
  8032b2:	e8 3c db ff ff       	call   800df3 <_panic>
  8032b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	74 10                	je     8032d0 <alloc_block_NF+0x9d>
  8032c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c8:	8b 52 04             	mov    0x4(%edx),%edx
  8032cb:	89 50 04             	mov    %edx,0x4(%eax)
  8032ce:	eb 0b                	jmp    8032db <alloc_block_NF+0xa8>
  8032d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	8b 40 04             	mov    0x4(%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	74 0f                	je     8032f4 <alloc_block_NF+0xc1>
  8032e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e8:	8b 40 04             	mov    0x4(%eax),%eax
  8032eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ee:	8b 12                	mov    (%edx),%edx
  8032f0:	89 10                	mov    %edx,(%eax)
  8032f2:	eb 0a                	jmp    8032fe <alloc_block_NF+0xcb>
  8032f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803311:	a1 54 51 80 00       	mov    0x805154,%eax
  803316:	48                   	dec    %eax
  803317:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  80331c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331f:	e9 ad 00 00 00       	jmp    8033d1 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332d:	0f 85 87 00 00 00    	jne    8033ba <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803337:	75 17                	jne    803350 <alloc_block_NF+0x11d>
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	68 09 48 80 00       	push   $0x804809
  803341:	68 c8 00 00 00       	push   $0xc8
  803346:	68 97 47 80 00       	push   $0x804797
  80334b:	e8 a3 da ff ff       	call   800df3 <_panic>
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	8b 00                	mov    (%eax),%eax
  803355:	85 c0                	test   %eax,%eax
  803357:	74 10                	je     803369 <alloc_block_NF+0x136>
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803361:	8b 52 04             	mov    0x4(%edx),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	eb 0b                	jmp    803374 <alloc_block_NF+0x141>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	74 0f                	je     80338d <alloc_block_NF+0x15a>
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 40 04             	mov    0x4(%eax),%eax
  803384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803387:	8b 12                	mov    (%edx),%edx
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	eb 0a                	jmp    803397 <alloc_block_NF+0x164>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	a3 38 51 80 00       	mov    %eax,0x805138
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033af:	48                   	dec    %eax
  8033b0:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	eb 17                	jmp    8033d1 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8033c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c6:	0f 85 7a fe ff ff    	jne    803246 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8033cc:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8033d1:	c9                   	leave  
  8033d2:	c3                   	ret    

008033d3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033d3:	55                   	push   %ebp
  8033d4:	89 e5                	mov    %esp,%ebp
  8033d6:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8033d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8033de:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8033e1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8033e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8033f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033f5:	75 68                	jne    80345f <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8033f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fb:	75 17                	jne    803414 <insert_sorted_with_merge_freeList+0x41>
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	68 74 47 80 00       	push   $0x804774
  803405:	68 da 00 00 00       	push   $0xda
  80340a:	68 97 47 80 00       	push   $0x804797
  80340f:	e8 df d9 ff ff       	call   800df3 <_panic>
  803414:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	89 10                	mov    %edx,(%eax)
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 0d                	je     803435 <insert_sorted_with_merge_freeList+0x62>
  803428:	a1 38 51 80 00       	mov    0x805138,%eax
  80342d:	8b 55 08             	mov    0x8(%ebp),%edx
  803430:	89 50 04             	mov    %edx,0x4(%eax)
  803433:	eb 08                	jmp    80343d <insert_sorted_with_merge_freeList+0x6a>
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	a3 38 51 80 00       	mov    %eax,0x805138
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344f:	a1 44 51 80 00       	mov    0x805144,%eax
  803454:	40                   	inc    %eax
  803455:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80345a:	e9 49 07 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	8b 50 08             	mov    0x8(%eax),%edx
  803465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803468:	8b 40 0c             	mov    0xc(%eax),%eax
  80346b:	01 c2                	add    %eax,%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 40 08             	mov    0x8(%eax),%eax
  803473:	39 c2                	cmp    %eax,%edx
  803475:	73 77                	jae    8034ee <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	75 6e                	jne    8034ee <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803480:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803484:	74 68                	je     8034ee <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803486:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348a:	75 17                	jne    8034a3 <insert_sorted_with_merge_freeList+0xd0>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 b0 47 80 00       	push   $0x8047b0
  803494:	68 e0 00 00 00       	push   $0xe0
  803499:	68 97 47 80 00       	push   $0x804797
  80349e:	e8 50 d9 ff ff       	call   800df3 <_panic>
  8034a3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	89 50 04             	mov    %edx,0x4(%eax)
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 0c                	je     8034c5 <insert_sorted_with_merge_freeList+0xf2>
  8034b9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034be:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c1:	89 10                	mov    %edx,(%eax)
  8034c3:	eb 08                	jmp    8034cd <insert_sorted_with_merge_freeList+0xfa>
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034de:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e3:	40                   	inc    %eax
  8034e4:	a3 44 51 80 00       	mov    %eax,0x805144
  8034e9:	e9 ba 06 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 40 08             	mov    0x8(%eax),%eax
  8034fa:	01 c2                	add    %eax,%edx
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 40 08             	mov    0x8(%eax),%eax
  803502:	39 c2                	cmp    %eax,%edx
  803504:	73 78                	jae    80357e <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	75 6e                	jne    80357e <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803510:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803514:	74 68                	je     80357e <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351a:	75 17                	jne    803533 <insert_sorted_with_merge_freeList+0x160>
  80351c:	83 ec 04             	sub    $0x4,%esp
  80351f:	68 74 47 80 00       	push   $0x804774
  803524:	68 e6 00 00 00       	push   $0xe6
  803529:	68 97 47 80 00       	push   $0x804797
  80352e:	e8 c0 d8 ff ff       	call   800df3 <_panic>
  803533:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	89 10                	mov    %edx,(%eax)
  80353e:	8b 45 08             	mov    0x8(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	85 c0                	test   %eax,%eax
  803545:	74 0d                	je     803554 <insert_sorted_with_merge_freeList+0x181>
  803547:	a1 38 51 80 00       	mov    0x805138,%eax
  80354c:	8b 55 08             	mov    0x8(%ebp),%edx
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	eb 08                	jmp    80355c <insert_sorted_with_merge_freeList+0x189>
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	a3 38 51 80 00       	mov    %eax,0x805138
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356e:	a1 44 51 80 00       	mov    0x805144,%eax
  803573:	40                   	inc    %eax
  803574:	a3 44 51 80 00       	mov    %eax,0x805144
  803579:	e9 2a 06 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80357e:	a1 38 51 80 00       	mov    0x805138,%eax
  803583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803586:	e9 ed 05 00 00       	jmp    803b78 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803593:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803597:	0f 84 a7 00 00 00    	je     803644 <insert_sorted_with_merge_freeList+0x271>
  80359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 40 08             	mov    0x8(%eax),%eax
  8035a9:	01 c2                	add    %eax,%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
  8035b1:	39 c2                	cmp    %eax,%edx
  8035b3:	0f 83 8b 00 00 00    	jae    803644 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	8b 40 08             	mov    0x8(%eax),%eax
  8035c5:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8035c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ca:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8035cd:	39 c2                	cmp    %eax,%edx
  8035cf:	73 73                	jae    803644 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8035d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d5:	74 06                	je     8035dd <insert_sorted_with_merge_freeList+0x20a>
  8035d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035db:	75 17                	jne    8035f4 <insert_sorted_with_merge_freeList+0x221>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 28 48 80 00       	push   $0x804828
  8035e5:	68 f0 00 00 00       	push   $0xf0
  8035ea:	68 97 47 80 00       	push   $0x804797
  8035ef:	e8 ff d7 ff ff       	call   800df3 <_panic>
  8035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f7:	8b 10                	mov    (%eax),%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0b                	je     803612 <insert_sorted_with_merge_freeList+0x23f>
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	8b 55 08             	mov    0x8(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 55 08             	mov    0x8(%ebp),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803620:	89 50 04             	mov    %edx,0x4(%eax)
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	75 08                	jne    803634 <insert_sorted_with_merge_freeList+0x261>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803634:	a1 44 51 80 00       	mov    0x805144,%eax
  803639:	40                   	inc    %eax
  80363a:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  80363f:	e9 64 05 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803644:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803649:	8b 50 0c             	mov    0xc(%eax),%edx
  80364c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803651:	8b 40 08             	mov    0x8(%eax),%eax
  803654:	01 c2                	add    %eax,%edx
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	8b 40 08             	mov    0x8(%eax),%eax
  80365c:	39 c2                	cmp    %eax,%edx
  80365e:	0f 85 b1 00 00 00    	jne    803715 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803664:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	0f 84 a4 00 00 00    	je     803715 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803671:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803676:	8b 00                	mov    (%eax),%eax
  803678:	85 c0                	test   %eax,%eax
  80367a:	0f 85 95 00 00 00    	jne    803715 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803680:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803685:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80368b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80368e:	8b 55 08             	mov    0x8(%ebp),%edx
  803691:	8b 52 0c             	mov    0xc(%edx),%edx
  803694:	01 ca                	add    %ecx,%edx
  803696:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8036ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b1:	75 17                	jne    8036ca <insert_sorted_with_merge_freeList+0x2f7>
  8036b3:	83 ec 04             	sub    $0x4,%esp
  8036b6:	68 74 47 80 00       	push   $0x804774
  8036bb:	68 ff 00 00 00       	push   $0xff
  8036c0:	68 97 47 80 00       	push   $0x804797
  8036c5:	e8 29 d7 ff ff       	call   800df3 <_panic>
  8036ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	89 10                	mov    %edx,(%eax)
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	85 c0                	test   %eax,%eax
  8036dc:	74 0d                	je     8036eb <insert_sorted_with_merge_freeList+0x318>
  8036de:	a1 48 51 80 00       	mov    0x805148,%eax
  8036e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e6:	89 50 04             	mov    %edx,0x4(%eax)
  8036e9:	eb 08                	jmp    8036f3 <insert_sorted_with_merge_freeList+0x320>
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803705:	a1 54 51 80 00       	mov    0x805154,%eax
  80370a:	40                   	inc    %eax
  80370b:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803710:	e9 93 04 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	8b 50 08             	mov    0x8(%eax),%edx
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 40 0c             	mov    0xc(%eax),%eax
  803721:	01 c2                	add    %eax,%edx
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	8b 40 08             	mov    0x8(%eax),%eax
  803729:	39 c2                	cmp    %eax,%edx
  80372b:	0f 85 ae 00 00 00    	jne    8037df <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	8b 50 0c             	mov    0xc(%eax),%edx
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	8b 40 08             	mov    0x8(%eax),%eax
  80373d:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803747:	39 c2                	cmp    %eax,%edx
  803749:	0f 84 90 00 00 00    	je     8037df <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80374f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803752:	8b 50 0c             	mov    0xc(%eax),%edx
  803755:	8b 45 08             	mov    0x8(%ebp),%eax
  803758:	8b 40 0c             	mov    0xc(%eax),%eax
  80375b:	01 c2                	add    %eax,%edx
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803777:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80377b:	75 17                	jne    803794 <insert_sorted_with_merge_freeList+0x3c1>
  80377d:	83 ec 04             	sub    $0x4,%esp
  803780:	68 74 47 80 00       	push   $0x804774
  803785:	68 0b 01 00 00       	push   $0x10b
  80378a:	68 97 47 80 00       	push   $0x804797
  80378f:	e8 5f d6 ff ff       	call   800df3 <_panic>
  803794:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	89 10                	mov    %edx,(%eax)
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	8b 00                	mov    (%eax),%eax
  8037a4:	85 c0                	test   %eax,%eax
  8037a6:	74 0d                	je     8037b5 <insert_sorted_with_merge_freeList+0x3e2>
  8037a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b0:	89 50 04             	mov    %edx,0x4(%eax)
  8037b3:	eb 08                	jmp    8037bd <insert_sorted_with_merge_freeList+0x3ea>
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d4:	40                   	inc    %eax
  8037d5:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8037da:	e9 c9 03 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e8:	8b 40 08             	mov    0x8(%eax),%eax
  8037eb:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f0:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8037f3:	39 c2                	cmp    %eax,%edx
  8037f5:	0f 85 bb 00 00 00    	jne    8038b6 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8037fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ff:	0f 84 b1 00 00 00    	je     8038b6 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	85 c0                	test   %eax,%eax
  80380d:	0f 85 a3 00 00 00    	jne    8038b6 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803813:	a1 38 51 80 00       	mov    0x805138,%eax
  803818:	8b 55 08             	mov    0x8(%ebp),%edx
  80381b:	8b 52 08             	mov    0x8(%edx),%edx
  80381e:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803821:	a1 38 51 80 00       	mov    0x805138,%eax
  803826:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80382c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80382f:	8b 55 08             	mov    0x8(%ebp),%edx
  803832:	8b 52 0c             	mov    0xc(%edx),%edx
  803835:	01 ca                	add    %ecx,%edx
  803837:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80384e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803852:	75 17                	jne    80386b <insert_sorted_with_merge_freeList+0x498>
  803854:	83 ec 04             	sub    $0x4,%esp
  803857:	68 74 47 80 00       	push   $0x804774
  80385c:	68 17 01 00 00       	push   $0x117
  803861:	68 97 47 80 00       	push   $0x804797
  803866:	e8 88 d5 ff ff       	call   800df3 <_panic>
  80386b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	89 10                	mov    %edx,(%eax)
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	8b 00                	mov    (%eax),%eax
  80387b:	85 c0                	test   %eax,%eax
  80387d:	74 0d                	je     80388c <insert_sorted_with_merge_freeList+0x4b9>
  80387f:	a1 48 51 80 00       	mov    0x805148,%eax
  803884:	8b 55 08             	mov    0x8(%ebp),%edx
  803887:	89 50 04             	mov    %edx,0x4(%eax)
  80388a:	eb 08                	jmp    803894 <insert_sorted_with_merge_freeList+0x4c1>
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	a3 48 51 80 00       	mov    %eax,0x805148
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ab:	40                   	inc    %eax
  8038ac:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8038b1:	e9 f2 02 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	8b 50 08             	mov    0x8(%eax),%edx
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c2:	01 c2                	add    %eax,%edx
  8038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ca:	39 c2                	cmp    %eax,%edx
  8038cc:	0f 85 be 00 00 00    	jne    803990 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 40 04             	mov    0x4(%eax),%eax
  8038d8:	8b 50 08             	mov    0x8(%eax),%edx
  8038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038de:	8b 40 04             	mov    0x4(%eax),%eax
  8038e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e4:	01 c2                	add    %eax,%edx
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	8b 40 08             	mov    0x8(%eax),%eax
  8038ec:	39 c2                	cmp    %eax,%edx
  8038ee:	0f 84 9c 00 00 00    	je     803990 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	8b 50 08             	mov    0x8(%eax),%edx
  8038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fd:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803903:	8b 50 0c             	mov    0xc(%eax),%edx
  803906:	8b 45 08             	mov    0x8(%ebp),%eax
  803909:	8b 40 0c             	mov    0xc(%eax),%eax
  80390c:	01 c2                	add    %eax,%edx
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392c:	75 17                	jne    803945 <insert_sorted_with_merge_freeList+0x572>
  80392e:	83 ec 04             	sub    $0x4,%esp
  803931:	68 74 47 80 00       	push   $0x804774
  803936:	68 26 01 00 00       	push   $0x126
  80393b:	68 97 47 80 00       	push   $0x804797
  803940:	e8 ae d4 ff ff       	call   800df3 <_panic>
  803945:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	89 10                	mov    %edx,(%eax)
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	85 c0                	test   %eax,%eax
  803957:	74 0d                	je     803966 <insert_sorted_with_merge_freeList+0x593>
  803959:	a1 48 51 80 00       	mov    0x805148,%eax
  80395e:	8b 55 08             	mov    0x8(%ebp),%edx
  803961:	89 50 04             	mov    %edx,0x4(%eax)
  803964:	eb 08                	jmp    80396e <insert_sorted_with_merge_freeList+0x59b>
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80396e:	8b 45 08             	mov    0x8(%ebp),%eax
  803971:	a3 48 51 80 00       	mov    %eax,0x805148
  803976:	8b 45 08             	mov    0x8(%ebp),%eax
  803979:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803980:	a1 54 51 80 00       	mov    0x805154,%eax
  803985:	40                   	inc    %eax
  803986:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80398b:	e9 18 02 00 00       	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803993:	8b 50 0c             	mov    0xc(%eax),%edx
  803996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803999:	8b 40 08             	mov    0x8(%eax),%eax
  80399c:	01 c2                	add    %eax,%edx
  80399e:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a1:	8b 40 08             	mov    0x8(%eax),%eax
  8039a4:	39 c2                	cmp    %eax,%edx
  8039a6:	0f 85 c4 01 00 00    	jne    803b70 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	8b 50 0c             	mov    0xc(%eax),%edx
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	8b 40 08             	mov    0x8(%eax),%eax
  8039b8:	01 c2                	add    %eax,%edx
  8039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bd:	8b 00                	mov    (%eax),%eax
  8039bf:	8b 40 08             	mov    0x8(%eax),%eax
  8039c2:	39 c2                	cmp    %eax,%edx
  8039c4:	0f 85 a6 01 00 00    	jne    803b70 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8039ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ce:	0f 84 9c 01 00 00    	je     803b70 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8039da:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e0:	01 c2                	add    %eax,%edx
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ea:	01 c2                	add    %eax,%edx
  8039ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ef:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803a06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a0a:	75 17                	jne    803a23 <insert_sorted_with_merge_freeList+0x650>
  803a0c:	83 ec 04             	sub    $0x4,%esp
  803a0f:	68 74 47 80 00       	push   $0x804774
  803a14:	68 32 01 00 00       	push   $0x132
  803a19:	68 97 47 80 00       	push   $0x804797
  803a1e:	e8 d0 d3 ff ff       	call   800df3 <_panic>
  803a23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	89 10                	mov    %edx,(%eax)
  803a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a31:	8b 00                	mov    (%eax),%eax
  803a33:	85 c0                	test   %eax,%eax
  803a35:	74 0d                	je     803a44 <insert_sorted_with_merge_freeList+0x671>
  803a37:	a1 48 51 80 00       	mov    0x805148,%eax
  803a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3f:	89 50 04             	mov    %edx,0x4(%eax)
  803a42:	eb 08                	jmp    803a4c <insert_sorted_with_merge_freeList+0x679>
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	a3 48 51 80 00       	mov    %eax,0x805148
  803a54:	8b 45 08             	mov    0x8(%ebp),%eax
  803a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5e:	a1 54 51 80 00       	mov    0x805154,%eax
  803a63:	40                   	inc    %eax
  803a64:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6c:	8b 00                	mov    (%eax),%eax
  803a6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a78:	8b 00                	mov    (%eax),%eax
  803a7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a84:	8b 00                	mov    (%eax),%eax
  803a86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803a89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a8d:	75 17                	jne    803aa6 <insert_sorted_with_merge_freeList+0x6d3>
  803a8f:	83 ec 04             	sub    $0x4,%esp
  803a92:	68 09 48 80 00       	push   $0x804809
  803a97:	68 36 01 00 00       	push   $0x136
  803a9c:	68 97 47 80 00       	push   $0x804797
  803aa1:	e8 4d d3 ff ff       	call   800df3 <_panic>
  803aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	85 c0                	test   %eax,%eax
  803aad:	74 10                	je     803abf <insert_sorted_with_merge_freeList+0x6ec>
  803aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab7:	8b 52 04             	mov    0x4(%edx),%edx
  803aba:	89 50 04             	mov    %edx,0x4(%eax)
  803abd:	eb 0b                	jmp    803aca <insert_sorted_with_merge_freeList+0x6f7>
  803abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac2:	8b 40 04             	mov    0x4(%eax),%eax
  803ac5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803aca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acd:	8b 40 04             	mov    0x4(%eax),%eax
  803ad0:	85 c0                	test   %eax,%eax
  803ad2:	74 0f                	je     803ae3 <insert_sorted_with_merge_freeList+0x710>
  803ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad7:	8b 40 04             	mov    0x4(%eax),%eax
  803ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803add:	8b 12                	mov    (%edx),%edx
  803adf:	89 10                	mov    %edx,(%eax)
  803ae1:	eb 0a                	jmp    803aed <insert_sorted_with_merge_freeList+0x71a>
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	a3 38 51 80 00       	mov    %eax,0x805138
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b00:	a1 44 51 80 00       	mov    0x805144,%eax
  803b05:	48                   	dec    %eax
  803b06:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803b0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b0f:	75 17                	jne    803b28 <insert_sorted_with_merge_freeList+0x755>
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 74 47 80 00       	push   $0x804774
  803b19:	68 37 01 00 00       	push   $0x137
  803b1e:	68 97 47 80 00       	push   $0x804797
  803b23:	e8 cb d2 ff ff       	call   800df3 <_panic>
  803b28:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b31:	89 10                	mov    %edx,(%eax)
  803b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	85 c0                	test   %eax,%eax
  803b3a:	74 0d                	je     803b49 <insert_sorted_with_merge_freeList+0x776>
  803b3c:	a1 48 51 80 00       	mov    0x805148,%eax
  803b41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b44:	89 50 04             	mov    %edx,0x4(%eax)
  803b47:	eb 08                	jmp    803b51 <insert_sorted_with_merge_freeList+0x77e>
  803b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b54:	a3 48 51 80 00       	mov    %eax,0x805148
  803b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b63:	a1 54 51 80 00       	mov    0x805154,%eax
  803b68:	40                   	inc    %eax
  803b69:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803b6e:	eb 38                	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803b70:	a1 40 51 80 00       	mov    0x805140,%eax
  803b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b7c:	74 07                	je     803b85 <insert_sorted_with_merge_freeList+0x7b2>
  803b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	eb 05                	jmp    803b8a <insert_sorted_with_merge_freeList+0x7b7>
  803b85:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8a:	a3 40 51 80 00       	mov    %eax,0x805140
  803b8f:	a1 40 51 80 00       	mov    0x805140,%eax
  803b94:	85 c0                	test   %eax,%eax
  803b96:	0f 85 ef f9 ff ff    	jne    80358b <insert_sorted_with_merge_freeList+0x1b8>
  803b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba0:	0f 85 e5 f9 ff ff    	jne    80358b <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803ba6:	eb 00                	jmp    803ba8 <insert_sorted_with_merge_freeList+0x7d5>
  803ba8:	90                   	nop
  803ba9:	c9                   	leave  
  803baa:	c3                   	ret    
  803bab:	90                   	nop

00803bac <__udivdi3>:
  803bac:	55                   	push   %ebp
  803bad:	57                   	push   %edi
  803bae:	56                   	push   %esi
  803baf:	53                   	push   %ebx
  803bb0:	83 ec 1c             	sub    $0x1c,%esp
  803bb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc3:	89 ca                	mov    %ecx,%edx
  803bc5:	89 f8                	mov    %edi,%eax
  803bc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcb:	85 f6                	test   %esi,%esi
  803bcd:	75 2d                	jne    803bfc <__udivdi3+0x50>
  803bcf:	39 cf                	cmp    %ecx,%edi
  803bd1:	77 65                	ja     803c38 <__udivdi3+0x8c>
  803bd3:	89 fd                	mov    %edi,%ebp
  803bd5:	85 ff                	test   %edi,%edi
  803bd7:	75 0b                	jne    803be4 <__udivdi3+0x38>
  803bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bde:	31 d2                	xor    %edx,%edx
  803be0:	f7 f7                	div    %edi
  803be2:	89 c5                	mov    %eax,%ebp
  803be4:	31 d2                	xor    %edx,%edx
  803be6:	89 c8                	mov    %ecx,%eax
  803be8:	f7 f5                	div    %ebp
  803bea:	89 c1                	mov    %eax,%ecx
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f5                	div    %ebp
  803bf0:	89 cf                	mov    %ecx,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	39 ce                	cmp    %ecx,%esi
  803bfe:	77 28                	ja     803c28 <__udivdi3+0x7c>
  803c00:	0f bd fe             	bsr    %esi,%edi
  803c03:	83 f7 1f             	xor    $0x1f,%edi
  803c06:	75 40                	jne    803c48 <__udivdi3+0x9c>
  803c08:	39 ce                	cmp    %ecx,%esi
  803c0a:	72 0a                	jb     803c16 <__udivdi3+0x6a>
  803c0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c10:	0f 87 9e 00 00 00    	ja     803cb4 <__udivdi3+0x108>
  803c16:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1b:	89 fa                	mov    %edi,%edx
  803c1d:	83 c4 1c             	add    $0x1c,%esp
  803c20:	5b                   	pop    %ebx
  803c21:	5e                   	pop    %esi
  803c22:	5f                   	pop    %edi
  803c23:	5d                   	pop    %ebp
  803c24:	c3                   	ret    
  803c25:	8d 76 00             	lea    0x0(%esi),%esi
  803c28:	31 ff                	xor    %edi,%edi
  803c2a:	31 c0                	xor    %eax,%eax
  803c2c:	89 fa                	mov    %edi,%edx
  803c2e:	83 c4 1c             	add    $0x1c,%esp
  803c31:	5b                   	pop    %ebx
  803c32:	5e                   	pop    %esi
  803c33:	5f                   	pop    %edi
  803c34:	5d                   	pop    %ebp
  803c35:	c3                   	ret    
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	89 d8                	mov    %ebx,%eax
  803c3a:	f7 f7                	div    %edi
  803c3c:	31 ff                	xor    %edi,%edi
  803c3e:	89 fa                	mov    %edi,%edx
  803c40:	83 c4 1c             	add    $0x1c,%esp
  803c43:	5b                   	pop    %ebx
  803c44:	5e                   	pop    %esi
  803c45:	5f                   	pop    %edi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    
  803c48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c4d:	89 eb                	mov    %ebp,%ebx
  803c4f:	29 fb                	sub    %edi,%ebx
  803c51:	89 f9                	mov    %edi,%ecx
  803c53:	d3 e6                	shl    %cl,%esi
  803c55:	89 c5                	mov    %eax,%ebp
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 ed                	shr    %cl,%ebp
  803c5b:	89 e9                	mov    %ebp,%ecx
  803c5d:	09 f1                	or     %esi,%ecx
  803c5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c63:	89 f9                	mov    %edi,%ecx
  803c65:	d3 e0                	shl    %cl,%eax
  803c67:	89 c5                	mov    %eax,%ebp
  803c69:	89 d6                	mov    %edx,%esi
  803c6b:	88 d9                	mov    %bl,%cl
  803c6d:	d3 ee                	shr    %cl,%esi
  803c6f:	89 f9                	mov    %edi,%ecx
  803c71:	d3 e2                	shl    %cl,%edx
  803c73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c77:	88 d9                	mov    %bl,%cl
  803c79:	d3 e8                	shr    %cl,%eax
  803c7b:	09 c2                	or     %eax,%edx
  803c7d:	89 d0                	mov    %edx,%eax
  803c7f:	89 f2                	mov    %esi,%edx
  803c81:	f7 74 24 0c          	divl   0xc(%esp)
  803c85:	89 d6                	mov    %edx,%esi
  803c87:	89 c3                	mov    %eax,%ebx
  803c89:	f7 e5                	mul    %ebp
  803c8b:	39 d6                	cmp    %edx,%esi
  803c8d:	72 19                	jb     803ca8 <__udivdi3+0xfc>
  803c8f:	74 0b                	je     803c9c <__udivdi3+0xf0>
  803c91:	89 d8                	mov    %ebx,%eax
  803c93:	31 ff                	xor    %edi,%edi
  803c95:	e9 58 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca0:	89 f9                	mov    %edi,%ecx
  803ca2:	d3 e2                	shl    %cl,%edx
  803ca4:	39 c2                	cmp    %eax,%edx
  803ca6:	73 e9                	jae    803c91 <__udivdi3+0xe5>
  803ca8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cab:	31 ff                	xor    %edi,%edi
  803cad:	e9 40 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cb2:	66 90                	xchg   %ax,%ax
  803cb4:	31 c0                	xor    %eax,%eax
  803cb6:	e9 37 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cbb:	90                   	nop

00803cbc <__umoddi3>:
  803cbc:	55                   	push   %ebp
  803cbd:	57                   	push   %edi
  803cbe:	56                   	push   %esi
  803cbf:	53                   	push   %ebx
  803cc0:	83 ec 1c             	sub    $0x1c,%esp
  803cc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ccf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdb:	89 f3                	mov    %esi,%ebx
  803cdd:	89 fa                	mov    %edi,%edx
  803cdf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce3:	89 34 24             	mov    %esi,(%esp)
  803ce6:	85 c0                	test   %eax,%eax
  803ce8:	75 1a                	jne    803d04 <__umoddi3+0x48>
  803cea:	39 f7                	cmp    %esi,%edi
  803cec:	0f 86 a2 00 00 00    	jbe    803d94 <__umoddi3+0xd8>
  803cf2:	89 c8                	mov    %ecx,%eax
  803cf4:	89 f2                	mov    %esi,%edx
  803cf6:	f7 f7                	div    %edi
  803cf8:	89 d0                	mov    %edx,%eax
  803cfa:	31 d2                	xor    %edx,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	39 f0                	cmp    %esi,%eax
  803d06:	0f 87 ac 00 00 00    	ja     803db8 <__umoddi3+0xfc>
  803d0c:	0f bd e8             	bsr    %eax,%ebp
  803d0f:	83 f5 1f             	xor    $0x1f,%ebp
  803d12:	0f 84 ac 00 00 00    	je     803dc4 <__umoddi3+0x108>
  803d18:	bf 20 00 00 00       	mov    $0x20,%edi
  803d1d:	29 ef                	sub    %ebp,%edi
  803d1f:	89 fe                	mov    %edi,%esi
  803d21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d25:	89 e9                	mov    %ebp,%ecx
  803d27:	d3 e0                	shl    %cl,%eax
  803d29:	89 d7                	mov    %edx,%edi
  803d2b:	89 f1                	mov    %esi,%ecx
  803d2d:	d3 ef                	shr    %cl,%edi
  803d2f:	09 c7                	or     %eax,%edi
  803d31:	89 e9                	mov    %ebp,%ecx
  803d33:	d3 e2                	shl    %cl,%edx
  803d35:	89 14 24             	mov    %edx,(%esp)
  803d38:	89 d8                	mov    %ebx,%eax
  803d3a:	d3 e0                	shl    %cl,%eax
  803d3c:	89 c2                	mov    %eax,%edx
  803d3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d42:	d3 e0                	shl    %cl,%eax
  803d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d4c:	89 f1                	mov    %esi,%ecx
  803d4e:	d3 e8                	shr    %cl,%eax
  803d50:	09 d0                	or     %edx,%eax
  803d52:	d3 eb                	shr    %cl,%ebx
  803d54:	89 da                	mov    %ebx,%edx
  803d56:	f7 f7                	div    %edi
  803d58:	89 d3                	mov    %edx,%ebx
  803d5a:	f7 24 24             	mull   (%esp)
  803d5d:	89 c6                	mov    %eax,%esi
  803d5f:	89 d1                	mov    %edx,%ecx
  803d61:	39 d3                	cmp    %edx,%ebx
  803d63:	0f 82 87 00 00 00    	jb     803df0 <__umoddi3+0x134>
  803d69:	0f 84 91 00 00 00    	je     803e00 <__umoddi3+0x144>
  803d6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d73:	29 f2                	sub    %esi,%edx
  803d75:	19 cb                	sbb    %ecx,%ebx
  803d77:	89 d8                	mov    %ebx,%eax
  803d79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d7d:	d3 e0                	shl    %cl,%eax
  803d7f:	89 e9                	mov    %ebp,%ecx
  803d81:	d3 ea                	shr    %cl,%edx
  803d83:	09 d0                	or     %edx,%eax
  803d85:	89 e9                	mov    %ebp,%ecx
  803d87:	d3 eb                	shr    %cl,%ebx
  803d89:	89 da                	mov    %ebx,%edx
  803d8b:	83 c4 1c             	add    $0x1c,%esp
  803d8e:	5b                   	pop    %ebx
  803d8f:	5e                   	pop    %esi
  803d90:	5f                   	pop    %edi
  803d91:	5d                   	pop    %ebp
  803d92:	c3                   	ret    
  803d93:	90                   	nop
  803d94:	89 fd                	mov    %edi,%ebp
  803d96:	85 ff                	test   %edi,%edi
  803d98:	75 0b                	jne    803da5 <__umoddi3+0xe9>
  803d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d9f:	31 d2                	xor    %edx,%edx
  803da1:	f7 f7                	div    %edi
  803da3:	89 c5                	mov    %eax,%ebp
  803da5:	89 f0                	mov    %esi,%eax
  803da7:	31 d2                	xor    %edx,%edx
  803da9:	f7 f5                	div    %ebp
  803dab:	89 c8                	mov    %ecx,%eax
  803dad:	f7 f5                	div    %ebp
  803daf:	89 d0                	mov    %edx,%eax
  803db1:	e9 44 ff ff ff       	jmp    803cfa <__umoddi3+0x3e>
  803db6:	66 90                	xchg   %ax,%ax
  803db8:	89 c8                	mov    %ecx,%eax
  803dba:	89 f2                	mov    %esi,%edx
  803dbc:	83 c4 1c             	add    $0x1c,%esp
  803dbf:	5b                   	pop    %ebx
  803dc0:	5e                   	pop    %esi
  803dc1:	5f                   	pop    %edi
  803dc2:	5d                   	pop    %ebp
  803dc3:	c3                   	ret    
  803dc4:	3b 04 24             	cmp    (%esp),%eax
  803dc7:	72 06                	jb     803dcf <__umoddi3+0x113>
  803dc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dcd:	77 0f                	ja     803dde <__umoddi3+0x122>
  803dcf:	89 f2                	mov    %esi,%edx
  803dd1:	29 f9                	sub    %edi,%ecx
  803dd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dd7:	89 14 24             	mov    %edx,(%esp)
  803dda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dde:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de2:	8b 14 24             	mov    (%esp),%edx
  803de5:	83 c4 1c             	add    $0x1c,%esp
  803de8:	5b                   	pop    %ebx
  803de9:	5e                   	pop    %esi
  803dea:	5f                   	pop    %edi
  803deb:	5d                   	pop    %ebp
  803dec:	c3                   	ret    
  803ded:	8d 76 00             	lea    0x0(%esi),%esi
  803df0:	2b 04 24             	sub    (%esp),%eax
  803df3:	19 fa                	sbb    %edi,%edx
  803df5:	89 d1                	mov    %edx,%ecx
  803df7:	89 c6                	mov    %eax,%esi
  803df9:	e9 71 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
  803dfe:	66 90                	xchg   %ax,%ax
  803e00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e04:	72 ea                	jb     803df0 <__umoddi3+0x134>
  803e06:	89 d9                	mov    %ebx,%ecx
  803e08:	e9 62 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
