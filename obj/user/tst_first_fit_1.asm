
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 67 28 00 00       	call   8028b0 <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 e0 3c 80 00       	push   $0x803ce0
  80009f:	6a 15                	push   $0x15
  8000a1:	68 fc 3c 80 00       	push   $0x803cfc
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 3a 1e 00 00       	call   801efd <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 bf 22 00 00       	call   80239b <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 57 23 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 07 1e 00 00       	call   801efd <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 14 3d 80 00       	push   $0x803d14
  80010e:	6a 26                	push   $0x26
  800110:	68 fc 3c 80 00       	push   $0x803cfc
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 1c 23 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 44 3d 80 00       	push   $0x803d44
  80012c:	6a 28                	push   $0x28
  80012e:	68 fc 3c 80 00       	push   $0x803cfc
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 5e 22 00 00       	call   80239b <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 61 3d 80 00       	push   $0x803d61
  80014e:	6a 29                	push   $0x29
  800150:	68 fc 3c 80 00       	push   $0x803cfc
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 3c 22 00 00       	call   80239b <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 d4 22 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 84 1d 00 00       	call   801efd <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 14 3d 80 00       	push   $0x803d14
  800198:	6a 2f                	push   $0x2f
  80019a:	68 fc 3c 80 00       	push   $0x803cfc
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 92 22 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 44 3d 80 00       	push   $0x803d44
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 fc 3c 80 00       	push   $0x803cfc
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 d4 21 00 00       	call   80239b <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 61 3d 80 00       	push   $0x803d61
  8001d8:	6a 32                	push   $0x32
  8001da:	68 fc 3c 80 00       	push   $0x803cfc
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 b2 21 00 00       	call   80239b <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 4a 22 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 fa 1c 00 00       	call   801efd <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 14 3d 80 00       	push   $0x803d14
  800224:	6a 38                	push   $0x38
  800226:	68 fc 3c 80 00       	push   $0x803cfc
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 06 22 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 44 3d 80 00       	push   $0x803d44
  800242:	6a 3a                	push   $0x3a
  800244:	68 fc 3c 80 00       	push   $0x803cfc
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 48 21 00 00       	call   80239b <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 61 3d 80 00       	push   $0x803d61
  800264:	6a 3b                	push   $0x3b
  800266:	68 fc 3c 80 00       	push   $0x803cfc
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 26 21 00 00       	call   80239b <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 be 21 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 6e 1c 00 00       	call   801efd <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 14 3d 80 00       	push   $0x803d14
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 fc 3c 80 00       	push   $0x803cfc
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 76 21 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 44 3d 80 00       	push   $0x803d44
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 fc 3c 80 00       	push   $0x803cfc
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 b8 20 00 00       	call   80239b <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 61 3d 80 00       	push   $0x803d61
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 fc 3c 80 00       	push   $0x803cfc
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 96 20 00 00       	call   80239b <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 2e 21 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 dc 1b 00 00       	call   801efd <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 14 3d 80 00       	push   $0x803d14
  800343:	6a 4a                	push   $0x4a
  800345:	68 fc 3c 80 00       	push   $0x803cfc
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 e7 20 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 44 3d 80 00       	push   $0x803d44
  800361:	6a 4c                	push   $0x4c
  800363:	68 fc 3c 80 00       	push   $0x803cfc
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 29 20 00 00       	call   80239b <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 61 3d 80 00       	push   $0x803d61
  800383:	6a 4d                	push   $0x4d
  800385:	68 fc 3c 80 00       	push   $0x803cfc
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 07 20 00 00       	call   80239b <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 9f 20 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 4d 1b 00 00       	call   801efd <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 14 3d 80 00       	push   $0x803d14
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 fc 3c 80 00       	push   $0x803cfc
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 53 20 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 44 3d 80 00       	push   $0x803d44
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 fc 3c 80 00       	push   $0x803cfc
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 95 1f 00 00       	call   80239b <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 61 3d 80 00       	push   $0x803d61
  800417:	6a 56                	push   $0x56
  800419:	68 fc 3c 80 00       	push   $0x803cfc
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 73 1f 00 00       	call   80239b <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 0b 20 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 b5 1a 00 00       	call   801efd <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 14 3d 80 00       	push   $0x803d14
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 fc 3c 80 00       	push   $0x803cfc
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 c0 1f 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 44 3d 80 00       	push   $0x803d44
  800488:	6a 5e                	push   $0x5e
  80048a:	68 fc 3c 80 00       	push   $0x803cfc
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 02 1f 00 00       	call   80239b <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 61 3d 80 00       	push   $0x803d61
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 fc 3c 80 00       	push   $0x803cfc
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 e0 1e 00 00       	call   80239b <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 78 1f 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 22 1a 00 00       	call   801efd <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 14 3d 80 00       	push   $0x803d14
  800505:	6a 65                	push   $0x65
  800507:	68 fc 3c 80 00       	push   $0x803cfc
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 25 1f 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 44 3d 80 00       	push   $0x803d44
  800523:	6a 67                	push   $0x67
  800525:	68 fc 3c 80 00       	push   $0x803cfc
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 67 1e 00 00       	call   80239b <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 61 3d 80 00       	push   $0x803d61
  800545:	6a 68                	push   $0x68
  800547:	68 fc 3c 80 00       	push   $0x803cfc
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 45 1e 00 00       	call   80239b <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 dd 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 29 1a 00 00       	call   801f96 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 c6 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 74 3d 80 00       	push   $0x803d74
  800582:	6a 72                	push   $0x72
  800584:	68 fc 3c 80 00       	push   $0x803cfc
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 08 1e 00 00       	call   80239b <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 8b 3d 80 00       	push   $0x803d8b
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 fc 3c 80 00       	push   $0x803cfc
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 e6 1d 00 00       	call   80239b <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 7e 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 ca 19 00 00       	call   801f96 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 67 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 74 3d 80 00       	push   $0x803d74
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 fc 3c 80 00       	push   $0x803cfc
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 a9 1d 00 00       	call   80239b <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 8b 3d 80 00       	push   $0x803d8b
  800603:	6a 7b                	push   $0x7b
  800605:	68 fc 3c 80 00       	push   $0x803cfc
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 87 1d 00 00       	call   80239b <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 1f 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 6b 19 00 00       	call   801f96 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 08 1e 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 74 3d 80 00       	push   $0x803d74
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 fc 3c 80 00       	push   $0x803cfc
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 47 1d 00 00       	call   80239b <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 8b 3d 80 00       	push   $0x803d8b
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 fc 3c 80 00       	push   $0x803cfc
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 22 1d 00 00       	call   80239b <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 ba 1d 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 66 18 00 00       	call   801efd <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 14 3d 80 00       	push   $0x803d14
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 fc 3c 80 00       	push   $0x803cfc
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 71 1d 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 44 3d 80 00       	push   $0x803d44
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 fc 3c 80 00       	push   $0x803cfc
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 b0 1c 00 00       	call   80239b <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 61 3d 80 00       	push   $0x803d61
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 fc 3c 80 00       	push   $0x803cfc
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 8b 1c 00 00       	call   80239b <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 23 1d 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 d3 17 00 00       	call   801efd <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 14 3d 80 00       	push   $0x803d14
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 fc 3c 80 00       	push   $0x803cfc
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 db 1c 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 44 3d 80 00       	push   $0x803d44
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 fc 3c 80 00       	push   $0x803cfc
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 1a 1c 00 00       	call   80239b <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 61 3d 80 00       	push   $0x803d61
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 fc 3c 80 00       	push   $0x803cfc
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 f5 1b 00 00       	call   80239b <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 8d 1c 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 39 17 00 00       	call   801efd <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 14 3d 80 00       	push   $0x803d14
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 fc 3c 80 00       	push   $0x803cfc
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 3a 1c 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 44 3d 80 00       	push   $0x803d44
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 fc 3c 80 00       	push   $0x803cfc
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 79 1b 00 00       	call   80239b <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 61 3d 80 00       	push   $0x803d61
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 fc 3c 80 00       	push   $0x803cfc
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 54 1b 00 00       	call   80239b <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 ec 1b 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 9d 16 00 00       	call   801efd <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 14 3d 80 00       	push   $0x803d14
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 fc 3c 80 00       	push   $0x803cfc
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 a5 1b 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 44 3d 80 00       	push   $0x803d44
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 fc 3c 80 00       	push   $0x803cfc
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 e4 1a 00 00       	call   80239b <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 61 3d 80 00       	push   $0x803d61
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 fc 3c 80 00       	push   $0x803cfc
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 bf 1a 00 00       	call   80239b <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 57 1b 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 04 16 00 00       	call   801efd <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 14 3d 80 00       	push   $0x803d14
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 fc 3c 80 00       	push   $0x803cfc
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 03 1b 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 44 3d 80 00       	push   $0x803d44
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 fc 3c 80 00       	push   $0x803cfc
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 42 1a 00 00       	call   80239b <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 61 3d 80 00       	push   $0x803d61
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 fc 3c 80 00       	push   $0x803cfc
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 1d 1a 00 00       	call   80239b <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 b5 1a 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 01 16 00 00       	call   801f96 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 9e 1a 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 74 3d 80 00       	push   $0x803d74
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 fc 3c 80 00       	push   $0x803cfc
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 dd 19 00 00       	call   80239b <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 8b 3d 80 00       	push   $0x803d8b
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 fc 3c 80 00       	push   $0x803cfc
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 b8 19 00 00       	call   80239b <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 50 1a 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 9c 15 00 00       	call   801f96 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 39 1a 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 74 3d 80 00       	push   $0x803d74
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 fc 3c 80 00       	push   $0x803cfc
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 78 19 00 00       	call   80239b <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 8b 3d 80 00       	push   $0x803d8b
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 fc 3c 80 00       	push   $0x803cfc
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 53 19 00 00       	call   80239b <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 eb 19 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 37 15 00 00       	call   801f96 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 d4 19 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 74 3d 80 00       	push   $0x803d74
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 fc 3c 80 00       	push   $0x803cfc
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 13 19 00 00       	call   80239b <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 8b 3d 80 00       	push   $0x803d8b
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 fc 3c 80 00       	push   $0x803cfc
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 ee 18 00 00       	call   80239b <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 86 19 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 29 14 00 00       	call   801efd <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 14 3d 80 00       	push   $0x803d14
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 fc 3c 80 00       	push   $0x803cfc
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 24 19 00 00       	call   80243b <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 44 3d 80 00       	push   $0x803d44
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 fc 3c 80 00       	push   $0x803cfc
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 63 18 00 00       	call   80239b <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 61 3d 80 00       	push   $0x803d61
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 fc 3c 80 00       	push   $0x803cfc
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 98 3d 80 00       	push   $0x803d98
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 02 1b 00 00       	call   80267b <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 a4 18 00 00       	call   802488 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 fc 3d 80 00       	push   $0x803dfc
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 24 3e 80 00       	push   $0x803e24
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 4c 3e 80 00       	push   $0x803e4c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 a4 3e 80 00       	push   $0x803ea4
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 fc 3d 80 00       	push   $0x803dfc
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 24 18 00 00       	call   8024a2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 b1 19 00 00       	call   802647 <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 06 1a 00 00       	call   8026ad <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 b8 3e 80 00       	push   $0x803eb8
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 bd 3e 80 00       	push   $0x803ebd
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 d9 3e 80 00       	push   $0x803ed9
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 dc 3e 80 00       	push   $0x803edc
  800d39:	6a 26                	push   $0x26
  800d3b:	68 28 3f 80 00       	push   $0x803f28
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 34 3f 80 00       	push   $0x803f34
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 28 3f 80 00       	push   $0x803f28
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 88 3f 80 00       	push   $0x803f88
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 28 3f 80 00       	push   $0x803f28
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 05 14 00 00       	call   8022da <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 8e 13 00 00       	call   8022da <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 f2 14 00 00       	call   802488 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 ec 14 00 00       	call   8024a2 <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 64 2a 00 00       	call   803a64 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 24 2b 00 00       	call   803b74 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 f4 41 80 00       	add    $0x8041f4,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 05 42 80 00       	push   $0x804205
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 0e 42 80 00       	push   $0x80420e
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be 11 42 80 00       	mov    $0x804211,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 70 43 80 00       	push   $0x804370
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801d1f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d26:	00 00 00 
  801d29:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d30:	00 00 00 
  801d33:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d3a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d3d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d44:	00 00 00 
  801d47:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d4e:	00 00 00 
  801d51:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d58:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801d5b:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	c1 e8 0c             	shr    $0xc,%eax
  801d68:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801d6d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d81:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801d86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801d8d:	a1 20 51 80 00       	mov    0x805120,%eax
  801d92:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801d96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801d99:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801da0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da6:	01 d0                	add    %edx,%eax
  801da8:	48                   	dec    %eax
  801da9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801daf:	ba 00 00 00 00       	mov    $0x0,%edx
  801db4:	f7 75 e4             	divl   -0x1c(%ebp)
  801db7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dba:	29 d0                	sub    %edx,%eax
  801dbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801dbf:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dce:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	6a 07                	push   $0x7
  801dd8:	ff 75 e8             	pushl  -0x18(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	e8 3d 06 00 00       	call   80241e <sys_allocate_chunk>
  801de1:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801de4:	a1 20 51 80 00       	mov    0x805120,%eax
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	50                   	push   %eax
  801ded:	e8 b2 0c 00 00       	call   802aa4 <initialize_MemBlocksList>
  801df2:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801df5:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801dfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801dfd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e01:	0f 84 f3 00 00 00    	je     801efa <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801e07:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e0b:	75 14                	jne    801e21 <initialize_dyn_block_system+0x108>
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 95 43 80 00       	push   $0x804395
  801e15:	6a 36                	push   $0x36
  801e17:	68 b3 43 80 00       	push   $0x8043b3
  801e1c:	e8 89 ee ff ff       	call   800caa <_panic>
  801e21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e24:	8b 00                	mov    (%eax),%eax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	74 10                	je     801e3a <initialize_dyn_block_system+0x121>
  801e2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e2d:	8b 00                	mov    (%eax),%eax
  801e2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e32:	8b 52 04             	mov    0x4(%edx),%edx
  801e35:	89 50 04             	mov    %edx,0x4(%eax)
  801e38:	eb 0b                	jmp    801e45 <initialize_dyn_block_system+0x12c>
  801e3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e3d:	8b 40 04             	mov    0x4(%eax),%eax
  801e40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e48:	8b 40 04             	mov    0x4(%eax),%eax
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	74 0f                	je     801e5e <initialize_dyn_block_system+0x145>
  801e4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e52:	8b 40 04             	mov    0x4(%eax),%eax
  801e55:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e58:	8b 12                	mov    (%edx),%edx
  801e5a:	89 10                	mov    %edx,(%eax)
  801e5c:	eb 0a                	jmp    801e68 <initialize_dyn_block_system+0x14f>
  801e5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e61:	8b 00                	mov    (%eax),%eax
  801e63:	a3 48 51 80 00       	mov    %eax,0x805148
  801e68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e7b:	a1 54 51 80 00       	mov    0x805154,%eax
  801e80:	48                   	dec    %eax
  801e81:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801e86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e89:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801e90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e93:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801e9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e9e:	75 14                	jne    801eb4 <initialize_dyn_block_system+0x19b>
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	68 c0 43 80 00       	push   $0x8043c0
  801ea8:	6a 3e                	push   $0x3e
  801eaa:	68 b3 43 80 00       	push   $0x8043b3
  801eaf:	e8 f6 ed ff ff       	call   800caa <_panic>
  801eb4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801eba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebd:	89 10                	mov    %edx,(%eax)
  801ebf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec2:	8b 00                	mov    (%eax),%eax
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	74 0d                	je     801ed5 <initialize_dyn_block_system+0x1bc>
  801ec8:	a1 38 51 80 00       	mov    0x805138,%eax
  801ecd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ed0:	89 50 04             	mov    %edx,0x4(%eax)
  801ed3:	eb 08                	jmp    801edd <initialize_dyn_block_system+0x1c4>
  801ed5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ed8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801edd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ee0:	a3 38 51 80 00       	mov    %eax,0x805138
  801ee5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ee8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eef:	a1 44 51 80 00       	mov    0x805144,%eax
  801ef4:	40                   	inc    %eax
  801ef5:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801f03:	e8 e0 fd ff ff       	call   801ce8 <InitializeUHeap>
		if (size == 0) return NULL ;
  801f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f0c:	75 07                	jne    801f15 <malloc+0x18>
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	eb 7f                	jmp    801f94 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f15:	e8 d2 08 00 00       	call   8027ec <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	74 71                	je     801f8f <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801f1e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f25:	8b 55 08             	mov    0x8(%ebp),%edx
  801f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	48                   	dec    %eax
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	ba 00 00 00 00       	mov    $0x0,%edx
  801f39:	f7 75 f4             	divl   -0xc(%ebp)
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	29 d0                	sub    %edx,%eax
  801f41:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801f44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801f4b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f52:	76 07                	jbe    801f5b <malloc+0x5e>
					return NULL ;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	eb 39                	jmp    801f94 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	e8 e6 0d 00 00       	call   802d4c <alloc_block_FF>
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801f6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f70:	74 16                	je     801f88 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	ff 75 ec             	pushl  -0x14(%ebp)
  801f78:	e8 37 0c 00 00       	call   802bb4 <insert_sorted_allocList>
  801f7d:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	eb 0c                	jmp    801f94 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	eb 05                	jmp    801f94 <malloc+0x97>
				}
		}
	return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801fa2:	83 ec 08             	sub    $0x8,%esp
  801fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa8:	68 40 50 80 00       	push   $0x805040
  801fad:	e8 cf 0b 00 00       	call   802b81 <find_block>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	8b 40 08             	mov    0x8(%eax),%eax
  801fc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801fca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fce:	0f 84 a1 00 00 00    	je     802075 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd8:	75 17                	jne    801ff1 <free+0x5b>
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	68 95 43 80 00       	push   $0x804395
  801fe2:	68 80 00 00 00       	push   $0x80
  801fe7:	68 b3 43 80 00       	push   $0x8043b3
  801fec:	e8 b9 ec ff ff       	call   800caa <_panic>
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	8b 00                	mov    (%eax),%eax
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	74 10                	je     80200a <free+0x74>
  801ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffd:	8b 00                	mov    (%eax),%eax
  801fff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802002:	8b 52 04             	mov    0x4(%edx),%edx
  802005:	89 50 04             	mov    %edx,0x4(%eax)
  802008:	eb 0b                	jmp    802015 <free+0x7f>
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 40 04             	mov    0x4(%eax),%eax
  802010:	a3 44 50 80 00       	mov    %eax,0x805044
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	8b 40 04             	mov    0x4(%eax),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	74 0f                	je     80202e <free+0x98>
  80201f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802022:	8b 40 04             	mov    0x4(%eax),%eax
  802025:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802028:	8b 12                	mov    (%edx),%edx
  80202a:	89 10                	mov    %edx,(%eax)
  80202c:	eb 0a                	jmp    802038 <free+0xa2>
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	a3 40 50 80 00       	mov    %eax,0x805040
  802038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80204b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802050:	48                   	dec    %eax
  802051:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  802056:	83 ec 0c             	sub    $0xc,%esp
  802059:	ff 75 f0             	pushl  -0x10(%ebp)
  80205c:	e8 29 12 00 00       	call   80328a <insert_sorted_with_merge_freeList>
  802061:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  802064:	83 ec 08             	sub    $0x8,%esp
  802067:	ff 75 ec             	pushl  -0x14(%ebp)
  80206a:	ff 75 e8             	pushl  -0x18(%ebp)
  80206d:	e8 74 03 00 00       	call   8023e6 <sys_free_user_mem>
  802072:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802075:	90                   	nop
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 38             	sub    $0x38,%esp
  80207e:	8b 45 10             	mov    0x10(%ebp),%eax
  802081:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802084:	e8 5f fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802089:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208d:	75 0a                	jne    802099 <smalloc+0x21>
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	e9 b2 00 00 00       	jmp    80214b <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802099:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8020a0:	76 0a                	jbe    8020ac <smalloc+0x34>
		return NULL;
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	e9 9f 00 00 00       	jmp    80214b <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8020ac:	e8 3b 07 00 00       	call   8027ec <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	0f 84 8d 00 00 00    	je     802146 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8020b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8020c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	48                   	dec    %eax
  8020d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020db:	f7 75 f0             	divl   -0x10(%ebp)
  8020de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e1:	29 d0                	sub    %edx,%eax
  8020e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8020ec:	e8 5b 0c 00 00       	call   802d4c <alloc_block_FF>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8020f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fb:	75 07                	jne    802104 <smalloc+0x8c>
			return NULL;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	eb 47                	jmp    80214b <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	ff 75 f4             	pushl  -0xc(%ebp)
  80210a:	e8 a5 0a 00 00       	call   802bb4 <insert_sorted_allocList>
  80210f:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 40 08             	mov    0x8(%eax),%eax
  802118:	89 c2                	mov    %eax,%edx
  80211a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80211e:	52                   	push   %edx
  80211f:	50                   	push   %eax
  802120:	ff 75 0c             	pushl  0xc(%ebp)
  802123:	ff 75 08             	pushl  0x8(%ebp)
  802126:	e8 46 04 00 00       	call   802571 <sys_createSharedObject>
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  802131:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802135:	78 08                	js     80213f <smalloc+0xc7>
		return (void *)b->sva;
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	eb 0c                	jmp    80214b <smalloc+0xd3>
		}else{
		return NULL;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
  802144:	eb 05                	jmp    80214b <smalloc+0xd3>
			}

	}return NULL;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802153:	e8 90 fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802158:	e8 8f 06 00 00       	call   8027ec <sys_isUHeapPlacementStrategyFIRSTFIT>
  80215d:	85 c0                	test   %eax,%eax
  80215f:	0f 84 ad 00 00 00    	je     802212 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802165:	83 ec 08             	sub    $0x8,%esp
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	ff 75 08             	pushl  0x8(%ebp)
  80216e:	e8 28 04 00 00       	call   80259b <sys_getSizeOfSharedObject>
  802173:	83 c4 10             	add    $0x10,%esp
  802176:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217d:	79 0a                	jns    802189 <sget+0x3c>
    {
    	return NULL;
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	e9 8e 00 00 00       	jmp    802217 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802189:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  802190:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219d:	01 d0                	add    %edx,%eax
  80219f:	48                   	dec    %eax
  8021a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ab:	f7 75 ec             	divl   -0x14(%ebp)
  8021ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b1:	29 d0                	sub    %edx,%eax
  8021b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8021b6:	83 ec 0c             	sub    $0xc,%esp
  8021b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021bc:	e8 8b 0b 00 00       	call   802d4c <alloc_block_FF>
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8021c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021cb:	75 07                	jne    8021d4 <sget+0x87>
				return NULL;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	eb 43                	jmp    802217 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8021da:	e8 d5 09 00 00       	call   802bb4 <insert_sorted_allocList>
  8021df:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8021e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e5:	8b 40 08             	mov    0x8(%eax),%eax
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	50                   	push   %eax
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	e8 c1 03 00 00       	call   8025b8 <sys_getSharedObject>
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8021fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802201:	78 08                	js     80220b <sget+0xbe>
			return (void *)b->sva;
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802206:	8b 40 08             	mov    0x8(%eax),%eax
  802209:	eb 0c                	jmp    802217 <sget+0xca>
			}else{
			return NULL;
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
  802210:	eb 05                	jmp    802217 <sget+0xca>
			}
    }}return NULL;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80221f:	e8 c4 fa ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	68 e4 43 80 00       	push   $0x8043e4
  80222c:	68 03 01 00 00       	push   $0x103
  802231:	68 b3 43 80 00       	push   $0x8043b3
  802236:	e8 6f ea ff ff       	call   800caa <_panic>

