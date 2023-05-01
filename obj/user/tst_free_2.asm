
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 e0 3a 80 00       	push   $0x803ae0
  800095:	6a 14                	push   $0x14
  800097:	68 fc 3a 80 00       	push   $0x803afc
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 5d 1c 00 00       	call   801d08 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 86 24 00 00       	call   80253e <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 d8 20 00 00       	call   8021a6 <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 ab 20 00 00       	call   8021a6 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 43 21 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 f1 1b 00 00       	call   801d08 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 10 3b 80 00       	push   $0x803b10
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 fc 3a 80 00       	push   $0x803afc
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 09 21 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 78 3b 80 00       	push   $0x803b78
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 fc 3a 80 00       	push   $0x803afc
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 3c 20 00 00       	call   8021a6 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 d4 20 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 82 1b 00 00       	call   801d08 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 10 3b 80 00       	push   $0x803b10
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 fc 3a 80 00       	push   $0x803afc
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 8e 20 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 78 3b 80 00       	push   $0x803b78
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 fc 3a 80 00       	push   $0x803afc
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 c1 1f 00 00       	call   8021a6 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 59 20 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 0a 1b 00 00       	call   801d08 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 10 3b 80 00       	push   $0x803b10
  800220:	6a 3d                	push   $0x3d
  800222:	68 fc 3a 80 00       	push   $0x803afc
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 15 20 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 78 3b 80 00       	push   $0x803b78
  80023e:	6a 3e                	push   $0x3e
  800240:	68 fc 3a 80 00       	push   $0x803afc
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 4b 1f 00 00       	call   8021a6 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 e3 1f 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 94 1a 00 00       	call   801d08 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 10 3b 80 00       	push   $0x803b10
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 fc 3a 80 00       	push   $0x803afc
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 95 1f 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 78 3b 80 00       	push   $0x803b78
  8002be:	6a 46                	push   $0x46
  8002c0:	68 fc 3a 80 00       	push   $0x803afc
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 cb 1e 00 00       	call   8021a6 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 63 1f 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 0c 1a 00 00       	call   801d08 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 10 3b 80 00       	push   $0x803b10
  800328:	6a 4d                	push   $0x4d
  80032a:	68 fc 3a 80 00       	push   $0x803afc
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 0d 1f 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 78 3b 80 00       	push   $0x803b78
  800346:	6a 4e                	push   $0x4e
  800348:	68 fc 3a 80 00       	push   $0x803afc
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 3b 1e 00 00       	call   8021a6 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 d3 1e 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 7d 19 00 00       	call   801d08 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 10 3b 80 00       	push   $0x803b10
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 fc 3a 80 00       	push   $0x803afc
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 7e 1e 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 78 3b 80 00       	push   $0x803b78
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 fc 3a 80 00       	push   $0x803afc
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 ad 1d 00 00       	call   8021a6 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 45 1e 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 f3 18 00 00       	call   801d08 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 10 3b 80 00       	push   $0x803b10
  800448:	6a 5d                	push   $0x5d
  80044a:	68 fc 3a 80 00       	push   $0x803afc
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 ed 1d 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 78 3b 80 00       	push   $0x803b78
  800466:	6a 5e                	push   $0x5e
  800468:	68 fc 3a 80 00       	push   $0x803afc
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 20 1d 00 00       	call   8021a6 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 b8 1d 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 04 19 00 00       	call   801da1 <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 a1 1d 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 a8 3b 80 00       	push   $0x803ba8
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 fc 3a 80 00       	push   $0x803afc
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 56 20 00 00       	call   802525 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 e4 3b 80 00       	push   $0x803be4
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 fc 3a 80 00       	push   $0x803afc
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 24 20 00 00       	call   802525 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 e4 3b 80 00       	push   $0x803be4
  80051a:	6a 71                	push   $0x71
  80051c:	68 fc 3a 80 00       	push   $0x803afc
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 7b 1c 00 00       	call   8021a6 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 13 1d 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 5f 18 00 00       	call   801da1 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 fc 1c 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 a8 3b 80 00       	push   $0x803ba8
  800557:	6a 76                	push   $0x76
  800559:	68 fc 3a 80 00       	push   $0x803afc
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 b1 1f 00 00       	call   802525 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 e4 3b 80 00       	push   $0x803be4
  800585:	6a 7a                	push   $0x7a
  800587:	68 fc 3a 80 00       	push   $0x803afc
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 7f 1f 00 00       	call   802525 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 e4 3b 80 00       	push   $0x803be4
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 fc 3a 80 00       	push   $0x803afc
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 d6 1b 00 00       	call   8021a6 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 6e 1c 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 ba 17 00 00       	call   801da1 <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 57 1c 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 a8 3b 80 00       	push   $0x803ba8
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 fc 3a 80 00       	push   $0x803afc
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 09 1f 00 00       	call   802525 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 e4 3b 80 00       	push   $0x803be4
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 fc 3a 80 00       	push   $0x803afc
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 d4 1e 00 00       	call   802525 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 e4 3b 80 00       	push   $0x803be4
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 fc 3a 80 00       	push   $0x803afc
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 28 1b 00 00       	call   8021a6 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 c0 1b 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 0c 17 00 00       	call   801da1 <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 a9 1b 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 a8 3b 80 00       	push   $0x803ba8
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 fc 3a 80 00       	push   $0x803afc
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 5b 1e 00 00       	call   802525 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 e4 3b 80 00       	push   $0x803be4
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 fc 3a 80 00       	push   $0x803afc
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 26 1e 00 00       	call   802525 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 e4 3b 80 00       	push   $0x803be4
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 fc 3a 80 00       	push   $0x803afc
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 7a 1a 00 00       	call   8021a6 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 12 1b 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 5e 16 00 00       	call   801da1 <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 fb 1a 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 a8 3b 80 00       	push   $0x803ba8
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 fc 3a 80 00       	push   $0x803afc
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 ad 1d 00 00       	call   802525 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 e4 3b 80 00       	push   $0x803be4
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 fc 3a 80 00       	push   $0x803afc
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 78 1d 00 00       	call   802525 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 e4 3b 80 00       	push   $0x803be4
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 fc 3a 80 00       	push   $0x803afc
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 cc 19 00 00       	call   8021a6 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 64 1a 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 b0 15 00 00       	call   801da1 <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 4d 1a 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 a8 3b 80 00       	push   $0x803ba8
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 fc 3a 80 00       	push   $0x803afc
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 ff 1c 00 00       	call   802525 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 e4 3b 80 00       	push   $0x803be4
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 fc 3a 80 00       	push   $0x803afc
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 ca 1c 00 00       	call   802525 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 e4 3b 80 00       	push   $0x803be4
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 fc 3a 80 00       	push   $0x803afc
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 1e 19 00 00       	call   8021a6 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 b6 19 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 02 15 00 00       	call   801da1 <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 9f 19 00 00       	call   802246 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 a8 3b 80 00       	push   $0x803ba8
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 fc 3a 80 00       	push   $0x803afc
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 51 1c 00 00       	call   802525 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 e4 3b 80 00       	push   $0x803be4
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 fc 3a 80 00       	push   $0x803afc
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 1c 1c 00 00       	call   802525 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 e4 3b 80 00       	push   $0x803be4
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 fc 3a 80 00       	push   $0x803afc
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 70 18 00 00       	call   8021a6 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 28 3c 80 00       	push   $0x803c28
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 fc 3a 80 00       	push   $0x803afc
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 de 1b 00 00       	call   80253e <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 5c 3c 80 00       	push   $0x803c5c
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 02 1b 00 00       	call   802486 <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 a4 18 00 00       	call   802293 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 b0 3c 80 00       	push   $0x803cb0
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 d8 3c 80 00       	push   $0x803cd8
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 00 3d 80 00       	push   $0x803d00
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 58 3d 80 00       	push   $0x803d58
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 b0 3c 80 00       	push   $0x803cb0
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 24 18 00 00       	call   8022ad <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 b1 19 00 00       	call   802452 <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 06 1a 00 00       	call   8024b8 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 6c 3d 80 00       	push   $0x803d6c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 71 3d 80 00       	push   $0x803d71
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 8d 3d 80 00       	push   $0x803d8d
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 90 3d 80 00       	push   $0x803d90
  800b44:	6a 26                	push   $0x26
  800b46:	68 dc 3d 80 00       	push   $0x803ddc
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 e8 3d 80 00       	push   $0x803de8
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 dc 3d 80 00       	push   $0x803ddc
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 3c 3e 80 00       	push   $0x803e3c
  800c86:	6a 44                	push   $0x44
  800c88:	68 dc 3d 80 00       	push   $0x803ddc
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 05 14 00 00       	call   8020e5 <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 8e 13 00 00       	call   8020e5 <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 f2 14 00 00       	call   802293 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 ec 14 00 00       	call   8022ad <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 65 2a 00 00       	call   803870 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 25 2b 00 00       	call   803980 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 b4 40 80 00       	add    $0x8040b4,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 c5 40 80 00       	push   $0x8040c5
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 ce 40 80 00       	push   $0x8040ce
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be d1 40 80 00       	mov    $0x8040d1,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 30 42 80 00       	push   $0x804230
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801b2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b31:	00 00 00 
  801b34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b3b:	00 00 00 
  801b3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b45:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b48:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b4f:	00 00 00 
  801b52:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b59:	00 00 00 
  801b5c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b63:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801b66:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b70:	c1 e8 0c             	shr    $0xc,%eax
  801b73:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801b78:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b87:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b8c:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801b91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801b98:	a1 20 51 80 00       	mov    0x805120,%eax
  801b9d:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801ba1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801ba4:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801bab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb1:	01 d0                	add    %edx,%eax
  801bb3:	48                   	dec    %eax
  801bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	f7 75 e4             	divl   -0x1c(%ebp)
  801bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc5:	29 d0                	sub    %edx,%eax
  801bc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801bca:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801bd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	6a 07                	push   $0x7
  801be3:	ff 75 e8             	pushl  -0x18(%ebp)
  801be6:	50                   	push   %eax
  801be7:	e8 3d 06 00 00       	call   802229 <sys_allocate_chunk>
  801bec:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bef:	a1 20 51 80 00       	mov    0x805120,%eax
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	50                   	push   %eax
  801bf8:	e8 b2 0c 00 00       	call   8028af <initialize_MemBlocksList>
  801bfd:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801c00:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c05:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801c08:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c0c:	0f 84 f3 00 00 00    	je     801d05 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801c12:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c16:	75 14                	jne    801c2c <initialize_dyn_block_system+0x108>
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	68 55 42 80 00       	push   $0x804255
  801c20:	6a 36                	push   $0x36
  801c22:	68 73 42 80 00       	push   $0x804273
  801c27:	e8 89 ee ff ff       	call   800ab5 <_panic>
  801c2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c2f:	8b 00                	mov    (%eax),%eax
  801c31:	85 c0                	test   %eax,%eax
  801c33:	74 10                	je     801c45 <initialize_dyn_block_system+0x121>
  801c35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c38:	8b 00                	mov    (%eax),%eax
  801c3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c3d:	8b 52 04             	mov    0x4(%edx),%edx
  801c40:	89 50 04             	mov    %edx,0x4(%eax)
  801c43:	eb 0b                	jmp    801c50 <initialize_dyn_block_system+0x12c>
  801c45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c48:	8b 40 04             	mov    0x4(%eax),%eax
  801c4b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c53:	8b 40 04             	mov    0x4(%eax),%eax
  801c56:	85 c0                	test   %eax,%eax
  801c58:	74 0f                	je     801c69 <initialize_dyn_block_system+0x145>
  801c5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c5d:	8b 40 04             	mov    0x4(%eax),%eax
  801c60:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c63:	8b 12                	mov    (%edx),%edx
  801c65:	89 10                	mov    %edx,(%eax)
  801c67:	eb 0a                	jmp    801c73 <initialize_dyn_block_system+0x14f>
  801c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	a3 48 51 80 00       	mov    %eax,0x805148
  801c73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c86:	a1 54 51 80 00       	mov    0x805154,%eax
  801c8b:	48                   	dec    %eax
  801c8c:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801c91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c94:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801c9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c9e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801ca5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ca9:	75 14                	jne    801cbf <initialize_dyn_block_system+0x19b>
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	68 80 42 80 00       	push   $0x804280
  801cb3:	6a 3e                	push   $0x3e
  801cb5:	68 73 42 80 00       	push   $0x804273
  801cba:	e8 f6 ed ff ff       	call   800ab5 <_panic>
  801cbf:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cc8:	89 10                	mov    %edx,(%eax)
  801cca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	74 0d                	je     801ce0 <initialize_dyn_block_system+0x1bc>
  801cd3:	a1 38 51 80 00       	mov    0x805138,%eax
  801cd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cdb:	89 50 04             	mov    %edx,0x4(%eax)
  801cde:	eb 08                	jmp    801ce8 <initialize_dyn_block_system+0x1c4>
  801ce0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ce3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ceb:	a3 38 51 80 00       	mov    %eax,0x805138
  801cf0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cfa:	a1 44 51 80 00       	mov    0x805144,%eax
  801cff:	40                   	inc    %eax
  801d00:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801d0e:	e8 e0 fd ff ff       	call   801af3 <InitializeUHeap>
		if (size == 0) return NULL ;
  801d13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d17:	75 07                	jne    801d20 <malloc+0x18>
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	eb 7f                	jmp    801d9f <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d20:	e8 d2 08 00 00       	call   8025f7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	74 71                	je     801d9a <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801d29:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d30:	8b 55 08             	mov    0x8(%ebp),%edx
  801d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d36:	01 d0                	add    %edx,%eax
  801d38:	48                   	dec    %eax
  801d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	f7 75 f4             	divl   -0xc(%ebp)
  801d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4a:	29 d0                	sub    %edx,%eax
  801d4c:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801d4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801d56:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d5d:	76 07                	jbe    801d66 <malloc+0x5e>
					return NULL ;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	eb 39                	jmp    801d9f <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	e8 e6 0d 00 00       	call   802b57 <alloc_block_FF>
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801d77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d7b:	74 16                	je     801d93 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 75 ec             	pushl  -0x14(%ebp)
  801d83:	e8 37 0c 00 00       	call   8029bf <insert_sorted_allocList>
  801d88:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8e:	8b 40 08             	mov    0x8(%eax),%eax
  801d91:	eb 0c                	jmp    801d9f <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	eb 05                	jmp    801d9f <malloc+0x97>
				}
		}
	return 0;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	ff 75 f4             	pushl  -0xc(%ebp)
  801db3:	68 40 50 80 00       	push   $0x805040
  801db8:	e8 cf 0b 00 00       	call   80298c <find_block>
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcf:	8b 40 08             	mov    0x8(%eax),%eax
  801dd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd9:	0f 84 a1 00 00 00    	je     801e80 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801ddf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de3:	75 17                	jne    801dfc <free+0x5b>
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	68 55 42 80 00       	push   $0x804255
  801ded:	68 80 00 00 00       	push   $0x80
  801df2:	68 73 42 80 00       	push   $0x804273
  801df7:	e8 b9 ec ff ff       	call   800ab5 <_panic>
  801dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dff:	8b 00                	mov    (%eax),%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	74 10                	je     801e15 <free+0x74>
  801e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e08:	8b 00                	mov    (%eax),%eax
  801e0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e0d:	8b 52 04             	mov    0x4(%edx),%edx
  801e10:	89 50 04             	mov    %edx,0x4(%eax)
  801e13:	eb 0b                	jmp    801e20 <free+0x7f>
  801e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e18:	8b 40 04             	mov    0x4(%eax),%eax
  801e1b:	a3 44 50 80 00       	mov    %eax,0x805044
  801e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e23:	8b 40 04             	mov    0x4(%eax),%eax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	74 0f                	je     801e39 <free+0x98>
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2d:	8b 40 04             	mov    0x4(%eax),%eax
  801e30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e33:	8b 12                	mov    (%edx),%edx
  801e35:	89 10                	mov    %edx,(%eax)
  801e37:	eb 0a                	jmp    801e43 <free+0xa2>
  801e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3c:	8b 00                	mov    (%eax),%eax
  801e3e:	a3 40 50 80 00       	mov    %eax,0x805040
  801e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e5b:	48                   	dec    %eax
  801e5c:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	ff 75 f0             	pushl  -0x10(%ebp)
  801e67:	e8 29 12 00 00       	call   803095 <insert_sorted_with_merge_freeList>
  801e6c:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801e6f:	83 ec 08             	sub    $0x8,%esp
  801e72:	ff 75 ec             	pushl  -0x14(%ebp)
  801e75:	ff 75 e8             	pushl  -0x18(%ebp)
  801e78:	e8 74 03 00 00       	call   8021f1 <sys_free_user_mem>
  801e7d:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e80:	90                   	nop
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 38             	sub    $0x38,%esp
  801e89:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e8f:	e8 5f fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e98:	75 0a                	jne    801ea4 <smalloc+0x21>
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	e9 b2 00 00 00       	jmp    801f56 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801ea4:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801eab:	76 0a                	jbe    801eb7 <smalloc+0x34>
		return NULL;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb2:	e9 9f 00 00 00       	jmp    801f56 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801eb7:	e8 3b 07 00 00       	call   8025f7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 84 8d 00 00 00    	je     801f51 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801ec4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801ecb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed8:	01 d0                	add    %edx,%eax
  801eda:	48                   	dec    %eax
  801edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee6:	f7 75 f0             	divl   -0x10(%ebp)
  801ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eec:	29 d0                	sub    %edx,%eax
  801eee:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ef7:	e8 5b 0c 00 00       	call   802b57 <alloc_block_FF>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f06:	75 07                	jne    801f0f <smalloc+0x8c>
			return NULL;
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	eb 47                	jmp    801f56 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	e8 a5 0a 00 00       	call   8029bf <insert_sorted_allocList>
  801f1a:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 40 08             	mov    0x8(%eax),%eax
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	e8 46 04 00 00       	call   80237c <sys_createSharedObject>
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801f3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f40:	78 08                	js     801f4a <smalloc+0xc7>
		return (void *)b->sva;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 40 08             	mov    0x8(%eax),%eax
  801f48:	eb 0c                	jmp    801f56 <smalloc+0xd3>
		}else{
		return NULL;
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	eb 05                	jmp    801f56 <smalloc+0xd3>
			}

	}return NULL;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f5e:	e8 90 fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f63:	e8 8f 06 00 00       	call   8025f7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 84 ad 00 00 00    	je     80201d <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f70:	83 ec 08             	sub    $0x8,%esp
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	e8 28 04 00 00       	call   8023a6 <sys_getSizeOfSharedObject>
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801f84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f88:	79 0a                	jns    801f94 <sget+0x3c>
    {
    	return NULL;
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	e9 8e 00 00 00       	jmp    802022 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801f94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801f9b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa8:	01 d0                	add    %edx,%eax
  801faa:	48                   	dec    %eax
  801fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb6:	f7 75 ec             	divl   -0x14(%ebp)
  801fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fbc:	29 d0                	sub    %edx,%eax
  801fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc7:	e8 8b 0b 00 00       	call   802b57 <alloc_block_FF>
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801fd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd6:	75 07                	jne    801fdf <sget+0x87>
				return NULL;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	eb 43                	jmp    802022 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe5:	e8 d5 09 00 00       	call   8029bf <insert_sorted_allocList>
  801fea:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff0:	8b 40 08             	mov    0x8(%eax),%eax
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	50                   	push   %eax
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 c1 03 00 00       	call   8023c3 <sys_getSharedObject>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802008:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80200c:	78 08                	js     802016 <sget+0xbe>
			return (void *)b->sva;
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	8b 40 08             	mov    0x8(%eax),%eax
  802014:	eb 0c                	jmp    802022 <sget+0xca>
			}else{
			return NULL;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	eb 05                	jmp    802022 <sget+0xca>
			}
    }}return NULL;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80202a:	e8 c4 fa ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	68 a4 42 80 00       	push   $0x8042a4
  802037:	68 03 01 00 00       	push   $0x103
  80203c:	68 73 42 80 00       	push   $0x804273
  802041:	e8 6f ea ff ff       	call   800ab5 <_panic>

