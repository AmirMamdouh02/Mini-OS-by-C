
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 a0 3f 80 00       	push   $0x803fa0
  800096:	6a 1a                	push   $0x1a
  800098:	68 bc 3f 80 00       	push   $0x803fbc
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 0f 21 00 00       	call   8021bb <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 75 25 00 00       	call   802659 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 f9 25 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 a7 20 00 00       	call   8021bb <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 d0 3f 80 00       	push   $0x803fd0
  80013c:	6a 39                	push   $0x39
  80013e:	68 bc 3f 80 00       	push   $0x803fbc
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 ac 25 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 38 40 80 00       	push   $0x804038
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 bc 3f 80 00       	push   $0x803fbc
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 ee 24 00 00       	call   802659 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 b9 24 00 00       	call   802659 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 68 40 80 00       	push   $0x804068
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 bc 3f 80 00       	push   $0x803fbc
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 ac 40 80 00       	push   $0x8040ac
  800273:	6a 4b                	push   $0x4b
  800275:	68 bc 3f 80 00       	push   $0x803fbc
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 75 24 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 23 1f 00 00       	call   8021bb <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 d0 3f 80 00       	push   $0x803fd0
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 bc 3f 80 00       	push   $0x803fbc
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 13 24 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 38 40 80 00       	push   $0x804038
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 bc 3f 80 00       	push   $0x803fbc
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 55 23 00 00       	call   802659 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 17 23 00 00       	call   802659 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 68 40 80 00       	push   $0x804068
  800353:	6a 58                	push   $0x58
  800355:	68 bc 3f 80 00       	push   $0x803fbc
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 ac 40 80 00       	push   $0x8040ac
  800419:	6a 61                	push   $0x61
  80041b:	68 bc 3f 80 00       	push   $0x803fbc
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 cf 22 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 7c 1d 00 00       	call   8021bb <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 d0 3f 80 00       	push   $0x803fd0
  80047e:	6a 66                	push   $0x66
  800480:	68 bc 3f 80 00       	push   $0x803fbc
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 6a 22 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 38 40 80 00       	push   $0x804038
  80049c:	6a 67                	push   $0x67
  80049e:	68 bc 3f 80 00       	push   $0x803fbc
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 ac 21 00 00       	call   802659 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 70 21 00 00       	call   802659 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 68 40 80 00       	push   $0x804068
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 bc 3f 80 00       	push   $0x803fbc
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 ac 40 80 00       	push   $0x8040ac
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 bc 3f 80 00       	push   $0x803fbc
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 7f 20 00 00       	call   802659 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 17 21 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 c4 1b 00 00       	call   8021bb <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 d0 3f 80 00       	push   $0x803fd0
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 bc 3f 80 00       	push   $0x803fbc
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 9e 20 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 38 40 80 00       	push   $0x804038
  800668:	6a 7e                	push   $0x7e
  80066a:	68 bc 3f 80 00       	push   $0x803fbc
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 80 20 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 29 1b 00 00       	call   8021bb <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 d0 3f 80 00       	push   $0x803fd0
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 bc 3f 80 00       	push   $0x803fbc
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 00 20 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 38 40 80 00       	push   $0x804038
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 bc 3f 80 00       	push   $0x803fbc
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 3f 1f 00 00       	call   802659 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 9b 1e 00 00       	call   802659 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 68 40 80 00       	push   $0x804068
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 bc 3f 80 00       	push   $0x803fbc
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 ac 40 80 00       	push   $0x8040ac
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 bc 3f 80 00       	push   $0x803fbc
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 89 1d 00 00       	call   802659 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 21 1e 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 cb 18 00 00       	call   8021bb <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 d0 3f 80 00       	push   $0x803fd0
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 bc 3f 80 00       	push   $0x803fbc
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 a2 1d 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 38 40 80 00       	push   $0x804038
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 bc 3f 80 00       	push   $0x803fbc
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 81 1d 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 29 18 00 00       	call   8021bb <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 d0 3f 80 00       	push   $0x803fd0
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 bc 3f 80 00       	push   $0x803fbc
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 f2 1c 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 38 40 80 00       	push   $0x804038
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 bc 3f 80 00       	push   $0x803fbc
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 31 1c 00 00       	call   802659 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 c0 1b 00 00       	call   802659 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 68 40 80 00       	push   $0x804068
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 bc 3f 80 00       	push   $0x803fbc
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 ac 40 80 00       	push   $0x8040ac
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 bc 3f 80 00       	push   $0x803fbc
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 f6 1a 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 9d 15 00 00       	call   8021bb <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 d0 3f 80 00       	push   $0x803fd0
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 bc 3f 80 00       	push   $0x803fbc
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 64 1a 00 00       	call   8026f9 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 38 40 80 00       	push   $0x804038
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 bc 3f 80 00       	push   $0x803fbc
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 a3 19 00 00       	call   802659 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 4f 19 00 00       	call   802659 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 68 40 80 00       	push   $0x804068
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 bc 3f 80 00       	push   $0x803fbc
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 ac 40 80 00       	push   $0x8040ac
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 bc 3f 80 00       	push   $0x803fbc
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 cc 40 80 00       	push   $0x8040cc
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 02 1b 00 00       	call   802939 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 a4 18 00 00       	call   802746 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 20 41 80 00       	push   $0x804120
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 48 41 80 00       	push   $0x804148
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 70 41 80 00       	push   $0x804170
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 c8 41 80 00       	push   $0x8041c8
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 20 41 80 00       	push   $0x804120
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 24 18 00 00       	call   802760 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 b1 19 00 00       	call   802905 <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 06 1a 00 00       	call   80296b <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 dc 41 80 00       	push   $0x8041dc
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 e1 41 80 00       	push   $0x8041e1
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 fd 41 80 00       	push   $0x8041fd
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 00 42 80 00       	push   $0x804200
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 4c 42 80 00       	push   $0x80424c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 58 42 80 00       	push   $0x804258
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 4c 42 80 00       	push   $0x80424c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 ac 42 80 00       	push   $0x8042ac
  801139:	6a 44                	push   $0x44
  80113b:	68 4c 42 80 00       	push   $0x80424c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 05 14 00 00       	call   802598 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 8e 13 00 00       	call   802598 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 f2 14 00 00       	call   802746 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 ec 14 00 00       	call   802760 <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 62 2a 00 00       	call   803d20 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 22 2b 00 00       	call   803e30 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 14 45 80 00       	add    $0x804514,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 25 45 80 00       	push   $0x804525
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 2e 45 80 00       	push   $0x80452e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 31 45 80 00       	mov    $0x804531,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 90 46 80 00       	push   $0x804690
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801fdd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801fe4:	00 00 00 
  801fe7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801fee:	00 00 00 
  801ff1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ff8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801ffb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802002:	00 00 00 
  802005:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80200c:	00 00 00 
  80200f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802016:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  802019:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	c1 e8 0c             	shr    $0xc,%eax
  802026:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80202b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80203a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80203f:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  802044:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80204b:	a1 20 51 80 00       	mov    0x805120,%eax
  802050:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  802054:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  802057:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80205e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802064:	01 d0                	add    %edx,%eax
  802066:	48                   	dec    %eax
  802067:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80206a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80206d:	ba 00 00 00 00       	mov    $0x0,%edx
  802072:	f7 75 e4             	divl   -0x1c(%ebp)
  802075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802078:	29 d0                	sub    %edx,%eax
  80207a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80207d:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  802084:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80208c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	6a 07                	push   $0x7
  802096:	ff 75 e8             	pushl  -0x18(%ebp)
  802099:	50                   	push   %eax
  80209a:	e8 3d 06 00 00       	call   8026dc <sys_allocate_chunk>
  80209f:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8020a2:	a1 20 51 80 00       	mov    0x805120,%eax
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	50                   	push   %eax
  8020ab:	e8 b2 0c 00 00       	call   802d62 <initialize_MemBlocksList>
  8020b0:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8020b3:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8020b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8020bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020bf:	0f 84 f3 00 00 00    	je     8021b8 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8020c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020c9:	75 14                	jne    8020df <initialize_dyn_block_system+0x108>
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 b5 46 80 00       	push   $0x8046b5
  8020d3:	6a 36                	push   $0x36
  8020d5:	68 d3 46 80 00       	push   $0x8046d3
  8020da:	e8 89 ee ff ff       	call   800f68 <_panic>
  8020df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	74 10                	je     8020f8 <initialize_dyn_block_system+0x121>
  8020e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020f0:	8b 52 04             	mov    0x4(%edx),%edx
  8020f3:	89 50 04             	mov    %edx,0x4(%eax)
  8020f6:	eb 0b                	jmp    802103 <initialize_dyn_block_system+0x12c>
  8020f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020fb:	8b 40 04             	mov    0x4(%eax),%eax
  8020fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802103:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802106:	8b 40 04             	mov    0x4(%eax),%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 0f                	je     80211c <initialize_dyn_block_system+0x145>
  80210d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802110:	8b 40 04             	mov    0x4(%eax),%eax
  802113:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802116:	8b 12                	mov    (%edx),%edx
  802118:	89 10                	mov    %edx,(%eax)
  80211a:	eb 0a                	jmp    802126 <initialize_dyn_block_system+0x14f>
  80211c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	a3 48 51 80 00       	mov    %eax,0x805148
  802126:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802132:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802139:	a1 54 51 80 00       	mov    0x805154,%eax
  80213e:	48                   	dec    %eax
  80213f:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  802144:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802147:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80214e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802151:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  802158:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80215c:	75 14                	jne    802172 <initialize_dyn_block_system+0x19b>
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	68 e0 46 80 00       	push   $0x8046e0
  802166:	6a 3e                	push   $0x3e
  802168:	68 d3 46 80 00       	push   $0x8046d3
  80216d:	e8 f6 ed ff ff       	call   800f68 <_panic>
  802172:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802178:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80217b:	89 10                	mov    %edx,(%eax)
  80217d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802180:	8b 00                	mov    (%eax),%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	74 0d                	je     802193 <initialize_dyn_block_system+0x1bc>
  802186:	a1 38 51 80 00       	mov    0x805138,%eax
  80218b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80218e:	89 50 04             	mov    %edx,0x4(%eax)
  802191:	eb 08                	jmp    80219b <initialize_dyn_block_system+0x1c4>
  802193:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802196:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80219b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80219e:	a3 38 51 80 00       	mov    %eax,0x805138
  8021a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8021b2:	40                   	inc    %eax
  8021b3:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  8021b8:	90                   	nop
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8021c1:	e8 e0 fd ff ff       	call   801fa6 <InitializeUHeap>
		if (size == 0) return NULL ;
  8021c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ca:	75 07                	jne    8021d3 <malloc+0x18>
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d1:	eb 7f                	jmp    802252 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8021d3:	e8 d2 08 00 00       	call   802aaa <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	74 71                	je     80224d <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8021dc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8021e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	48                   	dec    %eax
  8021ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f7:	f7 75 f4             	divl   -0xc(%ebp)
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	29 d0                	sub    %edx,%eax
  8021ff:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  802202:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  802209:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802210:	76 07                	jbe    802219 <malloc+0x5e>
					return NULL ;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
  802217:	eb 39                	jmp    802252 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	e8 e6 0d 00 00       	call   80300a <alloc_block_FF>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80222a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222e:	74 16                	je     802246 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  802230:	83 ec 0c             	sub    $0xc,%esp
  802233:	ff 75 ec             	pushl  -0x14(%ebp)
  802236:	e8 37 0c 00 00       	call   802e72 <insert_sorted_allocList>
  80223b:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	8b 40 08             	mov    0x8(%eax),%eax
  802244:	eb 0c                	jmp    802252 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
  80224b:	eb 05                	jmp    802252 <malloc+0x97>
				}
		}
	return 0;
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  802260:	83 ec 08             	sub    $0x8,%esp
  802263:	ff 75 f4             	pushl  -0xc(%ebp)
  802266:	68 40 50 80 00       	push   $0x805040
  80226b:	e8 cf 0b 00 00       	call   802e3f <find_block>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	8b 40 0c             	mov    0xc(%eax),%eax
  80227c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80227f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  802288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228c:	0f 84 a1 00 00 00    	je     802333 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  802292:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802296:	75 17                	jne    8022af <free+0x5b>
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 b5 46 80 00       	push   $0x8046b5
  8022a0:	68 80 00 00 00       	push   $0x80
  8022a5:	68 d3 46 80 00       	push   $0x8046d3
  8022aa:	e8 b9 ec ff ff       	call   800f68 <_panic>
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	8b 00                	mov    (%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 10                	je     8022c8 <free+0x74>
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 00                	mov    (%eax),%eax
  8022bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c0:	8b 52 04             	mov    0x4(%edx),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	eb 0b                	jmp    8022d3 <free+0x7f>
  8022c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 0f                	je     8022ec <free+0x98>
  8022dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e0:	8b 40 04             	mov    0x4(%eax),%eax
  8022e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e6:	8b 12                	mov    (%edx),%edx
  8022e8:	89 10                	mov    %edx,(%eax)
  8022ea:	eb 0a                	jmp    8022f6 <free+0xa2>
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802309:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80230e:	48                   	dec    %eax
  80230f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  802314:	83 ec 0c             	sub    $0xc,%esp
  802317:	ff 75 f0             	pushl  -0x10(%ebp)
  80231a:	e8 29 12 00 00       	call   803548 <insert_sorted_with_merge_freeList>
  80231f:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  802322:	83 ec 08             	sub    $0x8,%esp
  802325:	ff 75 ec             	pushl  -0x14(%ebp)
  802328:	ff 75 e8             	pushl  -0x18(%ebp)
  80232b:	e8 74 03 00 00       	call   8026a4 <sys_free_user_mem>
  802330:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802333:	90                   	nop
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 38             	sub    $0x38,%esp
  80233c:	8b 45 10             	mov    0x10(%ebp),%eax
  80233f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802342:	e8 5f fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802347:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80234b:	75 0a                	jne    802357 <smalloc+0x21>
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
  802352:	e9 b2 00 00 00       	jmp    802409 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802357:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80235e:	76 0a                	jbe    80236a <smalloc+0x34>
		return NULL;
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
  802365:	e9 9f 00 00 00       	jmp    802409 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80236a:	e8 3b 07 00 00       	call   802aaa <sys_isUHeapPlacementStrategyFIRSTFIT>
  80236f:	85 c0                	test   %eax,%eax
  802371:	0f 84 8d 00 00 00    	je     802404 <smalloc+0xce>
	struct MemBlock *b = NULL;
  802377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80237e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802385:	8b 55 0c             	mov    0xc(%ebp),%edx
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	48                   	dec    %eax
  80238e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802394:	ba 00 00 00 00       	mov    $0x0,%edx
  802399:	f7 75 f0             	divl   -0x10(%ebp)
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	29 d0                	sub    %edx,%eax
  8023a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8023aa:	e8 5b 0c 00 00       	call   80300a <alloc_block_FF>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8023b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b9:	75 07                	jne    8023c2 <smalloc+0x8c>
			return NULL;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	eb 47                	jmp    802409 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c8:	e8 a5 0a 00 00       	call   802e72 <insert_sorted_allocList>
  8023cd:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 08             	mov    0x8(%eax),%eax
  8023d6:	89 c2                	mov    %eax,%edx
  8023d8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8023dc:	52                   	push   %edx
  8023dd:	50                   	push   %eax
  8023de:	ff 75 0c             	pushl  0xc(%ebp)
  8023e1:	ff 75 08             	pushl  0x8(%ebp)
  8023e4:	e8 46 04 00 00       	call   80282f <sys_createSharedObject>
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8023ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023f3:	78 08                	js     8023fd <smalloc+0xc7>
		return (void *)b->sva;
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 08             	mov    0x8(%eax),%eax
  8023fb:	eb 0c                	jmp    802409 <smalloc+0xd3>
		}else{
		return NULL;
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	eb 05                	jmp    802409 <smalloc+0xd3>
			}

	}return NULL;
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802411:	e8 90 fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802416:	e8 8f 06 00 00       	call   802aaa <sys_isUHeapPlacementStrategyFIRSTFIT>
  80241b:	85 c0                	test   %eax,%eax
  80241d:	0f 84 ad 00 00 00    	je     8024d0 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802423:	83 ec 08             	sub    $0x8,%esp
  802426:	ff 75 0c             	pushl  0xc(%ebp)
  802429:	ff 75 08             	pushl  0x8(%ebp)
  80242c:	e8 28 04 00 00       	call   802859 <sys_getSizeOfSharedObject>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243b:	79 0a                	jns    802447 <sget+0x3c>
    {
    	return NULL;
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	e9 8e 00 00 00       	jmp    8024d5 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802447:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80244e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245b:	01 d0                	add    %edx,%eax
  80245d:	48                   	dec    %eax
  80245e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802464:	ba 00 00 00 00       	mov    $0x0,%edx
  802469:	f7 75 ec             	divl   -0x14(%ebp)
  80246c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80246f:	29 d0                	sub    %edx,%eax
  802471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	ff 75 e4             	pushl  -0x1c(%ebp)
  80247a:	e8 8b 0b 00 00       	call   80300a <alloc_block_FF>
  80247f:	83 c4 10             	add    $0x10,%esp
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802489:	75 07                	jne    802492 <sget+0x87>
				return NULL;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	eb 43                	jmp    8024d5 <sget+0xca>
			}
			insert_sorted_allocList(b);
  802492:	83 ec 0c             	sub    $0xc,%esp
  802495:	ff 75 f0             	pushl  -0x10(%ebp)
  802498:	e8 d5 09 00 00       	call   802e72 <insert_sorted_allocList>
  80249d:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8024a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	50                   	push   %eax
  8024aa:	ff 75 0c             	pushl  0xc(%ebp)
  8024ad:	ff 75 08             	pushl  0x8(%ebp)
  8024b0:	e8 c1 03 00 00       	call   802876 <sys_getSharedObject>
  8024b5:	83 c4 10             	add    $0x10,%esp
  8024b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8024bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024bf:	78 08                	js     8024c9 <sget+0xbe>
			return (void *)b->sva;
  8024c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	eb 0c                	jmp    8024d5 <sget+0xca>
			}else{
			return NULL;
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	eb 05                	jmp    8024d5 <sget+0xca>
			}
    }}return NULL;
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024dd:	e8 c4 fa ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 04 47 80 00       	push   $0x804704
  8024ea:	68 03 01 00 00       	push   $0x103
  8024ef:	68 d3 46 80 00       	push   $0x8046d3
  8024f4:	e8 6f ea ff ff       	call   800f68 <_panic>

