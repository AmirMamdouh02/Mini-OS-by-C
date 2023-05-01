
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 e0 42 80 00       	push   $0x8042e0
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 27 29 00 00       	call   80299b <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 bf 29 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 6f 24 00 00       	call   8024fd <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 04 43 80 00       	push   $0x804304
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 34 43 80 00       	push   $0x804334
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 e1 28 00 00       	call   80299b <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 4c 43 80 00       	push   $0x80434c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 34 43 80 00       	push   $0x804334
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 5f 29 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 b8 43 80 00       	push   $0x8043b8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 34 43 80 00       	push   $0x804334
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 9c 28 00 00       	call   80299b <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 34 29 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 e4 23 00 00       	call   8024fd <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 04 43 80 00       	push   $0x804304
  800138:	6a 19                	push   $0x19
  80013a:	68 34 43 80 00       	push   $0x804334
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 52 28 00 00       	call   80299b <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 4c 43 80 00       	push   $0x80434c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 34 43 80 00       	push   $0x804334
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 d0 28 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 b8 43 80 00       	push   $0x8043b8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 34 43 80 00       	push   $0x804334
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 0d 28 00 00       	call   80299b <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 a5 28 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 55 23 00 00       	call   8024fd <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 04 43 80 00       	push   $0x804304
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 34 43 80 00       	push   $0x804334
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 c1 27 00 00       	call   80299b <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 4c 43 80 00       	push   $0x80434c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 34 43 80 00       	push   $0x804334
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 3f 28 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 b8 43 80 00       	push   $0x8043b8
  80020e:	6a 24                	push   $0x24
  800210:	68 34 43 80 00       	push   $0x804334
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 7c 27 00 00       	call   80299b <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 14 28 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 c4 22 00 00       	call   8024fd <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 04 43 80 00       	push   $0x804304
  80025e:	6a 2a                	push   $0x2a
  800260:	68 34 43 80 00       	push   $0x804334
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 2c 27 00 00       	call   80299b <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 4c 43 80 00       	push   $0x80434c
  800280:	6a 2c                	push   $0x2c
  800282:	68 34 43 80 00       	push   $0x804334
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 aa 27 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 b8 43 80 00       	push   $0x8043b8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 34 43 80 00       	push   $0x804334
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 e7 26 00 00       	call   80299b <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 7f 27 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 2d 22 00 00       	call   8024fd <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 04 43 80 00       	push   $0x804304
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 34 43 80 00       	push   $0x804334
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 95 26 00 00       	call   80299b <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 4c 43 80 00       	push   $0x80434c
  800317:	6a 35                	push   $0x35
  800319:	68 34 43 80 00       	push   $0x804334
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 13 27 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 b8 43 80 00       	push   $0x8043b8
  80033a:	6a 36                	push   $0x36
  80033c:	68 34 43 80 00       	push   $0x804334
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 50 26 00 00       	call   80299b <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 e8 26 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 96 21 00 00       	call   8024fd <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 04 43 80 00       	push   $0x804304
  80038e:	6a 3c                	push   $0x3c
  800390:	68 34 43 80 00       	push   $0x804334
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 fc 25 00 00       	call   80299b <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 4c 43 80 00       	push   $0x80434c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 34 43 80 00       	push   $0x804334
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 7a 26 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 b8 43 80 00       	push   $0x8043b8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 34 43 80 00       	push   $0x804334
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 b7 25 00 00       	call   80299b <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 4f 26 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 f9 20 00 00       	call   8024fd <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 04 43 80 00       	push   $0x804304
  800426:	6a 45                	push   $0x45
  800428:	68 34 43 80 00       	push   $0x804334
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 61 25 00 00       	call   80299b <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 4c 43 80 00       	push   $0x80434c
  80044b:	6a 47                	push   $0x47
  80044d:	68 34 43 80 00       	push   $0x804334
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 df 25 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 b8 43 80 00       	push   $0x8043b8
  80046e:	6a 48                	push   $0x48
  800470:	68 34 43 80 00       	push   $0x804334
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 1c 25 00 00       	call   80299b <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 b4 25 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 5e 20 00 00       	call   8024fd <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 04 43 80 00       	push   $0x804304
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 34 43 80 00       	push   $0x804334
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 be 24 00 00       	call   80299b <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 4c 43 80 00       	push   $0x80434c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 34 43 80 00       	push   $0x804334
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 3c 25 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 b8 43 80 00       	push   $0x8043b8
  800511:	6a 51                	push   $0x51
  800513:	68 34 43 80 00       	push   $0x804334
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 79 24 00 00       	call   80299b <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 11 25 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 a4 1f 00 00       	call   8024fd <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 04 43 80 00       	push   $0x804304
  800584:	6a 5a                	push   $0x5a
  800586:	68 34 43 80 00       	push   $0x804334
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 03 24 00 00       	call   80299b <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 4c 43 80 00       	push   $0x80434c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 34 43 80 00       	push   $0x804334
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 81 24 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 b8 43 80 00       	push   $0x8043b8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 34 43 80 00       	push   $0x804334
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 be 23 00 00       	call   80299b <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 56 24 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 a2 1f 00 00       	call   802596 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 3f 24 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 e8 43 80 00       	push   $0x8043e8
  800612:	6a 68                	push   $0x68
  800614:	68 34 43 80 00       	push   $0x804334
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 78 23 00 00       	call   80299b <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 24 44 80 00       	push   $0x804424
  800634:	6a 69                	push   $0x69
  800636:	68 34 43 80 00       	push   $0x804334
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 56 23 00 00       	call   80299b <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 ee 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 3a 1f 00 00       	call   802596 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 d7 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 e8 43 80 00       	push   $0x8043e8
  80067a:	6a 70                	push   $0x70
  80067c:	68 34 43 80 00       	push   $0x804334
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 10 23 00 00       	call   80299b <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 24 44 80 00       	push   $0x804424
  80069c:	6a 71                	push   $0x71
  80069e:	68 34 43 80 00       	push   $0x804334
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 ee 22 00 00       	call   80299b <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 86 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 d2 1e 00 00       	call   802596 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 6f 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 e8 43 80 00       	push   $0x8043e8
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 34 43 80 00       	push   $0x804334
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 a8 22 00 00       	call   80299b <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 24 44 80 00       	push   $0x804424
  800704:	6a 79                	push   $0x79
  800706:	68 34 43 80 00       	push   $0x804334
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 86 22 00 00       	call   80299b <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 1e 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 6a 1e 00 00       	call   802596 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 07 23 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 e8 43 80 00       	push   $0x8043e8
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 34 43 80 00       	push   $0x804334
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 3d 22 00 00       	call   80299b <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 24 44 80 00       	push   $0x804424
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 34 43 80 00       	push   $0x804334
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 11 22 00 00       	call   80299b <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 a9 22 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 55 1d 00 00       	call   8024fd <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 04 43 80 00       	push   $0x804304
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 34 43 80 00       	push   $0x804334
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 c0 21 00 00       	call   80299b <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 4c 43 80 00       	push   $0x80434c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 34 43 80 00       	push   $0x804334
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 3b 22 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 b8 43 80 00       	push   $0x8043b8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 34 43 80 00       	push   $0x804334
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 0b 21 00 00       	call   80299b <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 a3 21 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 61 1f 00 00       	call   802819 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 70 44 80 00       	push   $0x804470
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 34 43 80 00       	push   $0x804334
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 b0 20 00 00       	call   80299b <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 a4 44 80 00       	push   $0x8044a4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 34 43 80 00       	push   $0x804334
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 2b 21 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 14 45 80 00       	push   $0x804514
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 34 43 80 00       	push   $0x804334
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 48 45 80 00       	push   $0x804548
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 34 43 80 00       	push   $0x804334
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 48 45 80 00       	push   $0x804548
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 34 43 80 00       	push   $0x804334
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 48 45 80 00       	push   $0x804548
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 34 43 80 00       	push   $0x804334
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 48 45 80 00       	push   $0x804548
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 34 43 80 00       	push   $0x804334
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 f6 1e 00 00       	call   80299b <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 8e 1f 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 da 1a 00 00       	call   802596 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 77 1f 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 80 45 80 00       	push   $0x804580
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 34 43 80 00       	push   $0x804334
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 ad 1e 00 00       	call   80299b <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 24 44 80 00       	push   $0x804424
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 34 43 80 00       	push   $0x804334
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 d4 45 80 00       	push   $0x8045d4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 71 1e 00 00       	call   80299b <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 09 1f 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 af 19 00 00       	call   8024fd <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 04 43 80 00       	push   $0x804304
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 34 43 80 00       	push   $0x804334
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 17 1e 00 00       	call   80299b <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 4c 43 80 00       	push   $0x80434c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 34 43 80 00       	push   $0x804334
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 92 1e 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 b8 43 80 00       	push   $0x8043b8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 34 43 80 00       	push   $0x804334
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 5b 1d 00 00       	call   80299b <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 f3 1d 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 aa 1b 00 00       	call   802819 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 70 44 80 00       	push   $0x804470
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 34 43 80 00       	push   $0x804334
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 96 1d 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 14 45 80 00       	push   $0x804514
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 34 43 80 00       	push   $0x804334
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 48 45 80 00       	push   $0x804548
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 34 43 80 00       	push   $0x804334
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 48 45 80 00       	push   $0x804548
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 34 43 80 00       	push   $0x804334
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 48 45 80 00       	push   $0x804548
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 34 43 80 00       	push   $0x804334
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 48 45 80 00       	push   $0x804548
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 34 43 80 00       	push   $0x804334
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 56 1b 00 00       	call   80299b <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 ee 1b 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 3a 17 00 00       	call   802596 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 d7 1b 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 80 45 80 00       	push   $0x804580
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 34 43 80 00       	push   $0x804334
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 db 45 80 00       	push   $0x8045db
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 94 1a 00 00       	call   80299b <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 2c 1b 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 ef 18 00 00       	call   802819 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 70 44 80 00       	push   $0x804470
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 34 43 80 00       	push   $0x804334
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 d2 1a 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 14 45 80 00       	push   $0x804514
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 34 43 80 00       	push   $0x804334
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 48 45 80 00       	push   $0x804548
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 34 43 80 00       	push   $0x804334
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 48 45 80 00       	push   $0x804548
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 34 43 80 00       	push   $0x804334
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 48 45 80 00       	push   $0x804548
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 34 43 80 00       	push   $0x804334
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 48 45 80 00       	push   $0x804548
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 34 43 80 00       	push   $0x804334
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 9b 18 00 00       	call   80299b <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 33 19 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 7f 14 00 00       	call   802596 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 1c 19 00 00       	call   802a3b <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 80 45 80 00       	push   $0x804580
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 34 43 80 00       	push   $0x804334
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 e2 45 80 00       	push   $0x8045e2
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 ec 45 80 00       	push   $0x8045ec
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 02 1b 00 00       	call   802c7b <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 a4 18 00 00       	call   802a88 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 40 46 80 00       	push   $0x804640
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 68 46 80 00       	push   $0x804668
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 90 46 80 00       	push   $0x804690
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 e8 46 80 00       	push   $0x8046e8
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 40 46 80 00       	push   $0x804640
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 24 18 00 00       	call   802aa2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 b1 19 00 00       	call   802c47 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 06 1a 00 00       	call   802cad <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 fc 46 80 00       	push   $0x8046fc
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 01 47 80 00       	push   $0x804701
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 1d 47 80 00       	push   $0x80471d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 20 47 80 00       	push   $0x804720
  801339:	6a 26                	push   $0x26
  80133b:	68 6c 47 80 00       	push   $0x80476c
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 78 47 80 00       	push   $0x804778
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 6c 47 80 00       	push   $0x80476c
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 cc 47 80 00       	push   $0x8047cc
  80147b:	6a 44                	push   $0x44
  80147d:	68 6c 47 80 00       	push   $0x80476c
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 05 14 00 00       	call   8028da <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 8e 13 00 00       	call   8028da <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 f2 14 00 00       	call   802a88 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 ec 14 00 00       	call   802aa2 <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 64 2a 00 00       	call   804064 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 24 2b 00 00       	call   804174 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 34 4a 80 00       	add    $0x804a34,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 45 4a 80 00       	push   $0x804a45
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 4e 4a 80 00       	push   $0x804a4e
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be 51 4a 80 00       	mov    $0x804a51,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 b0 4b 80 00       	push   $0x804bb0
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80231f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802326:	00 00 00 
  802329:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802330:	00 00 00 
  802333:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80233a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80233d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802344:	00 00 00 
  802347:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80234e:	00 00 00 
  802351:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802358:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80235b:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c1 e8 0c             	shr    $0xc,%eax
  802368:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80236d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80237c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802381:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  802386:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80238d:	a1 20 51 80 00       	mov    0x805120,%eax
  802392:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  802396:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  802399:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8023a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a6:	01 d0                	add    %edx,%eax
  8023a8:	48                   	dec    %eax
  8023a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8023ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023af:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b4:	f7 75 e4             	divl   -0x1c(%ebp)
  8023b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ba:	29 d0                	sub    %edx,%eax
  8023bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8023bf:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8023c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023ce:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	6a 07                	push   $0x7
  8023d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8023db:	50                   	push   %eax
  8023dc:	e8 3d 06 00 00       	call   802a1e <sys_allocate_chunk>
  8023e1:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023e4:	a1 20 51 80 00       	mov    0x805120,%eax
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	50                   	push   %eax
  8023ed:	e8 b2 0c 00 00       	call   8030a4 <initialize_MemBlocksList>
  8023f2:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8023f5:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8023fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8023fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802401:	0f 84 f3 00 00 00    	je     8024fa <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  802407:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80240b:	75 14                	jne    802421 <initialize_dyn_block_system+0x108>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 d5 4b 80 00       	push   $0x804bd5
  802415:	6a 36                	push   $0x36
  802417:	68 f3 4b 80 00       	push   $0x804bf3
  80241c:	e8 89 ee ff ff       	call   8012aa <_panic>
  802421:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	74 10                	je     80243a <initialize_dyn_block_system+0x121>
  80242a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802432:	8b 52 04             	mov    0x4(%edx),%edx
  802435:	89 50 04             	mov    %edx,0x4(%eax)
  802438:	eb 0b                	jmp    802445 <initialize_dyn_block_system+0x12c>
  80243a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802445:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802448:	8b 40 04             	mov    0x4(%eax),%eax
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 0f                	je     80245e <initialize_dyn_block_system+0x145>
  80244f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802452:	8b 40 04             	mov    0x4(%eax),%eax
  802455:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802458:	8b 12                	mov    (%edx),%edx
  80245a:	89 10                	mov    %edx,(%eax)
  80245c:	eb 0a                	jmp    802468 <initialize_dyn_block_system+0x14f>
  80245e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	a3 48 51 80 00       	mov    %eax,0x805148
  802468:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80246b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802471:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802474:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247b:	a1 54 51 80 00       	mov    0x805154,%eax
  802480:	48                   	dec    %eax
  802481:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  802486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802489:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  802490:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802493:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80249a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80249e:	75 14                	jne    8024b4 <initialize_dyn_block_system+0x19b>
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	68 00 4c 80 00       	push   $0x804c00
  8024a8:	6a 3e                	push   $0x3e
  8024aa:	68 f3 4b 80 00       	push   $0x804bf3
  8024af:	e8 f6 ed ff ff       	call   8012aa <_panic>
  8024b4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8024ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0d                	je     8024d5 <initialize_dyn_block_system+0x1bc>
  8024c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	eb 08                	jmp    8024dd <initialize_dyn_block_system+0x1c4>
  8024d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8024e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8024f4:	40                   	inc    %eax
  8024f5:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  8024fa:	90                   	nop
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
  802500:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  802503:	e8 e0 fd ff ff       	call   8022e8 <InitializeUHeap>
		if (size == 0) return NULL ;
  802508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250c:	75 07                	jne    802515 <malloc+0x18>
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
  802513:	eb 7f                	jmp    802594 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  802515:	e8 d2 08 00 00       	call   802dec <sys_isUHeapPlacementStrategyFIRSTFIT>
  80251a:	85 c0                	test   %eax,%eax
  80251c:	74 71                	je     80258f <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80251e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802525:	8b 55 08             	mov    0x8(%ebp),%edx
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	01 d0                	add    %edx,%eax
  80252d:	48                   	dec    %eax
  80252e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	ba 00 00 00 00       	mov    $0x0,%edx
  802539:	f7 75 f4             	divl   -0xc(%ebp)
  80253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253f:	29 d0                	sub    %edx,%eax
  802541:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  802544:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80254b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802552:	76 07                	jbe    80255b <malloc+0x5e>
					return NULL ;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	eb 39                	jmp    802594 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	ff 75 08             	pushl  0x8(%ebp)
  802561:	e8 e6 0d 00 00       	call   80334c <alloc_block_FF>
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80256c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802570:	74 16                	je     802588 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	ff 75 ec             	pushl  -0x14(%ebp)
  802578:	e8 37 0c 00 00       	call   8031b4 <insert_sorted_allocList>
  80257d:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  802580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802583:	8b 40 08             	mov    0x8(%eax),%eax
  802586:	eb 0c                	jmp    802594 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	eb 05                	jmp    802594 <malloc+0x97>
				}
		}
	return 0;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8025a2:	83 ec 08             	sub    $0x8,%esp
  8025a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a8:	68 40 50 80 00       	push   $0x805040
  8025ad:	e8 cf 0b 00 00       	call   803181 <find_block>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8025b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025be:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	8b 40 08             	mov    0x8(%eax),%eax
  8025c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8025ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ce:	0f 84 a1 00 00 00    	je     802675 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8025d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025d8:	75 17                	jne    8025f1 <free+0x5b>
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	68 d5 4b 80 00       	push   $0x804bd5
  8025e2:	68 80 00 00 00       	push   $0x80
  8025e7:	68 f3 4b 80 00       	push   $0x804bf3
  8025ec:	e8 b9 ec ff ff       	call   8012aa <_panic>
  8025f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 10                	je     80260a <free+0x74>
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802602:	8b 52 04             	mov    0x4(%edx),%edx
  802605:	89 50 04             	mov    %edx,0x4(%eax)
  802608:	eb 0b                	jmp    802615 <free+0x7f>
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 40 04             	mov    0x4(%eax),%eax
  802610:	a3 44 50 80 00       	mov    %eax,0x805044
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 0f                	je     80262e <free+0x98>
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802628:	8b 12                	mov    (%edx),%edx
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	eb 0a                	jmp    802638 <free+0xa2>
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	a3 40 50 80 00       	mov    %eax,0x805040
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802650:	48                   	dec    %eax
  802651:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	ff 75 f0             	pushl  -0x10(%ebp)
  80265c:	e8 29 12 00 00       	call   80388a <insert_sorted_with_merge_freeList>
  802661:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  802664:	83 ec 08             	sub    $0x8,%esp
  802667:	ff 75 ec             	pushl  -0x14(%ebp)
  80266a:	ff 75 e8             	pushl  -0x18(%ebp)
  80266d:	e8 74 03 00 00       	call   8029e6 <sys_free_user_mem>
  802672:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802675:	90                   	nop
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 38             	sub    $0x38,%esp
  80267e:	8b 45 10             	mov    0x10(%ebp),%eax
  802681:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802684:	e8 5f fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802689:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80268d:	75 0a                	jne    802699 <smalloc+0x21>
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	e9 b2 00 00 00       	jmp    80274b <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802699:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8026a0:	76 0a                	jbe    8026ac <smalloc+0x34>
		return NULL;
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	e9 9f 00 00 00       	jmp    80274b <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8026ac:	e8 3b 07 00 00       	call   802dec <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 84 8d 00 00 00    	je     802746 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8026b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8026c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8026c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	01 d0                	add    %edx,%eax
  8026cf:	48                   	dec    %eax
  8026d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026db:	f7 75 f0             	divl   -0x10(%ebp)
  8026de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e1:	29 d0                	sub    %edx,%eax
  8026e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8026ec:	e8 5b 0c 00 00       	call   80334c <alloc_block_FF>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	75 07                	jne    802704 <smalloc+0x8c>
			return NULL;
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802702:	eb 47                	jmp    80274b <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	ff 75 f4             	pushl  -0xc(%ebp)
  80270a:	e8 a5 0a 00 00       	call   8031b4 <insert_sorted_allocList>
  80270f:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 08             	mov    0x8(%eax),%eax
  802718:	89 c2                	mov    %eax,%edx
  80271a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80271e:	52                   	push   %edx
  80271f:	50                   	push   %eax
  802720:	ff 75 0c             	pushl  0xc(%ebp)
  802723:	ff 75 08             	pushl  0x8(%ebp)
  802726:	e8 46 04 00 00       	call   802b71 <sys_createSharedObject>
  80272b:	83 c4 10             	add    $0x10,%esp
  80272e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  802731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802735:	78 08                	js     80273f <smalloc+0xc7>
		return (void *)b->sva;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 08             	mov    0x8(%eax),%eax
  80273d:	eb 0c                	jmp    80274b <smalloc+0xd3>
		}else{
		return NULL;
  80273f:	b8 00 00 00 00       	mov    $0x0,%eax
  802744:	eb 05                	jmp    80274b <smalloc+0xd3>
			}

	}return NULL;
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802753:	e8 90 fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802758:	e8 8f 06 00 00       	call   802dec <sys_isUHeapPlacementStrategyFIRSTFIT>
  80275d:	85 c0                	test   %eax,%eax
  80275f:	0f 84 ad 00 00 00    	je     802812 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802765:	83 ec 08             	sub    $0x8,%esp
  802768:	ff 75 0c             	pushl  0xc(%ebp)
  80276b:	ff 75 08             	pushl  0x8(%ebp)
  80276e:	e8 28 04 00 00       	call   802b9b <sys_getSizeOfSharedObject>
  802773:	83 c4 10             	add    $0x10,%esp
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	79 0a                	jns    802789 <sget+0x3c>
    {
    	return NULL;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	e9 8e 00 00 00       	jmp    802817 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  802790:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	01 d0                	add    %edx,%eax
  80279f:	48                   	dec    %eax
  8027a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ab:	f7 75 ec             	divl   -0x14(%ebp)
  8027ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b1:	29 d0                	sub    %edx,%eax
  8027b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8027b6:	83 ec 0c             	sub    $0xc,%esp
  8027b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027bc:	e8 8b 0b 00 00       	call   80334c <alloc_block_FF>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8027c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027cb:	75 07                	jne    8027d4 <sget+0x87>
				return NULL;
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	eb 43                	jmp    802817 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8027da:	e8 d5 09 00 00       	call   8031b4 <insert_sorted_allocList>
  8027df:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	8b 40 08             	mov    0x8(%eax),%eax
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	50                   	push   %eax
  8027ec:	ff 75 0c             	pushl  0xc(%ebp)
  8027ef:	ff 75 08             	pushl  0x8(%ebp)
  8027f2:	e8 c1 03 00 00       	call   802bb8 <sys_getSharedObject>
  8027f7:	83 c4 10             	add    $0x10,%esp
  8027fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8027fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802801:	78 08                	js     80280b <sget+0xbe>
			return (void *)b->sva;
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	eb 0c                	jmp    802817 <sget+0xca>
			}else{
			return NULL;
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
  802810:	eb 05                	jmp    802817 <sget+0xca>
			}
    }}return NULL;
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80281f:	e8 c4 fa ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	68 24 4c 80 00       	push   $0x804c24
  80282c:	68 03 01 00 00       	push   $0x103
  802831:	68 f3 4b 80 00       	push   $0x804bf3
  802836:	e8 6f ea ff ff       	call   8012aa <_panic>