00802046 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	68 cc 42 80 00       	push   $0x8042cc
  802054:	68 17 01 00 00       	push   $0x117
  802059:	68 73 42 80 00       	push   $0x804273
  80205e:	e8 52 ea ff ff       	call   800ab5 <_panic>

00802063 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	68 f0 42 80 00       	push   $0x8042f0
  802071:	68 22 01 00 00       	push   $0x122
  802076:	68 73 42 80 00       	push   $0x804273
  80207b:	e8 35 ea ff ff       	call   800ab5 <_panic>

00802080 <shrink>:

}
void shrink(uint32 newSize)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 f0 42 80 00       	push   $0x8042f0
  80208e:	68 27 01 00 00       	push   $0x127
  802093:	68 73 42 80 00       	push   $0x804273
  802098:	e8 18 ea ff ff       	call   800ab5 <_panic>

0080209d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	68 f0 42 80 00       	push   $0x8042f0
  8020ab:	68 2c 01 00 00       	push   $0x12c
  8020b0:	68 73 42 80 00       	push   $0x804273
  8020b5:	e8 fb e9 ff ff       	call   800ab5 <_panic>

008020ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	57                   	push   %edi
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020d5:	cd 30                	int    $0x30
  8020d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5e                   	pop    %esi
  8020e2:	5f                   	pop    %edi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    

