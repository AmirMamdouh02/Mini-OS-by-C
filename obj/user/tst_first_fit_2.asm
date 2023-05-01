
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 78 23 00 00       	call   8023c2 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 e0 37 80 00       	push   $0x8037e0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 fc 37 80 00       	push   $0x8037fc
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 59 19 00 00       	call   801a0f <malloc>
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
  8000e0:	e8 2a 19 00 00       	call   801a0f <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 14 38 80 00       	push   $0x803814
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 fc 37 80 00       	push   $0x8037fc
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 a2 1d 00 00       	call   801ead <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 3a 1e 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 e8 18 00 00       	call   801a0f <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 58 38 80 00       	push   $0x803858
  80013f:	6a 31                	push   $0x31
  800141:	68 fc 37 80 00       	push   $0x8037fc
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 fd 1d 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 88 38 80 00       	push   $0x803888
  80015d:	6a 33                	push   $0x33
  80015f:	68 fc 37 80 00       	push   $0x8037fc
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 3f 1d 00 00       	call   801ead <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 d7 1d 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 85 18 00 00       	call   801a0f <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 58 38 80 00       	push   $0x803858
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 fc 37 80 00       	push   $0x8037fc
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 91 1d 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 88 38 80 00       	push   $0x803888
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 fc 37 80 00       	push   $0x8037fc
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 d3 1c 00 00       	call   801ead <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 6b 1d 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 18 18 00 00       	call   801a0f <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 58 38 80 00       	push   $0x803858
  800219:	6a 41                	push   $0x41
  80021b:	68 fc 37 80 00       	push   $0x8037fc
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 23 1d 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 88 38 80 00       	push   $0x803888
  800237:	6a 43                	push   $0x43
  800239:	68 fc 37 80 00       	push   $0x8037fc
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 65 1c 00 00       	call   801ead <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 fd 1c 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 aa 17 00 00       	call   801a0f <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 58 38 80 00       	push   $0x803858
  800291:	6a 49                	push   $0x49
  800293:	68 fc 37 80 00       	push   $0x8037fc
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 ab 1c 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 88 38 80 00       	push   $0x803888
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 fc 37 80 00       	push   $0x8037fc
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 ed 1b 00 00       	call   801ead <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 85 1c 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 d1 17 00 00       	call   801aa8 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 6e 1c 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 a5 38 80 00       	push   $0x8038a5
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 fc 37 80 00       	push   $0x8037fc
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 b0 1b 00 00       	call   801ead <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 48 1c 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 f1 16 00 00       	call   801a0f <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 58 38 80 00       	push   $0x803858
  80034a:	6a 58                	push   $0x58
  80034c:	68 fc 37 80 00       	push   $0x8037fc
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 f2 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 88 38 80 00       	push   $0x803888
  800368:	6a 5a                	push   $0x5a
  80036a:	68 fc 37 80 00       	push   $0x8037fc
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 34 1b 00 00       	call   801ead <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 cc 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 18 17 00 00       	call   801aa8 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 b5 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 a5 38 80 00       	push   $0x8038a5
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 fc 37 80 00       	push   $0x8037fc
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 f7 1a 00 00       	call   801ead <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 8f 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 39 16 00 00       	call   801a0f <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 58 38 80 00       	push   $0x803858
  800402:	6a 67                	push   $0x67
  800404:	68 fc 37 80 00       	push   $0x8037fc
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 3a 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 88 38 80 00       	push   $0x803888
  800420:	6a 69                	push   $0x69
  800422:	68 fc 37 80 00       	push   $0x8037fc
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 7c 1a 00 00       	call   801ead <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 14 1b 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 ba 15 00 00       	call   801a0f <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 58 38 80 00       	push   $0x803858
  800488:	6a 6f                	push   $0x6f
  80048a:	68 fc 37 80 00       	push   $0x8037fc
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 b4 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 88 38 80 00       	push   $0x803888
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 fc 37 80 00       	push   $0x8037fc
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 f6 19 00 00       	call   801ead <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 8e 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 da 15 00 00       	call   801aa8 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 77 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 a5 38 80 00       	push   $0x8038a5
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 fc 37 80 00       	push   $0x8037fc
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 b9 19 00 00       	call   801ead <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 51 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 9d 15 00 00       	call   801aa8 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 3a 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 a5 38 80 00       	push   $0x8038a5
  800520:	6a 7f                	push   $0x7f
  800522:	68 fc 37 80 00       	push   $0x8037fc
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 7c 19 00 00       	call   801ead <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 14 1a 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 bd 14 00 00       	call   801a0f <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 58 38 80 00       	push   $0x803858
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 fc 37 80 00       	push   $0x8037fc
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 b1 19 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 88 38 80 00       	push   $0x803888
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 fc 37 80 00       	push   $0x8037fc
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 f0 18 00 00       	call   801ead <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 88 19 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 32 14 00 00       	call   801a0f <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 58 38 80 00       	push   $0x803858
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 fc 37 80 00       	push   $0x8037fc
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 44 19 00 00       	call   801f4d <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 88 38 80 00       	push   $0x803888
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 fc 37 80 00       	push   $0x8037fc
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 cb 13 00 00       	call   801a0f <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 bc 38 80 00       	push   $0x8038bc
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 fc 37 80 00       	push   $0x8037fc
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 20 39 80 00       	push   $0x803920
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 02 1b 00 00       	call   80218d <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 a4 18 00 00       	call   801f9a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 84 39 80 00       	push   $0x803984
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 ac 39 80 00       	push   $0x8039ac
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 d4 39 80 00       	push   $0x8039d4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 2c 3a 80 00       	push   $0x803a2c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 84 39 80 00       	push   $0x803984
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 24 18 00 00       	call   801fb4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 b1 19 00 00       	call   802159 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 06 1a 00 00       	call   8021bf <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 40 3a 80 00       	push   $0x803a40
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 45 3a 80 00       	push   $0x803a45
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 61 3a 80 00       	push   $0x803a61
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 64 3a 80 00       	push   $0x803a64
  80084b:	6a 26                	push   $0x26
  80084d:	68 b0 3a 80 00       	push   $0x803ab0
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 bc 3a 80 00       	push   $0x803abc
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 b0 3a 80 00       	push   $0x803ab0
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 10 3b 80 00       	push   $0x803b10
  80098d:	6a 44                	push   $0x44
  80098f:	68 b0 3a 80 00       	push   $0x803ab0
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 05 14 00 00       	call   801dec <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 8e 13 00 00       	call   801dec <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 f2 14 00 00       	call   801f9a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 ec 14 00 00       	call   801fb4 <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 62 2a 00 00       	call   803574 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 22 2b 00 00       	call   803684 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 74 3d 80 00       	add    $0x803d74,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 85 3d 80 00       	push   $0x803d85
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 8e 3d 80 00       	push   $0x803d8e
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 f0 3e 80 00       	push   $0x803ef0
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801831:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801838:	00 00 00 
  80183b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801842:	00 00 00 
  801845:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80184c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80184f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801856:	00 00 00 
  801859:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801860:	00 00 00 
  801863:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80186a:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80186d:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	c1 e8 0c             	shr    $0xc,%eax
  80187a:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80187f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801889:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801893:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801898:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80189f:	a1 20 51 80 00       	mov    0x805120,%eax
  8018a4:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8018a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8018ab:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8018b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	48                   	dec    %eax
  8018bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c6:	f7 75 e4             	divl   -0x1c(%ebp)
  8018c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cc:	29 d0                	sub    %edx,%eax
  8018ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8018d1:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8018d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018e0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	6a 07                	push   $0x7
  8018ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	e8 3d 06 00 00       	call   801f30 <sys_allocate_chunk>
  8018f3:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018f6:	a1 20 51 80 00       	mov    0x805120,%eax
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	50                   	push   %eax
  8018ff:	e8 b2 0c 00 00       	call   8025b6 <initialize_MemBlocksList>
  801904:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801907:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80190c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80190f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801913:	0f 84 f3 00 00 00    	je     801a0c <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801919:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80191d:	75 14                	jne    801933 <initialize_dyn_block_system+0x108>
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	68 15 3f 80 00       	push   $0x803f15
  801927:	6a 36                	push   $0x36
  801929:	68 33 3f 80 00       	push   $0x803f33
  80192e:	e8 89 ee ff ff       	call   8007bc <_panic>
  801933:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801936:	8b 00                	mov    (%eax),%eax
  801938:	85 c0                	test   %eax,%eax
  80193a:	74 10                	je     80194c <initialize_dyn_block_system+0x121>
  80193c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80193f:	8b 00                	mov    (%eax),%eax
  801941:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801944:	8b 52 04             	mov    0x4(%edx),%edx
  801947:	89 50 04             	mov    %edx,0x4(%eax)
  80194a:	eb 0b                	jmp    801957 <initialize_dyn_block_system+0x12c>
  80194c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80194f:	8b 40 04             	mov    0x4(%eax),%eax
  801952:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801957:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195a:	8b 40 04             	mov    0x4(%eax),%eax
  80195d:	85 c0                	test   %eax,%eax
  80195f:	74 0f                	je     801970 <initialize_dyn_block_system+0x145>
  801961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801964:	8b 40 04             	mov    0x4(%eax),%eax
  801967:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80196a:	8b 12                	mov    (%edx),%edx
  80196c:	89 10                	mov    %edx,(%eax)
  80196e:	eb 0a                	jmp    80197a <initialize_dyn_block_system+0x14f>
  801970:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801973:	8b 00                	mov    (%eax),%eax
  801975:	a3 48 51 80 00       	mov    %eax,0x805148
  80197a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80197d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801983:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80198d:	a1 54 51 80 00       	mov    0x805154,%eax
  801992:	48                   	dec    %eax
  801993:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801998:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80199b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8019a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019a5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8019ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8019b0:	75 14                	jne    8019c6 <initialize_dyn_block_system+0x19b>
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	68 40 3f 80 00       	push   $0x803f40
  8019ba:	6a 3e                	push   $0x3e
  8019bc:	68 33 3f 80 00       	push   $0x803f33
  8019c1:	e8 f6 ed ff ff       	call   8007bc <_panic>
  8019c6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8019cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019cf:	89 10                	mov    %edx,(%eax)
  8019d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	74 0d                	je     8019e7 <initialize_dyn_block_system+0x1bc>
  8019da:	a1 38 51 80 00       	mov    0x805138,%eax
  8019df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019e2:	89 50 04             	mov    %edx,0x4(%eax)
  8019e5:	eb 08                	jmp    8019ef <initialize_dyn_block_system+0x1c4>
  8019e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8019f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a01:	a1 44 51 80 00       	mov    0x805144,%eax
  801a06:	40                   	inc    %eax
  801a07:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801a15:	e8 e0 fd ff ff       	call   8017fa <InitializeUHeap>
		if (size == 0) return NULL ;
  801a1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a1e:	75 07                	jne    801a27 <malloc+0x18>
  801a20:	b8 00 00 00 00       	mov    $0x0,%eax
  801a25:	eb 7f                	jmp    801aa6 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801a27:	e8 d2 08 00 00       	call   8022fe <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 71                	je     801aa1 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801a30:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a37:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	48                   	dec    %eax
  801a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a46:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4b:	f7 75 f4             	divl   -0xc(%ebp)
  801a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a51:	29 d0                	sub    %edx,%eax
  801a53:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801a56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801a5d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a64:	76 07                	jbe    801a6d <malloc+0x5e>
					return NULL ;
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6b:	eb 39                	jmp    801aa6 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801a6d:	83 ec 0c             	sub    $0xc,%esp
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 e6 0d 00 00       	call   80285e <alloc_block_FF>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801a7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a82:	74 16                	je     801a9a <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801a84:	83 ec 0c             	sub    $0xc,%esp
  801a87:	ff 75 ec             	pushl  -0x14(%ebp)
  801a8a:	e8 37 0c 00 00       	call   8026c6 <insert_sorted_allocList>
  801a8f:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a95:	8b 40 08             	mov    0x8(%eax),%eax
  801a98:	eb 0c                	jmp    801aa6 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9f:	eb 05                	jmp    801aa6 <malloc+0x97>
				}
		}
	return 0;
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aba:	68 40 50 80 00       	push   $0x805040
  801abf:	e8 cf 0b 00 00       	call   802693 <find_block>
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad6:	8b 40 08             	mov    0x8(%eax),%eax
  801ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ae0:	0f 84 a1 00 00 00    	je     801b87 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801ae6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aea:	75 17                	jne    801b03 <free+0x5b>
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	68 15 3f 80 00       	push   $0x803f15
  801af4:	68 80 00 00 00       	push   $0x80
  801af9:	68 33 3f 80 00       	push   $0x803f33
  801afe:	e8 b9 ec ff ff       	call   8007bc <_panic>
  801b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b06:	8b 00                	mov    (%eax),%eax
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	74 10                	je     801b1c <free+0x74>
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	8b 00                	mov    (%eax),%eax
  801b11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b14:	8b 52 04             	mov    0x4(%edx),%edx
  801b17:	89 50 04             	mov    %edx,0x4(%eax)
  801b1a:	eb 0b                	jmp    801b27 <free+0x7f>
  801b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1f:	8b 40 04             	mov    0x4(%eax),%eax
  801b22:	a3 44 50 80 00       	mov    %eax,0x805044
  801b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2a:	8b 40 04             	mov    0x4(%eax),%eax
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	74 0f                	je     801b40 <free+0x98>
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	8b 40 04             	mov    0x4(%eax),%eax
  801b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b3a:	8b 12                	mov    (%edx),%edx
  801b3c:	89 10                	mov    %edx,(%eax)
  801b3e:	eb 0a                	jmp    801b4a <free+0xa2>
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	8b 00                	mov    (%eax),%eax
  801b45:	a3 40 50 80 00       	mov    %eax,0x805040
  801b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b5d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b62:	48                   	dec    %eax
  801b63:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801b68:	83 ec 0c             	sub    $0xc,%esp
  801b6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6e:	e8 29 12 00 00       	call   802d9c <insert_sorted_with_merge_freeList>
  801b73:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	ff 75 ec             	pushl  -0x14(%ebp)
  801b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7f:	e8 74 03 00 00       	call   801ef8 <sys_free_user_mem>
  801b84:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 38             	sub    $0x38,%esp
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b96:	e8 5f fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b9f:	75 0a                	jne    801bab <smalloc+0x21>
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba6:	e9 b2 00 00 00       	jmp    801c5d <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801bab:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801bb2:	76 0a                	jbe    801bbe <smalloc+0x34>
		return NULL;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	e9 9f 00 00 00       	jmp    801c5d <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801bbe:	e8 3b 07 00 00       	call   8022fe <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	0f 84 8d 00 00 00    	je     801c58 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801bd2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdf:	01 d0                	add    %edx,%eax
  801be1:	48                   	dec    %eax
  801be2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bed:	f7 75 f0             	divl   -0x10(%ebp)
  801bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf3:	29 d0                	sub    %edx,%eax
  801bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfe:	e8 5b 0c 00 00       	call   80285e <alloc_block_FF>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c0d:	75 07                	jne    801c16 <smalloc+0x8c>
			return NULL;
  801c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c14:	eb 47                	jmp    801c5d <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1c:	e8 a5 0a 00 00       	call   8026c6 <insert_sorted_allocList>
  801c21:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c27:	8b 40 08             	mov    0x8(%eax),%eax
  801c2a:	89 c2                	mov    %eax,%edx
  801c2c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	e8 46 04 00 00       	call   802083 <sys_createSharedObject>
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801c43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c47:	78 08                	js     801c51 <smalloc+0xc7>
		return (void *)b->sva;
  801c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4c:	8b 40 08             	mov    0x8(%eax),%eax
  801c4f:	eb 0c                	jmp    801c5d <smalloc+0xd3>
		}else{
		return NULL;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
  801c56:	eb 05                	jmp    801c5d <smalloc+0xd3>
			}

	}return NULL;
  801c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c65:	e8 90 fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c6a:	e8 8f 06 00 00       	call   8022fe <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	0f 84 ad 00 00 00    	je     801d24 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	ff 75 08             	pushl  0x8(%ebp)
  801c80:	e8 28 04 00 00       	call   8020ad <sys_getSizeOfSharedObject>
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8f:	79 0a                	jns    801c9b <sget+0x3c>
    {
    	return NULL;
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	e9 8e 00 00 00       	jmp    801d29 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801c9b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801ca2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	48                   	dec    %eax
  801cb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbd:	f7 75 ec             	divl   -0x14(%ebp)
  801cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc3:	29 d0                	sub    %edx,%eax
  801cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cce:	e8 8b 0b 00 00       	call   80285e <alloc_block_FF>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cdd:	75 07                	jne    801ce6 <sget+0x87>
				return NULL;
  801cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce4:	eb 43                	jmp    801d29 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 f0             	pushl  -0x10(%ebp)
  801cec:	e8 d5 09 00 00       	call   8026c6 <insert_sorted_allocList>
  801cf1:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	8b 40 08             	mov    0x8(%eax),%eax
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	50                   	push   %eax
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	e8 c1 03 00 00       	call   8020ca <sys_getSharedObject>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801d0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d13:	78 08                	js     801d1d <sget+0xbe>
			return (void *)b->sva;
  801d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d18:	8b 40 08             	mov    0x8(%eax),%eax
  801d1b:	eb 0c                	jmp    801d29 <sget+0xca>
			}else{
			return NULL;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	eb 05                	jmp    801d29 <sget+0xca>
			}
    }}return NULL;
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d31:	e8 c4 fa ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d36:	83 ec 04             	sub    $0x4,%esp
  801d39:	68 64 3f 80 00       	push   $0x803f64
  801d3e:	68 03 01 00 00       	push   $0x103
  801d43:	68 33 3f 80 00       	push   $0x803f33
  801d48:	e8 6f ea ff ff       	call   8007bc <_panic>