0080223b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 0c 44 80 00       	push   $0x80440c
  802249:	68 17 01 00 00       	push   $0x117
  80224e:	68 b3 43 80 00       	push   $0x8043b3
  802253:	e8 52 ea ff ff       	call   800caa <_panic>

00802258 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	68 30 44 80 00       	push   $0x804430
  802266:	68 22 01 00 00       	push   $0x122
  80226b:	68 b3 43 80 00       	push   $0x8043b3
  802270:	e8 35 ea ff ff       	call   800caa <_panic>

00802275 <shrink>:

}
void shrink(uint32 newSize)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 30 44 80 00       	push   $0x804430
  802283:	68 27 01 00 00       	push   $0x127
  802288:	68 b3 43 80 00       	push   $0x8043b3
  80228d:	e8 18 ea ff ff       	call   800caa <_panic>

00802292 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 30 44 80 00       	push   $0x804430
  8022a0:	68 2c 01 00 00       	push   $0x12c
  8022a5:	68 b3 43 80 00       	push   $0x8043b3
  8022aa:	e8 fb e9 ff ff       	call   800caa <_panic>

008022af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	57                   	push   %edi
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022ca:	cd 30                	int    $0x30
  8022cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5f                   	pop    %edi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    

008022da <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	52                   	push   %edx
  8022f2:	ff 75 0c             	pushl  0xc(%ebp)
  8022f5:	50                   	push   %eax
  8022f6:	6a 00                	push   $0x0
  8022f8:	e8 b2 ff ff ff       	call   8022af <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	90                   	nop
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_cgetc>:

int
sys_cgetc(void)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 01                	push   $0x1
  802312:	e8 98 ff ff ff       	call   8022af <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80231f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	52                   	push   %edx
  80232c:	50                   	push   %eax
  80232d:	6a 05                	push   $0x5
  80232f:	e8 7b ff ff ff       	call   8022af <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	56                   	push   %esi
  80233d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80233e:	8b 75 18             	mov    0x18(%ebp),%esi
  802341:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802344:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	56                   	push   %esi
  80234e:	53                   	push   %ebx
  80234f:	51                   	push   %ecx
  802350:	52                   	push   %edx
  802351:	50                   	push   %eax
  802352:	6a 06                	push   $0x6
  802354:	e8 56 ff ff ff       	call   8022af <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    

00802363 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802366:	8b 55 0c             	mov    0xc(%ebp),%edx
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	52                   	push   %edx
  802373:	50                   	push   %eax
  802374:	6a 07                	push   $0x7
  802376:	e8 34 ff ff ff       	call   8022af <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	ff 75 0c             	pushl  0xc(%ebp)
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	6a 08                	push   $0x8
  802391:	e8 19 ff ff ff       	call   8022af <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 09                	push   $0x9
  8023aa:	e8 00 ff ff ff       	call   8022af <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 0a                	push   $0xa
  8023c3:	e8 e7 fe ff ff       	call   8022af <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 0b                	push   $0xb
  8023dc:	e8 ce fe ff ff       	call   8022af <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	ff 75 0c             	pushl  0xc(%ebp)
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	6a 0f                	push   $0xf
  8023f7:	e8 b3 fe ff ff       	call   8022af <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
	return;
  8023ff:	90                   	nop
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	ff 75 08             	pushl  0x8(%ebp)
  802411:	6a 10                	push   $0x10
  802413:	e8 97 fe ff ff       	call   8022af <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
	return ;
  80241b:	90                   	nop
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	ff 75 10             	pushl  0x10(%ebp)
  802428:	ff 75 0c             	pushl  0xc(%ebp)
  80242b:	ff 75 08             	pushl  0x8(%ebp)
  80242e:	6a 11                	push   $0x11
  802430:	e8 7a fe ff ff       	call   8022af <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
	return ;
  802438:	90                   	nop
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 0c                	push   $0xc
  80244a:	e8 60 fe ff ff       	call   8022af <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	ff 75 08             	pushl  0x8(%ebp)
  802462:	6a 0d                	push   $0xd
  802464:	e8 46 fe ff ff       	call   8022af <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
}
  80246c:	c9                   	leave  
  80246d:	c3                   	ret    

0080246e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 0e                	push   $0xe
  80247d:	e8 2d fe ff ff       	call   8022af <syscall>
  802482:	83 c4 18             	add    $0x18,%esp
}
  802485:	90                   	nop
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 13                	push   $0x13
  802497:	e8 13 fe ff ff       	call   8022af <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
}
  80249f:	90                   	nop
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 14                	push   $0x14
  8024b1:	e8 f9 fd ff ff       	call   8022af <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	90                   	nop
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_cputc>:


void
sys_cputc(const char c)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	50                   	push   %eax
  8024d5:	6a 15                	push   $0x15
  8024d7:	e8 d3 fd ff ff       	call   8022af <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	90                   	nop
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 16                	push   $0x16
  8024f1:	e8 b9 fd ff ff       	call   8022af <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
}
  8024f9:	90                   	nop
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	ff 75 0c             	pushl  0xc(%ebp)
  80250b:	50                   	push   %eax
  80250c:	6a 17                	push   $0x17
  80250e:	e8 9c fd ff ff       	call   8022af <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80251b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	52                   	push   %edx
  802528:	50                   	push   %eax
  802529:	6a 1a                	push   $0x1a
  80252b:	e8 7f fd ff ff       	call   8022af <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	52                   	push   %edx
  802545:	50                   	push   %eax
  802546:	6a 18                	push   $0x18
  802548:	e8 62 fd ff ff       	call   8022af <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	90                   	nop
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802556:	8b 55 0c             	mov    0xc(%ebp),%edx
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	52                   	push   %edx
  802563:	50                   	push   %eax
  802564:	6a 19                	push   $0x19
  802566:	e8 44 fd ff ff       	call   8022af <syscall>
  80256b:	83 c4 18             	add    $0x18,%esp
}
  80256e:	90                   	nop
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	8b 45 10             	mov    0x10(%ebp),%eax
  80257a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80257d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802580:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	51                   	push   %ecx
  80258a:	52                   	push   %edx
  80258b:	ff 75 0c             	pushl  0xc(%ebp)
  80258e:	50                   	push   %eax
  80258f:	6a 1b                	push   $0x1b
  802591:	e8 19 fd ff ff       	call   8022af <syscall>
  802596:	83 c4 18             	add    $0x18,%esp
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80259e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	52                   	push   %edx
  8025ab:	50                   	push   %eax
  8025ac:	6a 1c                	push   $0x1c
  8025ae:	e8 fc fc ff ff       	call   8022af <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	51                   	push   %ecx
  8025c9:	52                   	push   %edx
  8025ca:	50                   	push   %eax
  8025cb:	6a 1d                	push   $0x1d
  8025cd:	e8 dd fc ff ff       	call   8022af <syscall>
  8025d2:	83 c4 18             	add    $0x18,%esp
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	52                   	push   %edx
  8025e7:	50                   	push   %eax
  8025e8:	6a 1e                	push   $0x1e
  8025ea:	e8 c0 fc ff ff       	call   8022af <syscall>
  8025ef:	83 c4 18             	add    $0x18,%esp
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 1f                	push   $0x1f
  802603:	e8 a7 fc ff ff       	call   8022af <syscall>
  802608:	83 c4 18             	add    $0x18,%esp
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	6a 00                	push   $0x0
  802615:	ff 75 14             	pushl  0x14(%ebp)
  802618:	ff 75 10             	pushl  0x10(%ebp)
  80261b:	ff 75 0c             	pushl  0xc(%ebp)
  80261e:	50                   	push   %eax
  80261f:	6a 20                	push   $0x20
  802621:	e8 89 fc ff ff       	call   8022af <syscall>
  802626:	83 c4 18             	add    $0x18,%esp
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	50                   	push   %eax
  80263a:	6a 21                	push   $0x21
  80263c:	e8 6e fc ff ff       	call   8022af <syscall>
  802641:	83 c4 18             	add    $0x18,%esp
}
  802644:	90                   	nop
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	50                   	push   %eax
  802656:	6a 22                	push   $0x22
  802658:	e8 52 fc ff ff       	call   8022af <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 02                	push   $0x2
  802671:	e8 39 fc ff ff       	call   8022af <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 03                	push   $0x3
  80268a:	e8 20 fc ff ff       	call   8022af <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
}
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 04                	push   $0x4
  8026a3:	e8 07 fc ff ff       	call   8022af <syscall>
  8026a8:	83 c4 18             	add    $0x18,%esp
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_exit_env>:


void sys_exit_env(void)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 23                	push   $0x23
  8026bc:	e8 ee fb ff ff       	call   8022af <syscall>
  8026c1:	83 c4 18             	add    $0x18,%esp
}
  8026c4:	90                   	nop
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026d0:	8d 50 04             	lea    0x4(%eax),%edx
  8026d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	52                   	push   %edx
  8026dd:	50                   	push   %eax
  8026de:	6a 24                	push   $0x24
  8026e0:	e8 ca fb ff ff       	call   8022af <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
	return result;
  8026e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026f1:	89 01                	mov    %eax,(%ecx)
  8026f3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	c9                   	leave  
  8026fa:	c2 04 00             	ret    $0x4