008020e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	52                   	push   %edx
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	50                   	push   %eax
  802101:	6a 00                	push   $0x0
  802103:	e8 b2 ff ff ff       	call   8020ba <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_cgetc>:

int
sys_cgetc(void)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 01                	push   $0x1
  80211d:	e8 98 ff ff ff       	call   8020ba <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80212a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	6a 05                	push   $0x5
  80213a:	e8 7b ff ff ff       	call   8020ba <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802149:	8b 75 18             	mov    0x18(%ebp),%esi
  80214c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80214f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802152:	8b 55 0c             	mov    0xc(%ebp),%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	56                   	push   %esi
  802159:	53                   	push   %ebx
  80215a:	51                   	push   %ecx
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 06                	push   $0x6
  80215f:	e8 56 ff ff ff       	call   8020ba <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216a:	5b                   	pop    %ebx
  80216b:	5e                   	pop    %esi
  80216c:	5d                   	pop    %ebp
  80216d:	c3                   	ret    

0080216e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802171:	8b 55 0c             	mov    0xc(%ebp),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	52                   	push   %edx
  80217e:	50                   	push   %eax
  80217f:	6a 07                	push   $0x7
  802181:	e8 34 ff ff ff       	call   8020ba <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 08                	push   $0x8
  80219c:	e8 19 ff ff ff       	call   8020ba <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 09                	push   $0x9
  8021b5:	e8 00 ff ff ff       	call   8020ba <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 0a                	push   $0xa
  8021ce:	e8 e7 fe ff ff       	call   8020ba <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 0b                	push   $0xb
  8021e7:	e8 ce fe ff ff       	call   8020ba <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	ff 75 0c             	pushl  0xc(%ebp)
  8021fd:	ff 75 08             	pushl  0x8(%ebp)
  802200:	6a 0f                	push   $0xf
  802202:	e8 b3 fe ff ff       	call   8020ba <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
	return;
  80220a:	90                   	nop
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 0c             	pushl  0xc(%ebp)
  802219:	ff 75 08             	pushl  0x8(%ebp)
  80221c:	6a 10                	push   $0x10
  80221e:	e8 97 fe ff ff       	call   8020ba <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
	return ;
  802226:	90                   	nop
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	ff 75 10             	pushl  0x10(%ebp)
  802233:	ff 75 0c             	pushl  0xc(%ebp)
  802236:	ff 75 08             	pushl  0x8(%ebp)
  802239:	6a 11                	push   $0x11
  80223b:	e8 7a fe ff ff       	call   8020ba <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
	return ;
  802243:	90                   	nop
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 0c                	push   $0xc
  802255:	e8 60 fe ff ff       	call   8020ba <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	ff 75 08             	pushl  0x8(%ebp)
  80226d:	6a 0d                	push   $0xd
  80226f:	e8 46 fe ff ff       	call   8020ba <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 0e                	push   $0xe
  802288:	e8 2d fe ff ff       	call   8020ba <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 13                	push   $0x13
  8022a2:	e8 13 fe ff ff       	call   8020ba <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 14                	push   $0x14
  8022bc:	e8 f9 fd ff ff       	call   8020ba <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	50                   	push   %eax
  8022e0:	6a 15                	push   $0x15
  8022e2:	e8 d3 fd ff ff       	call   8020ba <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 16                	push   $0x16
  8022fc:	e8 b9 fd ff ff       	call   8020ba <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	90                   	nop
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	ff 75 0c             	pushl  0xc(%ebp)
  802316:	50                   	push   %eax
  802317:	6a 17                	push   $0x17
  802319:	e8 9c fd ff ff       	call   8020ba <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	52                   	push   %edx
  802333:	50                   	push   %eax
  802334:	6a 1a                	push   $0x1a
  802336:	e8 7f fd ff ff       	call   8020ba <syscall>
  80233b:	83 c4 18             	add    $0x18,%esp
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 18                	push   $0x18
  802353:	e8 62 fd ff ff       	call   8020ba <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	90                   	nop
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802361:	8b 55 0c             	mov    0xc(%ebp),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	52                   	push   %edx
  80236e:	50                   	push   %eax
  80236f:	6a 19                	push   $0x19
  802371:	e8 44 fd ff ff       	call   8020ba <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
}
  802379:	90                   	nop
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 04             	sub    $0x4,%esp
  802382:	8b 45 10             	mov    0x10(%ebp),%eax
  802385:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802388:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80238b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	6a 00                	push   $0x0
  802394:	51                   	push   %ecx
  802395:	52                   	push   %edx
  802396:	ff 75 0c             	pushl  0xc(%ebp)
  802399:	50                   	push   %eax
  80239a:	6a 1b                	push   $0x1b
  80239c:	e8 19 fd ff ff       	call   8020ba <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	52                   	push   %edx
  8023b6:	50                   	push   %eax
  8023b7:	6a 1c                	push   $0x1c
  8023b9:	e8 fc fc ff ff       	call   8020ba <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	51                   	push   %ecx
  8023d4:	52                   	push   %edx
  8023d5:	50                   	push   %eax
  8023d6:	6a 1d                	push   $0x1d
  8023d8:	e8 dd fc ff ff       	call   8020ba <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 1e                	push   $0x1e
  8023f5:	e8 c0 fc ff ff       	call   8020ba <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 1f                	push   $0x1f
  80240e:	e8 a7 fc ff ff       	call   8020ba <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	6a 00                	push   $0x0
  802420:	ff 75 14             	pushl  0x14(%ebp)
  802423:	ff 75 10             	pushl  0x10(%ebp)
  802426:	ff 75 0c             	pushl  0xc(%ebp)
  802429:	50                   	push   %eax
  80242a:	6a 20                	push   $0x20
  80242c:	e8 89 fc ff ff       	call   8020ba <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	50                   	push   %eax
  802445:	6a 21                	push   $0x21
  802447:	e8 6e fc ff ff       	call   8020ba <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	90                   	nop
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	50                   	push   %eax
  802461:	6a 22                	push   $0x22
  802463:	e8 52 fc ff ff       	call   8020ba <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 02                	push   $0x2
  80247c:	e8 39 fc ff ff       	call   8020ba <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 03                	push   $0x3
  802495:	e8 20 fc ff ff       	call   8020ba <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 04                	push   $0x4
  8024ae:	e8 07 fc ff ff       	call   8020ba <syscall>
  8024b3:	83 c4 18             	add    $0x18,%esp
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sys_exit_env>:


void sys_exit_env(void)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 23                	push   $0x23
  8024c7:	e8 ee fb ff ff       	call   8020ba <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	90                   	nop
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024db:	8d 50 04             	lea    0x4(%eax),%edx
  8024de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	52                   	push   %edx
  8024e8:	50                   	push   %eax
  8024e9:	6a 24                	push   $0x24
  8024eb:	e8 ca fb ff ff       	call   8020ba <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return result;
  8024f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024fc:	89 01                	mov    %eax,(%ecx)
  8024fe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	c9                   	leave  
  802505:	c2 04 00             	ret    $0x4

00802508 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	ff 75 10             	pushl  0x10(%ebp)
  802512:	ff 75 0c             	pushl  0xc(%ebp)
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	6a 12                	push   $0x12
  80251a:	e8 9b fb ff ff       	call   8020ba <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
	return ;
  802522:	90                   	nop
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_rcr2>:
uint32 sys_rcr2()
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 25                	push   $0x25
  802534:	e8 81 fb ff ff       	call   8020ba <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80254a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	50                   	push   %eax
  802557:	6a 26                	push   $0x26
  802559:	e8 5c fb ff ff       	call   8020ba <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
	return ;
  802561:	90                   	nop
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <rsttst>:
void rsttst()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 28                	push   $0x28
  802573:	e8 42 fb ff ff       	call   8020ba <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
	return ;
  80257b:	90                   	nop
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	8b 45 14             	mov    0x14(%ebp),%eax
  802587:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80258a:	8b 55 18             	mov    0x18(%ebp),%edx
  80258d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802591:	52                   	push   %edx
  802592:	50                   	push   %eax
  802593:	ff 75 10             	pushl  0x10(%ebp)
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	ff 75 08             	pushl  0x8(%ebp)
  80259c:	6a 27                	push   $0x27
  80259e:	e8 17 fb ff ff       	call   8020ba <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a6:	90                   	nop
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <chktst>:
void chktst(uint32 n)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	ff 75 08             	pushl  0x8(%ebp)
  8025b7:	6a 29                	push   $0x29
  8025b9:	e8 fc fa ff ff       	call   8020ba <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <inctst>:

void inctst()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 2a                	push   $0x2a
  8025d3:	e8 e2 fa ff ff       	call   8020ba <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025db:	90                   	nop
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <gettst>:
uint32 gettst()
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 2b                	push   $0x2b
  8025ed:	e8 c8 fa ff ff       	call   8020ba <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 2c                	push   $0x2c
  802609:	e8 ac fa ff ff       	call   8020ba <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
  802611:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802614:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802618:	75 07                	jne    802621 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	eb 05                	jmp    802626 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 2c                	push   $0x2c
  80263a:	e8 7b fa ff ff       	call   8020ba <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
  802642:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802645:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802649:	75 07                	jne    802652 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80264b:	b8 01 00 00 00       	mov    $0x1,%eax
  802650:	eb 05                	jmp    802657 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 2c                	push   $0x2c
  80266b:	e8 4a fa ff ff       	call   8020ba <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
  802673:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802676:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80267a:	75 07                	jne    802683 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80267c:	b8 01 00 00 00       	mov    $0x1,%eax
  802681:	eb 05                	jmp    802688 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 2c                	push   $0x2c
  80269c:	e8 19 fa ff ff       	call   8020ba <syscall>
  8026a1:	83 c4 18             	add    $0x18,%esp
  8026a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026a7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026ab:	75 07                	jne    8026b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b2:	eb 05                	jmp    8026b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	ff 75 08             	pushl  0x8(%ebp)
  8026c9:	6a 2d                	push   $0x2d
  8026cb:	e8 ea f9 ff ff       	call   8020ba <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d3:	90                   	nop
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	6a 00                	push   $0x0
  8026e8:	53                   	push   %ebx
  8026e9:	51                   	push   %ecx
  8026ea:	52                   	push   %edx
  8026eb:	50                   	push   %eax
  8026ec:	6a 2e                	push   $0x2e
  8026ee:	e8 c7 f9 ff ff       	call   8020ba <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
}
  8026f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	52                   	push   %edx
  80270b:	50                   	push   %eax
  80270c:	6a 2f                	push   $0x2f
  80270e:	e8 a7 f9 ff ff       	call   8020ba <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80271e:	83 ec 0c             	sub    $0xc,%esp
  802721:	68 00 43 80 00       	push   $0x804300
  802726:	e8 3e e6 ff ff       	call   800d69 <cprintf>
  80272b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80272e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802735:	83 ec 0c             	sub    $0xc,%esp
  802738:	68 2c 43 80 00       	push   $0x80432c
  80273d:	e8 27 e6 ff ff       	call   800d69 <cprintf>
  802742:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802745:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802749:	a1 38 51 80 00       	mov    0x805138,%eax
  80274e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802751:	eb 56                	jmp    8027a9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802753:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802757:	74 1c                	je     802775 <print_mem_block_lists+0x5d>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 50 08             	mov    0x8(%eax),%edx
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 48 08             	mov    0x8(%eax),%ecx
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 40 0c             	mov    0xc(%eax),%eax
  80276b:	01 c8                	add    %ecx,%eax
  80276d:	39 c2                	cmp    %eax,%edx
  80276f:	73 04                	jae    802775 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802771:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 50 08             	mov    0x8(%eax),%edx
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 0c             	mov    0xc(%eax),%eax
  802781:	01 c2                	add    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	52                   	push   %edx
  80278d:	50                   	push   %eax
  80278e:	68 41 43 80 00       	push   $0x804341
  802793:	e8 d1 e5 ff ff       	call   800d69 <cprintf>
  802798:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ad:	74 07                	je     8027b6 <print_mem_block_lists+0x9e>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	eb 05                	jmp    8027bb <print_mem_block_lists+0xa3>
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8027c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	75 8a                	jne    802753 <print_mem_block_lists+0x3b>
  8027c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cd:	75 84                	jne    802753 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027cf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027d3:	75 10                	jne    8027e5 <print_mem_block_lists+0xcd>
  8027d5:	83 ec 0c             	sub    $0xc,%esp
  8027d8:	68 50 43 80 00       	push   $0x804350
  8027dd:	e8 87 e5 ff ff       	call   800d69 <cprintf>
  8027e2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	68 74 43 80 00       	push   $0x804374
  8027f4:	e8 70 e5 ff ff       	call   800d69 <cprintf>
  8027f9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027fc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802800:	a1 40 50 80 00       	mov    0x805040,%eax
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802808:	eb 56                	jmp    802860 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80280a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280e:	74 1c                	je     80282c <print_mem_block_lists+0x114>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 50 08             	mov    0x8(%eax),%edx
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 48 08             	mov    0x8(%eax),%ecx
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
  802822:	01 c8                	add    %ecx,%eax
  802824:	39 c2                	cmp    %eax,%edx
  802826:	73 04                	jae    80282c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802828:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 50 08             	mov    0x8(%eax),%edx
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	01 c2                	add    %eax,%edx
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 08             	mov    0x8(%eax),%eax
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	52                   	push   %edx
  802844:	50                   	push   %eax
  802845:	68 41 43 80 00       	push   $0x804341
  80284a:	e8 1a e5 ff ff       	call   800d69 <cprintf>
  80284f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802858:	a1 48 50 80 00       	mov    0x805048,%eax
  80285d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802864:	74 07                	je     80286d <print_mem_block_lists+0x155>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	eb 05                	jmp    802872 <print_mem_block_lists+0x15a>
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
  802872:	a3 48 50 80 00       	mov    %eax,0x805048
  802877:	a1 48 50 80 00       	mov    0x805048,%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	75 8a                	jne    80280a <print_mem_block_lists+0xf2>
  802880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802884:	75 84                	jne    80280a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802886:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80288a:	75 10                	jne    80289c <print_mem_block_lists+0x184>
  80288c:	83 ec 0c             	sub    $0xc,%esp
  80288f:	68 8c 43 80 00       	push   $0x80438c
  802894:	e8 d0 e4 ff ff       	call   800d69 <cprintf>
  802899:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	68 00 43 80 00       	push   $0x804300
  8028a4:	e8 c0 e4 ff ff       	call   800d69 <cprintf>
  8028a9:	83 c4 10             	add    $0x10,%esp

}
  8028ac:	90                   	nop
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    