00801d4d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	68 8c 3f 80 00       	push   $0x803f8c
  801d5b:	68 17 01 00 00       	push   $0x117
  801d60:	68 33 3f 80 00       	push   $0x803f33
  801d65:	e8 52 ea ff ff       	call   8007bc <_panic>

00801d6a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	68 b0 3f 80 00       	push   $0x803fb0
  801d78:	68 22 01 00 00       	push   $0x122
  801d7d:	68 33 3f 80 00       	push   $0x803f33
  801d82:	e8 35 ea ff ff       	call   8007bc <_panic>

00801d87 <shrink>:

}
void shrink(uint32 newSize)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	68 b0 3f 80 00       	push   $0x803fb0
  801d95:	68 27 01 00 00       	push   $0x127
  801d9a:	68 33 3f 80 00       	push   $0x803f33
  801d9f:	e8 18 ea ff ff       	call   8007bc <_panic>

00801da4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	68 b0 3f 80 00       	push   $0x803fb0
  801db2:	68 2c 01 00 00       	push   $0x12c
  801db7:	68 33 3f 80 00       	push   $0x803f33
  801dbc:	e8 fb e9 ff ff       	call   8007bc <_panic>

00801dc1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	57                   	push   %edi
  801dc5:	56                   	push   %esi
  801dc6:	53                   	push   %ebx
  801dc7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dd9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ddc:	cd 30                	int    $0x30
  801dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5f                   	pop    %edi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	8b 45 10             	mov    0x10(%ebp),%eax
  801df5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801df8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	52                   	push   %edx
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	50                   	push   %eax
  801e08:	6a 00                	push   $0x0
  801e0a:	e8 b2 ff ff ff       	call   801dc1 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	90                   	nop
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 01                	push   $0x1
  801e24:	e8 98 ff ff ff       	call   801dc1 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	6a 05                	push   $0x5
  801e41:	e8 7b ff ff ff       	call   801dc1 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e50:	8b 75 18             	mov    0x18(%ebp),%esi
  801e53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	56                   	push   %esi
  801e60:	53                   	push   %ebx
  801e61:	51                   	push   %ecx
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 06                	push   $0x6
  801e66:	e8 56 ff ff ff       	call   801dc1 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    

