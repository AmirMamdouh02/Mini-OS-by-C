
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 e3 25 00 00       	call   80262d <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 60 3a 80 00       	push   $0x803a60
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 7c 3a 80 00       	push   $0x803a7c
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 c4 1b 00 00       	call   801c7a <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 95 1b 00 00       	call   801c7a <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 94 3a 80 00       	push   $0x803a94
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 7c 3a 80 00       	push   $0x803a7c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 0d 20 00 00       	call   802118 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 a5 20 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 53 1b 00 00       	call   801c7a <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 d8 3a 80 00       	push   $0x803ad8
  80013f:	6a 31                	push   $0x31
  800141:	68 7c 3a 80 00       	push   $0x803a7c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 68 20 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 08 3b 80 00       	push   $0x803b08
  800162:	6a 33                	push   $0x33
  800164:	68 7c 3a 80 00       	push   $0x803a7c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 a5 1f 00 00       	call   802118 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 3d 20 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 eb 1a 00 00       	call   801c7a <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 d8 3a 80 00       	push   $0x803ad8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 7c 3a 80 00       	push   $0x803a7c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 f7 1f 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 08 3b 80 00       	push   $0x803b08
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 7c 3a 80 00       	push   $0x803a7c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 34 1f 00 00       	call   802118 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 cc 1f 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 7d 1a 00 00       	call   801c7a <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 d8 3a 80 00       	push   $0x803ad8
  80021f:	6a 41                	push   $0x41
  800221:	68 7c 3a 80 00       	push   $0x803a7c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 88 1f 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 08 3b 80 00       	push   $0x803b08
  800240:	6a 43                	push   $0x43
  800242:	68 7c 3a 80 00       	push   $0x803a7c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 c7 1e 00 00       	call   802118 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 5f 1f 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 10 1a 00 00       	call   801c7a <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 d8 3a 80 00       	push   $0x803ad8
  800296:	6a 49                	push   $0x49
  800298:	68 7c 3a 80 00       	push   $0x803a7c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 11 1f 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 08 3b 80 00       	push   $0x803b08
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 7c 3a 80 00       	push   $0x803a7c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 50 1e 00 00       	call   802118 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 e8 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 34 1a 00 00       	call   801d13 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 d1 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 25 3b 80 00       	push   $0x803b25
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 7c 3a 80 00       	push   $0x803a7c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 0c 1e 00 00       	call   802118 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 a4 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 4d 19 00 00       	call   801c7a <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 d8 3a 80 00       	push   $0x803ad8
  800359:	6a 58                	push   $0x58
  80035b:	68 7c 3a 80 00       	push   $0x803a7c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 4e 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 08 3b 80 00       	push   $0x803b08
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 7c 3a 80 00       	push   $0x803a7c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 8d 1d 00 00       	call   802118 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 25 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 71 19 00 00       	call   801d13 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 0e 1e 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 25 3b 80 00       	push   $0x803b25
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 7c 3a 80 00       	push   $0x803a7c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 47 1d 00 00       	call   802118 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 df 1d 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 89 18 00 00       	call   801c7a <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 d8 3a 80 00       	push   $0x803ad8
  80041d:	6a 67                	push   $0x67
  80041f:	68 7c 3a 80 00       	push   $0x803a7c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 8a 1d 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 08 3b 80 00       	push   $0x803b08
  800454:	6a 69                	push   $0x69
  800456:	68 7c 3a 80 00       	push   $0x803a7c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 b3 1c 00 00       	call   802118 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 4b 1d 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 f1 17 00 00       	call   801c7a <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 d8 3a 80 00       	push   $0x803ad8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 7c 3a 80 00       	push   $0x803a7c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 eb 1c 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 08 3b 80 00       	push   $0x803b08
  8004df:	6a 71                	push   $0x71
  8004e1:	68 7c 3a 80 00       	push   $0x803a7c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 28 1c 00 00       	call   802118 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 c0 1c 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 69 17 00 00       	call   801c7a <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 d8 3a 80 00       	push   $0x803ad8
  800547:	6a 77                	push   $0x77
  800549:	68 7c 3a 80 00       	push   $0x803a7c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 60 1c 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 08 3b 80 00       	push   $0x803b08
  80057f:	6a 79                	push   $0x79
  800581:	68 7c 3a 80 00       	push   $0x803a7c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 88 1b 00 00       	call   802118 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 20 1c 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 6c 17 00 00       	call   801d13 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 09 1c 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 25 3b 80 00       	push   $0x803b25
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 7c 3a 80 00       	push   $0x803a7c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 3f 1b 00 00       	call   802118 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 d7 1b 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 23 17 00 00       	call   801d13 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 c0 1b 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 25 3b 80 00       	push   $0x803b25
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 7c 3a 80 00       	push   $0x803a7c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 f6 1a 00 00       	call   802118 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 8e 1b 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 3c 16 00 00       	call   801c7a <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 d8 3a 80 00       	push   $0x803ad8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 7c 3a 80 00       	push   $0x803a7c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 33 1b 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 08 3b 80 00       	push   $0x803b08
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 7c 3a 80 00       	push   $0x803a7c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 6d 1a 00 00       	call   802118 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 05 1b 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 b0 15 00 00       	call   801c7a <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 d8 3a 80 00       	push   $0x803ad8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 7c 3a 80 00       	push   $0x803a7c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 aa 1a 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 08 3b 80 00       	push   $0x803b08
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 7c 3a 80 00       	push   $0x803a7c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 e6 19 00 00       	call   802118 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 7e 1a 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 ca 15 00 00       	call   801d13 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 67 1a 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 25 3b 80 00       	push   $0x803b25
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 7c 3a 80 00       	push   $0x803a7c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 9d 19 00 00       	call   802118 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 35 1a 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 df 14 00 00       	call   801c7a <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 d8 3a 80 00       	push   $0x803ad8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 7c 3a 80 00       	push   $0x803a7c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 dd 19 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 08 3b 80 00       	push   $0x803b08
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 7c 3a 80 00       	push   $0x803a7c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 03 19 00 00       	call   802118 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 9b 19 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 48 14 00 00       	call   801c7a <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 d8 3a 80 00       	push   $0x803ad8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 7c 3a 80 00       	push   $0x803a7c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 5a 19 00 00       	call   8021b8 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 08 3b 80 00       	push   $0x803b08
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 7c 3a 80 00       	push   $0x803a7c
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 cb 13 00 00       	call   801c7a <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 3c 3b 80 00       	push   $0x803b3c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 7c 3a 80 00       	push   $0x803a7c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 a0 3b 80 00       	push   $0x803ba0
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 02 1b 00 00       	call   8023f8 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 a4 18 00 00       	call   802205 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 00 3c 80 00       	push   $0x803c00
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 28 3c 80 00       	push   $0x803c28
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 50 3c 80 00       	push   $0x803c50
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 a8 3c 80 00       	push   $0x803ca8
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 00 3c 80 00       	push   $0x803c00
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 24 18 00 00       	call   80221f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 b1 19 00 00       	call   8023c4 <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 06 1a 00 00       	call   80242a <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 bc 3c 80 00       	push   $0x803cbc
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 c1 3c 80 00       	push   $0x803cc1
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 dd 3c 80 00       	push   $0x803cdd
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 e0 3c 80 00       	push   $0x803ce0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 2c 3d 80 00       	push   $0x803d2c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 38 3d 80 00       	push   $0x803d38
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 2c 3d 80 00       	push   $0x803d2c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 8c 3d 80 00       	push   $0x803d8c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 2c 3d 80 00       	push   $0x803d2c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 05 14 00 00       	call   802057 <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 8e 13 00 00       	call   802057 <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 f2 14 00 00       	call   802205 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 ec 14 00 00       	call   80221f <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 63 2a 00 00       	call   8037e0 <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 23 2b 00 00       	call   8038f0 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 f4 3f 80 00       	add    $0x803ff4,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 05 40 80 00       	push   $0x804005
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 0e 40 80 00       	push   $0x80400e
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be 11 40 80 00       	mov    $0x804011,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 70 41 80 00       	push   $0x804170
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801a9c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801aa3:	00 00 00 
  801aa6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801aad:	00 00 00 
  801ab0:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ab7:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801aba:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ac1:	00 00 00 
  801ac4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801acb:	00 00 00 
  801ace:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ad5:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801ad8:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	c1 e8 0c             	shr    $0xc,%eax
  801ae5:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801aea:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801af9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801afe:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801b03:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801b0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801b0f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801b13:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801b16:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801b1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	48                   	dec    %eax
  801b26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b31:	f7 75 e4             	divl   -0x1c(%ebp)
  801b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b37:	29 d0                	sub    %edx,%eax
  801b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801b3c:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801b43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b4b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	6a 07                	push   $0x7
  801b55:	ff 75 e8             	pushl  -0x18(%ebp)
  801b58:	50                   	push   %eax
  801b59:	e8 3d 06 00 00       	call   80219b <sys_allocate_chunk>
  801b5e:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b61:	a1 20 51 80 00       	mov    0x805120,%eax
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	50                   	push   %eax
  801b6a:	e8 b2 0c 00 00       	call   802821 <initialize_MemBlocksList>
  801b6f:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801b72:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801b77:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801b7a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b7e:	0f 84 f3 00 00 00    	je     801c77 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801b84:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b88:	75 14                	jne    801b9e <initialize_dyn_block_system+0x108>
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	68 95 41 80 00       	push   $0x804195
  801b92:	6a 36                	push   $0x36
  801b94:	68 b3 41 80 00       	push   $0x8041b3
  801b99:	e8 89 ee ff ff       	call   800a27 <_panic>
  801b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ba1:	8b 00                	mov    (%eax),%eax
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	74 10                	je     801bb7 <initialize_dyn_block_system+0x121>
  801ba7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801baa:	8b 00                	mov    (%eax),%eax
  801bac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801baf:	8b 52 04             	mov    0x4(%edx),%edx
  801bb2:	89 50 04             	mov    %edx,0x4(%eax)
  801bb5:	eb 0b                	jmp    801bc2 <initialize_dyn_block_system+0x12c>
  801bb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bba:	8b 40 04             	mov    0x4(%eax),%eax
  801bbd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bc5:	8b 40 04             	mov    0x4(%eax),%eax
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	74 0f                	je     801bdb <initialize_dyn_block_system+0x145>
  801bcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bcf:	8b 40 04             	mov    0x4(%eax),%eax
  801bd2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bd5:	8b 12                	mov    (%edx),%edx
  801bd7:	89 10                	mov    %edx,(%eax)
  801bd9:	eb 0a                	jmp    801be5 <initialize_dyn_block_system+0x14f>
  801bdb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	a3 48 51 80 00       	mov    %eax,0x805148
  801be5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bf8:	a1 54 51 80 00       	mov    0x805154,%eax
  801bfd:	48                   	dec    %eax
  801bfe:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801c03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c06:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801c0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c10:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801c17:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c1b:	75 14                	jne    801c31 <initialize_dyn_block_system+0x19b>
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	68 c0 41 80 00       	push   $0x8041c0
  801c25:	6a 3e                	push   $0x3e
  801c27:	68 b3 41 80 00       	push   $0x8041b3
  801c2c:	e8 f6 ed ff ff       	call   800a27 <_panic>
  801c31:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c37:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c3a:	89 10                	mov    %edx,(%eax)
  801c3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	85 c0                	test   %eax,%eax
  801c43:	74 0d                	je     801c52 <initialize_dyn_block_system+0x1bc>
  801c45:	a1 38 51 80 00       	mov    0x805138,%eax
  801c4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c4d:	89 50 04             	mov    %edx,0x4(%eax)
  801c50:	eb 08                	jmp    801c5a <initialize_dyn_block_system+0x1c4>
  801c52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c55:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801c5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c5d:	a3 38 51 80 00       	mov    %eax,0x805138
  801c62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c6c:	a1 44 51 80 00       	mov    0x805144,%eax
  801c71:	40                   	inc    %eax
  801c72:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801c80:	e8 e0 fd ff ff       	call   801a65 <InitializeUHeap>
		if (size == 0) return NULL ;
  801c85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c89:	75 07                	jne    801c92 <malloc+0x18>
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c90:	eb 7f                	jmp    801d11 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c92:	e8 d2 08 00 00       	call   802569 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c97:	85 c0                	test   %eax,%eax
  801c99:	74 71                	je     801d0c <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801c9b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	48                   	dec    %eax
  801cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb6:	f7 75 f4             	divl   -0xc(%ebp)
  801cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbc:	29 d0                	sub    %edx,%eax
  801cbe:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801cc1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801cc8:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ccf:	76 07                	jbe    801cd8 <malloc+0x5e>
					return NULL ;
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	eb 39                	jmp    801d11 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	e8 e6 0d 00 00       	call   802ac9 <alloc_block_FF>
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801ce9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ced:	74 16                	je     801d05 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	ff 75 ec             	pushl  -0x14(%ebp)
  801cf5:	e8 37 0c 00 00       	call   802931 <insert_sorted_allocList>
  801cfa:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d00:	8b 40 08             	mov    0x8(%eax),%eax
  801d03:	eb 0c                	jmp    801d11 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 05                	jmp    801d11 <malloc+0x97>
				}
		}
	return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	ff 75 f4             	pushl  -0xc(%ebp)
  801d25:	68 40 50 80 00       	push   $0x805040
  801d2a:	e8 cf 0b 00 00       	call   8028fe <find_block>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d38:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d41:	8b 40 08             	mov    0x8(%eax),%eax
  801d44:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d4b:	0f 84 a1 00 00 00    	je     801df2 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801d51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d55:	75 17                	jne    801d6e <free+0x5b>
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 95 41 80 00       	push   $0x804195
  801d5f:	68 80 00 00 00       	push   $0x80
  801d64:	68 b3 41 80 00       	push   $0x8041b3
  801d69:	e8 b9 ec ff ff       	call   800a27 <_panic>
  801d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d71:	8b 00                	mov    (%eax),%eax
  801d73:	85 c0                	test   %eax,%eax
  801d75:	74 10                	je     801d87 <free+0x74>
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7f:	8b 52 04             	mov    0x4(%edx),%edx
  801d82:	89 50 04             	mov    %edx,0x4(%eax)
  801d85:	eb 0b                	jmp    801d92 <free+0x7f>
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	8b 40 04             	mov    0x4(%eax),%eax
  801d8d:	a3 44 50 80 00       	mov    %eax,0x805044
  801d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d95:	8b 40 04             	mov    0x4(%eax),%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	74 0f                	je     801dab <free+0x98>
  801d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9f:	8b 40 04             	mov    0x4(%eax),%eax
  801da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da5:	8b 12                	mov    (%edx),%edx
  801da7:	89 10                	mov    %edx,(%eax)
  801da9:	eb 0a                	jmp    801db5 <free+0xa2>
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	a3 40 50 80 00       	mov    %eax,0x805040
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dc8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dcd:	48                   	dec    %eax
  801dce:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd9:	e8 29 12 00 00       	call   803007 <insert_sorted_with_merge_freeList>
  801dde:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801de1:	83 ec 08             	sub    $0x8,%esp
  801de4:	ff 75 ec             	pushl  -0x14(%ebp)
  801de7:	ff 75 e8             	pushl  -0x18(%ebp)
  801dea:	e8 74 03 00 00       	call   802163 <sys_free_user_mem>
  801def:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 38             	sub    $0x38,%esp
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e01:	e8 5f fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e0a:	75 0a                	jne    801e16 <smalloc+0x21>
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	e9 b2 00 00 00       	jmp    801ec8 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801e16:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e1d:	76 0a                	jbe    801e29 <smalloc+0x34>
		return NULL;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	e9 9f 00 00 00       	jmp    801ec8 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801e29:	e8 3b 07 00 00       	call   802569 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	0f 84 8d 00 00 00    	je     801ec3 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801e36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801e3d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	48                   	dec    %eax
  801e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e53:	ba 00 00 00 00       	mov    $0x0,%edx
  801e58:	f7 75 f0             	divl   -0x10(%ebp)
  801e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5e:	29 d0                	sub    %edx,%eax
  801e60:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	ff 75 e8             	pushl  -0x18(%ebp)
  801e69:	e8 5b 0c 00 00       	call   802ac9 <alloc_block_FF>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e78:	75 07                	jne    801e81 <smalloc+0x8c>
			return NULL;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7f:	eb 47                	jmp    801ec8 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	ff 75 f4             	pushl  -0xc(%ebp)
  801e87:	e8 a5 0a 00 00       	call   802931 <insert_sorted_allocList>
  801e8c:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 40 08             	mov    0x8(%eax),%eax
  801e95:	89 c2                	mov    %eax,%edx
  801e97:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	e8 46 04 00 00       	call   8022ee <sys_createSharedObject>
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801eae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eb2:	78 08                	js     801ebc <smalloc+0xc7>
		return (void *)b->sva;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 40 08             	mov    0x8(%eax),%eax
  801eba:	eb 0c                	jmp    801ec8 <smalloc+0xd3>
		}else{
		return NULL;
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec1:	eb 05                	jmp    801ec8 <smalloc+0xd3>
			}

	}return NULL;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed0:	e8 90 fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ed5:	e8 8f 06 00 00       	call   802569 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 84 ad 00 00 00    	je     801f8f <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ee2:	83 ec 08             	sub    $0x8,%esp
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	e8 28 04 00 00       	call   802318 <sys_getSizeOfSharedObject>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801ef6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efa:	79 0a                	jns    801f06 <sget+0x3c>
    {
    	return NULL;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
  801f01:	e9 8e 00 00 00       	jmp    801f94 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801f06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801f0d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1a:	01 d0                	add    %edx,%eax
  801f1c:	48                   	dec    %eax
  801f1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f23:	ba 00 00 00 00       	mov    $0x0,%edx
  801f28:	f7 75 ec             	divl   -0x14(%ebp)
  801f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2e:	29 d0                	sub    %edx,%eax
  801f30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f39:	e8 8b 0b 00 00       	call   802ac9 <alloc_block_FF>
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f48:	75 07                	jne    801f51 <sget+0x87>
				return NULL;
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	eb 43                	jmp    801f94 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	ff 75 f0             	pushl  -0x10(%ebp)
  801f57:	e8 d5 09 00 00       	call   802931 <insert_sorted_allocList>
  801f5c:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	8b 40 08             	mov    0x8(%eax),%eax
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	50                   	push   %eax
  801f69:	ff 75 0c             	pushl  0xc(%ebp)
  801f6c:	ff 75 08             	pushl  0x8(%ebp)
  801f6f:	e8 c1 03 00 00       	call   802335 <sys_getSharedObject>
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801f7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f7e:	78 08                	js     801f88 <sget+0xbe>
			return (void *)b->sva;
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	eb 0c                	jmp    801f94 <sget+0xca>
			}else{
			return NULL;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	eb 05                	jmp    801f94 <sget+0xca>
			}
    }}return NULL;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f9c:	e8 c4 fa ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 e4 41 80 00       	push   $0x8041e4
  801fa9:	68 03 01 00 00       	push   $0x103
  801fae:	68 b3 41 80 00       	push   $0x8041b3
  801fb3:	e8 6f ea ff ff       	call   800a27 <_panic>