008026fd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	ff 75 10             	pushl  0x10(%ebp)
  802707:	ff 75 0c             	pushl  0xc(%ebp)
  80270a:	ff 75 08             	pushl  0x8(%ebp)
  80270d:	6a 12                	push   $0x12
  80270f:	e8 9b fb ff ff       	call   8022af <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
	return ;
  802717:	90                   	nop
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <sys_rcr2>:
uint32 sys_rcr2()
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 25                	push   $0x25
  802729:	e8 81 fb ff ff       	call   8022af <syscall>
  80272e:	83 c4 18             	add    $0x18,%esp
}
  802731:	c9                   	leave  
  802732:	c3                   	ret    

00802733 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80273f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	50                   	push   %eax
  80274c:	6a 26                	push   $0x26
  80274e:	e8 5c fb ff ff       	call   8022af <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
	return ;
  802756:	90                   	nop
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <rsttst>:
void rsttst()
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 28                	push   $0x28
  802768:	e8 42 fb ff ff       	call   8022af <syscall>
  80276d:	83 c4 18             	add    $0x18,%esp
	return ;
  802770:	90                   	nop
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	8b 45 14             	mov    0x14(%ebp),%eax
  80277c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80277f:	8b 55 18             	mov    0x18(%ebp),%edx
  802782:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802786:	52                   	push   %edx
  802787:	50                   	push   %eax
  802788:	ff 75 10             	pushl  0x10(%ebp)
  80278b:	ff 75 0c             	pushl  0xc(%ebp)
  80278e:	ff 75 08             	pushl  0x8(%ebp)
  802791:	6a 27                	push   $0x27
  802793:	e8 17 fb ff ff       	call   8022af <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
	return ;
  80279b:	90                   	nop
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <chktst>:
void chktst(uint32 n)
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	ff 75 08             	pushl  0x8(%ebp)
  8027ac:	6a 29                	push   $0x29
  8027ae:	e8 fc fa ff ff       	call   8022af <syscall>
  8027b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b6:	90                   	nop
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <inctst>:

void inctst()
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 2a                	push   $0x2a
  8027c8:	e8 e2 fa ff ff       	call   8022af <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d0:	90                   	nop
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <gettst>:
uint32 gettst()
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 2b                	push   $0x2b
  8027e2:	e8 c8 fa ff ff       	call   8022af <syscall>
  8027e7:	83 c4 18             	add    $0x18,%esp
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 2c                	push   $0x2c
  8027fe:	e8 ac fa ff ff       	call   8022af <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
  802806:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802809:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80280d:	75 07                	jne    802816 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80280f:	b8 01 00 00 00       	mov    $0x1,%eax
  802814:	eb 05                	jmp    80281b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802816:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 2c                	push   $0x2c
  80282f:	e8 7b fa ff ff       	call   8022af <syscall>
  802834:	83 c4 18             	add    $0x18,%esp
  802837:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80283a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80283e:	75 07                	jne    802847 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802840:	b8 01 00 00 00       	mov    $0x1,%eax
  802845:	eb 05                	jmp    80284c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284c:	c9                   	leave  
  80284d:	c3                   	ret    