008024f9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8024ff:	83 ec 04             	sub    $0x4,%esp
  802502:	68 2c 47 80 00       	push   $0x80472c
  802507:	68 17 01 00 00       	push   $0x117
  80250c:	68 d3 46 80 00       	push   $0x8046d3
  802511:	e8 52 ea ff ff       	call   800f68 <_panic>

00802516 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
  802519:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 50 47 80 00       	push   $0x804750
  802524:	68 22 01 00 00       	push   $0x122
  802529:	68 d3 46 80 00       	push   $0x8046d3
  80252e:	e8 35 ea ff ff       	call   800f68 <_panic>

00802533 <shrink>:

}
void shrink(uint32 newSize)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802539:	83 ec 04             	sub    $0x4,%esp
  80253c:	68 50 47 80 00       	push   $0x804750
  802541:	68 27 01 00 00       	push   $0x127
  802546:	68 d3 46 80 00       	push   $0x8046d3
  80254b:	e8 18 ea ff ff       	call   800f68 <_panic>

00802550 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	68 50 47 80 00       	push   $0x804750
  80255e:	68 2c 01 00 00       	push   $0x12c
  802563:	68 d3 46 80 00       	push   $0x8046d3
  802568:	e8 fb e9 ff ff       	call   800f68 <_panic>

0080256d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	57                   	push   %edi
  802571:	56                   	push   %esi
  802572:	53                   	push   %ebx
  802573:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80257f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802582:	8b 7d 18             	mov    0x18(%ebp),%edi
  802585:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802588:	cd 30                	int    $0x30
  80258a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5f                   	pop    %edi
  802596:	5d                   	pop    %ebp
  802597:	c3                   	ret    

00802598 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	83 ec 04             	sub    $0x4,%esp
  80259e:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8025a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	52                   	push   %edx
  8025b0:	ff 75 0c             	pushl  0xc(%ebp)
  8025b3:	50                   	push   %eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	e8 b2 ff ff ff       	call   80256d <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
}
  8025be:	90                   	nop
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 01                	push   $0x1
  8025d0:	e8 98 ff ff ff       	call   80256d <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	52                   	push   %edx
  8025ea:	50                   	push   %eax
  8025eb:	6a 05                	push   $0x5
  8025ed:	e8 7b ff ff ff       	call   80256d <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8025ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802602:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802605:	8b 55 0c             	mov    0xc(%ebp),%edx
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	56                   	push   %esi
  80260c:	53                   	push   %ebx
  80260d:	51                   	push   %ecx
  80260e:	52                   	push   %edx
  80260f:	50                   	push   %eax
  802610:	6a 06                	push   $0x6
  802612:	e8 56 ff ff ff       	call   80256d <syscall>
  802617:	83 c4 18             	add    $0x18,%esp
}
  80261a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    

00802621 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802624:	8b 55 0c             	mov    0xc(%ebp),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	52                   	push   %edx
  802631:	50                   	push   %eax
  802632:	6a 07                	push   $0x7
  802634:	e8 34 ff ff ff       	call   80256d <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	ff 75 0c             	pushl  0xc(%ebp)
  80264a:	ff 75 08             	pushl  0x8(%ebp)
  80264d:	6a 08                	push   $0x8
  80264f:	e8 19 ff ff ff       	call   80256d <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 09                	push   $0x9
  802668:	e8 00 ff ff ff       	call   80256d <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 0a                	push   $0xa
  802681:	e8 e7 fe ff ff       	call   80256d <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 0b                	push   $0xb
  80269a:	e8 ce fe ff ff       	call   80256d <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	ff 75 0c             	pushl  0xc(%ebp)
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	6a 0f                	push   $0xf
  8026b5:	e8 b3 fe ff ff       	call   80256d <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
	return;
  8026bd:	90                   	nop
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	ff 75 0c             	pushl  0xc(%ebp)
  8026cc:	ff 75 08             	pushl  0x8(%ebp)
  8026cf:	6a 10                	push   $0x10
  8026d1:	e8 97 fe ff ff       	call   80256d <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d9:	90                   	nop
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	ff 75 10             	pushl  0x10(%ebp)
  8026e6:	ff 75 0c             	pushl  0xc(%ebp)
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	6a 11                	push   $0x11
  8026ee:	e8 7a fe ff ff       	call   80256d <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f6:	90                   	nop
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 0c                	push   $0xc
  802708:	e8 60 fe ff ff       	call   80256d <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	ff 75 08             	pushl  0x8(%ebp)
  802720:	6a 0d                	push   $0xd
  802722:	e8 46 fe ff ff       	call   80256d <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 0e                	push   $0xe
  80273b:	e8 2d fe ff ff       	call   80256d <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	90                   	nop
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 13                	push   $0x13
  802755:	e8 13 fe ff ff       	call   80256d <syscall>
  80275a:	83 c4 18             	add    $0x18,%esp
}
  80275d:	90                   	nop
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 14                	push   $0x14
  80276f:	e8 f9 fd ff ff       	call   80256d <syscall>
  802774:	83 c4 18             	add    $0x18,%esp
}
  802777:	90                   	nop
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_cputc>:


void
sys_cputc(const char c)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 04             	sub    $0x4,%esp
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802786:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	50                   	push   %eax
  802793:	6a 15                	push   $0x15
  802795:	e8 d3 fd ff ff       	call   80256d <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
}
  80279d:	90                   	nop
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 16                	push   $0x16
  8027af:	e8 b9 fd ff ff       	call   80256d <syscall>
  8027b4:	83 c4 18             	add    $0x18,%esp
}
  8027b7:	90                   	nop
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	ff 75 0c             	pushl  0xc(%ebp)
  8027c9:	50                   	push   %eax
  8027ca:	6a 17                	push   $0x17
  8027cc:	e8 9c fd ff ff       	call   80256d <syscall>
  8027d1:	83 c4 18             	add    $0x18,%esp
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8027d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	52                   	push   %edx
  8027e6:	50                   	push   %eax
  8027e7:	6a 1a                	push   $0x1a
  8027e9:	e8 7f fd ff ff       	call   80256d <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8027f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	52                   	push   %edx
  802803:	50                   	push   %eax
  802804:	6a 18                	push   $0x18
  802806:	e8 62 fd ff ff       	call   80256d <syscall>
  80280b:	83 c4 18             	add    $0x18,%esp
}
  80280e:	90                   	nop
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802814:	8b 55 0c             	mov    0xc(%ebp),%edx
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	52                   	push   %edx
  802821:	50                   	push   %eax
  802822:	6a 19                	push   $0x19
  802824:	e8 44 fd ff ff       	call   80256d <syscall>
  802829:	83 c4 18             	add    $0x18,%esp
}
  80282c:	90                   	nop
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	8b 45 10             	mov    0x10(%ebp),%eax
  802838:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80283b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80283e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	6a 00                	push   $0x0
  802847:	51                   	push   %ecx
  802848:	52                   	push   %edx
  802849:	ff 75 0c             	pushl  0xc(%ebp)
  80284c:	50                   	push   %eax
  80284d:	6a 1b                	push   $0x1b
  80284f:	e8 19 fd ff ff       	call   80256d <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
}
  802857:	c9                   	leave  
  802858:	c3                   	ret    

00802859 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80285c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	52                   	push   %edx
  802869:	50                   	push   %eax
  80286a:	6a 1c                	push   $0x1c
  80286c:	e8 fc fc ff ff       	call   80256d <syscall>
  802871:	83 c4 18             	add    $0x18,%esp
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802879:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80287c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	51                   	push   %ecx
  802887:	52                   	push   %edx
  802888:	50                   	push   %eax
  802889:	6a 1d                	push   $0x1d
  80288b:	e8 dd fc ff ff       	call   80256d <syscall>
  802890:	83 c4 18             	add    $0x18,%esp
}
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	52                   	push   %edx
  8028a5:	50                   	push   %eax
  8028a6:	6a 1e                	push   $0x1e
  8028a8:	e8 c0 fc ff ff       	call   80256d <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

008028b2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 1f                	push   $0x1f
  8028c1:	e8 a7 fc ff ff       	call   80256d <syscall>
  8028c6:	83 c4 18             	add    $0x18,%esp
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	6a 00                	push   $0x0
  8028d3:	ff 75 14             	pushl  0x14(%ebp)
  8028d6:	ff 75 10             	pushl  0x10(%ebp)
  8028d9:	ff 75 0c             	pushl  0xc(%ebp)
  8028dc:	50                   	push   %eax
  8028dd:	6a 20                	push   $0x20
  8028df:	e8 89 fc ff ff       	call   80256d <syscall>
  8028e4:	83 c4 18             	add    $0x18,%esp
}
  8028e7:	c9                   	leave  
  8028e8:	c3                   	ret    

008028e9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	50                   	push   %eax
  8028f8:	6a 21                	push   $0x21
  8028fa:	e8 6e fc ff ff       	call   80256d <syscall>
  8028ff:	83 c4 18             	add    $0x18,%esp
}
  802902:	90                   	nop
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	50                   	push   %eax
  802914:	6a 22                	push   $0x22
  802916:	e8 52 fc ff ff       	call   80256d <syscall>
  80291b:	83 c4 18             	add    $0x18,%esp
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 02                	push   $0x2
  80292f:	e8 39 fc ff ff       	call   80256d <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 03                	push   $0x3
  802948:	e8 20 fc ff ff       	call   80256d <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 04                	push   $0x4
  802961:	e8 07 fc ff ff       	call   80256d <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <sys_exit_env>:


void sys_exit_env(void)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 23                	push   $0x23
  80297a:	e8 ee fb ff ff       	call   80256d <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
}
  802982:	90                   	nop
  802983:	c9                   	leave  
  802984:	c3                   	ret    

00802985 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80298b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80298e:	8d 50 04             	lea    0x4(%eax),%edx
  802991:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	52                   	push   %edx
  80299b:	50                   	push   %eax
  80299c:	6a 24                	push   $0x24
  80299e:	e8 ca fb ff ff       	call   80256d <syscall>
  8029a3:	83 c4 18             	add    $0x18,%esp
	return result;
  8029a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029af:	89 01                	mov    %eax,(%ecx)
  8029b1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	c9                   	leave  
  8029b8:	c2 04 00             	ret    $0x4

008029bb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	ff 75 10             	pushl  0x10(%ebp)
  8029c5:	ff 75 0c             	pushl  0xc(%ebp)
  8029c8:	ff 75 08             	pushl  0x8(%ebp)
  8029cb:	6a 12                	push   $0x12
  8029cd:	e8 9b fb ff ff       	call   80256d <syscall>
  8029d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d5:	90                   	nop
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 25                	push   $0x25
  8029e7:	e8 81 fb ff ff       	call   80256d <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029fd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	50                   	push   %eax
  802a0a:	6a 26                	push   $0x26
  802a0c:	e8 5c fb ff ff       	call   80256d <syscall>
  802a11:	83 c4 18             	add    $0x18,%esp
	return ;
  802a14:	90                   	nop
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <rsttst>:
void rsttst()
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 28                	push   $0x28
  802a26:	e8 42 fb ff ff       	call   80256d <syscall>
  802a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a2e:	90                   	nop
}
  802a2f:	c9                   	leave  
  802a30:	c3                   	ret    

00802a31 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	8b 45 14             	mov    0x14(%ebp),%eax
  802a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a3d:	8b 55 18             	mov    0x18(%ebp),%edx
  802a40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a44:	52                   	push   %edx
  802a45:	50                   	push   %eax
  802a46:	ff 75 10             	pushl  0x10(%ebp)
  802a49:	ff 75 0c             	pushl  0xc(%ebp)
  802a4c:	ff 75 08             	pushl  0x8(%ebp)
  802a4f:	6a 27                	push   $0x27
  802a51:	e8 17 fb ff ff       	call   80256d <syscall>
  802a56:	83 c4 18             	add    $0x18,%esp
	return ;
  802a59:	90                   	nop
}
  802a5a:	c9                   	leave  
  802a5b:	c3                   	ret    

00802a5c <chktst>:
void chktst(uint32 n)
{
  802a5c:	55                   	push   %ebp
  802a5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	ff 75 08             	pushl  0x8(%ebp)
  802a6a:	6a 29                	push   $0x29
  802a6c:	e8 fc fa ff ff       	call   80256d <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
	return ;
  802a74:	90                   	nop
}
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <inctst>:

void inctst()
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a7a:	6a 00                	push   $0x0
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 2a                	push   $0x2a
  802a86:	e8 e2 fa ff ff       	call   80256d <syscall>
  802a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a8e:	90                   	nop
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <gettst>:
uint32 gettst()
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 2b                	push   $0x2b
  802aa0:	e8 c8 fa ff ff       	call   80256d <syscall>
  802aa5:	83 c4 18             	add    $0x18,%esp
}
  802aa8:	c9                   	leave  
  802aa9:	c3                   	ret    

00802aaa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802aaa:	55                   	push   %ebp
  802aab:	89 e5                	mov    %esp,%ebp
  802aad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 2c                	push   $0x2c
  802abc:	e8 ac fa ff ff       	call   80256d <syscall>
  802ac1:	83 c4 18             	add    $0x18,%esp
  802ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ac7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802acb:	75 07                	jne    802ad4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802acd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad2:	eb 05                	jmp    802ad9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 2c                	push   $0x2c
  802aed:	e8 7b fa ff ff       	call   80256d <syscall>
  802af2:	83 c4 18             	add    $0x18,%esp
  802af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802af8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802afc:	75 07                	jne    802b05 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802afe:	b8 01 00 00 00       	mov    $0x1,%eax
  802b03:	eb 05                	jmp    802b0a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 2c                	push   $0x2c
  802b1e:	e8 4a fa ff ff       	call   80256d <syscall>
  802b23:	83 c4 18             	add    $0x18,%esp
  802b26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b29:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b2d:	75 07                	jne    802b36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b2f:	b8 01 00 00 00       	mov    $0x1,%eax
  802b34:	eb 05                	jmp    802b3b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3b:	c9                   	leave  
  802b3c:	c3                   	ret    

00802b3d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 2c                	push   $0x2c
  802b4f:	e8 19 fa ff ff       	call   80256d <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
  802b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b5a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b5e:	75 07                	jne    802b67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b60:	b8 01 00 00 00       	mov    $0x1,%eax
  802b65:	eb 05                	jmp    802b6c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	ff 75 08             	pushl  0x8(%ebp)
  802b7c:	6a 2d                	push   $0x2d
  802b7e:	e8 ea f9 ff ff       	call   80256d <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
	return ;
  802b86:	90                   	nop
}
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
  802b8c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	6a 00                	push   $0x0
  802b9b:	53                   	push   %ebx
  802b9c:	51                   	push   %ecx
  802b9d:	52                   	push   %edx
  802b9e:	50                   	push   %eax
  802b9f:	6a 2e                	push   $0x2e
  802ba1:	e8 c7 f9 ff ff       	call   80256d <syscall>
  802ba6:	83 c4 18             	add    $0x18,%esp
}
  802ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bac:	c9                   	leave  
  802bad:	c3                   	ret    