00801fb8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 0c 42 80 00       	push   $0x80420c
  801fc6:	68 17 01 00 00       	push   $0x117
  801fcb:	68 b3 41 80 00       	push   $0x8041b3
  801fd0:	e8 52 ea ff ff       	call   800a27 <_panic>

00801fd5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	68 30 42 80 00       	push   $0x804230
  801fe3:	68 22 01 00 00       	push   $0x122
  801fe8:	68 b3 41 80 00       	push   $0x8041b3
  801fed:	e8 35 ea ff ff       	call   800a27 <_panic>

00801ff2 <shrink>:

}
void shrink(uint32 newSize)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 30 42 80 00       	push   $0x804230
  802000:	68 27 01 00 00       	push   $0x127
  802005:	68 b3 41 80 00       	push   $0x8041b3
  80200a:	e8 18 ea ff ff       	call   800a27 <_panic>

0080200f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 30 42 80 00       	push   $0x804230
  80201d:	68 2c 01 00 00       	push   $0x12c
  802022:	68 b3 41 80 00       	push   $0x8041b3
  802027:	e8 fb e9 ff ff       	call   800a27 <_panic>

0080202c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	57                   	push   %edi
  802030:	56                   	push   %esi
  802031:	53                   	push   %ebx
  802032:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802041:	8b 7d 18             	mov    0x18(%ebp),%edi
  802044:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802047:	cd 30                	int    $0x30
  802049:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	5b                   	pop    %ebx
  802053:	5e                   	pop    %esi
  802054:	5f                   	pop    %edi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 10             	mov    0x10(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802063:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	52                   	push   %edx
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	50                   	push   %eax
  802073:	6a 00                	push   $0x0
  802075:	e8 b2 ff ff ff       	call   80202c <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	90                   	nop
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_cgetc>:

int
sys_cgetc(void)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 01                	push   $0x1
  80208f:	e8 98 ff ff ff       	call   80202c <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 05                	push   $0x5
  8020ac:	e8 7b ff ff ff       	call   80202c <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	56                   	push   %esi
  8020ba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8020be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	56                   	push   %esi
  8020cb:	53                   	push   %ebx
  8020cc:	51                   	push   %ecx
  8020cd:	52                   	push   %edx
  8020ce:	50                   	push   %eax
  8020cf:	6a 06                	push   $0x6
  8020d1:	e8 56 ff ff ff       	call   80202c <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
}
  8020d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020dc:	5b                   	pop    %ebx
  8020dd:	5e                   	pop    %esi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	6a 07                	push   $0x7
  8020f3:	e8 34 ff ff ff       	call   80202c <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	ff 75 0c             	pushl  0xc(%ebp)
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	6a 08                	push   $0x8
  80210e:	e8 19 ff ff ff       	call   80202c <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 09                	push   $0x9
  802127:	e8 00 ff ff ff       	call   80202c <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 0a                	push   $0xa
  802140:	e8 e7 fe ff ff       	call   80202c <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 0b                	push   $0xb
  802159:	e8 ce fe ff ff       	call   80202c <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	ff 75 08             	pushl  0x8(%ebp)
  802172:	6a 0f                	push   $0xf
  802174:	e8 b3 fe ff ff       	call   80202c <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
	return;
  80217c:	90                   	nop
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	ff 75 08             	pushl  0x8(%ebp)
  80218e:	6a 10                	push   $0x10
  802190:	e8 97 fe ff ff       	call   80202c <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
	return ;
  802198:	90                   	nop
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	ff 75 10             	pushl  0x10(%ebp)
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	ff 75 08             	pushl  0x8(%ebp)
  8021ab:	6a 11                	push   $0x11
  8021ad:	e8 7a fe ff ff       	call   80202c <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b5:	90                   	nop
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 0c                	push   $0xc
  8021c7:	e8 60 fe ff ff       	call   80202c <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	ff 75 08             	pushl  0x8(%ebp)
  8021df:	6a 0d                	push   $0xd
  8021e1:	e8 46 fe ff ff       	call   80202c <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 0e                	push   $0xe
  8021fa:	e8 2d fe ff ff       	call   80202c <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	90                   	nop
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 13                	push   $0x13
  802214:	e8 13 fe ff ff       	call   80202c <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	90                   	nop
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 14                	push   $0x14
  80222e:	e8 f9 fd ff ff       	call   80202c <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
}
  802236:	90                   	nop
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_cputc>:


void
sys_cputc(const char c)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802245:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	50                   	push   %eax
  802252:	6a 15                	push   $0x15
  802254:	e8 d3 fd ff ff       	call   80202c <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	90                   	nop
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 16                	push   $0x16
  80226e:	e8 b9 fd ff ff       	call   80202c <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	90                   	nop
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	50                   	push   %eax
  802289:	6a 17                	push   $0x17
  80228b:	e8 9c fd ff ff       	call   80202c <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	6a 1a                	push   $0x1a
  8022a8:	e8 7f fd ff ff       	call   80202c <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	52                   	push   %edx
  8022c2:	50                   	push   %eax
  8022c3:	6a 18                	push   $0x18
  8022c5:	e8 62 fd ff ff       	call   80202c <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	90                   	nop
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 19                	push   $0x19
  8022e3:	e8 44 fd ff ff       	call   80202c <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 04             	sub    $0x4,%esp
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	6a 00                	push   $0x0
  802306:	51                   	push   %ecx
  802307:	52                   	push   %edx
  802308:	ff 75 0c             	pushl  0xc(%ebp)
  80230b:	50                   	push   %eax
  80230c:	6a 1b                	push   $0x1b
  80230e:	e8 19 fd ff ff       	call   80202c <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80231b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	52                   	push   %edx
  802328:	50                   	push   %eax
  802329:	6a 1c                	push   $0x1c
  80232b:	e8 fc fc ff ff       	call   80202c <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802338:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	51                   	push   %ecx
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 1d                	push   $0x1d
  80234a:	e8 dd fc ff ff       	call   80202c <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	52                   	push   %edx
  802364:	50                   	push   %eax
  802365:	6a 1e                	push   $0x1e
  802367:	e8 c0 fc ff ff       	call   80202c <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 1f                	push   $0x1f
  802380:	e8 a7 fc ff ff       	call   80202c <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	ff 75 14             	pushl  0x14(%ebp)
  802395:	ff 75 10             	pushl  0x10(%ebp)
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	50                   	push   %eax
  80239c:	6a 20                	push   $0x20
  80239e:	e8 89 fc ff ff       	call   80202c <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	50                   	push   %eax
  8023b7:	6a 21                	push   $0x21
  8023b9:	e8 6e fc ff ff       	call   80202c <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	50                   	push   %eax
  8023d3:	6a 22                	push   $0x22
  8023d5:	e8 52 fc ff ff       	call   80202c <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 02                	push   $0x2
  8023ee:	e8 39 fc ff ff       	call   80202c <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 03                	push   $0x3
  802407:	e8 20 fc ff ff       	call   80202c <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 04                	push   $0x4
  802420:	e8 07 fc ff ff       	call   80202c <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_exit_env>:


void sys_exit_env(void)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 23                	push   $0x23
  802439:	e8 ee fb ff ff       	call   80202c <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	90                   	nop
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80244a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244d:	8d 50 04             	lea    0x4(%eax),%edx
  802450:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	52                   	push   %edx
  80245a:	50                   	push   %eax
  80245b:	6a 24                	push   $0x24
  80245d:	e8 ca fb ff ff       	call   80202c <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return result;
  802465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802468:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246e:	89 01                	mov    %eax,(%ecx)
  802470:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	c9                   	leave  
  802477:	c2 04 00             	ret    $0x4

0080247a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 10             	pushl  0x10(%ebp)
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 12                	push   $0x12
  80248c:	e8 9b fb ff ff       	call   80202c <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_rcr2>:
uint32 sys_rcr2()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 25                	push   $0x25
  8024a6:	e8 81 fb ff ff       	call   80202c <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024bc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	50                   	push   %eax
  8024c9:	6a 26                	push   $0x26
  8024cb:	e8 5c fb ff ff       	call   80202c <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <rsttst>:
void rsttst()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 28                	push   $0x28
  8024e5:	e8 42 fb ff ff       	call   80202c <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ed:	90                   	nop
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024fc:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	ff 75 10             	pushl  0x10(%ebp)
  802508:	ff 75 0c             	pushl  0xc(%ebp)
  80250b:	ff 75 08             	pushl  0x8(%ebp)
  80250e:	6a 27                	push   $0x27
  802510:	e8 17 fb ff ff       	call   80202c <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return ;
  802518:	90                   	nop
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <chktst>:
void chktst(uint32 n)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	ff 75 08             	pushl  0x8(%ebp)
  802529:	6a 29                	push   $0x29
  80252b:	e8 fc fa ff ff       	call   80202c <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
	return ;
  802533:	90                   	nop
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <inctst>:

void inctst()
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 2a                	push   $0x2a
  802545:	e8 e2 fa ff ff       	call   80202c <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
	return ;
  80254d:	90                   	nop
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <gettst>:
uint32 gettst()
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 2b                	push   $0x2b
  80255f:	e8 c8 fa ff ff       	call   80202c <syscall>
  802564:	83 c4 18             	add    $0x18,%esp
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 2c                	push   $0x2c
  80257b:	e8 ac fa ff ff       	call   80202c <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
  802583:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802586:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80258a:	75 07                	jne    802593 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80258c:	b8 01 00 00 00       	mov    $0x1,%eax
  802591:	eb 05                	jmp    802598 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 2c                	push   $0x2c
  8025ac:	e8 7b fa ff ff       	call   80202c <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
  8025b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025bb:	75 07                	jne    8025c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	eb 05                	jmp    8025c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 2c                	push   $0x2c
  8025dd:	e8 4a fa ff ff       	call   80202c <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
  8025e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025ec:	75 07                	jne    8025f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f3:	eb 05                	jmp    8025fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 2c                	push   $0x2c
  80260e:	e8 19 fa ff ff       	call   80202c <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
  802616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802619:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80261d:	75 07                	jne    802626 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80261f:	b8 01 00 00 00       	mov    $0x1,%eax
  802624:	eb 05                	jmp    80262b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	ff 75 08             	pushl  0x8(%ebp)
  80263b:	6a 2d                	push   $0x2d
  80263d:	e8 ea f9 ff ff       	call   80202c <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
	return ;
  802645:	90                   	nop
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80264c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802652:	8b 55 0c             	mov    0xc(%ebp),%edx
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	53                   	push   %ebx
  80265b:	51                   	push   %ecx
  80265c:	52                   	push   %edx
  80265d:	50                   	push   %eax
  80265e:	6a 2e                	push   $0x2e
  802660:	e8 c7 f9 ff ff       	call   80202c <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
}
  802668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802670:	8b 55 0c             	mov    0xc(%ebp),%edx
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	52                   	push   %edx
  80267d:	50                   	push   %eax
  80267e:	6a 2f                	push   $0x2f
  802680:	e8 a7 f9 ff ff       	call   80202c <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802690:	83 ec 0c             	sub    $0xc,%esp
  802693:	68 40 42 80 00       	push   $0x804240
  802698:	e8 3e e6 ff ff       	call   800cdb <cprintf>
  80269d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	68 6c 42 80 00       	push   $0x80426c
  8026af:	e8 27 e6 ff ff       	call   800cdb <cprintf>
  8026b4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026b7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c3:	eb 56                	jmp    80271b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c9:	74 1c                	je     8026e7 <print_mem_block_lists+0x5d>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 50 08             	mov    0x8(%eax),%edx
  8026d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d4:	8b 48 08             	mov    0x8(%eax),%ecx
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dd:	01 c8                	add    %ecx,%eax
  8026df:	39 c2                	cmp    %eax,%edx
  8026e1:	73 04                	jae    8026e7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026e3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 50 08             	mov    0x8(%eax),%edx
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	01 c2                	add    %eax,%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 08             	mov    0x8(%eax),%eax
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	52                   	push   %edx
  8026ff:	50                   	push   %eax
  802700:	68 81 42 80 00       	push   $0x804281
  802705:	e8 d1 e5 ff ff       	call   800cdb <cprintf>
  80270a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802713:	a1 40 51 80 00       	mov    0x805140,%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271f:	74 07                	je     802728 <print_mem_block_lists+0x9e>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	eb 05                	jmp    80272d <print_mem_block_lists+0xa3>
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	a3 40 51 80 00       	mov    %eax,0x805140
  802732:	a1 40 51 80 00       	mov    0x805140,%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	75 8a                	jne    8026c5 <print_mem_block_lists+0x3b>
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	75 84                	jne    8026c5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802741:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802745:	75 10                	jne    802757 <print_mem_block_lists+0xcd>
  802747:	83 ec 0c             	sub    $0xc,%esp
  80274a:	68 90 42 80 00       	push   $0x804290
  80274f:	e8 87 e5 ff ff       	call   800cdb <cprintf>
  802754:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802757:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	68 b4 42 80 00       	push   $0x8042b4
  802766:	e8 70 e5 ff ff       	call   800cdb <cprintf>
  80276b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80276e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802772:	a1 40 50 80 00       	mov    0x805040,%eax
  802777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277a:	eb 56                	jmp    8027d2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80277c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802780:	74 1c                	je     80279e <print_mem_block_lists+0x114>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 50 08             	mov    0x8(%eax),%edx
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 48 08             	mov    0x8(%eax),%ecx
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	8b 40 0c             	mov    0xc(%eax),%eax
  802794:	01 c8                	add    %ecx,%eax
  802796:	39 c2                	cmp    %eax,%edx
  802798:	73 04                	jae    80279e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80279a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 50 08             	mov    0x8(%eax),%edx
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	01 c2                	add    %eax,%edx
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	83 ec 04             	sub    $0x4,%esp
  8027b5:	52                   	push   %edx
  8027b6:	50                   	push   %eax
  8027b7:	68 81 42 80 00       	push   $0x804281
  8027bc:	e8 1a e5 ff ff       	call   800cdb <cprintf>
  8027c1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ca:	a1 48 50 80 00       	mov    0x805048,%eax
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	74 07                	je     8027df <print_mem_block_lists+0x155>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	eb 05                	jmp    8027e4 <print_mem_block_lists+0x15a>
  8027df:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e4:	a3 48 50 80 00       	mov    %eax,0x805048
  8027e9:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	75 8a                	jne    80277c <print_mem_block_lists+0xf2>
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	75 84                	jne    80277c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027f8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027fc:	75 10                	jne    80280e <print_mem_block_lists+0x184>
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	68 cc 42 80 00       	push   $0x8042cc
  802806:	e8 d0 e4 ff ff       	call   800cdb <cprintf>
  80280b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	68 40 42 80 00       	push   $0x804240
  802816:	e8 c0 e4 ff ff       	call   800cdb <cprintf>
  80281b:	83 c4 10             	add    $0x10,%esp

}
  80281e:	90                   	nop
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
  802824:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802827:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80282e:	00 00 00 
  802831:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802838:	00 00 00 
  80283b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802842:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802845:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80284c:	e9 9e 00 00 00       	jmp    8028ef <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802851:	a1 50 50 80 00       	mov    0x805050,%eax
  802856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802859:	c1 e2 04             	shl    $0x4,%edx
  80285c:	01 d0                	add    %edx,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	75 14                	jne    802876 <initialize_MemBlocksList+0x55>
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 f4 42 80 00       	push   $0x8042f4
  80286a:	6a 3d                	push   $0x3d
  80286c:	68 17 43 80 00       	push   $0x804317
  802871:	e8 b1 e1 ff ff       	call   800a27 <_panic>
  802876:	a1 50 50 80 00       	mov    0x805050,%eax
  80287b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287e:	c1 e2 04             	shl    $0x4,%edx
  802881:	01 d0                	add    %edx,%eax
  802883:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802889:	89 10                	mov    %edx,(%eax)
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 18                	je     8028a9 <initialize_MemBlocksList+0x88>
  802891:	a1 48 51 80 00       	mov    0x805148,%eax
  802896:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80289c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80289f:	c1 e1 04             	shl    $0x4,%ecx
  8028a2:	01 ca                	add    %ecx,%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 12                	jmp    8028bb <initialize_MemBlocksList+0x9a>
  8028a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c1 e2 04             	shl    $0x4,%edx
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c3:	c1 e2 04             	shl    $0x4,%edx
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8028cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d5:	c1 e2 04             	shl    $0x4,%edx
  8028d8:	01 d0                	add    %edx,%eax
  8028da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8028e6:	40                   	inc    %eax
  8028e7:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8028ec:	ff 45 f4             	incl   -0xc(%ebp)
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f5:	0f 82 56 ff ff ff    	jb     802851 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8028fb:	90                   	nop
  8028fc:	c9                   	leave  
  8028fd:	c3                   	ret    