00801e75 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 07                	push   $0x7
  801e88:	e8 34 ff ff ff       	call   801dc1 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	ff 75 0c             	pushl  0xc(%ebp)
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	6a 08                	push   $0x8
  801ea3:	e8 19 ff ff ff       	call   801dc1 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 09                	push   $0x9
  801ebc:	e8 00 ff ff ff       	call   801dc1 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 0a                	push   $0xa
  801ed5:	e8 e7 fe ff ff       	call   801dc1 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 0b                	push   $0xb
  801eee:	e8 ce fe ff ff       	call   801dc1 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	ff 75 08             	pushl  0x8(%ebp)
  801f07:	6a 0f                	push   $0xf
  801f09:	e8 b3 fe ff ff       	call   801dc1 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
	return;
  801f11:	90                   	nop
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 0c             	pushl  0xc(%ebp)
  801f20:	ff 75 08             	pushl  0x8(%ebp)
  801f23:	6a 10                	push   $0x10
  801f25:	e8 97 fe ff ff       	call   801dc1 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2d:	90                   	nop
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	ff 75 10             	pushl  0x10(%ebp)
  801f3a:	ff 75 0c             	pushl  0xc(%ebp)
  801f3d:	ff 75 08             	pushl  0x8(%ebp)
  801f40:	6a 11                	push   $0x11
  801f42:	e8 7a fe ff ff       	call   801dc1 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4a:	90                   	nop
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 0c                	push   $0xc
  801f5c:	e8 60 fe ff ff       	call   801dc1 <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	6a 0d                	push   $0xd
  801f76:	e8 46 fe ff ff       	call   801dc1 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 0e                	push   $0xe
  801f8f:	e8 2d fe ff ff       	call   801dc1 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	90                   	nop
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 13                	push   $0x13
  801fa9:	e8 13 fe ff ff       	call   801dc1 <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 14                	push   $0x14
  801fc3:	e8 f9 fd ff ff       	call   801dc1 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	90                   	nop
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_cputc>:


void
sys_cputc(const char c)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fda:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	50                   	push   %eax
  801fe7:	6a 15                	push   $0x15
  801fe9:	e8 d3 fd ff ff       	call   801dc1 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	90                   	nop
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 16                	push   $0x16
  802003:	e8 b9 fd ff ff       	call   801dc1 <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
}
  80200b:	90                   	nop
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	50                   	push   %eax
  80201e:	6a 17                	push   $0x17
  802020:	e8 9c fd ff ff       	call   801dc1 <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 1a                	push   $0x1a
  80203d:	e8 7f fd ff ff       	call   801dc1 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80204a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 18                	push   $0x18
  80205a:	e8 62 fd ff ff       	call   801dc1 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802068:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	52                   	push   %edx
  802075:	50                   	push   %eax
  802076:	6a 19                	push   $0x19
  802078:	e8 44 fd ff ff       	call   801dc1 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	8b 45 10             	mov    0x10(%ebp),%eax
  80208c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80208f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802092:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	6a 00                	push   $0x0
  80209b:	51                   	push   %ecx
  80209c:	52                   	push   %edx
  80209d:	ff 75 0c             	pushl  0xc(%ebp)
  8020a0:	50                   	push   %eax
  8020a1:	6a 1b                	push   $0x1b
  8020a3:	e8 19 fd ff ff       	call   801dc1 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	52                   	push   %edx
  8020bd:	50                   	push   %eax
  8020be:	6a 1c                	push   $0x1c
  8020c0:	e8 fc fc ff ff       	call   801dc1 <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	51                   	push   %ecx
  8020db:	52                   	push   %edx
  8020dc:	50                   	push   %eax
  8020dd:	6a 1d                	push   $0x1d
  8020df:	e8 dd fc ff ff       	call   801dc1 <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	6a 1e                	push   $0x1e
  8020fc:	e8 c0 fc ff ff       	call   801dc1 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 1f                	push   $0x1f
  802115:	e8 a7 fc ff ff       	call   801dc1 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	ff 75 14             	pushl  0x14(%ebp)
  80212a:	ff 75 10             	pushl  0x10(%ebp)
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	50                   	push   %eax
  802131:	6a 20                	push   $0x20
  802133:	e8 89 fc ff ff       	call   801dc1 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	50                   	push   %eax
  80214c:	6a 21                	push   $0x21
  80214e:	e8 6e fc ff ff       	call   801dc1 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	90                   	nop
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	50                   	push   %eax
  802168:	6a 22                	push   $0x22
  80216a:	e8 52 fc ff ff       	call   801dc1 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 02                	push   $0x2
  802183:	e8 39 fc ff ff       	call   801dc1 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 03                	push   $0x3
  80219c:	e8 20 fc ff ff       	call   801dc1 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 04                	push   $0x4
  8021b5:	e8 07 fc ff ff       	call   801dc1 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_exit_env>:


void sys_exit_env(void)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 23                	push   $0x23
  8021ce:	e8 ee fb ff ff       	call   801dc1 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	90                   	nop
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021e2:	8d 50 04             	lea    0x4(%eax),%edx
  8021e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	52                   	push   %edx
  8021ef:	50                   	push   %eax
  8021f0:	6a 24                	push   $0x24
  8021f2:	e8 ca fb ff ff       	call   801dc1 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
	return result;
  8021fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802200:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802203:	89 01                	mov    %eax,(%ecx)
  802205:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	c9                   	leave  
  80220c:	c2 04 00             	ret    $0x4

0080220f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	ff 75 10             	pushl  0x10(%ebp)
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 12                	push   $0x12
  802221:	e8 9b fb ff ff       	call   801dc1 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_rcr2>:
uint32 sys_rcr2()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 25                	push   $0x25
  80223b:	e8 81 fb ff ff       	call   801dc1 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802251:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	50                   	push   %eax
  80225e:	6a 26                	push   $0x26
  802260:	e8 5c fb ff ff       	call   801dc1 <syscall>
  802265:	83 c4 18             	add    $0x18,%esp
	return ;
  802268:	90                   	nop
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <rsttst>:
void rsttst()
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 28                	push   $0x28
  80227a:	e8 42 fb ff ff       	call   801dc1 <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
	return ;
  802282:	90                   	nop
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	8b 45 14             	mov    0x14(%ebp),%eax
  80228e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802291:	8b 55 18             	mov    0x18(%ebp),%edx
  802294:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802298:	52                   	push   %edx
  802299:	50                   	push   %eax
  80229a:	ff 75 10             	pushl  0x10(%ebp)
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	6a 27                	push   $0x27
  8022a5:	e8 17 fb ff ff       	call   801dc1 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ad:	90                   	nop
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <chktst>:
void chktst(uint32 n)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	ff 75 08             	pushl  0x8(%ebp)
  8022be:	6a 29                	push   $0x29
  8022c0:	e8 fc fa ff ff       	call   801dc1 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c8:	90                   	nop
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <inctst>:

void inctst()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 2a                	push   $0x2a
  8022da:	e8 e2 fa ff ff       	call   801dc1 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e2:	90                   	nop
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <gettst>:
uint32 gettst()
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 2b                	push   $0x2b
  8022f4:	e8 c8 fa ff ff       	call   801dc1 <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 2c                	push   $0x2c
  802310:	e8 ac fa ff ff       	call   801dc1 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
  802318:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80231b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80231f:	75 07                	jne    802328 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802321:	b8 01 00 00 00       	mov    $0x1,%eax
  802326:	eb 05                	jmp    80232d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 2c                	push   $0x2c
  802341:	e8 7b fa ff ff       	call   801dc1 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
  802349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80234c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802350:	75 07                	jne    802359 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	eb 05                	jmp    80235e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 2c                	push   $0x2c
  802372:	e8 4a fa ff ff       	call   801dc1 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
  80237a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80237d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802381:	75 07                	jne    80238a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802383:	b8 01 00 00 00       	mov    $0x1,%eax
  802388:	eb 05                	jmp    80238f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 2c                	push   $0x2c
  8023a3:	e8 19 fa ff ff       	call   801dc1 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
  8023ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023ae:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023b2:	75 07                	jne    8023bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b9:	eb 05                	jmp    8023c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	ff 75 08             	pushl  0x8(%ebp)
  8023d0:	6a 2d                	push   $0x2d
  8023d2:	e8 ea f9 ff ff       	call   801dc1 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023da:	90                   	nop
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	53                   	push   %ebx
  8023f0:	51                   	push   %ecx
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 2e                	push   $0x2e
  8023f5:	e8 c7 f9 ff ff       	call   801dc1 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802405:	8b 55 0c             	mov    0xc(%ebp),%edx
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	52                   	push   %edx
  802412:	50                   	push   %eax
  802413:	6a 2f                	push   $0x2f
  802415:	e8 a7 f9 ff ff       	call   801dc1 <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802425:	83 ec 0c             	sub    $0xc,%esp
  802428:	68 c0 3f 80 00       	push   $0x803fc0
  80242d:	e8 3e e6 ff ff       	call   800a70 <cprintf>
  802432:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80243c:	83 ec 0c             	sub    $0xc,%esp
  80243f:	68 ec 3f 80 00       	push   $0x803fec
  802444:	e8 27 e6 ff ff       	call   800a70 <cprintf>
  802449:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80244c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802450:	a1 38 51 80 00       	mov    0x805138,%eax
  802455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802458:	eb 56                	jmp    8024b0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80245a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245e:	74 1c                	je     80247c <print_mem_block_lists+0x5d>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 50 08             	mov    0x8(%eax),%edx
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	8b 48 08             	mov    0x8(%eax),%ecx
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	01 c8                	add    %ecx,%eax
  802474:	39 c2                	cmp    %eax,%edx
  802476:	73 04                	jae    80247c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802478:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 50 08             	mov    0x8(%eax),%edx
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 40 0c             	mov    0xc(%eax),%eax
  802488:	01 c2                	add    %eax,%edx
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 08             	mov    0x8(%eax),%eax
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	52                   	push   %edx
  802494:	50                   	push   %eax
  802495:	68 01 40 80 00       	push   $0x804001
  80249a:	e8 d1 e5 ff ff       	call   800a70 <cprintf>
  80249f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b4:	74 07                	je     8024bd <print_mem_block_lists+0x9e>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 00                	mov    (%eax),%eax
  8024bb:	eb 05                	jmp    8024c2 <print_mem_block_lists+0xa3>
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c2:	a3 40 51 80 00       	mov    %eax,0x805140
  8024c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	75 8a                	jne    80245a <print_mem_block_lists+0x3b>
  8024d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d4:	75 84                	jne    80245a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024d6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024da:	75 10                	jne    8024ec <print_mem_block_lists+0xcd>
  8024dc:	83 ec 0c             	sub    $0xc,%esp
  8024df:	68 10 40 80 00       	push   $0x804010
  8024e4:	e8 87 e5 ff ff       	call   800a70 <cprintf>
  8024e9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	68 34 40 80 00       	push   $0x804034
  8024fb:	e8 70 e5 ff ff       	call   800a70 <cprintf>
  802500:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802503:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802507:	a1 40 50 80 00       	mov    0x805040,%eax
  80250c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250f:	eb 56                	jmp    802567 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802515:	74 1c                	je     802533 <print_mem_block_lists+0x114>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 50 08             	mov    0x8(%eax),%edx
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 48 08             	mov    0x8(%eax),%ecx
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	8b 40 0c             	mov    0xc(%eax),%eax
  802529:	01 c8                	add    %ecx,%eax
  80252b:	39 c2                	cmp    %eax,%edx
  80252d:	73 04                	jae    802533 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80252f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 50 08             	mov    0x8(%eax),%edx
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	01 c2                	add    %eax,%edx
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 08             	mov    0x8(%eax),%eax
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	52                   	push   %edx
  80254b:	50                   	push   %eax
  80254c:	68 01 40 80 00       	push   $0x804001
  802551:	e8 1a e5 ff ff       	call   800a70 <cprintf>
  802556:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80255f:	a1 48 50 80 00       	mov    0x805048,%eax
  802564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	74 07                	je     802574 <print_mem_block_lists+0x155>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	eb 05                	jmp    802579 <print_mem_block_lists+0x15a>
  802574:	b8 00 00 00 00       	mov    $0x0,%eax
  802579:	a3 48 50 80 00       	mov    %eax,0x805048
  80257e:	a1 48 50 80 00       	mov    0x805048,%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	75 8a                	jne    802511 <print_mem_block_lists+0xf2>
  802587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258b:	75 84                	jne    802511 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80258d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802591:	75 10                	jne    8025a3 <print_mem_block_lists+0x184>
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	68 4c 40 80 00       	push   $0x80404c
  80259b:	e8 d0 e4 ff ff       	call   800a70 <cprintf>
  8025a0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	68 c0 3f 80 00       	push   $0x803fc0
  8025ab:	e8 c0 e4 ff ff       	call   800a70 <cprintf>
  8025b0:	83 c4 10             	add    $0x10,%esp

}
  8025b3:	90                   	nop
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8025bc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025c3:	00 00 00 
  8025c6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025cd:	00 00 00 
  8025d0:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025d7:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8025da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025e1:	e9 9e 00 00 00       	jmp    802684 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8025e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8025eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ee:	c1 e2 04             	shl    $0x4,%edx
  8025f1:	01 d0                	add    %edx,%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	75 14                	jne    80260b <initialize_MemBlocksList+0x55>
  8025f7:	83 ec 04             	sub    $0x4,%esp
  8025fa:	68 74 40 80 00       	push   $0x804074
  8025ff:	6a 3d                	push   $0x3d
  802601:	68 97 40 80 00       	push   $0x804097
  802606:	e8 b1 e1 ff ff       	call   8007bc <_panic>
  80260b:	a1 50 50 80 00       	mov    0x805050,%eax
  802610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802613:	c1 e2 04             	shl    $0x4,%edx
  802616:	01 d0                	add    %edx,%eax
  802618:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	8b 00                	mov    (%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 18                	je     80263e <initialize_MemBlocksList+0x88>
  802626:	a1 48 51 80 00       	mov    0x805148,%eax
  80262b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802634:	c1 e1 04             	shl    $0x4,%ecx
  802637:	01 ca                	add    %ecx,%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 12                	jmp    802650 <initialize_MemBlocksList+0x9a>
  80263e:	a1 50 50 80 00       	mov    0x805050,%eax
  802643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802646:	c1 e2 04             	shl    $0x4,%edx
  802649:	01 d0                	add    %edx,%eax
  80264b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802650:	a1 50 50 80 00       	mov    0x805050,%eax
  802655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802658:	c1 e2 04             	shl    $0x4,%edx
  80265b:	01 d0                	add    %edx,%eax
  80265d:	a3 48 51 80 00       	mov    %eax,0x805148
  802662:	a1 50 50 80 00       	mov    0x805050,%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	c1 e2 04             	shl    $0x4,%edx
  80266d:	01 d0                	add    %edx,%eax
  80266f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802676:	a1 54 51 80 00       	mov    0x805154,%eax
  80267b:	40                   	inc    %eax
  80267c:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802681:	ff 45 f4             	incl   -0xc(%ebp)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268a:	0f 82 56 ff ff ff    	jb     8025e6 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802690:	90                   	nop
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8026a1:	eb 18                	jmp    8026bb <find_block+0x28>

		if(tmp->sva == va){
  8026a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026ac:	75 05                	jne    8026b3 <find_block+0x20>
			return tmp ;
  8026ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026b1:	eb 11                	jmp    8026c4 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8026b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8026bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026bf:	75 e2                	jne    8026a3 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8026c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8026cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8026d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8026dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026e0:	75 65                	jne    802747 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8026e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e6:	75 14                	jne    8026fc <insert_sorted_allocList+0x36>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 74 40 80 00       	push   $0x804074
  8026f0:	6a 62                	push   $0x62
  8026f2:	68 97 40 80 00       	push   $0x804097
  8026f7:	e8 c0 e0 ff ff       	call   8007bc <_panic>
  8026fc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	89 10                	mov    %edx,(%eax)
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0d                	je     80271d <insert_sorted_allocList+0x57>
  802710:	a1 40 50 80 00       	mov    0x805040,%eax
  802715:	8b 55 08             	mov    0x8(%ebp),%edx
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	eb 08                	jmp    802725 <insert_sorted_allocList+0x5f>
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	a3 44 50 80 00       	mov    %eax,0x805044
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	a3 40 50 80 00       	mov    %eax,0x805040
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802737:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273c:	40                   	inc    %eax
  80273d:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802742:	e9 14 01 00 00       	jmp    80285b <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	8b 50 08             	mov    0x8(%eax),%edx
  80274d:	a1 44 50 80 00       	mov    0x805044,%eax
  802752:	8b 40 08             	mov    0x8(%eax),%eax
  802755:	39 c2                	cmp    %eax,%edx
  802757:	76 65                	jbe    8027be <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802759:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275d:	75 14                	jne    802773 <insert_sorted_allocList+0xad>
  80275f:	83 ec 04             	sub    $0x4,%esp
  802762:	68 b0 40 80 00       	push   $0x8040b0
  802767:	6a 64                	push   $0x64
  802769:	68 97 40 80 00       	push   $0x804097
  80276e:	e8 49 e0 ff ff       	call   8007bc <_panic>
  802773:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	89 50 04             	mov    %edx,0x4(%eax)
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0c                	je     802795 <insert_sorted_allocList+0xcf>
  802789:	a1 44 50 80 00       	mov    0x805044,%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 10                	mov    %edx,(%eax)
  802793:	eb 08                	jmp    80279d <insert_sorted_allocList+0xd7>
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	a3 40 50 80 00       	mov    %eax,0x805040
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	a3 44 50 80 00       	mov    %eax,0x805044
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b3:	40                   	inc    %eax
  8027b4:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8027b9:	e9 9d 00 00 00       	jmp    80285b <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8027be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8027c5:	e9 85 00 00 00       	jmp    80284f <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	8b 50 08             	mov    0x8(%eax),%edx
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 08             	mov    0x8(%eax),%eax
  8027d6:	39 c2                	cmp    %eax,%edx
  8027d8:	73 6a                	jae    802844 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8027da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027de:	74 06                	je     8027e6 <insert_sorted_allocList+0x120>
  8027e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e4:	75 14                	jne    8027fa <insert_sorted_allocList+0x134>
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	68 d4 40 80 00       	push   $0x8040d4
  8027ee:	6a 6b                	push   $0x6b
  8027f0:	68 97 40 80 00       	push   $0x804097
  8027f5:	e8 c2 df ff ff       	call   8007bc <_panic>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 50 04             	mov    0x4(%eax),%edx
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	89 50 04             	mov    %edx,0x4(%eax)
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 40 04             	mov    0x4(%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 0d                	je     802825 <insert_sorted_allocList+0x15f>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	8b 55 08             	mov    0x8(%ebp),%edx
  802821:	89 10                	mov    %edx,(%eax)
  802823:	eb 08                	jmp    80282d <insert_sorted_allocList+0x167>
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	a3 40 50 80 00       	mov    %eax,0x805040
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 55 08             	mov    0x8(%ebp),%edx
  802833:	89 50 04             	mov    %edx,0x4(%eax)
  802836:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80283b:	40                   	inc    %eax
  80283c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802841:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802842:	eb 17                	jmp    80285b <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80284c:	ff 45 f0             	incl   -0x10(%ebp)
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802855:	0f 8c 6f ff ff ff    	jl     8027ca <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80285b:	90                   	nop
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802864:	a1 38 51 80 00       	mov    0x805138,%eax
  802869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80286c:	e9 7c 01 00 00       	jmp    8029ed <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287a:	0f 86 cf 00 00 00    	jbe    80294f <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802880:	a1 48 51 80 00       	mov    0x805148,%eax
  802885:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80288e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802891:	8b 55 08             	mov    0x8(%ebp),%edx
  802894:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 50 08             	mov    0x8(%eax),%edx
  80289d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a0:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ac:	89 c2                	mov    %eax,%edx
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	01 c2                	add    %eax,%edx
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8028c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c9:	75 17                	jne    8028e2 <alloc_block_FF+0x84>
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 09 41 80 00       	push   $0x804109
  8028d3:	68 83 00 00 00       	push   $0x83
  8028d8:	68 97 40 80 00       	push   $0x804097
  8028dd:	e8 da de ff ff       	call   8007bc <_panic>
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 10                	je     8028fb <alloc_block_FF+0x9d>
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f3:	8b 52 04             	mov    0x4(%edx),%edx
  8028f6:	89 50 04             	mov    %edx,0x4(%eax)
  8028f9:	eb 0b                	jmp    802906 <alloc_block_FF+0xa8>
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 0f                	je     80291f <alloc_block_FF+0xc1>
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802919:	8b 12                	mov    (%edx),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	eb 0a                	jmp    802929 <alloc_block_FF+0xcb>
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	a3 48 51 80 00       	mov    %eax,0x805148
  802929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293c:	a1 54 51 80 00       	mov    0x805154,%eax
  802941:	48                   	dec    %eax
  802942:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	e9 ad 00 00 00       	jmp    8029fc <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	3b 45 08             	cmp    0x8(%ebp),%eax
  802958:	0f 85 87 00 00 00    	jne    8029e5 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80295e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802962:	75 17                	jne    80297b <alloc_block_FF+0x11d>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 09 41 80 00       	push   $0x804109
  80296c:	68 87 00 00 00       	push   $0x87
  802971:	68 97 40 80 00       	push   $0x804097
  802976:	e8 41 de ff ff       	call   8007bc <_panic>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 10                	je     802994 <alloc_block_FF+0x136>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298c:	8b 52 04             	mov    0x4(%edx),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	eb 0b                	jmp    80299f <alloc_block_FF+0x141>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 0f                	je     8029b8 <alloc_block_FF+0x15a>
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b2:	8b 12                	mov    (%edx),%edx
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	eb 0a                	jmp    8029c2 <alloc_block_FF+0x164>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8029da:	48                   	dec    %eax
  8029db:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	eb 17                	jmp    8029fc <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8029ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f1:	0f 85 7a fe ff ff    	jne    802871 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
  802a01:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802a04:	a1 38 51 80 00       	mov    0x805138,%eax
  802a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802a0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802a13:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802a1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a22:	e9 d0 00 00 00       	jmp    802af7 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a30:	0f 82 b8 00 00 00    	jb     802aee <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a48:	0f 83 a1 00 00 00    	jae    802aef <alloc_block_BF+0xf1>
				differsize = differance ;
  802a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802a5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a5e:	0f 85 8b 00 00 00    	jne    802aef <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a68:	75 17                	jne    802a81 <alloc_block_BF+0x83>
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 09 41 80 00       	push   $0x804109
  802a72:	68 a0 00 00 00       	push   $0xa0
  802a77:	68 97 40 80 00       	push   $0x804097
  802a7c:	e8 3b dd ff ff       	call   8007bc <_panic>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	74 10                	je     802a9a <alloc_block_BF+0x9c>
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a92:	8b 52 04             	mov    0x4(%edx),%edx
  802a95:	89 50 04             	mov    %edx,0x4(%eax)
  802a98:	eb 0b                	jmp    802aa5 <alloc_block_BF+0xa7>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 0f                	je     802abe <alloc_block_BF+0xc0>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab8:	8b 12                	mov    (%edx),%edx
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	eb 0a                	jmp    802ac8 <alloc_block_BF+0xca>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adb:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae0:	48                   	dec    %eax
  802ae1:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	e9 0c 01 00 00       	jmp    802bfa <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802aee:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802aef:	a1 40 51 80 00       	mov    0x805140,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	74 07                	je     802b04 <alloc_block_BF+0x106>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	eb 05                	jmp    802b09 <alloc_block_BF+0x10b>
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	a3 40 51 80 00       	mov    %eax,0x805140
  802b0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	0f 85 0c ff ff ff    	jne    802a27 <alloc_block_BF+0x29>
  802b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1f:	0f 85 02 ff ff ff    	jne    802a27 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802b25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b29:	0f 84 c6 00 00 00    	je     802bf5 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802b2f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b34:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 50 08             	mov    0x8(%eax),%edx
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b52:	2b 45 08             	sub    0x8(%ebp),%eax
  802b55:	89 c2                	mov    %eax,%edx
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	01 c2                	add    %eax,%edx
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802b6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b72:	75 17                	jne    802b8b <alloc_block_BF+0x18d>
  802b74:	83 ec 04             	sub    $0x4,%esp
  802b77:	68 09 41 80 00       	push   $0x804109
  802b7c:	68 af 00 00 00       	push   $0xaf
  802b81:	68 97 40 80 00       	push   $0x804097
  802b86:	e8 31 dc ff ff       	call   8007bc <_panic>
  802b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 10                	je     802ba4 <alloc_block_BF+0x1a6>
  802b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9c:	8b 52 04             	mov    0x4(%edx),%edx
  802b9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ba2:	eb 0b                	jmp    802baf <alloc_block_BF+0x1b1>
  802ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 0f                	je     802bc8 <alloc_block_BF+0x1ca>
  802bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc2:	8b 12                	mov    (%edx),%edx
  802bc4:	89 10                	mov    %edx,(%eax)
  802bc6:	eb 0a                	jmp    802bd2 <alloc_block_BF+0x1d4>
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be5:	a1 54 51 80 00       	mov    0x805154,%eax
  802bea:	48                   	dec    %eax
  802beb:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf3:	eb 05                	jmp    802bfa <alloc_block_BF+0x1fc>
	}

	return NULL;
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802c02:	a1 38 51 80 00       	mov    0x805138,%eax
  802c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802c0a:	e9 7c 01 00 00       	jmp    802d8b <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 0c             	mov    0xc(%eax),%eax
  802c15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c18:	0f 86 cf 00 00 00    	jbe    802ced <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802c1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c29:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c32:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3e:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 0c             	mov    0xc(%eax),%eax
  802c47:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4a:	89 c2                	mov    %eax,%edx
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	01 c2                	add    %eax,%edx
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802c63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c67:	75 17                	jne    802c80 <alloc_block_NF+0x84>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 09 41 80 00       	push   $0x804109
  802c71:	68 c4 00 00 00       	push   $0xc4
  802c76:	68 97 40 80 00       	push   $0x804097
  802c7b:	e8 3c db ff ff       	call   8007bc <_panic>
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 10                	je     802c99 <alloc_block_NF+0x9d>
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c91:	8b 52 04             	mov    0x4(%edx),%edx
  802c94:	89 50 04             	mov    %edx,0x4(%eax)
  802c97:	eb 0b                	jmp    802ca4 <alloc_block_NF+0xa8>
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 0f                	je     802cbd <alloc_block_NF+0xc1>
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb7:	8b 12                	mov    (%edx),%edx
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	eb 0a                	jmp    802cc7 <alloc_block_NF+0xcb>
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 54 51 80 00       	mov    0x805154,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce8:	e9 ad 00 00 00       	jmp    802d9a <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf6:	0f 85 87 00 00 00    	jne    802d83 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802cfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_NF+0x11d>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 09 41 80 00       	push   $0x804109
  802d0a:	68 c8 00 00 00       	push   $0xc8
  802d0f:	68 97 40 80 00       	push   $0x804097
  802d14:	e8 a3 da ff ff       	call   8007bc <_panic>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 10                	je     802d32 <alloc_block_NF+0x136>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2a:	8b 52 04             	mov    0x4(%edx),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 0b                	jmp    802d3d <alloc_block_NF+0x141>
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	74 0f                	je     802d56 <alloc_block_NF+0x15a>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d50:	8b 12                	mov    (%edx),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	eb 0a                	jmp    802d60 <alloc_block_NF+0x164>
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d73:	a1 44 51 80 00       	mov    0x805144,%eax
  802d78:	48                   	dec    %eax
  802d79:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	eb 17                	jmp    802d9a <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8f:	0f 85 7a fe ff ff    	jne    802c0f <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802d95:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d9a:	c9                   	leave  
  802d9b:	c3                   	ret    

00802d9c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d9c:	55                   	push   %ebp
  802d9d:	89 e5                	mov    %esp,%ebp
  802d9f:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802da2:	a1 38 51 80 00       	mov    0x805138,%eax
  802da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802daa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802db2:	a1 44 51 80 00       	mov    0x805144,%eax
  802db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802dba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dbe:	75 68                	jne    802e28 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc4:	75 17                	jne    802ddd <insert_sorted_with_merge_freeList+0x41>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 74 40 80 00       	push   $0x804074
  802dce:	68 da 00 00 00       	push   $0xda
  802dd3:	68 97 40 80 00       	push   $0x804097
  802dd8:	e8 df d9 ff ff       	call   8007bc <_panic>
  802ddd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0d                	je     802dfe <insert_sorted_with_merge_freeList+0x62>
  802df1:	a1 38 51 80 00       	mov    0x805138,%eax
  802df6:	8b 55 08             	mov    0x8(%ebp),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	eb 08                	jmp    802e06 <insert_sorted_with_merge_freeList+0x6a>
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1d:	40                   	inc    %eax
  802e1e:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802e23:	e9 49 07 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	8b 50 08             	mov    0x8(%eax),%edx
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	01 c2                	add    %eax,%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	39 c2                	cmp    %eax,%edx
  802e3e:	73 77                	jae    802eb7 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	75 6e                	jne    802eb7 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e4d:	74 68                	je     802eb7 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802e4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e53:	75 17                	jne    802e6c <insert_sorted_with_merge_freeList+0xd0>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 b0 40 80 00       	push   $0x8040b0
  802e5d:	68 e0 00 00 00       	push   $0xe0
  802e62:	68 97 40 80 00       	push   $0x804097
  802e67:	e8 50 d9 ff ff       	call   8007bc <_panic>
  802e6c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 0c                	je     802e8e <insert_sorted_with_merge_freeList+0xf2>
  802e82:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e87:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	eb 08                	jmp    802e96 <insert_sorted_with_merge_freeList+0xfa>
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	a3 38 51 80 00       	mov    %eax,0x805138
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea7:	a1 44 51 80 00       	mov    0x805144,%eax
  802eac:	40                   	inc    %eax
  802ead:	a3 44 51 80 00       	mov    %eax,0x805144
  802eb2:	e9 ba 06 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 08             	mov    0x8(%eax),%eax
  802ec3:	01 c2                	add    %eax,%edx
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	73 78                	jae    802f47 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 04             	mov    0x4(%eax),%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	75 6e                	jne    802f47 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802ed9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802edd:	74 68                	je     802f47 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee3:	75 17                	jne    802efc <insert_sorted_with_merge_freeList+0x160>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 74 40 80 00       	push   $0x804074
  802eed:	68 e6 00 00 00       	push   $0xe6
  802ef2:	68 97 40 80 00       	push   $0x804097
  802ef7:	e8 c0 d8 ff ff       	call   8007bc <_panic>
  802efc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0d                	je     802f1d <insert_sorted_with_merge_freeList+0x181>
  802f10:	a1 38 51 80 00       	mov    0x805138,%eax
  802f15:	8b 55 08             	mov    0x8(%ebp),%edx
  802f18:	89 50 04             	mov    %edx,0x4(%eax)
  802f1b:	eb 08                	jmp    802f25 <insert_sorted_with_merge_freeList+0x189>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 44 51 80 00       	mov    0x805144,%eax
  802f3c:	40                   	inc    %eax
  802f3d:	a3 44 51 80 00       	mov    %eax,0x805144
  802f42:	e9 2a 06 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802f47:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4f:	e9 ed 05 00 00       	jmp    803541 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802f5c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f60:	0f 84 a7 00 00 00    	je     80300d <insert_sorted_with_merge_freeList+0x271>
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 08             	mov    0x8(%eax),%eax
  802f72:	01 c2                	add    %eax,%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	0f 83 8b 00 00 00    	jae    80300d <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 50 0c             	mov    0xc(%eax),%edx
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	8b 40 08             	mov    0x8(%eax),%eax
  802f8e:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802f96:	39 c2                	cmp    %eax,%edx
  802f98:	73 73                	jae    80300d <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9e:	74 06                	je     802fa6 <insert_sorted_with_merge_freeList+0x20a>
  802fa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa4:	75 17                	jne    802fbd <insert_sorted_with_merge_freeList+0x221>
  802fa6:	83 ec 04             	sub    $0x4,%esp
  802fa9:	68 28 41 80 00       	push   $0x804128
  802fae:	68 f0 00 00 00       	push   $0xf0
  802fb3:	68 97 40 80 00       	push   $0x804097
  802fb8:	e8 ff d7 ff ff       	call   8007bc <_panic>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 10                	mov    (%eax),%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 0b                	je     802fdb <insert_sorted_with_merge_freeList+0x23f>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe1:	89 10                	mov    %edx,(%eax)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	75 08                	jne    802ffd <insert_sorted_with_merge_freeList+0x261>
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ffd:	a1 44 51 80 00       	mov    0x805144,%eax
  803002:	40                   	inc    %eax
  803003:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803008:	e9 64 05 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  80300d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803012:	8b 50 0c             	mov    0xc(%eax),%edx
  803015:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301a:	8b 40 08             	mov    0x8(%eax),%eax
  80301d:	01 c2                	add    %eax,%edx
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 40 08             	mov    0x8(%eax),%eax
  803025:	39 c2                	cmp    %eax,%edx
  803027:	0f 85 b1 00 00 00    	jne    8030de <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80302d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	0f 84 a4 00 00 00    	je     8030de <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  80303a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	0f 85 95 00 00 00    	jne    8030de <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803049:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803054:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803057:	8b 55 08             	mov    0x8(%ebp),%edx
  80305a:	8b 52 0c             	mov    0xc(%edx),%edx
  80305d:	01 ca                	add    %ecx,%edx
  80305f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307a:	75 17                	jne    803093 <insert_sorted_with_merge_freeList+0x2f7>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 74 40 80 00       	push   $0x804074
  803084:	68 ff 00 00 00       	push   $0xff
  803089:	68 97 40 80 00       	push   $0x804097
  80308e:	e8 29 d7 ff ff       	call   8007bc <_panic>
  803093:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0d                	je     8030b4 <insert_sorted_with_merge_freeList+0x318>
  8030a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	eb 08                	jmp    8030bc <insert_sorted_with_merge_freeList+0x320>
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d3:	40                   	inc    %eax
  8030d4:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8030d9:	e9 93 04 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 50 08             	mov    0x8(%eax),%edx
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ea:	01 c2                	add    %eax,%edx
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 40 08             	mov    0x8(%eax),%eax
  8030f2:	39 c2                	cmp    %eax,%edx
  8030f4:	0f 85 ae 00 00 00    	jne    8031a8 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 50 0c             	mov    0xc(%eax),%edx
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 40 08             	mov    0x8(%eax),%eax
  803106:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803110:	39 c2                	cmp    %eax,%edx
  803112:	0f 84 90 00 00 00    	je     8031a8 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8b 50 0c             	mov    0xc(%eax),%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 40 0c             	mov    0xc(%eax),%eax
  803124:	01 c2                	add    %eax,%edx
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803144:	75 17                	jne    80315d <insert_sorted_with_merge_freeList+0x3c1>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 74 40 80 00       	push   $0x804074
  80314e:	68 0b 01 00 00       	push   $0x10b
  803153:	68 97 40 80 00       	push   $0x804097
  803158:	e8 5f d6 ff ff       	call   8007bc <_panic>
  80315d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	89 10                	mov    %edx,(%eax)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0d                	je     80317e <insert_sorted_with_merge_freeList+0x3e2>
  803171:	a1 48 51 80 00       	mov    0x805148,%eax
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
  803179:	89 50 04             	mov    %edx,0x4(%eax)
  80317c:	eb 08                	jmp    803186 <insert_sorted_with_merge_freeList+0x3ea>
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	a3 48 51 80 00       	mov    %eax,0x805148
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803198:	a1 54 51 80 00       	mov    0x805154,%eax
  80319d:	40                   	inc    %eax
  80319e:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8031a3:	e9 c9 03 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 40 08             	mov    0x8(%eax),%eax
  8031b4:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8031bc:	39 c2                	cmp    %eax,%edx
  8031be:	0f 85 bb 00 00 00    	jne    80327f <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8031c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c8:	0f 84 b1 00 00 00    	je     80327f <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	0f 85 a3 00 00 00    	jne    80327f <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8031dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e4:	8b 52 08             	mov    0x8(%edx),%edx
  8031e7:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8031ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031f5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8031fe:	01 ca                	add    %ecx,%edx
  803200:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321b:	75 17                	jne    803234 <insert_sorted_with_merge_freeList+0x498>
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	68 74 40 80 00       	push   $0x804074
  803225:	68 17 01 00 00       	push   $0x117
  80322a:	68 97 40 80 00       	push   $0x804097
  80322f:	e8 88 d5 ff ff       	call   8007bc <_panic>
  803234:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	89 10                	mov    %edx,(%eax)
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0d                	je     803255 <insert_sorted_with_merge_freeList+0x4b9>
  803248:	a1 48 51 80 00       	mov    0x805148,%eax
  80324d:	8b 55 08             	mov    0x8(%ebp),%edx
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	eb 08                	jmp    80325d <insert_sorted_with_merge_freeList+0x4c1>
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	a3 48 51 80 00       	mov    %eax,0x805148
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326f:	a1 54 51 80 00       	mov    0x805154,%eax
  803274:	40                   	inc    %eax
  803275:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80327a:	e9 f2 02 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 50 08             	mov    0x8(%eax),%edx
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	8b 40 0c             	mov    0xc(%eax),%eax
  80328b:	01 c2                	add    %eax,%edx
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 40 08             	mov    0x8(%eax),%eax
  803293:	39 c2                	cmp    %eax,%edx
  803295:	0f 85 be 00 00 00    	jne    803359 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	8b 50 08             	mov    0x8(%eax),%edx
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ad:	01 c2                	add    %eax,%edx
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 40 08             	mov    0x8(%eax),%eax
  8032b5:	39 c2                	cmp    %eax,%edx
  8032b7:	0f 84 9c 00 00 00    	je     803359 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	8b 50 08             	mov    0x8(%eax),%edx
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d5:	01 c2                	add    %eax,%edx
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8032f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f5:	75 17                	jne    80330e <insert_sorted_with_merge_freeList+0x572>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 74 40 80 00       	push   $0x804074
  8032ff:	68 26 01 00 00       	push   $0x126
  803304:	68 97 40 80 00       	push   $0x804097
  803309:	e8 ae d4 ff ff       	call   8007bc <_panic>
  80330e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	89 10                	mov    %edx,(%eax)
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 0d                	je     80332f <insert_sorted_with_merge_freeList+0x593>
  803322:	a1 48 51 80 00       	mov    0x805148,%eax
  803327:	8b 55 08             	mov    0x8(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 08                	jmp    803337 <insert_sorted_with_merge_freeList+0x59b>
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	a3 48 51 80 00       	mov    %eax,0x805148
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803349:	a1 54 51 80 00       	mov    0x805154,%eax
  80334e:	40                   	inc    %eax
  80334f:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803354:	e9 18 02 00 00       	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 50 0c             	mov    0xc(%eax),%edx
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 40 08             	mov    0x8(%eax),%eax
  803365:	01 c2                	add    %eax,%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 85 c4 01 00 00    	jne    803539 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 50 0c             	mov    0xc(%eax),%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	01 c2                	add    %eax,%edx
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	8b 40 08             	mov    0x8(%eax),%eax
  80338b:	39 c2                	cmp    %eax,%edx
  80338d:	0f 85 a6 01 00 00    	jne    803539 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803397:	0f 84 9c 01 00 00    	je     803539 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a9:	01 c2                	add    %eax,%edx
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	8b 00                	mov    (%eax),%eax
  8033b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b3:	01 c2                	add    %eax,%edx
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8033cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d3:	75 17                	jne    8033ec <insert_sorted_with_merge_freeList+0x650>
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 74 40 80 00       	push   $0x804074
  8033dd:	68 32 01 00 00       	push   $0x132
  8033e2:	68 97 40 80 00       	push   $0x804097
  8033e7:	e8 d0 d3 ff ff       	call   8007bc <_panic>
  8033ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0d                	je     80340d <insert_sorted_with_merge_freeList+0x671>
  803400:	a1 48 51 80 00       	mov    0x805148,%eax
  803405:	8b 55 08             	mov    0x8(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 08                	jmp    803415 <insert_sorted_with_merge_freeList+0x679>
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	a3 48 51 80 00       	mov    %eax,0x805148
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803427:	a1 54 51 80 00       	mov    0x805154,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803452:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803456:	75 17                	jne    80346f <insert_sorted_with_merge_freeList+0x6d3>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 09 41 80 00       	push   $0x804109
  803460:	68 36 01 00 00       	push   $0x136
  803465:	68 97 40 80 00       	push   $0x804097
  80346a:	e8 4d d3 ff ff       	call   8007bc <_panic>
  80346f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	74 10                	je     803488 <insert_sorted_with_merge_freeList+0x6ec>
  803478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803480:	8b 52 04             	mov    0x4(%edx),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	eb 0b                	jmp    803493 <insert_sorted_with_merge_freeList+0x6f7>
  803488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348b:	8b 40 04             	mov    0x4(%eax),%eax
  80348e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803496:	8b 40 04             	mov    0x4(%eax),%eax
  803499:	85 c0                	test   %eax,%eax
  80349b:	74 0f                	je     8034ac <insert_sorted_with_merge_freeList+0x710>
  80349d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a6:	8b 12                	mov    (%edx),%edx
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	eb 0a                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x71a>
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ce:	48                   	dec    %eax
  8034cf:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8034d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d8:	75 17                	jne    8034f1 <insert_sorted_with_merge_freeList+0x755>
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	68 74 40 80 00       	push   $0x804074
  8034e2:	68 37 01 00 00       	push   $0x137
  8034e7:	68 97 40 80 00       	push   $0x804097
  8034ec:	e8 cb d2 ff ff       	call   8007bc <_panic>
  8034f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	89 10                	mov    %edx,(%eax)
  8034fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	85 c0                	test   %eax,%eax
  803503:	74 0d                	je     803512 <insert_sorted_with_merge_freeList+0x776>
  803505:	a1 48 51 80 00       	mov    0x805148,%eax
  80350a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80350d:	89 50 04             	mov    %edx,0x4(%eax)
  803510:	eb 08                	jmp    80351a <insert_sorted_with_merge_freeList+0x77e>
  803512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803515:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80351a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351d:	a3 48 51 80 00       	mov    %eax,0x805148
  803522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352c:	a1 54 51 80 00       	mov    0x805154,%eax
  803531:	40                   	inc    %eax
  803532:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803537:	eb 38                	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803539:	a1 40 51 80 00       	mov    0x805140,%eax
  80353e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803545:	74 07                	je     80354e <insert_sorted_with_merge_freeList+0x7b2>
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	eb 05                	jmp    803553 <insert_sorted_with_merge_freeList+0x7b7>
  80354e:	b8 00 00 00 00       	mov    $0x0,%eax
  803553:	a3 40 51 80 00       	mov    %eax,0x805140
  803558:	a1 40 51 80 00       	mov    0x805140,%eax
  80355d:	85 c0                	test   %eax,%eax
  80355f:	0f 85 ef f9 ff ff    	jne    802f54 <insert_sorted_with_merge_freeList+0x1b8>
  803565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803569:	0f 85 e5 f9 ff ff    	jne    802f54 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80356f:	eb 00                	jmp    803571 <insert_sorted_with_merge_freeList+0x7d5>
  803571:	90                   	nop
  803572:	c9                   	leave  
  803573:	c3                   	ret    

00803574 <__udivdi3>:
  803574:	55                   	push   %ebp
  803575:	57                   	push   %edi
  803576:	56                   	push   %esi
  803577:	53                   	push   %ebx
  803578:	83 ec 1c             	sub    $0x1c,%esp
  80357b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80357f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803587:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80358b:	89 ca                	mov    %ecx,%edx
  80358d:	89 f8                	mov    %edi,%eax
  80358f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803593:	85 f6                	test   %esi,%esi
  803595:	75 2d                	jne    8035c4 <__udivdi3+0x50>
  803597:	39 cf                	cmp    %ecx,%edi
  803599:	77 65                	ja     803600 <__udivdi3+0x8c>
  80359b:	89 fd                	mov    %edi,%ebp
  80359d:	85 ff                	test   %edi,%edi
  80359f:	75 0b                	jne    8035ac <__udivdi3+0x38>
  8035a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a6:	31 d2                	xor    %edx,%edx
  8035a8:	f7 f7                	div    %edi
  8035aa:	89 c5                	mov    %eax,%ebp
  8035ac:	31 d2                	xor    %edx,%edx
  8035ae:	89 c8                	mov    %ecx,%eax
  8035b0:	f7 f5                	div    %ebp
  8035b2:	89 c1                	mov    %eax,%ecx
  8035b4:	89 d8                	mov    %ebx,%eax
  8035b6:	f7 f5                	div    %ebp
  8035b8:	89 cf                	mov    %ecx,%edi
  8035ba:	89 fa                	mov    %edi,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 ce                	cmp    %ecx,%esi
  8035c6:	77 28                	ja     8035f0 <__udivdi3+0x7c>
  8035c8:	0f bd fe             	bsr    %esi,%edi
  8035cb:	83 f7 1f             	xor    $0x1f,%edi
  8035ce:	75 40                	jne    803610 <__udivdi3+0x9c>
  8035d0:	39 ce                	cmp    %ecx,%esi
  8035d2:	72 0a                	jb     8035de <__udivdi3+0x6a>
  8035d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d8:	0f 87 9e 00 00 00    	ja     80367c <__udivdi3+0x108>
  8035de:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e3:	89 fa                	mov    %edi,%edx
  8035e5:	83 c4 1c             	add    $0x1c,%esp
  8035e8:	5b                   	pop    %ebx
  8035e9:	5e                   	pop    %esi
  8035ea:	5f                   	pop    %edi
  8035eb:	5d                   	pop    %ebp
  8035ec:	c3                   	ret    
  8035ed:	8d 76 00             	lea    0x0(%esi),%esi
  8035f0:	31 ff                	xor    %edi,%edi
  8035f2:	31 c0                	xor    %eax,%eax
  8035f4:	89 fa                	mov    %edi,%edx
  8035f6:	83 c4 1c             	add    $0x1c,%esp
  8035f9:	5b                   	pop    %ebx
  8035fa:	5e                   	pop    %esi
  8035fb:	5f                   	pop    %edi
  8035fc:	5d                   	pop    %ebp
  8035fd:	c3                   	ret    
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	89 d8                	mov    %ebx,%eax
  803602:	f7 f7                	div    %edi
  803604:	31 ff                	xor    %edi,%edi
  803606:	89 fa                	mov    %edi,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	bd 20 00 00 00       	mov    $0x20,%ebp
  803615:	89 eb                	mov    %ebp,%ebx
  803617:	29 fb                	sub    %edi,%ebx
  803619:	89 f9                	mov    %edi,%ecx
  80361b:	d3 e6                	shl    %cl,%esi
  80361d:	89 c5                	mov    %eax,%ebp
  80361f:	88 d9                	mov    %bl,%cl
  803621:	d3 ed                	shr    %cl,%ebp
  803623:	89 e9                	mov    %ebp,%ecx
  803625:	09 f1                	or     %esi,%ecx
  803627:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80362b:	89 f9                	mov    %edi,%ecx
  80362d:	d3 e0                	shl    %cl,%eax
  80362f:	89 c5                	mov    %eax,%ebp
  803631:	89 d6                	mov    %edx,%esi
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 ee                	shr    %cl,%esi
  803637:	89 f9                	mov    %edi,%ecx
  803639:	d3 e2                	shl    %cl,%edx
  80363b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363f:	88 d9                	mov    %bl,%cl
  803641:	d3 e8                	shr    %cl,%eax
  803643:	09 c2                	or     %eax,%edx
  803645:	89 d0                	mov    %edx,%eax
  803647:	89 f2                	mov    %esi,%edx
  803649:	f7 74 24 0c          	divl   0xc(%esp)
  80364d:	89 d6                	mov    %edx,%esi
  80364f:	89 c3                	mov    %eax,%ebx
  803651:	f7 e5                	mul    %ebp
  803653:	39 d6                	cmp    %edx,%esi
  803655:	72 19                	jb     803670 <__udivdi3+0xfc>
  803657:	74 0b                	je     803664 <__udivdi3+0xf0>
  803659:	89 d8                	mov    %ebx,%eax
  80365b:	31 ff                	xor    %edi,%edi
  80365d:	e9 58 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  803662:	66 90                	xchg   %ax,%ax
  803664:	8b 54 24 08          	mov    0x8(%esp),%edx
  803668:	89 f9                	mov    %edi,%ecx
  80366a:	d3 e2                	shl    %cl,%edx
  80366c:	39 c2                	cmp    %eax,%edx
  80366e:	73 e9                	jae    803659 <__udivdi3+0xe5>
  803670:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803673:	31 ff                	xor    %edi,%edi
  803675:	e9 40 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	31 c0                	xor    %eax,%eax
  80367e:	e9 37 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  803683:	90                   	nop

00803684 <__umoddi3>:
  803684:	55                   	push   %ebp
  803685:	57                   	push   %edi
  803686:	56                   	push   %esi
  803687:	53                   	push   %ebx
  803688:	83 ec 1c             	sub    $0x1c,%esp
  80368b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80368f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803697:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80369b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80369f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036a3:	89 f3                	mov    %esi,%ebx
  8036a5:	89 fa                	mov    %edi,%edx
  8036a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ab:	89 34 24             	mov    %esi,(%esp)
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	75 1a                	jne    8036cc <__umoddi3+0x48>
  8036b2:	39 f7                	cmp    %esi,%edi
  8036b4:	0f 86 a2 00 00 00    	jbe    80375c <__umoddi3+0xd8>
  8036ba:	89 c8                	mov    %ecx,%eax
  8036bc:	89 f2                	mov    %esi,%edx
  8036be:	f7 f7                	div    %edi
  8036c0:	89 d0                	mov    %edx,%eax
  8036c2:	31 d2                	xor    %edx,%edx
  8036c4:	83 c4 1c             	add    $0x1c,%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
  8036cc:	39 f0                	cmp    %esi,%eax
  8036ce:	0f 87 ac 00 00 00    	ja     803780 <__umoddi3+0xfc>
  8036d4:	0f bd e8             	bsr    %eax,%ebp
  8036d7:	83 f5 1f             	xor    $0x1f,%ebp
  8036da:	0f 84 ac 00 00 00    	je     80378c <__umoddi3+0x108>
  8036e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e5:	29 ef                	sub    %ebp,%edi
  8036e7:	89 fe                	mov    %edi,%esi
  8036e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036ed:	89 e9                	mov    %ebp,%ecx
  8036ef:	d3 e0                	shl    %cl,%eax
  8036f1:	89 d7                	mov    %edx,%edi
  8036f3:	89 f1                	mov    %esi,%ecx
  8036f5:	d3 ef                	shr    %cl,%edi
  8036f7:	09 c7                	or     %eax,%edi
  8036f9:	89 e9                	mov    %ebp,%ecx
  8036fb:	d3 e2                	shl    %cl,%edx
  8036fd:	89 14 24             	mov    %edx,(%esp)
  803700:	89 d8                	mov    %ebx,%eax
  803702:	d3 e0                	shl    %cl,%eax
  803704:	89 c2                	mov    %eax,%edx
  803706:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370a:	d3 e0                	shl    %cl,%eax
  80370c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803710:	8b 44 24 08          	mov    0x8(%esp),%eax
  803714:	89 f1                	mov    %esi,%ecx
  803716:	d3 e8                	shr    %cl,%eax
  803718:	09 d0                	or     %edx,%eax
  80371a:	d3 eb                	shr    %cl,%ebx
  80371c:	89 da                	mov    %ebx,%edx
  80371e:	f7 f7                	div    %edi
  803720:	89 d3                	mov    %edx,%ebx
  803722:	f7 24 24             	mull   (%esp)
  803725:	89 c6                	mov    %eax,%esi
  803727:	89 d1                	mov    %edx,%ecx
  803729:	39 d3                	cmp    %edx,%ebx
  80372b:	0f 82 87 00 00 00    	jb     8037b8 <__umoddi3+0x134>
  803731:	0f 84 91 00 00 00    	je     8037c8 <__umoddi3+0x144>
  803737:	8b 54 24 04          	mov    0x4(%esp),%edx
  80373b:	29 f2                	sub    %esi,%edx
  80373d:	19 cb                	sbb    %ecx,%ebx
  80373f:	89 d8                	mov    %ebx,%eax
  803741:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803745:	d3 e0                	shl    %cl,%eax
  803747:	89 e9                	mov    %ebp,%ecx
  803749:	d3 ea                	shr    %cl,%edx
  80374b:	09 d0                	or     %edx,%eax
  80374d:	89 e9                	mov    %ebp,%ecx
  80374f:	d3 eb                	shr    %cl,%ebx
  803751:	89 da                	mov    %ebx,%edx
  803753:	83 c4 1c             	add    $0x1c,%esp
  803756:	5b                   	pop    %ebx
  803757:	5e                   	pop    %esi
  803758:	5f                   	pop    %edi
  803759:	5d                   	pop    %ebp
  80375a:	c3                   	ret    
  80375b:	90                   	nop
  80375c:	89 fd                	mov    %edi,%ebp
  80375e:	85 ff                	test   %edi,%edi
  803760:	75 0b                	jne    80376d <__umoddi3+0xe9>
  803762:	b8 01 00 00 00       	mov    $0x1,%eax
  803767:	31 d2                	xor    %edx,%edx
  803769:	f7 f7                	div    %edi
  80376b:	89 c5                	mov    %eax,%ebp
  80376d:	89 f0                	mov    %esi,%eax
  80376f:	31 d2                	xor    %edx,%edx
  803771:	f7 f5                	div    %ebp
  803773:	89 c8                	mov    %ecx,%eax
  803775:	f7 f5                	div    %ebp
  803777:	89 d0                	mov    %edx,%eax
  803779:	e9 44 ff ff ff       	jmp    8036c2 <__umoddi3+0x3e>
  80377e:	66 90                	xchg   %ax,%ax
  803780:	89 c8                	mov    %ecx,%eax
  803782:	89 f2                	mov    %esi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	3b 04 24             	cmp    (%esp),%eax
  80378f:	72 06                	jb     803797 <__umoddi3+0x113>
  803791:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803795:	77 0f                	ja     8037a6 <__umoddi3+0x122>
  803797:	89 f2                	mov    %esi,%edx
  803799:	29 f9                	sub    %edi,%ecx
  80379b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80379f:	89 14 24             	mov    %edx,(%esp)
  8037a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037aa:	8b 14 24             	mov    (%esp),%edx
  8037ad:	83 c4 1c             	add    $0x1c,%esp
  8037b0:	5b                   	pop    %ebx
  8037b1:	5e                   	pop    %esi
  8037b2:	5f                   	pop    %edi
  8037b3:	5d                   	pop    %ebp
  8037b4:	c3                   	ret    
  8037b5:	8d 76 00             	lea    0x0(%esi),%esi
  8037b8:	2b 04 24             	sub    (%esp),%eax
  8037bb:	19 fa                	sbb    %edi,%edx
  8037bd:	89 d1                	mov    %edx,%ecx
  8037bf:	89 c6                	mov    %eax,%esi
  8037c1:	e9 71 ff ff ff       	jmp    803737 <__umoddi3+0xb3>
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037cc:	72 ea                	jb     8037b8 <__umoddi3+0x134>
  8037ce:	89 d9                	mov    %ebx,%ecx
  8037d0:	e9 62 ff ff ff       	jmp    803737 <__umoddi3+0xb3>