00802bae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	6a 00                	push   $0x0
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	52                   	push   %edx
  802bbe:	50                   	push   %eax
  802bbf:	6a 2f                	push   $0x2f
  802bc1:	e8 a7 f9 ff ff       	call   80256d <syscall>
  802bc6:	83 c4 18             	add    $0x18,%esp
}
  802bc9:	c9                   	leave  
  802bca:	c3                   	ret    

00802bcb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802bcb:	55                   	push   %ebp
  802bcc:	89 e5                	mov    %esp,%ebp
  802bce:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802bd1:	83 ec 0c             	sub    $0xc,%esp
  802bd4:	68 60 47 80 00       	push   $0x804760
  802bd9:	e8 3e e6 ff ff       	call   80121c <cprintf>
  802bde:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802be1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802be8:	83 ec 0c             	sub    $0xc,%esp
  802beb:	68 8c 47 80 00       	push   $0x80478c
  802bf0:	e8 27 e6 ff ff       	call   80121c <cprintf>
  802bf5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802bf8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bfc:	a1 38 51 80 00       	mov    0x805138,%eax
  802c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c04:	eb 56                	jmp    802c5c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0a:	74 1c                	je     802c28 <print_mem_block_lists+0x5d>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 50 08             	mov    0x8(%eax),%edx
  802c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c15:	8b 48 08             	mov    0x8(%eax),%ecx
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	01 c8                	add    %ecx,%eax
  802c20:	39 c2                	cmp    %eax,%edx
  802c22:	73 04                	jae    802c28 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802c24:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 40 0c             	mov    0xc(%eax),%eax
  802c34:	01 c2                	add    %eax,%edx
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	52                   	push   %edx
  802c40:	50                   	push   %eax
  802c41:	68 a1 47 80 00       	push   $0x8047a1
  802c46:	e8 d1 e5 ff ff       	call   80121c <cprintf>
  802c4b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c54:	a1 40 51 80 00       	mov    0x805140,%eax
  802c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c60:	74 07                	je     802c69 <print_mem_block_lists+0x9e>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	eb 05                	jmp    802c6e <print_mem_block_lists+0xa3>
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c73:	a1 40 51 80 00       	mov    0x805140,%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	75 8a                	jne    802c06 <print_mem_block_lists+0x3b>
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	75 84                	jne    802c06 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802c82:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c86:	75 10                	jne    802c98 <print_mem_block_lists+0xcd>
  802c88:	83 ec 0c             	sub    $0xc,%esp
  802c8b:	68 b0 47 80 00       	push   $0x8047b0
  802c90:	e8 87 e5 ff ff       	call   80121c <cprintf>
  802c95:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802c98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802c9f:	83 ec 0c             	sub    $0xc,%esp
  802ca2:	68 d4 47 80 00       	push   $0x8047d4
  802ca7:	e8 70 e5 ff ff       	call   80121c <cprintf>
  802cac:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802caf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802cb3:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbb:	eb 56                	jmp    802d13 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802cbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc1:	74 1c                	je     802cdf <print_mem_block_lists+0x114>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 50 08             	mov    0x8(%eax),%edx
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 48 08             	mov    0x8(%eax),%ecx
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	01 c8                	add    %ecx,%eax
  802cd7:	39 c2                	cmp    %eax,%edx
  802cd9:	73 04                	jae    802cdf <print_mem_block_lists+0x114>
			sorted = 0 ;
  802cdb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 50 08             	mov    0x8(%eax),%edx
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 08             	mov    0x8(%eax),%eax
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	52                   	push   %edx
  802cf7:	50                   	push   %eax
  802cf8:	68 a1 47 80 00       	push   $0x8047a1
  802cfd:	e8 1a e5 ff ff       	call   80121c <cprintf>
  802d02:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802d0b:	a1 48 50 80 00       	mov    0x805048,%eax
  802d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d17:	74 07                	je     802d20 <print_mem_block_lists+0x155>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	eb 05                	jmp    802d25 <print_mem_block_lists+0x15a>
  802d20:	b8 00 00 00 00       	mov    $0x0,%eax
  802d25:	a3 48 50 80 00       	mov    %eax,0x805048
  802d2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	75 8a                	jne    802cbd <print_mem_block_lists+0xf2>
  802d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d37:	75 84                	jne    802cbd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802d39:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802d3d:	75 10                	jne    802d4f <print_mem_block_lists+0x184>
  802d3f:	83 ec 0c             	sub    $0xc,%esp
  802d42:	68 ec 47 80 00       	push   $0x8047ec
  802d47:	e8 d0 e4 ff ff       	call   80121c <cprintf>
  802d4c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802d4f:	83 ec 0c             	sub    $0xc,%esp
  802d52:	68 60 47 80 00       	push   $0x804760
  802d57:	e8 c0 e4 ff ff       	call   80121c <cprintf>
  802d5c:	83 c4 10             	add    $0x10,%esp

}
  802d5f:	90                   	nop
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
  802d65:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802d68:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802d6f:	00 00 00 
  802d72:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802d79:	00 00 00 
  802d7c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802d83:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802d86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d8d:	e9 9e 00 00 00       	jmp    802e30 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802d92:	a1 50 50 80 00       	mov    0x805050,%eax
  802d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9a:	c1 e2 04             	shl    $0x4,%edx
  802d9d:	01 d0                	add    %edx,%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	75 14                	jne    802db7 <initialize_MemBlocksList+0x55>
  802da3:	83 ec 04             	sub    $0x4,%esp
  802da6:	68 14 48 80 00       	push   $0x804814
  802dab:	6a 3d                	push   $0x3d
  802dad:	68 37 48 80 00       	push   $0x804837
  802db2:	e8 b1 e1 ff ff       	call   800f68 <_panic>
  802db7:	a1 50 50 80 00       	mov    0x805050,%eax
  802dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbf:	c1 e2 04             	shl    $0x4,%edx
  802dc2:	01 d0                	add    %edx,%eax
  802dc4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dca:	89 10                	mov    %edx,(%eax)
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 18                	je     802dea <initialize_MemBlocksList+0x88>
  802dd2:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802ddd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802de0:	c1 e1 04             	shl    $0x4,%ecx
  802de3:	01 ca                	add    %ecx,%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 12                	jmp    802dfc <initialize_MemBlocksList+0x9a>
  802dea:	a1 50 50 80 00       	mov    0x805050,%eax
  802def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df2:	c1 e2 04             	shl    $0x4,%edx
  802df5:	01 d0                	add    %edx,%eax
  802df7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfc:	a1 50 50 80 00       	mov    0x805050,%eax
  802e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e04:	c1 e2 04             	shl    $0x4,%edx
  802e07:	01 d0                	add    %edx,%eax
  802e09:	a3 48 51 80 00       	mov    %eax,0x805148
  802e0e:	a1 50 50 80 00       	mov    0x805050,%eax
  802e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e16:	c1 e2 04             	shl    $0x4,%edx
  802e19:	01 d0                	add    %edx,%eax
  802e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e22:	a1 54 51 80 00       	mov    0x805154,%eax
  802e27:	40                   	inc    %eax
  802e28:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802e2d:	ff 45 f4             	incl   -0xc(%ebp)
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e36:	0f 82 56 ff ff ff    	jb     802d92 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802e3c:	90                   	nop
  802e3d:	c9                   	leave  
  802e3e:	c3                   	ret    