008028fe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80290c:	eb 18                	jmp    802926 <find_block+0x28>

		if(tmp->sva == va){
  80290e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802911:	8b 40 08             	mov    0x8(%eax),%eax
  802914:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802917:	75 05                	jne    80291e <find_block+0x20>
			return tmp ;
  802919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291c:	eb 11                	jmp    80292f <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80291e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802926:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80292a:	75 e2                	jne    80290e <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80292c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802937:	a1 40 50 80 00       	mov    0x805040,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80293f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802944:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802947:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80294b:	75 65                	jne    8029b2 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80294d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802951:	75 14                	jne    802967 <insert_sorted_allocList+0x36>
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	68 f4 42 80 00       	push   $0x8042f4
  80295b:	6a 62                	push   $0x62
  80295d:	68 17 43 80 00       	push   $0x804317
  802962:	e8 c0 e0 ff ff       	call   800a27 <_panic>
  802967:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	89 10                	mov    %edx,(%eax)
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	74 0d                	je     802988 <insert_sorted_allocList+0x57>
  80297b:	a1 40 50 80 00       	mov    0x805040,%eax
  802980:	8b 55 08             	mov    0x8(%ebp),%edx
  802983:	89 50 04             	mov    %edx,0x4(%eax)
  802986:	eb 08                	jmp    802990 <insert_sorted_allocList+0x5f>
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	a3 44 50 80 00       	mov    %eax,0x805044
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	a3 40 50 80 00       	mov    %eax,0x805040
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a7:	40                   	inc    %eax
  8029a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8029ad:	e9 14 01 00 00       	jmp    802ac6 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8029bd:	8b 40 08             	mov    0x8(%eax),%eax
  8029c0:	39 c2                	cmp    %eax,%edx
  8029c2:	76 65                	jbe    802a29 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8029c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c8:	75 14                	jne    8029de <insert_sorted_allocList+0xad>
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	68 30 43 80 00       	push   $0x804330
  8029d2:	6a 64                	push   $0x64
  8029d4:	68 17 43 80 00       	push   $0x804317
  8029d9:	e8 49 e0 ff ff       	call   800a27 <_panic>
  8029de:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0c                	je     802a00 <insert_sorted_allocList+0xcf>
  8029f4:	a1 44 50 80 00       	mov    0x805044,%eax
  8029f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	eb 08                	jmp    802a08 <insert_sorted_allocList+0xd7>
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 40 50 80 00       	mov    %eax,0x805040
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	a3 44 50 80 00       	mov    %eax,0x805044
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a19:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a1e:	40                   	inc    %eax
  802a1f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a24:	e9 9d 00 00 00       	jmp    802ac6 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802a29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802a30:	e9 85 00 00 00       	jmp    802aba <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	8b 50 08             	mov    0x8(%eax),%edx
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 08             	mov    0x8(%eax),%eax
  802a41:	39 c2                	cmp    %eax,%edx
  802a43:	73 6a                	jae    802aaf <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a49:	74 06                	je     802a51 <insert_sorted_allocList+0x120>
  802a4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4f:	75 14                	jne    802a65 <insert_sorted_allocList+0x134>
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	68 54 43 80 00       	push   $0x804354
  802a59:	6a 6b                	push   $0x6b
  802a5b:	68 17 43 80 00       	push   $0x804317
  802a60:	e8 c2 df ff ff       	call   800a27 <_panic>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 50 04             	mov    0x4(%eax),%edx
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 0d                	je     802a90 <insert_sorted_allocList+0x15f>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 08                	jmp    802a98 <insert_sorted_allocList+0x167>
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	a3 40 50 80 00       	mov    %eax,0x805040
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9e:	89 50 04             	mov    %edx,0x4(%eax)
  802aa1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa6:	40                   	inc    %eax
  802aa7:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802aac:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802aad:	eb 17                	jmp    802ac6 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802ab7:	ff 45 f0             	incl   -0x10(%ebp)
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ac0:	0f 8c 6f ff ff ff    	jl     802a35 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ac6:	90                   	nop
  802ac7:	c9                   	leave  
  802ac8:	c3                   	ret    

00802ac9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ac9:	55                   	push   %ebp
  802aca:	89 e5                	mov    %esp,%ebp
  802acc:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802acf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802ad7:	e9 7c 01 00 00       	jmp    802c58 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae5:	0f 86 cf 00 00 00    	jbe    802bba <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802aeb:	a1 48 51 80 00       	mov    0x805148,%eax
  802af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af6:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afc:	8b 55 08             	mov    0x8(%ebp),%edx
  802aff:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	2b 45 08             	sub    0x8(%ebp),%eax
  802b17:	89 c2                	mov    %eax,%edx
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 50 08             	mov    0x8(%eax),%edx
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	01 c2                	add    %eax,%edx
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802b30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b34:	75 17                	jne    802b4d <alloc_block_FF+0x84>
  802b36:	83 ec 04             	sub    $0x4,%esp
  802b39:	68 89 43 80 00       	push   $0x804389
  802b3e:	68 83 00 00 00       	push   $0x83
  802b43:	68 17 43 80 00       	push   $0x804317
  802b48:	e8 da de ff ff       	call   800a27 <_panic>
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 10                	je     802b66 <alloc_block_FF+0x9d>
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5e:	8b 52 04             	mov    0x4(%edx),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 0b                	jmp    802b71 <alloc_block_FF+0xa8>
  802b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0f                	je     802b8a <alloc_block_FF+0xc1>
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b84:	8b 12                	mov    (%edx),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	eb 0a                	jmp    802b94 <alloc_block_FF+0xcb>
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bac:	48                   	dec    %eax
  802bad:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	e9 ad 00 00 00       	jmp    802c67 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	0f 85 87 00 00 00    	jne    802c50 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block_FF+0x11d>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 89 43 80 00       	push   $0x804389
  802bd7:	68 87 00 00 00       	push   $0x87
  802bdc:	68 17 43 80 00       	push   $0x804317
  802be1:	e8 41 de ff ff       	call   800a27 <_panic>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 10                	je     802bff <alloc_block_FF+0x136>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf7:	8b 52 04             	mov    0x4(%edx),%edx
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	eb 0b                	jmp    802c0a <alloc_block_FF+0x141>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 0f                	je     802c23 <alloc_block_FF+0x15a>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1d:	8b 12                	mov    (%edx),%edx
  802c1f:	89 10                	mov    %edx,(%eax)
  802c21:	eb 0a                	jmp    802c2d <alloc_block_FF+0x164>
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c40:	a1 44 51 80 00       	mov    0x805144,%eax
  802c45:	48                   	dec    %eax
  802c46:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	eb 17                	jmp    802c67 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5c:	0f 85 7a fe ff ff    	jne    802adc <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802c6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802c77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802c7e:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802c85:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8d:	e9 d0 00 00 00       	jmp    802d62 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9b:	0f 82 b8 00 00 00    	jb     802d59 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	2b 45 08             	sub    0x8(%ebp),%eax
  802caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cb3:	0f 83 a1 00 00 00    	jae    802d5a <alloc_block_BF+0xf1>
				differsize = differance ;
  802cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cc9:	0f 85 8b 00 00 00    	jne    802d5a <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd3:	75 17                	jne    802cec <alloc_block_BF+0x83>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 89 43 80 00       	push   $0x804389
  802cdd:	68 a0 00 00 00       	push   $0xa0
  802ce2:	68 17 43 80 00       	push   $0x804317
  802ce7:	e8 3b dd ff ff       	call   800a27 <_panic>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <alloc_block_BF+0x9c>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <alloc_block_BF+0xa7>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <alloc_block_BF+0xc0>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <alloc_block_BF+0xca>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	e9 0c 01 00 00       	jmp    802e65 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802d59:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802d5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	74 07                	je     802d6f <alloc_block_BF+0x106>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	eb 05                	jmp    802d74 <alloc_block_BF+0x10b>
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d74:	a3 40 51 80 00       	mov    %eax,0x805140
  802d79:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	0f 85 0c ff ff ff    	jne    802c92 <alloc_block_BF+0x29>
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	0f 85 02 ff ff ff    	jne    802c92 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d94:	0f 84 c6 00 00 00    	je     802e60 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802d9a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da5:	8b 55 08             	mov    0x8(%ebp),%edx
  802da8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db4:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbd:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc0:	89 c2                	mov    %eax,%edx
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 50 08             	mov    0x8(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	01 c2                	add    %eax,%edx
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802dd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ddd:	75 17                	jne    802df6 <alloc_block_BF+0x18d>
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 89 43 80 00       	push   $0x804389
  802de7:	68 af 00 00 00       	push   $0xaf
  802dec:	68 17 43 80 00       	push   $0x804317
  802df1:	e8 31 dc ff ff       	call   800a27 <_panic>
  802df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 10                	je     802e0f <alloc_block_BF+0x1a6>
  802dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e07:	8b 52 04             	mov    0x4(%edx),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 0b                	jmp    802e1a <alloc_block_BF+0x1b1>
  802e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 0f                	je     802e33 <alloc_block_BF+0x1ca>
  802e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e27:	8b 40 04             	mov    0x4(%eax),%eax
  802e2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e2d:	8b 12                	mov    (%edx),%edx
  802e2f:	89 10                	mov    %edx,(%eax)
  802e31:	eb 0a                	jmp    802e3d <alloc_block_BF+0x1d4>
  802e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	a3 48 51 80 00       	mov    %eax,0x805148
  802e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e50:	a1 54 51 80 00       	mov    0x805154,%eax
  802e55:	48                   	dec    %eax
  802e56:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	eb 05                	jmp    802e65 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e65:	c9                   	leave  
  802e66:	c3                   	ret    

00802e67 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802e67:	55                   	push   %ebp
  802e68:	89 e5                	mov    %esp,%ebp
  802e6a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802e6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802e75:	e9 7c 01 00 00       	jmp    802ff6 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e83:	0f 86 cf 00 00 00    	jbe    802f58 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802e89:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9d:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 50 08             	mov    0x8(%eax),%edx
  802ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea9:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	2b 45 08             	sub    0x8(%ebp),%eax
  802eb5:	89 c2                	mov    %eax,%edx
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 50 08             	mov    0x8(%eax),%edx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	01 c2                	add    %eax,%edx
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802ece:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ed2:	75 17                	jne    802eeb <alloc_block_NF+0x84>
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	68 89 43 80 00       	push   $0x804389
  802edc:	68 c4 00 00 00       	push   $0xc4
  802ee1:	68 17 43 80 00       	push   $0x804317
  802ee6:	e8 3c db ff ff       	call   800a27 <_panic>
  802eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 10                	je     802f04 <alloc_block_NF+0x9d>
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802efc:	8b 52 04             	mov    0x4(%edx),%edx
  802eff:	89 50 04             	mov    %edx,0x4(%eax)
  802f02:	eb 0b                	jmp    802f0f <alloc_block_NF+0xa8>
  802f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 0f                	je     802f28 <alloc_block_NF+0xc1>
  802f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f22:	8b 12                	mov    (%edx),%edx
  802f24:	89 10                	mov    %edx,(%eax)
  802f26:	eb 0a                	jmp    802f32 <alloc_block_NF+0xcb>
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f45:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4a:	48                   	dec    %eax
  802f4b:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f53:	e9 ad 00 00 00       	jmp    803005 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f61:	0f 85 87 00 00 00    	jne    802fee <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	75 17                	jne    802f84 <alloc_block_NF+0x11d>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 89 43 80 00       	push   $0x804389
  802f75:	68 c8 00 00 00       	push   $0xc8
  802f7a:	68 17 43 80 00       	push   $0x804317
  802f7f:	e8 a3 da ff ff       	call   800a27 <_panic>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 10                	je     802f9d <alloc_block_NF+0x136>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f95:	8b 52 04             	mov    0x4(%edx),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <alloc_block_NF+0x141>
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0f                	je     802fc1 <alloc_block_NF+0x15a>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbb:	8b 12                	mov    (%edx),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 0a                	jmp    802fcb <alloc_block_NF+0x164>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe3:	48                   	dec    %eax
  802fe4:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	eb 17                	jmp    803005 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	0f 85 7a fe ff ff    	jne    802e7a <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803000:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
  80300a:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80300d:	a1 38 51 80 00       	mov    0x805138,%eax
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803015:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301a:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80301d:	a1 44 51 80 00       	mov    0x805144,%eax
  803022:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803025:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803029:	75 68                	jne    803093 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80302b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302f:	75 17                	jne    803048 <insert_sorted_with_merge_freeList+0x41>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 f4 42 80 00       	push   $0x8042f4
  803039:	68 da 00 00 00       	push   $0xda
  80303e:	68 17 43 80 00       	push   $0x804317
  803043:	e8 df d9 ff ff       	call   800a27 <_panic>
  803048:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0d                	je     803069 <insert_sorted_with_merge_freeList+0x62>
  80305c:	a1 38 51 80 00       	mov    0x805138,%eax
  803061:	8b 55 08             	mov    0x8(%ebp),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	eb 08                	jmp    803071 <insert_sorted_with_merge_freeList+0x6a>
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	a3 38 51 80 00       	mov    %eax,0x805138
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803083:	a1 44 51 80 00       	mov    0x805144,%eax
  803088:	40                   	inc    %eax
  803089:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80308e:	e9 49 07 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	8b 50 08             	mov    0x8(%eax),%edx
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 40 0c             	mov    0xc(%eax),%eax
  80309f:	01 c2                	add    %eax,%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	8b 40 08             	mov    0x8(%eax),%eax
  8030a7:	39 c2                	cmp    %eax,%edx
  8030a9:	73 77                	jae    803122 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	75 6e                	jne    803122 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8030b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b8:	74 68                	je     803122 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8030ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030be:	75 17                	jne    8030d7 <insert_sorted_with_merge_freeList+0xd0>
  8030c0:	83 ec 04             	sub    $0x4,%esp
  8030c3:	68 30 43 80 00       	push   $0x804330
  8030c8:	68 e0 00 00 00       	push   $0xe0
  8030cd:	68 17 43 80 00       	push   $0x804317
  8030d2:	e8 50 d9 ff ff       	call   800a27 <_panic>
  8030d7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0c                	je     8030f9 <insert_sorted_with_merge_freeList+0xf2>
  8030ed:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	eb 08                	jmp    803101 <insert_sorted_with_merge_freeList+0xfa>
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803112:	a1 44 51 80 00       	mov    0x805144,%eax
  803117:	40                   	inc    %eax
  803118:	a3 44 51 80 00       	mov    %eax,0x805144
  80311d:	e9 ba 06 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 50 0c             	mov    0xc(%eax),%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	8b 40 08             	mov    0x8(%eax),%eax
  80312e:	01 c2                	add    %eax,%edx
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 40 08             	mov    0x8(%eax),%eax
  803136:	39 c2                	cmp    %eax,%edx
  803138:	73 78                	jae    8031b2 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	75 6e                	jne    8031b2 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803144:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803148:	74 68                	je     8031b2 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80314a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314e:	75 17                	jne    803167 <insert_sorted_with_merge_freeList+0x160>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 f4 42 80 00       	push   $0x8042f4
  803158:	68 e6 00 00 00       	push   $0xe6
  80315d:	68 17 43 80 00       	push   $0x804317
  803162:	e8 c0 d8 ff ff       	call   800a27 <_panic>
  803167:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	89 10                	mov    %edx,(%eax)
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0d                	je     803188 <insert_sorted_with_merge_freeList+0x181>
  80317b:	a1 38 51 80 00       	mov    0x805138,%eax
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 08                	jmp    803190 <insert_sorted_with_merge_freeList+0x189>
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	a3 38 51 80 00       	mov    %eax,0x805138
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a7:	40                   	inc    %eax
  8031a8:	a3 44 51 80 00       	mov    %eax,0x805144
  8031ad:	e9 2a 06 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8031b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ba:	e9 ed 05 00 00       	jmp    8037ac <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8031c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031cb:	0f 84 a7 00 00 00    	je     803278 <insert_sorted_with_merge_freeList+0x271>
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 08             	mov    0x8(%eax),%eax
  8031dd:	01 c2                	add    %eax,%edx
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 40 08             	mov    0x8(%eax),%eax
  8031e5:	39 c2                	cmp    %eax,%edx
  8031e7:	0f 83 8b 00 00 00    	jae    803278 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 40 08             	mov    0x8(%eax),%eax
  8031f9:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803201:	39 c2                	cmp    %eax,%edx
  803203:	73 73                	jae    803278 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803209:	74 06                	je     803211 <insert_sorted_with_merge_freeList+0x20a>
  80320b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320f:	75 17                	jne    803228 <insert_sorted_with_merge_freeList+0x221>
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 a8 43 80 00       	push   $0x8043a8
  803219:	68 f0 00 00 00       	push   $0xf0
  80321e:	68 17 43 80 00       	push   $0x804317
  803223:	e8 ff d7 ff ff       	call   800a27 <_panic>
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 10                	mov    (%eax),%edx
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0b                	je     803246 <insert_sorted_with_merge_freeList+0x23f>
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	8b 55 08             	mov    0x8(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 55 08             	mov    0x8(%ebp),%edx
  80324c:	89 10                	mov    %edx,(%eax)
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	75 08                	jne    803268 <insert_sorted_with_merge_freeList+0x261>
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803268:	a1 44 51 80 00       	mov    0x805144,%eax
  80326d:	40                   	inc    %eax
  80326e:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803273:	e9 64 05 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803278:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327d:	8b 50 0c             	mov    0xc(%eax),%edx
  803280:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803285:	8b 40 08             	mov    0x8(%eax),%eax
  803288:	01 c2                	add    %eax,%edx
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	8b 40 08             	mov    0x8(%eax),%eax
  803290:	39 c2                	cmp    %eax,%edx
  803292:	0f 85 b1 00 00 00    	jne    803349 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803298:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80329d:	85 c0                	test   %eax,%eax
  80329f:	0f 84 a4 00 00 00    	je     803349 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  8032a5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	0f 85 95 00 00 00    	jne    803349 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  8032b4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032b9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032bf:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8032c8:	01 ca                	add    %ecx,%edx
  8032ca:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8032e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e5:	75 17                	jne    8032fe <insert_sorted_with_merge_freeList+0x2f7>
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	68 f4 42 80 00       	push   $0x8042f4
  8032ef:	68 ff 00 00 00       	push   $0xff
  8032f4:	68 17 43 80 00       	push   $0x804317
  8032f9:	e8 29 d7 ff ff       	call   800a27 <_panic>
  8032fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	89 10                	mov    %edx,(%eax)
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0d                	je     80331f <insert_sorted_with_merge_freeList+0x318>
  803312:	a1 48 51 80 00       	mov    0x805148,%eax
  803317:	8b 55 08             	mov    0x8(%ebp),%edx
  80331a:	89 50 04             	mov    %edx,0x4(%eax)
  80331d:	eb 08                	jmp    803327 <insert_sorted_with_merge_freeList+0x320>
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	a3 48 51 80 00       	mov    %eax,0x805148
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803339:	a1 54 51 80 00       	mov    0x805154,%eax
  80333e:	40                   	inc    %eax
  80333f:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803344:	e9 93 04 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 50 08             	mov    0x8(%eax),%edx
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	8b 40 0c             	mov    0xc(%eax),%eax
  803355:	01 c2                	add    %eax,%edx
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	8b 40 08             	mov    0x8(%eax),%eax
  80335d:	39 c2                	cmp    %eax,%edx
  80335f:	0f 85 ae 00 00 00    	jne    803413 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	8b 50 0c             	mov    0xc(%eax),%edx
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 40 08             	mov    0x8(%eax),%eax
  803371:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  80337b:	39 c2                	cmp    %eax,%edx
  80337d:	0f 84 90 00 00 00    	je     803413 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 50 0c             	mov    0xc(%eax),%edx
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 40 0c             	mov    0xc(%eax),%eax
  80338f:	01 c2                	add    %eax,%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x3c1>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 f4 42 80 00       	push   $0x8042f4
  8033b9:	68 0b 01 00 00       	push   $0x10b
  8033be:	68 17 43 80 00       	push   $0x804317
  8033c3:	e8 5f d6 ff ff       	call   800a27 <_panic>
  8033c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0d                	je     8033e9 <insert_sorted_with_merge_freeList+0x3e2>
  8033dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 08                	jmp    8033f1 <insert_sorted_with_merge_freeList+0x3ea>
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803403:	a1 54 51 80 00       	mov    0x805154,%eax
  803408:	40                   	inc    %eax
  803409:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80340e:	e9 c9 03 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 50 0c             	mov    0xc(%eax),%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 40 08             	mov    0x8(%eax),%eax
  80341f:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803427:	39 c2                	cmp    %eax,%edx
  803429:	0f 85 bb 00 00 00    	jne    8034ea <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80342f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803433:	0f 84 b1 00 00 00    	je     8034ea <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	0f 85 a3 00 00 00    	jne    8034ea <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803447:	a1 38 51 80 00       	mov    0x805138,%eax
  80344c:	8b 55 08             	mov    0x8(%ebp),%edx
  80344f:	8b 52 08             	mov    0x8(%edx),%edx
  803452:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803455:	a1 38 51 80 00       	mov    0x805138,%eax
  80345a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803460:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803463:	8b 55 08             	mov    0x8(%ebp),%edx
  803466:	8b 52 0c             	mov    0xc(%edx),%edx
  803469:	01 ca                	add    %ecx,%edx
  80346b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803482:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803486:	75 17                	jne    80349f <insert_sorted_with_merge_freeList+0x498>
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	68 f4 42 80 00       	push   $0x8042f4
  803490:	68 17 01 00 00       	push   $0x117
  803495:	68 17 43 80 00       	push   $0x804317
  80349a:	e8 88 d5 ff ff       	call   800a27 <_panic>
  80349f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	74 0d                	je     8034c0 <insert_sorted_with_merge_freeList+0x4b9>
  8034b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034bb:	89 50 04             	mov    %edx,0x4(%eax)
  8034be:	eb 08                	jmp    8034c8 <insert_sorted_with_merge_freeList+0x4c1>
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034da:	a1 54 51 80 00       	mov    0x805154,%eax
  8034df:	40                   	inc    %eax
  8034e0:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8034e5:	e9 f2 02 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	8b 50 08             	mov    0x8(%eax),%edx
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f6:	01 c2                	add    %eax,%edx
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 40 08             	mov    0x8(%eax),%eax
  8034fe:	39 c2                	cmp    %eax,%edx
  803500:	0f 85 be 00 00 00    	jne    8035c4 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 50 08             	mov    0x8(%eax),%edx
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	8b 40 0c             	mov    0xc(%eax),%eax
  803518:	01 c2                	add    %eax,%edx
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	8b 40 08             	mov    0x8(%eax),%eax
  803520:	39 c2                	cmp    %eax,%edx
  803522:	0f 84 9c 00 00 00    	je     8035c4 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	8b 50 08             	mov    0x8(%eax),%edx
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 50 0c             	mov    0xc(%eax),%edx
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	8b 40 0c             	mov    0xc(%eax),%eax
  803540:	01 c2                	add    %eax,%edx
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80355c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803560:	75 17                	jne    803579 <insert_sorted_with_merge_freeList+0x572>
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	68 f4 42 80 00       	push   $0x8042f4
  80356a:	68 26 01 00 00       	push   $0x126
  80356f:	68 17 43 80 00       	push   $0x804317
  803574:	e8 ae d4 ff ff       	call   800a27 <_panic>
  803579:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	89 10                	mov    %edx,(%eax)
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 0d                	je     80359a <insert_sorted_with_merge_freeList+0x593>
  80358d:	a1 48 51 80 00       	mov    0x805148,%eax
  803592:	8b 55 08             	mov    0x8(%ebp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	eb 08                	jmp    8035a2 <insert_sorted_with_merge_freeList+0x59b>
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b9:	40                   	inc    %eax
  8035ba:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8035bf:	e9 18 02 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 40 08             	mov    0x8(%eax),%eax
  8035d0:	01 c2                	add    %eax,%edx
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 40 08             	mov    0x8(%eax),%eax
  8035d8:	39 c2                	cmp    %eax,%edx
  8035da:	0f 85 c4 01 00 00    	jne    8037a4 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 40 08             	mov    0x8(%eax),%eax
  8035ec:	01 c2                	add    %eax,%edx
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	8b 40 08             	mov    0x8(%eax),%eax
  8035f6:	39 c2                	cmp    %eax,%edx
  8035f8:	0f 85 a6 01 00 00    	jne    8037a4 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803602:	0f 84 9c 01 00 00    	je     8037a4 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 50 0c             	mov    0xc(%eax),%edx
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	8b 40 0c             	mov    0xc(%eax),%eax
  803614:	01 c2                	add    %eax,%edx
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	8b 40 0c             	mov    0xc(%eax),%eax
  80361e:	01 c2                	add    %eax,%edx
  803620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803623:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80363a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363e:	75 17                	jne    803657 <insert_sorted_with_merge_freeList+0x650>
  803640:	83 ec 04             	sub    $0x4,%esp
  803643:	68 f4 42 80 00       	push   $0x8042f4
  803648:	68 32 01 00 00       	push   $0x132
  80364d:	68 17 43 80 00       	push   $0x804317
  803652:	e8 d0 d3 ff ff       	call   800a27 <_panic>
  803657:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	89 10                	mov    %edx,(%eax)
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	85 c0                	test   %eax,%eax
  803669:	74 0d                	je     803678 <insert_sorted_with_merge_freeList+0x671>
  80366b:	a1 48 51 80 00       	mov    0x805148,%eax
  803670:	8b 55 08             	mov    0x8(%ebp),%edx
  803673:	89 50 04             	mov    %edx,0x4(%eax)
  803676:	eb 08                	jmp    803680 <insert_sorted_with_merge_freeList+0x679>
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	a3 48 51 80 00       	mov    %eax,0x805148
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803692:	a1 54 51 80 00       	mov    0x805154,%eax
  803697:	40                   	inc    %eax
  803698:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a0:	8b 00                	mov    (%eax),%eax
  8036a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8036a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	8b 00                	mov    (%eax),%eax
  8036ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8036bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c1:	75 17                	jne    8036da <insert_sorted_with_merge_freeList+0x6d3>
  8036c3:	83 ec 04             	sub    $0x4,%esp
  8036c6:	68 89 43 80 00       	push   $0x804389
  8036cb:	68 36 01 00 00       	push   $0x136
  8036d0:	68 17 43 80 00       	push   $0x804317
  8036d5:	e8 4d d3 ff ff       	call   800a27 <_panic>
  8036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 10                	je     8036f3 <insert_sorted_with_merge_freeList+0x6ec>
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036eb:	8b 52 04             	mov    0x4(%edx),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	eb 0b                	jmp    8036fe <insert_sorted_with_merge_freeList+0x6f7>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803701:	8b 40 04             	mov    0x4(%eax),%eax
  803704:	85 c0                	test   %eax,%eax
  803706:	74 0f                	je     803717 <insert_sorted_with_merge_freeList+0x710>
  803708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803711:	8b 12                	mov    (%edx),%edx
  803713:	89 10                	mov    %edx,(%eax)
  803715:	eb 0a                	jmp    803721 <insert_sorted_with_merge_freeList+0x71a>
  803717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371a:	8b 00                	mov    (%eax),%eax
  80371c:	a3 38 51 80 00       	mov    %eax,0x805138
  803721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803734:	a1 44 51 80 00       	mov    0x805144,%eax
  803739:	48                   	dec    %eax
  80373a:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80373f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803743:	75 17                	jne    80375c <insert_sorted_with_merge_freeList+0x755>
  803745:	83 ec 04             	sub    $0x4,%esp
  803748:	68 f4 42 80 00       	push   $0x8042f4
  80374d:	68 37 01 00 00       	push   $0x137
  803752:	68 17 43 80 00       	push   $0x804317
  803757:	e8 cb d2 ff ff       	call   800a27 <_panic>
  80375c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	89 10                	mov    %edx,(%eax)
  803767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	85 c0                	test   %eax,%eax
  80376e:	74 0d                	je     80377d <insert_sorted_with_merge_freeList+0x776>
  803770:	a1 48 51 80 00       	mov    0x805148,%eax
  803775:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803778:	89 50 04             	mov    %edx,0x4(%eax)
  80377b:	eb 08                	jmp    803785 <insert_sorted_with_merge_freeList+0x77e>
  80377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803780:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803788:	a3 48 51 80 00       	mov    %eax,0x805148
  80378d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803797:	a1 54 51 80 00       	mov    0x805154,%eax
  80379c:	40                   	inc    %eax
  80379d:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  8037a2:	eb 38                	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8037a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b0:	74 07                	je     8037b9 <insert_sorted_with_merge_freeList+0x7b2>
  8037b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	eb 05                	jmp    8037be <insert_sorted_with_merge_freeList+0x7b7>
  8037b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037be:	a3 40 51 80 00       	mov    %eax,0x805140
  8037c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	0f 85 ef f9 ff ff    	jne    8031bf <insert_sorted_with_merge_freeList+0x1b8>
  8037d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d4:	0f 85 e5 f9 ff ff    	jne    8031bf <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8037da:	eb 00                	jmp    8037dc <insert_sorted_with_merge_freeList+0x7d5>
  8037dc:	90                   	nop
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    
  8037df:	90                   	nop

008037e0 <__udivdi3>:
  8037e0:	55                   	push   %ebp
  8037e1:	57                   	push   %edi
  8037e2:	56                   	push   %esi
  8037e3:	53                   	push   %ebx
  8037e4:	83 ec 1c             	sub    $0x1c,%esp
  8037e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037f7:	89 ca                	mov    %ecx,%edx
  8037f9:	89 f8                	mov    %edi,%eax
  8037fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ff:	85 f6                	test   %esi,%esi
  803801:	75 2d                	jne    803830 <__udivdi3+0x50>
  803803:	39 cf                	cmp    %ecx,%edi
  803805:	77 65                	ja     80386c <__udivdi3+0x8c>
  803807:	89 fd                	mov    %edi,%ebp
  803809:	85 ff                	test   %edi,%edi
  80380b:	75 0b                	jne    803818 <__udivdi3+0x38>
  80380d:	b8 01 00 00 00       	mov    $0x1,%eax
  803812:	31 d2                	xor    %edx,%edx
  803814:	f7 f7                	div    %edi
  803816:	89 c5                	mov    %eax,%ebp
  803818:	31 d2                	xor    %edx,%edx
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	f7 f5                	div    %ebp
  80381e:	89 c1                	mov    %eax,%ecx
  803820:	89 d8                	mov    %ebx,%eax
  803822:	f7 f5                	div    %ebp
  803824:	89 cf                	mov    %ecx,%edi
  803826:	89 fa                	mov    %edi,%edx
  803828:	83 c4 1c             	add    $0x1c,%esp
  80382b:	5b                   	pop    %ebx
  80382c:	5e                   	pop    %esi
  80382d:	5f                   	pop    %edi
  80382e:	5d                   	pop    %ebp
  80382f:	c3                   	ret    
  803830:	39 ce                	cmp    %ecx,%esi
  803832:	77 28                	ja     80385c <__udivdi3+0x7c>
  803834:	0f bd fe             	bsr    %esi,%edi
  803837:	83 f7 1f             	xor    $0x1f,%edi
  80383a:	75 40                	jne    80387c <__udivdi3+0x9c>
  80383c:	39 ce                	cmp    %ecx,%esi
  80383e:	72 0a                	jb     80384a <__udivdi3+0x6a>
  803840:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803844:	0f 87 9e 00 00 00    	ja     8038e8 <__udivdi3+0x108>
  80384a:	b8 01 00 00 00       	mov    $0x1,%eax
  80384f:	89 fa                	mov    %edi,%edx
  803851:	83 c4 1c             	add    $0x1c,%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5f                   	pop    %edi
  803857:	5d                   	pop    %ebp
  803858:	c3                   	ret    
  803859:	8d 76 00             	lea    0x0(%esi),%esi
  80385c:	31 ff                	xor    %edi,%edi
  80385e:	31 c0                	xor    %eax,%eax
  803860:	89 fa                	mov    %edi,%edx
  803862:	83 c4 1c             	add    $0x1c,%esp
  803865:	5b                   	pop    %ebx
  803866:	5e                   	pop    %esi
  803867:	5f                   	pop    %edi
  803868:	5d                   	pop    %ebp
  803869:	c3                   	ret    
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	89 d8                	mov    %ebx,%eax
  80386e:	f7 f7                	div    %edi
  803870:	31 ff                	xor    %edi,%edi
  803872:	89 fa                	mov    %edi,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803881:	89 eb                	mov    %ebp,%ebx
  803883:	29 fb                	sub    %edi,%ebx
  803885:	89 f9                	mov    %edi,%ecx
  803887:	d3 e6                	shl    %cl,%esi
  803889:	89 c5                	mov    %eax,%ebp
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 ed                	shr    %cl,%ebp
  80388f:	89 e9                	mov    %ebp,%ecx
  803891:	09 f1                	or     %esi,%ecx
  803893:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803897:	89 f9                	mov    %edi,%ecx
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 c5                	mov    %eax,%ebp
  80389d:	89 d6                	mov    %edx,%esi
  80389f:	88 d9                	mov    %bl,%cl
  8038a1:	d3 ee                	shr    %cl,%esi
  8038a3:	89 f9                	mov    %edi,%ecx
  8038a5:	d3 e2                	shl    %cl,%edx
  8038a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ab:	88 d9                	mov    %bl,%cl
  8038ad:	d3 e8                	shr    %cl,%eax
  8038af:	09 c2                	or     %eax,%edx
  8038b1:	89 d0                	mov    %edx,%eax
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	f7 74 24 0c          	divl   0xc(%esp)
  8038b9:	89 d6                	mov    %edx,%esi
  8038bb:	89 c3                	mov    %eax,%ebx
  8038bd:	f7 e5                	mul    %ebp
  8038bf:	39 d6                	cmp    %edx,%esi
  8038c1:	72 19                	jb     8038dc <__udivdi3+0xfc>
  8038c3:	74 0b                	je     8038d0 <__udivdi3+0xf0>
  8038c5:	89 d8                	mov    %ebx,%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 58 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038d4:	89 f9                	mov    %edi,%ecx
  8038d6:	d3 e2                	shl    %cl,%edx
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	73 e9                	jae    8038c5 <__udivdi3+0xe5>
  8038dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038df:	31 ff                	xor    %edi,%edi
  8038e1:	e9 40 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038e6:	66 90                	xchg   %ax,%ax
  8038e8:	31 c0                	xor    %eax,%eax
  8038ea:	e9 37 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ef:	90                   	nop

008038f0 <__umoddi3>:
  8038f0:	55                   	push   %ebp
  8038f1:	57                   	push   %edi
  8038f2:	56                   	push   %esi
  8038f3:	53                   	push   %ebx
  8038f4:	83 ec 1c             	sub    $0x1c,%esp
  8038f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803903:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803907:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80390b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80390f:	89 f3                	mov    %esi,%ebx
  803911:	89 fa                	mov    %edi,%edx
  803913:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803917:	89 34 24             	mov    %esi,(%esp)
  80391a:	85 c0                	test   %eax,%eax
  80391c:	75 1a                	jne    803938 <__umoddi3+0x48>
  80391e:	39 f7                	cmp    %esi,%edi
  803920:	0f 86 a2 00 00 00    	jbe    8039c8 <__umoddi3+0xd8>
  803926:	89 c8                	mov    %ecx,%eax
  803928:	89 f2                	mov    %esi,%edx
  80392a:	f7 f7                	div    %edi
  80392c:	89 d0                	mov    %edx,%eax
  80392e:	31 d2                	xor    %edx,%edx
  803930:	83 c4 1c             	add    $0x1c,%esp
  803933:	5b                   	pop    %ebx
  803934:	5e                   	pop    %esi
  803935:	5f                   	pop    %edi
  803936:	5d                   	pop    %ebp
  803937:	c3                   	ret    
  803938:	39 f0                	cmp    %esi,%eax
  80393a:	0f 87 ac 00 00 00    	ja     8039ec <__umoddi3+0xfc>
  803940:	0f bd e8             	bsr    %eax,%ebp
  803943:	83 f5 1f             	xor    $0x1f,%ebp
  803946:	0f 84 ac 00 00 00    	je     8039f8 <__umoddi3+0x108>
  80394c:	bf 20 00 00 00       	mov    $0x20,%edi
  803951:	29 ef                	sub    %ebp,%edi
  803953:	89 fe                	mov    %edi,%esi
  803955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803959:	89 e9                	mov    %ebp,%ecx
  80395b:	d3 e0                	shl    %cl,%eax
  80395d:	89 d7                	mov    %edx,%edi
  80395f:	89 f1                	mov    %esi,%ecx
  803961:	d3 ef                	shr    %cl,%edi
  803963:	09 c7                	or     %eax,%edi
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 e2                	shl    %cl,%edx
  803969:	89 14 24             	mov    %edx,(%esp)
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	d3 e0                	shl    %cl,%eax
  803970:	89 c2                	mov    %eax,%edx
  803972:	8b 44 24 08          	mov    0x8(%esp),%eax
  803976:	d3 e0                	shl    %cl,%eax
  803978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80397c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803980:	89 f1                	mov    %esi,%ecx
  803982:	d3 e8                	shr    %cl,%eax
  803984:	09 d0                	or     %edx,%eax
  803986:	d3 eb                	shr    %cl,%ebx
  803988:	89 da                	mov    %ebx,%edx
  80398a:	f7 f7                	div    %edi
  80398c:	89 d3                	mov    %edx,%ebx
  80398e:	f7 24 24             	mull   (%esp)
  803991:	89 c6                	mov    %eax,%esi
  803993:	89 d1                	mov    %edx,%ecx
  803995:	39 d3                	cmp    %edx,%ebx
  803997:	0f 82 87 00 00 00    	jb     803a24 <__umoddi3+0x134>
  80399d:	0f 84 91 00 00 00    	je     803a34 <__umoddi3+0x144>
  8039a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039a7:	29 f2                	sub    %esi,%edx
  8039a9:	19 cb                	sbb    %ecx,%ebx
  8039ab:	89 d8                	mov    %ebx,%eax
  8039ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039b1:	d3 e0                	shl    %cl,%eax
  8039b3:	89 e9                	mov    %ebp,%ecx
  8039b5:	d3 ea                	shr    %cl,%edx
  8039b7:	09 d0                	or     %edx,%eax
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	d3 eb                	shr    %cl,%ebx
  8039bd:	89 da                	mov    %ebx,%edx
  8039bf:	83 c4 1c             	add    $0x1c,%esp
  8039c2:	5b                   	pop    %ebx
  8039c3:	5e                   	pop    %esi
  8039c4:	5f                   	pop    %edi
  8039c5:	5d                   	pop    %ebp
  8039c6:	c3                   	ret    
  8039c7:	90                   	nop
  8039c8:	89 fd                	mov    %edi,%ebp
  8039ca:	85 ff                	test   %edi,%edi
  8039cc:	75 0b                	jne    8039d9 <__umoddi3+0xe9>
  8039ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d3:	31 d2                	xor    %edx,%edx
  8039d5:	f7 f7                	div    %edi
  8039d7:	89 c5                	mov    %eax,%ebp
  8039d9:	89 f0                	mov    %esi,%eax
  8039db:	31 d2                	xor    %edx,%edx
  8039dd:	f7 f5                	div    %ebp
  8039df:	89 c8                	mov    %ecx,%eax
  8039e1:	f7 f5                	div    %ebp
  8039e3:	89 d0                	mov    %edx,%eax
  8039e5:	e9 44 ff ff ff       	jmp    80392e <__umoddi3+0x3e>
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	89 c8                	mov    %ecx,%eax
  8039ee:	89 f2                	mov    %esi,%edx
  8039f0:	83 c4 1c             	add    $0x1c,%esp
  8039f3:	5b                   	pop    %ebx
  8039f4:	5e                   	pop    %esi
  8039f5:	5f                   	pop    %edi
  8039f6:	5d                   	pop    %ebp
  8039f7:	c3                   	ret    
  8039f8:	3b 04 24             	cmp    (%esp),%eax
  8039fb:	72 06                	jb     803a03 <__umoddi3+0x113>
  8039fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a01:	77 0f                	ja     803a12 <__umoddi3+0x122>
  803a03:	89 f2                	mov    %esi,%edx
  803a05:	29 f9                	sub    %edi,%ecx
  803a07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a0b:	89 14 24             	mov    %edx,(%esp)
  803a0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a16:	8b 14 24             	mov    (%esp),%edx
  803a19:	83 c4 1c             	add    $0x1c,%esp
  803a1c:	5b                   	pop    %ebx
  803a1d:	5e                   	pop    %esi
  803a1e:	5f                   	pop    %edi
  803a1f:	5d                   	pop    %ebp
  803a20:	c3                   	ret    
  803a21:	8d 76 00             	lea    0x0(%esi),%esi
  803a24:	2b 04 24             	sub    (%esp),%eax
  803a27:	19 fa                	sbb    %edi,%edx
  803a29:	89 d1                	mov    %edx,%ecx
  803a2b:	89 c6                	mov    %eax,%esi
  803a2d:	e9 71 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a38:	72 ea                	jb     803a24 <__umoddi3+0x134>
  803a3a:	89 d9                	mov    %ebx,%ecx
  803a3c:	e9 62 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