0080283b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802841:	83 ec 04             	sub    $0x4,%esp
  802844:	68 4c 4c 80 00       	push   $0x804c4c
  802849:	68 17 01 00 00       	push   $0x117
  80284e:	68 f3 4b 80 00       	push   $0x804bf3
  802853:	e8 52 ea ff ff       	call   8012aa <_panic>

00802858 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80285e:	83 ec 04             	sub    $0x4,%esp
  802861:	68 70 4c 80 00       	push   $0x804c70
  802866:	68 22 01 00 00       	push   $0x122
  80286b:	68 f3 4b 80 00       	push   $0x804bf3
  802870:	e8 35 ea ff ff       	call   8012aa <_panic>

00802875 <shrink>:

}
void shrink(uint32 newSize)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 70 4c 80 00       	push   $0x804c70
  802883:	68 27 01 00 00       	push   $0x127
  802888:	68 f3 4b 80 00       	push   $0x804bf3
  80288d:	e8 18 ea ff ff       	call   8012aa <_panic>

00802892 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	68 70 4c 80 00       	push   $0x804c70
  8028a0:	68 2c 01 00 00       	push   $0x12c
  8028a5:	68 f3 4b 80 00       	push   $0x804bf3
  8028aa:	e8 fb e9 ff ff       	call   8012aa <_panic>

008028af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	57                   	push   %edi
  8028b3:	56                   	push   %esi
  8028b4:	53                   	push   %ebx
  8028b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8028c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8028ca:	cd 30                	int    $0x30
  8028cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8028d2:	83 c4 10             	add    $0x10,%esp
  8028d5:	5b                   	pop    %ebx
  8028d6:	5e                   	pop    %esi
  8028d7:	5f                   	pop    %edi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8028e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	52                   	push   %edx
  8028f2:	ff 75 0c             	pushl  0xc(%ebp)
  8028f5:	50                   	push   %eax
  8028f6:	6a 00                	push   $0x0
  8028f8:	e8 b2 ff ff ff       	call   8028af <syscall>
  8028fd:	83 c4 18             	add    $0x18,%esp
}
  802900:	90                   	nop
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <sys_cgetc>:

int
sys_cgetc(void)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 01                	push   $0x1
  802912:	e8 98 ff ff ff       	call   8028af <syscall>
  802917:	83 c4 18             	add    $0x18,%esp
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80291f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	52                   	push   %edx
  80292c:	50                   	push   %eax
  80292d:	6a 05                	push   $0x5
  80292f:	e8 7b ff ff ff       	call   8028af <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
  80293c:	56                   	push   %esi
  80293d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80293e:	8b 75 18             	mov    0x18(%ebp),%esi
  802941:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802944:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	56                   	push   %esi
  80294e:	53                   	push   %ebx
  80294f:	51                   	push   %ecx
  802950:	52                   	push   %edx
  802951:	50                   	push   %eax
  802952:	6a 06                	push   $0x6
  802954:	e8 56 ff ff ff       	call   8028af <syscall>
  802959:	83 c4 18             	add    $0x18,%esp
}
  80295c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80295f:	5b                   	pop    %ebx
  802960:	5e                   	pop    %esi
  802961:	5d                   	pop    %ebp
  802962:	c3                   	ret    

00802963 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802966:	8b 55 0c             	mov    0xc(%ebp),%edx
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	52                   	push   %edx
  802973:	50                   	push   %eax
  802974:	6a 07                	push   $0x7
  802976:	e8 34 ff ff ff       	call   8028af <syscall>
  80297b:	83 c4 18             	add    $0x18,%esp
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	ff 75 0c             	pushl  0xc(%ebp)
  80298c:	ff 75 08             	pushl  0x8(%ebp)
  80298f:	6a 08                	push   $0x8
  802991:	e8 19 ff ff ff       	call   8028af <syscall>
  802996:	83 c4 18             	add    $0x18,%esp
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 09                	push   $0x9
  8029aa:	e8 00 ff ff ff       	call   8028af <syscall>
  8029af:	83 c4 18             	add    $0x18,%esp
}
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 0a                	push   $0xa
  8029c3:	e8 e7 fe ff ff       	call   8028af <syscall>
  8029c8:	83 c4 18             	add    $0x18,%esp
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 0b                	push   $0xb
  8029dc:	e8 ce fe ff ff       	call   8028af <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	ff 75 0c             	pushl  0xc(%ebp)
  8029f2:	ff 75 08             	pushl  0x8(%ebp)
  8029f5:	6a 0f                	push   $0xf
  8029f7:	e8 b3 fe ff ff       	call   8028af <syscall>
  8029fc:	83 c4 18             	add    $0x18,%esp
	return;
  8029ff:	90                   	nop
}
  802a00:	c9                   	leave  
  802a01:	c3                   	ret    

00802a02 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a02:	55                   	push   %ebp
  802a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	ff 75 0c             	pushl  0xc(%ebp)
  802a0e:	ff 75 08             	pushl  0x8(%ebp)
  802a11:	6a 10                	push   $0x10
  802a13:	e8 97 fe ff ff       	call   8028af <syscall>
  802a18:	83 c4 18             	add    $0x18,%esp
	return ;
  802a1b:	90                   	nop
}
  802a1c:	c9                   	leave  
  802a1d:	c3                   	ret    

00802a1e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	ff 75 10             	pushl  0x10(%ebp)
  802a28:	ff 75 0c             	pushl  0xc(%ebp)
  802a2b:	ff 75 08             	pushl  0x8(%ebp)
  802a2e:	6a 11                	push   $0x11
  802a30:	e8 7a fe ff ff       	call   8028af <syscall>
  802a35:	83 c4 18             	add    $0x18,%esp
	return ;
  802a38:	90                   	nop
}
  802a39:	c9                   	leave  
  802a3a:	c3                   	ret    

00802a3b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 0c                	push   $0xc
  802a4a:	e8 60 fe ff ff       	call   8028af <syscall>
  802a4f:	83 c4 18             	add    $0x18,%esp
}
  802a52:	c9                   	leave  
  802a53:	c3                   	ret    

00802a54 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	ff 75 08             	pushl  0x8(%ebp)
  802a62:	6a 0d                	push   $0xd
  802a64:	e8 46 fe ff ff       	call   8028af <syscall>
  802a69:	83 c4 18             	add    $0x18,%esp
}
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <sys_scarce_memory>:

void sys_scarce_memory()
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 0e                	push   $0xe
  802a7d:	e8 2d fe ff ff       	call   8028af <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
}
  802a85:	90                   	nop
  802a86:	c9                   	leave  
  802a87:	c3                   	ret    

00802a88 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 13                	push   $0x13
  802a97:	e8 13 fe ff ff       	call   8028af <syscall>
  802a9c:	83 c4 18             	add    $0x18,%esp
}
  802a9f:	90                   	nop
  802aa0:	c9                   	leave  
  802aa1:	c3                   	ret    

00802aa2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802aa2:	55                   	push   %ebp
  802aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 14                	push   $0x14
  802ab1:	e8 f9 fd ff ff       	call   8028af <syscall>
  802ab6:	83 c4 18             	add    $0x18,%esp
}
  802ab9:	90                   	nop
  802aba:	c9                   	leave  
  802abb:	c3                   	ret    

00802abc <sys_cputc>:


void
sys_cputc(const char c)
{
  802abc:	55                   	push   %ebp
  802abd:	89 e5                	mov    %esp,%ebp
  802abf:	83 ec 04             	sub    $0x4,%esp
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ac8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	50                   	push   %eax
  802ad5:	6a 15                	push   $0x15
  802ad7:	e8 d3 fd ff ff       	call   8028af <syscall>
  802adc:	83 c4 18             	add    $0x18,%esp
}
  802adf:	90                   	nop
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 00                	push   $0x0
  802aed:	6a 00                	push   $0x0
  802aef:	6a 16                	push   $0x16
  802af1:	e8 b9 fd ff ff       	call   8028af <syscall>
  802af6:	83 c4 18             	add    $0x18,%esp
}
  802af9:	90                   	nop
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	ff 75 0c             	pushl  0xc(%ebp)
  802b0b:	50                   	push   %eax
  802b0c:	6a 17                	push   $0x17
  802b0e:	e8 9c fd ff ff       	call   8028af <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
}
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	52                   	push   %edx
  802b28:	50                   	push   %eax
  802b29:	6a 1a                	push   $0x1a
  802b2b:	e8 7f fd ff ff       	call   8028af <syscall>
  802b30:	83 c4 18             	add    $0x18,%esp
}
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	52                   	push   %edx
  802b45:	50                   	push   %eax
  802b46:	6a 18                	push   $0x18
  802b48:	e8 62 fd ff ff       	call   8028af <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
}
  802b50:	90                   	nop
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	52                   	push   %edx
  802b63:	50                   	push   %eax
  802b64:	6a 19                	push   $0x19
  802b66:	e8 44 fd ff ff       	call   8028af <syscall>
  802b6b:	83 c4 18             	add    $0x18,%esp
}
  802b6e:	90                   	nop
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
  802b74:	83 ec 04             	sub    $0x4,%esp
  802b77:	8b 45 10             	mov    0x10(%ebp),%eax
  802b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802b7d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b80:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	6a 00                	push   $0x0
  802b89:	51                   	push   %ecx
  802b8a:	52                   	push   %edx
  802b8b:	ff 75 0c             	pushl  0xc(%ebp)
  802b8e:	50                   	push   %eax
  802b8f:	6a 1b                	push   $0x1b
  802b91:	e8 19 fd ff ff       	call   8028af <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
}
  802b99:	c9                   	leave  
  802b9a:	c3                   	ret    

00802b9b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802b9b:	55                   	push   %ebp
  802b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	52                   	push   %edx
  802bab:	50                   	push   %eax
  802bac:	6a 1c                	push   $0x1c
  802bae:	e8 fc fc ff ff       	call   8028af <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802bbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	51                   	push   %ecx
  802bc9:	52                   	push   %edx
  802bca:	50                   	push   %eax
  802bcb:	6a 1d                	push   $0x1d
  802bcd:	e8 dd fc ff ff       	call   8028af <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
}
  802bd5:	c9                   	leave  
  802bd6:	c3                   	ret    

00802bd7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802bd7:	55                   	push   %ebp
  802bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	52                   	push   %edx
  802be7:	50                   	push   %eax
  802be8:	6a 1e                	push   $0x1e
  802bea:	e8 c0 fc ff ff       	call   8028af <syscall>
  802bef:	83 c4 18             	add    $0x18,%esp
}
  802bf2:	c9                   	leave  
  802bf3:	c3                   	ret    

00802bf4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 1f                	push   $0x1f
  802c03:	e8 a7 fc ff ff       	call   8028af <syscall>
  802c08:	83 c4 18             	add    $0x18,%esp
}
  802c0b:	c9                   	leave  
  802c0c:	c3                   	ret    

00802c0d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802c0d:	55                   	push   %ebp
  802c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	6a 00                	push   $0x0
  802c15:	ff 75 14             	pushl  0x14(%ebp)
  802c18:	ff 75 10             	pushl  0x10(%ebp)
  802c1b:	ff 75 0c             	pushl  0xc(%ebp)
  802c1e:	50                   	push   %eax
  802c1f:	6a 20                	push   $0x20
  802c21:	e8 89 fc ff ff       	call   8028af <syscall>
  802c26:	83 c4 18             	add    $0x18,%esp
}
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	6a 00                	push   $0x0
  802c33:	6a 00                	push   $0x0
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	50                   	push   %eax
  802c3a:	6a 21                	push   $0x21
  802c3c:	e8 6e fc ff ff       	call   8028af <syscall>
  802c41:	83 c4 18             	add    $0x18,%esp
}
  802c44:	90                   	nop
  802c45:	c9                   	leave  
  802c46:	c3                   	ret    

00802c47 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802c47:	55                   	push   %ebp
  802c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	50                   	push   %eax
  802c56:	6a 22                	push   $0x22
  802c58:	e8 52 fc ff ff       	call   8028af <syscall>
  802c5d:	83 c4 18             	add    $0x18,%esp
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 02                	push   $0x2
  802c71:	e8 39 fc ff ff       	call   8028af <syscall>
  802c76:	83 c4 18             	add    $0x18,%esp
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 03                	push   $0x3
  802c8a:	e8 20 fc ff ff       	call   8028af <syscall>
  802c8f:	83 c4 18             	add    $0x18,%esp
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    

00802c94 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c97:	6a 00                	push   $0x0
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 00                	push   $0x0
  802c9f:	6a 00                	push   $0x0
  802ca1:	6a 04                	push   $0x4
  802ca3:	e8 07 fc ff ff       	call   8028af <syscall>
  802ca8:	83 c4 18             	add    $0x18,%esp
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <sys_exit_env>:


void sys_exit_env(void)
{
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802cb0:	6a 00                	push   $0x0
  802cb2:	6a 00                	push   $0x0
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 23                	push   $0x23
  802cbc:	e8 ee fb ff ff       	call   8028af <syscall>
  802cc1:	83 c4 18             	add    $0x18,%esp
}
  802cc4:	90                   	nop
  802cc5:	c9                   	leave  
  802cc6:	c3                   	ret    

00802cc7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802cc7:	55                   	push   %ebp
  802cc8:	89 e5                	mov    %esp,%ebp
  802cca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ccd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802cd0:	8d 50 04             	lea    0x4(%eax),%edx
  802cd3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	52                   	push   %edx
  802cdd:	50                   	push   %eax
  802cde:	6a 24                	push   $0x24
  802ce0:	e8 ca fb ff ff       	call   8028af <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
	return result;
  802ce8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ceb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802cf1:	89 01                	mov    %eax,(%ecx)
  802cf3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	c9                   	leave  
  802cfa:	c2 04 00             	ret    $0x4

00802cfd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	ff 75 10             	pushl  0x10(%ebp)
  802d07:	ff 75 0c             	pushl  0xc(%ebp)
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	6a 12                	push   $0x12
  802d0f:	e8 9b fb ff ff       	call   8028af <syscall>
  802d14:	83 c4 18             	add    $0x18,%esp
	return ;
  802d17:	90                   	nop
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <sys_rcr2>:
uint32 sys_rcr2()
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 25                	push   $0x25
  802d29:	e8 81 fb ff ff       	call   8028af <syscall>
  802d2e:	83 c4 18             	add    $0x18,%esp
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d3f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	50                   	push   %eax
  802d4c:	6a 26                	push   $0x26
  802d4e:	e8 5c fb ff ff       	call   8028af <syscall>
  802d53:	83 c4 18             	add    $0x18,%esp
	return ;
  802d56:	90                   	nop
}
  802d57:	c9                   	leave  
  802d58:	c3                   	ret    

00802d59 <rsttst>:
void rsttst()
{
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 00                	push   $0x0
  802d66:	6a 28                	push   $0x28
  802d68:	e8 42 fb ff ff       	call   8028af <syscall>
  802d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  802d70:	90                   	nop
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	8b 45 14             	mov    0x14(%ebp),%eax
  802d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802d7f:	8b 55 18             	mov    0x18(%ebp),%edx
  802d82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d86:	52                   	push   %edx
  802d87:	50                   	push   %eax
  802d88:	ff 75 10             	pushl  0x10(%ebp)
  802d8b:	ff 75 0c             	pushl  0xc(%ebp)
  802d8e:	ff 75 08             	pushl  0x8(%ebp)
  802d91:	6a 27                	push   $0x27
  802d93:	e8 17 fb ff ff       	call   8028af <syscall>
  802d98:	83 c4 18             	add    $0x18,%esp
	return ;
  802d9b:	90                   	nop
}
  802d9c:	c9                   	leave  
  802d9d:	c3                   	ret    