0080284e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 2c                	push   $0x2c
  802860:	e8 4a fa ff ff       	call   8022af <syscall>
  802865:	83 c4 18             	add    $0x18,%esp
  802868:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80286b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80286f:	75 07                	jne    802878 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802871:	b8 01 00 00 00       	mov    $0x1,%eax
  802876:	eb 05                	jmp    80287d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 2c                	push   $0x2c
  802891:	e8 19 fa ff ff       	call   8022af <syscall>
  802896:	83 c4 18             	add    $0x18,%esp
  802899:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80289c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028a0:	75 07                	jne    8028a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a7:	eb 05                	jmp    8028ae <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	ff 75 08             	pushl  0x8(%ebp)
  8028be:	6a 2d                	push   $0x2d
  8028c0:	e8 ea f9 ff ff       	call   8022af <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c8:	90                   	nop
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	6a 00                	push   $0x0
  8028dd:	53                   	push   %ebx
  8028de:	51                   	push   %ecx
  8028df:	52                   	push   %edx
  8028e0:	50                   	push   %eax
  8028e1:	6a 2e                	push   $0x2e
  8028e3:	e8 c7 f9 ff ff       	call   8022af <syscall>
  8028e8:	83 c4 18             	add    $0x18,%esp
}
  8028eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	52                   	push   %edx
  802900:	50                   	push   %eax
  802901:	6a 2f                	push   $0x2f
  802903:	e8 a7 f9 ff ff       	call   8022af <syscall>
  802908:	83 c4 18             	add    $0x18,%esp
}
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	68 40 44 80 00       	push   $0x804440
  80291b:	e8 3e e6 ff ff       	call   800f5e <cprintf>
  802920:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802923:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	68 6c 44 80 00       	push   $0x80446c
  802932:	e8 27 e6 ff ff       	call   800f5e <cprintf>
  802937:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80293a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80293e:	a1 38 51 80 00       	mov    0x805138,%eax
  802943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802946:	eb 56                	jmp    80299e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802948:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80294c:	74 1c                	je     80296a <print_mem_block_lists+0x5d>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 50 08             	mov    0x8(%eax),%edx
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	8b 48 08             	mov    0x8(%eax),%ecx
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	8b 40 0c             	mov    0xc(%eax),%eax
  802960:	01 c8                	add    %ecx,%eax
  802962:	39 c2                	cmp    %eax,%edx
  802964:	73 04                	jae    80296a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802966:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	01 c2                	add    %eax,%edx
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 08             	mov    0x8(%eax),%eax
  80297e:	83 ec 04             	sub    $0x4,%esp
  802981:	52                   	push   %edx
  802982:	50                   	push   %eax
  802983:	68 81 44 80 00       	push   $0x804481
  802988:	e8 d1 e5 ff ff       	call   800f5e <cprintf>
  80298d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802996:	a1 40 51 80 00       	mov    0x805140,%eax
  80299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a2:	74 07                	je     8029ab <print_mem_block_lists+0x9e>
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	eb 05                	jmp    8029b0 <print_mem_block_lists+0xa3>
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	75 8a                	jne    802948 <print_mem_block_lists+0x3b>
  8029be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c2:	75 84                	jne    802948 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029c8:	75 10                	jne    8029da <print_mem_block_lists+0xcd>
  8029ca:	83 ec 0c             	sub    $0xc,%esp
  8029cd:	68 90 44 80 00       	push   $0x804490
  8029d2:	e8 87 e5 ff ff       	call   800f5e <cprintf>
  8029d7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029e1:	83 ec 0c             	sub    $0xc,%esp
  8029e4:	68 b4 44 80 00       	push   $0x8044b4
  8029e9:	e8 70 e5 ff ff       	call   800f5e <cprintf>
  8029ee:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029f1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8029fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fd:	eb 56                	jmp    802a55 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a03:	74 1c                	je     802a21 <print_mem_block_lists+0x114>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 50 08             	mov    0x8(%eax),%edx
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	8b 48 08             	mov    0x8(%eax),%ecx
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	01 c8                	add    %ecx,%eax
  802a19:	39 c2                	cmp    %eax,%edx
  802a1b:	73 04                	jae    802a21 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a1d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 50 08             	mov    0x8(%eax),%edx
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	52                   	push   %edx
  802a39:	50                   	push   %eax
  802a3a:	68 81 44 80 00       	push   $0x804481
  802a3f:	e8 1a e5 ff ff       	call   800f5e <cprintf>
  802a44:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a4d:	a1 48 50 80 00       	mov    0x805048,%eax
  802a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	74 07                	je     802a62 <print_mem_block_lists+0x155>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	eb 05                	jmp    802a67 <print_mem_block_lists+0x15a>
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	a3 48 50 80 00       	mov    %eax,0x805048
  802a6c:	a1 48 50 80 00       	mov    0x805048,%eax
  802a71:	85 c0                	test   %eax,%eax
  802a73:	75 8a                	jne    8029ff <print_mem_block_lists+0xf2>
  802a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a79:	75 84                	jne    8029ff <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a7b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a7f:	75 10                	jne    802a91 <print_mem_block_lists+0x184>
  802a81:	83 ec 0c             	sub    $0xc,%esp
  802a84:	68 cc 44 80 00       	push   $0x8044cc
  802a89:	e8 d0 e4 ff ff       	call   800f5e <cprintf>
  802a8e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a91:	83 ec 0c             	sub    $0xc,%esp
  802a94:	68 40 44 80 00       	push   $0x804440
  802a99:	e8 c0 e4 ff ff       	call   800f5e <cprintf>
  802a9e:	83 c4 10             	add    $0x10,%esp

}
  802aa1:	90                   	nop
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
  802aa7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802aaa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802ab1:	00 00 00 
  802ab4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802abb:	00 00 00 
  802abe:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ac5:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802acf:	e9 9e 00 00 00       	jmp    802b72 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802ad4:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adc:	c1 e2 04             	shl    $0x4,%edx
  802adf:	01 d0                	add    %edx,%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	75 14                	jne    802af9 <initialize_MemBlocksList+0x55>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 f4 44 80 00       	push   $0x8044f4
  802aed:	6a 3d                	push   $0x3d
  802aef:	68 17 45 80 00       	push   $0x804517
  802af4:	e8 b1 e1 ff ff       	call   800caa <_panic>
  802af9:	a1 50 50 80 00       	mov    0x805050,%eax
  802afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b01:	c1 e2 04             	shl    $0x4,%edx
  802b04:	01 d0                	add    %edx,%eax
  802b06:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 18                	je     802b2c <initialize_MemBlocksList+0x88>
  802b14:	a1 48 51 80 00       	mov    0x805148,%eax
  802b19:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b1f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b22:	c1 e1 04             	shl    $0x4,%ecx
  802b25:	01 ca                	add    %ecx,%edx
  802b27:	89 50 04             	mov    %edx,0x4(%eax)
  802b2a:	eb 12                	jmp    802b3e <initialize_MemBlocksList+0x9a>
  802b2c:	a1 50 50 80 00       	mov    0x805050,%eax
  802b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b34:	c1 e2 04             	shl    $0x4,%edx
  802b37:	01 d0                	add    %edx,%eax
  802b39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3e:	a1 50 50 80 00       	mov    0x805050,%eax
  802b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b46:	c1 e2 04             	shl    $0x4,%edx
  802b49:	01 d0                	add    %edx,%eax
  802b4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b50:	a1 50 50 80 00       	mov    0x805050,%eax
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	c1 e2 04             	shl    $0x4,%edx
  802b5b:	01 d0                	add    %edx,%eax
  802b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b64:	a1 54 51 80 00       	mov    0x805154,%eax
  802b69:	40                   	inc    %eax
  802b6a:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802b6f:	ff 45 f4             	incl   -0xc(%ebp)
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b78:	0f 82 56 ff ff ff    	jb     802ad4 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802b7e:	90                   	nop
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802b8f:	eb 18                	jmp    802ba9 <find_block+0x28>

		if(tmp->sva == va){
  802b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b94:	8b 40 08             	mov    0x8(%eax),%eax
  802b97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b9a:	75 05                	jne    802ba1 <find_block+0x20>
			return tmp ;
  802b9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b9f:	eb 11                	jmp    802bb2 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bad:	75 e2                	jne    802b91 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    

00802bb4 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
  802bb7:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802bba:	a1 40 50 80 00       	mov    0x805040,%eax
  802bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802bc2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bce:	75 65                	jne    802c35 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd4:	75 14                	jne    802bea <insert_sorted_allocList+0x36>
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	68 f4 44 80 00       	push   $0x8044f4
  802bde:	6a 62                	push   $0x62
  802be0:	68 17 45 80 00       	push   $0x804517
  802be5:	e8 c0 e0 ff ff       	call   800caa <_panic>
  802bea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	89 10                	mov    %edx,(%eax)
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 0d                	je     802c0b <insert_sorted_allocList+0x57>
  802bfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802c03:	8b 55 08             	mov    0x8(%ebp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 08                	jmp    802c13 <insert_sorted_allocList+0x5f>
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	a3 44 50 80 00       	mov    %eax,0x805044
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	a3 40 50 80 00       	mov    %eax,0x805040
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c25:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c2a:	40                   	inc    %eax
  802c2b:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c30:	e9 14 01 00 00       	jmp    802d49 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	a1 44 50 80 00       	mov    0x805044,%eax
  802c40:	8b 40 08             	mov    0x8(%eax),%eax
  802c43:	39 c2                	cmp    %eax,%edx
  802c45:	76 65                	jbe    802cac <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802c47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4b:	75 14                	jne    802c61 <insert_sorted_allocList+0xad>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 30 45 80 00       	push   $0x804530
  802c55:	6a 64                	push   $0x64
  802c57:	68 17 45 80 00       	push   $0x804517
  802c5c:	e8 49 e0 ff ff       	call   800caa <_panic>
  802c61:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0c                	je     802c83 <insert_sorted_allocList+0xcf>
  802c77:	a1 44 50 80 00       	mov    0x805044,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	eb 08                	jmp    802c8b <insert_sorted_allocList+0xd7>
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	a3 40 50 80 00       	mov    %eax,0x805040
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	a3 44 50 80 00       	mov    %eax,0x805044
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca1:	40                   	inc    %eax
  802ca2:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ca7:	e9 9d 00 00 00       	jmp    802d49 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802cac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802cb3:	e9 85 00 00 00       	jmp    802d3d <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	39 c2                	cmp    %eax,%edx
  802cc6:	73 6a                	jae    802d32 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccc:	74 06                	je     802cd4 <insert_sorted_allocList+0x120>
  802cce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd2:	75 14                	jne    802ce8 <insert_sorted_allocList+0x134>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 54 45 80 00       	push   $0x804554
  802cdc:	6a 6b                	push   $0x6b
  802cde:	68 17 45 80 00       	push   $0x804517
  802ce3:	e8 c2 df ff ff       	call   800caa <_panic>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 50 04             	mov    0x4(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0d                	je     802d13 <insert_sorted_allocList+0x15f>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	eb 08                	jmp    802d1b <insert_sorted_allocList+0x167>
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	a3 40 50 80 00       	mov    %eax,0x805040
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d29:	40                   	inc    %eax
  802d2a:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802d2f:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d30:	eb 17                	jmp    802d49 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802d3a:	ff 45 f0             	incl   -0x10(%ebp)
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d43:	0f 8c 6f ff ff ff    	jl     802cb8 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d49:	90                   	nop
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
  802d4f:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802d52:	a1 38 51 80 00       	mov    0x805138,%eax
  802d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802d5a:	e9 7c 01 00 00       	jmp    802edb <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 0c             	mov    0xc(%eax),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 86 cf 00 00 00    	jbe    802e3d <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 50 08             	mov    0x8(%eax),%edx
  802d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8e:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	2b 45 08             	sub    0x8(%ebp),%eax
  802d9a:	89 c2                	mov    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802db3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db7:	75 17                	jne    802dd0 <alloc_block_FF+0x84>
  802db9:	83 ec 04             	sub    $0x4,%esp
  802dbc:	68 89 45 80 00       	push   $0x804589
  802dc1:	68 83 00 00 00       	push   $0x83
  802dc6:	68 17 45 80 00       	push   $0x804517
  802dcb:	e8 da de ff ff       	call   800caa <_panic>
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 10                	je     802de9 <alloc_block_FF+0x9d>
  802dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de1:	8b 52 04             	mov    0x4(%edx),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 0b                	jmp    802df4 <alloc_block_FF+0xa8>
  802de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 0f                	je     802e0d <alloc_block_FF+0xc1>
  802dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e07:	8b 12                	mov    (%edx),%edx
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	eb 0a                	jmp    802e17 <alloc_block_FF+0xcb>
  802e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	a3 48 51 80 00       	mov    %eax,0x805148
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2f:	48                   	dec    %eax
  802e30:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e38:	e9 ad 00 00 00       	jmp    802eea <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e46:	0f 85 87 00 00 00    	jne    802ed3 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	75 17                	jne    802e69 <alloc_block_FF+0x11d>
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	68 89 45 80 00       	push   $0x804589
  802e5a:	68 87 00 00 00       	push   $0x87
  802e5f:	68 17 45 80 00       	push   $0x804517
  802e64:	e8 41 de ff ff       	call   800caa <_panic>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 10                	je     802e82 <alloc_block_FF+0x136>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	8b 52 04             	mov    0x4(%edx),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	eb 0b                	jmp    802e8d <alloc_block_FF+0x141>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0f                	je     802ea6 <alloc_block_FF+0x15a>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 04             	mov    0x4(%eax),%eax
  802e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea0:	8b 12                	mov    (%edx),%edx
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	eb 0a                	jmp    802eb0 <alloc_block_FF+0x164>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec8:	48                   	dec    %eax
  802ec9:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	eb 17                	jmp    802eea <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edf:	0f 85 7a fe ff ff    	jne    802d5f <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802ef2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802efa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802f01:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802f08:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f10:	e9 d0 00 00 00       	jmp    802fe5 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1e:	0f 82 b8 00 00 00    	jb     802fdc <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f36:	0f 83 a1 00 00 00    	jae    802fdd <alloc_block_BF+0xf1>
				differsize = differance ;
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802f48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f4c:	0f 85 8b 00 00 00    	jne    802fdd <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	75 17                	jne    802f6f <alloc_block_BF+0x83>
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	68 89 45 80 00       	push   $0x804589
  802f60:	68 a0 00 00 00       	push   $0xa0
  802f65:	68 17 45 80 00       	push   $0x804517
  802f6a:	e8 3b dd ff ff       	call   800caa <_panic>
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 10                	je     802f88 <alloc_block_BF+0x9c>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f80:	8b 52 04             	mov    0x4(%edx),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 0b                	jmp    802f93 <alloc_block_BF+0xa7>
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0f                	je     802fac <alloc_block_BF+0xc0>
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa6:	8b 12                	mov    (%edx),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	eb 0a                	jmp    802fb6 <alloc_block_BF+0xca>
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fce:	48                   	dec    %eax
  802fcf:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	e9 0c 01 00 00       	jmp    8030e8 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802fdc:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802fdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	74 07                	je     802ff2 <alloc_block_BF+0x106>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	eb 05                	jmp    802ff7 <alloc_block_BF+0x10b>
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	a3 40 51 80 00       	mov    %eax,0x805140
  802ffc:	a1 40 51 80 00       	mov    0x805140,%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	0f 85 0c ff ff ff    	jne    802f15 <alloc_block_BF+0x29>
  803009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300d:	0f 85 02 ff ff ff    	jne    802f15 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  803013:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803017:	0f 84 c6 00 00 00    	je     8030e3 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80301d:	a1 48 51 80 00       	mov    0x805148,%eax
  803022:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  803025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803028:	8b 55 08             	mov    0x8(%ebp),%edx
  80302b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80302e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803031:	8b 50 08             	mov    0x8(%eax),%edx
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	8b 40 0c             	mov    0xc(%eax),%eax
  803040:	2b 45 08             	sub    0x8(%ebp),%eax
  803043:	89 c2                	mov    %eax,%edx
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	01 c2                	add    %eax,%edx
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80305c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803060:	75 17                	jne    803079 <alloc_block_BF+0x18d>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 89 45 80 00       	push   $0x804589
  80306a:	68 af 00 00 00       	push   $0xaf
  80306f:	68 17 45 80 00       	push   $0x804517
  803074:	e8 31 dc ff ff       	call   800caa <_panic>
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 10                	je     803092 <alloc_block_BF+0x1a6>
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308a:	8b 52 04             	mov    0x4(%edx),%edx
  80308d:	89 50 04             	mov    %edx,0x4(%eax)
  803090:	eb 0b                	jmp    80309d <alloc_block_BF+0x1b1>
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0f                	je     8030b6 <alloc_block_BF+0x1ca>
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b0:	8b 12                	mov    (%edx),%edx
  8030b2:	89 10                	mov    %edx,(%eax)
  8030b4:	eb 0a                	jmp    8030c0 <alloc_block_BF+0x1d4>
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d8:	48                   	dec    %eax
  8030d9:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	eb 05                	jmp    8030e8 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8030e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    

008030ea <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
  8030ed:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8030f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8030f8:	e9 7c 01 00 00       	jmp    803279 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	3b 45 08             	cmp    0x8(%ebp),%eax
  803106:	0f 86 cf 00 00 00    	jbe    8031db <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80310c:	a1 48 51 80 00       	mov    0x805148,%eax
  803111:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	8b 55 08             	mov    0x8(%ebp),%edx
  803120:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 50 08             	mov    0x8(%eax),%edx
  803129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312c:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	2b 45 08             	sub    0x8(%ebp),%eax
  803138:	89 c2                	mov    %eax,%edx
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 50 08             	mov    0x8(%eax),%edx
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	01 c2                	add    %eax,%edx
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803151:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803155:	75 17                	jne    80316e <alloc_block_NF+0x84>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 89 45 80 00       	push   $0x804589
  80315f:	68 c4 00 00 00       	push   $0xc4
  803164:	68 17 45 80 00       	push   $0x804517
  803169:	e8 3c db ff ff       	call   800caa <_panic>
  80316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 10                	je     803187 <alloc_block_NF+0x9d>
  803177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317f:	8b 52 04             	mov    0x4(%edx),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	eb 0b                	jmp    803192 <alloc_block_NF+0xa8>
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 0f                	je     8031ab <alloc_block_NF+0xc1>
  80319c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a5:	8b 12                	mov    (%edx),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	eb 0a                	jmp    8031b5 <alloc_block_NF+0xcb>
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cd:	48                   	dec    %eax
  8031ce:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8031d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d6:	e9 ad 00 00 00       	jmp    803288 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e4:	0f 85 87 00 00 00    	jne    803271 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8031ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ee:	75 17                	jne    803207 <alloc_block_NF+0x11d>
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 89 45 80 00       	push   $0x804589
  8031f8:	68 c8 00 00 00       	push   $0xc8
  8031fd:	68 17 45 80 00       	push   $0x804517
  803202:	e8 a3 da ff ff       	call   800caa <_panic>
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 10                	je     803220 <alloc_block_NF+0x136>
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803218:	8b 52 04             	mov    0x4(%edx),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	eb 0b                	jmp    80322b <alloc_block_NF+0x141>
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0f                	je     803244 <alloc_block_NF+0x15a>
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	8b 40 04             	mov    0x4(%eax),%eax
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	8b 12                	mov    (%edx),%edx
  803240:	89 10                	mov    %edx,(%eax)
  803242:	eb 0a                	jmp    80324e <alloc_block_NF+0x164>
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	a3 38 51 80 00       	mov    %eax,0x805138
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803261:	a1 44 51 80 00       	mov    0x805144,%eax
  803266:	48                   	dec    %eax
  803267:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	eb 17                	jmp    803288 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327d:	0f 85 7a fe ff ff    	jne    8030fd <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
  80328d:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  803290:	a1 38 51 80 00       	mov    0x805138,%eax
  803295:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803298:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80329d:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8032a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8032a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ac:	75 68                	jne    803316 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8032ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b2:	75 17                	jne    8032cb <insert_sorted_with_merge_freeList+0x41>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 f4 44 80 00       	push   $0x8044f4
  8032bc:	68 da 00 00 00       	push   $0xda
  8032c1:	68 17 45 80 00       	push   $0x804517
  8032c6:	e8 df d9 ff ff       	call   800caa <_panic>
  8032cb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	89 10                	mov    %edx,(%eax)
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	74 0d                	je     8032ec <insert_sorted_with_merge_freeList+0x62>
  8032df:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	eb 08                	jmp    8032f4 <insert_sorted_with_merge_freeList+0x6a>
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803306:	a1 44 51 80 00       	mov    0x805144,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  803311:	e9 49 07 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803319:	8b 50 08             	mov    0x8(%eax),%edx
  80331c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331f:	8b 40 0c             	mov    0xc(%eax),%eax
  803322:	01 c2                	add    %eax,%edx
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	8b 40 08             	mov    0x8(%eax),%eax
  80332a:	39 c2                	cmp    %eax,%edx
  80332c:	73 77                	jae    8033a5 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	75 6e                	jne    8033a5 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803337:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80333b:	74 68                	je     8033a5 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80333d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803341:	75 17                	jne    80335a <insert_sorted_with_merge_freeList+0xd0>
  803343:	83 ec 04             	sub    $0x4,%esp
  803346:	68 30 45 80 00       	push   $0x804530
  80334b:	68 e0 00 00 00       	push   $0xe0
  803350:	68 17 45 80 00       	push   $0x804517
  803355:	e8 50 d9 ff ff       	call   800caa <_panic>
  80335a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0c                	je     80337c <insert_sorted_with_merge_freeList+0xf2>
  803370:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803375:	8b 55 08             	mov    0x8(%ebp),%edx
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	eb 08                	jmp    803384 <insert_sorted_with_merge_freeList+0xfa>
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	a3 38 51 80 00       	mov    %eax,0x805138
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803395:	a1 44 51 80 00       	mov    0x805144,%eax
  80339a:	40                   	inc    %eax
  80339b:	a3 44 51 80 00       	mov    %eax,0x805144
  8033a0:	e9 ba 06 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	8b 40 08             	mov    0x8(%eax),%eax
  8033b1:	01 c2                	add    %eax,%edx
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	73 78                	jae    803435 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 40 04             	mov    0x4(%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	75 6e                	jne    803435 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8033c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033cb:	74 68                	je     803435 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8033cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d1:	75 17                	jne    8033ea <insert_sorted_with_merge_freeList+0x160>
  8033d3:	83 ec 04             	sub    $0x4,%esp
  8033d6:	68 f4 44 80 00       	push   $0x8044f4
  8033db:	68 e6 00 00 00       	push   $0xe6
  8033e0:	68 17 45 80 00       	push   $0x804517
  8033e5:	e8 c0 d8 ff ff       	call   800caa <_panic>
  8033ea:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	89 10                	mov    %edx,(%eax)
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0d                	je     80340b <insert_sorted_with_merge_freeList+0x181>
  8033fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803403:	8b 55 08             	mov    0x8(%ebp),%edx
  803406:	89 50 04             	mov    %edx,0x4(%eax)
  803409:	eb 08                	jmp    803413 <insert_sorted_with_merge_freeList+0x189>
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	a3 38 51 80 00       	mov    %eax,0x805138
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803425:	a1 44 51 80 00       	mov    0x805144,%eax
  80342a:	40                   	inc    %eax
  80342b:	a3 44 51 80 00       	mov    %eax,0x805144
  803430:	e9 2a 06 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803435:	a1 38 51 80 00       	mov    0x805138,%eax
  80343a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343d:	e9 ed 05 00 00       	jmp    803a2f <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  80344a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80344e:	0f 84 a7 00 00 00    	je     8034fb <insert_sorted_with_merge_freeList+0x271>
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 50 0c             	mov    0xc(%eax),%edx
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 08             	mov    0x8(%eax),%eax
  803460:	01 c2                	add    %eax,%edx
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	8b 40 08             	mov    0x8(%eax),%eax
  803468:	39 c2                	cmp    %eax,%edx
  80346a:	0f 83 8b 00 00 00    	jae    8034fb <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 50 0c             	mov    0xc(%eax),%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 40 08             	mov    0x8(%eax),%eax
  80347c:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803484:	39 c2                	cmp    %eax,%edx
  803486:	73 73                	jae    8034fb <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348c:	74 06                	je     803494 <insert_sorted_with_merge_freeList+0x20a>
  80348e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803492:	75 17                	jne    8034ab <insert_sorted_with_merge_freeList+0x221>
  803494:	83 ec 04             	sub    $0x4,%esp
  803497:	68 a8 45 80 00       	push   $0x8045a8
  80349c:	68 f0 00 00 00       	push   $0xf0
  8034a1:	68 17 45 80 00       	push   $0x804517
  8034a6:	e8 ff d7 ff ff       	call   800caa <_panic>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 10                	mov    (%eax),%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 0b                	je     8034c9 <insert_sorted_with_merge_freeList+0x23f>
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	89 50 04             	mov    %edx,0x4(%eax)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	75 08                	jne    8034eb <insert_sorted_with_merge_freeList+0x261>
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f0:	40                   	inc    %eax
  8034f1:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8034f6:	e9 64 05 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8034fb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803500:	8b 50 0c             	mov    0xc(%eax),%edx
  803503:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803508:	8b 40 08             	mov    0x8(%eax),%eax
  80350b:	01 c2                	add    %eax,%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	8b 40 08             	mov    0x8(%eax),%eax
  803513:	39 c2                	cmp    %eax,%edx
  803515:	0f 85 b1 00 00 00    	jne    8035cc <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80351b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	0f 84 a4 00 00 00    	je     8035cc <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803528:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	0f 85 95 00 00 00    	jne    8035cc <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803537:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80353c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803542:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803545:	8b 55 08             	mov    0x8(%ebp),%edx
  803548:	8b 52 0c             	mov    0xc(%edx),%edx
  80354b:	01 ca                	add    %ecx,%edx
  80354d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803564:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803568:	75 17                	jne    803581 <insert_sorted_with_merge_freeList+0x2f7>
  80356a:	83 ec 04             	sub    $0x4,%esp
  80356d:	68 f4 44 80 00       	push   $0x8044f4
  803572:	68 ff 00 00 00       	push   $0xff
  803577:	68 17 45 80 00       	push   $0x804517
  80357c:	e8 29 d7 ff ff       	call   800caa <_panic>
  803581:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	89 10                	mov    %edx,(%eax)
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	85 c0                	test   %eax,%eax
  803593:	74 0d                	je     8035a2 <insert_sorted_with_merge_freeList+0x318>
  803595:	a1 48 51 80 00       	mov    0x805148,%eax
  80359a:	8b 55 08             	mov    0x8(%ebp),%edx
  80359d:	89 50 04             	mov    %edx,0x4(%eax)
  8035a0:	eb 08                	jmp    8035aa <insert_sorted_with_merge_freeList+0x320>
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c1:	40                   	inc    %eax
  8035c2:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8035c7:	e9 93 04 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 50 08             	mov    0x8(%eax),%edx
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d8:	01 c2                	add    %eax,%edx
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 40 08             	mov    0x8(%eax),%eax
  8035e0:	39 c2                	cmp    %eax,%edx
  8035e2:	0f 85 ae 00 00 00    	jne    803696 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f1:	8b 40 08             	mov    0x8(%eax),%eax
  8035f4:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8035fe:	39 c2                	cmp    %eax,%edx
  803600:	0f 84 90 00 00 00    	je     803696 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	8b 50 0c             	mov    0xc(%eax),%edx
  80360c:	8b 45 08             	mov    0x8(%ebp),%eax
  80360f:	8b 40 0c             	mov    0xc(%eax),%eax
  803612:	01 c2                	add    %eax,%edx
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80362e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803632:	75 17                	jne    80364b <insert_sorted_with_merge_freeList+0x3c1>
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 f4 44 80 00       	push   $0x8044f4
  80363c:	68 0b 01 00 00       	push   $0x10b
  803641:	68 17 45 80 00       	push   $0x804517
  803646:	e8 5f d6 ff ff       	call   800caa <_panic>
  80364b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	89 10                	mov    %edx,(%eax)
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	8b 00                	mov    (%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0d                	je     80366c <insert_sorted_with_merge_freeList+0x3e2>
  80365f:	a1 48 51 80 00       	mov    0x805148,%eax
  803664:	8b 55 08             	mov    0x8(%ebp),%edx
  803667:	89 50 04             	mov    %edx,0x4(%eax)
  80366a:	eb 08                	jmp    803674 <insert_sorted_with_merge_freeList+0x3ea>
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	a3 48 51 80 00       	mov    %eax,0x805148
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803686:	a1 54 51 80 00       	mov    0x805154,%eax
  80368b:	40                   	inc    %eax
  80368c:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803691:	e9 c9 03 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 50 0c             	mov    0xc(%eax),%edx
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 40 08             	mov    0x8(%eax),%eax
  8036a2:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8036aa:	39 c2                	cmp    %eax,%edx
  8036ac:	0f 85 bb 00 00 00    	jne    80376d <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8036b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b6:	0f 84 b1 00 00 00    	je     80376d <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	8b 40 04             	mov    0x4(%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	0f 85 a3 00 00 00    	jne    80376d <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8036ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8036cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d2:	8b 52 08             	mov    0x8(%edx),%edx
  8036d5:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8036d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8036dd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036e3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8036ec:	01 ca                	add    %ecx,%edx
  8036ee:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803705:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803709:	75 17                	jne    803722 <insert_sorted_with_merge_freeList+0x498>
  80370b:	83 ec 04             	sub    $0x4,%esp
  80370e:	68 f4 44 80 00       	push   $0x8044f4
  803713:	68 17 01 00 00       	push   $0x117
  803718:	68 17 45 80 00       	push   $0x804517
  80371d:	e8 88 d5 ff ff       	call   800caa <_panic>
  803722:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	89 10                	mov    %edx,(%eax)
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 0d                	je     803743 <insert_sorted_with_merge_freeList+0x4b9>
  803736:	a1 48 51 80 00       	mov    0x805148,%eax
  80373b:	8b 55 08             	mov    0x8(%ebp),%edx
  80373e:	89 50 04             	mov    %edx,0x4(%eax)
  803741:	eb 08                	jmp    80374b <insert_sorted_with_merge_freeList+0x4c1>
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	a3 48 51 80 00       	mov    %eax,0x805148
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375d:	a1 54 51 80 00       	mov    0x805154,%eax
  803762:	40                   	inc    %eax
  803763:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803768:	e9 f2 02 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 50 08             	mov    0x8(%eax),%edx
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	8b 40 0c             	mov    0xc(%eax),%eax
  803779:	01 c2                	add    %eax,%edx
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	8b 40 08             	mov    0x8(%eax),%eax
  803781:	39 c2                	cmp    %eax,%edx
  803783:	0f 85 be 00 00 00    	jne    803847 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 40 04             	mov    0x4(%eax),%eax
  80378f:	8b 50 08             	mov    0x8(%eax),%edx
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	8b 40 0c             	mov    0xc(%eax),%eax
  80379b:	01 c2                	add    %eax,%edx
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	8b 40 08             	mov    0x8(%eax),%eax
  8037a3:	39 c2                	cmp    %eax,%edx
  8037a5:	0f 84 9c 00 00 00    	je     803847 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	8b 50 08             	mov    0x8(%eax),%edx
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c3:	01 c2                	add    %eax,%edx
  8037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8037d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8037df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e3:	75 17                	jne    8037fc <insert_sorted_with_merge_freeList+0x572>
  8037e5:	83 ec 04             	sub    $0x4,%esp
  8037e8:	68 f4 44 80 00       	push   $0x8044f4
  8037ed:	68 26 01 00 00       	push   $0x126
  8037f2:	68 17 45 80 00       	push   $0x804517
  8037f7:	e8 ae d4 ff ff       	call   800caa <_panic>
  8037fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803802:	8b 45 08             	mov    0x8(%ebp),%eax
  803805:	89 10                	mov    %edx,(%eax)
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0d                	je     80381d <insert_sorted_with_merge_freeList+0x593>
  803810:	a1 48 51 80 00       	mov    0x805148,%eax
  803815:	8b 55 08             	mov    0x8(%ebp),%edx
  803818:	89 50 04             	mov    %edx,0x4(%eax)
  80381b:	eb 08                	jmp    803825 <insert_sorted_with_merge_freeList+0x59b>
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	a3 48 51 80 00       	mov    %eax,0x805148
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803837:	a1 54 51 80 00       	mov    0x805154,%eax
  80383c:	40                   	inc    %eax
  80383d:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803842:	e9 18 02 00 00       	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	8b 50 0c             	mov    0xc(%eax),%edx
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 08             	mov    0x8(%eax),%eax
  803853:	01 c2                	add    %eax,%edx
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	8b 40 08             	mov    0x8(%eax),%eax
  80385b:	39 c2                	cmp    %eax,%edx
  80385d:	0f 85 c4 01 00 00    	jne    803a27 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	8b 50 0c             	mov    0xc(%eax),%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 40 08             	mov    0x8(%eax),%eax
  80386f:	01 c2                	add    %eax,%edx
  803871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	8b 40 08             	mov    0x8(%eax),%eax
  803879:	39 c2                	cmp    %eax,%edx
  80387b:	0f 85 a6 01 00 00    	jne    803a27 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803885:	0f 84 9c 01 00 00    	je     803a27 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	8b 50 0c             	mov    0xc(%eax),%edx
  803891:	8b 45 08             	mov    0x8(%ebp),%eax
  803894:	8b 40 0c             	mov    0xc(%eax),%eax
  803897:	01 c2                	add    %eax,%edx
  803899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a1:	01 c2                	add    %eax,%edx
  8038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a6:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8038bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038c1:	75 17                	jne    8038da <insert_sorted_with_merge_freeList+0x650>
  8038c3:	83 ec 04             	sub    $0x4,%esp
  8038c6:	68 f4 44 80 00       	push   $0x8044f4
  8038cb:	68 32 01 00 00       	push   $0x132
  8038d0:	68 17 45 80 00       	push   $0x804517
  8038d5:	e8 d0 d3 ff ff       	call   800caa <_panic>
  8038da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	89 10                	mov    %edx,(%eax)
  8038e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	74 0d                	je     8038fb <insert_sorted_with_merge_freeList+0x671>
  8038ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8038f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f6:	89 50 04             	mov    %edx,0x4(%eax)
  8038f9:	eb 08                	jmp    803903 <insert_sorted_with_merge_freeList+0x679>
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	a3 48 51 80 00       	mov    %eax,0x805148
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803915:	a1 54 51 80 00       	mov    0x805154,%eax
  80391a:	40                   	inc    %eax
  80391b:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	8b 00                	mov    (%eax),%eax
  80393d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803940:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803944:	75 17                	jne    80395d <insert_sorted_with_merge_freeList+0x6d3>
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 89 45 80 00       	push   $0x804589
  80394e:	68 36 01 00 00       	push   $0x136
  803953:	68 17 45 80 00       	push   $0x804517
  803958:	e8 4d d3 ff ff       	call   800caa <_panic>
  80395d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	85 c0                	test   %eax,%eax
  803964:	74 10                	je     803976 <insert_sorted_with_merge_freeList+0x6ec>
  803966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803969:	8b 00                	mov    (%eax),%eax
  80396b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396e:	8b 52 04             	mov    0x4(%edx),%edx
  803971:	89 50 04             	mov    %edx,0x4(%eax)
  803974:	eb 0b                	jmp    803981 <insert_sorted_with_merge_freeList+0x6f7>
  803976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803979:	8b 40 04             	mov    0x4(%eax),%eax
  80397c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 0f                	je     80399a <insert_sorted_with_merge_freeList+0x710>
  80398b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803994:	8b 12                	mov    (%edx),%edx
  803996:	89 10                	mov    %edx,(%eax)
  803998:	eb 0a                	jmp    8039a4 <insert_sorted_with_merge_freeList+0x71a>
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	a3 38 51 80 00       	mov    %eax,0x805138
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039bc:	48                   	dec    %eax
  8039bd:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8039c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039c6:	75 17                	jne    8039df <insert_sorted_with_merge_freeList+0x755>
  8039c8:	83 ec 04             	sub    $0x4,%esp
  8039cb:	68 f4 44 80 00       	push   $0x8044f4
  8039d0:	68 37 01 00 00       	push   $0x137
  8039d5:	68 17 45 80 00       	push   $0x804517
  8039da:	e8 cb d2 ff ff       	call   800caa <_panic>
  8039df:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e8:	89 10                	mov    %edx,(%eax)
  8039ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	85 c0                	test   %eax,%eax
  8039f1:	74 0d                	je     803a00 <insert_sorted_with_merge_freeList+0x776>
  8039f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8039f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039fb:	89 50 04             	mov    %edx,0x4(%eax)
  8039fe:	eb 08                	jmp    803a08 <insert_sorted_with_merge_freeList+0x77e>
  803a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0b:	a3 48 51 80 00       	mov    %eax,0x805148
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1a:	a1 54 51 80 00       	mov    0x805154,%eax
  803a1f:	40                   	inc    %eax
  803a20:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803a25:	eb 38                	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803a27:	a1 40 51 80 00       	mov    0x805140,%eax
  803a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a33:	74 07                	je     803a3c <insert_sorted_with_merge_freeList+0x7b2>
  803a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	eb 05                	jmp    803a41 <insert_sorted_with_merge_freeList+0x7b7>
  803a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a41:	a3 40 51 80 00       	mov    %eax,0x805140
  803a46:	a1 40 51 80 00       	mov    0x805140,%eax
  803a4b:	85 c0                	test   %eax,%eax
  803a4d:	0f 85 ef f9 ff ff    	jne    803442 <insert_sorted_with_merge_freeList+0x1b8>
  803a53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a57:	0f 85 e5 f9 ff ff    	jne    803442 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803a5d:	eb 00                	jmp    803a5f <insert_sorted_with_merge_freeList+0x7d5>
  803a5f:	90                   	nop
  803a60:	c9                   	leave  
  803a61:	c3                   	ret    
  803a62:	66 90                	xchg   %ax,%ax

00803a64 <__udivdi3>:
  803a64:	55                   	push   %ebp
  803a65:	57                   	push   %edi
  803a66:	56                   	push   %esi
  803a67:	53                   	push   %ebx
  803a68:	83 ec 1c             	sub    $0x1c,%esp
  803a6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a7b:	89 ca                	mov    %ecx,%edx
  803a7d:	89 f8                	mov    %edi,%eax
  803a7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a83:	85 f6                	test   %esi,%esi
  803a85:	75 2d                	jne    803ab4 <__udivdi3+0x50>
  803a87:	39 cf                	cmp    %ecx,%edi
  803a89:	77 65                	ja     803af0 <__udivdi3+0x8c>
  803a8b:	89 fd                	mov    %edi,%ebp
  803a8d:	85 ff                	test   %edi,%edi
  803a8f:	75 0b                	jne    803a9c <__udivdi3+0x38>
  803a91:	b8 01 00 00 00       	mov    $0x1,%eax
  803a96:	31 d2                	xor    %edx,%edx
  803a98:	f7 f7                	div    %edi
  803a9a:	89 c5                	mov    %eax,%ebp
  803a9c:	31 d2                	xor    %edx,%edx
  803a9e:	89 c8                	mov    %ecx,%eax
  803aa0:	f7 f5                	div    %ebp
  803aa2:	89 c1                	mov    %eax,%ecx
  803aa4:	89 d8                	mov    %ebx,%eax
  803aa6:	f7 f5                	div    %ebp
  803aa8:	89 cf                	mov    %ecx,%edi
  803aaa:	89 fa                	mov    %edi,%edx
  803aac:	83 c4 1c             	add    $0x1c,%esp
  803aaf:	5b                   	pop    %ebx
  803ab0:	5e                   	pop    %esi
  803ab1:	5f                   	pop    %edi
  803ab2:	5d                   	pop    %ebp
  803ab3:	c3                   	ret    
  803ab4:	39 ce                	cmp    %ecx,%esi
  803ab6:	77 28                	ja     803ae0 <__udivdi3+0x7c>
  803ab8:	0f bd fe             	bsr    %esi,%edi
  803abb:	83 f7 1f             	xor    $0x1f,%edi
  803abe:	75 40                	jne    803b00 <__udivdi3+0x9c>
  803ac0:	39 ce                	cmp    %ecx,%esi
  803ac2:	72 0a                	jb     803ace <__udivdi3+0x6a>
  803ac4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ac8:	0f 87 9e 00 00 00    	ja     803b6c <__udivdi3+0x108>
  803ace:	b8 01 00 00 00       	mov    $0x1,%eax
  803ad3:	89 fa                	mov    %edi,%edx
  803ad5:	83 c4 1c             	add    $0x1c,%esp
  803ad8:	5b                   	pop    %ebx
  803ad9:	5e                   	pop    %esi
  803ada:	5f                   	pop    %edi
  803adb:	5d                   	pop    %ebp
  803adc:	c3                   	ret    
  803add:	8d 76 00             	lea    0x0(%esi),%esi
  803ae0:	31 ff                	xor    %edi,%edi
  803ae2:	31 c0                	xor    %eax,%eax
  803ae4:	89 fa                	mov    %edi,%edx
  803ae6:	83 c4 1c             	add    $0x1c,%esp
  803ae9:	5b                   	pop    %ebx
  803aea:	5e                   	pop    %esi
  803aeb:	5f                   	pop    %edi
  803aec:	5d                   	pop    %ebp
  803aed:	c3                   	ret    
  803aee:	66 90                	xchg   %ax,%ax
  803af0:	89 d8                	mov    %ebx,%eax
  803af2:	f7 f7                	div    %edi
  803af4:	31 ff                	xor    %edi,%edi
  803af6:	89 fa                	mov    %edi,%edx
  803af8:	83 c4 1c             	add    $0x1c,%esp
  803afb:	5b                   	pop    %ebx
  803afc:	5e                   	pop    %esi
  803afd:	5f                   	pop    %edi
  803afe:	5d                   	pop    %ebp
  803aff:	c3                   	ret    
  803b00:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b05:	89 eb                	mov    %ebp,%ebx
  803b07:	29 fb                	sub    %edi,%ebx
  803b09:	89 f9                	mov    %edi,%ecx
  803b0b:	d3 e6                	shl    %cl,%esi
  803b0d:	89 c5                	mov    %eax,%ebp
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 ed                	shr    %cl,%ebp
  803b13:	89 e9                	mov    %ebp,%ecx
  803b15:	09 f1                	or     %esi,%ecx
  803b17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b1b:	89 f9                	mov    %edi,%ecx
  803b1d:	d3 e0                	shl    %cl,%eax
  803b1f:	89 c5                	mov    %eax,%ebp
  803b21:	89 d6                	mov    %edx,%esi
  803b23:	88 d9                	mov    %bl,%cl
  803b25:	d3 ee                	shr    %cl,%esi
  803b27:	89 f9                	mov    %edi,%ecx
  803b29:	d3 e2                	shl    %cl,%edx
  803b2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2f:	88 d9                	mov    %bl,%cl
  803b31:	d3 e8                	shr    %cl,%eax
  803b33:	09 c2                	or     %eax,%edx
  803b35:	89 d0                	mov    %edx,%eax
  803b37:	89 f2                	mov    %esi,%edx
  803b39:	f7 74 24 0c          	divl   0xc(%esp)
  803b3d:	89 d6                	mov    %edx,%esi
  803b3f:	89 c3                	mov    %eax,%ebx
  803b41:	f7 e5                	mul    %ebp
  803b43:	39 d6                	cmp    %edx,%esi
  803b45:	72 19                	jb     803b60 <__udivdi3+0xfc>
  803b47:	74 0b                	je     803b54 <__udivdi3+0xf0>
  803b49:	89 d8                	mov    %ebx,%eax
  803b4b:	31 ff                	xor    %edi,%edi
  803b4d:	e9 58 ff ff ff       	jmp    803aaa <__udivdi3+0x46>
  803b52:	66 90                	xchg   %ax,%ax
  803b54:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b58:	89 f9                	mov    %edi,%ecx
  803b5a:	d3 e2                	shl    %cl,%edx
  803b5c:	39 c2                	cmp    %eax,%edx
  803b5e:	73 e9                	jae    803b49 <__udivdi3+0xe5>
  803b60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b63:	31 ff                	xor    %edi,%edi
  803b65:	e9 40 ff ff ff       	jmp    803aaa <__udivdi3+0x46>
  803b6a:	66 90                	xchg   %ax,%ax
  803b6c:	31 c0                	xor    %eax,%eax
  803b6e:	e9 37 ff ff ff       	jmp    803aaa <__udivdi3+0x46>
  803b73:	90                   	nop

00803b74 <__umoddi3>:
  803b74:	55                   	push   %ebp
  803b75:	57                   	push   %edi
  803b76:	56                   	push   %esi
  803b77:	53                   	push   %ebx
  803b78:	83 ec 1c             	sub    $0x1c,%esp
  803b7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b93:	89 f3                	mov    %esi,%ebx
  803b95:	89 fa                	mov    %edi,%edx
  803b97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b9b:	89 34 24             	mov    %esi,(%esp)
  803b9e:	85 c0                	test   %eax,%eax
  803ba0:	75 1a                	jne    803bbc <__umoddi3+0x48>
  803ba2:	39 f7                	cmp    %esi,%edi
  803ba4:	0f 86 a2 00 00 00    	jbe    803c4c <__umoddi3+0xd8>
  803baa:	89 c8                	mov    %ecx,%eax
  803bac:	89 f2                	mov    %esi,%edx
  803bae:	f7 f7                	div    %edi
  803bb0:	89 d0                	mov    %edx,%eax
  803bb2:	31 d2                	xor    %edx,%edx
  803bb4:	83 c4 1c             	add    $0x1c,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5e                   	pop    %esi
  803bb9:	5f                   	pop    %edi
  803bba:	5d                   	pop    %ebp
  803bbb:	c3                   	ret    
  803bbc:	39 f0                	cmp    %esi,%eax
  803bbe:	0f 87 ac 00 00 00    	ja     803c70 <__umoddi3+0xfc>
  803bc4:	0f bd e8             	bsr    %eax,%ebp
  803bc7:	83 f5 1f             	xor    $0x1f,%ebp
  803bca:	0f 84 ac 00 00 00    	je     803c7c <__umoddi3+0x108>
  803bd0:	bf 20 00 00 00       	mov    $0x20,%edi
  803bd5:	29 ef                	sub    %ebp,%edi
  803bd7:	89 fe                	mov    %edi,%esi
  803bd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bdd:	89 e9                	mov    %ebp,%ecx
  803bdf:	d3 e0                	shl    %cl,%eax
  803be1:	89 d7                	mov    %edx,%edi
  803be3:	89 f1                	mov    %esi,%ecx
  803be5:	d3 ef                	shr    %cl,%edi
  803be7:	09 c7                	or     %eax,%edi
  803be9:	89 e9                	mov    %ebp,%ecx
  803beb:	d3 e2                	shl    %cl,%edx
  803bed:	89 14 24             	mov    %edx,(%esp)
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	d3 e0                	shl    %cl,%eax
  803bf4:	89 c2                	mov    %eax,%edx
  803bf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bfa:	d3 e0                	shl    %cl,%eax
  803bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c00:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c04:	89 f1                	mov    %esi,%ecx
  803c06:	d3 e8                	shr    %cl,%eax
  803c08:	09 d0                	or     %edx,%eax
  803c0a:	d3 eb                	shr    %cl,%ebx
  803c0c:	89 da                	mov    %ebx,%edx
  803c0e:	f7 f7                	div    %edi
  803c10:	89 d3                	mov    %edx,%ebx
  803c12:	f7 24 24             	mull   (%esp)
  803c15:	89 c6                	mov    %eax,%esi
  803c17:	89 d1                	mov    %edx,%ecx
  803c19:	39 d3                	cmp    %edx,%ebx
  803c1b:	0f 82 87 00 00 00    	jb     803ca8 <__umoddi3+0x134>
  803c21:	0f 84 91 00 00 00    	je     803cb8 <__umoddi3+0x144>
  803c27:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c2b:	29 f2                	sub    %esi,%edx
  803c2d:	19 cb                	sbb    %ecx,%ebx
  803c2f:	89 d8                	mov    %ebx,%eax
  803c31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c35:	d3 e0                	shl    %cl,%eax
  803c37:	89 e9                	mov    %ebp,%ecx
  803c39:	d3 ea                	shr    %cl,%edx
  803c3b:	09 d0                	or     %edx,%eax
  803c3d:	89 e9                	mov    %ebp,%ecx
  803c3f:	d3 eb                	shr    %cl,%ebx
  803c41:	89 da                	mov    %ebx,%edx
  803c43:	83 c4 1c             	add    $0x1c,%esp
  803c46:	5b                   	pop    %ebx
  803c47:	5e                   	pop    %esi
  803c48:	5f                   	pop    %edi
  803c49:	5d                   	pop    %ebp
  803c4a:	c3                   	ret    
  803c4b:	90                   	nop
  803c4c:	89 fd                	mov    %edi,%ebp
  803c4e:	85 ff                	test   %edi,%edi
  803c50:	75 0b                	jne    803c5d <__umoddi3+0xe9>
  803c52:	b8 01 00 00 00       	mov    $0x1,%eax
  803c57:	31 d2                	xor    %edx,%edx
  803c59:	f7 f7                	div    %edi
  803c5b:	89 c5                	mov    %eax,%ebp
  803c5d:	89 f0                	mov    %esi,%eax
  803c5f:	31 d2                	xor    %edx,%edx
  803c61:	f7 f5                	div    %ebp
  803c63:	89 c8                	mov    %ecx,%eax
  803c65:	f7 f5                	div    %ebp
  803c67:	89 d0                	mov    %edx,%eax
  803c69:	e9 44 ff ff ff       	jmp    803bb2 <__umoddi3+0x3e>
  803c6e:	66 90                	xchg   %ax,%ax
  803c70:	89 c8                	mov    %ecx,%eax
  803c72:	89 f2                	mov    %esi,%edx
  803c74:	83 c4 1c             	add    $0x1c,%esp
  803c77:	5b                   	pop    %ebx
  803c78:	5e                   	pop    %esi
  803c79:	5f                   	pop    %edi
  803c7a:	5d                   	pop    %ebp
  803c7b:	c3                   	ret    
  803c7c:	3b 04 24             	cmp    (%esp),%eax
  803c7f:	72 06                	jb     803c87 <__umoddi3+0x113>
  803c81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c85:	77 0f                	ja     803c96 <__umoddi3+0x122>
  803c87:	89 f2                	mov    %esi,%edx
  803c89:	29 f9                	sub    %edi,%ecx
  803c8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c8f:	89 14 24             	mov    %edx,(%esp)
  803c92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c96:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c9a:	8b 14 24             	mov    (%esp),%edx
  803c9d:	83 c4 1c             	add    $0x1c,%esp
  803ca0:	5b                   	pop    %ebx
  803ca1:	5e                   	pop    %esi
  803ca2:	5f                   	pop    %edi
  803ca3:	5d                   	pop    %ebp
  803ca4:	c3                   	ret    
  803ca5:	8d 76 00             	lea    0x0(%esi),%esi
  803ca8:	2b 04 24             	sub    (%esp),%eax
  803cab:	19 fa                	sbb    %edi,%edx
  803cad:	89 d1                	mov    %edx,%ecx
  803caf:	89 c6                	mov    %eax,%esi
  803cb1:	e9 71 ff ff ff       	jmp    803c27 <__umoddi3+0xb3>
  803cb6:	66 90                	xchg   %ax,%ax
  803cb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cbc:	72 ea                	jb     803ca8 <__umoddi3+0x134>
  803cbe:	89 d9                	mov    %ebx,%ecx
  803cc0:	e9 62 ff ff ff       	jmp    803c27 <__umoddi3+0xb3>