00802e3f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802e4d:	eb 18                	jmp    802e67 <find_block+0x28>

		if(tmp->sva == va){
  802e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e58:	75 05                	jne    802e5f <find_block+0x20>
			return tmp ;
  802e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e5d:	eb 11                	jmp    802e70 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802e6b:	75 e2                	jne    802e4f <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    

00802e72 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802e72:	55                   	push   %ebp
  802e73:	89 e5                	mov    %esp,%ebp
  802e75:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802e78:	a1 40 50 80 00       	mov    0x805040,%eax
  802e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802e80:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e85:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802e88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e8c:	75 65                	jne    802ef3 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802e8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e92:	75 14                	jne    802ea8 <insert_sorted_allocList+0x36>
  802e94:	83 ec 04             	sub    $0x4,%esp
  802e97:	68 14 48 80 00       	push   $0x804814
  802e9c:	6a 62                	push   $0x62
  802e9e:	68 37 48 80 00       	push   $0x804837
  802ea3:	e8 c0 e0 ff ff       	call   800f68 <_panic>
  802ea8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 00                	mov    (%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 0d                	je     802ec9 <insert_sorted_allocList+0x57>
  802ebc:	a1 40 50 80 00       	mov    0x805040,%eax
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 08                	jmp    802ed1 <insert_sorted_allocList+0x5f>
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	a3 44 50 80 00       	mov    %eax,0x805044
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 40 50 80 00       	mov    %eax,0x805040
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ee8:	40                   	inc    %eax
  802ee9:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802eee:	e9 14 01 00 00       	jmp    803007 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	a1 44 50 80 00       	mov    0x805044,%eax
  802efe:	8b 40 08             	mov    0x8(%eax),%eax
  802f01:	39 c2                	cmp    %eax,%edx
  802f03:	76 65                	jbe    802f6a <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802f05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f09:	75 14                	jne    802f1f <insert_sorted_allocList+0xad>
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	68 50 48 80 00       	push   $0x804850
  802f13:	6a 64                	push   $0x64
  802f15:	68 37 48 80 00       	push   $0x804837
  802f1a:	e8 49 e0 ff ff       	call   800f68 <_panic>
  802f1f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0c                	je     802f41 <insert_sorted_allocList+0xcf>
  802f35:	a1 44 50 80 00       	mov    0x805044,%eax
  802f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3d:	89 10                	mov    %edx,(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_allocList+0xd7>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 40 50 80 00       	mov    %eax,0x805040
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 44 50 80 00       	mov    %eax,0x805044
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802f65:	e9 9d 00 00 00       	jmp    803007 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802f6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f71:	e9 85 00 00 00       	jmp    802ffb <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8b 50 08             	mov    0x8(%eax),%edx
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 40 08             	mov    0x8(%eax),%eax
  802f82:	39 c2                	cmp    %eax,%edx
  802f84:	73 6a                	jae    802ff0 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802f86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8a:	74 06                	je     802f92 <insert_sorted_allocList+0x120>
  802f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f90:	75 14                	jne    802fa6 <insert_sorted_allocList+0x134>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 74 48 80 00       	push   $0x804874
  802f9a:	6a 6b                	push   $0x6b
  802f9c:	68 37 48 80 00       	push   $0x804837
  802fa1:	e8 c2 df ff ff       	call   800f68 <_panic>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 50 04             	mov    0x4(%eax),%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	89 50 04             	mov    %edx,0x4(%eax)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb8:	89 10                	mov    %edx,(%eax)
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 0d                	je     802fd1 <insert_sorted_allocList+0x15f>
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	eb 08                	jmp    802fd9 <insert_sorted_allocList+0x167>
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	a3 40 50 80 00       	mov    %eax,0x805040
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802fed:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802fee:	eb 17                	jmp    803007 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802ff8:	ff 45 f0             	incl   -0x10(%ebp)
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803001:	0f 8c 6f ff ff ff    	jl     802f76 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803007:	90                   	nop
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
  80300d:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  803010:	a1 38 51 80 00       	mov    0x805138,%eax
  803015:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  803018:	e9 7c 01 00 00       	jmp    803199 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	3b 45 08             	cmp    0x8(%ebp),%eax
  803026:	0f 86 cf 00 00 00    	jbe    8030fb <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80302c:	a1 48 51 80 00       	mov    0x805148,%eax
  803031:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80303a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303d:	8b 55 08             	mov    0x8(%ebp),%edx
  803040:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 50 08             	mov    0x8(%eax),%edx
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 40 0c             	mov    0xc(%eax),%eax
  803055:	2b 45 08             	sub    0x8(%ebp),%eax
  803058:	89 c2                	mov    %eax,%edx
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 50 08             	mov    0x8(%eax),%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803071:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803075:	75 17                	jne    80308e <alloc_block_FF+0x84>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 a9 48 80 00       	push   $0x8048a9
  80307f:	68 83 00 00 00       	push   $0x83
  803084:	68 37 48 80 00       	push   $0x804837
  803089:	e8 da de ff ff       	call   800f68 <_panic>
  80308e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	85 c0                	test   %eax,%eax
  803095:	74 10                	je     8030a7 <alloc_block_FF+0x9d>
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80309f:	8b 52 04             	mov    0x4(%edx),%edx
  8030a2:	89 50 04             	mov    %edx,0x4(%eax)
  8030a5:	eb 0b                	jmp    8030b2 <alloc_block_FF+0xa8>
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0f                	je     8030cb <alloc_block_FF+0xc1>
  8030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bf:	8b 40 04             	mov    0x4(%eax),%eax
  8030c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030c5:	8b 12                	mov    (%edx),%edx
  8030c7:	89 10                	mov    %edx,(%eax)
  8030c9:	eb 0a                	jmp    8030d5 <alloc_block_FF+0xcb>
  8030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ed:	48                   	dec    %eax
  8030ee:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	e9 ad 00 00 00       	jmp    8031a8 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803101:	3b 45 08             	cmp    0x8(%ebp),%eax
  803104:	0f 85 87 00 00 00    	jne    803191 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80310a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310e:	75 17                	jne    803127 <alloc_block_FF+0x11d>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 a9 48 80 00       	push   $0x8048a9
  803118:	68 87 00 00 00       	push   $0x87
  80311d:	68 37 48 80 00       	push   $0x804837
  803122:	e8 41 de ff ff       	call   800f68 <_panic>
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 10                	je     803140 <alloc_block_FF+0x136>
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803138:	8b 52 04             	mov    0x4(%edx),%edx
  80313b:	89 50 04             	mov    %edx,0x4(%eax)
  80313e:	eb 0b                	jmp    80314b <alloc_block_FF+0x141>
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 40 04             	mov    0x4(%eax),%eax
  803146:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 0f                	je     803164 <alloc_block_FF+0x15a>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315e:	8b 12                	mov    (%edx),%edx
  803160:	89 10                	mov    %edx,(%eax)
  803162:	eb 0a                	jmp    80316e <alloc_block_FF+0x164>
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	a3 38 51 80 00       	mov    %eax,0x805138
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803181:	a1 44 51 80 00       	mov    0x805144,%eax
  803186:	48                   	dec    %eax
  803187:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	eb 17                	jmp    8031a8 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  803199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319d:	0f 85 7a fe ff ff    	jne    80301d <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
  8031ad:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8031b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8031b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8031bf:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8031c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ce:	e9 d0 00 00 00       	jmp    8032a3 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031dc:	0f 82 b8 00 00 00    	jb     80329a <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8031eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8031ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8031f4:	0f 83 a1 00 00 00    	jae    80329b <alloc_block_BF+0xf1>
				differsize = differance ;
  8031fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  803206:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80320a:	0f 85 8b 00 00 00    	jne    80329b <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  803210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803214:	75 17                	jne    80322d <alloc_block_BF+0x83>
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	68 a9 48 80 00       	push   $0x8048a9
  80321e:	68 a0 00 00 00       	push   $0xa0
  803223:	68 37 48 80 00       	push   $0x804837
  803228:	e8 3b dd ff ff       	call   800f68 <_panic>
  80322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 10                	je     803246 <alloc_block_BF+0x9c>
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	8b 52 04             	mov    0x4(%edx),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 0b                	jmp    803251 <alloc_block_BF+0xa7>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 40 04             	mov    0x4(%eax),%eax
  80324c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 40 04             	mov    0x4(%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0f                	je     80326a <alloc_block_BF+0xc0>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 40 04             	mov    0x4(%eax),%eax
  803261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803264:	8b 12                	mov    (%edx),%edx
  803266:	89 10                	mov    %edx,(%eax)
  803268:	eb 0a                	jmp    803274 <alloc_block_BF+0xca>
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	a3 38 51 80 00       	mov    %eax,0x805138
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 44 51 80 00       	mov    0x805144,%eax
  80328c:	48                   	dec    %eax
  80328d:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	e9 0c 01 00 00       	jmp    8033a6 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80329a:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80329b:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a7:	74 07                	je     8032b0 <alloc_block_BF+0x106>
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	eb 05                	jmp    8032b5 <alloc_block_BF+0x10b>
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	0f 85 0c ff ff ff    	jne    8031d3 <alloc_block_BF+0x29>
  8032c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cb:	0f 85 02 ff ff ff    	jne    8031d3 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8032d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d5:	0f 84 c6 00 00 00    	je     8033a1 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8032db:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8032e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	8b 50 08             	mov    0x8(%eax),%edx
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8032f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fe:	2b 45 08             	sub    0x8(%ebp),%eax
  803301:	89 c2                	mov    %eax,%edx
  803303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803306:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	8b 50 08             	mov    0x8(%eax),%edx
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	01 c2                	add    %eax,%edx
  803314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803317:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80331a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80331e:	75 17                	jne    803337 <alloc_block_BF+0x18d>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 a9 48 80 00       	push   $0x8048a9
  803328:	68 af 00 00 00       	push   $0xaf
  80332d:	68 37 48 80 00       	push   $0x804837
  803332:	e8 31 dc ff ff       	call   800f68 <_panic>
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 10                	je     803350 <alloc_block_BF+0x1a6>
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803348:	8b 52 04             	mov    0x4(%edx),%edx
  80334b:	89 50 04             	mov    %edx,0x4(%eax)
  80334e:	eb 0b                	jmp    80335b <alloc_block_BF+0x1b1>
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0f                	je     803374 <alloc_block_BF+0x1ca>
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336e:	8b 12                	mov    (%edx),%edx
  803370:	89 10                	mov    %edx,(%eax)
  803372:	eb 0a                	jmp    80337e <alloc_block_BF+0x1d4>
  803374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	a3 48 51 80 00       	mov    %eax,0x805148
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803391:	a1 54 51 80 00       	mov    0x805154,%eax
  803396:	48                   	dec    %eax
  803397:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	eb 05                	jmp    8033a6 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8033a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033a6:	c9                   	leave  
  8033a7:	c3                   	ret    

008033a8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8033a8:	55                   	push   %ebp
  8033a9:	89 e5                	mov    %esp,%ebp
  8033ab:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8033ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8033b6:	e9 7c 01 00 00       	jmp    803537 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c4:	0f 86 cf 00 00 00    	jbe    803499 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8033ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8033cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8033d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8033d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033db:	8b 55 08             	mov    0x8(%ebp),%edx
  8033de:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	8b 50 08             	mov    0x8(%eax),%edx
  8033e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ea:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8033f6:	89 c2                	mov    %eax,%edx
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	8b 50 08             	mov    0x8(%eax),%edx
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	01 c2                	add    %eax,%edx
  803409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340c:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80340f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803413:	75 17                	jne    80342c <alloc_block_NF+0x84>
  803415:	83 ec 04             	sub    $0x4,%esp
  803418:	68 a9 48 80 00       	push   $0x8048a9
  80341d:	68 c4 00 00 00       	push   $0xc4
  803422:	68 37 48 80 00       	push   $0x804837
  803427:	e8 3c db ff ff       	call   800f68 <_panic>
  80342c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 10                	je     803445 <alloc_block_NF+0x9d>
  803435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80343d:	8b 52 04             	mov    0x4(%edx),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 0b                	jmp    803450 <alloc_block_NF+0xa8>
  803445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	8b 40 04             	mov    0x4(%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 0f                	je     803469 <alloc_block_NF+0xc1>
  80345a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803463:	8b 12                	mov    (%edx),%edx
  803465:	89 10                	mov    %edx,(%eax)
  803467:	eb 0a                	jmp    803473 <alloc_block_NF+0xcb>
  803469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	a3 48 51 80 00       	mov    %eax,0x805148
  803473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803486:	a1 54 51 80 00       	mov    0x805154,%eax
  80348b:	48                   	dec    %eax
  80348c:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  803491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803494:	e9 ad 00 00 00       	jmp    803546 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 40 0c             	mov    0xc(%eax),%eax
  80349f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a2:	0f 85 87 00 00 00    	jne    80352f <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8034a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ac:	75 17                	jne    8034c5 <alloc_block_NF+0x11d>
  8034ae:	83 ec 04             	sub    $0x4,%esp
  8034b1:	68 a9 48 80 00       	push   $0x8048a9
  8034b6:	68 c8 00 00 00       	push   $0xc8
  8034bb:	68 37 48 80 00       	push   $0x804837
  8034c0:	e8 a3 da ff ff       	call   800f68 <_panic>
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 10                	je     8034de <alloc_block_NF+0x136>
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d6:	8b 52 04             	mov    0x4(%edx),%edx
  8034d9:	89 50 04             	mov    %edx,0x4(%eax)
  8034dc:	eb 0b                	jmp    8034e9 <alloc_block_NF+0x141>
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	8b 40 04             	mov    0x4(%eax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	74 0f                	je     803502 <alloc_block_NF+0x15a>
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 40 04             	mov    0x4(%eax),%eax
  8034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fc:	8b 12                	mov    (%edx),%edx
  8034fe:	89 10                	mov    %edx,(%eax)
  803500:	eb 0a                	jmp    80350c <alloc_block_NF+0x164>
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	a3 38 51 80 00       	mov    %eax,0x805138
  80350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351f:	a1 44 51 80 00       	mov    0x805144,%eax
  803524:	48                   	dec    %eax
  803525:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	eb 17                	jmp    803546 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353b:	0f 85 7a fe ff ff    	jne    8033bb <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803541:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803546:	c9                   	leave  
  803547:	c3                   	ret    

00803548 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803548:	55                   	push   %ebp
  803549:	89 e5                	mov    %esp,%ebp
  80354b:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80354e:	a1 38 51 80 00       	mov    0x805138,%eax
  803553:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803556:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80355b:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80355e:	a1 44 51 80 00       	mov    0x805144,%eax
  803563:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803566:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80356a:	75 68                	jne    8035d4 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80356c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803570:	75 17                	jne    803589 <insert_sorted_with_merge_freeList+0x41>
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	68 14 48 80 00       	push   $0x804814
  80357a:	68 da 00 00 00       	push   $0xda
  80357f:	68 37 48 80 00       	push   $0x804837
  803584:	e8 df d9 ff ff       	call   800f68 <_panic>
  803589:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	89 10                	mov    %edx,(%eax)
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 0d                	je     8035aa <insert_sorted_with_merge_freeList+0x62>
  80359d:	a1 38 51 80 00       	mov    0x805138,%eax
  8035a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a5:	89 50 04             	mov    %edx,0x4(%eax)
  8035a8:	eb 08                	jmp    8035b2 <insert_sorted_with_merge_freeList+0x6a>
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c9:	40                   	inc    %eax
  8035ca:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  8035cf:	e9 49 07 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d7:	8b 50 08             	mov    0x8(%eax),%edx
  8035da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e0:	01 c2                	add    %eax,%edx
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	8b 40 08             	mov    0x8(%eax),%eax
  8035e8:	39 c2                	cmp    %eax,%edx
  8035ea:	73 77                	jae    803663 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	75 6e                	jne    803663 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035f9:	74 68                	je     803663 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8035fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ff:	75 17                	jne    803618 <insert_sorted_with_merge_freeList+0xd0>
  803601:	83 ec 04             	sub    $0x4,%esp
  803604:	68 50 48 80 00       	push   $0x804850
  803609:	68 e0 00 00 00       	push   $0xe0
  80360e:	68 37 48 80 00       	push   $0x804837
  803613:	e8 50 d9 ff ff       	call   800f68 <_panic>
  803618:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	89 50 04             	mov    %edx,0x4(%eax)
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	8b 40 04             	mov    0x4(%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 0c                	je     80363a <insert_sorted_with_merge_freeList+0xf2>
  80362e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803633:	8b 55 08             	mov    0x8(%ebp),%edx
  803636:	89 10                	mov    %edx,(%eax)
  803638:	eb 08                	jmp    803642 <insert_sorted_with_merge_freeList+0xfa>
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	a3 38 51 80 00       	mov    %eax,0x805138
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803653:	a1 44 51 80 00       	mov    0x805144,%eax
  803658:	40                   	inc    %eax
  803659:	a3 44 51 80 00       	mov    %eax,0x805144
  80365e:	e9 ba 06 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	8b 50 0c             	mov    0xc(%eax),%edx
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	8b 40 08             	mov    0x8(%eax),%eax
  80366f:	01 c2                	add    %eax,%edx
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	8b 40 08             	mov    0x8(%eax),%eax
  803677:	39 c2                	cmp    %eax,%edx
  803679:	73 78                	jae    8036f3 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	8b 40 04             	mov    0x4(%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	75 6e                	jne    8036f3 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803685:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803689:	74 68                	je     8036f3 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80368b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368f:	75 17                	jne    8036a8 <insert_sorted_with_merge_freeList+0x160>
  803691:	83 ec 04             	sub    $0x4,%esp
  803694:	68 14 48 80 00       	push   $0x804814
  803699:	68 e6 00 00 00       	push   $0xe6
  80369e:	68 37 48 80 00       	push   $0x804837
  8036a3:	e8 c0 d8 ff ff       	call   800f68 <_panic>
  8036a8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	89 10                	mov    %edx,(%eax)
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	74 0d                	je     8036c9 <insert_sorted_with_merge_freeList+0x181>
  8036bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8036c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c4:	89 50 04             	mov    %edx,0x4(%eax)
  8036c7:	eb 08                	jmp    8036d1 <insert_sorted_with_merge_freeList+0x189>
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8036e8:	40                   	inc    %eax
  8036e9:	a3 44 51 80 00       	mov    %eax,0x805144
  8036ee:	e9 2a 06 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8036f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036fb:	e9 ed 05 00 00       	jmp    803ced <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803708:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80370c:	0f 84 a7 00 00 00    	je     8037b9 <insert_sorted_with_merge_freeList+0x271>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 50 0c             	mov    0xc(%eax),%edx
  803718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371b:	8b 40 08             	mov    0x8(%eax),%eax
  80371e:	01 c2                	add    %eax,%edx
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	8b 40 08             	mov    0x8(%eax),%eax
  803726:	39 c2                	cmp    %eax,%edx
  803728:	0f 83 8b 00 00 00    	jae    8037b9 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	8b 50 0c             	mov    0xc(%eax),%edx
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	8b 40 08             	mov    0x8(%eax),%eax
  80373a:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80373c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373f:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803742:	39 c2                	cmp    %eax,%edx
  803744:	73 73                	jae    8037b9 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374a:	74 06                	je     803752 <insert_sorted_with_merge_freeList+0x20a>
  80374c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803750:	75 17                	jne    803769 <insert_sorted_with_merge_freeList+0x221>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 c8 48 80 00       	push   $0x8048c8
  80375a:	68 f0 00 00 00       	push   $0xf0
  80375f:	68 37 48 80 00       	push   $0x804837
  803764:	e8 ff d7 ff ff       	call   800f68 <_panic>
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	8b 10                	mov    (%eax),%edx
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	89 10                	mov    %edx,(%eax)
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 0b                	je     803787 <insert_sorted_with_merge_freeList+0x23f>
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	8b 55 08             	mov    0x8(%ebp),%edx
  803784:	89 50 04             	mov    %edx,0x4(%eax)
  803787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378a:	8b 55 08             	mov    0x8(%ebp),%edx
  80378d:	89 10                	mov    %edx,(%eax)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803795:	89 50 04             	mov    %edx,0x4(%eax)
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	75 08                	jne    8037a9 <insert_sorted_with_merge_freeList+0x261>
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ae:	40                   	inc    %eax
  8037af:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8037b4:	e9 64 05 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8037b9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037be:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037c6:	8b 40 08             	mov    0x8(%eax),%eax
  8037c9:	01 c2                	add    %eax,%edx
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	8b 40 08             	mov    0x8(%eax),%eax
  8037d1:	39 c2                	cmp    %eax,%edx
  8037d3:	0f 85 b1 00 00 00    	jne    80388a <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  8037d9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	0f 84 a4 00 00 00    	je     80388a <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  8037e6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	85 c0                	test   %eax,%eax
  8037ef:	0f 85 95 00 00 00    	jne    80388a <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  8037f5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037fa:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803800:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803803:	8b 55 08             	mov    0x8(%ebp),%edx
  803806:	8b 52 0c             	mov    0xc(%edx),%edx
  803809:	01 ca                	add    %ecx,%edx
  80380b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80380e:	8b 45 08             	mov    0x8(%ebp),%eax
  803811:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803822:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803826:	75 17                	jne    80383f <insert_sorted_with_merge_freeList+0x2f7>
  803828:	83 ec 04             	sub    $0x4,%esp
  80382b:	68 14 48 80 00       	push   $0x804814
  803830:	68 ff 00 00 00       	push   $0xff
  803835:	68 37 48 80 00       	push   $0x804837
  80383a:	e8 29 d7 ff ff       	call   800f68 <_panic>
  80383f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	89 10                	mov    %edx,(%eax)
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	74 0d                	je     803860 <insert_sorted_with_merge_freeList+0x318>
  803853:	a1 48 51 80 00       	mov    0x805148,%eax
  803858:	8b 55 08             	mov    0x8(%ebp),%edx
  80385b:	89 50 04             	mov    %edx,0x4(%eax)
  80385e:	eb 08                	jmp    803868 <insert_sorted_with_merge_freeList+0x320>
  803860:	8b 45 08             	mov    0x8(%ebp),%eax
  803863:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803868:	8b 45 08             	mov    0x8(%ebp),%eax
  80386b:	a3 48 51 80 00       	mov    %eax,0x805148
  803870:	8b 45 08             	mov    0x8(%ebp),%eax
  803873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387a:	a1 54 51 80 00       	mov    0x805154,%eax
  80387f:	40                   	inc    %eax
  803880:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803885:	e9 93 04 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  80388a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388d:	8b 50 08             	mov    0x8(%eax),%edx
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 40 0c             	mov    0xc(%eax),%eax
  803896:	01 c2                	add    %eax,%edx
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	8b 40 08             	mov    0x8(%eax),%eax
  80389e:	39 c2                	cmp    %eax,%edx
  8038a0:	0f 85 ae 00 00 00    	jne    803954 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	8b 40 08             	mov    0x8(%eax),%eax
  8038b2:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8038bc:	39 c2                	cmp    %eax,%edx
  8038be:	0f 84 90 00 00 00    	je     803954 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d0:	01 c2                	add    %eax,%edx
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8038e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8038ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f0:	75 17                	jne    803909 <insert_sorted_with_merge_freeList+0x3c1>
  8038f2:	83 ec 04             	sub    $0x4,%esp
  8038f5:	68 14 48 80 00       	push   $0x804814
  8038fa:	68 0b 01 00 00       	push   $0x10b
  8038ff:	68 37 48 80 00       	push   $0x804837
  803904:	e8 5f d6 ff ff       	call   800f68 <_panic>
  803909:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
  803912:	89 10                	mov    %edx,(%eax)
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	8b 00                	mov    (%eax),%eax
  803919:	85 c0                	test   %eax,%eax
  80391b:	74 0d                	je     80392a <insert_sorted_with_merge_freeList+0x3e2>
  80391d:	a1 48 51 80 00       	mov    0x805148,%eax
  803922:	8b 55 08             	mov    0x8(%ebp),%edx
  803925:	89 50 04             	mov    %edx,0x4(%eax)
  803928:	eb 08                	jmp    803932 <insert_sorted_with_merge_freeList+0x3ea>
  80392a:	8b 45 08             	mov    0x8(%ebp),%eax
  80392d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
  803935:	a3 48 51 80 00       	mov    %eax,0x805148
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803944:	a1 54 51 80 00       	mov    0x805154,%eax
  803949:	40                   	inc    %eax
  80394a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80394f:	e9 c9 03 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	8b 50 0c             	mov    0xc(%eax),%edx
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	8b 40 08             	mov    0x8(%eax),%eax
  803960:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803968:	39 c2                	cmp    %eax,%edx
  80396a:	0f 85 bb 00 00 00    	jne    803a2b <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803974:	0f 84 b1 00 00 00    	je     803a2b <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  80397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	85 c0                	test   %eax,%eax
  803982:	0f 85 a3 00 00 00    	jne    803a2b <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803988:	a1 38 51 80 00       	mov    0x805138,%eax
  80398d:	8b 55 08             	mov    0x8(%ebp),%edx
  803990:	8b 52 08             	mov    0x8(%edx),%edx
  803993:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803996:	a1 38 51 80 00       	mov    0x805138,%eax
  80399b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8039a1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8039a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a7:	8b 52 0c             	mov    0xc(%edx),%edx
  8039aa:	01 ca                	add    %ecx,%edx
  8039ac:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8039af:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8039c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039c7:	75 17                	jne    8039e0 <insert_sorted_with_merge_freeList+0x498>
  8039c9:	83 ec 04             	sub    $0x4,%esp
  8039cc:	68 14 48 80 00       	push   $0x804814
  8039d1:	68 17 01 00 00       	push   $0x117
  8039d6:	68 37 48 80 00       	push   $0x804837
  8039db:	e8 88 d5 ff ff       	call   800f68 <_panic>
  8039e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e9:	89 10                	mov    %edx,(%eax)
  8039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	74 0d                	je     803a01 <insert_sorted_with_merge_freeList+0x4b9>
  8039f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8039f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039fc:	89 50 04             	mov    %edx,0x4(%eax)
  8039ff:	eb 08                	jmp    803a09 <insert_sorted_with_merge_freeList+0x4c1>
  803a01:	8b 45 08             	mov    0x8(%ebp),%eax
  803a04:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a09:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a11:	8b 45 08             	mov    0x8(%ebp),%eax
  803a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a1b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a20:	40                   	inc    %eax
  803a21:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803a26:	e9 f2 02 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	8b 50 08             	mov    0x8(%eax),%edx
  803a31:	8b 45 08             	mov    0x8(%ebp),%eax
  803a34:	8b 40 0c             	mov    0xc(%eax),%eax
  803a37:	01 c2                	add    %eax,%edx
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	8b 40 08             	mov    0x8(%eax),%eax
  803a3f:	39 c2                	cmp    %eax,%edx
  803a41:	0f 85 be 00 00 00    	jne    803b05 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	8b 50 08             	mov    0x8(%eax),%edx
  803a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a53:	8b 40 04             	mov    0x4(%eax),%eax
  803a56:	8b 40 0c             	mov    0xc(%eax),%eax
  803a59:	01 c2                	add    %eax,%edx
  803a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5e:	8b 40 08             	mov    0x8(%eax),%eax
  803a61:	39 c2                	cmp    %eax,%edx
  803a63:	0f 84 9c 00 00 00    	je     803b05 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803a69:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6c:	8b 50 08             	mov    0x8(%eax),%edx
  803a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a72:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a78:	8b 50 0c             	mov    0xc(%eax),%edx
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  803a81:	01 c2                	add    %eax,%edx
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803a89:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803a93:	8b 45 08             	mov    0x8(%ebp),%eax
  803a96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803a9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aa1:	75 17                	jne    803aba <insert_sorted_with_merge_freeList+0x572>
  803aa3:	83 ec 04             	sub    $0x4,%esp
  803aa6:	68 14 48 80 00       	push   $0x804814
  803aab:	68 26 01 00 00       	push   $0x126
  803ab0:	68 37 48 80 00       	push   $0x804837
  803ab5:	e8 ae d4 ff ff       	call   800f68 <_panic>
  803aba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac3:	89 10                	mov    %edx,(%eax)
  803ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac8:	8b 00                	mov    (%eax),%eax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	74 0d                	je     803adb <insert_sorted_with_merge_freeList+0x593>
  803ace:	a1 48 51 80 00       	mov    0x805148,%eax
  803ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad6:	89 50 04             	mov    %edx,0x4(%eax)
  803ad9:	eb 08                	jmp    803ae3 <insert_sorted_with_merge_freeList+0x59b>
  803adb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ade:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae6:	a3 48 51 80 00       	mov    %eax,0x805148
  803aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af5:	a1 54 51 80 00       	mov    0x805154,%eax
  803afa:	40                   	inc    %eax
  803afb:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803b00:	e9 18 02 00 00       	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b08:	8b 50 0c             	mov    0xc(%eax),%edx
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	8b 40 08             	mov    0x8(%eax),%eax
  803b11:	01 c2                	add    %eax,%edx
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	8b 40 08             	mov    0x8(%eax),%eax
  803b19:	39 c2                	cmp    %eax,%edx
  803b1b:	0f 85 c4 01 00 00    	jne    803ce5 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803b21:	8b 45 08             	mov    0x8(%ebp),%eax
  803b24:	8b 50 0c             	mov    0xc(%eax),%edx
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	8b 40 08             	mov    0x8(%eax),%eax
  803b2d:	01 c2                	add    %eax,%edx
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	8b 40 08             	mov    0x8(%eax),%eax
  803b37:	39 c2                	cmp    %eax,%edx
  803b39:	0f 85 a6 01 00 00    	jne    803ce5 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b43:	0f 84 9c 01 00 00    	je     803ce5 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4c:	8b 50 0c             	mov    0xc(%eax),%edx
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 40 0c             	mov    0xc(%eax),%eax
  803b55:	01 c2                	add    %eax,%edx
  803b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5a:	8b 00                	mov    (%eax),%eax
  803b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b5f:	01 c2                	add    %eax,%edx
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803b67:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803b7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b7f:	75 17                	jne    803b98 <insert_sorted_with_merge_freeList+0x650>
  803b81:	83 ec 04             	sub    $0x4,%esp
  803b84:	68 14 48 80 00       	push   $0x804814
  803b89:	68 32 01 00 00       	push   $0x132
  803b8e:	68 37 48 80 00       	push   $0x804837
  803b93:	e8 d0 d3 ff ff       	call   800f68 <_panic>
  803b98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba1:	89 10                	mov    %edx,(%eax)
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	85 c0                	test   %eax,%eax
  803baa:	74 0d                	je     803bb9 <insert_sorted_with_merge_freeList+0x671>
  803bac:	a1 48 51 80 00       	mov    0x805148,%eax
  803bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bb4:	89 50 04             	mov    %edx,0x4(%eax)
  803bb7:	eb 08                	jmp    803bc1 <insert_sorted_with_merge_freeList+0x679>
  803bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc4:	a3 48 51 80 00       	mov    %eax,0x805148
  803bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd3:	a1 54 51 80 00       	mov    0x805154,%eax
  803bd8:	40                   	inc    %eax
  803bd9:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be1:	8b 00                	mov    (%eax),%eax
  803be3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bed:	8b 00                	mov    (%eax),%eax
  803bef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf9:	8b 00                	mov    (%eax),%eax
  803bfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803bfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c02:	75 17                	jne    803c1b <insert_sorted_with_merge_freeList+0x6d3>
  803c04:	83 ec 04             	sub    $0x4,%esp
  803c07:	68 a9 48 80 00       	push   $0x8048a9
  803c0c:	68 36 01 00 00       	push   $0x136
  803c11:	68 37 48 80 00       	push   $0x804837
  803c16:	e8 4d d3 ff ff       	call   800f68 <_panic>
  803c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1e:	8b 00                	mov    (%eax),%eax
  803c20:	85 c0                	test   %eax,%eax
  803c22:	74 10                	je     803c34 <insert_sorted_with_merge_freeList+0x6ec>
  803c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c27:	8b 00                	mov    (%eax),%eax
  803c29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c2c:	8b 52 04             	mov    0x4(%edx),%edx
  803c2f:	89 50 04             	mov    %edx,0x4(%eax)
  803c32:	eb 0b                	jmp    803c3f <insert_sorted_with_merge_freeList+0x6f7>
  803c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c37:	8b 40 04             	mov    0x4(%eax),%eax
  803c3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c42:	8b 40 04             	mov    0x4(%eax),%eax
  803c45:	85 c0                	test   %eax,%eax
  803c47:	74 0f                	je     803c58 <insert_sorted_with_merge_freeList+0x710>
  803c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4c:	8b 40 04             	mov    0x4(%eax),%eax
  803c4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c52:	8b 12                	mov    (%edx),%edx
  803c54:	89 10                	mov    %edx,(%eax)
  803c56:	eb 0a                	jmp    803c62 <insert_sorted_with_merge_freeList+0x71a>
  803c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5b:	8b 00                	mov    (%eax),%eax
  803c5d:	a3 38 51 80 00       	mov    %eax,0x805138
  803c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c75:	a1 44 51 80 00       	mov    0x805144,%eax
  803c7a:	48                   	dec    %eax
  803c7b:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803c80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c84:	75 17                	jne    803c9d <insert_sorted_with_merge_freeList+0x755>
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	68 14 48 80 00       	push   $0x804814
  803c8e:	68 37 01 00 00       	push   $0x137
  803c93:	68 37 48 80 00       	push   $0x804837
  803c98:	e8 cb d2 ff ff       	call   800f68 <_panic>
  803c9d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca6:	89 10                	mov    %edx,(%eax)
  803ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cab:	8b 00                	mov    (%eax),%eax
  803cad:	85 c0                	test   %eax,%eax
  803caf:	74 0d                	je     803cbe <insert_sorted_with_merge_freeList+0x776>
  803cb1:	a1 48 51 80 00       	mov    0x805148,%eax
  803cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cb9:	89 50 04             	mov    %edx,0x4(%eax)
  803cbc:	eb 08                	jmp    803cc6 <insert_sorted_with_merge_freeList+0x77e>
  803cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc9:	a3 48 51 80 00       	mov    %eax,0x805148
  803cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd8:	a1 54 51 80 00       	mov    0x805154,%eax
  803cdd:	40                   	inc    %eax
  803cde:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803ce3:	eb 38                	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803ce5:	a1 40 51 80 00       	mov    0x805140,%eax
  803cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf1:	74 07                	je     803cfa <insert_sorted_with_merge_freeList+0x7b2>
  803cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf6:	8b 00                	mov    (%eax),%eax
  803cf8:	eb 05                	jmp    803cff <insert_sorted_with_merge_freeList+0x7b7>
  803cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803cff:	a3 40 51 80 00       	mov    %eax,0x805140
  803d04:	a1 40 51 80 00       	mov    0x805140,%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	0f 85 ef f9 ff ff    	jne    803700 <insert_sorted_with_merge_freeList+0x1b8>
  803d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d15:	0f 85 e5 f9 ff ff    	jne    803700 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803d1b:	eb 00                	jmp    803d1d <insert_sorted_with_merge_freeList+0x7d5>
  803d1d:	90                   	nop
  803d1e:	c9                   	leave  
  803d1f:	c3                   	ret    

00803d20 <__udivdi3>:
  803d20:	55                   	push   %ebp
  803d21:	57                   	push   %edi
  803d22:	56                   	push   %esi
  803d23:	53                   	push   %ebx
  803d24:	83 ec 1c             	sub    $0x1c,%esp
  803d27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d37:	89 ca                	mov    %ecx,%edx
  803d39:	89 f8                	mov    %edi,%eax
  803d3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d3f:	85 f6                	test   %esi,%esi
  803d41:	75 2d                	jne    803d70 <__udivdi3+0x50>
  803d43:	39 cf                	cmp    %ecx,%edi
  803d45:	77 65                	ja     803dac <__udivdi3+0x8c>
  803d47:	89 fd                	mov    %edi,%ebp
  803d49:	85 ff                	test   %edi,%edi
  803d4b:	75 0b                	jne    803d58 <__udivdi3+0x38>
  803d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d52:	31 d2                	xor    %edx,%edx
  803d54:	f7 f7                	div    %edi
  803d56:	89 c5                	mov    %eax,%ebp
  803d58:	31 d2                	xor    %edx,%edx
  803d5a:	89 c8                	mov    %ecx,%eax
  803d5c:	f7 f5                	div    %ebp
  803d5e:	89 c1                	mov    %eax,%ecx
  803d60:	89 d8                	mov    %ebx,%eax
  803d62:	f7 f5                	div    %ebp
  803d64:	89 cf                	mov    %ecx,%edi
  803d66:	89 fa                	mov    %edi,%edx
  803d68:	83 c4 1c             	add    $0x1c,%esp
  803d6b:	5b                   	pop    %ebx
  803d6c:	5e                   	pop    %esi
  803d6d:	5f                   	pop    %edi
  803d6e:	5d                   	pop    %ebp
  803d6f:	c3                   	ret    
  803d70:	39 ce                	cmp    %ecx,%esi
  803d72:	77 28                	ja     803d9c <__udivdi3+0x7c>
  803d74:	0f bd fe             	bsr    %esi,%edi
  803d77:	83 f7 1f             	xor    $0x1f,%edi
  803d7a:	75 40                	jne    803dbc <__udivdi3+0x9c>
  803d7c:	39 ce                	cmp    %ecx,%esi
  803d7e:	72 0a                	jb     803d8a <__udivdi3+0x6a>
  803d80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d84:	0f 87 9e 00 00 00    	ja     803e28 <__udivdi3+0x108>
  803d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8f:	89 fa                	mov    %edi,%edx
  803d91:	83 c4 1c             	add    $0x1c,%esp
  803d94:	5b                   	pop    %ebx
  803d95:	5e                   	pop    %esi
  803d96:	5f                   	pop    %edi
  803d97:	5d                   	pop    %ebp
  803d98:	c3                   	ret    
  803d99:	8d 76 00             	lea    0x0(%esi),%esi
  803d9c:	31 ff                	xor    %edi,%edi
  803d9e:	31 c0                	xor    %eax,%eax
  803da0:	89 fa                	mov    %edi,%edx
  803da2:	83 c4 1c             	add    $0x1c,%esp
  803da5:	5b                   	pop    %ebx
  803da6:	5e                   	pop    %esi
  803da7:	5f                   	pop    %edi
  803da8:	5d                   	pop    %ebp
  803da9:	c3                   	ret    
  803daa:	66 90                	xchg   %ax,%ax
  803dac:	89 d8                	mov    %ebx,%eax
  803dae:	f7 f7                	div    %edi
  803db0:	31 ff                	xor    %edi,%edi
  803db2:	89 fa                	mov    %edi,%edx
  803db4:	83 c4 1c             	add    $0x1c,%esp
  803db7:	5b                   	pop    %ebx
  803db8:	5e                   	pop    %esi
  803db9:	5f                   	pop    %edi
  803dba:	5d                   	pop    %ebp
  803dbb:	c3                   	ret    
  803dbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dc1:	89 eb                	mov    %ebp,%ebx
  803dc3:	29 fb                	sub    %edi,%ebx
  803dc5:	89 f9                	mov    %edi,%ecx
  803dc7:	d3 e6                	shl    %cl,%esi
  803dc9:	89 c5                	mov    %eax,%ebp
  803dcb:	88 d9                	mov    %bl,%cl
  803dcd:	d3 ed                	shr    %cl,%ebp
  803dcf:	89 e9                	mov    %ebp,%ecx
  803dd1:	09 f1                	or     %esi,%ecx
  803dd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dd7:	89 f9                	mov    %edi,%ecx
  803dd9:	d3 e0                	shl    %cl,%eax
  803ddb:	89 c5                	mov    %eax,%ebp
  803ddd:	89 d6                	mov    %edx,%esi
  803ddf:	88 d9                	mov    %bl,%cl
  803de1:	d3 ee                	shr    %cl,%esi
  803de3:	89 f9                	mov    %edi,%ecx
  803de5:	d3 e2                	shl    %cl,%edx
  803de7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803deb:	88 d9                	mov    %bl,%cl
  803ded:	d3 e8                	shr    %cl,%eax
  803def:	09 c2                	or     %eax,%edx
  803df1:	89 d0                	mov    %edx,%eax
  803df3:	89 f2                	mov    %esi,%edx
  803df5:	f7 74 24 0c          	divl   0xc(%esp)
  803df9:	89 d6                	mov    %edx,%esi
  803dfb:	89 c3                	mov    %eax,%ebx
  803dfd:	f7 e5                	mul    %ebp
  803dff:	39 d6                	cmp    %edx,%esi
  803e01:	72 19                	jb     803e1c <__udivdi3+0xfc>
  803e03:	74 0b                	je     803e10 <__udivdi3+0xf0>
  803e05:	89 d8                	mov    %ebx,%eax
  803e07:	31 ff                	xor    %edi,%edi
  803e09:	e9 58 ff ff ff       	jmp    803d66 <__udivdi3+0x46>
  803e0e:	66 90                	xchg   %ax,%ax
  803e10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e14:	89 f9                	mov    %edi,%ecx
  803e16:	d3 e2                	shl    %cl,%edx
  803e18:	39 c2                	cmp    %eax,%edx
  803e1a:	73 e9                	jae    803e05 <__udivdi3+0xe5>
  803e1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e1f:	31 ff                	xor    %edi,%edi
  803e21:	e9 40 ff ff ff       	jmp    803d66 <__udivdi3+0x46>
  803e26:	66 90                	xchg   %ax,%ax
  803e28:	31 c0                	xor    %eax,%eax
  803e2a:	e9 37 ff ff ff       	jmp    803d66 <__udivdi3+0x46>
  803e2f:	90                   	nop

00803e30 <__umoddi3>:
  803e30:	55                   	push   %ebp
  803e31:	57                   	push   %edi
  803e32:	56                   	push   %esi
  803e33:	53                   	push   %ebx
  803e34:	83 ec 1c             	sub    $0x1c,%esp
  803e37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e4f:	89 f3                	mov    %esi,%ebx
  803e51:	89 fa                	mov    %edi,%edx
  803e53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e57:	89 34 24             	mov    %esi,(%esp)
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	75 1a                	jne    803e78 <__umoddi3+0x48>
  803e5e:	39 f7                	cmp    %esi,%edi
  803e60:	0f 86 a2 00 00 00    	jbe    803f08 <__umoddi3+0xd8>
  803e66:	89 c8                	mov    %ecx,%eax
  803e68:	89 f2                	mov    %esi,%edx
  803e6a:	f7 f7                	div    %edi
  803e6c:	89 d0                	mov    %edx,%eax
  803e6e:	31 d2                	xor    %edx,%edx
  803e70:	83 c4 1c             	add    $0x1c,%esp
  803e73:	5b                   	pop    %ebx
  803e74:	5e                   	pop    %esi
  803e75:	5f                   	pop    %edi
  803e76:	5d                   	pop    %ebp
  803e77:	c3                   	ret    
  803e78:	39 f0                	cmp    %esi,%eax
  803e7a:	0f 87 ac 00 00 00    	ja     803f2c <__umoddi3+0xfc>
  803e80:	0f bd e8             	bsr    %eax,%ebp
  803e83:	83 f5 1f             	xor    $0x1f,%ebp
  803e86:	0f 84 ac 00 00 00    	je     803f38 <__umoddi3+0x108>
  803e8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e91:	29 ef                	sub    %ebp,%edi
  803e93:	89 fe                	mov    %edi,%esi
  803e95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e99:	89 e9                	mov    %ebp,%ecx
  803e9b:	d3 e0                	shl    %cl,%eax
  803e9d:	89 d7                	mov    %edx,%edi
  803e9f:	89 f1                	mov    %esi,%ecx
  803ea1:	d3 ef                	shr    %cl,%edi
  803ea3:	09 c7                	or     %eax,%edi
  803ea5:	89 e9                	mov    %ebp,%ecx
  803ea7:	d3 e2                	shl    %cl,%edx
  803ea9:	89 14 24             	mov    %edx,(%esp)
  803eac:	89 d8                	mov    %ebx,%eax
  803eae:	d3 e0                	shl    %cl,%eax
  803eb0:	89 c2                	mov    %eax,%edx
  803eb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb6:	d3 e0                	shl    %cl,%eax
  803eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ebc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ec0:	89 f1                	mov    %esi,%ecx
  803ec2:	d3 e8                	shr    %cl,%eax
  803ec4:	09 d0                	or     %edx,%eax
  803ec6:	d3 eb                	shr    %cl,%ebx
  803ec8:	89 da                	mov    %ebx,%edx
  803eca:	f7 f7                	div    %edi
  803ecc:	89 d3                	mov    %edx,%ebx
  803ece:	f7 24 24             	mull   (%esp)
  803ed1:	89 c6                	mov    %eax,%esi
  803ed3:	89 d1                	mov    %edx,%ecx
  803ed5:	39 d3                	cmp    %edx,%ebx
  803ed7:	0f 82 87 00 00 00    	jb     803f64 <__umoddi3+0x134>
  803edd:	0f 84 91 00 00 00    	je     803f74 <__umoddi3+0x144>
  803ee3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ee7:	29 f2                	sub    %esi,%edx
  803ee9:	19 cb                	sbb    %ecx,%ebx
  803eeb:	89 d8                	mov    %ebx,%eax
  803eed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ef1:	d3 e0                	shl    %cl,%eax
  803ef3:	89 e9                	mov    %ebp,%ecx
  803ef5:	d3 ea                	shr    %cl,%edx
  803ef7:	09 d0                	or     %edx,%eax
  803ef9:	89 e9                	mov    %ebp,%ecx
  803efb:	d3 eb                	shr    %cl,%ebx
  803efd:	89 da                	mov    %ebx,%edx
  803eff:	83 c4 1c             	add    $0x1c,%esp
  803f02:	5b                   	pop    %ebx
  803f03:	5e                   	pop    %esi
  803f04:	5f                   	pop    %edi
  803f05:	5d                   	pop    %ebp
  803f06:	c3                   	ret    
  803f07:	90                   	nop
  803f08:	89 fd                	mov    %edi,%ebp
  803f0a:	85 ff                	test   %edi,%edi
  803f0c:	75 0b                	jne    803f19 <__umoddi3+0xe9>
  803f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f13:	31 d2                	xor    %edx,%edx
  803f15:	f7 f7                	div    %edi
  803f17:	89 c5                	mov    %eax,%ebp
  803f19:	89 f0                	mov    %esi,%eax
  803f1b:	31 d2                	xor    %edx,%edx
  803f1d:	f7 f5                	div    %ebp
  803f1f:	89 c8                	mov    %ecx,%eax
  803f21:	f7 f5                	div    %ebp
  803f23:	89 d0                	mov    %edx,%eax
  803f25:	e9 44 ff ff ff       	jmp    803e6e <__umoddi3+0x3e>
  803f2a:	66 90                	xchg   %ax,%ax
  803f2c:	89 c8                	mov    %ecx,%eax
  803f2e:	89 f2                	mov    %esi,%edx
  803f30:	83 c4 1c             	add    $0x1c,%esp
  803f33:	5b                   	pop    %ebx
  803f34:	5e                   	pop    %esi
  803f35:	5f                   	pop    %edi
  803f36:	5d                   	pop    %ebp
  803f37:	c3                   	ret    
  803f38:	3b 04 24             	cmp    (%esp),%eax
  803f3b:	72 06                	jb     803f43 <__umoddi3+0x113>
  803f3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f41:	77 0f                	ja     803f52 <__umoddi3+0x122>
  803f43:	89 f2                	mov    %esi,%edx
  803f45:	29 f9                	sub    %edi,%ecx
  803f47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f4b:	89 14 24             	mov    %edx,(%esp)
  803f4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f56:	8b 14 24             	mov    (%esp),%edx
  803f59:	83 c4 1c             	add    $0x1c,%esp
  803f5c:	5b                   	pop    %ebx
  803f5d:	5e                   	pop    %esi
  803f5e:	5f                   	pop    %edi
  803f5f:	5d                   	pop    %ebp
  803f60:	c3                   	ret    
  803f61:	8d 76 00             	lea    0x0(%esi),%esi
  803f64:	2b 04 24             	sub    (%esp),%eax
  803f67:	19 fa                	sbb    %edi,%edx
  803f69:	89 d1                	mov    %edx,%ecx
  803f6b:	89 c6                	mov    %eax,%esi
  803f6d:	e9 71 ff ff ff       	jmp    803ee3 <__umoddi3+0xb3>
  803f72:	66 90                	xchg   %ax,%ax
  803f74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f78:	72 ea                	jb     803f64 <__umoddi3+0x134>
  803f7a:	89 d9                	mov    %ebx,%ecx
  803f7c:	e9 62 ff ff ff       	jmp    803ee3 <__umoddi3+0xb3>