008028af <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8028b5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028bc:	00 00 00 
  8028bf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028c6:	00 00 00 
  8028c9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028d0:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8028d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028da:	e9 9e 00 00 00       	jmp    80297d <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8028df:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e7:	c1 e2 04             	shl    $0x4,%edx
  8028ea:	01 d0                	add    %edx,%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	75 14                	jne    802904 <initialize_MemBlocksList+0x55>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 b4 43 80 00       	push   $0x8043b4
  8028f8:	6a 3d                	push   $0x3d
  8028fa:	68 d7 43 80 00       	push   $0x8043d7
  8028ff:	e8 b1 e1 ff ff       	call   800ab5 <_panic>
  802904:	a1 50 50 80 00       	mov    0x805050,%eax
  802909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290c:	c1 e2 04             	shl    $0x4,%edx
  80290f:	01 d0                	add    %edx,%eax
  802911:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802917:	89 10                	mov    %edx,(%eax)
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 18                	je     802937 <initialize_MemBlocksList+0x88>
  80291f:	a1 48 51 80 00       	mov    0x805148,%eax
  802924:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80292a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80292d:	c1 e1 04             	shl    $0x4,%ecx
  802930:	01 ca                	add    %ecx,%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	eb 12                	jmp    802949 <initialize_MemBlocksList+0x9a>
  802937:	a1 50 50 80 00       	mov    0x805050,%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	c1 e2 04             	shl    $0x4,%edx
  802942:	01 d0                	add    %edx,%eax
  802944:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802949:	a1 50 50 80 00       	mov    0x805050,%eax
  80294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802951:	c1 e2 04             	shl    $0x4,%edx
  802954:	01 d0                	add    %edx,%eax
  802956:	a3 48 51 80 00       	mov    %eax,0x805148
  80295b:	a1 50 50 80 00       	mov    0x805050,%eax
  802960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802963:	c1 e2 04             	shl    $0x4,%edx
  802966:	01 d0                	add    %edx,%eax
  802968:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296f:	a1 54 51 80 00       	mov    0x805154,%eax
  802974:	40                   	inc    %eax
  802975:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80297a:	ff 45 f4             	incl   -0xc(%ebp)
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	3b 45 08             	cmp    0x8(%ebp),%eax
  802983:	0f 82 56 ff ff ff    	jb     8028df <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802989:	90                   	nop
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80299a:	eb 18                	jmp    8029b4 <find_block+0x28>

		if(tmp->sva == va){
  80299c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80299f:	8b 40 08             	mov    0x8(%eax),%eax
  8029a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029a5:	75 05                	jne    8029ac <find_block+0x20>
			return tmp ;
  8029a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029aa:	eb 11                	jmp    8029bd <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8029ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8029b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029b8:	75 e2                	jne    80299c <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8029ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8029bd:	c9                   	leave  
  8029be:	c3                   	ret    

008029bf <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
  8029c2:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8029c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8029cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8029d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d9:	75 65                	jne    802a40 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8029db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029df:	75 14                	jne    8029f5 <insert_sorted_allocList+0x36>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 b4 43 80 00       	push   $0x8043b4
  8029e9:	6a 62                	push   $0x62
  8029eb:	68 d7 43 80 00       	push   $0x8043d7
  8029f0:	e8 c0 e0 ff ff       	call   800ab5 <_panic>
  8029f5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0d                	je     802a16 <insert_sorted_allocList+0x57>
  802a09:	a1 40 50 80 00       	mov    0x805040,%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 08                	jmp    802a1e <insert_sorted_allocList+0x5f>
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 44 50 80 00       	mov    %eax,0x805044
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 40 50 80 00       	mov    %eax,0x805040
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a35:	40                   	inc    %eax
  802a36:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a3b:	e9 14 01 00 00       	jmp    802b54 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	a1 44 50 80 00       	mov    0x805044,%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	39 c2                	cmp    %eax,%edx
  802a50:	76 65                	jbe    802ab7 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802a52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a56:	75 14                	jne    802a6c <insert_sorted_allocList+0xad>
  802a58:	83 ec 04             	sub    $0x4,%esp
  802a5b:	68 f0 43 80 00       	push   $0x8043f0
  802a60:	6a 64                	push   $0x64
  802a62:	68 d7 43 80 00       	push   $0x8043d7
  802a67:	e8 49 e0 ff ff       	call   800ab5 <_panic>
  802a6c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	74 0c                	je     802a8e <insert_sorted_allocList+0xcf>
  802a82:	a1 44 50 80 00       	mov    0x805044,%eax
  802a87:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8a:	89 10                	mov    %edx,(%eax)
  802a8c:	eb 08                	jmp    802a96 <insert_sorted_allocList+0xd7>
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	a3 40 50 80 00       	mov    %eax,0x805040
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	a3 44 50 80 00       	mov    %eax,0x805044
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aac:	40                   	inc    %eax
  802aad:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ab2:	e9 9d 00 00 00       	jmp    802b54 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802ab7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802abe:	e9 85 00 00 00       	jmp    802b48 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 50 08             	mov    0x8(%eax),%edx
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 40 08             	mov    0x8(%eax),%eax
  802acf:	39 c2                	cmp    %eax,%edx
  802ad1:	73 6a                	jae    802b3d <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	74 06                	je     802adf <insert_sorted_allocList+0x120>
  802ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802add:	75 14                	jne    802af3 <insert_sorted_allocList+0x134>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 14 44 80 00       	push   $0x804414
  802ae7:	6a 6b                	push   $0x6b
  802ae9:	68 d7 43 80 00       	push   $0x8043d7
  802aee:	e8 c2 df ff ff       	call   800ab5 <_panic>
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 50 04             	mov    0x4(%eax),%edx
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0d                	je     802b1e <insert_sorted_allocList+0x15f>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	89 10                	mov    %edx,(%eax)
  802b1c:	eb 08                	jmp    802b26 <insert_sorted_allocList+0x167>
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	a3 40 50 80 00       	mov    %eax,0x805040
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b34:	40                   	inc    %eax
  802b35:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802b3a:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b3b:	eb 17                	jmp    802b54 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802b45:	ff 45 f0             	incl   -0x10(%ebp)
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b4e:	0f 8c 6f ff ff ff    	jl     802ac3 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b54:	90                   	nop
  802b55:	c9                   	leave  
  802b56:	c3                   	ret    

00802b57 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
  802b5a:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802b5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802b65:	e9 7c 01 00 00       	jmp    802ce6 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b73:	0f 86 cf 00 00 00    	jbe    802c48 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b79:	a1 48 51 80 00       	mov    0x805148,%eax
  802b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8d:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba5:	89 c2                	mov    %eax,%edx
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802bbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc2:	75 17                	jne    802bdb <alloc_block_FF+0x84>
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	68 49 44 80 00       	push   $0x804449
  802bcc:	68 83 00 00 00       	push   $0x83
  802bd1:	68 d7 43 80 00       	push   $0x8043d7
  802bd6:	e8 da de ff ff       	call   800ab5 <_panic>
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 10                	je     802bf4 <alloc_block_FF+0x9d>
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bec:	8b 52 04             	mov    0x4(%edx),%edx
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	eb 0b                	jmp    802bff <alloc_block_FF+0xa8>
  802bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 0f                	je     802c18 <alloc_block_FF+0xc1>
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	8b 40 04             	mov    0x4(%eax),%eax
  802c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c12:	8b 12                	mov    (%edx),%edx
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	eb 0a                	jmp    802c22 <alloc_block_FF+0xcb>
  802c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c35:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3a:	48                   	dec    %eax
  802c3b:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	e9 ad 00 00 00       	jmp    802cf5 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c51:	0f 85 87 00 00 00    	jne    802cde <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5b:	75 17                	jne    802c74 <alloc_block_FF+0x11d>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 49 44 80 00       	push   $0x804449
  802c65:	68 87 00 00 00       	push   $0x87
  802c6a:	68 d7 43 80 00       	push   $0x8043d7
  802c6f:	e8 41 de ff ff       	call   800ab5 <_panic>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 10                	je     802c8d <alloc_block_FF+0x136>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c85:	8b 52 04             	mov    0x4(%edx),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	eb 0b                	jmp    802c98 <alloc_block_FF+0x141>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 0f                	je     802cb1 <alloc_block_FF+0x15a>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	8b 12                	mov    (%edx),%edx
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	eb 0a                	jmp    802cbb <alloc_block_FF+0x164>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cce:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd3:	48                   	dec    %eax
  802cd4:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	eb 17                	jmp    802cf5 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802ce6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cea:	0f 85 7a fe ff ff    	jne    802b6a <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf5:	c9                   	leave  
  802cf6:	c3                   	ret    

00802cf7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cf7:	55                   	push   %ebp
  802cf8:	89 e5                	mov    %esp,%ebp
  802cfa:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802cfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802d0c:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802d13:	a1 38 51 80 00       	mov    0x805138,%eax
  802d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1b:	e9 d0 00 00 00       	jmp    802df0 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d29:	0f 82 b8 00 00 00    	jb     802de7 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 0c             	mov    0xc(%eax),%eax
  802d35:	2b 45 08             	sub    0x8(%ebp),%eax
  802d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d41:	0f 83 a1 00 00 00    	jae    802de8 <alloc_block_BF+0xf1>
				differsize = differance ;
  802d47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d57:	0f 85 8b 00 00 00    	jne    802de8 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d61:	75 17                	jne    802d7a <alloc_block_BF+0x83>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 49 44 80 00       	push   $0x804449
  802d6b:	68 a0 00 00 00       	push   $0xa0
  802d70:	68 d7 43 80 00       	push   $0x8043d7
  802d75:	e8 3b dd ff ff       	call   800ab5 <_panic>
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 10                	je     802d93 <alloc_block_BF+0x9c>
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8b:	8b 52 04             	mov    0x4(%edx),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 0b                	jmp    802d9e <alloc_block_BF+0xa7>
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0f                	je     802db7 <alloc_block_BF+0xc0>
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db1:	8b 12                	mov    (%edx),%edx
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	eb 0a                	jmp    802dc1 <alloc_block_BF+0xca>
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd4:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd9:	48                   	dec    %eax
  802dda:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	e9 0c 01 00 00       	jmp    802ef3 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802de7:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802de8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df4:	74 07                	je     802dfd <alloc_block_BF+0x106>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	eb 05                	jmp    802e02 <alloc_block_BF+0x10b>
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	a3 40 51 80 00       	mov    %eax,0x805140
  802e07:	a1 40 51 80 00       	mov    0x805140,%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	0f 85 0c ff ff ff    	jne    802d20 <alloc_block_BF+0x29>
  802e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e18:	0f 85 02 ff ff ff    	jne    802d20 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e22:	0f 84 c6 00 00 00    	je     802eee <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802e28:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 55 08             	mov    0x8(%ebp),%edx
  802e36:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	8b 50 08             	mov    0x8(%eax),%edx
  802e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e42:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e4e:	89 c2                	mov    %eax,%edx
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e59:	8b 50 08             	mov    0x8(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802e67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e6b:	75 17                	jne    802e84 <alloc_block_BF+0x18d>
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	68 49 44 80 00       	push   $0x804449
  802e75:	68 af 00 00 00       	push   $0xaf
  802e7a:	68 d7 43 80 00       	push   $0x8043d7
  802e7f:	e8 31 dc ff ff       	call   800ab5 <_panic>
  802e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 10                	je     802e9d <alloc_block_BF+0x1a6>
  802e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e95:	8b 52 04             	mov    0x4(%edx),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 0b                	jmp    802ea8 <alloc_block_BF+0x1b1>
  802e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 0f                	je     802ec1 <alloc_block_BF+0x1ca>
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebb:	8b 12                	mov    (%edx),%edx
  802ebd:	89 10                	mov    %edx,(%eax)
  802ebf:	eb 0a                	jmp    802ecb <alloc_block_BF+0x1d4>
  802ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ede:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee3:	48                   	dec    %eax
  802ee4:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802ee9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eec:	eb 05                	jmp    802ef3 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef3:	c9                   	leave  
  802ef4:	c3                   	ret    

00802ef5 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802ef5:	55                   	push   %ebp
  802ef6:	89 e5                	mov    %esp,%ebp
  802ef8:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802efb:	a1 38 51 80 00       	mov    0x805138,%eax
  802f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802f03:	e9 7c 01 00 00       	jmp    803084 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f11:	0f 86 cf 00 00 00    	jbe    802fe6 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802f17:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f28:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2b:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 50 08             	mov    0x8(%eax),%edx
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	2b 45 08             	sub    0x8(%ebp),%eax
  802f43:	89 c2                	mov    %eax,%edx
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 50 08             	mov    0x8(%eax),%edx
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802f5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f60:	75 17                	jne    802f79 <alloc_block_NF+0x84>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 49 44 80 00       	push   $0x804449
  802f6a:	68 c4 00 00 00       	push   $0xc4
  802f6f:	68 d7 43 80 00       	push   $0x8043d7
  802f74:	e8 3c db ff ff       	call   800ab5 <_panic>
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 10                	je     802f92 <alloc_block_NF+0x9d>
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f8a:	8b 52 04             	mov    0x4(%edx),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 0b                	jmp    802f9d <alloc_block_NF+0xa8>
  802f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0f                	je     802fb6 <alloc_block_NF+0xc1>
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fb0:	8b 12                	mov    (%edx),%edx
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	eb 0a                	jmp    802fc0 <alloc_block_NF+0xcb>
  802fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd8:	48                   	dec    %eax
  802fd9:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe1:	e9 ad 00 00 00       	jmp    803093 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fef:	0f 85 87 00 00 00    	jne    80307c <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff9:	75 17                	jne    803012 <alloc_block_NF+0x11d>
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	68 49 44 80 00       	push   $0x804449
  803003:	68 c8 00 00 00       	push   $0xc8
  803008:	68 d7 43 80 00       	push   $0x8043d7
  80300d:	e8 a3 da ff ff       	call   800ab5 <_panic>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 10                	je     80302b <alloc_block_NF+0x136>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803023:	8b 52 04             	mov    0x4(%edx),%edx
  803026:	89 50 04             	mov    %edx,0x4(%eax)
  803029:	eb 0b                	jmp    803036 <alloc_block_NF+0x141>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 40 04             	mov    0x4(%eax),%eax
  803031:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 40 04             	mov    0x4(%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 0f                	je     80304f <alloc_block_NF+0x15a>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 40 04             	mov    0x4(%eax),%eax
  803046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803049:	8b 12                	mov    (%edx),%edx
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	eb 0a                	jmp    803059 <alloc_block_NF+0x164>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	a3 38 51 80 00       	mov    %eax,0x805138
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306c:	a1 44 51 80 00       	mov    0x805144,%eax
  803071:	48                   	dec    %eax
  803072:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	eb 17                	jmp    803093 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803088:	0f 85 7a fe ff ff    	jne    802f08 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80308e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803093:	c9                   	leave  
  803094:	c3                   	ret    

00803095 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
  803098:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80309b:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8030a3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8030ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8030b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b7:	75 68                	jne    803121 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8030b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bd:	75 17                	jne    8030d6 <insert_sorted_with_merge_freeList+0x41>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 b4 43 80 00       	push   $0x8043b4
  8030c7:	68 da 00 00 00       	push   $0xda
  8030cc:	68 d7 43 80 00       	push   $0x8043d7
  8030d1:	e8 df d9 ff ff       	call   800ab5 <_panic>
  8030d6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	89 10                	mov    %edx,(%eax)
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 0d                	je     8030f7 <insert_sorted_with_merge_freeList+0x62>
  8030ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f2:	89 50 04             	mov    %edx,0x4(%eax)
  8030f5:	eb 08                	jmp    8030ff <insert_sorted_with_merge_freeList+0x6a>
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	a3 38 51 80 00       	mov    %eax,0x805138
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803111:	a1 44 51 80 00       	mov    0x805144,%eax
  803116:	40                   	inc    %eax
  803117:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80311c:	e9 49 07 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 50 08             	mov    0x8(%eax),%edx
  803127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	01 c2                	add    %eax,%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 40 08             	mov    0x8(%eax),%eax
  803135:	39 c2                	cmp    %eax,%edx
  803137:	73 77                	jae    8031b0 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	75 6e                	jne    8031b0 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803142:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803146:	74 68                	je     8031b0 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803148:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314c:	75 17                	jne    803165 <insert_sorted_with_merge_freeList+0xd0>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 f0 43 80 00       	push   $0x8043f0
  803156:	68 e0 00 00 00       	push   $0xe0
  80315b:	68 d7 43 80 00       	push   $0x8043d7
  803160:	e8 50 d9 ff ff       	call   800ab5 <_panic>
  803165:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0c                	je     803187 <insert_sorted_with_merge_freeList+0xf2>
  80317b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	89 10                	mov    %edx,(%eax)
  803185:	eb 08                	jmp    80318f <insert_sorted_with_merge_freeList+0xfa>
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 38 51 80 00       	mov    %eax,0x805138
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a5:	40                   	inc    %eax
  8031a6:	a3 44 51 80 00       	mov    %eax,0x805144
  8031ab:	e9 ba 06 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 40 08             	mov    0x8(%eax),%eax
  8031bc:	01 c2                	add    %eax,%edx
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 40 08             	mov    0x8(%eax),%eax
  8031c4:	39 c2                	cmp    %eax,%edx
  8031c6:	73 78                	jae    803240 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	75 6e                	jne    803240 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8031d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d6:	74 68                	je     803240 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8031d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031dc:	75 17                	jne    8031f5 <insert_sorted_with_merge_freeList+0x160>
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	68 b4 43 80 00       	push   $0x8043b4
  8031e6:	68 e6 00 00 00       	push   $0xe6
  8031eb:	68 d7 43 80 00       	push   $0x8043d7
  8031f0:	e8 c0 d8 ff ff       	call   800ab5 <_panic>
  8031f5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0d                	je     803216 <insert_sorted_with_merge_freeList+0x181>
  803209:	a1 38 51 80 00       	mov    0x805138,%eax
  80320e:	8b 55 08             	mov    0x8(%ebp),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 08                	jmp    80321e <insert_sorted_with_merge_freeList+0x189>
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	a3 38 51 80 00       	mov    %eax,0x805138
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 44 51 80 00       	mov    0x805144,%eax
  803235:	40                   	inc    %eax
  803236:	a3 44 51 80 00       	mov    %eax,0x805144
  80323b:	e9 2a 06 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803240:	a1 38 51 80 00       	mov    0x805138,%eax
  803245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803248:	e9 ed 05 00 00       	jmp    80383a <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803255:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803259:	0f 84 a7 00 00 00    	je     803306 <insert_sorted_with_merge_freeList+0x271>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 50 0c             	mov    0xc(%eax),%edx
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 40 08             	mov    0x8(%eax),%eax
  80326b:	01 c2                	add    %eax,%edx
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 08             	mov    0x8(%eax),%eax
  803273:	39 c2                	cmp    %eax,%edx
  803275:	0f 83 8b 00 00 00    	jae    803306 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	8b 50 0c             	mov    0xc(%eax),%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 40 08             	mov    0x8(%eax),%eax
  803287:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  80328f:	39 c2                	cmp    %eax,%edx
  803291:	73 73                	jae    803306 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803297:	74 06                	je     80329f <insert_sorted_with_merge_freeList+0x20a>
  803299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329d:	75 17                	jne    8032b6 <insert_sorted_with_merge_freeList+0x221>
  80329f:	83 ec 04             	sub    $0x4,%esp
  8032a2:	68 68 44 80 00       	push   $0x804468
  8032a7:	68 f0 00 00 00       	push   $0xf0
  8032ac:	68 d7 43 80 00       	push   $0x8043d7
  8032b1:	e8 ff d7 ff ff       	call   800ab5 <_panic>
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 10                	mov    (%eax),%edx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	74 0b                	je     8032d4 <insert_sorted_with_merge_freeList+0x23f>
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d1:	89 50 04             	mov    %edx,0x4(%eax)
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e2:	89 50 04             	mov    %edx,0x4(%eax)
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	75 08                	jne    8032f6 <insert_sorted_with_merge_freeList+0x261>
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fb:	40                   	inc    %eax
  8032fc:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803301:	e9 64 05 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803306:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330b:	8b 50 0c             	mov    0xc(%eax),%edx
  80330e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803313:	8b 40 08             	mov    0x8(%eax),%eax
  803316:	01 c2                	add    %eax,%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 40 08             	mov    0x8(%eax),%eax
  80331e:	39 c2                	cmp    %eax,%edx
  803320:	0f 85 b1 00 00 00    	jne    8033d7 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803326:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	0f 84 a4 00 00 00    	je     8033d7 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803333:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	0f 85 95 00 00 00    	jne    8033d7 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803342:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803347:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80334d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803350:	8b 55 08             	mov    0x8(%ebp),%edx
  803353:	8b 52 0c             	mov    0xc(%edx),%edx
  803356:	01 ca                	add    %ecx,%edx
  803358:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80336f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803373:	75 17                	jne    80338c <insert_sorted_with_merge_freeList+0x2f7>
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 b4 43 80 00       	push   $0x8043b4
  80337d:	68 ff 00 00 00       	push   $0xff
  803382:	68 d7 43 80 00       	push   $0x8043d7
  803387:	e8 29 d7 ff ff       	call   800ab5 <_panic>
  80338c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	89 10                	mov    %edx,(%eax)
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	85 c0                	test   %eax,%eax
  80339e:	74 0d                	je     8033ad <insert_sorted_with_merge_freeList+0x318>
  8033a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	eb 08                	jmp    8033b5 <insert_sorted_with_merge_freeList+0x320>
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cc:	40                   	inc    %eax
  8033cd:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8033d2:	e9 93 04 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 50 08             	mov    0x8(%eax),%edx
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e3:	01 c2                	add    %eax,%edx
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	8b 40 08             	mov    0x8(%eax),%eax
  8033eb:	39 c2                	cmp    %eax,%edx
  8033ed:	0f 85 ae 00 00 00    	jne    8034a1 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	8b 40 08             	mov    0x8(%eax),%eax
  8033ff:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803409:	39 c2                	cmp    %eax,%edx
  80340b:	0f 84 90 00 00 00    	je     8034a1 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 50 0c             	mov    0xc(%eax),%edx
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	8b 40 0c             	mov    0xc(%eax),%eax
  80341d:	01 c2                	add    %eax,%edx
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803425:	8b 45 08             	mov    0x8(%ebp),%eax
  803428:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803439:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343d:	75 17                	jne    803456 <insert_sorted_with_merge_freeList+0x3c1>
  80343f:	83 ec 04             	sub    $0x4,%esp
  803442:	68 b4 43 80 00       	push   $0x8043b4
  803447:	68 0b 01 00 00       	push   $0x10b
  80344c:	68 d7 43 80 00       	push   $0x8043d7
  803451:	e8 5f d6 ff ff       	call   800ab5 <_panic>
  803456:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 0d                	je     803477 <insert_sorted_with_merge_freeList+0x3e2>
  80346a:	a1 48 51 80 00       	mov    0x805148,%eax
  80346f:	8b 55 08             	mov    0x8(%ebp),%edx
  803472:	89 50 04             	mov    %edx,0x4(%eax)
  803475:	eb 08                	jmp    80347f <insert_sorted_with_merge_freeList+0x3ea>
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	a3 48 51 80 00       	mov    %eax,0x805148
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803491:	a1 54 51 80 00       	mov    0x805154,%eax
  803496:	40                   	inc    %eax
  803497:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80349c:	e9 c9 03 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034b5:	39 c2                	cmp    %eax,%edx
  8034b7:	0f 85 bb 00 00 00    	jne    803578 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	0f 84 b1 00 00 00    	je     803578 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	0f 85 a3 00 00 00    	jne    803578 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8034d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8034da:	8b 55 08             	mov    0x8(%ebp),%edx
  8034dd:	8b 52 08             	mov    0x8(%edx),%edx
  8034e0:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8034e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8034e8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034ee:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8034f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8034f7:	01 ca                	add    %ecx,%edx
  8034f9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803510:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803514:	75 17                	jne    80352d <insert_sorted_with_merge_freeList+0x498>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 b4 43 80 00       	push   $0x8043b4
  80351e:	68 17 01 00 00       	push   $0x117
  803523:	68 d7 43 80 00       	push   $0x8043d7
  803528:	e8 88 d5 ff ff       	call   800ab5 <_panic>
  80352d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	89 10                	mov    %edx,(%eax)
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	74 0d                	je     80354e <insert_sorted_with_merge_freeList+0x4b9>
  803541:	a1 48 51 80 00       	mov    0x805148,%eax
  803546:	8b 55 08             	mov    0x8(%ebp),%edx
  803549:	89 50 04             	mov    %edx,0x4(%eax)
  80354c:	eb 08                	jmp    803556 <insert_sorted_with_merge_freeList+0x4c1>
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	a3 48 51 80 00       	mov    %eax,0x805148
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803568:	a1 54 51 80 00       	mov    0x805154,%eax
  80356d:	40                   	inc    %eax
  80356e:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803573:	e9 f2 02 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	8b 50 08             	mov    0x8(%eax),%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 40 0c             	mov    0xc(%eax),%eax
  803584:	01 c2                	add    %eax,%edx
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 40 08             	mov    0x8(%eax),%eax
  80358c:	39 c2                	cmp    %eax,%edx
  80358e:	0f 85 be 00 00 00    	jne    803652 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803597:	8b 40 04             	mov    0x4(%eax),%eax
  80359a:	8b 50 08             	mov    0x8(%eax),%edx
  80359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a0:	8b 40 04             	mov    0x4(%eax),%eax
  8035a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a6:	01 c2                	add    %eax,%edx
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	8b 40 08             	mov    0x8(%eax),%eax
  8035ae:	39 c2                	cmp    %eax,%edx
  8035b0:	0f 84 9c 00 00 00    	je     803652 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 50 08             	mov    0x8(%eax),%edx
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ce:	01 c2                	add    %eax,%edx
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8035ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ee:	75 17                	jne    803607 <insert_sorted_with_merge_freeList+0x572>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 b4 43 80 00       	push   $0x8043b4
  8035f8:	68 26 01 00 00       	push   $0x126
  8035fd:	68 d7 43 80 00       	push   $0x8043d7
  803602:	e8 ae d4 ff ff       	call   800ab5 <_panic>
  803607:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	89 10                	mov    %edx,(%eax)
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	74 0d                	je     803628 <insert_sorted_with_merge_freeList+0x593>
  80361b:	a1 48 51 80 00       	mov    0x805148,%eax
  803620:	8b 55 08             	mov    0x8(%ebp),%edx
  803623:	89 50 04             	mov    %edx,0x4(%eax)
  803626:	eb 08                	jmp    803630 <insert_sorted_with_merge_freeList+0x59b>
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	a3 48 51 80 00       	mov    %eax,0x805148
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803642:	a1 54 51 80 00       	mov    0x805154,%eax
  803647:	40                   	inc    %eax
  803648:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80364d:	e9 18 02 00 00       	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803655:	8b 50 0c             	mov    0xc(%eax),%edx
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 40 08             	mov    0x8(%eax),%eax
  80365e:	01 c2                	add    %eax,%edx
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	8b 40 08             	mov    0x8(%eax),%eax
  803666:	39 c2                	cmp    %eax,%edx
  803668:	0f 85 c4 01 00 00    	jne    803832 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 50 0c             	mov    0xc(%eax),%edx
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	8b 40 08             	mov    0x8(%eax),%eax
  80367a:	01 c2                	add    %eax,%edx
  80367c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	8b 40 08             	mov    0x8(%eax),%eax
  803684:	39 c2                	cmp    %eax,%edx
  803686:	0f 85 a6 01 00 00    	jne    803832 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80368c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803690:	0f 84 9c 01 00 00    	je     803832 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 50 0c             	mov    0xc(%eax),%edx
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a2:	01 c2                	add    %eax,%edx
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ac:	01 c2                	add    %eax,%edx
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8036c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036cc:	75 17                	jne    8036e5 <insert_sorted_with_merge_freeList+0x650>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 b4 43 80 00       	push   $0x8043b4
  8036d6:	68 32 01 00 00       	push   $0x132
  8036db:	68 d7 43 80 00       	push   $0x8043d7
  8036e0:	e8 d0 d3 ff ff       	call   800ab5 <_panic>
  8036e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	89 10                	mov    %edx,(%eax)
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0d                	je     803706 <insert_sorted_with_merge_freeList+0x671>
  8036f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	eb 08                	jmp    80370e <insert_sorted_with_merge_freeList+0x679>
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	a3 48 51 80 00       	mov    %eax,0x805148
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803720:	a1 54 51 80 00       	mov    0x805154,%eax
  803725:	40                   	inc    %eax
  803726:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80374b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80374f:	75 17                	jne    803768 <insert_sorted_with_merge_freeList+0x6d3>
  803751:	83 ec 04             	sub    $0x4,%esp
  803754:	68 49 44 80 00       	push   $0x804449
  803759:	68 36 01 00 00       	push   $0x136
  80375e:	68 d7 43 80 00       	push   $0x8043d7
  803763:	e8 4d d3 ff ff       	call   800ab5 <_panic>
  803768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376b:	8b 00                	mov    (%eax),%eax
  80376d:	85 c0                	test   %eax,%eax
  80376f:	74 10                	je     803781 <insert_sorted_with_merge_freeList+0x6ec>
  803771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803774:	8b 00                	mov    (%eax),%eax
  803776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803779:	8b 52 04             	mov    0x4(%edx),%edx
  80377c:	89 50 04             	mov    %edx,0x4(%eax)
  80377f:	eb 0b                	jmp    80378c <insert_sorted_with_merge_freeList+0x6f7>
  803781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803784:	8b 40 04             	mov    0x4(%eax),%eax
  803787:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80378c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378f:	8b 40 04             	mov    0x4(%eax),%eax
  803792:	85 c0                	test   %eax,%eax
  803794:	74 0f                	je     8037a5 <insert_sorted_with_merge_freeList+0x710>
  803796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803799:	8b 40 04             	mov    0x4(%eax),%eax
  80379c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80379f:	8b 12                	mov    (%edx),%edx
  8037a1:	89 10                	mov    %edx,(%eax)
  8037a3:	eb 0a                	jmp    8037af <insert_sorted_with_merge_freeList+0x71a>
  8037a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8037c7:	48                   	dec    %eax
  8037c8:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8037cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037d1:	75 17                	jne    8037ea <insert_sorted_with_merge_freeList+0x755>
  8037d3:	83 ec 04             	sub    $0x4,%esp
  8037d6:	68 b4 43 80 00       	push   $0x8043b4
  8037db:	68 37 01 00 00       	push   $0x137
  8037e0:	68 d7 43 80 00       	push   $0x8043d7
  8037e5:	e8 cb d2 ff ff       	call   800ab5 <_panic>
  8037ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f3:	89 10                	mov    %edx,(%eax)
  8037f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f8:	8b 00                	mov    (%eax),%eax
  8037fa:	85 c0                	test   %eax,%eax
  8037fc:	74 0d                	je     80380b <insert_sorted_with_merge_freeList+0x776>
  8037fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803806:	89 50 04             	mov    %edx,0x4(%eax)
  803809:	eb 08                	jmp    803813 <insert_sorted_with_merge_freeList+0x77e>
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	a3 48 51 80 00       	mov    %eax,0x805148
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803825:	a1 54 51 80 00       	mov    0x805154,%eax
  80382a:	40                   	inc    %eax
  80382b:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803830:	eb 38                	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803832:	a1 40 51 80 00       	mov    0x805140,%eax
  803837:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80383a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383e:	74 07                	je     803847 <insert_sorted_with_merge_freeList+0x7b2>
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	eb 05                	jmp    80384c <insert_sorted_with_merge_freeList+0x7b7>
  803847:	b8 00 00 00 00       	mov    $0x0,%eax
  80384c:	a3 40 51 80 00       	mov    %eax,0x805140
  803851:	a1 40 51 80 00       	mov    0x805140,%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	0f 85 ef f9 ff ff    	jne    80324d <insert_sorted_with_merge_freeList+0x1b8>
  80385e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803862:	0f 85 e5 f9 ff ff    	jne    80324d <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803868:	eb 00                	jmp    80386a <insert_sorted_with_merge_freeList+0x7d5>
  80386a:	90                   	nop
  80386b:	c9                   	leave  
  80386c:	c3                   	ret    
  80386d:	66 90                	xchg   %ax,%ax
  80386f:	90                   	nop

00803870 <__udivdi3>:
  803870:	55                   	push   %ebp
  803871:	57                   	push   %edi
  803872:	56                   	push   %esi
  803873:	53                   	push   %ebx
  803874:	83 ec 1c             	sub    $0x1c,%esp
  803877:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80387b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80387f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803883:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803887:	89 ca                	mov    %ecx,%edx
  803889:	89 f8                	mov    %edi,%eax
  80388b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80388f:	85 f6                	test   %esi,%esi
  803891:	75 2d                	jne    8038c0 <__udivdi3+0x50>
  803893:	39 cf                	cmp    %ecx,%edi
  803895:	77 65                	ja     8038fc <__udivdi3+0x8c>
  803897:	89 fd                	mov    %edi,%ebp
  803899:	85 ff                	test   %edi,%edi
  80389b:	75 0b                	jne    8038a8 <__udivdi3+0x38>
  80389d:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a2:	31 d2                	xor    %edx,%edx
  8038a4:	f7 f7                	div    %edi
  8038a6:	89 c5                	mov    %eax,%ebp
  8038a8:	31 d2                	xor    %edx,%edx
  8038aa:	89 c8                	mov    %ecx,%eax
  8038ac:	f7 f5                	div    %ebp
  8038ae:	89 c1                	mov    %eax,%ecx
  8038b0:	89 d8                	mov    %ebx,%eax
  8038b2:	f7 f5                	div    %ebp
  8038b4:	89 cf                	mov    %ecx,%edi
  8038b6:	89 fa                	mov    %edi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	39 ce                	cmp    %ecx,%esi
  8038c2:	77 28                	ja     8038ec <__udivdi3+0x7c>
  8038c4:	0f bd fe             	bsr    %esi,%edi
  8038c7:	83 f7 1f             	xor    $0x1f,%edi
  8038ca:	75 40                	jne    80390c <__udivdi3+0x9c>
  8038cc:	39 ce                	cmp    %ecx,%esi
  8038ce:	72 0a                	jb     8038da <__udivdi3+0x6a>
  8038d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038d4:	0f 87 9e 00 00 00    	ja     803978 <__udivdi3+0x108>
  8038da:	b8 01 00 00 00       	mov    $0x1,%eax
  8038df:	89 fa                	mov    %edi,%edx
  8038e1:	83 c4 1c             	add    $0x1c,%esp
  8038e4:	5b                   	pop    %ebx
  8038e5:	5e                   	pop    %esi
  8038e6:	5f                   	pop    %edi
  8038e7:	5d                   	pop    %ebp
  8038e8:	c3                   	ret    
  8038e9:	8d 76 00             	lea    0x0(%esi),%esi
  8038ec:	31 ff                	xor    %edi,%edi
  8038ee:	31 c0                	xor    %eax,%eax
  8038f0:	89 fa                	mov    %edi,%edx
  8038f2:	83 c4 1c             	add    $0x1c,%esp
  8038f5:	5b                   	pop    %ebx
  8038f6:	5e                   	pop    %esi
  8038f7:	5f                   	pop    %edi
  8038f8:	5d                   	pop    %ebp
  8038f9:	c3                   	ret    
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	89 d8                	mov    %ebx,%eax
  8038fe:	f7 f7                	div    %edi
  803900:	31 ff                	xor    %edi,%edi
  803902:	89 fa                	mov    %edi,%edx
  803904:	83 c4 1c             	add    $0x1c,%esp
  803907:	5b                   	pop    %ebx
  803908:	5e                   	pop    %esi
  803909:	5f                   	pop    %edi
  80390a:	5d                   	pop    %ebp
  80390b:	c3                   	ret    
  80390c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803911:	89 eb                	mov    %ebp,%ebx
  803913:	29 fb                	sub    %edi,%ebx
  803915:	89 f9                	mov    %edi,%ecx
  803917:	d3 e6                	shl    %cl,%esi
  803919:	89 c5                	mov    %eax,%ebp
  80391b:	88 d9                	mov    %bl,%cl
  80391d:	d3 ed                	shr    %cl,%ebp
  80391f:	89 e9                	mov    %ebp,%ecx
  803921:	09 f1                	or     %esi,%ecx
  803923:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803927:	89 f9                	mov    %edi,%ecx
  803929:	d3 e0                	shl    %cl,%eax
  80392b:	89 c5                	mov    %eax,%ebp
  80392d:	89 d6                	mov    %edx,%esi
  80392f:	88 d9                	mov    %bl,%cl
  803931:	d3 ee                	shr    %cl,%esi
  803933:	89 f9                	mov    %edi,%ecx
  803935:	d3 e2                	shl    %cl,%edx
  803937:	8b 44 24 08          	mov    0x8(%esp),%eax
  80393b:	88 d9                	mov    %bl,%cl
  80393d:	d3 e8                	shr    %cl,%eax
  80393f:	09 c2                	or     %eax,%edx
  803941:	89 d0                	mov    %edx,%eax
  803943:	89 f2                	mov    %esi,%edx
  803945:	f7 74 24 0c          	divl   0xc(%esp)
  803949:	89 d6                	mov    %edx,%esi
  80394b:	89 c3                	mov    %eax,%ebx
  80394d:	f7 e5                	mul    %ebp
  80394f:	39 d6                	cmp    %edx,%esi
  803951:	72 19                	jb     80396c <__udivdi3+0xfc>
  803953:	74 0b                	je     803960 <__udivdi3+0xf0>
  803955:	89 d8                	mov    %ebx,%eax
  803957:	31 ff                	xor    %edi,%edi
  803959:	e9 58 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  80395e:	66 90                	xchg   %ax,%ax
  803960:	8b 54 24 08          	mov    0x8(%esp),%edx
  803964:	89 f9                	mov    %edi,%ecx
  803966:	d3 e2                	shl    %cl,%edx
  803968:	39 c2                	cmp    %eax,%edx
  80396a:	73 e9                	jae    803955 <__udivdi3+0xe5>
  80396c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80396f:	31 ff                	xor    %edi,%edi
  803971:	e9 40 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  803976:	66 90                	xchg   %ax,%ax
  803978:	31 c0                	xor    %eax,%eax
  80397a:	e9 37 ff ff ff       	jmp    8038b6 <__udivdi3+0x46>
  80397f:	90                   	nop

00803980 <__umoddi3>:
  803980:	55                   	push   %ebp
  803981:	57                   	push   %edi
  803982:	56                   	push   %esi
  803983:	53                   	push   %ebx
  803984:	83 ec 1c             	sub    $0x1c,%esp
  803987:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80398b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80398f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803993:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803997:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80399b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80399f:	89 f3                	mov    %esi,%ebx
  8039a1:	89 fa                	mov    %edi,%edx
  8039a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039a7:	89 34 24             	mov    %esi,(%esp)
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	75 1a                	jne    8039c8 <__umoddi3+0x48>
  8039ae:	39 f7                	cmp    %esi,%edi
  8039b0:	0f 86 a2 00 00 00    	jbe    803a58 <__umoddi3+0xd8>
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	89 f2                	mov    %esi,%edx
  8039ba:	f7 f7                	div    %edi
  8039bc:	89 d0                	mov    %edx,%eax
  8039be:	31 d2                	xor    %edx,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	39 f0                	cmp    %esi,%eax
  8039ca:	0f 87 ac 00 00 00    	ja     803a7c <__umoddi3+0xfc>
  8039d0:	0f bd e8             	bsr    %eax,%ebp
  8039d3:	83 f5 1f             	xor    $0x1f,%ebp
  8039d6:	0f 84 ac 00 00 00    	je     803a88 <__umoddi3+0x108>
  8039dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8039e1:	29 ef                	sub    %ebp,%edi
  8039e3:	89 fe                	mov    %edi,%esi
  8039e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039e9:	89 e9                	mov    %ebp,%ecx
  8039eb:	d3 e0                	shl    %cl,%eax
  8039ed:	89 d7                	mov    %edx,%edi
  8039ef:	89 f1                	mov    %esi,%ecx
  8039f1:	d3 ef                	shr    %cl,%edi
  8039f3:	09 c7                	or     %eax,%edi
  8039f5:	89 e9                	mov    %ebp,%ecx
  8039f7:	d3 e2                	shl    %cl,%edx
  8039f9:	89 14 24             	mov    %edx,(%esp)
  8039fc:	89 d8                	mov    %ebx,%eax
  8039fe:	d3 e0                	shl    %cl,%eax
  803a00:	89 c2                	mov    %eax,%edx
  803a02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a06:	d3 e0                	shl    %cl,%eax
  803a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a10:	89 f1                	mov    %esi,%ecx
  803a12:	d3 e8                	shr    %cl,%eax
  803a14:	09 d0                	or     %edx,%eax
  803a16:	d3 eb                	shr    %cl,%ebx
  803a18:	89 da                	mov    %ebx,%edx
  803a1a:	f7 f7                	div    %edi
  803a1c:	89 d3                	mov    %edx,%ebx
  803a1e:	f7 24 24             	mull   (%esp)
  803a21:	89 c6                	mov    %eax,%esi
  803a23:	89 d1                	mov    %edx,%ecx
  803a25:	39 d3                	cmp    %edx,%ebx
  803a27:	0f 82 87 00 00 00    	jb     803ab4 <__umoddi3+0x134>
  803a2d:	0f 84 91 00 00 00    	je     803ac4 <__umoddi3+0x144>
  803a33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a37:	29 f2                	sub    %esi,%edx
  803a39:	19 cb                	sbb    %ecx,%ebx
  803a3b:	89 d8                	mov    %ebx,%eax
  803a3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a41:	d3 e0                	shl    %cl,%eax
  803a43:	89 e9                	mov    %ebp,%ecx
  803a45:	d3 ea                	shr    %cl,%edx
  803a47:	09 d0                	or     %edx,%eax
  803a49:	89 e9                	mov    %ebp,%ecx
  803a4b:	d3 eb                	shr    %cl,%ebx
  803a4d:	89 da                	mov    %ebx,%edx
  803a4f:	83 c4 1c             	add    $0x1c,%esp
  803a52:	5b                   	pop    %ebx
  803a53:	5e                   	pop    %esi
  803a54:	5f                   	pop    %edi
  803a55:	5d                   	pop    %ebp
  803a56:	c3                   	ret    
  803a57:	90                   	nop
  803a58:	89 fd                	mov    %edi,%ebp
  803a5a:	85 ff                	test   %edi,%edi
  803a5c:	75 0b                	jne    803a69 <__umoddi3+0xe9>
  803a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a63:	31 d2                	xor    %edx,%edx
  803a65:	f7 f7                	div    %edi
  803a67:	89 c5                	mov    %eax,%ebp
  803a69:	89 f0                	mov    %esi,%eax
  803a6b:	31 d2                	xor    %edx,%edx
  803a6d:	f7 f5                	div    %ebp
  803a6f:	89 c8                	mov    %ecx,%eax
  803a71:	f7 f5                	div    %ebp
  803a73:	89 d0                	mov    %edx,%eax
  803a75:	e9 44 ff ff ff       	jmp    8039be <__umoddi3+0x3e>
  803a7a:	66 90                	xchg   %ax,%ax
  803a7c:	89 c8                	mov    %ecx,%eax
  803a7e:	89 f2                	mov    %esi,%edx
  803a80:	83 c4 1c             	add    $0x1c,%esp
  803a83:	5b                   	pop    %ebx
  803a84:	5e                   	pop    %esi
  803a85:	5f                   	pop    %edi
  803a86:	5d                   	pop    %ebp
  803a87:	c3                   	ret    
  803a88:	3b 04 24             	cmp    (%esp),%eax
  803a8b:	72 06                	jb     803a93 <__umoddi3+0x113>
  803a8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a91:	77 0f                	ja     803aa2 <__umoddi3+0x122>
  803a93:	89 f2                	mov    %esi,%edx
  803a95:	29 f9                	sub    %edi,%ecx
  803a97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a9b:	89 14 24             	mov    %edx,(%esp)
  803a9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aa6:	8b 14 24             	mov    (%esp),%edx
  803aa9:	83 c4 1c             	add    $0x1c,%esp
  803aac:	5b                   	pop    %ebx
  803aad:	5e                   	pop    %esi
  803aae:	5f                   	pop    %edi
  803aaf:	5d                   	pop    %ebp
  803ab0:	c3                   	ret    
  803ab1:	8d 76 00             	lea    0x0(%esi),%esi
  803ab4:	2b 04 24             	sub    (%esp),%eax
  803ab7:	19 fa                	sbb    %edi,%edx
  803ab9:	89 d1                	mov    %edx,%ecx
  803abb:	89 c6                	mov    %eax,%esi
  803abd:	e9 71 ff ff ff       	jmp    803a33 <__umoddi3+0xb3>
  803ac2:	66 90                	xchg   %ax,%ax
  803ac4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ac8:	72 ea                	jb     803ab4 <__umoddi3+0x134>
  803aca:	89 d9                	mov    %ebx,%ecx
  803acc:	e9 62 ff ff ff       	jmp    803a33 <__umoddi3+0xb3>