00802d9e <chktst>:
void chktst(uint32 n)
{
  802d9e:	55                   	push   %ebp
  802d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	6a 00                	push   $0x0
  802da7:	6a 00                	push   $0x0
  802da9:	ff 75 08             	pushl  0x8(%ebp)
  802dac:	6a 29                	push   $0x29
  802dae:	e8 fc fa ff ff       	call   8028af <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
	return ;
  802db6:	90                   	nop
}
  802db7:	c9                   	leave  
  802db8:	c3                   	ret    

00802db9 <inctst>:

void inctst()
{
  802db9:	55                   	push   %ebp
  802dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 2a                	push   $0x2a
  802dc8:	e8 e2 fa ff ff       	call   8028af <syscall>
  802dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  802dd0:	90                   	nop
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <gettst>:
uint32 gettst()
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	6a 00                	push   $0x0
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 2b                	push   $0x2b
  802de2:	e8 c8 fa ff ff       	call   8028af <syscall>
  802de7:	83 c4 18             	add    $0x18,%esp
}
  802dea:	c9                   	leave  
  802deb:	c3                   	ret    

00802dec <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802dec:	55                   	push   %ebp
  802ded:	89 e5                	mov    %esp,%ebp
  802def:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 2c                	push   $0x2c
  802dfe:	e8 ac fa ff ff       	call   8028af <syscall>
  802e03:	83 c4 18             	add    $0x18,%esp
  802e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802e09:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802e0d:	75 07                	jne    802e16 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  802e14:	eb 05                	jmp    802e1b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    

00802e1d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802e1d:	55                   	push   %ebp
  802e1e:	89 e5                	mov    %esp,%ebp
  802e20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 2c                	push   $0x2c
  802e2f:	e8 7b fa ff ff       	call   8028af <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
  802e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802e3a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802e3e:	75 07                	jne    802e47 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802e40:	b8 01 00 00 00       	mov    $0x1,%eax
  802e45:	eb 05                	jmp    802e4c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4c:	c9                   	leave  
  802e4d:	c3                   	ret    

00802e4e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802e4e:	55                   	push   %ebp
  802e4f:	89 e5                	mov    %esp,%ebp
  802e51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 2c                	push   $0x2c
  802e60:	e8 4a fa ff ff       	call   8028af <syscall>
  802e65:	83 c4 18             	add    $0x18,%esp
  802e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802e6b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802e6f:	75 07                	jne    802e78 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802e71:	b8 01 00 00 00       	mov    $0x1,%eax
  802e76:	eb 05                	jmp    802e7d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 00                	push   $0x0
  802e8f:	6a 2c                	push   $0x2c
  802e91:	e8 19 fa ff ff       	call   8028af <syscall>
  802e96:	83 c4 18             	add    $0x18,%esp
  802e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e9c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ea0:	75 07                	jne    802ea9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ea2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ea7:	eb 05                	jmp    802eae <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	ff 75 08             	pushl  0x8(%ebp)
  802ebe:	6a 2d                	push   $0x2d
  802ec0:	e8 ea f9 ff ff       	call   8028af <syscall>
  802ec5:	83 c4 18             	add    $0x18,%esp
	return ;
  802ec8:	90                   	nop
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
  802ece:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ecf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ed2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	6a 00                	push   $0x0
  802edd:	53                   	push   %ebx
  802ede:	51                   	push   %ecx
  802edf:	52                   	push   %edx
  802ee0:	50                   	push   %eax
  802ee1:	6a 2e                	push   $0x2e
  802ee3:	e8 c7 f9 ff ff       	call   8028af <syscall>
  802ee8:	83 c4 18             	add    $0x18,%esp
}
  802eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	52                   	push   %edx
  802f00:	50                   	push   %eax
  802f01:	6a 2f                	push   $0x2f
  802f03:	e8 a7 f9 ff ff       	call   8028af <syscall>
  802f08:	83 c4 18             	add    $0x18,%esp
}
  802f0b:	c9                   	leave  
  802f0c:	c3                   	ret    

00802f0d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802f0d:	55                   	push   %ebp
  802f0e:	89 e5                	mov    %esp,%ebp
  802f10:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802f13:	83 ec 0c             	sub    $0xc,%esp
  802f16:	68 80 4c 80 00       	push   $0x804c80
  802f1b:	e8 3e e6 ff ff       	call   80155e <cprintf>
  802f20:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802f23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802f2a:	83 ec 0c             	sub    $0xc,%esp
  802f2d:	68 ac 4c 80 00       	push   $0x804cac
  802f32:	e8 27 e6 ff ff       	call   80155e <cprintf>
  802f37:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802f3a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f46:	eb 56                	jmp    802f9e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4c:	74 1c                	je     802f6a <print_mem_block_lists+0x5d>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 50 08             	mov    0x8(%eax),%edx
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 48 08             	mov    0x8(%eax),%ecx
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	01 c8                	add    %ecx,%eax
  802f62:	39 c2                	cmp    %eax,%edx
  802f64:	73 04                	jae    802f6a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802f66:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 50 08             	mov    0x8(%eax),%edx
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 0c             	mov    0xc(%eax),%eax
  802f76:	01 c2                	add    %eax,%edx
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	52                   	push   %edx
  802f82:	50                   	push   %eax
  802f83:	68 c1 4c 80 00       	push   $0x804cc1
  802f88:	e8 d1 e5 ff ff       	call   80155e <cprintf>
  802f8d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f96:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa2:	74 07                	je     802fab <print_mem_block_lists+0x9e>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	eb 05                	jmp    802fb0 <print_mem_block_lists+0xa3>
  802fab:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb0:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb5:	a1 40 51 80 00       	mov    0x805140,%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	75 8a                	jne    802f48 <print_mem_block_lists+0x3b>
  802fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc2:	75 84                	jne    802f48 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802fc4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802fc8:	75 10                	jne    802fda <print_mem_block_lists+0xcd>
  802fca:	83 ec 0c             	sub    $0xc,%esp
  802fcd:	68 d0 4c 80 00       	push   $0x804cd0
  802fd2:	e8 87 e5 ff ff       	call   80155e <cprintf>
  802fd7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802fda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	68 f4 4c 80 00       	push   $0x804cf4
  802fe9:	e8 70 e5 ff ff       	call   80155e <cprintf>
  802fee:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802ff1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ff5:	a1 40 50 80 00       	mov    0x805040,%eax
  802ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffd:	eb 56                	jmp    803055 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802fff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803003:	74 1c                	je     803021 <print_mem_block_lists+0x114>
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 50 08             	mov    0x8(%eax),%edx
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 48 08             	mov    0x8(%eax),%ecx
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	01 c8                	add    %ecx,%eax
  803019:	39 c2                	cmp    %eax,%edx
  80301b:	73 04                	jae    803021 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80301d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	8b 50 08             	mov    0x8(%eax),%edx
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 40 0c             	mov    0xc(%eax),%eax
  80302d:	01 c2                	add    %eax,%edx
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 40 08             	mov    0x8(%eax),%eax
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	52                   	push   %edx
  803039:	50                   	push   %eax
  80303a:	68 c1 4c 80 00       	push   $0x804cc1
  80303f:	e8 1a e5 ff ff       	call   80155e <cprintf>
  803044:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80304d:	a1 48 50 80 00       	mov    0x805048,%eax
  803052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803059:	74 07                	je     803062 <print_mem_block_lists+0x155>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	eb 05                	jmp    803067 <print_mem_block_lists+0x15a>
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	a3 48 50 80 00       	mov    %eax,0x805048
  80306c:	a1 48 50 80 00       	mov    0x805048,%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	75 8a                	jne    802fff <print_mem_block_lists+0xf2>
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	75 84                	jne    802fff <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80307b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80307f:	75 10                	jne    803091 <print_mem_block_lists+0x184>
  803081:	83 ec 0c             	sub    $0xc,%esp
  803084:	68 0c 4d 80 00       	push   $0x804d0c
  803089:	e8 d0 e4 ff ff       	call   80155e <cprintf>
  80308e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803091:	83 ec 0c             	sub    $0xc,%esp
  803094:	68 80 4c 80 00       	push   $0x804c80
  803099:	e8 c0 e4 ff ff       	call   80155e <cprintf>
  80309e:	83 c4 10             	add    $0x10,%esp

}
  8030a1:	90                   	nop
  8030a2:	c9                   	leave  
  8030a3:	c3                   	ret    

008030a4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8030a4:	55                   	push   %ebp
  8030a5:	89 e5                	mov    %esp,%ebp
  8030a7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8030aa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8030b1:	00 00 00 
  8030b4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8030bb:	00 00 00 
  8030be:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8030c5:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8030c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030cf:	e9 9e 00 00 00       	jmp    803172 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8030d4:	a1 50 50 80 00       	mov    0x805050,%eax
  8030d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030dc:	c1 e2 04             	shl    $0x4,%edx
  8030df:	01 d0                	add    %edx,%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	75 14                	jne    8030f9 <initialize_MemBlocksList+0x55>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 34 4d 80 00       	push   $0x804d34
  8030ed:	6a 3d                	push   $0x3d
  8030ef:	68 57 4d 80 00       	push   $0x804d57
  8030f4:	e8 b1 e1 ff ff       	call   8012aa <_panic>
  8030f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8030fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803101:	c1 e2 04             	shl    $0x4,%edx
  803104:	01 d0                	add    %edx,%eax
  803106:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 18                	je     80312c <initialize_MemBlocksList+0x88>
  803114:	a1 48 51 80 00       	mov    0x805148,%eax
  803119:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80311f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803122:	c1 e1 04             	shl    $0x4,%ecx
  803125:	01 ca                	add    %ecx,%edx
  803127:	89 50 04             	mov    %edx,0x4(%eax)
  80312a:	eb 12                	jmp    80313e <initialize_MemBlocksList+0x9a>
  80312c:	a1 50 50 80 00       	mov    0x805050,%eax
  803131:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803134:	c1 e2 04             	shl    $0x4,%edx
  803137:	01 d0                	add    %edx,%eax
  803139:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313e:	a1 50 50 80 00       	mov    0x805050,%eax
  803143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803146:	c1 e2 04             	shl    $0x4,%edx
  803149:	01 d0                	add    %edx,%eax
  80314b:	a3 48 51 80 00       	mov    %eax,0x805148
  803150:	a1 50 50 80 00       	mov    0x805050,%eax
  803155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803158:	c1 e2 04             	shl    $0x4,%edx
  80315b:	01 d0                	add    %edx,%eax
  80315d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803164:	a1 54 51 80 00       	mov    0x805154,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80316f:	ff 45 f4             	incl   -0xc(%ebp)
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	3b 45 08             	cmp    0x8(%ebp),%eax
  803178:	0f 82 56 ff ff ff    	jb     8030d4 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80317e:	90                   	nop
  80317f:	c9                   	leave  
  803180:	c3                   	ret    

00803181 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803181:	55                   	push   %ebp
  803182:	89 e5                	mov    %esp,%ebp
  803184:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80318f:	eb 18                	jmp    8031a9 <find_block+0x28>

		if(tmp->sva == va){
  803191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803194:	8b 40 08             	mov    0x8(%eax),%eax
  803197:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80319a:	75 05                	jne    8031a1 <find_block+0x20>
			return tmp ;
  80319c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80319f:	eb 11                	jmp    8031b2 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8031a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8031a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8031ad:	75 e2                	jne    803191 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8031af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
  8031b7:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8031ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8031bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8031c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8031ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031ce:	75 65                	jne    803235 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8031d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d4:	75 14                	jne    8031ea <insert_sorted_allocList+0x36>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 34 4d 80 00       	push   $0x804d34
  8031de:	6a 62                	push   $0x62
  8031e0:	68 57 4d 80 00       	push   $0x804d57
  8031e5:	e8 c0 e0 ff ff       	call   8012aa <_panic>
  8031ea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0d                	je     80320b <insert_sorted_allocList+0x57>
  8031fe:	a1 40 50 80 00       	mov    0x805040,%eax
  803203:	8b 55 08             	mov    0x8(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 08                	jmp    803213 <insert_sorted_allocList+0x5f>
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	a3 44 50 80 00       	mov    %eax,0x805044
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	a3 40 50 80 00       	mov    %eax,0x805040
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803225:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803230:	e9 14 01 00 00       	jmp    803349 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 50 08             	mov    0x8(%eax),%edx
  80323b:	a1 44 50 80 00       	mov    0x805044,%eax
  803240:	8b 40 08             	mov    0x8(%eax),%eax
  803243:	39 c2                	cmp    %eax,%edx
  803245:	76 65                	jbe    8032ac <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  803247:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324b:	75 14                	jne    803261 <insert_sorted_allocList+0xad>
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	68 70 4d 80 00       	push   $0x804d70
  803255:	6a 64                	push   $0x64
  803257:	68 57 4d 80 00       	push   $0x804d57
  80325c:	e8 49 e0 ff ff       	call   8012aa <_panic>
  803261:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	74 0c                	je     803283 <insert_sorted_allocList+0xcf>
  803277:	a1 44 50 80 00       	mov    0x805044,%eax
  80327c:	8b 55 08             	mov    0x8(%ebp),%edx
  80327f:	89 10                	mov    %edx,(%eax)
  803281:	eb 08                	jmp    80328b <insert_sorted_allocList+0xd7>
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	a3 40 50 80 00       	mov    %eax,0x805040
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	a3 44 50 80 00       	mov    %eax,0x805044
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032a1:	40                   	inc    %eax
  8032a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8032a7:	e9 9d 00 00 00       	jmp    803349 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8032ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032b3:	e9 85 00 00 00       	jmp    80333d <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 50 08             	mov    0x8(%eax),%edx
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 08             	mov    0x8(%eax),%eax
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	73 6a                	jae    803332 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8032c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cc:	74 06                	je     8032d4 <insert_sorted_allocList+0x120>
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 14                	jne    8032e8 <insert_sorted_allocList+0x134>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 94 4d 80 00       	push   $0x804d94
  8032dc:	6a 6b                	push   $0x6b
  8032de:	68 57 4d 80 00       	push   $0x804d57
  8032e3:	e8 c2 df ff ff       	call   8012aa <_panic>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 50 04             	mov    0x4(%eax),%edx
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	89 50 04             	mov    %edx,0x4(%eax)
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 40 04             	mov    0x4(%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	74 0d                	je     803313 <insert_sorted_allocList+0x15f>
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 40 04             	mov    0x4(%eax),%eax
  80330c:	8b 55 08             	mov    0x8(%ebp),%edx
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	eb 08                	jmp    80331b <insert_sorted_allocList+0x167>
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	a3 40 50 80 00       	mov    %eax,0x805040
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 55 08             	mov    0x8(%ebp),%edx
  803321:	89 50 04             	mov    %edx,0x4(%eax)
  803324:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803329:	40                   	inc    %eax
  80332a:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  80332f:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803330:	eb 17                	jmp    803349 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80333a:	ff 45 f0             	incl   -0x10(%ebp)
  80333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803340:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803343:	0f 8c 6f ff ff ff    	jl     8032b8 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803349:	90                   	nop
  80334a:	c9                   	leave  
  80334b:	c3                   	ret    

0080334c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
  80334f:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  803352:	a1 38 51 80 00       	mov    0x805138,%eax
  803357:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80335a:	e9 7c 01 00 00       	jmp    8034db <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 40 0c             	mov    0xc(%eax),%eax
  803365:	3b 45 08             	cmp    0x8(%ebp),%eax
  803368:	0f 86 cf 00 00 00    	jbe    80343d <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80336e:	a1 48 51 80 00       	mov    0x805148,%eax
  803373:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  803376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803379:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 50 08             	mov    0x8(%eax),%edx
  80338b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338e:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 40 0c             	mov    0xc(%eax),%eax
  803397:	2b 45 08             	sub    0x8(%ebp),%eax
  80339a:	89 c2                	mov    %eax,%edx
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	8b 50 08             	mov    0x8(%eax),%edx
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	01 c2                	add    %eax,%edx
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8033b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033b7:	75 17                	jne    8033d0 <alloc_block_FF+0x84>
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	68 c9 4d 80 00       	push   $0x804dc9
  8033c1:	68 83 00 00 00       	push   $0x83
  8033c6:	68 57 4d 80 00       	push   $0x804d57
  8033cb:	e8 da de ff ff       	call   8012aa <_panic>
  8033d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 10                	je     8033e9 <alloc_block_FF+0x9d>
  8033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033e1:	8b 52 04             	mov    0x4(%edx),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 0b                	jmp    8033f4 <alloc_block_FF+0xa8>
  8033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0f                	je     80340d <alloc_block_FF+0xc1>
  8033fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803407:	8b 12                	mov    (%edx),%edx
  803409:	89 10                	mov    %edx,(%eax)
  80340b:	eb 0a                	jmp    803417 <alloc_block_FF+0xcb>
  80340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	a3 48 51 80 00       	mov    %eax,0x805148
  803417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342a:	a1 54 51 80 00       	mov    0x805154,%eax
  80342f:	48                   	dec    %eax
  803430:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  803435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803438:	e9 ad 00 00 00       	jmp    8034ea <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 40 0c             	mov    0xc(%eax),%eax
  803443:	3b 45 08             	cmp    0x8(%ebp),%eax
  803446:	0f 85 87 00 00 00    	jne    8034d3 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80344c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803450:	75 17                	jne    803469 <alloc_block_FF+0x11d>
  803452:	83 ec 04             	sub    $0x4,%esp
  803455:	68 c9 4d 80 00       	push   $0x804dc9
  80345a:	68 87 00 00 00       	push   $0x87
  80345f:	68 57 4d 80 00       	push   $0x804d57
  803464:	e8 41 de ff ff       	call   8012aa <_panic>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	85 c0                	test   %eax,%eax
  803470:	74 10                	je     803482 <alloc_block_FF+0x136>
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	8b 00                	mov    (%eax),%eax
  803477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80347a:	8b 52 04             	mov    0x4(%edx),%edx
  80347d:	89 50 04             	mov    %edx,0x4(%eax)
  803480:	eb 0b                	jmp    80348d <alloc_block_FF+0x141>
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	8b 40 04             	mov    0x4(%eax),%eax
  803488:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	74 0f                	je     8034a6 <alloc_block_FF+0x15a>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034a0:	8b 12                	mov    (%edx),%edx
  8034a2:	89 10                	mov    %edx,(%eax)
  8034a4:	eb 0a                	jmp    8034b0 <alloc_block_FF+0x164>
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	8b 00                	mov    (%eax),%eax
  8034ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c8:	48                   	dec    %eax
  8034c9:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	eb 17                	jmp    8034ea <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8034db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034df:	0f 85 7a fe ff ff    	jne    80335f <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8034e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ea:	c9                   	leave  
  8034eb:	c3                   	ret    

008034ec <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8034ec:	55                   	push   %ebp
  8034ed:	89 e5                	mov    %esp,%ebp
  8034ef:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8034f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8034fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  803501:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  803508:	a1 38 51 80 00       	mov    0x805138,%eax
  80350d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803510:	e9 d0 00 00 00       	jmp    8035e5 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 0c             	mov    0xc(%eax),%eax
  80351b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80351e:	0f 82 b8 00 00 00    	jb     8035dc <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 40 0c             	mov    0xc(%eax),%eax
  80352a:	2b 45 08             	sub    0x8(%ebp),%eax
  80352d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  803530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803533:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803536:	0f 83 a1 00 00 00    	jae    8035dd <alloc_block_BF+0xf1>
				differsize = differance ;
  80353c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  803548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80354c:	0f 85 8b 00 00 00    	jne    8035dd <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  803552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803556:	75 17                	jne    80356f <alloc_block_BF+0x83>
  803558:	83 ec 04             	sub    $0x4,%esp
  80355b:	68 c9 4d 80 00       	push   $0x804dc9
  803560:	68 a0 00 00 00       	push   $0xa0
  803565:	68 57 4d 80 00       	push   $0x804d57
  80356a:	e8 3b dd ff ff       	call   8012aa <_panic>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 10                	je     803588 <alloc_block_BF+0x9c>
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803580:	8b 52 04             	mov    0x4(%edx),%edx
  803583:	89 50 04             	mov    %edx,0x4(%eax)
  803586:	eb 0b                	jmp    803593 <alloc_block_BF+0xa7>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 40 04             	mov    0x4(%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 0f                	je     8035ac <alloc_block_BF+0xc0>
  80359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a0:	8b 40 04             	mov    0x4(%eax),%eax
  8035a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a6:	8b 12                	mov    (%edx),%edx
  8035a8:	89 10                	mov    %edx,(%eax)
  8035aa:	eb 0a                	jmp    8035b6 <alloc_block_BF+0xca>
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ce:	48                   	dec    %eax
  8035cf:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	e9 0c 01 00 00       	jmp    8036e8 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8035dc:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8035dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e9:	74 07                	je     8035f2 <alloc_block_BF+0x106>
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	eb 05                	jmp    8035f7 <alloc_block_BF+0x10b>
  8035f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8035fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	0f 85 0c ff ff ff    	jne    803515 <alloc_block_BF+0x29>
  803609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360d:	0f 85 02 ff ff ff    	jne    803515 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  803613:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803617:	0f 84 c6 00 00 00    	je     8036e3 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80361d:	a1 48 51 80 00       	mov    0x805148,%eax
  803622:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  803625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803628:	8b 55 08             	mov    0x8(%ebp),%edx
  80362b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803631:	8b 50 08             	mov    0x8(%eax),%edx
  803634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803637:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80363a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363d:	8b 40 0c             	mov    0xc(%eax),%eax
  803640:	2b 45 08             	sub    0x8(%ebp),%eax
  803643:	89 c2                	mov    %eax,%edx
  803645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803648:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80364b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364e:	8b 50 08             	mov    0x8(%eax),%edx
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	01 c2                	add    %eax,%edx
  803656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803659:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80365c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803660:	75 17                	jne    803679 <alloc_block_BF+0x18d>
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	68 c9 4d 80 00       	push   $0x804dc9
  80366a:	68 af 00 00 00       	push   $0xaf
  80366f:	68 57 4d 80 00       	push   $0x804d57
  803674:	e8 31 dc ff ff       	call   8012aa <_panic>
  803679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367c:	8b 00                	mov    (%eax),%eax
  80367e:	85 c0                	test   %eax,%eax
  803680:	74 10                	je     803692 <alloc_block_BF+0x1a6>
  803682:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368a:	8b 52 04             	mov    0x4(%edx),%edx
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	eb 0b                	jmp    80369d <alloc_block_BF+0x1b1>
  803692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80369d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a0:	8b 40 04             	mov    0x4(%eax),%eax
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	74 0f                	je     8036b6 <alloc_block_BF+0x1ca>
  8036a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036aa:	8b 40 04             	mov    0x4(%eax),%eax
  8036ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b0:	8b 12                	mov    (%edx),%edx
  8036b2:	89 10                	mov    %edx,(%eax)
  8036b4:	eb 0a                	jmp    8036c0 <alloc_block_BF+0x1d4>
  8036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b9:	8b 00                	mov    (%eax),%eax
  8036bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d8:	48                   	dec    %eax
  8036d9:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	eb 05                	jmp    8036e8 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8036e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e8:	c9                   	leave  
  8036e9:	c3                   	ret    

008036ea <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8036ea:	55                   	push   %ebp
  8036eb:	89 e5                	mov    %esp,%ebp
  8036ed:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8036f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8036f8:	e9 7c 01 00 00       	jmp    803879 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803700:	8b 40 0c             	mov    0xc(%eax),%eax
  803703:	3b 45 08             	cmp    0x8(%ebp),%eax
  803706:	0f 86 cf 00 00 00    	jbe    8037db <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80370c:	a1 48 51 80 00       	mov    0x805148,%eax
  803711:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  803714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803717:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80371a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371d:	8b 55 08             	mov    0x8(%ebp),%edx
  803720:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	8b 50 08             	mov    0x8(%eax),%edx
  803729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372c:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80372f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803732:	8b 40 0c             	mov    0xc(%eax),%eax
  803735:	2b 45 08             	sub    0x8(%ebp),%eax
  803738:	89 c2                	mov    %eax,%edx
  80373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373d:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	8b 50 08             	mov    0x8(%eax),%edx
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	01 c2                	add    %eax,%edx
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803751:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803755:	75 17                	jne    80376e <alloc_block_NF+0x84>
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	68 c9 4d 80 00       	push   $0x804dc9
  80375f:	68 c4 00 00 00       	push   $0xc4
  803764:	68 57 4d 80 00       	push   $0x804d57
  803769:	e8 3c db ff ff       	call   8012aa <_panic>
  80376e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	85 c0                	test   %eax,%eax
  803775:	74 10                	je     803787 <alloc_block_NF+0x9d>
  803777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80377f:	8b 52 04             	mov    0x4(%edx),%edx
  803782:	89 50 04             	mov    %edx,0x4(%eax)
  803785:	eb 0b                	jmp    803792 <alloc_block_NF+0xa8>
  803787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378a:	8b 40 04             	mov    0x4(%eax),%eax
  80378d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 0f                	je     8037ab <alloc_block_NF+0xc1>
  80379c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379f:	8b 40 04             	mov    0x4(%eax),%eax
  8037a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037a5:	8b 12                	mov    (%edx),%edx
  8037a7:	89 10                	mov    %edx,(%eax)
  8037a9:	eb 0a                	jmp    8037b5 <alloc_block_NF+0xcb>
  8037ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8037b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8037cd:	48                   	dec    %eax
  8037ce:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8037d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d6:	e9 ad 00 00 00       	jmp    803888 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e4:	0f 85 87 00 00 00    	jne    803871 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8037ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ee:	75 17                	jne    803807 <alloc_block_NF+0x11d>
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 c9 4d 80 00       	push   $0x804dc9
  8037f8:	68 c8 00 00 00       	push   $0xc8
  8037fd:	68 57 4d 80 00       	push   $0x804d57
  803802:	e8 a3 da ff ff       	call   8012aa <_panic>
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 10                	je     803820 <alloc_block_NF+0x136>
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803818:	8b 52 04             	mov    0x4(%edx),%edx
  80381b:	89 50 04             	mov    %edx,0x4(%eax)
  80381e:	eb 0b                	jmp    80382b <alloc_block_NF+0x141>
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	8b 40 04             	mov    0x4(%eax),%eax
  803826:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80382b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382e:	8b 40 04             	mov    0x4(%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 0f                	je     803844 <alloc_block_NF+0x15a>
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80383e:	8b 12                	mov    (%edx),%edx
  803840:	89 10                	mov    %edx,(%eax)
  803842:	eb 0a                	jmp    80384e <alloc_block_NF+0x164>
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	a3 38 51 80 00       	mov    %eax,0x805138
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803861:	a1 44 51 80 00       	mov    0x805144,%eax
  803866:	48                   	dec    %eax
  803867:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	eb 17                	jmp    803888 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  803871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387d:	0f 85 7a fe ff ff    	jne    8036fd <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803883:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803888:	c9                   	leave  
  803889:	c3                   	ret    

0080388a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80388a:	55                   	push   %ebp
  80388b:	89 e5                	mov    %esp,%ebp
  80388d:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  803890:	a1 38 51 80 00       	mov    0x805138,%eax
  803895:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803898:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80389d:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8038a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8038a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038ac:	75 68                	jne    803916 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8038ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b2:	75 17                	jne    8038cb <insert_sorted_with_merge_freeList+0x41>
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	68 34 4d 80 00       	push   $0x804d34
  8038bc:	68 da 00 00 00       	push   $0xda
  8038c1:	68 57 4d 80 00       	push   $0x804d57
  8038c6:	e8 df d9 ff ff       	call   8012aa <_panic>
  8038cb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d4:	89 10                	mov    %edx,(%eax)
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	74 0d                	je     8038ec <insert_sorted_with_merge_freeList+0x62>
  8038df:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ea:	eb 08                	jmp    8038f4 <insert_sorted_with_merge_freeList+0x6a>
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803906:	a1 44 51 80 00       	mov    0x805144,%eax
  80390b:	40                   	inc    %eax
  80390c:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  803911:	e9 49 07 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803919:	8b 50 08             	mov    0x8(%eax),%edx
  80391c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391f:	8b 40 0c             	mov    0xc(%eax),%eax
  803922:	01 c2                	add    %eax,%edx
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	8b 40 08             	mov    0x8(%eax),%eax
  80392a:	39 c2                	cmp    %eax,%edx
  80392c:	73 77                	jae    8039a5 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	85 c0                	test   %eax,%eax
  803935:	75 6e                	jne    8039a5 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803937:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80393b:	74 68                	je     8039a5 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80393d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803941:	75 17                	jne    80395a <insert_sorted_with_merge_freeList+0xd0>
  803943:	83 ec 04             	sub    $0x4,%esp
  803946:	68 70 4d 80 00       	push   $0x804d70
  80394b:	68 e0 00 00 00       	push   $0xe0
  803950:	68 57 4d 80 00       	push   $0x804d57
  803955:	e8 50 d9 ff ff       	call   8012aa <_panic>
  80395a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	89 50 04             	mov    %edx,0x4(%eax)
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	8b 40 04             	mov    0x4(%eax),%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	74 0c                	je     80397c <insert_sorted_with_merge_freeList+0xf2>
  803970:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803975:	8b 55 08             	mov    0x8(%ebp),%edx
  803978:	89 10                	mov    %edx,(%eax)
  80397a:	eb 08                	jmp    803984 <insert_sorted_with_merge_freeList+0xfa>
  80397c:	8b 45 08             	mov    0x8(%ebp),%eax
  80397f:	a3 38 51 80 00       	mov    %eax,0x805138
  803984:	8b 45 08             	mov    0x8(%ebp),%eax
  803987:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803995:	a1 44 51 80 00       	mov    0x805144,%eax
  80399a:	40                   	inc    %eax
  80399b:	a3 44 51 80 00       	mov    %eax,0x805144
  8039a0:	e9 ba 06 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	8b 40 08             	mov    0x8(%eax),%eax
  8039b1:	01 c2                	add    %eax,%edx
  8039b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b6:	8b 40 08             	mov    0x8(%eax),%eax
  8039b9:	39 c2                	cmp    %eax,%edx
  8039bb:	73 78                	jae    803a35 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	85 c0                	test   %eax,%eax
  8039c5:	75 6e                	jne    803a35 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8039c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039cb:	74 68                	je     803a35 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8039cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d1:	75 17                	jne    8039ea <insert_sorted_with_merge_freeList+0x160>
  8039d3:	83 ec 04             	sub    $0x4,%esp
  8039d6:	68 34 4d 80 00       	push   $0x804d34
  8039db:	68 e6 00 00 00       	push   $0xe6
  8039e0:	68 57 4d 80 00       	push   $0x804d57
  8039e5:	e8 c0 d8 ff ff       	call   8012aa <_panic>
  8039ea:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8039f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f3:	89 10                	mov    %edx,(%eax)
  8039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	74 0d                	je     803a0b <insert_sorted_with_merge_freeList+0x181>
  8039fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803a03:	8b 55 08             	mov    0x8(%ebp),%edx
  803a06:	89 50 04             	mov    %edx,0x4(%eax)
  803a09:	eb 08                	jmp    803a13 <insert_sorted_with_merge_freeList+0x189>
  803a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a13:	8b 45 08             	mov    0x8(%ebp),%eax
  803a16:	a3 38 51 80 00       	mov    %eax,0x805138
  803a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a25:	a1 44 51 80 00       	mov    0x805144,%eax
  803a2a:	40                   	inc    %eax
  803a2b:	a3 44 51 80 00       	mov    %eax,0x805144
  803a30:	e9 2a 06 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803a35:	a1 38 51 80 00       	mov    0x805138,%eax
  803a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a3d:	e9 ed 05 00 00       	jmp    80402f <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803a4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a4e:	0f 84 a7 00 00 00    	je     803afb <insert_sorted_with_merge_freeList+0x271>
  803a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a57:	8b 50 0c             	mov    0xc(%eax),%edx
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	8b 40 08             	mov    0x8(%eax),%eax
  803a60:	01 c2                	add    %eax,%edx
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	8b 40 08             	mov    0x8(%eax),%eax
  803a68:	39 c2                	cmp    %eax,%edx
  803a6a:	0f 83 8b 00 00 00    	jae    803afb <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	8b 50 0c             	mov    0xc(%eax),%edx
  803a76:	8b 45 08             	mov    0x8(%ebp),%eax
  803a79:	8b 40 08             	mov    0x8(%eax),%eax
  803a7c:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a81:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803a84:	39 c2                	cmp    %eax,%edx
  803a86:	73 73                	jae    803afb <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803a88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a8c:	74 06                	je     803a94 <insert_sorted_with_merge_freeList+0x20a>
  803a8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a92:	75 17                	jne    803aab <insert_sorted_with_merge_freeList+0x221>
  803a94:	83 ec 04             	sub    $0x4,%esp
  803a97:	68 e8 4d 80 00       	push   $0x804de8
  803a9c:	68 f0 00 00 00       	push   $0xf0
  803aa1:	68 57 4d 80 00       	push   $0x804d57
  803aa6:	e8 ff d7 ff ff       	call   8012aa <_panic>
  803aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aae:	8b 10                	mov    (%eax),%edx
  803ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab3:	89 10                	mov    %edx,(%eax)
  803ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab8:	8b 00                	mov    (%eax),%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	74 0b                	je     803ac9 <insert_sorted_with_merge_freeList+0x23f>
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac6:	89 50 04             	mov    %edx,0x4(%eax)
  803ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acc:	8b 55 08             	mov    0x8(%ebp),%edx
  803acf:	89 10                	mov    %edx,(%eax)
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ad7:	89 50 04             	mov    %edx,0x4(%eax)
  803ada:	8b 45 08             	mov    0x8(%ebp),%eax
  803add:	8b 00                	mov    (%eax),%eax
  803adf:	85 c0                	test   %eax,%eax
  803ae1:	75 08                	jne    803aeb <insert_sorted_with_merge_freeList+0x261>
  803ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803aeb:	a1 44 51 80 00       	mov    0x805144,%eax
  803af0:	40                   	inc    %eax
  803af1:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803af6:	e9 64 05 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803afb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b00:	8b 50 0c             	mov    0xc(%eax),%edx
  803b03:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b08:	8b 40 08             	mov    0x8(%eax),%eax
  803b0b:	01 c2                	add    %eax,%edx
  803b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b10:	8b 40 08             	mov    0x8(%eax),%eax
  803b13:	39 c2                	cmp    %eax,%edx
  803b15:	0f 85 b1 00 00 00    	jne    803bcc <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803b1b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b20:	85 c0                	test   %eax,%eax
  803b22:	0f 84 a4 00 00 00    	je     803bcc <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803b28:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	0f 85 95 00 00 00    	jne    803bcc <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803b37:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b3c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803b42:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803b45:	8b 55 08             	mov    0x8(%ebp),%edx
  803b48:	8b 52 0c             	mov    0xc(%edx),%edx
  803b4b:	01 ca                	add    %ecx,%edx
  803b4d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803b50:	8b 45 08             	mov    0x8(%ebp),%eax
  803b53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b68:	75 17                	jne    803b81 <insert_sorted_with_merge_freeList+0x2f7>
  803b6a:	83 ec 04             	sub    $0x4,%esp
  803b6d:	68 34 4d 80 00       	push   $0x804d34
  803b72:	68 ff 00 00 00       	push   $0xff
  803b77:	68 57 4d 80 00       	push   $0x804d57
  803b7c:	e8 29 d7 ff ff       	call   8012aa <_panic>
  803b81:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	89 10                	mov    %edx,(%eax)
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	8b 00                	mov    (%eax),%eax
  803b91:	85 c0                	test   %eax,%eax
  803b93:	74 0d                	je     803ba2 <insert_sorted_with_merge_freeList+0x318>
  803b95:	a1 48 51 80 00       	mov    0x805148,%eax
  803b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ba0:	eb 08                	jmp    803baa <insert_sorted_with_merge_freeList+0x320>
  803ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803baa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bad:	a3 48 51 80 00       	mov    %eax,0x805148
  803bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbc:	a1 54 51 80 00       	mov    0x805154,%eax
  803bc1:	40                   	inc    %eax
  803bc2:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803bc7:	e9 93 04 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcf:	8b 50 08             	mov    0x8(%eax),%edx
  803bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd8:	01 c2                	add    %eax,%edx
  803bda:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdd:	8b 40 08             	mov    0x8(%eax),%eax
  803be0:	39 c2                	cmp    %eax,%edx
  803be2:	0f 85 ae 00 00 00    	jne    803c96 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803be8:	8b 45 08             	mov    0x8(%ebp),%eax
  803beb:	8b 50 0c             	mov    0xc(%eax),%edx
  803bee:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf1:	8b 40 08             	mov    0x8(%eax),%eax
  803bf4:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf9:	8b 00                	mov    (%eax),%eax
  803bfb:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803bfe:	39 c2                	cmp    %eax,%edx
  803c00:	0f 84 90 00 00 00    	je     803c96 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c09:	8b 50 0c             	mov    0xc(%eax),%edx
  803c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  803c12:	01 c2                	add    %eax,%edx
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803c24:	8b 45 08             	mov    0x8(%ebp),%eax
  803c27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c32:	75 17                	jne    803c4b <insert_sorted_with_merge_freeList+0x3c1>
  803c34:	83 ec 04             	sub    $0x4,%esp
  803c37:	68 34 4d 80 00       	push   $0x804d34
  803c3c:	68 0b 01 00 00       	push   $0x10b
  803c41:	68 57 4d 80 00       	push   $0x804d57
  803c46:	e8 5f d6 ff ff       	call   8012aa <_panic>
  803c4b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c51:	8b 45 08             	mov    0x8(%ebp),%eax
  803c54:	89 10                	mov    %edx,(%eax)
  803c56:	8b 45 08             	mov    0x8(%ebp),%eax
  803c59:	8b 00                	mov    (%eax),%eax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	74 0d                	je     803c6c <insert_sorted_with_merge_freeList+0x3e2>
  803c5f:	a1 48 51 80 00       	mov    0x805148,%eax
  803c64:	8b 55 08             	mov    0x8(%ebp),%edx
  803c67:	89 50 04             	mov    %edx,0x4(%eax)
  803c6a:	eb 08                	jmp    803c74 <insert_sorted_with_merge_freeList+0x3ea>
  803c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c74:	8b 45 08             	mov    0x8(%ebp),%eax
  803c77:	a3 48 51 80 00       	mov    %eax,0x805148
  803c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c86:	a1 54 51 80 00       	mov    0x805154,%eax
  803c8b:	40                   	inc    %eax
  803c8c:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803c91:	e9 c9 03 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803c96:	8b 45 08             	mov    0x8(%ebp),%eax
  803c99:	8b 50 0c             	mov    0xc(%eax),%edx
  803c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9f:	8b 40 08             	mov    0x8(%eax),%eax
  803ca2:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca7:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803caa:	39 c2                	cmp    %eax,%edx
  803cac:	0f 85 bb 00 00 00    	jne    803d6d <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb6:	0f 84 b1 00 00 00    	je     803d6d <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	8b 40 04             	mov    0x4(%eax),%eax
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	0f 85 a3 00 00 00    	jne    803d6d <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803cca:	a1 38 51 80 00       	mov    0x805138,%eax
  803ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd2:	8b 52 08             	mov    0x8(%edx),%edx
  803cd5:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803cd8:	a1 38 51 80 00       	mov    0x805138,%eax
  803cdd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803ce3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce9:	8b 52 0c             	mov    0xc(%edx),%edx
  803cec:	01 ca                	add    %ecx,%edx
  803cee:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d09:	75 17                	jne    803d22 <insert_sorted_with_merge_freeList+0x498>
  803d0b:	83 ec 04             	sub    $0x4,%esp
  803d0e:	68 34 4d 80 00       	push   $0x804d34
  803d13:	68 17 01 00 00       	push   $0x117
  803d18:	68 57 4d 80 00       	push   $0x804d57
  803d1d:	e8 88 d5 ff ff       	call   8012aa <_panic>
  803d22:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d28:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2b:	89 10                	mov    %edx,(%eax)
  803d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	74 0d                	je     803d43 <insert_sorted_with_merge_freeList+0x4b9>
  803d36:	a1 48 51 80 00       	mov    0x805148,%eax
  803d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d3e:	89 50 04             	mov    %edx,0x4(%eax)
  803d41:	eb 08                	jmp    803d4b <insert_sorted_with_merge_freeList+0x4c1>
  803d43:	8b 45 08             	mov    0x8(%ebp),%eax
  803d46:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4e:	a3 48 51 80 00       	mov    %eax,0x805148
  803d53:	8b 45 08             	mov    0x8(%ebp),%eax
  803d56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d5d:	a1 54 51 80 00       	mov    0x805154,%eax
  803d62:	40                   	inc    %eax
  803d63:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803d68:	e9 f2 02 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d70:	8b 50 08             	mov    0x8(%eax),%edx
  803d73:	8b 45 08             	mov    0x8(%ebp),%eax
  803d76:	8b 40 0c             	mov    0xc(%eax),%eax
  803d79:	01 c2                	add    %eax,%edx
  803d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7e:	8b 40 08             	mov    0x8(%eax),%eax
  803d81:	39 c2                	cmp    %eax,%edx
  803d83:	0f 85 be 00 00 00    	jne    803e47 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8c:	8b 40 04             	mov    0x4(%eax),%eax
  803d8f:	8b 50 08             	mov    0x8(%eax),%edx
  803d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d95:	8b 40 04             	mov    0x4(%eax),%eax
  803d98:	8b 40 0c             	mov    0xc(%eax),%eax
  803d9b:	01 c2                	add    %eax,%edx
  803d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803da0:	8b 40 08             	mov    0x8(%eax),%eax
  803da3:	39 c2                	cmp    %eax,%edx
  803da5:	0f 84 9c 00 00 00    	je     803e47 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803dab:	8b 45 08             	mov    0x8(%ebp),%eax
  803dae:	8b 50 08             	mov    0x8(%eax),%edx
  803db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db4:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dba:	8b 50 0c             	mov    0xc(%eax),%edx
  803dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  803dc3:	01 c2                	add    %eax,%edx
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803ddf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803de3:	75 17                	jne    803dfc <insert_sorted_with_merge_freeList+0x572>
  803de5:	83 ec 04             	sub    $0x4,%esp
  803de8:	68 34 4d 80 00       	push   $0x804d34
  803ded:	68 26 01 00 00       	push   $0x126
  803df2:	68 57 4d 80 00       	push   $0x804d57
  803df7:	e8 ae d4 ff ff       	call   8012aa <_panic>
  803dfc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e02:	8b 45 08             	mov    0x8(%ebp),%eax
  803e05:	89 10                	mov    %edx,(%eax)
  803e07:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0a:	8b 00                	mov    (%eax),%eax
  803e0c:	85 c0                	test   %eax,%eax
  803e0e:	74 0d                	je     803e1d <insert_sorted_with_merge_freeList+0x593>
  803e10:	a1 48 51 80 00       	mov    0x805148,%eax
  803e15:	8b 55 08             	mov    0x8(%ebp),%edx
  803e18:	89 50 04             	mov    %edx,0x4(%eax)
  803e1b:	eb 08                	jmp    803e25 <insert_sorted_with_merge_freeList+0x59b>
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e25:	8b 45 08             	mov    0x8(%ebp),%eax
  803e28:	a3 48 51 80 00       	mov    %eax,0x805148
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e37:	a1 54 51 80 00       	mov    0x805154,%eax
  803e3c:	40                   	inc    %eax
  803e3d:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803e42:	e9 18 02 00 00       	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4a:	8b 50 0c             	mov    0xc(%eax),%edx
  803e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e50:	8b 40 08             	mov    0x8(%eax),%eax
  803e53:	01 c2                	add    %eax,%edx
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	8b 40 08             	mov    0x8(%eax),%eax
  803e5b:	39 c2                	cmp    %eax,%edx
  803e5d:	0f 85 c4 01 00 00    	jne    804027 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803e63:	8b 45 08             	mov    0x8(%ebp),%eax
  803e66:	8b 50 0c             	mov    0xc(%eax),%edx
  803e69:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6c:	8b 40 08             	mov    0x8(%eax),%eax
  803e6f:	01 c2                	add    %eax,%edx
  803e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	8b 40 08             	mov    0x8(%eax),%eax
  803e79:	39 c2                	cmp    %eax,%edx
  803e7b:	0f 85 a6 01 00 00    	jne    804027 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e85:	0f 84 9c 01 00 00    	je     804027 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8e:	8b 50 0c             	mov    0xc(%eax),%edx
  803e91:	8b 45 08             	mov    0x8(%ebp),%eax
  803e94:	8b 40 0c             	mov    0xc(%eax),%eax
  803e97:	01 c2                	add    %eax,%edx
  803e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9c:	8b 00                	mov    (%eax),%eax
  803e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  803ea1:	01 c2                	add    %eax,%edx
  803ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea6:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ec1:	75 17                	jne    803eda <insert_sorted_with_merge_freeList+0x650>
  803ec3:	83 ec 04             	sub    $0x4,%esp
  803ec6:	68 34 4d 80 00       	push   $0x804d34
  803ecb:	68 32 01 00 00       	push   $0x132
  803ed0:	68 57 4d 80 00       	push   $0x804d57
  803ed5:	e8 d0 d3 ff ff       	call   8012aa <_panic>
  803eda:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee3:	89 10                	mov    %edx,(%eax)
  803ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee8:	8b 00                	mov    (%eax),%eax
  803eea:	85 c0                	test   %eax,%eax
  803eec:	74 0d                	je     803efb <insert_sorted_with_merge_freeList+0x671>
  803eee:	a1 48 51 80 00       	mov    0x805148,%eax
  803ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ef6:	89 50 04             	mov    %edx,0x4(%eax)
  803ef9:	eb 08                	jmp    803f03 <insert_sorted_with_merge_freeList+0x679>
  803efb:	8b 45 08             	mov    0x8(%ebp),%eax
  803efe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f03:	8b 45 08             	mov    0x8(%ebp),%eax
  803f06:	a3 48 51 80 00       	mov    %eax,0x805148
  803f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f15:	a1 54 51 80 00       	mov    0x805154,%eax
  803f1a:	40                   	inc    %eax
  803f1b:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f23:	8b 00                	mov    (%eax),%eax
  803f25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2f:	8b 00                	mov    (%eax),%eax
  803f31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f44:	75 17                	jne    803f5d <insert_sorted_with_merge_freeList+0x6d3>
  803f46:	83 ec 04             	sub    $0x4,%esp
  803f49:	68 c9 4d 80 00       	push   $0x804dc9
  803f4e:	68 36 01 00 00       	push   $0x136
  803f53:	68 57 4d 80 00       	push   $0x804d57
  803f58:	e8 4d d3 ff ff       	call   8012aa <_panic>
  803f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f60:	8b 00                	mov    (%eax),%eax
  803f62:	85 c0                	test   %eax,%eax
  803f64:	74 10                	je     803f76 <insert_sorted_with_merge_freeList+0x6ec>
  803f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f69:	8b 00                	mov    (%eax),%eax
  803f6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f6e:	8b 52 04             	mov    0x4(%edx),%edx
  803f71:	89 50 04             	mov    %edx,0x4(%eax)
  803f74:	eb 0b                	jmp    803f81 <insert_sorted_with_merge_freeList+0x6f7>
  803f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f79:	8b 40 04             	mov    0x4(%eax),%eax
  803f7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f84:	8b 40 04             	mov    0x4(%eax),%eax
  803f87:	85 c0                	test   %eax,%eax
  803f89:	74 0f                	je     803f9a <insert_sorted_with_merge_freeList+0x710>
  803f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8e:	8b 40 04             	mov    0x4(%eax),%eax
  803f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f94:	8b 12                	mov    (%edx),%edx
  803f96:	89 10                	mov    %edx,(%eax)
  803f98:	eb 0a                	jmp    803fa4 <insert_sorted_with_merge_freeList+0x71a>
  803f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9d:	8b 00                	mov    (%eax),%eax
  803f9f:	a3 38 51 80 00       	mov    %eax,0x805138
  803fa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fb7:	a1 44 51 80 00       	mov    0x805144,%eax
  803fbc:	48                   	dec    %eax
  803fbd:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fc6:	75 17                	jne    803fdf <insert_sorted_with_merge_freeList+0x755>
  803fc8:	83 ec 04             	sub    $0x4,%esp
  803fcb:	68 34 4d 80 00       	push   $0x804d34
  803fd0:	68 37 01 00 00       	push   $0x137
  803fd5:	68 57 4d 80 00       	push   $0x804d57
  803fda:	e8 cb d2 ff ff       	call   8012aa <_panic>
  803fdf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe8:	89 10                	mov    %edx,(%eax)
  803fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fed:	8b 00                	mov    (%eax),%eax
  803fef:	85 c0                	test   %eax,%eax
  803ff1:	74 0d                	je     804000 <insert_sorted_with_merge_freeList+0x776>
  803ff3:	a1 48 51 80 00       	mov    0x805148,%eax
  803ff8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ffb:	89 50 04             	mov    %edx,0x4(%eax)
  803ffe:	eb 08                	jmp    804008 <insert_sorted_with_merge_freeList+0x77e>
  804000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804003:	a3 4c 51 80 00       	mov    %eax,0x80514c
  804008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400b:	a3 48 51 80 00       	mov    %eax,0x805148
  804010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804013:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80401a:	a1 54 51 80 00       	mov    0x805154,%eax
  80401f:	40                   	inc    %eax
  804020:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  804025:	eb 38                	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  804027:	a1 40 51 80 00       	mov    0x805140,%eax
  80402c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80402f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804033:	74 07                	je     80403c <insert_sorted_with_merge_freeList+0x7b2>
  804035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804038:	8b 00                	mov    (%eax),%eax
  80403a:	eb 05                	jmp    804041 <insert_sorted_with_merge_freeList+0x7b7>
  80403c:	b8 00 00 00 00       	mov    $0x0,%eax
  804041:	a3 40 51 80 00       	mov    %eax,0x805140
  804046:	a1 40 51 80 00       	mov    0x805140,%eax
  80404b:	85 c0                	test   %eax,%eax
  80404d:	0f 85 ef f9 ff ff    	jne    803a42 <insert_sorted_with_merge_freeList+0x1b8>
  804053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804057:	0f 85 e5 f9 ff ff    	jne    803a42 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80405d:	eb 00                	jmp    80405f <insert_sorted_with_merge_freeList+0x7d5>
  80405f:	90                   	nop
  804060:	c9                   	leave  
  804061:	c3                   	ret    
  804062:	66 90                	xchg   %ax,%ax

00804064 <__udivdi3>:
  804064:	55                   	push   %ebp
  804065:	57                   	push   %edi
  804066:	56                   	push   %esi
  804067:	53                   	push   %ebx
  804068:	83 ec 1c             	sub    $0x1c,%esp
  80406b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80406f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804077:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80407b:	89 ca                	mov    %ecx,%edx
  80407d:	89 f8                	mov    %edi,%eax
  80407f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804083:	85 f6                	test   %esi,%esi
  804085:	75 2d                	jne    8040b4 <__udivdi3+0x50>
  804087:	39 cf                	cmp    %ecx,%edi
  804089:	77 65                	ja     8040f0 <__udivdi3+0x8c>
  80408b:	89 fd                	mov    %edi,%ebp
  80408d:	85 ff                	test   %edi,%edi
  80408f:	75 0b                	jne    80409c <__udivdi3+0x38>
  804091:	b8 01 00 00 00       	mov    $0x1,%eax
  804096:	31 d2                	xor    %edx,%edx
  804098:	f7 f7                	div    %edi
  80409a:	89 c5                	mov    %eax,%ebp
  80409c:	31 d2                	xor    %edx,%edx
  80409e:	89 c8                	mov    %ecx,%eax
  8040a0:	f7 f5                	div    %ebp
  8040a2:	89 c1                	mov    %eax,%ecx
  8040a4:	89 d8                	mov    %ebx,%eax
  8040a6:	f7 f5                	div    %ebp
  8040a8:	89 cf                	mov    %ecx,%edi
  8040aa:	89 fa                	mov    %edi,%edx
  8040ac:	83 c4 1c             	add    $0x1c,%esp
  8040af:	5b                   	pop    %ebx
  8040b0:	5e                   	pop    %esi
  8040b1:	5f                   	pop    %edi
  8040b2:	5d                   	pop    %ebp
  8040b3:	c3                   	ret    
  8040b4:	39 ce                	cmp    %ecx,%esi
  8040b6:	77 28                	ja     8040e0 <__udivdi3+0x7c>
  8040b8:	0f bd fe             	bsr    %esi,%edi
  8040bb:	83 f7 1f             	xor    $0x1f,%edi
  8040be:	75 40                	jne    804100 <__udivdi3+0x9c>
  8040c0:	39 ce                	cmp    %ecx,%esi
  8040c2:	72 0a                	jb     8040ce <__udivdi3+0x6a>
  8040c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040c8:	0f 87 9e 00 00 00    	ja     80416c <__udivdi3+0x108>
  8040ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d3:	89 fa                	mov    %edi,%edx
  8040d5:	83 c4 1c             	add    $0x1c,%esp
  8040d8:	5b                   	pop    %ebx
  8040d9:	5e                   	pop    %esi
  8040da:	5f                   	pop    %edi
  8040db:	5d                   	pop    %ebp
  8040dc:	c3                   	ret    
  8040dd:	8d 76 00             	lea    0x0(%esi),%esi
  8040e0:	31 ff                	xor    %edi,%edi
  8040e2:	31 c0                	xor    %eax,%eax
  8040e4:	89 fa                	mov    %edi,%edx
  8040e6:	83 c4 1c             	add    $0x1c,%esp
  8040e9:	5b                   	pop    %ebx
  8040ea:	5e                   	pop    %esi
  8040eb:	5f                   	pop    %edi
  8040ec:	5d                   	pop    %ebp
  8040ed:	c3                   	ret    
  8040ee:	66 90                	xchg   %ax,%ax
  8040f0:	89 d8                	mov    %ebx,%eax
  8040f2:	f7 f7                	div    %edi
  8040f4:	31 ff                	xor    %edi,%edi
  8040f6:	89 fa                	mov    %edi,%edx
  8040f8:	83 c4 1c             	add    $0x1c,%esp
  8040fb:	5b                   	pop    %ebx
  8040fc:	5e                   	pop    %esi
  8040fd:	5f                   	pop    %edi
  8040fe:	5d                   	pop    %ebp
  8040ff:	c3                   	ret    
  804100:	bd 20 00 00 00       	mov    $0x20,%ebp
  804105:	89 eb                	mov    %ebp,%ebx
  804107:	29 fb                	sub    %edi,%ebx
  804109:	89 f9                	mov    %edi,%ecx
  80410b:	d3 e6                	shl    %cl,%esi
  80410d:	89 c5                	mov    %eax,%ebp
  80410f:	88 d9                	mov    %bl,%cl
  804111:	d3 ed                	shr    %cl,%ebp
  804113:	89 e9                	mov    %ebp,%ecx
  804115:	09 f1                	or     %esi,%ecx
  804117:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80411b:	89 f9                	mov    %edi,%ecx
  80411d:	d3 e0                	shl    %cl,%eax
  80411f:	89 c5                	mov    %eax,%ebp
  804121:	89 d6                	mov    %edx,%esi
  804123:	88 d9                	mov    %bl,%cl
  804125:	d3 ee                	shr    %cl,%esi
  804127:	89 f9                	mov    %edi,%ecx
  804129:	d3 e2                	shl    %cl,%edx
  80412b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80412f:	88 d9                	mov    %bl,%cl
  804131:	d3 e8                	shr    %cl,%eax
  804133:	09 c2                	or     %eax,%edx
  804135:	89 d0                	mov    %edx,%eax
  804137:	89 f2                	mov    %esi,%edx
  804139:	f7 74 24 0c          	divl   0xc(%esp)
  80413d:	89 d6                	mov    %edx,%esi
  80413f:	89 c3                	mov    %eax,%ebx
  804141:	f7 e5                	mul    %ebp
  804143:	39 d6                	cmp    %edx,%esi
  804145:	72 19                	jb     804160 <__udivdi3+0xfc>
  804147:	74 0b                	je     804154 <__udivdi3+0xf0>
  804149:	89 d8                	mov    %ebx,%eax
  80414b:	31 ff                	xor    %edi,%edi
  80414d:	e9 58 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  804152:	66 90                	xchg   %ax,%ax
  804154:	8b 54 24 08          	mov    0x8(%esp),%edx
  804158:	89 f9                	mov    %edi,%ecx
  80415a:	d3 e2                	shl    %cl,%edx
  80415c:	39 c2                	cmp    %eax,%edx
  80415e:	73 e9                	jae    804149 <__udivdi3+0xe5>
  804160:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804163:	31 ff                	xor    %edi,%edi
  804165:	e9 40 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  80416a:	66 90                	xchg   %ax,%ax
  80416c:	31 c0                	xor    %eax,%eax
  80416e:	e9 37 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  804173:	90                   	nop

00804174 <__umoddi3>:
  804174:	55                   	push   %ebp
  804175:	57                   	push   %edi
  804176:	56                   	push   %esi
  804177:	53                   	push   %ebx
  804178:	83 ec 1c             	sub    $0x1c,%esp
  80417b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80417f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804187:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80418b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80418f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804193:	89 f3                	mov    %esi,%ebx
  804195:	89 fa                	mov    %edi,%edx
  804197:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80419b:	89 34 24             	mov    %esi,(%esp)
  80419e:	85 c0                	test   %eax,%eax
  8041a0:	75 1a                	jne    8041bc <__umoddi3+0x48>
  8041a2:	39 f7                	cmp    %esi,%edi
  8041a4:	0f 86 a2 00 00 00    	jbe    80424c <__umoddi3+0xd8>
  8041aa:	89 c8                	mov    %ecx,%eax
  8041ac:	89 f2                	mov    %esi,%edx
  8041ae:	f7 f7                	div    %edi
  8041b0:	89 d0                	mov    %edx,%eax
  8041b2:	31 d2                	xor    %edx,%edx
  8041b4:	83 c4 1c             	add    $0x1c,%esp
  8041b7:	5b                   	pop    %ebx
  8041b8:	5e                   	pop    %esi
  8041b9:	5f                   	pop    %edi
  8041ba:	5d                   	pop    %ebp
  8041bb:	c3                   	ret    
  8041bc:	39 f0                	cmp    %esi,%eax
  8041be:	0f 87 ac 00 00 00    	ja     804270 <__umoddi3+0xfc>
  8041c4:	0f bd e8             	bsr    %eax,%ebp
  8041c7:	83 f5 1f             	xor    $0x1f,%ebp
  8041ca:	0f 84 ac 00 00 00    	je     80427c <__umoddi3+0x108>
  8041d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8041d5:	29 ef                	sub    %ebp,%edi
  8041d7:	89 fe                	mov    %edi,%esi
  8041d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041dd:	89 e9                	mov    %ebp,%ecx
  8041df:	d3 e0                	shl    %cl,%eax
  8041e1:	89 d7                	mov    %edx,%edi
  8041e3:	89 f1                	mov    %esi,%ecx
  8041e5:	d3 ef                	shr    %cl,%edi
  8041e7:	09 c7                	or     %eax,%edi
  8041e9:	89 e9                	mov    %ebp,%ecx
  8041eb:	d3 e2                	shl    %cl,%edx
  8041ed:	89 14 24             	mov    %edx,(%esp)
  8041f0:	89 d8                	mov    %ebx,%eax
  8041f2:	d3 e0                	shl    %cl,%eax
  8041f4:	89 c2                	mov    %eax,%edx
  8041f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041fa:	d3 e0                	shl    %cl,%eax
  8041fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804200:	8b 44 24 08          	mov    0x8(%esp),%eax
  804204:	89 f1                	mov    %esi,%ecx
  804206:	d3 e8                	shr    %cl,%eax
  804208:	09 d0                	or     %edx,%eax
  80420a:	d3 eb                	shr    %cl,%ebx
  80420c:	89 da                	mov    %ebx,%edx
  80420e:	f7 f7                	div    %edi
  804210:	89 d3                	mov    %edx,%ebx
  804212:	f7 24 24             	mull   (%esp)
  804215:	89 c6                	mov    %eax,%esi
  804217:	89 d1                	mov    %edx,%ecx
  804219:	39 d3                	cmp    %edx,%ebx
  80421b:	0f 82 87 00 00 00    	jb     8042a8 <__umoddi3+0x134>
  804221:	0f 84 91 00 00 00    	je     8042b8 <__umoddi3+0x144>
  804227:	8b 54 24 04          	mov    0x4(%esp),%edx
  80422b:	29 f2                	sub    %esi,%edx
  80422d:	19 cb                	sbb    %ecx,%ebx
  80422f:	89 d8                	mov    %ebx,%eax
  804231:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804235:	d3 e0                	shl    %cl,%eax
  804237:	89 e9                	mov    %ebp,%ecx
  804239:	d3 ea                	shr    %cl,%edx
  80423b:	09 d0                	or     %edx,%eax
  80423d:	89 e9                	mov    %ebp,%ecx
  80423f:	d3 eb                	shr    %cl,%ebx
  804241:	89 da                	mov    %ebx,%edx
  804243:	83 c4 1c             	add    $0x1c,%esp
  804246:	5b                   	pop    %ebx
  804247:	5e                   	pop    %esi
  804248:	5f                   	pop    %edi
  804249:	5d                   	pop    %ebp
  80424a:	c3                   	ret    
  80424b:	90                   	nop
  80424c:	89 fd                	mov    %edi,%ebp
  80424e:	85 ff                	test   %edi,%edi
  804250:	75 0b                	jne    80425d <__umoddi3+0xe9>
  804252:	b8 01 00 00 00       	mov    $0x1,%eax
  804257:	31 d2                	xor    %edx,%edx
  804259:	f7 f7                	div    %edi
  80425b:	89 c5                	mov    %eax,%ebp
  80425d:	89 f0                	mov    %esi,%eax
  80425f:	31 d2                	xor    %edx,%edx
  804261:	f7 f5                	div    %ebp
  804263:	89 c8                	mov    %ecx,%eax
  804265:	f7 f5                	div    %ebp
  804267:	89 d0                	mov    %edx,%eax
  804269:	e9 44 ff ff ff       	jmp    8041b2 <__umoddi3+0x3e>
  80426e:	66 90                	xchg   %ax,%ax
  804270:	89 c8                	mov    %ecx,%eax
  804272:	89 f2                	mov    %esi,%edx
  804274:	83 c4 1c             	add    $0x1c,%esp
  804277:	5b                   	pop    %ebx
  804278:	5e                   	pop    %esi
  804279:	5f                   	pop    %edi
  80427a:	5d                   	pop    %ebp
  80427b:	c3                   	ret    
  80427c:	3b 04 24             	cmp    (%esp),%eax
  80427f:	72 06                	jb     804287 <__umoddi3+0x113>
  804281:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804285:	77 0f                	ja     804296 <__umoddi3+0x122>
  804287:	89 f2                	mov    %esi,%edx
  804289:	29 f9                	sub    %edi,%ecx
  80428b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80428f:	89 14 24             	mov    %edx,(%esp)
  804292:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804296:	8b 44 24 04          	mov    0x4(%esp),%eax
  80429a:	8b 14 24             	mov    (%esp),%edx
  80429d:	83 c4 1c             	add    $0x1c,%esp
  8042a0:	5b                   	pop    %ebx
  8042a1:	5e                   	pop    %esi
  8042a2:	5f                   	pop    %edi
  8042a3:	5d                   	pop    %ebp
  8042a4:	c3                   	ret    
  8042a5:	8d 76 00             	lea    0x0(%esi),%esi
  8042a8:	2b 04 24             	sub    (%esp),%eax
  8042ab:	19 fa                	sbb    %edi,%edx
  8042ad:	89 d1                	mov    %edx,%ecx
  8042af:	89 c6                	mov    %eax,%esi
  8042b1:	e9 71 ff ff ff       	jmp    804227 <__umoddi3+0xb3>
  8042b6:	66 90                	xchg   %ax,%ax
  8042b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042bc:	72 ea                	jb     8042a8 <__umoddi3+0x134>
  8042be:	89 d9                	mov    %ebx,%ecx
  8042c0:	e9 62 ff ff ff       	jmp    804227 <__umoddi3+0xb3>
